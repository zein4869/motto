import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget { const MyApp({super.key});

@override Widget build(BuildContext context) { return MaterialApp( debugShowCheckedModeBanner: false, home: const ThreePartsPage(), ); } }

class ThreePartsPage extends StatefulWidget { const ThreePartsPage({super.key});

@override State<ThreePartsPage> createState() => _ThreePartsPageState(); }

class _ThreePartsPageState extends State<ThreePartsPage> { final TextEditingController _controller = TextEditingController(); final ScrollController _selectableScroll = ScrollController();

@override void dispose() { _controller.dispose(); _selectableScroll.dispose(); super.dispose(); }

@override Widget build(BuildContext context) { return Scaffold( appBar: AppBar(title: const Text('3 thành phần (TextField, IconButton, Selectable)')), // We use a Stack so we can have two Expanded halves (Column) and // place the IconButton visually between them (center overlay). body: Stack( children: [ Column( children: [ // Top half: TextField that does NOT grow in height when typing. // Setting expands: true + maxLines: null makes the TextField fill // its parent's height and perform internal scrolling instead of // expanding. Expanded( child: Container( padding: const EdgeInsets.all(12), color: Colors.grey.shade100, child: Card( child: Padding( padding: const EdgeInsets.all(8.0), child: TextField( controller: _controller, keyboardType: TextInputType.multiline, maxLines: null, expands: true, // IMPORTANT: keeps the TextField at fixed height decoration: const InputDecoration( border: InputBorder.none, hintText: 'Gõ vào đây — nội dung sẽ cuộn trong vùng này', ), ), ), ), ), ),

// Bottom half: a container with selectable text that scrolls.
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              child: Card(
                child: Scrollbar(
                  controller: _selectableScroll,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _selectableScroll,
                    padding: const EdgeInsets.all(12),
                    child: const SelectableText(
                      'Đây là vùng SelectableText. Nếu nội dung nhiều hơn vùng hiển thị, nó sẽ cuộn lại bên trong vùng này mà không làm thay đổi kích thước container.\n\nThêm nhiều dòng ở đây để thử cuộn.\n\n- Dòng 1\n- Dòng 2\n- Dòng 3\n- ...',
                      showCursor: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Centered IconButton placed between the two halves. It doesn't resize
      // the halves because it's rendered on top (overlay).
      // If you truly need the IconButton to be inside the Column and take
      // space (which would change the half sizes), you can place it as a
      // middle child instead of overlay.
      Align(
        alignment: Alignment.center,
        child: Material(
          // Use Material so the button has ripple even over the stack.
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                ),
              ],
            ),
            child: IconButton(
              iconSize: 36,
              onPressed: () {
                // example action: copy top text into bottom selectable region
                final text = _controller.text.isEmpty
                    ? 'Chưa có nội dung ở TextField.'
                    : _controller.text;
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: SelectableText(text),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.swap_vert),
            ),
          ),
        ),
      ),
    ],
  ),
);

} }
