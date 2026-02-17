import 'package:flutter/material.dart';

void main() {
  runApp(const QrCollectionApp());
}

class QrCollectionApp extends StatelessWidget {
  const QrCollectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const QrCollectionPage(),
    );
  }
}

class QrCollectionPage extends StatefulWidget {
  const QrCollectionPage({super.key});

  @override
  State<QrCollectionPage> createState() => _QrCollectionPageState();
}

class _QrCollectionPageState extends State<QrCollectionPage> {
  final TextEditingController _controller = TextEditingController();

  final Map<String, String> _knownCodes = {
    '001':
        'https://via.placeholder.com/300x200/FF69B4/FFFFFF?text=Flower',
  };

  final List<String> _collectedCodes = [];

  String? _message;
  String? _lastCollectedImage;

  void _collectCode() {
    final code = _controller.text.trim();

    setState(() {
      if (_collectedCodes.contains(code)) {
        _message = 'Ez a QR-kód már be lett gyűjtve';
        _lastCollectedImage = _knownCodes[code];
      } else if (_knownCodes.containsKey(code)) {
        _collectedCodes.add(code);
        _message = 'Sikeres gyűjtés: $code';
        _lastCollectedImage = _knownCodes[code];
      } else {
        _message = 'Hibás kód';
        _lastCollectedImage = null;
      }
    });

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Gyűjtő Demo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'QR-kód (pl. 001)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _collectCode(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _collectCode,
              child: const Text('Gyűjtés'),
            ),
            const SizedBox(height: 12),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: _message == 'Hibás kód'
                      ? Colors.redAccent
                      : Colors.greenAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 12),
            if (_lastCollectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _lastCollectedImage!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'Begyűjtött elemek',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _collectedCodes.isEmpty
                  ? const Center(child: Text('Még nincs begyűjtött QR-kód.'))
                  : ListView.builder(
                      itemCount: _collectedCodes.length,
                      itemBuilder: (context, index) {
                        final code = _collectedCodes[index];
                        final imageUrl = _knownCodes[code]!;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            leading: Image.network(
                              imageUrl,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                            title: Text('Kód: $code'),
                            subtitle: const Text('Virág kép'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
