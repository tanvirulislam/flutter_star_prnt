import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_star_prnt/flutter_star_prnt.dart';
import 'dart:ui' as ui;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey _globalKey = new GlobalKey();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e);
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(
          children: <Widget>[
            TextButton(
              onPressed: () async {
                List<PortInfo> list =
                    await StarPrnt.portDiscovery(StarPortType.All);
                print(list);
                list.forEach((port) async {
                  print(port.portName);
                  if (port.portName.isNotEmpty) {
                    print(await StarPrnt.checkStatus(
                      portName: port.portName,
                      emulation: 'StarGraphic',
                    ));

                    PrintCommands commands = PrintCommands();
                    Map<String, dynamic> rasterMap = {
                      'appendBitmapText': "        Star Clothing Boutique\n" +
                          "             123 Star Road\n" +
                          "           City, State 12345\n" +
                          "\n" +
                          "Date:MM/DD/YYYY          Time:HH:MM PM\n" +
                          "--------------------------------------\n" +
                          "SALE\n" +
                          "SKU            Description       Total\n" +
                          "300678566      PLAIN T-SHIRT     10.99\n" +
                          "300692003      BLACK DENIM       29.99\n" +
                          "300651148      BLUE DENIM        29.99\n" +
                          "300642980      STRIPED DRESS     49.99\n" +
                          "30063847       BLACK BOOTS       35.99\n" +
                          "\n" +
                          "Subtotal                        156.95\n" +
                          "Tax                               0.00\n" +
                          "--------------------------------------\n" +
                          "Total                           156.95\n" +
                          "--------------------------------------\n" +
                          "\n" +
                          "Charge\n" +
                          "156.95\n" +
                          "Visa XXXX-XXXX-XXXX-0123\n" +
                          "Refunds and Exchanges\n" +
                          "Within 30 days with receipt\n" +
                          "And tags attached\n",
                    };
                    commands.push(rasterMap);
                    print(await StarPrnt.print(
                        portName: port.portName,
                        emulation: 'StarGraphic',
                        printCommands: commands));
                  }
                });
              },
              child: Text('Print from text'),
            ),
            TextButton(
              onPressed: () async {
                //FilePickerResult file = await FilePicker.platform.pickFiles();
                List<PortInfo> list =
                    await StarPrnt.portDiscovery(StarPortType.All);
                print(list);
                list.forEach((port) async {
                  print(port.portName);
                  if (port.portName.isNotEmpty) {
                    print(await StarPrnt.checkStatus(
                      portName: port.portName,
                      emulation: 'StarGraphic',
                    ));

                    PrintCommands commands = PrintCommands();
                    Map<String, dynamic> rasterMap = {
                      'appendBitmap':
                          'https://c8.alamy.com/comp/MPCNP1/camera-logo-design-photograph-logo-vector-icons-MPCNP1.jpg'
                    };
                    commands.push(rasterMap);
                    print(await StarPrnt.print(
                        portName: port.portName,
                        emulation: 'StarGraphic',
                        printCommands: commands));
                  }
                });
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('Print from url'),
            ),
            SizedBox(
              width: 576, // 3'' only
              child: RepaintBoundary(
                key: _globalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('This is a text to print as image , for 3\''),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final img = await _capturePng();
                setState(() {
                  isLoading = true;
                });
                //FilePickerResult file = await FilePicker.platform.pickFiles();
                List<PortInfo> list =
                    await StarPrnt.portDiscovery(StarPortType.All);
                print(list);

                list.forEach((port) async {
                  print(port.portName);
                  if (port.portName.isNotEmpty) {
                    print(await StarPrnt.checkStatus(
                      portName: port.portName,
                      emulation: 'StarGraphic',
                    ));

                    PrintCommands commands = PrintCommands();
                    commands.push({'appendBitmapImg': img});

                    commands.push({'diffusion': true});
                    commands.push({'width': 576});
                    commands.push({'bothScale': true});
                    commands
                        .push({'alignment': StarAlignmentPosition.Left.text});
                    print(await StarPrnt.print(
                        portName: port.portName,
                        emulation: 'StarGraphic',
                        printCommands: commands));
                  }
                });
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('Print from genrated image'),
            ),
          ],
        ),
      ),
    );
  }
}
