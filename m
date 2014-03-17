Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaCQWAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:00:06 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59299 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaCQWAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:00:01 -0400
From: Teodora Baluta <teobaluta@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: peter.p.waskiewicz.jr@intel.com, Teodora Baluta <teobaluta@gmail.com>
Subject: [RFC] QR encoding for Oops messages
Date: Mon, 17 Mar 2014 14:59:47 -0700
Message-Id: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature encodes Oops messages into a QR barcode that is scannable by
any device with a camera.

If the config option for this feature is enabled, then when an Oops is
in progress, the printk() calls' strings are buffered. When the Oops
finishes, the buffer is compressed, encoded into a QR and then displayed
to frame buffer. The compression is done with zlib from lib/.

Current issues:
 * the QR code is sometimes displayed on top of the console text,
   sometimes under it, thus making it unscannable
 * the compression rate could be better than what zlib offers
 * not tested for Oops messages issued from several CPUs

As far as decoding is concerned, there are a lot of apps on mobile devices
that decode QR codes (just text mostly). In order to make this work, an
app which also decodes the QR code is needed. I will be working the next
couple of weeks on an Android app which scans the Oops encoding QR and
sends it to a server which keeps track of these Oopses that are sent to
it making a sort of stream of the latest Oopses. Any thoughts on what the best
workflow would be are more than welcomed.

Also, if there are any suggestions on how to solve some of the issues,
they are more than welcomed.

Signed-off-by: Teodora Baluta <teobaluta@gmail.com>
---
 include/linux/print_oops.h |   11 +
 include/linux/qrencode.h   |  546 +++++++++++++
 kernel/Makefile            |    1 +
 kernel/panic.c             |    5 +
 kernel/print_oops.c        |  173 +++++
 kernel/printk/printk.c     |    9 +-
 lib/Kconfig                |    5 +
 lib/Kconfig.debug          |   11 +
 lib/Makefile               |    3 +
 lib/qr/Makefile            |    6 +
 lib/qr/bitstream.c         |  233 ++++++
 lib/qr/bitstream.h         |   37 +
 lib/qr/mask.c              |  320 ++++++++
 lib/qr/mask.h              |   39 +
 lib/qr/mmask.c             |  175 +++++
 lib/qr/mmask.h             |   36 +
 lib/qr/mqrspec.c           |  259 +++++++
 lib/qr/mqrspec.h           |  155 ++++
 lib/qr/qrencode.c          |  871 +++++++++++++++++++++
 lib/qr/qrencode.h          |  546 +++++++++++++
 lib/qr/qrinput.c           | 1834 ++++++++++++++++++++++++++++++++++++++++++++
 lib/qr/qrinput.h           |  129 ++++
 lib/qr/qrspec.c            |  543 +++++++++++++
 lib/qr/qrspec.h            |  178 +++++
 lib/qr/rscode.c            |  325 ++++++++
 lib/qr/rscode.h            |   38 +
 lib/qr/split.c             |  331 ++++++++
 lib/qr/split.h             |   44 ++
 28 files changed, 6860 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/print_oops.h
 create mode 100644 include/linux/qrencode.h
 create mode 100644 kernel/print_oops.c
 create mode 100644 lib/qr/Makefile
 create mode 100644 lib/qr/bitstream.c
 create mode 100644 lib/qr/bitstream.h
 create mode 100644 lib/qr/mask.c
 create mode 100644 lib/qr/mask.h
 create mode 100644 lib/qr/mmask.c
 create mode 100644 lib/qr/mmask.h
 create mode 100644 lib/qr/mqrspec.c
 create mode 100644 lib/qr/mqrspec.h
 create mode 100644 lib/qr/qrencode.c
 create mode 100644 lib/qr/qrencode.h
 create mode 100644 lib/qr/qrinput.c
 create mode 100644 lib/qr/qrinput.h
 create mode 100644 lib/qr/qrspec.c
 create mode 100644 lib/qr/qrspec.h
 create mode 100644 lib/qr/rscode.c
 create mode 100644 lib/qr/rscode.h
 create mode 100644 lib/qr/split.c
 create mode 100644 lib/qr/split.h

diff --git a/include/linux/print_oops.h b/include/linux/print_oops.h
new file mode 100644
index 0000000..9ebb963
--- /dev/null
+++ b/include/linux/print_oops.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_X86_PRINT_OPS_H
+#define _ASM_X86_PRINT_OPS_H
+
+#include <linux/module.h>
+
+#define QR_BUFSIZE 4096
+
+void qr_append(char *text);
+void print_qr_err(void);
+
+#endif /* _PRINT_OPS_H */
diff --git a/include/linux/qrencode.h b/include/linux/qrencode.h
new file mode 100644
index 0000000..e643274
--- /dev/null
+++ b/include/linux/qrencode.h
@@ -0,0 +1,546 @@
+/**
+ * qrencode - QR Code encoder
+ *
+ * Copyright (C) 2006-2012 Kentaro Fukuchi <kentaro@fukuchi.org>
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+/** \mainpage
+ * Libqrencode is a library for encoding data in a QR Code symbol, a kind of 2D
+ * symbology.
+ *
+ * \section encoding Encoding
+ *
+ * There are two methods to encode data: <b>encoding a string/data</b> or
+ * <b>encoding a structured data</b>.
+ *
+ * \subsection encoding-string Encoding a string/data
+ * You can encode a string by calling QRcode_encodeString().
+ * The given string is parsed automatically and encoded. If you want to encode
+ * data that can be represented as a C string style (NUL terminated), you can
+ * simply use this way.
+ *
+ * If the input data contains Kanji (Shift-JIS) characters and you want to
+ * encode them as Kanji in QR Code, you should give QR_MODE_KANJI as a hint.
+ * Otherwise, all of non-alphanumeric characters are encoded as 8 bit data.
+ * If you want to encode a whole string in 8 bit mode, you can use
+ * QRcode_encodeString8bit() instead.
+ *
+ * Please note that a C string can not contain NUL characters. If your data
+ * contains NUL, you must use QRcode_encodeData().
+ *
+ * \subsection encoding-input Encoding a structured data
+ * You can construct a structured input data manually. If the structure of the
+ * input data is known, you can use this way.
+ * At first, create a ::QRinput object by QRinput_new(). Then add input data
+ * to the QRinput object by QRinput_append(). Finally call QRcode_encodeInput()
+ * to encode the QRinput data.
+ * You can reuse the QRinput data again to encode it in other symbols with
+ * different parameters.
+ *
+ * \section result Result
+ * The encoded symbol is resulted as a ::QRcode object. It will contain
+ * its version number, width of the symbol and an array represents the symbol.
+ * See ::QRcode for the details. You can free the object by QRcode_free().
+ *
+ * Please note that the version of the result may be larger than specified.
+ * In such cases, the input data would be too large to be encoded in a
+ * symbol of the specified version.
+ *
+ * \section structured Structured append
+ * Libqrencode can generate "Structured-appended" symbols that enables to split
+ * a large data set into mulitple QR codes. A QR code reader concatenates
+ * multiple QR code symbols into a string.
+ * Just like QRcode_encodeString(), you can use QRcode_encodeStringStructured()
+ * to generate structured-appended symbols. This functions returns an instance
+ * of ::QRcode_List. The returned list is a singly-linked list of QRcode: you
+ * can retrieve each QR code in this way:
+ *
+ * \code
+ * QRcode_List *qrcodes;
+ * QRcode_List *entry;
+ * QRcode *qrcode;
+ *
+ * qrcodes = QRcode_encodeStringStructured(...);
+ * entry = qrcodes;
+ * while(entry != NULL) {
+ *     qrcode = entry->code;
+ *     // do something
+ *     entry = entry->next;
+ * }
+ * QRcode_List_free(entry);
+ * \endcode
+ *
+ * Instead of using auto-parsing functions, you can construct your own
+ * structured input. At first, instantiate an object of ::QRinput_Struct
+ * by calling QRinput_Struct_new(). This object can hold multiple ::QRinput,
+ * and one QR code is generated for a ::QRinput.
+ * QRinput_Struct_appendInput() appends a ::QRinput to a ::QRinput_Struct
+ * object. In order to generate structured-appended symbols, it is required to
+ * embed headers to each symbol. You can use
+ * QRinput_Struct_insertStructuredAppendHeaders() to insert appropriate
+ * headers to each symbol. You should call this function just once before
+ * encoding symbols.
+ */
+
+#ifndef __QRENCODE_H__
+#define __QRENCODE_H__
+
+#if defined(__cplusplus)
+extern "C" {
+#endif
+
+/**
+ * Encoding mode.
+ */
+enum QRencodeMode {
+	QR_MODE_NUL = -1,   /* Terminator (NUL character). Internal use only */
+	QR_MODE_NUM = 0,    /* Numeric mode */
+	QR_MODE_AN,         /* Alphabet-numeric mode */
+	QR_MODE_8,          /* 8-bit data mode */
+	QR_MODE_KANJI,      /* Kanji (shift-jis) mode */
+	QR_MODE_STRUCTURE,  /* Internal use only */
+	QR_MODE_ECI,        /* ECI mode */
+	QR_MODE_FNC1FIRST,  /* FNC1, first position */
+	QR_MODE_FNC1SECOND, /* FNC1, second position */
+};
+
+/**
+ * Level of error correction.
+ */
+enum QRecLevel {
+	QR_ECLEVEL_L = 0, /* lowest */
+	QR_ECLEVEL_M,
+	QR_ECLEVEL_Q,
+	QR_ECLEVEL_H      /* highest */
+};
+
+/**
+ * Maximum version (size) of QR-code symbol.
+ */
+#define QRSPEC_VERSION_MAX 40
+
+/**
+ * Maximum version (size) of QR-code symbol.
+ */
+#define MQRSPEC_VERSION_MAX 4
+
+
+/******************************************************************************
+ * Input data (qrinput.c)
+ *****************************************************************************/
+/**
+ * Instantiate an input data object. The version is set to 0 (auto-select)
+ * and the error correction level is set to QR_ECLEVEL_L.
+ * @return an input object (initialized). On error, NULL is returned and errno
+ *         is set to indicate the error.
+ * @throw ENOMEM unable to allocate memory.
+ */
+extern struct QRinput *QRinput_new(void);
+
+/**
+ * Instantiate an input data object.
+ * @param version version number.
+ * @param level Error correction level.
+ * @return an input object (initialized). On error, NULL is returned and errno
+ *         is set to indicate the error.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ * @throw EINVAL invalid arguments.
+ */
+extern struct QRinput *QRinput_new2(int version, enum QRecLevel level);
+
+/**
+ * Instantiate an input data object. Object's Micro QR Code flag is set.
+ * Unlike with full-sized QR Code, version number must be specified (>0).
+ * @param version version number (1--4).
+ * @param level Error correction level.
+ * @return an input object (initialized). On error, NULL is returned and errno
+ *         is set to indicate the error.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ * @throw EINVAL invalid arguments.
+ */
+extern struct QRinput *QRinput_newMQR(int version, enum QRecLevel level);
+
+/**
+ * Append data to an input object.
+ * The data is copied and appended to the input object.
+ * @param input input object.
+ * @param mode encoding mode.
+ * @param size size of data (byte).
+ * @param data a pointer to the memory area of the input data.
+ * @retval 0 success.
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw EINVAL input data is invalid.
+ *
+ */
+extern int QRinput_append(struct QRinput *input, enum QRencodeMode mode,
+			  int size, const unsigned char *data);
+
+/**
+ * Append ECI header.
+ * @param input input object.
+ * @param ecinum ECI indicator number (0 - 999999)
+ * @retval 0 success.
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw EINVAL input data is invalid.
+ *
+ */
+extern int QRinput_appendECIheader(struct QRinput *input, unsigned int ecinum);
+
+/**
+ * Get current version.
+ * @param input input object.
+ * @return current version.
+ */
+extern int QRinput_getVersion(struct QRinput *input);
+
+/**
+ * Set version of the QR code that is to be encoded.
+ * This function cannot be applied to Micro QR Code.
+ * @param input input object.
+ * @param version version number (0 = auto)
+ * @retval 0 success.
+ * @retval -1 invalid argument.
+ */
+extern int QRinput_setVersion(struct QRinput *input, int version);
+
+/**
+ * Get current error correction level.
+ * @param input input object.
+ * @return Current error correcntion level.
+ */
+extern enum QRecLevel QRinput_getErrorCorrectionLevel(struct QRinput *input);
+
+/**
+ * Set error correction level of the QR code that is to be encoded.
+ * This function cannot be applied to Micro QR Code.
+ * @param input input object.
+ * @param level Error correction level.
+ * @retval 0 success.
+ * @retval -1 invalid argument.
+ */
+extern int QRinput_setErrorCorrectionLevel(struct QRinput *input,
+					   enum QRecLevel level);
+
+/**
+ * Set version and error correction level of the QR code at once.
+ * This function is recommened for Micro QR Code.
+ * @param input input object.
+ * @param version version number (0 = auto)
+ * @param level Error correction level.
+ * @retval 0 success.
+ * @retval -1 invalid argument.
+ */
+extern int
+QRinput_setVersionAndErrorCorrectionLevel(struct QRinput *input, int version,
+					  enum QRecLevel level);
+
+/**
+ * Free the input object.
+ * All of data chunks in the input object are freed too.
+ * @param input input object.
+ */
+extern void QRinput_free(struct QRinput *input);
+
+/**
+ * Validate the input data.
+ * @param mode encoding mode.
+ * @param size size of data (byte).
+ * @param data a pointer to the memory area of the input data.
+ * @retval 0 success.
+ * @retval -1 invalid arguments.
+ */
+extern int QRinput_check(enum QRencodeMode mode, int size,
+			 const unsigned char *data);
+
+/**
+ * Instantiate a set of input data object.
+ * @return an instance of QRinput_Struct. On error, NULL is returned and errno
+ *         is set to indicate the error.
+ * @throw ENOMEM unable to allocate memory.
+ */
+extern struct QRinput_Struct *QRinput_Struct_new(void);
+
+/**
+ * Set parity of structured symbols.
+ * @param s structured input object.
+ * @param parity parity of s.
+ */
+extern void QRinput_Struct_setParity(struct QRinput_Struct *s,
+				     unsigned char parity);
+
+/**
+ * Append a QRinput object to the set. QRinput created by QRinput_newMQR()
+ * will be rejected.
+ * @warning never append the same QRinput object twice or more.
+ * @param s structured input object.
+ * @param input an input object.
+ * @retval >0 number of input objects in the structure.
+ * @retval -1 an error occurred. See Exceptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw EINVAL invalid arguments.
+ */
+extern int QRinput_Struct_appendInput(struct QRinput_Struct *s,
+				      struct QRinput *input);
+
+/**
+ * Free all of QRinput in the set.
+ * @param s a structured input object.
+ */
+extern void QRinput_Struct_free(struct QRinput_Struct *s);
+
+/**
+ * Split a QRinput to QRinput_Struct. It calculates a parity, set it, then
+ * insert structured-append headers. QRinput created by QRinput_newMQR() will
+ * be rejected.
+ * @param input input object. Version number and error correction level must be
+ *        set.
+ * @return a set of input data. On error, NULL is returned, and errno is set
+ *         to indicate the error. See Exceptions for the details.
+ * @throw ERANGE input data is too large.
+ * @throw EINVAL invalid input data.
+ * @throw ENOMEM unable to allocate memory.
+ */
+extern struct QRinput_Struct
+*QRinput_splitQRinputToStruct(struct QRinput *input);
+
+/**
+ * Insert structured-append headers to the input structure. It calculates
+ * a parity and set it if the parity is not set yet.
+ * @param s input structure
+ * @retval 0 success.
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory.
+ */
+extern int
+QRinput_Struct_insertStructuredAppendHeaders(struct QRinput_Struct *s);
+
+/**
+ * Set FNC1-1st position flag.
+ */
+extern int QRinput_setFNC1First(struct QRinput *input);
+
+/**
+ * Set FNC1-2nd position flag and application identifier.
+ */
+extern int QRinput_setFNC1Second(struct QRinput *input, unsigned char appid);
+
+/******************************************************************************
+ * QRcode output (qrencode.c)
+ *****************************************************************************/
+
+/**
+ * QRcode class.
+ * Symbol data is represented as an array contains width*width uchars.
+ * Each uchar represents a module (dot). If the less significant bit of
+ * the uchar is 1, the corresponding module is black. The other bits are
+ * meaningless for usual applications, but here its specification is described.
+ *
+ * <pre>
+ * MSB 76543210 LSB
+ *     |||||||`- 1=black/0=white
+ *     ||||||`-- data and ecc code area
+ *     |||||`--- format information
+ *     ||||`---- version information
+ *     |||`----- timing pattern
+ *     ||`------ alignment pattern
+ *     |`------- finder pattern and separator
+ *     `-------- non-data modules (format, timing, etc.)
+ * </pre>
+ */
+struct QRcode {
+	int version;         /* version of the symbol */
+	int width;           /* width of the symbol */
+	unsigned char *data; /* symbol data */
+};
+
+/**
+ * Singly-linked list of QRcode. Used to represent a structured symbols.
+ * A list is terminated with NULL.
+ */
+struct QRcode_List {
+	struct QRcode *code;
+	struct QRcode_List *next;
+};
+
+/**
+ * Create a symbol from the input data.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param input input data.
+ * @return an instance of QRcode class. The version of the result QRcode may
+ *         be larger than the designated version. On error, NULL is returned,
+ *         and errno is set to indicate the error. See Exceptions for the
+ *         details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ */
+extern struct QRcode *QRcode_encodeInput(struct QRinput *input);
+
+/**
+ * Create a symbol from the string. The library automatically parses the input
+ * string and encodes in a QR Code symbol.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param string input string. It must be NUL terminated.
+ * @param version version of the symbol. If 0, the library chooses the minimum
+ *                version for the given input data.
+ * @param level error correction level.
+ * @param hint tell the library how Japanese Kanji characters should be
+ *             encoded. If QR_MODE_KANJI is given, the library assumes that the
+ *             given string contains Shift-JIS characters and encodes them in
+ *             Kanji-mode. If QR_MODE_8 is given, all of non-alphanumerical
+ *             characters will be encoded as is. If you want to embed UTF-8
+ *             string, choose this. Other mode will cause EINVAL error.
+ * @param casesensitive case-sensitive(1) or not(0).
+ * @return an instance of QRcode class. The version of the result QRcode may
+ *         be larger than the designated version. On error, NULL is returned,
+ *         and errno is set to indicate the error. See Exceptions for the
+ *         details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ * @throw ERANGE input data is too large.
+ */
+extern struct QRcode
+*QRcode_encodeString(const char *string, int version,
+		     enum QRecLevel level, enum QRencodeMode hint,
+		     int casesensitive);
+
+/**
+ * Same to QRcode_encodeString(), but encode whole data in 8-bit mode.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode
+*QRcode_encodeString8bit(const char *string, int version,
+			 enum QRecLevel level);
+
+/**
+ * Micro QR Code version of QRcode_encodeString().
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode
+*QRcode_encodeStringMQR(const char *string, int version, enum QRecLevel level,
+			enum QRencodeMode hint, int casesensitive);
+
+/**
+ * Micro QR Code version of QRcode_encodeString8bit().
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode
+*QRcode_encodeString8bitMQR(const char *string, int version,
+			    enum QRecLevel level);
+
+/**
+ * Encode byte stream (may include '\0') in 8-bit mode.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param size size of the input data.
+ * @param data input data.
+ * @param version version of the symbol. If 0, the library chooses the minimum
+ *                version for the given input data.
+ * @param level error correction level.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ * @throw ERANGE input data is too large.
+ */
+extern struct QRcode
+*QRcode_encodeData(int size, const unsigned char *data,
+		   int version, enum QRecLevel level);
+
+/**
+ * Micro QR Code version of QRcode_encodeData().
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode
+*QRcode_encodeDataMQR(int size, const unsigned char *data,
+		      int version, enum QRecLevel level);
+
+/**
+ * Free the instance of QRcode class.
+ * @param qrcode an instance of QRcode class.
+ */
+extern void QRcode_free(struct QRcode *qrcode);
+
+/**
+ * Create structured symbols from the input data.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param s
+ * @return a singly-linked list of QRcode.
+ */
+extern struct QRcode_List
+*QRcode_encodeInputStructured(struct QRinput_Struct *s);
+
+/**
+ * Create structured symbols from the string. The library automatically parses
+ * the input string and encodes in a QR Code symbol.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param string input string. It must be NUL terminated.
+ * @param version version of the symbol.
+ * @param level error correction level.
+ * @param hint tell the library how Japanese Kanji characters should be
+ *             encoded. If QR_MODE_KANJI is given, the library assumes that the
+ *             given string contains Shift-JIS characters and encodes them in
+ *             Kanji-mode. If QR_MODE_8 is given, all of non-alphanumerical
+ *             characters will be encoded as is. If you want to embed UTF-8
+ *             string, choose this. Other mode will cause EINVAL error.
+ * @param casesensitive case-sensitive(1) or not(0).
+ * @return a singly-linked list of QRcode. On error, NULL is returned, and
+ *         errno is set to indicate the error. See Exceptions for the details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ */
+extern struct QRcode_List
+*QRcode_encodeStringStructured(const char *string, int version,
+			       enum QRecLevel level, enum QRencodeMode hint,
+			       int casesensitive);
+
+/**
+ * Same to QRcode_encodeStringStructured(), but encode whole data in 8-bit mode.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode_List
+*QRcode_encodeString8bitStructured(const char *string, int version,
+				   enum QRecLevel level);
+
+/**
+ * Create structured symbols from byte stream (may include '\0'). Wholde data
+ * are encoded in 8-bit mode.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param size size of the input data.
+ * @param data input dat.
+ * @param version version of the symbol.
+ * @param level error correction level.
+ * @return a singly-linked list of QRcode. On error, NULL is returned, and
+ *         errno is set to indicate the error. See Exceptions for the details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ */
+extern struct QRcode_List
+*QRcode_encodeDataStructured(int size, const unsigned char *data,
+			     int version, enum QRecLevel level);
+
+/**
+ * Return the number of symbols included in a QRcode_List.
+ * @param qrlist a head entry of a QRcode_List.
+ * @return number of symbols in the list.
+ */
+extern int QRcode_List_size(struct QRcode_List *qrlist);
+
+/**
+ * Free the QRcode_List.
+ * @param qrlist a head entry of a QRcode_List.
+ */
+extern void QRcode_List_free(struct QRcode_List *qrlist);
+
+#endif /* __QRENCODE_H__ */
diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee..297a619 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -26,6 +26,7 @@ obj-y += cpu/
 obj-y += irq/
 obj-y += rcu/
 
+obj-$(CONFIG_QR_OOPS) += print_oops.o
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
diff --git a/kernel/panic.c b/kernel/panic.c
index 6d63003..cceec30 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -24,6 +24,8 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 
+#include <linux/print_oops.h>
+
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
 
@@ -382,6 +384,9 @@ void print_oops_end_marker(void)
 	init_oops_id();
 	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
 		(unsigned long long)oops_id);
+#ifdef CONFIG_QR_OOPS
+	print_qr_err();
+#endif
 }
 
 /*
diff --git a/kernel/print_oops.c b/kernel/print_oops.c
new file mode 100644
index 0000000..089e11e
--- /dev/null
+++ b/kernel/print_oops.c
@@ -0,0 +1,173 @@
+/*
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ */
+#include <linux/print_oops.h>
+#include <linux/kdebug.h>
+#include <linux/bug.h>
+#include <linux/qrencode.h>
+#include <linux/fb.h>
+#include <linux/zlib.h>
+
+static char qr_buffer[QR_BUFSIZE];
+static int buf_pos;
+
+#define COMPR_LEVEL 6
+
+static DEFINE_MUTEX(compr_mutex);
+static struct z_stream_s stream;
+
+#define QQQ_WHITE 0x0F
+#define QQQ_BLACK 0x00
+
+void qr_append(char *text)
+{
+	while (*text != '\0') {
+		if (buf_pos == QR_BUFSIZE - 1) {
+			qr_buffer[QR_BUFSIZE - 1] = '\0';
+			return;
+		}
+		qr_buffer[buf_pos] = *text;
+		buf_pos++;
+		text++;
+	}
+}
+
+static inline int compute_w(struct fb_info *info, int qrw)
+{
+	int xres  = info->var.xres;
+	int yres  = info->var.yres;
+	int minxy = (xres < yres) ? xres : yres;
+	return minxy / qrw / 3;
+}
+
+static int __init qr_compr_init(void)
+{
+	size_t size = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
+			zlib_inflate_workspacesize());
+	stream.workspace = vmalloc(size);
+	if (!stream.workspace)
+		return -ENOMEM;
+	return 0;
+}
+
+static void qr_compr_exit(void)
+{
+	vfree(stream.workspace);
+}
+
+static int qr_compress(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int err, ret;
+
+	ret = -EIO;
+
+	err = qr_compr_init();
+	if (err != 0)
+		goto error;
+	mutex_lock(&compr_mutex);
+	err = zlib_deflateInit(&stream, COMPR_LEVEL);
+	if (err != Z_OK)
+		goto error;
+
+	stream.next_in = in;
+	stream.avail_in = inlen;
+	stream.total_in = 0;
+	stream.next_out = out;
+	stream.avail_out = outlen;
+	stream.total_out = 0;
+
+	err = zlib_deflate(&stream, Z_FINISH);
+	if (err != Z_STREAM_END)
+		goto error;
+
+	err = zlib_deflateEnd(&stream);
+	if (err != Z_OK)
+		goto error;
+
+	if (stream.total_out >= stream.total_in)
+		goto error;
+
+	ret = stream.total_out;
+error:
+	mutex_unlock(&compr_mutex);
+	return ret;
+}
+
+void print_qr_err(void)
+{
+	ssize_t compr_len;
+	struct fb_info *info;
+	struct fb_fillrect rect;
+	struct QRcode *qr;
+
+	int i, j;
+	int w;
+	int is_black;
+
+	char compr_qr_buffer[buf_pos];
+	compr_len = qr_compress(qr_buffer, compr_qr_buffer, buf_pos, buf_pos);
+
+	if (compr_len < 0)
+		return;
+
+
+	qr = QRcode_encodeData(compr_len, compr_qr_buffer, 0, QR_ECLEVEL_H);
+
+	info = registered_fb[0];
+	w = compute_w(info, qr->width);
+
+	rect.width = w;
+	rect.height = w;
+	rect.rop = 0;
+
+	/* Print borders: */
+	rect.color = QQQ_WHITE;
+	for (i = 0; i < qr->width + 2; i++) {
+		/* Top */
+		rect.dx = 0;
+		rect.dy = i * w;
+		cfb_fillrect(info, &rect);
+
+		/* Bottom */
+		rect.dx = (qr->width + 1) * w;
+		rect.dy = i * w;
+		cfb_fillrect(info, &rect);
+
+		/* Left */
+		rect.dx = i * w;
+		rect.dy = 0;
+		cfb_fillrect(info, &rect);
+
+		/* Right */
+		rect.dx = i * w;
+		rect.dy = (qr->width + 1) * w;
+		cfb_fillrect(info, &rect);
+	}
+
+	/* Print actual QR matrix: */
+	for (i = 0; i < qr->width; i++) {
+		for (j = 0; j < qr->width; j++) {
+			rect.dx = (j + 1) * w;
+			rect.dy = (i + 1) * w;
+			is_black = qr->data[i * qr->width + j] & 1;
+			rect.color = is_black ? QQQ_BLACK : QQQ_WHITE;
+			cfb_fillrect(info, &rect);
+		}
+	}
+
+	QRcode_free(qr);
+	qr_compr_exit();
+	buf_pos = 0;
+}
+
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b1d255f..72dd80a 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -45,6 +45,7 @@
 #include <linux/poll.h>
 #include <linux/irq_work.h>
 #include <linux/utsname.h>
+#include <linux/print_oops.h>
 
 #include <asm/uaccess.h>
 
@@ -1076,7 +1077,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		next_seq = log_next_seq;
 
 		len = 0;
-		prev = 0;
 		while (len >= 0 && seq < next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 			int textlen;
@@ -1569,6 +1569,11 @@ asmlinkage int vprintk_emit(int facility, int level,
 		}
 	}
 
+#ifdef CONFIG_QR_OOPS
+	if (oops_in_progress)
+		qr_append(text);
+#endif
+
 	if (level == -1)
 		level = default_message_loglevel;
 
@@ -1688,7 +1693,6 @@ asmlinkage int printk(const char *fmt, ...)
 	va_start(args, fmt);
 	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
 	va_end(args);
-
 	return r;
 }
 EXPORT_SYMBOL(printk);
@@ -2788,7 +2792,6 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	next_idx = idx;
 
 	l = 0;
-	prev = 0;
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
diff --git a/lib/Kconfig b/lib/Kconfig
index 991c98b..ef591d6 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -435,6 +435,11 @@ config SIGNATURE
 	  Digital signature verification. Currently only RSA is supported.
 	  Implementation is done using GnuPG MPI library
 
+config QRLIB
+	bool "QR encoding library"
+	help
+	  QR encoding library
+
 #
 # libfdt files, only selected if needed.
 #
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a48abea..523136c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -15,6 +15,17 @@ config PRINTK_TIME
 	  The behavior is also controlled by the kernel command line
 	  parameter printk.time=1. See Documentation/kernel-parameters.txt
 
+config QR_OOPS
+	bool "Display QR barcode for Oops messages for debug"
+	depends on PRINTK && QRLIB
+	help
+		Selecting this option makes printk() calls to accumulate
+		the Oops messages in a buffer, compresses the message
+		and prints the OR to the frame buffer device.
+
+		This is an experimental feature at the moment.
+
+
 config DEFAULT_MESSAGE_LOGLEVEL
 	int "Default message log level (1-7)"
 	range 1 7
diff --git a/lib/Makefile b/lib/Makefile
index 48140e3..c4dff81 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -39,6 +39,9 @@ CFLAGS_kobject.o += -DDEBUG
 CFLAGS_kobject_uevent.o += -DDEBUG
 endif
 
+# QR lib
+obj-$(CONFIG_QRLIB) += qr/
+
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
 obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
diff --git a/lib/qr/Makefile b/lib/qr/Makefile
new file mode 100644
index 0000000..2b90691
--- /dev/null
+++ b/lib/qr/Makefile
@@ -0,0 +1,6 @@
+#
+# QR encoding library
+#
+
+EXTRA_FLAGS = -g
+obj-$(CONFIG_QRLIB) = bitstream.o mask.o mmask.o mqrspec.o qrencode.o qrinput.o qrspec.o rscode.o split.o
diff --git a/lib/qr/bitstream.c b/lib/qr/bitstream.c
new file mode 100644
index 0000000..a2c9fc3
--- /dev/null
+++ b/lib/qr/bitstream.c
@@ -0,0 +1,233 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Binary sequence class.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include "bitstream.h"
+
+struct BitStream *BitStream_new(void)
+{
+	struct BitStream *bstream;
+
+	bstream = kmalloc(sizeof(struct BitStream), GFP_ATOMIC);
+	if (bstream == NULL)
+		return NULL;
+
+	bstream->length = 0;
+	bstream->data = NULL;
+
+	return bstream;
+}
+
+static int BitStream_allocate(struct BitStream *bstream, int length)
+{
+	unsigned char *data;
+
+	if (bstream == NULL)
+		return -1;
+
+	data = kmalloc(length, GFP_ATOMIC);
+	if (data == NULL)
+		return -1;
+
+	kfree(bstream->data);
+
+	bstream->length = length;
+	bstream->data = data;
+
+	return 0;
+}
+
+static struct BitStream *BitStream_newFromNum(int bits, unsigned int num)
+{
+	unsigned int mask;
+	int i;
+	unsigned char *p;
+	struct BitStream *bstream;
+
+	bstream = BitStream_new();
+	if (bstream == NULL)
+		return NULL;
+
+	if (BitStream_allocate(bstream, bits)) {
+		BitStream_free(bstream);
+		return NULL;
+	}
+
+	p = bstream->data;
+	mask = 1 << (bits - 1);
+	for (i = 0; i < bits; i++) {
+		if (num & mask)
+			*p = 1;
+		else
+			*p = 0;
+		p++;
+		mask = mask >> 1;
+	}
+
+	return bstream;
+}
+
+static struct BitStream *BitStream_newFromBytes(int size, unsigned char *data)
+{
+	unsigned char mask;
+	int i, j;
+	unsigned char *p;
+	struct BitStream *bstream;
+
+	bstream = BitStream_new();
+	if (bstream == NULL)
+		return NULL;
+
+	if (BitStream_allocate(bstream, size * 8)) {
+		BitStream_free(bstream);
+		return NULL;
+	}
+
+	p = bstream->data;
+	for (i = 0; i < size; i++) {
+		mask = 0x80;
+		for (j = 0; j < 8; j++) {
+			if (data[i] & mask)
+				*p = 1;
+			else
+				*p = 0;
+			p++;
+			mask = mask >> 1;
+		}
+	}
+
+	return bstream;
+}
+
+int BitStream_append(struct BitStream *bstream, struct BitStream *arg)
+{
+	unsigned char *data;
+
+	if (arg == NULL)
+		return -1;
+
+	if (arg->length == 0)
+		return 0;
+
+	if (bstream->length == 0) {
+		if (BitStream_allocate(bstream, arg->length))
+			return -1;
+
+		memcpy(bstream->data, arg->data, arg->length);
+		return 0;
+	}
+
+	data = kmalloc(bstream->length + arg->length, GFP_ATOMIC);
+	if (data == NULL)
+		return -1;
+
+	memcpy(data, bstream->data, bstream->length);
+	memcpy(data + bstream->length, arg->data, arg->length);
+
+	kfree(bstream->data);
+	bstream->length += arg->length;
+	bstream->data = data;
+
+	return 0;
+}
+
+int BitStream_appendNum(struct BitStream *bstream, int bits, unsigned int num)
+{
+	struct BitStream *b;
+	int ret;
+
+	if (bits == 0)
+		return 0;
+
+	b = BitStream_newFromNum(bits, num);
+	if (b == NULL)
+		return -1;
+
+	ret = BitStream_append(bstream, b);
+	BitStream_free(b);
+
+	return ret;
+}
+
+int BitStream_appendBytes(struct BitStream *bstream, int size,
+			  unsigned char *data)
+{
+	struct BitStream *b;
+	int ret;
+
+	if (size == 0)
+		return 0;
+
+	b = BitStream_newFromBytes(size, data);
+	if (b == NULL)
+		return -1;
+
+	ret = BitStream_append(bstream, b);
+	BitStream_free(b);
+
+	return ret;
+}
+
+unsigned char *BitStream_toByte(struct BitStream *bstream)
+{
+	int i, j, size, bytes;
+	unsigned char *data, v;
+	unsigned char *p;
+
+	size = BitStream_size(bstream);
+	if (size == 0)
+		return NULL;
+
+	data = kmalloc((size + 7) / 8, GFP_ATOMIC);
+	if (data == NULL)
+		return NULL;
+
+	bytes = size / 8;
+
+	p = bstream->data;
+	for (i = 0; i < bytes; i++) {
+		v = 0;
+		for (j = 0; j < 8; j++) {
+			v = v << 1;
+			v |= *p;
+			p++;
+		}
+		data[i] = v;
+	}
+	if (size & 7) {
+		v = 0;
+		for (j = 0; j < (size & 7); j++) {
+			v = v << 1;
+			v |= *p;
+			p++;
+		}
+		data[bytes] = v;
+	}
+
+	return data;
+}
+
+void BitStream_free(struct BitStream *bstream)
+{
+	if (bstream != NULL) {
+		kfree(bstream->data);
+		kfree(bstream);
+	}
+}
diff --git a/lib/qr/bitstream.h b/lib/qr/bitstream.h
new file mode 100644
index 0000000..6a7ea65
--- /dev/null
+++ b/lib/qr/bitstream.h
@@ -0,0 +1,37 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Binary sequence class.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __BITSTREAM_H__
+#define __BITSTREAM_H__
+
+struct BitStream {
+	int length;
+	unsigned char *data;
+};
+
+extern struct BitStream *BitStream_new(void);
+extern int BitStream_append(struct BitStream *bstream, struct BitStream *arg);
+extern int BitStream_appendNum(struct BitStream *bstream, int bits,
+			       unsigned int num);
+extern int BitStream_appendBytes(struct BitStream *bstream, int size,
+				 unsigned char *data);
+#define BitStream_size(__bstream__) (__bstream__->length)
+extern unsigned char *BitStream_toByte(struct BitStream *bstream);
+extern void BitStream_free(struct BitStream *bstream);
+
+#endif /* __BITSTREAM_H__ */
diff --git a/lib/qr/mask.c b/lib/qr/mask.c
new file mode 100644
index 0000000..b5025cd
--- /dev/null
+++ b/lib/qr/mask.c
@@ -0,0 +1,320 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Masking.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <linux/qrencode.h>
+#include "qrspec.h"
+#include "mask.h"
+
+static int Mask_writeFormatInformation(int width, unsigned char *frame,
+				       int mask, enum QRecLevel level)
+{
+	unsigned int format;
+	unsigned char v;
+	int i;
+	int blacks = 0;
+
+	format = QRspec_getFormatInfo(mask, level);
+
+	for (i = 0; i < 8; i++) {
+		if (format & 1) {
+			blacks += 2;
+			v = 0x85;
+		} else {
+			v = 0x84;
+		}
+		frame[width * 8 + width - 1 - i] = v;
+		if (i < 6)
+			frame[width * i + 8] = v;
+		else
+			frame[width * (i + 1) + 8] = v;
+
+		format = format >> 1;
+	}
+	for (i = 0; i < 7; i++) {
+		if (format & 1) {
+			blacks += 2;
+			v = 0x85;
+		} else
+			v = 0x84;
+
+		frame[width * (width - 7 + i) + 8] = v;
+		if (i == 0)
+			frame[width * 8 + 7] = v;
+		else
+			frame[width * 8 + 6 - i] = v;
+
+		format = format >> 1;
+	}
+
+	return blacks;
+}
+
+/**
+ * Demerit coefficients.
+ * See Section 8.8.2, pp.45, JIS X0510:2004.
+ */
+#define N1 (3)
+#define N2 (3)
+#define N3 (40)
+#define N4 (10)
+
+#define MASKMAKER(__exp__) \
+	int x, y;\
+	int b = 0;\
+\
+	for (y = 0; y < width; y++) {\
+		for (x = 0; x < width; x++) {\
+			if (*s & 0x80) {\
+				*d = *s;\
+			} else {\
+				*d = *s ^ ((__exp__) == 0);\
+			} \
+			b += (int)(*d & 1);\
+			s++; d++;\
+		} \
+	} \
+	return b;
+
+static int Mask_mask0(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER((x + y) & 1)
+}
+
+static int Mask_mask1(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER(y & 1)
+}
+
+static int Mask_mask2(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER(x % 3)
+}
+
+static int Mask_mask3(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER((x + y) % 3)
+}
+
+static int Mask_mask4(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER(((y / 2) + (x / 3)) & 1)
+}
+
+static int Mask_mask5(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER(((x * y) & 1) + (x * y) % 3)
+}
+
+static int Mask_mask6(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER((((x * y) & 1) + (x * y) % 3) & 1)
+}
+
+static int Mask_mask7(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER((((x * y) % 3) + ((x + y) & 1)) & 1)
+}
+
+#define maskNum (8)
+typedef int MaskMaker(int, const unsigned char *, unsigned char *);
+static MaskMaker *maskMakers[maskNum] = {
+	Mask_mask0, Mask_mask1, Mask_mask2, Mask_mask3,
+	Mask_mask4, Mask_mask5, Mask_mask6, Mask_mask7
+};
+
+#ifdef WITH_TESTS
+unsigned char *Mask_makeMaskedFrame(int width, unsigned char *frame, int mask)
+{
+	unsigned char *masked;
+
+	masked = kmalloc(width * width, GFP_ATOMIC);
+	if (masked == NULL)
+		return NULL;
+
+	maskMakers[mask] (width, frame, masked);
+
+	return masked;
+}
+#endif
+
+unsigned char *Mask_makeMask(int width, unsigned char *frame, int mask,
+			     enum QRecLevel level)
+{
+	unsigned char *masked;
+
+	if (mask < 0 || mask >= maskNum)
+		return NULL;
+
+	masked = kmalloc(width * width, GFP_ATOMIC);
+	if (masked == NULL)
+		return NULL;
+
+	maskMakers[mask] (width, frame, masked);
+	Mask_writeFormatInformation(width, masked, mask, level);
+
+	return masked;
+}
+
+static int Mask_calcN1N3(int length, int *runLength)
+{
+	int i;
+	int demerit = 0;
+	int fact;
+
+	for (i = 0; i < length; i++) {
+		if (runLength[i] >= 5)
+			demerit += N1 + (runLength[i] - 5);
+		if ((i & 1)) {
+			if (i >= 3 && i < length - 2
+			    && (runLength[i] % 3) == 0) {
+				fact = runLength[i] / 3;
+				if (runLength[i - 2] == fact &&
+				    runLength[i - 1] == fact &&
+				    runLength[i + 1] == fact &&
+				    runLength[i + 2] == fact) {
+					if (i == 3
+					    || runLength[i - 3] >= 4 * fact) {
+						demerit += N3;
+					} else if (i + 4 >= length
+						   || runLength[i + 3] >=
+						   4 * fact) {
+						demerit += N3;
+					}
+				}
+			}
+		}
+	}
+
+	return demerit;
+}
+
+static int Mask_calcN2(int width, unsigned char *frame)
+{
+	int x, y;
+	unsigned char *p;
+	unsigned char b22, w22;
+	int demerit = 0;
+
+	p = frame + width + 1;
+	for (y = 1; y < width; y++) {
+		for (x = 1; x < width; x++) {
+			b22 = p[0] & p[-1] & p[-width] & p[-width - 1];
+			w22 = p[0] | p[-1] | p[-width] | p[-width - 1];
+			if ((b22 | (w22 ^ 1)) & 1)
+				demerit += N2;
+			p++;
+		}
+		p++;
+	}
+
+	return demerit;
+}
+
+static int Mask_calcRunLength(int width, unsigned char *frame, int dir,
+			      int *runLength)
+{
+	int head;
+	int i;
+	unsigned char *p;
+	int pitch;
+
+	pitch = (dir == 0) ? 1 : width;
+	if (frame[0] & 1) {
+		runLength[0] = -1;
+		head = 1;
+	} else {
+		head = 0;
+	}
+	runLength[head] = 1;
+	p = frame + pitch;
+
+	for (i = 1; i < width; i++) {
+		if ((p[0] ^ p[-pitch]) & 1) {
+			head++;
+			runLength[head] = 1;
+		} else {
+			runLength[head]++;
+		}
+		p += pitch;
+	}
+
+	return head + 1;
+}
+
+static int Mask_evaluateSymbol(int width, unsigned char *frame)
+{
+	int x, y;
+	int demerit = 0;
+	int runLength[QRSPEC_WIDTH_MAX + 1];
+	int length;
+
+	demerit += Mask_calcN2(width, frame);
+
+	for (y = 0; y < width; y++) {
+		length =
+		    Mask_calcRunLength(width, frame + y * width, 0, runLength);
+		demerit += Mask_calcN1N3(length, runLength);
+	}
+
+	for (x = 0; x < width; x++) {
+		length = Mask_calcRunLength(width, frame + x, 1, runLength);
+		demerit += Mask_calcN1N3(length, runLength);
+	}
+
+	return demerit;
+}
+
+unsigned char *Mask_mask(int width, unsigned char *frame, enum QRecLevel level)
+{
+	int i;
+	unsigned char *mask, *bestMask;
+	int minDemerit = INT_MAX;
+	int blacks;
+	int bratio;
+	int demerit;
+	int w2 = width * width;
+
+	mask = kmalloc(w2, GFP_ATOMIC);
+	if (mask == NULL)
+		return NULL;
+	bestMask = NULL;
+
+	for (i = 0; i < maskNum; i++) {
+		demerit = 0;
+		blacks = maskMakers[i] (width, frame, mask);
+		blacks += Mask_writeFormatInformation(width, mask, i, level);
+		bratio = (200 * blacks + w2) / w2 / 2;
+		demerit = (abs(bratio - 50) / 5) * N4;
+		demerit += Mask_evaluateSymbol(width, mask);
+		if (demerit < minDemerit) {
+			minDemerit = demerit;
+			kfree(bestMask);
+			bestMask = mask;
+			mask = kmalloc(w2, GFP_ATOMIC);
+			if (mask == NULL)
+				break;
+		}
+	}
+	kfree(mask);
+	return bestMask;
+}
diff --git a/lib/qr/mask.h b/lib/qr/mask.h
new file mode 100644
index 0000000..c8e9276
--- /dev/null
+++ b/lib/qr/mask.h
@@ -0,0 +1,39 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Masking.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __MASK_H__
+#define __MASK_H__
+
+extern unsigned char *Mask_makeMask(int width, unsigned char *frame,
+				    int mask, enum QRecLevel level);
+extern unsigned char *Mask_mask(int width, unsigned char *frame,
+				enum QRecLevel level);
+
+#ifdef WITH_TESTS
+extern int Mask_calcN2(int width, unsigned char *frame);
+extern int Mask_calcN1N3(int length, int *runLength);
+extern int Mask_calcRunLength(int width, unsigned char *frame,
+			      int dir, int *runLength);
+extern int Mask_evaluateSymbol(int width, unsigned char *frame);
+extern int Mask_writeFormatInformation(int width, unsigned char *frame,
+				       int mask, enum QRecLevel level);
+extern unsigned char *Mask_makeMaskedFrame(int width, unsigned char *frame,
+					   int mask);
+#endif
+
+#endif /* __MASK_H__ */
diff --git a/lib/qr/mmask.c b/lib/qr/mmask.c
new file mode 100644
index 0000000..386e12c
--- /dev/null
+++ b/lib/qr/mmask.c
@@ -0,0 +1,175 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Masking for Micro QR Code.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <linux/qrencode.h>
+#include "mqrspec.h"
+#include "mmask.h"
+
+static void MMask_writeFormatInformation(int version, int width,
+					 unsigned char *frame, int mask,
+					 enum QRecLevel level)
+{
+	unsigned int format;
+	unsigned char v;
+	int i;
+
+	format = MQRspec_getFormatInfo(mask, version, level);
+
+	for (i = 0; i < 8; i++) {
+		v = 0x84 | (format & 1);
+		frame[width * (i + 1) + 8] = v;
+		format = format >> 1;
+	}
+	for (i = 0; i < 7; i++) {
+		v = 0x84 | (format & 1);
+		frame[width * 8 + 7 - i] = v;
+		format = format >> 1;
+	}
+}
+
+#define MASKMAKER(__exp__) \
+	int x, y;\
+\
+	for (y = 0; y < width; y++) {\
+		for (x = 0; x < width; x++) {\
+			if (*s & 0x80) {\
+				*d = *s;\
+			} else { \
+				*d = *s ^ ((__exp__) == 0);\
+			} \
+			s++; d++;\
+		} \
+	}
+
+static void Mask_mask0(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER(y & 1)
+}
+
+static void Mask_mask1(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER(((y / 2) + (x / 3)) & 1)
+}
+
+static void Mask_mask2(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER((((x * y) & 1) + (x * y) % 3) & 1)
+}
+
+static void Mask_mask3(int width, const unsigned char *s, unsigned char *d)
+{
+	MASKMAKER((((x + y) & 1) + ((x * y) % 3)) & 1)
+}
+
+#define maskNum (4)
+typedef void MaskMaker(int, const unsigned char *, unsigned char *);
+static MaskMaker *maskMakers[maskNum] = {
+	Mask_mask0, Mask_mask1, Mask_mask2, Mask_mask3
+};
+
+#ifdef WITH_TESTS
+unsigned char *MMask_makeMaskedFrame(int width, unsigned char *frame, int mask)
+{
+	unsigned char *masked;
+
+	masked = kmalloc(width * width, GFP_ATOMIC);
+	if (masked == NULL)
+		return NULL;
+
+	maskMakers[mask] (width, frame, masked);
+
+	return masked;
+}
+#endif
+
+unsigned char *MMask_makeMask(int version, unsigned char *frame, int mask,
+			      enum QRecLevel level)
+{
+	unsigned char *masked;
+	int width;
+
+	if (mask < 0 || mask >= maskNum)
+		return NULL;
+
+	width = MQRspec_getWidth(version);
+	masked = kmalloc(width * width, GFP_ATOMIC);
+	if (masked == NULL)
+		return NULL;
+
+	maskMakers[mask] (width, frame, masked);
+	MMask_writeFormatInformation(version, width, masked, mask, level);
+
+	return masked;
+}
+
+static int MMask_evaluateSymbol(int width, unsigned char *frame)
+{
+	int x, y;
+	unsigned char *p;
+	int sum1 = 0, sum2 = 0;
+
+	p = frame + width * (width - 1);
+	for (x = 1; x < width; x++)
+		sum1 += (p[x] & 1);
+
+	p = frame + width * 2 - 1;
+	for (y = 1; y < width; y++) {
+		sum2 += (*p & 1);
+		p += width;
+	}
+
+	return (sum1 <= sum2) ? (sum1 * 16 + sum2) : (sum2 * 16 + sum1);
+}
+
+unsigned char *MMask_mask(int version, unsigned char *frame,
+			  enum QRecLevel level)
+{
+	int i;
+	unsigned char *mask, *bestMask;
+	int maxScore = 0;
+	int score;
+	int width;
+
+	width = MQRspec_getWidth(version);
+
+	mask = kmalloc(width * width, GFP_ATOMIC);
+	if (mask == NULL)
+		return NULL;
+	bestMask = NULL;
+
+	for (i = 0; i < maskNum; i++) {
+		score = 0;
+		maskMakers[i] (width, frame, mask);
+		MMask_writeFormatInformation(version, width, mask, i, level);
+		score = MMask_evaluateSymbol(width, mask);
+		if (score > maxScore) {
+			maxScore = score;
+			kfree(bestMask);
+			bestMask = mask;
+			mask = kmalloc(width * width, GFP_ATOMIC);
+			if (mask == NULL)
+				break;
+		}
+	}
+	kfree(mask);
+	return bestMask;
+}
diff --git a/lib/qr/mmask.h b/lib/qr/mmask.h
new file mode 100644
index 0000000..769abf2
--- /dev/null
+++ b/lib/qr/mmask.h
@@ -0,0 +1,36 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Masking for Micro QR Code.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __MMASK_H__
+#define __MMASK_H__
+
+extern unsigned char *MMask_makeMask(int version, unsigned char *frame,
+				     int mask, enum QRecLevel level);
+extern unsigned char *MMask_mask(int version, unsigned char *frame,
+				 enum QRecLevel level);
+
+#ifdef WITH_TESTS
+extern int MMask_evaluateSymbol(int width, unsigned char *frame);
+extern void MMask_writeFormatInformation(int version, int width,
+					 unsigned char *frame, int mask,
+					 enum QRecLevel level);
+extern unsigned char *MMask_makeMaskedFrame(int width, unsigned char *frame,
+					    int mask);
+#endif
+
+#endif /* __MMASK_H__ */
diff --git a/lib/qr/mqrspec.c b/lib/qr/mqrspec.c
new file mode 100644
index 0000000..b5a3408
--- /dev/null
+++ b/lib/qr/mqrspec.c
@@ -0,0 +1,259 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Micor QR Code specification in convenient format.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include "mqrspec.h"
+
+/******************************************************************************
+ * Version and capacity
+ *****************************************************************************/
+
+struct MQRspec_Capacity {
+	int width;		/* Edge length of the symbol */
+	int ec[4];		/* Number of ECC code (bytes) */
+};
+
+/**
+ * Table of the capacity of symbols
+ * See Table 1 (pp.106) and Table 8 (pp.113) of Appendix 1, JIS X0510:2004.
+ */
+static
+const struct MQRspec_Capacity mqrspecCapacity[MQRSPEC_VERSION_MAX + 1] = {
+	{0, {0, 0, 0, 0} },
+	{11, {2, 0, 0, 0} },
+	{13, {5, 6, 0, 0} },
+	{15, {6, 8, 0, 0} },
+	{17, {8, 10, 14, 0} }
+};
+
+int MQRspec_getDataLengthBit(int version, enum QRecLevel level)
+{
+	int w;
+	int ecc;
+
+	w = mqrspecCapacity[version].width - 1;
+	ecc = mqrspecCapacity[version].ec[level];
+	if (ecc == 0)
+		return 0;
+	return w * w - 64 - ecc * 8;
+}
+
+int MQRspec_getDataLength(int version, enum QRecLevel level)
+{
+	return (MQRspec_getDataLengthBit(version, level) + 4) / 8;
+}
+
+int MQRspec_getECCLength(int version, enum QRecLevel level)
+{
+	return mqrspecCapacity[version].ec[level];
+}
+
+int MQRspec_getWidth(int version)
+{
+	return mqrspecCapacity[version].width;
+}
+
+/******************************************************************************
+ * Length indicator
+ *****************************************************************************/
+
+/**
+ * See Table 3 (pp.107) of Appendix 1, JIS X0510:2004.
+ */
+static const int lengthTableBits[4][4] = {
+	{3, 4, 5, 6},
+	{0, 3, 4, 5},
+	{0, 0, 4, 5},
+	{0, 0, 3, 4}
+};
+
+int MQRspec_lengthIndicator(enum QRencodeMode mode, int version)
+{
+	return lengthTableBits[mode][version - 1];
+}
+
+int MQRspec_maximumWords(enum QRencodeMode mode, int version)
+{
+	int bits;
+	int words;
+
+	bits = lengthTableBits[mode][version - 1];
+	words = (1 << bits) - 1;
+	if (mode == QR_MODE_KANJI)
+		words *= 2;	/* the number of bytes is required */
+
+	return words;
+}
+
+/******************************************************************************
+ * Format information
+ *****************************************************************************/
+
+/* See calcFormatInfo in tests/test_mqrspec.c */
+static const unsigned int formatInfo[4][8] = {
+	{0x4445, 0x55ae, 0x6793, 0x7678, 0x06de, 0x1735, 0x2508, 0x34e3},
+	{0x4172, 0x5099, 0x62a4, 0x734f, 0x03e9, 0x1202, 0x203f, 0x31d4},
+	{0x4e2b, 0x5fc0, 0x6dfd, 0x7c16, 0x0cb0, 0x1d5b, 0x2f66, 0x3e8d},
+	{0x4b1c, 0x5af7, 0x68ca, 0x7921, 0x0987, 0x186c, 0x2a51, 0x3bba}
+};
+
+/* See Table 10 of Appendix 1. (pp.115) */
+static const int typeTable[MQRSPEC_VERSION_MAX + 1][3] = {
+	{-1, -1, -1},
+	{0, -1, -1},
+	{1, 2, -1},
+	{3, 4, -1},
+	{5, 6, 7}
+};
+
+unsigned int MQRspec_getFormatInfo(int mask, int version, enum QRecLevel level)
+{
+	int type;
+
+	if (mask < 0 || mask > 3)
+		return 0;
+	if (version <= 0 || version > MQRSPEC_VERSION_MAX)
+		return 0;
+	if (level == QR_ECLEVEL_H)
+		return 0;
+	type = typeTable[version][level];
+	if (type < 0)
+		return 0;
+
+	return formatInfo[mask][type];
+}
+
+/******************************************************************************
+ * Frame
+ *****************************************************************************/
+
+/**
+ * Cache of initial frames.
+ */
+/* C99 says that static storage shall be initialized to a null pointer
+ * by compiler. */
+static unsigned char *frames[MQRSPEC_VERSION_MAX + 1];
+#ifdef HAVE_LIBPTHREAD
+static pthread_mutex_t frames_mutex = PTHREAD_MUTEX_INITIALIZER;
+#endif
+
+/**
+ * Put a finder pattern.
+ * @param frame
+ * @param width
+ * @param ox,oy upper-left coordinate of the pattern
+ */
+static void putFinderPattern(unsigned char *frame, int width, int ox, int oy)
+{
+	static const unsigned char finder[] = {
+		0xc1, 0xc1, 0xc1, 0xc1, 0xc1, 0xc1, 0xc1,
+		0xc1, 0xc0, 0xc0, 0xc0, 0xc0, 0xc0, 0xc1,
+		0xc1, 0xc0, 0xc1, 0xc1, 0xc1, 0xc0, 0xc1,
+		0xc1, 0xc0, 0xc1, 0xc1, 0xc1, 0xc0, 0xc1,
+		0xc1, 0xc0, 0xc1, 0xc1, 0xc1, 0xc0, 0xc1,
+		0xc1, 0xc0, 0xc0, 0xc0, 0xc0, 0xc0, 0xc1,
+		0xc1, 0xc1, 0xc1, 0xc1, 0xc1, 0xc1, 0xc1,
+	};
+	int x, y;
+	const unsigned char *s;
+
+	frame += oy * width + ox;
+	s = finder;
+	for (y = 0; y < 7; y++) {
+		for (x = 0; x < 7; x++)
+			frame[x] = s[x];
+		frame += width;
+		s += 7;
+	}
+}
+
+static unsigned char *MQRspec_createFrame(int version)
+{
+	unsigned char *frame, *p, *q;
+	int width;
+	int x, y;
+
+	width = mqrspecCapacity[version].width;
+	frame = kmalloc(width * width, GFP_ATOMIC);
+	if (frame == NULL)
+		return NULL;
+
+	memset(frame, 0, width * width);
+	/* Finder pattern */
+	putFinderPattern(frame, width, 0, 0);
+	/* Separator */
+	p = frame;
+	for (y = 0; y < 7; y++) {
+		p[7] = 0xc0;
+		p += width;
+	}
+	memset(frame + width * 7, 0xc0, 8);
+	/* Mask format information area */
+	memset(frame + width * 8 + 1, 0x84, 8);
+	p = frame + width + 8;
+	for (y = 0; y < 7; y++) {
+		*p = 0x84;
+		p += width;
+	}
+	/* Timing pattern */
+	p = frame + 8;
+	q = frame + width * 8;
+	for (x = 1; x < width - 7; x++) {
+		*p = 0x90 | (x & 1);
+		*q = 0x90 | (x & 1);
+		p++;
+		q += width;
+	}
+
+	return frame;
+}
+
+unsigned char *MQRspec_newFrame(int version)
+{
+	unsigned char *frame;
+	int width;
+
+	if (version < 1 || version > MQRSPEC_VERSION_MAX)
+		return NULL;
+
+	if (frames[version] == NULL)
+		frames[version] = MQRspec_createFrame(version);
+	if (frames[version] == NULL)
+		return NULL;
+
+	width = mqrspecCapacity[version].width;
+	frame = kmalloc(width * width, GFP_ATOMIC);
+	if (frame == NULL)
+		return NULL;
+	memcpy(frame, frames[version], width * width);
+
+	return frame;
+}
+
+void MQRspec_clearCache(void)
+{
+	int i;
+
+	for (i = 1; i <= MQRSPEC_VERSION_MAX; i++) {
+		kfree(frames[i]);
+		frames[i] = NULL;
+	}
+}
diff --git a/lib/qr/mqrspec.h b/lib/qr/mqrspec.h
new file mode 100644
index 0000000..254cb56
--- /dev/null
+++ b/lib/qr/mqrspec.h
@@ -0,0 +1,155 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Micro QR Code specification in convenient format.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __MQRSPEC_H__
+#define __MQRSPEC_H__
+
+#include <linux/qrencode.h>
+
+/******************************************************************************
+ * Version and capacity
+ *****************************************************************************/
+
+/**
+ * Maximum width of a symbol
+ */
+#define MQRSPEC_WIDTH_MAX 17
+
+/**
+ * Return maximum data code length (bits) for the version.
+ * @param version
+ * @param level
+ * @return maximum size (bits)
+ */
+extern int MQRspec_getDataLengthBit(int version, enum QRecLevel level);
+
+/**
+ * Return maximum data code length (bytes) for the version.
+ * @param version
+ * @param level
+ * @return maximum size (bytes)
+ */
+extern int MQRspec_getDataLength(int version, enum QRecLevel level);
+
+/**
+ * Return maximum error correction code length (bytes) for the version.
+ * @param version
+ * @param level
+ * @return ECC size (bytes)
+ */
+extern int MQRspec_getECCLength(int version, enum QRecLevel level);
+
+/**
+ * Return a version number that satisfies the input code length.
+ * @param size input code length (byte)
+ * @param level
+ * @return version number
+ */
+extern int MQRspec_getMinimumVersion(int size, enum QRecLevel level);
+
+/**
+ * Return the width of the symbol for the version.
+ * @param version
+ * @return width
+ */
+extern int MQRspec_getWidth(int version);
+
+/**
+ * Return the numer of remainder bits.
+ * @param version
+ * @return number of remainder bits
+ */
+extern int MQRspec_getRemainder(int version);
+
+/******************************************************************************
+ * Length indicator
+ *****************************************************************************/
+
+/**
+ * Return the size of lenght indicator for the mode and version.
+ * @param mode
+ * @param version
+ * @return the size of the appropriate length indicator (bits).
+ */
+extern int MQRspec_lengthIndicator(enum QRencodeMode mode, int version);
+
+/**
+ * Return the maximum length for the mode and version.
+ * @param mode
+ * @param version
+ * @return the maximum length (bytes)
+ */
+extern int MQRspec_maximumWords(enum QRencodeMode mode, int version);
+
+/******************************************************************************
+ * Version information pattern
+ *****************************************************************************/
+
+/**
+ * Return BCH encoded version information pattern that is used for the symbol
+ * of version 7 or greater. Use lower 18 bits.
+ * @param version
+ * @return BCH encoded version information pattern
+ */
+extern unsigned int MQRspec_getVersionPattern(int version);
+
+/******************************************************************************
+ * Format information
+ *****************************************************************************/
+
+/**
+ * Return BCH encoded format information pattern.
+ * @param mask
+ * @param version
+ * @param level
+ * @return BCH encoded format information pattern
+ */
+extern unsigned int MQRspec_getFormatInfo(int mask, int version,
+					  enum QRecLevel level);
+
+/******************************************************************************
+ * Frame
+ *****************************************************************************/
+
+/**
+ * Return a copy of initialized frame.
+ * When the same version is requested twice or more, a copy of cached frame
+ * is returned.
+ * @param version
+ * @return Array of unsigned char. You can free it by free().
+ */
+extern unsigned char *MQRspec_newFrame(int version);
+
+/**
+ * Clear the frame cache. Typically for debug.
+ */
+extern void MQRspec_clearCache(void);
+
+/******************************************************************************
+ * Mode indicator
+ *****************************************************************************/
+
+/**
+ * Mode indicator. See Table 2 in Appendix 1 of JIS X0510:2004, pp.107.
+ */
+#define MQRSPEC_MODEID_NUM       0
+#define MQRSPEC_MODEID_AN        1
+#define MQRSPEC_MODEID_8         2
+#define MQRSPEC_MODEID_KANJI     3
+
+#endif /* __MQRSPEC_H__ */
diff --git a/lib/qr/qrencode.c b/lib/qr/qrencode.c
new file mode 100644
index 0000000..c0e7de7
--- /dev/null
+++ b/lib/qr/qrencode.c
@@ -0,0 +1,871 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Copyright (C) 2006-2012 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include "qrencode.h"
+#include "qrspec.h"
+#include "mqrspec.h"
+#include "bitstream.h"
+#include "qrinput.h"
+#include "rscode.h"
+#include "split.h"
+#include "mask.h"
+#include "mmask.h"
+
+/******************************************************************************
+ * Raw code
+ *****************************************************************************/
+
+struct RSblock {
+	int dataLength;
+	unsigned char *data;
+	int eccLength;
+	unsigned char *ecc;
+};
+
+struct QRRawCode {
+	int version;
+	int dataLength;
+	int eccLength;
+	unsigned char *datacode;
+	unsigned char *ecccode;
+	int b1;
+	int blocks;
+	struct RSblock *rsblock;
+	int count;
+};
+
+static void RSblock_initBlock(struct RSblock *block, int dl,
+			      unsigned char *data,
+			      int el, unsigned char *ecc, struct RS *rs)
+{
+	block->dataLength = dl;
+	block->data = data;
+	block->eccLength = el;
+	block->ecc = ecc;
+
+	encode_rs_char(rs, data, ecc);
+}
+
+static int RSblock_init(struct RSblock *blocks, int spec[5],
+			unsigned char *data,
+			unsigned char *ecc)
+{
+	int i;
+	struct RSblock *block;
+	unsigned char *dp, *ep;
+	struct RS *rs;
+	int el, dl;
+
+	dl = QRspec_rsDataCodes1(spec);
+	el = QRspec_rsEccCodes1(spec);
+	rs = init_rs(8, 0x11d, 0, 1, el, 255 - dl - el);
+	if (rs == NULL)
+		return -1;
+
+	block = blocks;
+	dp = data;
+	ep = ecc;
+	for (i = 0; i < QRspec_rsBlockNum1(spec); i++) {
+		RSblock_initBlock(block, dl, dp, el, ep, rs);
+		dp += dl;
+		ep += el;
+		block++;
+	}
+
+	if (QRspec_rsBlockNum2(spec) == 0)
+		return 0;
+
+	dl = QRspec_rsDataCodes2(spec);
+	el = QRspec_rsEccCodes2(spec);
+	rs = init_rs(8, 0x11d, 0, 1, el, 255 - dl - el);
+	if (rs == NULL)
+		return -1;
+	for (i = 0; i < QRspec_rsBlockNum2(spec); i++) {
+		RSblock_initBlock(block, dl, dp, el, ep, rs);
+		dp += dl;
+		ep += el;
+		block++;
+	}
+
+	return 0;
+}
+
+static void QRraw_free(struct QRRawCode *raw);
+static struct QRRawCode *QRraw_new(struct QRinput *input)
+{
+	struct QRRawCode *raw;
+	int spec[5], ret;
+
+	raw = kmalloc(sizeof(struct QRRawCode), GFP_ATOMIC);
+	if (raw == NULL)
+		return NULL;
+
+	raw->datacode = QRinput_getByteStream(input);
+	if (raw->datacode == NULL) {
+		kfree(raw);
+		return NULL;
+	}
+
+	QRspec_getEccSpec(input->version, input->level, spec);
+
+	raw->version = input->version;
+	raw->b1 = QRspec_rsBlockNum1(spec);
+	raw->dataLength = QRspec_rsDataLength(spec);
+	raw->eccLength = QRspec_rsEccLength(spec);
+	raw->ecccode = kmalloc(raw->eccLength, GFP_ATOMIC);
+	if (raw->ecccode == NULL) {
+		kfree(raw->datacode);
+		kfree(raw);
+		return NULL;
+	}
+
+	raw->blocks = QRspec_rsBlockNum(spec);
+	raw->rsblock = kcalloc(raw->blocks, sizeof(struct RSblock), GFP_ATOMIC);
+	if (raw->rsblock == NULL) {
+		QRraw_free(raw);
+		return NULL;
+	}
+	ret = RSblock_init(raw->rsblock, spec, raw->datacode, raw->ecccode);
+	if (ret < 0) {
+		QRraw_free(raw);
+		return NULL;
+	}
+
+	raw->count = 0;
+
+	return raw;
+}
+
+/**
+ * Return a code (byte).
+ * This function can be called iteratively.
+ * @param raw raw code.
+ * @return code
+ */
+static unsigned char QRraw_getCode(struct QRRawCode *raw)
+{
+	int col, row;
+	unsigned char ret;
+
+	if (raw->count < raw->dataLength) {
+		row = raw->count % raw->blocks;
+		col = raw->count / raw->blocks;
+		if (col >= raw->rsblock[0].dataLength)
+			row += raw->b1;
+		ret = raw->rsblock[row].data[col];
+	} else if (raw->count < raw->dataLength + raw->eccLength) {
+		row = (raw->count - raw->dataLength) % raw->blocks;
+		col = (raw->count - raw->dataLength) / raw->blocks;
+		ret = raw->rsblock[row].ecc[col];
+	} else {
+		return 0;
+	}
+	raw->count++;
+	return ret;
+}
+
+static void QRraw_free(struct QRRawCode *raw)
+{
+	if (raw != NULL) {
+		kfree(raw->datacode);
+		kfree(raw->ecccode);
+		kfree(raw->rsblock);
+		kfree(raw);
+	}
+}
+
+/******************************************************************************
+ * Raw code for Micro QR Code
+ *****************************************************************************/
+
+struct MQRRawCode {
+	int version;
+	int dataLength;
+	int eccLength;
+	unsigned char *datacode;
+	unsigned char *ecccode;
+	struct RSblock *rsblock;
+	int oddbits;
+	int count;
+};
+
+static void MQRraw_free(struct MQRRawCode *raw);
+static struct MQRRawCode *MQRraw_new(struct QRinput *input)
+{
+	struct MQRRawCode *raw;
+	struct RS *rs;
+
+	raw = kmalloc(sizeof(struct MQRRawCode), GFP_ATOMIC);
+	if (raw == NULL)
+		return NULL;
+
+	raw->version = input->version;
+	raw->dataLength = MQRspec_getDataLength(input->version, input->level);
+	raw->eccLength = MQRspec_getECCLength(input->version, input->level);
+	raw->oddbits =
+	    raw->dataLength * 8 - MQRspec_getDataLengthBit(input->version,
+							   input->level);
+	raw->datacode = QRinput_getByteStream(input);
+	if (raw->datacode == NULL) {
+		kfree(raw);
+		return NULL;
+	}
+	raw->ecccode = kmalloc(raw->eccLength, GFP_ATOMIC);
+	if (raw->ecccode == NULL) {
+		kfree(raw->datacode);
+		kfree(raw);
+		return NULL;
+	}
+
+	raw->rsblock = kcalloc(1, sizeof(struct RSblock), GFP_ATOMIC);
+	if (raw->rsblock == NULL) {
+		MQRraw_free(raw);
+		return NULL;
+	}
+
+	rs = init_rs(8, 0x11d, 0, 1, raw->eccLength,
+		     255 - raw->dataLength - raw->eccLength);
+	if (rs == NULL) {
+		MQRraw_free(raw);
+		return NULL;
+	}
+
+	RSblock_initBlock(raw->rsblock, raw->dataLength, raw->datacode,
+			  raw->eccLength, raw->ecccode, rs);
+
+	raw->count = 0;
+
+	return raw;
+}
+
+/**
+ * Return a code (byte).
+ * This function can be called iteratively.
+ * @param raw raw code.
+ * @return code
+ */
+static unsigned char MQRraw_getCode(struct MQRRawCode *raw)
+{
+	unsigned char ret;
+
+	if (raw->count < raw->dataLength)
+		ret = raw->datacode[raw->count];
+	else if (raw->count < raw->dataLength + raw->eccLength)
+		ret = raw->ecccode[raw->count - raw->dataLength];
+	else
+		return 0;
+
+	raw->count++;
+	return ret;
+}
+
+static void MQRraw_free(struct MQRRawCode *raw)
+{
+	if (raw != NULL) {
+		kfree(raw->datacode);
+		kfree(raw->ecccode);
+		kfree(raw->rsblock);
+		kfree(raw);
+	}
+}
+
+/******************************************************************************
+ * Frame filling
+ *****************************************************************************/
+
+struct FrameFiller {
+	int width;
+	unsigned char *frame;
+	int x, y;
+	int dir;
+	int bit;
+	int mqr;
+};
+
+static struct FrameFiller *FrameFiller_new(int width, unsigned char *frame,
+					   int mqr)
+{
+	struct FrameFiller *filler;
+
+	filler = kmalloc(sizeof(struct FrameFiller), GFP_ATOMIC);
+	if (filler == NULL)
+		return NULL;
+	filler->width = width;
+	filler->frame = frame;
+	filler->x = width - 1;
+	filler->y = width - 1;
+	filler->dir = -1;
+	filler->bit = -1;
+	filler->mqr = mqr;
+
+	return filler;
+}
+
+static unsigned char *FrameFiller_next(struct FrameFiller *filler)
+{
+	unsigned char *p;
+	int x, y, w;
+
+	if (filler->bit == -1) {
+		filler->bit = 0;
+		return filler->frame + filler->y * filler->width + filler->x;
+	}
+
+	x = filler->x;
+	y = filler->y;
+	p = filler->frame;
+	w = filler->width;
+
+	if (filler->bit == 0) {
+		x--;
+		filler->bit++;
+	} else {
+		x++;
+		y += filler->dir;
+		filler->bit--;
+	}
+
+	if (filler->dir < 0) {
+		if (y < 0) {
+			y = 0;
+			x -= 2;
+			filler->dir = 1;
+			if (!filler->mqr && x == 6) {
+				x--;
+				y = 9;
+			}
+		}
+	} else {
+		if (y == w) {
+			y = w - 1;
+			x -= 2;
+			filler->dir = -1;
+			if (!filler->mqr && x == 6) {
+				x--;
+				y -= 8;
+			}
+		}
+	}
+	if (x < 0 || y < 0)
+		return NULL;
+
+	filler->x = x;
+	filler->y = y;
+
+	if (p[y * w + x] & 0x80) {
+		/* This tail recursion could be optimized. */
+		return FrameFiller_next(filler);
+	}
+	return &p[y * w + x];
+}
+
+/******************************************************************************
+ * QR-code encoding
+ *****************************************************************************/
+
+static struct QRcode *QRcode_new(int version, int width, unsigned char *data)
+{
+	struct QRcode *qrcode;
+
+	qrcode = kmalloc(sizeof(struct QRcode), GFP_ATOMIC);
+	if (qrcode == NULL)
+		return NULL;
+
+	qrcode->version = version;
+	qrcode->width = width;
+	qrcode->data = data;
+
+	return qrcode;
+}
+
+void QRcode_free(struct QRcode *qrcode)
+{
+	if (qrcode != NULL) {
+		kfree(qrcode->data);
+		kfree(qrcode);
+	}
+}
+EXPORT_SYMBOL_GPL(QRcode_free);
+
+static struct QRcode *QRcode_encodeMask(struct QRinput *input, int mask)
+{
+	int width, version;
+	struct QRRawCode *raw;
+	unsigned char *frame, *masked, *p, code, bit;
+	struct FrameFiller *filler;
+	int i, j;
+	struct QRcode *qrcode = NULL;
+
+	if (input->mqr)
+		return NULL;
+
+	if (input->version < 0 || input->version > QRSPEC_VERSION_MAX)
+		return NULL;
+
+	if (input->level > QR_ECLEVEL_H)
+		return NULL;
+
+	raw = QRraw_new(input);
+	if (raw == NULL)
+		return NULL;
+
+	version = raw->version;
+	width = QRspec_getWidth(version);
+	frame = QRspec_newFrame(version);
+	if (frame == NULL) {
+		QRraw_free(raw);
+		return NULL;
+	}
+	filler = FrameFiller_new(width, frame, 0);
+	if (filler == NULL) {
+		QRraw_free(raw);
+		kfree(frame);
+		return NULL;
+	}
+
+	/* inteleaved data and ecc codes */
+	for (i = 0; i < raw->dataLength + raw->eccLength; i++) {
+		code = QRraw_getCode(raw);
+		bit = 0x80;
+		for (j = 0; j < 8; j++) {
+			p = FrameFiller_next(filler);
+			if (p == NULL)
+				goto EXIT;
+			*p = 0x02 | ((bit & code) != 0);
+			bit = bit >> 1;
+		}
+	}
+	QRraw_free(raw);
+	raw = NULL;
+	/* remainder bits */
+	j = QRspec_getRemainder(version);
+	for (i = 0; i < j; i++) {
+		p = FrameFiller_next(filler);
+		if (p == NULL)
+			goto EXIT;
+		*p = 0x02;
+	}
+
+	/* masking */
+	if (mask < 0)
+		masked = Mask_mask(width, frame, input->level);
+	else
+		masked = Mask_makeMask(width, frame, mask, input->level);
+
+	if (masked == NULL)
+		goto EXIT;
+
+	qrcode = QRcode_new(version, width, masked);
+
+EXIT:
+	QRraw_free(raw);
+	kfree(filler);
+	kfree(frame);
+	return qrcode;
+}
+
+static struct QRcode *QRcode_encodeMaskMQR(struct QRinput *input, int mask)
+{
+	int width, version;
+	struct MQRRawCode *raw;
+	unsigned char *frame, *masked, *p, code, bit;
+	struct FrameFiller *filler;
+	int i, j;
+	struct QRcode *qrcode = NULL;
+
+	if (!input->mqr)
+		return NULL;
+
+	if (input->version <= 0 || input->version > MQRSPEC_VERSION_MAX)
+		return NULL;
+
+	if (input->level > QR_ECLEVEL_Q)
+		return NULL;
+
+	raw = MQRraw_new(input);
+	if (raw == NULL)
+		return NULL;
+
+	version = raw->version;
+	width = MQRspec_getWidth(version);
+	frame = MQRspec_newFrame(version);
+	if (frame == NULL) {
+		MQRraw_free(raw);
+		return NULL;
+	}
+	filler = FrameFiller_new(width, frame, 1);
+	if (filler == NULL) {
+		MQRraw_free(raw);
+		kfree(frame);
+		return NULL;
+	}
+
+	/* inteleaved data and ecc codes */
+	for (i = 0; i < raw->dataLength + raw->eccLength; i++) {
+		code = MQRraw_getCode(raw);
+		if (raw->oddbits && i == raw->dataLength - 1) {
+			bit = 1 << (raw->oddbits - 1);
+			for (j = 0; j < raw->oddbits; j++) {
+				p = FrameFiller_next(filler);
+				if (p == NULL)
+					goto EXIT;
+				*p = 0x02 | ((bit & code) != 0);
+				bit = bit >> 1;
+			}
+		} else {
+			bit = 0x80;
+			for (j = 0; j < 8; j++) {
+				p = FrameFiller_next(filler);
+				if (p == NULL)
+					goto EXIT;
+				*p = 0x02 | ((bit & code) != 0);
+				bit = bit >> 1;
+			}
+		}
+	}
+	MQRraw_free(raw);
+	raw = NULL;
+
+	/* masking */
+	if (mask < 0)
+		masked = MMask_mask(version, frame, input->level);
+	else
+		masked = MMask_makeMask(version, frame, mask, input->level);
+
+	if (masked == NULL)
+		goto EXIT;
+
+	qrcode = QRcode_new(version, width, masked);
+
+EXIT:
+	MQRraw_free(raw);
+	kfree(filler);
+	kfree(frame);
+	return qrcode;
+}
+
+struct QRcode *QRcode_encodeInput(struct QRinput *input)
+{
+	if (input->mqr)
+		return QRcode_encodeMaskMQR(input, -1);
+	else
+		return QRcode_encodeMask(input, -1);
+
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeInput);
+
+static struct QRcode *QRcode_encodeStringReal(const char *string, int version,
+				       enum QRecLevel level, int mqr,
+				       enum QRencodeMode hint,
+				       int casesensitive)
+{
+	struct QRinput *input;
+	struct QRcode *code;
+	int ret;
+
+	if (string == NULL)
+		return NULL;
+
+	if (hint != QR_MODE_8 && hint != QR_MODE_KANJI)
+		return NULL;
+
+
+	if (mqr)
+		input = QRinput_newMQR(version, level);
+	else
+		input = QRinput_new2(version, level);
+
+	if (input == NULL)
+		return NULL;
+
+	ret = Split_splitStringToQRinput(string, input, hint, casesensitive);
+	if (ret < 0) {
+		QRinput_free(input);
+		return NULL;
+	}
+	code = QRcode_encodeInput(input);
+	QRinput_free(input);
+
+	return code;
+}
+
+struct QRcode *QRcode_encodeString(const char *string, int version,
+				   enum QRecLevel level, enum QRencodeMode hint,
+				   int casesensitive)
+{
+	return QRcode_encodeStringReal(string, version, level, 0, hint,
+				       casesensitive);
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeString);
+
+struct QRcode *QRcode_encodeStringMQR(const char *string, int version,
+				      enum QRecLevel level,
+				      enum QRencodeMode hint,
+				      int casesensitive)
+{
+	return QRcode_encodeStringReal(string, version, level, 1, hint,
+				       casesensitive);
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeStringMQR);
+
+static struct QRcode *QRcode_encodeDataReal(const unsigned char *data,
+					    int length, int version,
+					    enum QRecLevel level, int mqr)
+{
+	struct QRinput *input;
+	struct QRcode *code;
+	int ret;
+
+	if (data == NULL || length == 0)
+		return NULL;
+
+	if (mqr)
+		input = QRinput_newMQR(version, level);
+	else
+		input = QRinput_new2(version, level);
+
+	if (input == NULL)
+		return NULL;
+
+	ret = QRinput_append(input, QR_MODE_8, length, data);
+	if (ret < 0) {
+		QRinput_free(input);
+		return NULL;
+	}
+	code = QRcode_encodeInput(input);
+	QRinput_free(input);
+
+	return code;
+}
+
+struct QRcode *QRcode_encodeData(int size, const unsigned char *data,
+				 int version, enum QRecLevel level)
+{
+	return QRcode_encodeDataReal(data, size, version, level, 0);
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeData);
+
+struct QRcode *QRcode_encodeString8bit(const char *string, int version,
+				enum QRecLevel level)
+{
+	if (string == NULL)
+		return NULL;
+
+	return QRcode_encodeDataReal((unsigned char *)string, strlen(string),
+				     version, level, 0);
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeString8bit);
+
+struct QRcode *QRcode_encodeDataMQR(int size, const unsigned char *data,
+				    int version, enum QRecLevel level)
+{
+	return QRcode_encodeDataReal(data, size, version, level, 1);
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeDataMQR);
+
+struct QRcode *QRcode_encodeString8bitMQR(const char *string, int version,
+				   enum QRecLevel level)
+{
+	if (string == NULL)
+		return NULL;
+
+	return QRcode_encodeDataReal((unsigned char *)string, strlen(string),
+				     version, level, 1);
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeString8bitMQR);
+
+/******************************************************************************
+ * Structured QR-code encoding
+ *****************************************************************************/
+
+static struct QRcode_List *QRcode_List_newEntry(void)
+{
+	struct QRcode_List *entry;
+
+	entry = kmalloc(sizeof(struct QRcode_List), GFP_ATOMIC);
+	if (entry == NULL)
+		return NULL;
+
+	entry->next = NULL;
+	entry->code = NULL;
+
+	return entry;
+}
+
+static void QRcode_List_freeEntry(struct QRcode_List *entry)
+{
+	if (entry != NULL) {
+		QRcode_free(entry->code);
+		kfree(entry);
+	}
+}
+
+void QRcode_List_free(struct QRcode_List *qrlist)
+{
+	struct QRcode_List *list = qrlist, *next;
+
+	while (list != NULL) {
+		next = list->next;
+		QRcode_List_freeEntry(list);
+		list = next;
+	}
+}
+EXPORT_SYMBOL_GPL(QRcode_List_free);
+
+int QRcode_List_size(struct QRcode_List *qrlist)
+{
+	struct QRcode_List *list = qrlist;
+	int size = 0;
+
+	while (list != NULL) {
+		size++;
+		list = list->next;
+	}
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(QRcode_List_size);
+
+struct QRcode_List *QRcode_encodeInputStructured(struct QRinput_Struct *s)
+{
+	struct QRcode_List *head = NULL;
+	struct QRcode_List *tail = NULL;
+	struct QRcode_List *entry;
+	struct QRinput_InputList *list = s->head;
+
+	while (list != NULL) {
+		if (head == NULL) {
+			entry = QRcode_List_newEntry();
+			if (entry == NULL)
+				goto ABORT;
+			head = entry;
+			tail = head;
+		} else {
+			entry = QRcode_List_newEntry();
+			if (entry == NULL)
+				goto ABORT;
+			tail->next = entry;
+			tail = tail->next;
+		}
+		tail->code = QRcode_encodeInput(list->input);
+		if (tail->code == NULL)
+			goto ABORT;
+		list = list->next;
+	}
+
+	return head;
+ABORT:
+	QRcode_List_free(head);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeInputStructured);
+
+static struct QRcode_List *QRcode_encodeInputToStructured(struct QRinput *input)
+{
+	struct QRinput_Struct *s;
+	struct QRcode_List *codes;
+
+	s = QRinput_splitQRinputToStruct(input);
+	if (s == NULL)
+		return NULL;
+
+	codes = QRcode_encodeInputStructured(s);
+	QRinput_Struct_free(s);
+
+	return codes;
+}
+
+static struct QRcode_List *QRcode_encodeDataStructuredReal(int size,
+						    const unsigned char *data,
+						    int version,
+						    enum QRecLevel level,
+						    int eightbit,
+						    enum QRencodeMode hint,
+						    int casesensitive)
+{
+	struct QRinput *input;
+	struct QRcode_List *codes;
+	int ret;
+
+	if (version <= 0)
+		return NULL;
+
+	if (!eightbit && (hint != QR_MODE_8 && hint != QR_MODE_KANJI))
+		return NULL;
+
+	input = QRinput_new2(version, level);
+	if (input == NULL)
+		return NULL;
+
+	if (eightbit) {
+		ret = QRinput_append(input, QR_MODE_8, size, data);
+	} else {
+		ret =
+		    Split_splitStringToQRinput((char *)data, input, hint,
+					       casesensitive);
+	}
+	if (ret < 0) {
+		QRinput_free(input);
+		return NULL;
+	}
+	codes = QRcode_encodeInputToStructured(input);
+	QRinput_free(input);
+
+	return codes;
+}
+
+struct QRcode_List *QRcode_encodeDataStructured(int size,
+						const unsigned char *data,
+						int version,
+						enum QRecLevel level)
+{
+	return QRcode_encodeDataStructuredReal(size, data, version, level, 1,
+					       QR_MODE_NUL, 0);
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeDataStructured);
+
+struct QRcode_List *QRcode_encodeString8bitStructured(const char *string,
+						      int version,
+						      enum QRecLevel level)
+{
+	if (string == NULL)
+		return NULL;
+
+	return QRcode_encodeDataStructured(strlen(string),
+					   (unsigned char *)string, version,
+					   level);
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeString8bitStructured);
+
+struct QRcode_List
+*QRcode_encodeStringStructured(const char *string, int version,
+			       enum QRecLevel level, enum QRencodeMode hint,
+			       int casesensitive)
+{
+	if (string == NULL)
+		return NULL;
+
+	return QRcode_encodeDataStructuredReal(strlen(string),
+					       (unsigned char *)string, version,
+					       level, 0, hint, casesensitive);
+}
+EXPORT_SYMBOL_GPL(QRcode_encodeStringStructured);
+
diff --git a/lib/qr/qrencode.h b/lib/qr/qrencode.h
new file mode 100644
index 0000000..e643274
--- /dev/null
+++ b/lib/qr/qrencode.h
@@ -0,0 +1,546 @@
+/**
+ * qrencode - QR Code encoder
+ *
+ * Copyright (C) 2006-2012 Kentaro Fukuchi <kentaro@fukuchi.org>
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+/** \mainpage
+ * Libqrencode is a library for encoding data in a QR Code symbol, a kind of 2D
+ * symbology.
+ *
+ * \section encoding Encoding
+ *
+ * There are two methods to encode data: <b>encoding a string/data</b> or
+ * <b>encoding a structured data</b>.
+ *
+ * \subsection encoding-string Encoding a string/data
+ * You can encode a string by calling QRcode_encodeString().
+ * The given string is parsed automatically and encoded. If you want to encode
+ * data that can be represented as a C string style (NUL terminated), you can
+ * simply use this way.
+ *
+ * If the input data contains Kanji (Shift-JIS) characters and you want to
+ * encode them as Kanji in QR Code, you should give QR_MODE_KANJI as a hint.
+ * Otherwise, all of non-alphanumeric characters are encoded as 8 bit data.
+ * If you want to encode a whole string in 8 bit mode, you can use
+ * QRcode_encodeString8bit() instead.
+ *
+ * Please note that a C string can not contain NUL characters. If your data
+ * contains NUL, you must use QRcode_encodeData().
+ *
+ * \subsection encoding-input Encoding a structured data
+ * You can construct a structured input data manually. If the structure of the
+ * input data is known, you can use this way.
+ * At first, create a ::QRinput object by QRinput_new(). Then add input data
+ * to the QRinput object by QRinput_append(). Finally call QRcode_encodeInput()
+ * to encode the QRinput data.
+ * You can reuse the QRinput data again to encode it in other symbols with
+ * different parameters.
+ *
+ * \section result Result
+ * The encoded symbol is resulted as a ::QRcode object. It will contain
+ * its version number, width of the symbol and an array represents the symbol.
+ * See ::QRcode for the details. You can free the object by QRcode_free().
+ *
+ * Please note that the version of the result may be larger than specified.
+ * In such cases, the input data would be too large to be encoded in a
+ * symbol of the specified version.
+ *
+ * \section structured Structured append
+ * Libqrencode can generate "Structured-appended" symbols that enables to split
+ * a large data set into mulitple QR codes. A QR code reader concatenates
+ * multiple QR code symbols into a string.
+ * Just like QRcode_encodeString(), you can use QRcode_encodeStringStructured()
+ * to generate structured-appended symbols. This functions returns an instance
+ * of ::QRcode_List. The returned list is a singly-linked list of QRcode: you
+ * can retrieve each QR code in this way:
+ *
+ * \code
+ * QRcode_List *qrcodes;
+ * QRcode_List *entry;
+ * QRcode *qrcode;
+ *
+ * qrcodes = QRcode_encodeStringStructured(...);
+ * entry = qrcodes;
+ * while(entry != NULL) {
+ *     qrcode = entry->code;
+ *     // do something
+ *     entry = entry->next;
+ * }
+ * QRcode_List_free(entry);
+ * \endcode
+ *
+ * Instead of using auto-parsing functions, you can construct your own
+ * structured input. At first, instantiate an object of ::QRinput_Struct
+ * by calling QRinput_Struct_new(). This object can hold multiple ::QRinput,
+ * and one QR code is generated for a ::QRinput.
+ * QRinput_Struct_appendInput() appends a ::QRinput to a ::QRinput_Struct
+ * object. In order to generate structured-appended symbols, it is required to
+ * embed headers to each symbol. You can use
+ * QRinput_Struct_insertStructuredAppendHeaders() to insert appropriate
+ * headers to each symbol. You should call this function just once before
+ * encoding symbols.
+ */
+
+#ifndef __QRENCODE_H__
+#define __QRENCODE_H__
+
+#if defined(__cplusplus)
+extern "C" {
+#endif
+
+/**
+ * Encoding mode.
+ */
+enum QRencodeMode {
+	QR_MODE_NUL = -1,   /* Terminator (NUL character). Internal use only */
+	QR_MODE_NUM = 0,    /* Numeric mode */
+	QR_MODE_AN,         /* Alphabet-numeric mode */
+	QR_MODE_8,          /* 8-bit data mode */
+	QR_MODE_KANJI,      /* Kanji (shift-jis) mode */
+	QR_MODE_STRUCTURE,  /* Internal use only */
+	QR_MODE_ECI,        /* ECI mode */
+	QR_MODE_FNC1FIRST,  /* FNC1, first position */
+	QR_MODE_FNC1SECOND, /* FNC1, second position */
+};
+
+/**
+ * Level of error correction.
+ */
+enum QRecLevel {
+	QR_ECLEVEL_L = 0, /* lowest */
+	QR_ECLEVEL_M,
+	QR_ECLEVEL_Q,
+	QR_ECLEVEL_H      /* highest */
+};
+
+/**
+ * Maximum version (size) of QR-code symbol.
+ */
+#define QRSPEC_VERSION_MAX 40
+
+/**
+ * Maximum version (size) of QR-code symbol.
+ */
+#define MQRSPEC_VERSION_MAX 4
+
+
+/******************************************************************************
+ * Input data (qrinput.c)
+ *****************************************************************************/
+/**
+ * Instantiate an input data object. The version is set to 0 (auto-select)
+ * and the error correction level is set to QR_ECLEVEL_L.
+ * @return an input object (initialized). On error, NULL is returned and errno
+ *         is set to indicate the error.
+ * @throw ENOMEM unable to allocate memory.
+ */
+extern struct QRinput *QRinput_new(void);
+
+/**
+ * Instantiate an input data object.
+ * @param version version number.
+ * @param level Error correction level.
+ * @return an input object (initialized). On error, NULL is returned and errno
+ *         is set to indicate the error.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ * @throw EINVAL invalid arguments.
+ */
+extern struct QRinput *QRinput_new2(int version, enum QRecLevel level);
+
+/**
+ * Instantiate an input data object. Object's Micro QR Code flag is set.
+ * Unlike with full-sized QR Code, version number must be specified (>0).
+ * @param version version number (1--4).
+ * @param level Error correction level.
+ * @return an input object (initialized). On error, NULL is returned and errno
+ *         is set to indicate the error.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ * @throw EINVAL invalid arguments.
+ */
+extern struct QRinput *QRinput_newMQR(int version, enum QRecLevel level);
+
+/**
+ * Append data to an input object.
+ * The data is copied and appended to the input object.
+ * @param input input object.
+ * @param mode encoding mode.
+ * @param size size of data (byte).
+ * @param data a pointer to the memory area of the input data.
+ * @retval 0 success.
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw EINVAL input data is invalid.
+ *
+ */
+extern int QRinput_append(struct QRinput *input, enum QRencodeMode mode,
+			  int size, const unsigned char *data);
+
+/**
+ * Append ECI header.
+ * @param input input object.
+ * @param ecinum ECI indicator number (0 - 999999)
+ * @retval 0 success.
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw EINVAL input data is invalid.
+ *
+ */
+extern int QRinput_appendECIheader(struct QRinput *input, unsigned int ecinum);
+
+/**
+ * Get current version.
+ * @param input input object.
+ * @return current version.
+ */
+extern int QRinput_getVersion(struct QRinput *input);
+
+/**
+ * Set version of the QR code that is to be encoded.
+ * This function cannot be applied to Micro QR Code.
+ * @param input input object.
+ * @param version version number (0 = auto)
+ * @retval 0 success.
+ * @retval -1 invalid argument.
+ */
+extern int QRinput_setVersion(struct QRinput *input, int version);
+
+/**
+ * Get current error correction level.
+ * @param input input object.
+ * @return Current error correcntion level.
+ */
+extern enum QRecLevel QRinput_getErrorCorrectionLevel(struct QRinput *input);
+
+/**
+ * Set error correction level of the QR code that is to be encoded.
+ * This function cannot be applied to Micro QR Code.
+ * @param input input object.
+ * @param level Error correction level.
+ * @retval 0 success.
+ * @retval -1 invalid argument.
+ */
+extern int QRinput_setErrorCorrectionLevel(struct QRinput *input,
+					   enum QRecLevel level);
+
+/**
+ * Set version and error correction level of the QR code at once.
+ * This function is recommened for Micro QR Code.
+ * @param input input object.
+ * @param version version number (0 = auto)
+ * @param level Error correction level.
+ * @retval 0 success.
+ * @retval -1 invalid argument.
+ */
+extern int
+QRinput_setVersionAndErrorCorrectionLevel(struct QRinput *input, int version,
+					  enum QRecLevel level);
+
+/**
+ * Free the input object.
+ * All of data chunks in the input object are freed too.
+ * @param input input object.
+ */
+extern void QRinput_free(struct QRinput *input);
+
+/**
+ * Validate the input data.
+ * @param mode encoding mode.
+ * @param size size of data (byte).
+ * @param data a pointer to the memory area of the input data.
+ * @retval 0 success.
+ * @retval -1 invalid arguments.
+ */
+extern int QRinput_check(enum QRencodeMode mode, int size,
+			 const unsigned char *data);
+
+/**
+ * Instantiate a set of input data object.
+ * @return an instance of QRinput_Struct. On error, NULL is returned and errno
+ *         is set to indicate the error.
+ * @throw ENOMEM unable to allocate memory.
+ */
+extern struct QRinput_Struct *QRinput_Struct_new(void);
+
+/**
+ * Set parity of structured symbols.
+ * @param s structured input object.
+ * @param parity parity of s.
+ */
+extern void QRinput_Struct_setParity(struct QRinput_Struct *s,
+				     unsigned char parity);
+
+/**
+ * Append a QRinput object to the set. QRinput created by QRinput_newMQR()
+ * will be rejected.
+ * @warning never append the same QRinput object twice or more.
+ * @param s structured input object.
+ * @param input an input object.
+ * @retval >0 number of input objects in the structure.
+ * @retval -1 an error occurred. See Exceptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw EINVAL invalid arguments.
+ */
+extern int QRinput_Struct_appendInput(struct QRinput_Struct *s,
+				      struct QRinput *input);
+
+/**
+ * Free all of QRinput in the set.
+ * @param s a structured input object.
+ */
+extern void QRinput_Struct_free(struct QRinput_Struct *s);
+
+/**
+ * Split a QRinput to QRinput_Struct. It calculates a parity, set it, then
+ * insert structured-append headers. QRinput created by QRinput_newMQR() will
+ * be rejected.
+ * @param input input object. Version number and error correction level must be
+ *        set.
+ * @return a set of input data. On error, NULL is returned, and errno is set
+ *         to indicate the error. See Exceptions for the details.
+ * @throw ERANGE input data is too large.
+ * @throw EINVAL invalid input data.
+ * @throw ENOMEM unable to allocate memory.
+ */
+extern struct QRinput_Struct
+*QRinput_splitQRinputToStruct(struct QRinput *input);
+
+/**
+ * Insert structured-append headers to the input structure. It calculates
+ * a parity and set it if the parity is not set yet.
+ * @param s input structure
+ * @retval 0 success.
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory.
+ */
+extern int
+QRinput_Struct_insertStructuredAppendHeaders(struct QRinput_Struct *s);
+
+/**
+ * Set FNC1-1st position flag.
+ */
+extern int QRinput_setFNC1First(struct QRinput *input);
+
+/**
+ * Set FNC1-2nd position flag and application identifier.
+ */
+extern int QRinput_setFNC1Second(struct QRinput *input, unsigned char appid);
+
+/******************************************************************************
+ * QRcode output (qrencode.c)
+ *****************************************************************************/
+
+/**
+ * QRcode class.
+ * Symbol data is represented as an array contains width*width uchars.
+ * Each uchar represents a module (dot). If the less significant bit of
+ * the uchar is 1, the corresponding module is black. The other bits are
+ * meaningless for usual applications, but here its specification is described.
+ *
+ * <pre>
+ * MSB 76543210 LSB
+ *     |||||||`- 1=black/0=white
+ *     ||||||`-- data and ecc code area
+ *     |||||`--- format information
+ *     ||||`---- version information
+ *     |||`----- timing pattern
+ *     ||`------ alignment pattern
+ *     |`------- finder pattern and separator
+ *     `-------- non-data modules (format, timing, etc.)
+ * </pre>
+ */
+struct QRcode {
+	int version;         /* version of the symbol */
+	int width;           /* width of the symbol */
+	unsigned char *data; /* symbol data */
+};
+
+/**
+ * Singly-linked list of QRcode. Used to represent a structured symbols.
+ * A list is terminated with NULL.
+ */
+struct QRcode_List {
+	struct QRcode *code;
+	struct QRcode_List *next;
+};
+
+/**
+ * Create a symbol from the input data.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param input input data.
+ * @return an instance of QRcode class. The version of the result QRcode may
+ *         be larger than the designated version. On error, NULL is returned,
+ *         and errno is set to indicate the error. See Exceptions for the
+ *         details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ */
+extern struct QRcode *QRcode_encodeInput(struct QRinput *input);
+
+/**
+ * Create a symbol from the string. The library automatically parses the input
+ * string and encodes in a QR Code symbol.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param string input string. It must be NUL terminated.
+ * @param version version of the symbol. If 0, the library chooses the minimum
+ *                version for the given input data.
+ * @param level error correction level.
+ * @param hint tell the library how Japanese Kanji characters should be
+ *             encoded. If QR_MODE_KANJI is given, the library assumes that the
+ *             given string contains Shift-JIS characters and encodes them in
+ *             Kanji-mode. If QR_MODE_8 is given, all of non-alphanumerical
+ *             characters will be encoded as is. If you want to embed UTF-8
+ *             string, choose this. Other mode will cause EINVAL error.
+ * @param casesensitive case-sensitive(1) or not(0).
+ * @return an instance of QRcode class. The version of the result QRcode may
+ *         be larger than the designated version. On error, NULL is returned,
+ *         and errno is set to indicate the error. See Exceptions for the
+ *         details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ * @throw ERANGE input data is too large.
+ */
+extern struct QRcode
+*QRcode_encodeString(const char *string, int version,
+		     enum QRecLevel level, enum QRencodeMode hint,
+		     int casesensitive);
+
+/**
+ * Same to QRcode_encodeString(), but encode whole data in 8-bit mode.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode
+*QRcode_encodeString8bit(const char *string, int version,
+			 enum QRecLevel level);
+
+/**
+ * Micro QR Code version of QRcode_encodeString().
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode
+*QRcode_encodeStringMQR(const char *string, int version, enum QRecLevel level,
+			enum QRencodeMode hint, int casesensitive);
+
+/**
+ * Micro QR Code version of QRcode_encodeString8bit().
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode
+*QRcode_encodeString8bitMQR(const char *string, int version,
+			    enum QRecLevel level);
+
+/**
+ * Encode byte stream (may include '\0') in 8-bit mode.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param size size of the input data.
+ * @param data input data.
+ * @param version version of the symbol. If 0, the library chooses the minimum
+ *                version for the given input data.
+ * @param level error correction level.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ * @throw ERANGE input data is too large.
+ */
+extern struct QRcode
+*QRcode_encodeData(int size, const unsigned char *data,
+		   int version, enum QRecLevel level);
+
+/**
+ * Micro QR Code version of QRcode_encodeData().
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode
+*QRcode_encodeDataMQR(int size, const unsigned char *data,
+		      int version, enum QRecLevel level);
+
+/**
+ * Free the instance of QRcode class.
+ * @param qrcode an instance of QRcode class.
+ */
+extern void QRcode_free(struct QRcode *qrcode);
+
+/**
+ * Create structured symbols from the input data.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param s
+ * @return a singly-linked list of QRcode.
+ */
+extern struct QRcode_List
+*QRcode_encodeInputStructured(struct QRinput_Struct *s);
+
+/**
+ * Create structured symbols from the string. The library automatically parses
+ * the input string and encodes in a QR Code symbol.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param string input string. It must be NUL terminated.
+ * @param version version of the symbol.
+ * @param level error correction level.
+ * @param hint tell the library how Japanese Kanji characters should be
+ *             encoded. If QR_MODE_KANJI is given, the library assumes that the
+ *             given string contains Shift-JIS characters and encodes them in
+ *             Kanji-mode. If QR_MODE_8 is given, all of non-alphanumerical
+ *             characters will be encoded as is. If you want to embed UTF-8
+ *             string, choose this. Other mode will cause EINVAL error.
+ * @param casesensitive case-sensitive(1) or not(0).
+ * @return a singly-linked list of QRcode. On error, NULL is returned, and
+ *         errno is set to indicate the error. See Exceptions for the details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ */
+extern struct QRcode_List
+*QRcode_encodeStringStructured(const char *string, int version,
+			       enum QRecLevel level, enum QRencodeMode hint,
+			       int casesensitive);
+
+/**
+ * Same to QRcode_encodeStringStructured(), but encode whole data in 8-bit mode.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ */
+extern struct QRcode_List
+*QRcode_encodeString8bitStructured(const char *string, int version,
+				   enum QRecLevel level);
+
+/**
+ * Create structured symbols from byte stream (may include '\0'). Wholde data
+ * are encoded in 8-bit mode.
+ * @warning This function is THREAD UNSAFE when pthread is disabled.
+ * @param size size of the input data.
+ * @param data input dat.
+ * @param version version of the symbol.
+ * @param level error correction level.
+ * @return a singly-linked list of QRcode. On error, NULL is returned, and
+ *         errno is set to indicate the error. See Exceptions for the details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ */
+extern struct QRcode_List
+*QRcode_encodeDataStructured(int size, const unsigned char *data,
+			     int version, enum QRecLevel level);
+
+/**
+ * Return the number of symbols included in a QRcode_List.
+ * @param qrlist a head entry of a QRcode_List.
+ * @return number of symbols in the list.
+ */
+extern int QRcode_List_size(struct QRcode_List *qrlist);
+
+/**
+ * Free the QRcode_List.
+ * @param qrlist a head entry of a QRcode_List.
+ */
+extern void QRcode_List_free(struct QRcode_List *qrlist);
+
+#endif /* __QRENCODE_H__ */
diff --git a/lib/qr/qrinput.c b/lib/qr/qrinput.c
new file mode 100644
index 0000000..243bafb
--- /dev/null
+++ b/lib/qr/qrinput.c
@@ -0,0 +1,1834 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Input data chunk class
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <linux/qrencode.h>
+#include "qrspec.h"
+#include "mqrspec.h"
+#include "bitstream.h"
+#include "qrinput.h"
+
+/******************************************************************************
+ * Utilities
+ *****************************************************************************/
+int QRinput_isSplittableMode(enum QRencodeMode mode)
+{
+	return mode >= QR_MODE_NUM && mode <= QR_MODE_KANJI;
+}
+
+/******************************************************************************
+ * Entry of input data
+ *****************************************************************************/
+
+static
+struct QRinput_List *QRinput_List_newEntry(enum QRencodeMode mode,
+					   int size,
+					   const unsigned char *data)
+{
+	struct QRinput_List *entry;
+
+	if (QRinput_check(mode, size, data))
+		return NULL;
+
+	entry = kmalloc(sizeof(struct QRinput_List), GFP_ATOMIC);
+	if (entry == NULL)
+		return NULL;
+
+	entry->mode = mode;
+	entry->size = size;
+	if (size > 0) {
+		entry->data = kmalloc(size, GFP_ATOMIC);
+		if (entry->data == NULL) {
+			kfree(entry);
+			return NULL;
+		}
+		memcpy(entry->data, data, size);
+	}
+	entry->bstream = NULL;
+	entry->next = NULL;
+
+	return entry;
+}
+
+static void QRinput_List_freeEntry(struct QRinput_List *entry)
+{
+	if (entry != NULL) {
+		kfree(entry->data);
+		BitStream_free(entry->bstream);
+		kfree(entry);
+	}
+}
+
+static struct QRinput_List *QRinput_List_dup(struct QRinput_List *entry)
+{
+	struct QRinput_List *n;
+
+	n = kmalloc(sizeof(struct QRinput_List), GFP_ATOMIC);
+	if (n == NULL)
+		return NULL;
+
+	n->mode = entry->mode;
+	n->size = entry->size;
+	n->data = kmalloc(n->size, GFP_ATOMIC);
+	if (n->data == NULL) {
+		kfree(n);
+		return NULL;
+	}
+	memcpy(n->data, entry->data, entry->size);
+	n->bstream = NULL;
+	n->next = NULL;
+
+	return n;
+}
+
+/******************************************************************************
+ * Input Data
+ *****************************************************************************/
+
+struct QRinput *QRinput_new(void)
+{
+	return QRinput_new2(0, QR_ECLEVEL_L);
+}
+
+struct QRinput *QRinput_new2(int version, enum QRecLevel level)
+{
+	struct QRinput *input;
+	if (version < 0 || version > QRSPEC_VERSION_MAX || level > QR_ECLEVEL_H)
+		return NULL;
+
+	input = kmalloc(sizeof(struct QRinput), GFP_ATOMIC);
+	if (input == NULL)
+		return NULL;
+
+	input->head = NULL;
+	input->tail = NULL;
+	input->version = version;
+	input->level = level;
+	input->mqr = 0;
+	input->fnc1 = 0;
+
+	return input;
+}
+
+struct QRinput *QRinput_newMQR(int version, enum QRecLevel level)
+{
+	struct QRinput *input;
+
+	if (version <= 0 || version > MQRSPEC_VERSION_MAX)
+		goto INVALID;
+	if ((MQRspec_getECCLength(version, level) == 0))
+		goto INVALID;
+
+	input = QRinput_new2(version, level);
+	if (input == NULL)
+		return NULL;
+
+	input->mqr = 1;
+
+	return input;
+
+INVALID:
+	return NULL;
+}
+
+int QRinput_getVersion(struct QRinput *input)
+{
+	return input->version;
+}
+
+int QRinput_setVersion(struct QRinput *input, int version)
+{
+	if (input->mqr || version < 0 || version > QRSPEC_VERSION_MAX)
+		return -1;
+
+	input->version = version;
+
+	return 0;
+}
+
+enum QRecLevel QRinput_getErrorCorrectionLevel(struct QRinput *input)
+{
+	return input->level;
+}
+
+int QRinput_setErrorCorrectionLevel(struct QRinput *input, enum QRecLevel level)
+{
+	if (input->mqr || level > QR_ECLEVEL_H)
+		return -1;
+
+	input->level = level;
+
+	return 0;
+}
+
+int QRinput_setVersionAndErrorCorrectionLevel(struct QRinput *input,
+					      int version, enum QRecLevel level)
+{
+	if (input->mqr) {
+		if (version <= 0 || version > MQRSPEC_VERSION_MAX)
+			goto INVALID;
+		if ((MQRspec_getECCLength(version, level) == 0))
+			goto INVALID;
+	} else {
+		if (version < 0 || version > QRSPEC_VERSION_MAX)
+			goto INVALID;
+		if (level > QR_ECLEVEL_H)
+			goto INVALID;
+	}
+
+	input->version = version;
+	input->level = level;
+
+	return 0;
+
+INVALID:
+	return -1;
+}
+
+static void QRinput_appendEntry(struct QRinput *input,
+				struct QRinput_List *entry)
+{
+	if (input->tail == NULL) {
+		input->head = entry;
+		input->tail = entry;
+	} else {
+		input->tail->next = entry;
+		input->tail = entry;
+	}
+	entry->next = NULL;
+}
+
+int QRinput_append(struct QRinput *input, enum QRencodeMode mode, int size,
+		   const unsigned char *data)
+{
+	struct QRinput_List *entry;
+
+	entry = QRinput_List_newEntry(mode, size, data);
+	if (entry == NULL)
+		return -1;
+
+
+	QRinput_appendEntry(input, entry);
+
+	return 0;
+}
+
+/**
+ * Insert a structured-append header to the head of the input data.
+ * @param input input data.
+ * @param size number of structured symbols.
+ * @param number index number of the symbol. (1 <= number <= size)
+ * @param parity parity among input data. (NOTE: each symbol of a set of structured symbols has the same parity data)
+ * @retval 0 success.
+ * @retval -1 error occurred and errno is set to indeicate the error. See Execptions for the details.
+ * @throw EINVAL invalid parameter.
+ * @throw ENOMEM unable to allocate memory.
+ */
+static int QRinput_insertStructuredAppendHeader(struct QRinput *input, int size,
+						int number,
+						unsigned char parity)
+{
+	struct QRinput_List *entry;
+	unsigned char buf[3];
+
+	if (size > MAX_STRUCTURED_SYMBOLS)
+		return -1;
+	if (number <= 0 || number > size)
+		return -1;
+
+	buf[0] = (unsigned char)size;
+	buf[1] = (unsigned char)number;
+	buf[2] = parity;
+	entry = QRinput_List_newEntry(QR_MODE_STRUCTURE, 3, buf);
+	if (entry == NULL)
+		return -1;
+
+	entry->next = input->head;
+	input->head = entry;
+
+	return 0;
+}
+
+int QRinput_appendECIheader(struct QRinput *input, unsigned int ecinum)
+{
+	unsigned char data[4];
+
+	if (ecinum > 999999)
+		return -1;
+
+	/*
+	 * We manually create byte array of ecinum because
+	 * (unsigned char *)&ecinum may cause bus error on
+	 * some architectures.
+	 */
+	data[0] = ecinum & 0xff;
+	data[1] = (ecinum >> 8) & 0xff;
+	data[2] = (ecinum >> 16) & 0xff;
+	data[3] = (ecinum >> 24) & 0xff;
+	return QRinput_append(input, QR_MODE_ECI, 4, data);
+}
+
+void QRinput_free(struct QRinput *input)
+{
+	struct QRinput_List *list, *next;
+
+	if (input != NULL) {
+		list = input->head;
+		while (list != NULL) {
+			next = list->next;
+			QRinput_List_freeEntry(list);
+			list = next;
+		}
+		kfree(input);
+	}
+}
+
+static unsigned char QRinput_calcParity(struct QRinput *input)
+{
+	unsigned char parity = 0;
+	struct QRinput_List *list;
+	int i;
+
+	list = input->head;
+	while (list != NULL) {
+		if (list->mode != QR_MODE_STRUCTURE) {
+			for (i = list->size - 1; i >= 0; i--)
+				parity ^= list->data[i];
+		}
+		list = list->next;
+	}
+
+	return parity;
+}
+
+struct QRinput *QRinput_dup(struct QRinput *input)
+{
+	struct QRinput *n;
+	struct QRinput_List *list, *e;
+
+	if (input->mqr)
+		n = QRinput_newMQR(input->version, input->level);
+	else
+		n = QRinput_new2(input->version, input->level);
+	if (n == NULL)
+		return NULL;
+
+	list = input->head;
+	while (list != NULL) {
+		e = QRinput_List_dup(list);
+		if (e == NULL) {
+			QRinput_free(n);
+			return NULL;
+		}
+		QRinput_appendEntry(n, e);
+		list = list->next;
+	}
+
+	return n;
+}
+
+/******************************************************************************
+ * Numeric data
+ *****************************************************************************/
+
+/**
+ * Check the input data.
+ * @param size
+ * @param data
+ * @return result
+ */
+static int QRinput_checkModeNum(int size, const char *data)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (data[i] < '0' || data[i] > '9')
+			return -1;
+	}
+
+	return 0;
+}
+
+/**
+ * Estimates the length of the encoded bit stream of numeric data.
+ * @param size
+ * @return number of bits
+ */
+int QRinput_estimateBitsModeNum(int size)
+{
+	int w;
+	int bits;
+
+	w = size / 3;
+	bits = w * 10;
+	switch (size - w * 3) {
+	case 1:
+		bits += 4;
+		break;
+	case 2:
+		bits += 7;
+		break;
+	default:
+		break;
+	}
+
+	return bits;
+}
+
+/**
+ * Convert the number data to a bit stream.
+ * @param entry
+ * @param mqr
+ * @retval 0 success
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ */
+static int QRinput_encodeModeNum(struct QRinput_List *entry, int version,
+				 int mqr)
+{
+	int words, i, ret;
+	unsigned int val;
+
+	entry->bstream = BitStream_new();
+	if (entry->bstream == NULL)
+		return -1;
+
+	if (mqr) {
+		if (version > 1) {
+			ret =
+			    BitStream_appendNum(entry->bstream, version - 1,
+						MQRSPEC_MODEID_NUM);
+			if (ret < 0)
+				goto ABORT;
+		}
+		ret =
+		    BitStream_appendNum(entry->bstream,
+					MQRspec_lengthIndicator(QR_MODE_NUM,
+								version),
+					entry->size);
+		if (ret < 0)
+			goto ABORT;
+	} else {
+		ret = BitStream_appendNum(entry->bstream, 4, QRSPEC_MODEID_NUM);
+		if (ret < 0)
+			goto ABORT;
+
+		ret =
+		    BitStream_appendNum(entry->bstream,
+					QRspec_lengthIndicator(QR_MODE_NUM,
+							       version),
+					entry->size);
+		if (ret < 0)
+			goto ABORT;
+	}
+
+	words = entry->size / 3;
+	for (i = 0; i < words; i++) {
+		val = (entry->data[i * 3] - '0') * 100;
+		val += (entry->data[i * 3 + 1] - '0') * 10;
+		val += (entry->data[i * 3 + 2] - '0');
+
+		ret = BitStream_appendNum(entry->bstream, 10, val);
+		if (ret < 0)
+			goto ABORT;
+	}
+
+	if (entry->size - words * 3 == 1) {
+		val = entry->data[words * 3] - '0';
+		ret = BitStream_appendNum(entry->bstream, 4, val);
+		if (ret < 0)
+			goto ABORT;
+	} else if (entry->size - words * 3 == 2) {
+		val = (entry->data[words * 3] - '0') * 10;
+		val += (entry->data[words * 3 + 1] - '0');
+		BitStream_appendNum(entry->bstream, 7, val);
+		if (ret < 0)
+			goto ABORT;
+	}
+
+	return 0;
+ABORT:
+	BitStream_free(entry->bstream);
+	entry->bstream = NULL;
+	return -1;
+}
+
+/******************************************************************************
+ * Alphabet-numeric data
+ *****************************************************************************/
+
+const signed char QRinput_anTable[128] = {
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	36, -1, -1, -1, 37, 38, -1, -1, -1, -1, 39, 40, -1, 41, 42, 43,
+	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 44, -1, -1, -1, -1, -1,
+	-1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
+	25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
+};
+
+/**
+ * Check the input data.
+ * @param size
+ * @param data
+ * @return result
+ */
+static int QRinput_checkModeAn(int size, const char *data)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (QRinput_lookAnTable(data[i]) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+/**
+ * Estimates the length of the encoded bit stream of alphabet-numeric data.
+ * @param size
+ * @return number of bits
+ */
+int QRinput_estimateBitsModeAn(int size)
+{
+	int w;
+	int bits;
+
+	w = size / 2;
+	bits = w * 11;
+	if (size & 1)
+		bits += 6;
+
+	return bits;
+}
+
+/**
+ * Convert the alphabet-numeric data to a bit stream.
+ * @param entry
+ * @param mqr
+ * @retval 0 success
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw EINVAL invalid version.
+ */
+static int QRinput_encodeModeAn(struct QRinput_List *entry, int version,
+				int mqr)
+{
+	int words, i, ret;
+	unsigned int val;
+
+	entry->bstream = BitStream_new();
+	if (entry->bstream == NULL)
+		return -1;
+
+	if (mqr) {
+		if (version < 2)
+			goto ABORT;
+
+		ret =
+		    BitStream_appendNum(entry->bstream, version - 1,
+					MQRSPEC_MODEID_AN);
+		if (ret < 0)
+			goto ABORT;
+		ret =
+		    BitStream_appendNum(entry->bstream,
+					MQRspec_lengthIndicator(QR_MODE_AN,
+								version),
+					entry->size);
+		if (ret < 0)
+			goto ABORT;
+	} else {
+		ret = BitStream_appendNum(entry->bstream, 4, QRSPEC_MODEID_AN);
+		if (ret < 0)
+			goto ABORT;
+		ret =
+		    BitStream_appendNum(entry->bstream,
+					QRspec_lengthIndicator(QR_MODE_AN,
+							       version),
+					entry->size);
+		if (ret < 0)
+			goto ABORT;
+	}
+
+	words = entry->size / 2;
+	for (i = 0; i < words; i++) {
+		val =
+		    (unsigned int)QRinput_lookAnTable(entry->data[i * 2]) * 45;
+		val +=
+		    (unsigned int)QRinput_lookAnTable(entry->data[i * 2 + 1]);
+
+		ret = BitStream_appendNum(entry->bstream, 11, val);
+		if (ret < 0)
+			goto ABORT;
+	}
+
+	if (entry->size & 1) {
+		val = (unsigned int)QRinput_lookAnTable(entry->data[words * 2]);
+
+		ret = BitStream_appendNum(entry->bstream, 6, val);
+		if (ret < 0)
+			goto ABORT;
+	}
+
+	return 0;
+ABORT:
+	BitStream_free(entry->bstream);
+	entry->bstream = NULL;
+	return -1;
+}
+
+/******************************************************************************
+ * 8 bit data
+ *****************************************************************************/
+
+/**
+ * Estimates the length of the encoded bit stream of 8 bit data.
+ * @param size
+ * @return number of bits
+ */
+int QRinput_estimateBitsMode8(int size)
+{
+	return size * 8;
+}
+
+/**
+ * Convert the 8bits data to a bit stream.
+ * @param entry
+ * @param mqr
+ * @retval 0 success
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ */
+static int QRinput_encodeMode8(struct QRinput_List *entry, int version, int mqr)
+{
+	int ret;
+
+	entry->bstream = BitStream_new();
+	if (entry->bstream == NULL)
+		return -1;
+
+	if (mqr) {
+		if (version < 3)
+			goto ABORT;
+		ret =
+		    BitStream_appendNum(entry->bstream, version - 1,
+					MQRSPEC_MODEID_8);
+		if (ret < 0)
+			goto ABORT;
+		ret =
+		    BitStream_appendNum(entry->bstream,
+					MQRspec_lengthIndicator(QR_MODE_8,
+								version),
+					entry->size);
+		if (ret < 0)
+			goto ABORT;
+	} else {
+		ret = BitStream_appendNum(entry->bstream, 4, QRSPEC_MODEID_8);
+		if (ret < 0)
+			goto ABORT;
+		ret =
+		    BitStream_appendNum(entry->bstream,
+					QRspec_lengthIndicator(QR_MODE_8,
+							       version),
+					entry->size);
+		if (ret < 0)
+			goto ABORT;
+	}
+
+	ret = BitStream_appendBytes(entry->bstream, entry->size, entry->data);
+	if (ret < 0)
+		goto ABORT;
+
+	return 0;
+ABORT:
+	BitStream_free(entry->bstream);
+	entry->bstream = NULL;
+	return -1;
+}
+
+/******************************************************************************
+ * Kanji data
+ *****************************************************************************/
+
+/**
+ * Estimates the length of the encoded bit stream of kanji data.
+ * @param size
+ * @return number of bits
+ */
+int QRinput_estimateBitsModeKanji(int size)
+{
+	return (size / 2) * 13;
+}
+
+/**
+ * Check the input data.
+ * @param size
+ * @param data
+ * @return result
+ */
+static int QRinput_checkModeKanji(int size, const unsigned char *data)
+{
+	int i;
+	unsigned int val;
+
+	if (size & 1)
+		return -1;
+
+	for (i = 0; i < size; i += 2) {
+		val = ((unsigned int)data[i] << 8) | data[i + 1];
+		if (val < 0x8140 || (val > 0x9ffc && val < 0xe040)
+		    || val > 0xebbf) {
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * Convert the kanji data to a bit stream.
+ * @param entry
+ * @param mqr
+ * @retval 0 success
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw EINVAL invalid version.
+ */
+static int QRinput_encodeModeKanji(struct QRinput_List *entry, int version,
+				   int mqr)
+{
+	int ret, i;
+	unsigned int val, h;
+
+	entry->bstream = BitStream_new();
+	if (entry->bstream == NULL)
+		return -1;
+
+	if (mqr) {
+		if (version < 2)
+			goto ABORT;
+		ret =
+		    BitStream_appendNum(entry->bstream, version - 1,
+					MQRSPEC_MODEID_KANJI);
+		if (ret < 0)
+			goto ABORT;
+		ret =
+		    BitStream_appendNum(entry->bstream,
+					MQRspec_lengthIndicator(QR_MODE_KANJI,
+								version),
+					entry->size / 2);
+		if (ret < 0)
+			goto ABORT;
+	} else {
+		ret =
+		    BitStream_appendNum(entry->bstream, 4, QRSPEC_MODEID_KANJI);
+		if (ret < 0)
+			goto ABORT;
+		ret =
+		    BitStream_appendNum(entry->bstream,
+					QRspec_lengthIndicator(QR_MODE_KANJI,
+							       version),
+					entry->size / 2);
+		if (ret < 0)
+			goto ABORT;
+	}
+
+	for (i = 0; i < entry->size; i += 2) {
+		val = ((unsigned int)entry->data[i] << 8) | entry->data[i + 1];
+		if (val <= 0x9ffc)
+			val -= 0x8140;
+		else
+			val -= 0xc140;
+
+		h = (val >> 8) * 0xc0;
+		val = (val & 0xff) + h;
+
+		ret = BitStream_appendNum(entry->bstream, 13, val);
+		if (ret < 0)
+			goto ABORT;
+	}
+
+	return 0;
+ABORT:
+	BitStream_free(entry->bstream);
+	entry->bstream = NULL;
+	return -1;
+}
+
+/******************************************************************************
+ * Structured Symbol
+ *****************************************************************************/
+
+/**
+ * Convert a structure symbol code to a bit stream.
+ * @param entry
+ * @param mqr
+ * @retval 0 success
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw EINVAL invalid entry.
+ */
+static int QRinput_encodeModeStructure(struct QRinput_List *entry, int mqr)
+{
+	int ret;
+
+	if (mqr)
+		return -1;
+	entry->bstream = BitStream_new();
+	if (entry->bstream == NULL)
+		return -1;
+
+	ret = BitStream_appendNum(entry->bstream, 4, QRSPEC_MODEID_STRUCTURE);
+	if (ret < 0)
+		goto ABORT;
+	ret = BitStream_appendNum(entry->bstream, 4, entry->data[1] - 1);
+	if (ret < 0)
+		goto ABORT;
+	ret = BitStream_appendNum(entry->bstream, 4, entry->data[0] - 1);
+	if (ret < 0)
+		goto ABORT;
+	ret = BitStream_appendNum(entry->bstream, 8, entry->data[2]);
+	if (ret < 0)
+		goto ABORT;
+
+	return 0;
+ABORT:
+	BitStream_free(entry->bstream);
+	entry->bstream = NULL;
+	return -1;
+}
+
+/******************************************************************************
+ * FNC1
+ *****************************************************************************/
+
+static int QRinput_checkModeFNC1Second(int size, const unsigned char *data)
+{
+	if (size != 1)
+		return -1;
+
+	return 0;
+}
+
+static int QRinput_encodeModeFNC1Second(struct QRinput_List *entry, int version)
+{
+	int ret;
+
+	entry->bstream = BitStream_new();
+	if (entry->bstream == NULL)
+		return -1;
+
+	ret = BitStream_appendNum(entry->bstream, 4, QRSPEC_MODEID_FNC1SECOND);
+	if (ret < 0)
+		goto ABORT;
+
+	ret = BitStream_appendBytes(entry->bstream, 1, entry->data);
+	if (ret < 0)
+		goto ABORT;
+
+	return 0;
+ABORT:
+	BitStream_free(entry->bstream);
+	entry->bstream = NULL;
+	return -1;
+}
+
+/******************************************************************************
+ * ECI header
+ *****************************************************************************/
+static unsigned int QRinput_decodeECIfromByteArray(unsigned char *data)
+{
+	int i;
+	unsigned int ecinum;
+
+	ecinum = 0;
+	for (i = 0; i < 4; i++) {
+		ecinum = ecinum << 8;
+		ecinum |= data[3 - i];
+	}
+
+	return ecinum;
+}
+
+int QRinput_estimateBitsModeECI(unsigned char *data)
+{
+	unsigned int ecinum;
+
+	ecinum = QRinput_decodeECIfromByteArray(data);
+
+	/* See Table 4 of JISX 0510:2004 pp.17. */
+	if (ecinum < 128)
+		return MODE_INDICATOR_SIZE + 8;
+	else if (ecinum < 16384)
+		return MODE_INDICATOR_SIZE + 16;
+	else
+		return MODE_INDICATOR_SIZE + 24;
+}
+
+static int QRinput_encodeModeECI(struct QRinput_List *entry, int version)
+{
+	int ret, words;
+	unsigned int ecinum, code;
+
+	entry->bstream = BitStream_new();
+	if (entry->bstream == NULL)
+		return -1;
+
+	ecinum = QRinput_decodeECIfromByteArray(entry->data);
+
+	/* See Table 4 of JISX 0510:2004 pp.17. */
+	if (ecinum < 128) {
+		words = 1;
+		code = ecinum;
+	} else if (ecinum < 16384) {
+		words = 2;
+		code = 0x8000 + ecinum;
+	} else {
+		words = 3;
+		code = 0xc0000 + ecinum;
+	}
+
+	ret = BitStream_appendNum(entry->bstream, 4, QRSPEC_MODEID_ECI);
+	if (ret < 0)
+		goto ABORT;
+
+	ret = BitStream_appendNum(entry->bstream, words * 8, code);
+	if (ret < 0)
+		goto ABORT;
+
+	return 0;
+ABORT:
+	BitStream_free(entry->bstream);
+	entry->bstream = NULL;
+	return -1;
+}
+
+/******************************************************************************
+ * Validation
+ *****************************************************************************/
+
+int QRinput_check(enum QRencodeMode mode, int size, const unsigned char *data)
+{
+	if ((mode == QR_MODE_FNC1FIRST && size < 0) || size <= 0)
+		return -1;
+
+	switch (mode) {
+	case QR_MODE_NUM:
+		return QRinput_checkModeNum(size, (const char *)data);
+	case QR_MODE_AN:
+		return QRinput_checkModeAn(size, (const char *)data);
+	case QR_MODE_KANJI:
+		return QRinput_checkModeKanji(size, data);
+	case QR_MODE_8:
+		return 0;
+	case QR_MODE_STRUCTURE:
+		return 0;
+	case QR_MODE_ECI:
+		return 0;
+	case QR_MODE_FNC1FIRST:
+		return 0;
+	case QR_MODE_FNC1SECOND:
+		return QRinput_checkModeFNC1Second(size, data);
+	case QR_MODE_NUL:
+		break;
+	}
+
+	return -1;
+}
+
+/******************************************************************************
+ * Estimation of the bit length
+ *****************************************************************************/
+
+/**
+ * Estimates the length of the encoded bit stream on the current version.
+ * @param entry
+ * @param version version of the symbol
+ * @param mqr
+ * @return number of bits
+ */
+static int QRinput_estimateBitStreamSizeOfEntry(struct QRinput_List *entry,
+						int version, int mqr)
+{
+	int bits = 0;
+	int l, m;
+	int num;
+
+	if (version == 0)
+		version = 1;
+
+	switch (entry->mode) {
+	case QR_MODE_NUM:
+		bits = QRinput_estimateBitsModeNum(entry->size);
+		break;
+	case QR_MODE_AN:
+		bits = QRinput_estimateBitsModeAn(entry->size);
+		break;
+	case QR_MODE_8:
+		bits = QRinput_estimateBitsMode8(entry->size);
+		break;
+	case QR_MODE_KANJI:
+		bits = QRinput_estimateBitsModeKanji(entry->size);
+		break;
+	case QR_MODE_STRUCTURE:
+		return STRUCTURE_HEADER_SIZE;
+	case QR_MODE_ECI:
+		bits = QRinput_estimateBitsModeECI(entry->data);
+		break;
+	case QR_MODE_FNC1FIRST:
+		return MODE_INDICATOR_SIZE;
+	case QR_MODE_FNC1SECOND:
+		return MODE_INDICATOR_SIZE + 8;
+	default:
+		return 0;
+	}
+
+	if (mqr) {
+		l = QRspec_lengthIndicator(entry->mode, version);
+		m = version - 1;
+		bits += l + m;
+	} else {
+		l = QRspec_lengthIndicator(entry->mode, version);
+		m = 1 << l;
+		num = (entry->size + m - 1) / m;
+
+		bits += num * (MODE_INDICATOR_SIZE + l);
+	}
+
+	return bits;
+}
+
+/**
+ * Estimates the length of the encoded bit stream of the data.
+ * @param input input data
+ * @param version version of the symbol
+ * @return number of bits
+ */
+static int QRinput_estimateBitStreamSize(struct QRinput *input, int version)
+{
+	struct QRinput_List *list;
+	int bits = 0;
+
+	list = input->head;
+	while (list != NULL) {
+		bits +=
+		    QRinput_estimateBitStreamSizeOfEntry(list, version,
+							 input->mqr);
+		list = list->next;
+	}
+
+	return bits;
+}
+
+/**
+ * Estimates the required version number of the symbol.
+ * @param input input data
+ * @return required version number
+ */
+static int QRinput_estimateVersion(struct QRinput *input)
+{
+	int bits;
+	int version, prev;
+
+	version = 0;
+	do {
+		prev = version;
+		bits = QRinput_estimateBitStreamSize(input, prev);
+		version =
+		    QRspec_getMinimumVersion((bits + 7) / 8, input->level);
+		if (version < 0)
+			return -1;
+	} while (version > prev);
+
+	return version;
+}
+
+/**
+ * Returns required length in bytes for specified mode, version and bits.
+ * @param mode
+ * @param version
+ * @param bits
+ * @return required length of code words in bytes.
+ */
+static int QRinput_lengthOfCode(enum QRencodeMode mode, int version, int bits)
+{
+	int payload, size, chunks, remain, maxsize;
+
+	payload = bits - 4 - QRspec_lengthIndicator(mode, version);
+	switch (mode) {
+	case QR_MODE_NUM:
+		chunks = payload / 10;
+		remain = payload - chunks * 10;
+		size = chunks * 3;
+		if (remain >= 7)
+			size += 2;
+		else if (remain >= 4)
+			size += 1;
+		break;
+	case QR_MODE_AN:
+		chunks = payload / 11;
+		remain = payload - chunks * 11;
+		size = chunks * 2;
+		if (remain >= 6)
+			size++;
+		break;
+	case QR_MODE_8:
+		size = payload / 8;
+		break;
+	case QR_MODE_KANJI:
+		size = (payload / 13) * 2;
+		break;
+	case QR_MODE_STRUCTURE:
+		size = payload / 8;
+		break;
+	default:
+		size = 0;
+		break;
+	}
+	maxsize = QRspec_maximumWords(mode, version);
+	if (size < 0)
+		size = 0;
+	if (maxsize > 0 && size > maxsize)
+		size = maxsize;
+
+	return size;
+}
+
+/******************************************************************************
+ * Data conversion
+ *****************************************************************************/
+
+/**
+ * Convert the input data in the data chunk to a bit stream.
+ * @param entry
+ * @return number of bits (>0) or -1 for failure.
+ */
+static int QRinput_encodeBitStream(struct QRinput_List *entry, int version,
+				   int mqr)
+{
+	int words, ret;
+	struct QRinput_List *st1 = NULL, *st2 = NULL;
+
+	if (entry->bstream != NULL) {
+		BitStream_free(entry->bstream);
+		entry->bstream = NULL;
+	}
+
+	words = QRspec_maximumWords(entry->mode, version);
+	if (words != 0 && entry->size > words) {
+		st1 = QRinput_List_newEntry(entry->mode, words, entry->data);
+		if (st1 == NULL)
+			goto ABORT;
+		st2 =
+		    QRinput_List_newEntry(entry->mode, entry->size - words,
+					  &entry->data[words]);
+		if (st2 == NULL)
+			goto ABORT;
+
+		ret = QRinput_encodeBitStream(st1, version, mqr);
+		if (ret < 0)
+			goto ABORT;
+		ret = QRinput_encodeBitStream(st2, version, mqr);
+		if (ret < 0)
+			goto ABORT;
+		entry->bstream = BitStream_new();
+		if (entry->bstream == NULL)
+			goto ABORT;
+		ret = BitStream_append(entry->bstream, st1->bstream);
+		if (ret < 0)
+			goto ABORT;
+		ret = BitStream_append(entry->bstream, st2->bstream);
+		if (ret < 0)
+			goto ABORT;
+		QRinput_List_freeEntry(st1);
+		QRinput_List_freeEntry(st2);
+	} else {
+		ret = 0;
+		switch (entry->mode) {
+		case QR_MODE_NUM:
+			ret = QRinput_encodeModeNum(entry, version, mqr);
+			break;
+		case QR_MODE_AN:
+			ret = QRinput_encodeModeAn(entry, version, mqr);
+			break;
+		case QR_MODE_8:
+			ret = QRinput_encodeMode8(entry, version, mqr);
+			break;
+		case QR_MODE_KANJI:
+			ret = QRinput_encodeModeKanji(entry, version, mqr);
+			break;
+		case QR_MODE_STRUCTURE:
+			ret = QRinput_encodeModeStructure(entry, mqr);
+			break;
+		case QR_MODE_ECI:
+			ret = QRinput_encodeModeECI(entry, version);
+			break;
+		case QR_MODE_FNC1SECOND:
+			ret = QRinput_encodeModeFNC1Second(entry, version);
+			break;
+		default:
+			break;
+		}
+		if (ret < 0)
+			return -1;
+	}
+
+	return BitStream_size(entry->bstream);
+ABORT:
+	QRinput_List_freeEntry(st1);
+	QRinput_List_freeEntry(st2);
+	return -1;
+}
+
+/**
+ * Convert the input data to a bit stream.
+ * @param input input data.
+ * @retval 0 success
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ */
+static int QRinput_createBitStream(struct QRinput *input)
+{
+	struct QRinput_List *list;
+	int bits, total = 0;
+
+	list = input->head;
+	while (list != NULL) {
+		bits =
+		    QRinput_encodeBitStream(list, input->version, input->mqr);
+		if (bits < 0)
+			return -1;
+		total += bits;
+		list = list->next;
+	}
+
+	return total;
+}
+
+/**
+ * Convert the input data to a bit stream.
+ * When the version number is given and that is not sufficient, it is increased
+ * automatically.
+ * @param input input data.
+ * @retval 0 success
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ENOMEM unable to allocate memory.
+ * @throw ERANGE input is too large.
+ */
+static int QRinput_convertData(struct QRinput *input)
+{
+	int bits;
+	int ver;
+
+	ver = QRinput_estimateVersion(input);
+	if (ver > QRinput_getVersion(input))
+		QRinput_setVersion(input, ver);
+
+	for (;;) {
+		bits = QRinput_createBitStream(input);
+		if (bits < 0)
+			return -1;
+		ver = QRspec_getMinimumVersion((bits + 7) / 8, input->level);
+		if (ver < 0)
+			return -1;
+		else if (ver > QRinput_getVersion(input))
+			QRinput_setVersion(input, ver);
+		else
+			break;
+	}
+
+	return 0;
+}
+
+/**
+ * Append padding bits for the input data.
+ * @param bstream Bitstream to be appended.
+ * @param input input data.
+ * @retval 0 success
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ERANGE input data is too large.
+ * @throw ENOMEM unable to allocate memory.
+ */
+static int QRinput_appendPaddingBit(struct BitStream *bstream,
+				    struct QRinput *input)
+{
+	int bits, maxbits, words, maxwords, i, ret;
+	struct BitStream *padding = NULL;
+	unsigned char *padbuf;
+	int padlen;
+
+	bits = BitStream_size(bstream);
+	maxwords = QRspec_getDataLength(input->version, input->level);
+	maxbits = maxwords * 8;
+
+	if (maxbits < bits)
+		return -1;
+
+	if (maxbits == bits)
+		return 0;
+
+	if (maxbits - bits <= 4) {
+		ret = BitStream_appendNum(bstream, maxbits - bits, 0);
+		goto DONE;
+	}
+
+	words = (bits + 4 + 7) / 8;
+
+	padding = BitStream_new();
+	if (padding == NULL)
+		return -1;
+	ret = BitStream_appendNum(padding, words * 8 - bits, 0);
+	if (ret < 0)
+		goto DONE;
+
+	padlen = maxwords - words;
+	if (padlen > 0) {
+		padbuf = kmalloc(padlen, GFP_ATOMIC);
+		if (padbuf == NULL) {
+			ret = -1;
+			goto DONE;
+		}
+		for (i = 0; i < padlen; i++)
+			padbuf[i] = (i & 1) ? 0x11 : 0xec;
+		ret = BitStream_appendBytes(padding, padlen, padbuf);
+		kfree(padbuf);
+		if (ret < 0)
+			goto DONE;
+	}
+
+	ret = BitStream_append(bstream, padding);
+
+DONE:
+	BitStream_free(padding);
+	return ret;
+}
+
+/**
+ * Append padding bits for the input data - Micro QR Code version.
+ * @param bstream Bitstream to be appended.
+ * @param input input data.
+ * @retval 0 success
+ * @retval -1 an error occurred and errno is set to indeicate the error.
+ *            See Execptions for the details.
+ * @throw ERANGE input data is too large.
+ * @throw ENOMEM unable to allocate memory.
+ */
+static int QRinput_appendPaddingBitMQR(struct BitStream *bstream,
+				       struct QRinput *input)
+{
+	int bits, maxbits, words, maxwords, i, ret, termbits;
+	struct BitStream *padding = NULL;
+	unsigned char *padbuf;
+	int padlen;
+
+	bits = BitStream_size(bstream);
+	maxbits = MQRspec_getDataLengthBit(input->version, input->level);
+	maxwords = maxbits / 8;
+
+	if (maxbits < bits)
+		return -1;
+
+	if (maxbits == bits)
+		return 0;
+
+	termbits = input->version * 2 + 1;
+
+	if (maxbits - bits <= termbits) {
+		ret = BitStream_appendNum(bstream, maxbits - bits, 0);
+		goto DONE;
+	}
+
+	bits += termbits;
+
+	words = (bits + 7) / 8;
+	if (maxbits - words * 8 > 0) {
+		termbits += words * 8 - bits;
+		if (words == maxwords)
+			termbits += maxbits - words * 8;
+	} else {
+		termbits += words * 8 - bits;
+	}
+	padding = BitStream_new();
+	if (padding == NULL)
+		return -1;
+	ret = BitStream_appendNum(padding, termbits, 0);
+	if (ret < 0)
+		goto DONE;
+
+	padlen = maxwords - words;
+	if (padlen > 0) {
+		padbuf = kmalloc(padlen, GFP_ATOMIC);
+		if (padbuf == NULL) {
+			ret = -1;
+			goto DONE;
+		}
+		for (i = 0; i < padlen; i++)
+			padbuf[i] = (i & 1) ? 0x11 : 0xec;
+		ret = BitStream_appendBytes(padding, padlen, padbuf);
+		kfree(padbuf);
+		if (ret < 0)
+			goto DONE;
+
+		termbits = maxbits - maxwords * 8;
+		if (termbits > 0) {
+			ret = BitStream_appendNum(padding, termbits, 0);
+			if (ret < 0)
+				goto DONE;
+		}
+	}
+
+	ret = BitStream_append(bstream, padding);
+
+DONE:
+	BitStream_free(padding);
+	return ret;
+}
+
+static int QRinput_insertFNC1Header(struct QRinput *input)
+{
+	struct QRinput_List *entry = NULL;
+
+	if (input->fnc1 == 1) {
+		entry = QRinput_List_newEntry(QR_MODE_FNC1FIRST, 0, NULL);
+	} else if (input->fnc1 == 2) {
+		entry =
+		    QRinput_List_newEntry(QR_MODE_FNC1SECOND, 1,
+					  &(input->appid));
+	}
+	if (entry == NULL)
+		return -1;
+
+	if (input->head->mode != QR_MODE_STRUCTURE
+	    || input->head->mode != QR_MODE_ECI) {
+		entry->next = input->head;
+		input->head = entry;
+	} else {
+		entry->next = input->head->next;
+		input->head->next = entry;
+	}
+
+	return 0;
+}
+
+/**
+ * Merge all bit streams in the input data.
+ * @param input input data.
+ * @return merged bit stream
+ */
+
+static struct BitStream *QRinput_mergeBitStream(struct QRinput *input)
+{
+	struct BitStream *bstream;
+	struct QRinput_List *list;
+	int ret;
+
+	if (input->mqr) {
+		if (QRinput_createBitStream(input) < 0)
+			return NULL;
+	} else {
+		if (input->fnc1) {
+			if (QRinput_insertFNC1Header(input) < 0)
+				return NULL;
+		}
+		if (QRinput_convertData(input) < 0)
+			return NULL;
+	}
+
+	bstream = BitStream_new();
+	if (bstream == NULL)
+		return NULL;
+
+	list = input->head;
+	while (list != NULL) {
+		ret = BitStream_append(bstream, list->bstream);
+		if (ret < 0) {
+			BitStream_free(bstream);
+			return NULL;
+		}
+		list = list->next;
+	}
+
+	return bstream;
+}
+
+/**
+ * Merge all bit streams in the input data and append padding bits
+ * @param input input data.
+ * @return padded merged bit stream
+ */
+
+static struct BitStream *QRinput_getBitStream(struct QRinput *input)
+{
+	struct BitStream *bstream;
+	int ret;
+
+	bstream = QRinput_mergeBitStream(input);
+	if (bstream == NULL)
+		return NULL;
+
+	if (input->mqr)
+		ret = QRinput_appendPaddingBitMQR(bstream, input);
+	else
+		ret = QRinput_appendPaddingBit(bstream, input);
+
+	if (ret < 0) {
+		BitStream_free(bstream);
+		return NULL;
+	}
+
+	return bstream;
+}
+
+/**
+ * Pack all bit streams padding bits into a byte array.
+ * @param input input data.
+ * @return padded merged byte stream
+ */
+
+unsigned char *QRinput_getByteStream(struct QRinput *input)
+{
+	struct BitStream *bstream;
+	unsigned char *array;
+
+	bstream = QRinput_getBitStream(input);
+	if (bstream == NULL)
+		return NULL;
+
+	array = BitStream_toByte(bstream);
+	BitStream_free(bstream);
+
+	return array;
+}
+
+/******************************************************************************
+ * Structured input data
+ *****************************************************************************/
+
+static struct QRinput_InputList *QRinput_InputList_newEntry(struct QRinput
+							    *input)
+{
+	struct QRinput_InputList *entry;
+
+	entry = kmalloc(sizeof(struct QRinput_InputList), GFP_ATOMIC);
+	if (entry == NULL)
+		return NULL;
+
+	entry->input = input;
+	entry->next = NULL;
+
+	return entry;
+}
+
+static void QRinput_InputList_freeEntry(struct QRinput_InputList *entry)
+{
+	if (entry != NULL) {
+		QRinput_free(entry->input);
+		kfree(entry);
+	}
+}
+
+struct QRinput_Struct *QRinput_Struct_new(void)
+{
+	struct QRinput_Struct *s;
+
+	s = kmalloc(sizeof(struct QRinput_Struct), GFP_ATOMIC);
+	if (s == NULL)
+		return NULL;
+
+	s->size = 0;
+	s->parity = -1;
+	s->head = NULL;
+	s->tail = NULL;
+
+	return s;
+}
+
+void QRinput_Struct_setParity(struct QRinput_Struct *s, unsigned char parity)
+{
+	s->parity = (int)parity;
+}
+
+int QRinput_Struct_appendInput(struct QRinput_Struct *s, struct QRinput *input)
+{
+	struct QRinput_InputList *e;
+
+	if (input->mqr)
+		return -1;
+
+	e = QRinput_InputList_newEntry(input);
+	if (e == NULL)
+		return -1;
+
+	s->size++;
+	if (s->tail == NULL) {
+		s->head = e;
+		s->tail = e;
+	} else {
+		s->tail->next = e;
+		s->tail = e;
+	}
+
+	return s->size;
+}
+
+void QRinput_Struct_free(struct QRinput_Struct *s)
+{
+	struct QRinput_InputList *list, *next;
+
+	if (s != NULL) {
+		list = s->head;
+		while (list != NULL) {
+			next = list->next;
+			QRinput_InputList_freeEntry(list);
+			list = next;
+		}
+		kfree(s);
+	}
+}
+
+static unsigned char QRinput_Struct_calcParity(struct QRinput_Struct *s)
+{
+	struct QRinput_InputList *list;
+	unsigned char parity = 0;
+
+	list = s->head;
+	while (list != NULL) {
+		parity ^= QRinput_calcParity(list->input);
+		list = list->next;
+	}
+
+	QRinput_Struct_setParity(s, parity);
+
+	return parity;
+}
+
+static int QRinput_List_shrinkEntry(struct QRinput_List *entry, int bytes)
+{
+	unsigned char *data;
+
+	data = kmalloc(bytes, GFP_ATOMIC);
+	if (data == NULL)
+		return -1;
+
+	memcpy(data, entry->data, bytes);
+	kfree(entry->data);
+	entry->data = data;
+	entry->size = bytes;
+
+	return 0;
+}
+
+static int QRinput_splitEntry(struct QRinput_List *entry, int bytes)
+{
+	struct QRinput_List *e;
+	int ret;
+
+	e = QRinput_List_newEntry(entry->mode, entry->size - bytes,
+				  entry->data + bytes);
+	if (e == NULL)
+		return -1;
+
+	ret = QRinput_List_shrinkEntry(entry, bytes);
+	if (ret < 0) {
+		QRinput_List_freeEntry(e);
+		return -1;
+	}
+
+	e->next = entry->next;
+	entry->next = e;
+
+	return 0;
+}
+
+struct QRinput_Struct *QRinput_splitQRinputToStruct(struct QRinput *input)
+{
+	struct QRinput *p;
+	struct QRinput_Struct *s;
+	int bits, maxbits, nextbits, bytes, ret;
+	struct QRinput_List *list, *next, *prev;
+
+	if (input->mqr)
+		return NULL;
+
+
+	s = QRinput_Struct_new();
+	if (s == NULL)
+		return NULL;
+
+	input = QRinput_dup(input);
+	if (input == NULL) {
+		QRinput_Struct_free(s);
+		return NULL;
+	}
+
+	QRinput_Struct_setParity(s, QRinput_calcParity(input));
+	maxbits =
+	    QRspec_getDataLength(input->version,
+				 input->level) * 8 - STRUCTURE_HEADER_SIZE;
+
+	if (maxbits <= 0) {
+		QRinput_Struct_free(s);
+		QRinput_free(input);
+		return NULL;
+	}
+
+	bits = 0;
+	list = input->head;
+	prev = NULL;
+	while (list != NULL) {
+		nextbits =
+		    QRinput_estimateBitStreamSizeOfEntry(list, input->version,
+							 input->mqr);
+		if (bits + nextbits <= maxbits) {
+			ret =
+			    QRinput_encodeBitStream(list, input->version,
+						    input->mqr);
+			if (ret < 0)
+				goto ABORT;
+			bits += ret;
+			prev = list;
+			list = list->next;
+		} else {
+			bytes =
+			    QRinput_lengthOfCode(list->mode, input->version,
+						 maxbits - bits);
+			p = QRinput_new2(input->version, input->level);
+			if (p == NULL)
+				goto ABORT;
+			if (bytes > 0) {
+				/* Splits this entry into 2 entries. */
+				ret = QRinput_splitEntry(list, bytes);
+				if (ret < 0) {
+					QRinput_free(p);
+					goto ABORT;
+				}
+				/*
+				 * First half is the tail
+				 * of the current input.
+				 */
+				next = list->next;
+				list->next = NULL;
+				/*
+				 * Second half is the head
+				 * of the next input, p.
+				 */
+				p->head = next;
+				/* Renew QRinput.tail. */
+				p->tail = input->tail;
+				input->tail = list;
+				/* Point to the next entry. */
+				prev = list;
+				list = next;
+			} else {
+				/* Current entry will go to the next input. */
+				prev->next = NULL;
+				p->head = list;
+				p->tail = input->tail;
+				input->tail = prev;
+			}
+			ret = QRinput_Struct_appendInput(s, input);
+			if (ret < 0) {
+				QRinput_free(p);
+				goto ABORT;
+			}
+			input = p;
+			bits = 0;
+		}
+	}
+	ret = QRinput_Struct_appendInput(s, input);
+	if (ret < 0)
+		goto ABORT;
+	if (s->size > MAX_STRUCTURED_SYMBOLS) {
+		QRinput_Struct_free(s);
+		return NULL;
+	}
+	ret = QRinput_Struct_insertStructuredAppendHeaders(s);
+	if (ret < 0) {
+		QRinput_Struct_free(s);
+		return NULL;
+	}
+
+	return s;
+
+ABORT:
+	QRinput_free(input);
+	QRinput_Struct_free(s);
+	return NULL;
+}
+
+int QRinput_Struct_insertStructuredAppendHeaders(struct QRinput_Struct *s)
+{
+	int num, i;
+	struct QRinput_InputList *list;
+
+	if (s->parity < 0)
+		QRinput_Struct_calcParity(s);
+	num = 0;
+	list = s->head;
+	while (list != NULL) {
+		num++;
+		list = list->next;
+	}
+	i = 1;
+	list = s->head;
+	while (list != NULL) {
+		if (QRinput_insertStructuredAppendHeader
+		    (list->input, num, i, s->parity))
+			return -1;
+		i++;
+		list = list->next;
+	}
+
+	return 0;
+}
+
+/******************************************************************************
+ * Extended encoding mode (FNC1 and ECI)
+ *****************************************************************************/
+
+int QRinput_setFNC1First(struct QRinput *input)
+{
+	if (input->mqr)
+		return -1;
+	input->fnc1 = 1;
+
+	return 0;
+}
+
+int QRinput_setFNC1Second(struct QRinput *input, unsigned char appid)
+{
+	if (input->mqr)
+		return -1;
+	input->fnc1 = 2;
+	input->appid = appid;
+
+	return 0;
+}
diff --git a/lib/qr/qrinput.h b/lib/qr/qrinput.h
new file mode 100644
index 0000000..054f4f8
--- /dev/null
+++ b/lib/qr/qrinput.h
@@ -0,0 +1,129 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Input data chunk class
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __QRINPUT_H__
+#define __QRINPUT_H__
+
+#include <linux/qrencode.h>
+#include "bitstream.h"
+
+int QRinput_isSplittableMode(enum QRencodeMode mode);
+
+/******************************************************************************
+ * Entry of input data
+ *****************************************************************************/
+struct QRinput_List {
+	enum QRencodeMode mode;
+	int size;		/*  Size of data chunk (byte). */
+	unsigned char *data;	/* Data chunk. */
+	struct BitStream *bstream;
+	struct QRinput_List *next;
+};
+
+/******************************************************************************
+ * Input Data
+ *****************************************************************************/
+
+/**
+ * Singly linked list to contain input strings. An instance of this class
+ * contains its version and error correction level too. It is required to
+ * set them by QRinput_setVersion() and QRinput_setErrorCorrectionLevel(),
+ * or use QRinput_new2() to instantiate an object.
+ */
+struct QRinput {
+	int version;
+	enum QRecLevel level;
+	struct QRinput_List *head;
+	struct QRinput_List *tail;
+	int mqr;
+	int fnc1;
+	unsigned char appid;
+};
+
+/******************************************************************************
+ * Structured append input data
+ *****************************************************************************/
+
+struct QRinput_InputList {
+	struct QRinput *input;
+	struct QRinput_InputList *next;
+};
+
+/**
+ * Set of QRinput for structured symbols.
+ */
+struct QRinput_Struct {
+	int size;		/* number of structured symbols */
+	int parity;
+	struct QRinput_InputList *head;
+	struct QRinput_InputList *tail;
+};
+
+/**
+ * Pack all bit streams padding bits into a byte array.
+ * @param input input data.
+ * @return padded merged byte stream
+ */
+extern unsigned char *QRinput_getByteStream(struct QRinput *input);
+
+
+extern int QRinput_estimateBitsModeNum(int size);
+extern int QRinput_estimateBitsModeAn(int size);
+extern int QRinput_estimateBitsMode8(int size);
+extern int QRinput_estimateBitsModeKanji(int size);
+
+extern struct QRinput *QRinput_dup(struct QRinput *input);
+
+extern const signed char QRinput_anTable[128];
+
+/**
+ * Look up the alphabet-numeric convesion table (see JIS X0510:2004, pp.19).
+ * @param __c__ character
+ * @return value
+ */
+#define QRinput_lookAnTable(__c__) \
+	((__c__ & 0x80) ? -1 : QRinput_anTable[(int)__c__])
+
+/**
+ * Length of a standard mode indicator in bits.
+ */
+
+#define MODE_INDICATOR_SIZE 4
+
+/**
+ * Length of a segment of structured-append header.
+ */
+#define STRUCTURE_HEADER_SIZE 20
+
+/**
+ * Maximum number of symbols in a set of structured-appended symbols.
+ */
+#define MAX_STRUCTURED_SYMBOLS 16
+
+#ifdef WITH_TESTS
+extern struct BitStream *QRinput_mergeBitStream(struct QRinput *input);
+extern struct BitStream *QRinput_getBitStream(struct QRinput *input);
+extern int QRinput_estimateBitStreamSize(struct QRinput *input, int version);
+extern int QRinput_splitEntry(struct QRinput_List *entry, int bytes);
+extern int QRinput_lengthOfCode(enum QRencodeMode mode, int version, int bits);
+extern int QRinput_insertStructuredAppendHeader(struct QRinput *input,
+						int size, int index,
+						unsigned char parity);
+#endif
+
+#endif /* __QRINPUT_H__ */
diff --git a/lib/qr/qrspec.c b/lib/qr/qrspec.c
new file mode 100644
index 0000000..28d1db0
--- /dev/null
+++ b/lib/qr/qrspec.c
@@ -0,0 +1,543 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * QR Code specification in convenient format.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * The following data / specifications are taken from
+ * "Two dimensional symbol -- QR-code -- Basic Specification" (JIS X0510:2004)
+ *  or
+ * "Automatic identification and data capture techniques --
+ *  QR Code 2005 bar code symbology specification" (ISO/IEC 18004:2006)
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include "qrspec.h"
+#include "qrinput.h"
+
+/******************************************************************************
+ * Version and capacity
+ *****************************************************************************/
+
+struct QRspec_Capacity {
+	int width;		/* Edge length of the symbol */
+	int words;		/* Data capacity (bytes) */
+	int remainder;		/* Remainder bit (bits) */
+	int ec[4];		/* Number of ECC code (bytes) */
+};
+
+/**
+ * Table of the capacity of symbols
+ * See Table 1 (pp.13) and Table 12-16 (pp.30-36), JIS X0510:2004.
+ */
+static const struct QRspec_Capacity qrspecCapacity[QRSPEC_VERSION_MAX + 1] = {
+	{0, 0, 0, {0, 0, 0, 0} },
+	{21, 26, 0, {7, 10, 13, 17} },	/* 1 */
+	{25, 44, 7, {10, 16, 22, 28} },
+	{29, 70, 7, {15, 26, 36, 44} },
+	{33, 100, 7, {20, 36, 52, 64} },
+	{37, 134, 7, {26, 48, 72, 88} },	/* 5 */
+	{41, 172, 7, {36, 64, 96, 112} },
+	{45, 196, 0, {40, 72, 108, 130} },
+	{49, 242, 0, {48, 88, 132, 156} },
+	{53, 292, 0, {60, 110, 160, 192} },
+	{57, 346, 0, {72, 130, 192, 224} },	/* 10 */
+	{61, 404, 0, {80, 150, 224, 264} },
+	{65, 466, 0, {96, 176, 260, 308} },
+	{69, 532, 0, {104, 198, 288, 352} },
+	{73, 581, 3, {120, 216, 320, 384} },
+	{77, 655, 3, {132, 240, 360, 432} },	/* 15 */
+	{81, 733, 3, {144, 280, 408, 480} },
+	{85, 815, 3, {168, 308, 448, 532} },
+	{89, 901, 3, {180, 338, 504, 588} },
+	{93, 991, 3, {196, 364, 546, 650} },
+	{97, 1085, 3, {224, 416, 600, 700} },	/* 20 */
+	{101, 1156, 4, {224, 442, 644, 750} },
+	{105, 1258, 4, {252, 476, 690, 816} },
+	{109, 1364, 4, {270, 504, 750, 900} },
+	{113, 1474, 4, {300, 560, 810, 960} },
+	{117, 1588, 4, {312, 588, 870, 1050} },	/* 25 */
+	{121, 1706, 4, {336, 644, 952, 1110} },
+	{125, 1828, 4, {360, 700, 1020, 1200} },
+	{129, 1921, 3, {390, 728, 1050, 1260} },
+	{133, 2051, 3, {420, 784, 1140, 1350} },
+	{137, 2185, 3, {450, 812, 1200, 1440} },	/* 30 */
+	{141, 2323, 3, {480, 868, 1290, 1530} },
+	{145, 2465, 3, {510, 924, 1350, 1620} },
+	{149, 2611, 3, {540, 980, 1440, 1710} },
+	{153, 2761, 3, {570, 1036, 1530, 1800} },
+	{157, 2876, 0, {570, 1064, 1590, 1890} },	/*35 */
+	{161, 3034, 0, {600, 1120, 1680, 1980} },
+	{165, 3196, 0, {630, 1204, 1770, 2100} },
+	{169, 3362, 0, {660, 1260, 1860, 2220} },
+	{173, 3532, 0, {720, 1316, 1950, 2310} },
+	{177, 3706, 0, {750, 1372, 2040, 2430} }	/* 40 */
+};
+
+int QRspec_getDataLength(int version, enum QRecLevel level)
+{
+	return qrspecCapacity[version].words -
+	    qrspecCapacity[version].ec[level];
+}
+
+int QRspec_getECCLength(int version, enum QRecLevel level)
+{
+	return qrspecCapacity[version].ec[level];
+}
+
+int QRspec_getMinimumVersion(int size, enum QRecLevel level)
+{
+	int i;
+	int words;
+
+	for (i = 1; i <= QRSPEC_VERSION_MAX; i++) {
+		words = qrspecCapacity[i].words - qrspecCapacity[i].ec[level];
+		if (words >= size)
+			return i;
+	}
+
+	return -1;
+}
+
+int QRspec_getWidth(int version)
+{
+	return qrspecCapacity[version].width;
+}
+
+int QRspec_getRemainder(int version)
+{
+	return qrspecCapacity[version].remainder;
+}
+
+/******************************************************************************
+ * Length indicator
+ *****************************************************************************/
+
+static const int lengthTableBits[4][3] = {
+	{10, 12, 14},
+	{9, 11, 13},
+	{8, 16, 16},
+	{8, 10, 12}
+};
+
+int QRspec_lengthIndicator(enum QRencodeMode mode, int version)
+{
+	int l;
+
+	if (!QRinput_isSplittableMode(mode))
+		return 0;
+	if (version <= 9)
+		l = 0;
+	else if (version <= 26)
+		l = 1;
+	else
+		l = 2;
+
+	return lengthTableBits[mode][l];
+}
+
+int QRspec_maximumWords(enum QRencodeMode mode, int version)
+{
+	int l;
+	int bits;
+	int words;
+
+	if (!QRinput_isSplittableMode(mode))
+		return 0;
+	if (version <= 9)
+		l = 0;
+	else if (version <= 26)
+		l = 1;
+	else
+		l = 2;
+
+	bits = lengthTableBits[mode][l];
+	words = (1 << bits) - 1;
+	if (mode == QR_MODE_KANJI)
+		words *= 2;	/* the number of bytes is required */
+
+
+	return words;
+}
+
+/******************************************************************************
+ * Error correction code
+ *****************************************************************************/
+
+/**
+ * Table of the error correction code (Reed-Solomon block)
+ * See Table 12-16 (pp.30-36), JIS X0510:2004.
+ */
+static const int eccTable[QRSPEC_VERSION_MAX + 1][4][2] = {
+	{{0, 0}, {0, 0}, {0, 0}, {0, 0} },
+	{{1, 0}, {1, 0}, {1, 0}, {1, 0} },	/* 1 */
+	{{1, 0}, {1, 0}, {1, 0}, {1, 0} },
+	{{1, 0}, {1, 0}, {2, 0}, {2, 0} },
+	{{1, 0}, {2, 0}, {2, 0}, {4, 0} },
+	{{1, 0}, {2, 0}, {2, 2}, {2, 2} },	/* 5 */
+	{{2, 0}, {4, 0}, {4, 0}, {4, 0} },
+	{{2, 0}, {4, 0}, {2, 4}, {4, 1} },
+	{{2, 0}, {2, 2}, {4, 2}, {4, 2} },
+	{{2, 0}, {3, 2}, {4, 4}, {4, 4} },
+	{{2, 2}, {4, 1}, {6, 2}, {6, 2} },	/* 10 */
+	{{4, 0}, {1, 4}, {4, 4}, {3, 8} },
+	{{2, 2}, {6, 2}, {4, 6}, {7, 4} },
+	{{4, 0}, {8, 1}, {8, 4}, {12, 4} },
+	{{3, 1}, {4, 5}, {11, 5}, {11, 5} },
+	{{5, 1}, {5, 5}, {5, 7}, {11, 7} },	/* 15 */
+	{{5, 1}, {7, 3}, {15, 2}, {3, 13} },
+	{{1, 5}, {10, 1}, {1, 15}, {2, 17} },
+	{{5, 1}, {9, 4}, {17, 1}, {2, 19} },
+	{{3, 4}, {3, 11}, {17, 4}, {9, 16} },
+	{{3, 5}, {3, 13}, {15, 5}, {15, 10} },	/* 20 */
+	{{4, 4}, {17, 0}, {17, 6}, {19, 6} },
+	{{2, 7}, {17, 0}, {7, 16}, {34, 0} },
+	{{4, 5}, {4, 14}, {11, 14}, {16, 14} },
+	{{6, 4}, {6, 14}, {11, 16}, {30, 2} },
+	{{8, 4}, {8, 13}, {7, 22}, {22, 13} },	/* 25 */
+	{{10, 2}, {19, 4}, {28, 6}, {33, 4} },
+	{{8, 4}, {22, 3}, {8, 26}, {12, 28} },
+	{{3, 10}, {3, 23}, {4, 31}, {11, 31} },
+	{{7, 7}, {21, 7}, {1, 37}, {19, 26} },
+	{{5, 10}, {19, 10}, {15, 25}, {23, 25} },	/* 30 */
+	{{13, 3}, {2, 29}, {42, 1}, {23, 28} },
+	{{17, 0}, {10, 23}, {10, 35}, {19, 35} },
+	{{17, 1}, {14, 21}, {29, 19}, {11, 46} },
+	{{13, 6}, {14, 23}, {44, 7}, {59, 1} },
+	{{12, 7}, {12, 26}, {39, 14}, {22, 41} },	/* 35 */
+	{{6, 14}, {6, 34}, {46, 10}, {2, 64} },
+	{{17, 4}, {29, 14}, {49, 10}, {24, 46} },
+	{{4, 18}, {13, 32}, {48, 14}, {42, 32} },
+	{{20, 4}, {40, 7}, {43, 22}, {10, 67} },
+	{{19, 6}, {18, 31}, {34, 34}, {20, 61} },	/* 40 */
+};
+
+void QRspec_getEccSpec(int version, enum QRecLevel level, int spec[5])
+{
+	int b1, b2;
+	int data, ecc;
+
+	b1 = eccTable[version][level][0];
+	b2 = eccTable[version][level][1];
+	data = QRspec_getDataLength(version, level);
+	ecc = QRspec_getECCLength(version, level);
+
+	if (b2 == 0) {
+		spec[0] = b1;
+		spec[1] = data / b1;
+		spec[2] = ecc / b1;
+		spec[3] = spec[4] = 0;
+	} else {
+		spec[0] = b1;
+		spec[1] = data / (b1 + b2);
+		spec[2] = ecc / (b1 + b2);
+		spec[3] = b2;
+		spec[4] = spec[1] + 1;
+	}
+}
+
+/******************************************************************************
+ * Alignment pattern
+ *****************************************************************************/
+
+/**
+ * Positions of alignment patterns.
+ * This array includes only the second and the third position of the alignment
+ * patterns. Rest of them can be calculated from the distance between them.
+ *
+ * See Table 1 in Appendix E (pp.71) of JIS X0510:2004.
+ */
+static const int alignmentPattern[QRSPEC_VERSION_MAX + 1][2] = {
+	{0, 0},
+	{0, 0}, {18, 0}, {22, 0}, {26, 0}, {30, 0},	/* 1-5 */
+	{34, 0}, {22, 38}, {24, 42}, {26, 46}, {28, 50},	/* 6-10 */
+	{30, 54}, {32, 58}, {34, 62}, {26, 46}, {26, 48},	/* 11-15 */
+	{26, 50}, {30, 54}, {30, 56}, {30, 58}, {34, 62},	/* 16-20 */
+	{28, 50}, {26, 50}, {30, 54}, {28, 54}, {32, 58},	/* 21-25 */
+	{30, 58}, {34, 62}, {26, 50}, {30, 54}, {26, 52},	/* 26-30 */
+	{30, 56}, {34, 60}, {30, 58}, {34, 62}, {30, 54},	/* 31-35 */
+	{24, 50}, {28, 54}, {32, 58}, {26, 54}, {30, 58},	/* 35-40 */
+};
+
+/**
+ * Put an alignment marker.
+ * @param frame
+ * @param width
+ * @param ox,oy center coordinate of the pattern
+ */
+static void QRspec_putAlignmentMarker(unsigned char *frame, int width, int ox,
+				      int oy)
+{
+	static const unsigned char finder[] = {
+		0xa1, 0xa1, 0xa1, 0xa1, 0xa1,
+		0xa1, 0xa0, 0xa0, 0xa0, 0xa1,
+		0xa1, 0xa0, 0xa1, 0xa0, 0xa1,
+		0xa1, 0xa0, 0xa0, 0xa0, 0xa1,
+		0xa1, 0xa1, 0xa1, 0xa1, 0xa1,
+	};
+	int x, y;
+	const unsigned char *s;
+
+	frame += (oy - 2) * width + ox - 2;
+	s = finder;
+	for (y = 0; y < 5; y++) {
+		for (x = 0; x < 5; x++)
+			frame[x] = s[x];
+		frame += width;
+		s += 5;
+	}
+}
+
+static void QRspec_putAlignmentPattern(int version, unsigned char *frame,
+				       int width)
+{
+	int d, w, x, y, cx, cy;
+
+	if (version < 2)
+		return;
+
+	d = alignmentPattern[version][1] - alignmentPattern[version][0];
+	if (d < 0)
+		w = 2;
+	else
+		w = (width - alignmentPattern[version][0]) / d + 2;
+
+	if (w * w - 3 == 1) {
+		x = alignmentPattern[version][0];
+		y = alignmentPattern[version][0];
+		QRspec_putAlignmentMarker(frame, width, x, y);
+		return;
+	}
+
+	cx = alignmentPattern[version][0];
+	for (x = 1; x < w - 1; x++) {
+		QRspec_putAlignmentMarker(frame, width, 6, cx);
+		QRspec_putAlignmentMarker(frame, width, cx, 6);
+		cx += d;
+	}
+
+	cy = alignmentPattern[version][0];
+	for (y = 0; y < w - 1; y++) {
+		cx = alignmentPattern[version][0];
+		for (x = 0; x < w - 1; x++) {
+			QRspec_putAlignmentMarker(frame, width, cx, cy);
+			cx += d;
+		}
+		cy += d;
+	}
+}
+
+/******************************************************************************
+ * Version information pattern
+ *****************************************************************************/
+
+/**
+ * Version information pattern (BCH coded).
+ * See Table 1 in Appendix D (pp.68) of JIS X0510:2004.
+ */
+static const unsigned int versionPattern[QRSPEC_VERSION_MAX - 6] = {
+	0x07c94, 0x085bc, 0x09a99, 0x0a4d3, 0x0bbf6, 0x0c762, 0x0d847, 0x0e60d,
+	0x0f928, 0x10b78, 0x1145d, 0x12a17, 0x13532, 0x149a6, 0x15683, 0x168c9,
+	0x177ec, 0x18ec4, 0x191e1, 0x1afab, 0x1b08e, 0x1cc1a, 0x1d33f, 0x1ed75,
+	0x1f250, 0x209d5, 0x216f0, 0x228ba, 0x2379f, 0x24b0b, 0x2542e, 0x26a64,
+	0x27541, 0x28c69
+};
+
+unsigned int QRspec_getVersionPattern(int version)
+{
+	if (version < 7 || version > QRSPEC_VERSION_MAX)
+		return 0;
+
+	return versionPattern[version - 7];
+}
+
+/******************************************************************************
+ * Format information
+ *****************************************************************************/
+
+/* See calcFormatInfo in tests/test_qrspec.c */
+static const unsigned int formatInfo[4][8] = {
+	{0x77c4, 0x72f3, 0x7daa, 0x789d, 0x662f, 0x6318, 0x6c41, 0x6976},
+	{0x5412, 0x5125, 0x5e7c, 0x5b4b, 0x45f9, 0x40ce, 0x4f97, 0x4aa0},
+	{0x355f, 0x3068, 0x3f31, 0x3a06, 0x24b4, 0x2183, 0x2eda, 0x2bed},
+	{0x1689, 0x13be, 0x1ce7, 0x19d0, 0x0762, 0x0255, 0x0d0c, 0x083b}
+};
+
+unsigned int QRspec_getFormatInfo(int mask, enum QRecLevel level)
+{
+	if (mask < 0 || mask > 7)
+		return 0;
+
+	return formatInfo[level][mask];
+}
+
+/******************************************************************************
+ * Frame
+ *****************************************************************************/
+
+/**
+ * Cache of initial frames.
+ */
+/* C99 says that static storage shall be initialized to a null pointer
+ * by compiler. */
+static unsigned char *frames[QRSPEC_VERSION_MAX + 1];
+
+/**
+ * Put a finder pattern.
+ * @param frame
+ * @param width
+ * @param ox,oy upper-left coordinate of the pattern
+ */
+static void putFinderPattern(unsigned char *frame, int width, int ox, int oy)
+{
+	static const unsigned char finder[] = {
+		0xc1, 0xc1, 0xc1, 0xc1, 0xc1, 0xc1, 0xc1,
+		0xc1, 0xc0, 0xc0, 0xc0, 0xc0, 0xc0, 0xc1,
+		0xc1, 0xc0, 0xc1, 0xc1, 0xc1, 0xc0, 0xc1,
+		0xc1, 0xc0, 0xc1, 0xc1, 0xc1, 0xc0, 0xc1,
+		0xc1, 0xc0, 0xc1, 0xc1, 0xc1, 0xc0, 0xc1,
+		0xc1, 0xc0, 0xc0, 0xc0, 0xc0, 0xc0, 0xc1,
+		0xc1, 0xc1, 0xc1, 0xc1, 0xc1, 0xc1, 0xc1,
+	};
+	int x, y;
+	const unsigned char *s;
+
+	frame += oy * width + ox;
+	s = finder;
+	for (y = 0; y < 7; y++) {
+		for (x = 0; x < 7; x++)
+			frame[x] = s[x];
+		frame += width;
+		s += 7;
+	}
+}
+
+static unsigned char *QRspec_createFrame(int version)
+{
+	unsigned char *frame, *p, *q;
+	int width;
+	int x, y;
+	unsigned int verinfo, v;
+
+	width = qrspecCapacity[version].width;
+	frame = kmalloc(width * width, GFP_ATOMIC);
+	if (frame == NULL)
+		return NULL;
+
+	memset(frame, 0, width * width);
+	/* Finder pattern */
+	putFinderPattern(frame, width, 0, 0);
+	putFinderPattern(frame, width, width - 7, 0);
+	putFinderPattern(frame, width, 0, width - 7);
+	/* Separator */
+	p = frame;
+	q = frame + width * (width - 7);
+	for (y = 0; y < 7; y++) {
+		p[7] = 0xc0;
+		p[width - 8] = 0xc0;
+		q[7] = 0xc0;
+		p += width;
+		q += width;
+	}
+	memset(frame + width * 7, 0xc0, 8);
+	memset(frame + width * 8 - 8, 0xc0, 8);
+	memset(frame + width * (width - 8), 0xc0, 8);
+	/* Mask format information area */
+	memset(frame + width * 8, 0x84, 9);
+	memset(frame + width * 9 - 8, 0x84, 8);
+	p = frame + 8;
+	for (y = 0; y < 8; y++) {
+		*p = 0x84;
+		p += width;
+	}
+	p = frame + width * (width - 7) + 8;
+	for (y = 0; y < 7; y++) {
+		*p = 0x84;
+		p += width;
+	}
+	/* Timing pattern */
+	p = frame + width * 6 + 8;
+	q = frame + width * 8 + 6;
+	for (x = 1; x < width - 15; x++) {
+		*p = 0x90 | (x & 1);
+		*q = 0x90 | (x & 1);
+		p++;
+		q += width;
+	}
+	/* Alignment pattern */
+	QRspec_putAlignmentPattern(version, frame, width);
+
+	/* Version information */
+	if (version >= 7) {
+		verinfo = QRspec_getVersionPattern(version);
+
+		p = frame + width * (width - 11);
+		v = verinfo;
+		for (x = 0; x < 6; x++) {
+			for (y = 0; y < 3; y++) {
+				p[width * y + x] = 0x88 | (v & 1);
+				v = v >> 1;
+			}
+		}
+
+		p = frame + width - 11;
+		v = verinfo;
+		for (y = 0; y < 6; y++) {
+			for (x = 0; x < 3; x++) {
+				p[x] = 0x88 | (v & 1);
+				v = v >> 1;
+			}
+			p += width;
+		}
+	}
+	/* and a little bit... */
+	frame[width * (width - 8) + 8] = 0x81;
+
+	return frame;
+}
+
+unsigned char *QRspec_newFrame(int version)
+{
+	unsigned char *frame;
+	int width;
+
+	if (version < 1 || version > QRSPEC_VERSION_MAX)
+		return NULL;
+
+	if (frames[version] == NULL)
+		frames[version] = QRspec_createFrame(version);
+	if (frames[version] == NULL)
+		return NULL;
+
+	width = qrspecCapacity[version].width;
+	frame = kmalloc(width * width, GFP_ATOMIC);
+	if (frame == NULL)
+		return NULL;
+	memcpy(frame, frames[version], width * width);
+
+	return frame;
+}
+
+void QRspec_clearCache(void)
+{
+	int i;
+
+	for (i = 1; i <= QRSPEC_VERSION_MAX; i++) {
+		kfree(frames[i]);
+		frames[i] = NULL;
+	}
+}
diff --git a/lib/qr/qrspec.h b/lib/qr/qrspec.h
new file mode 100644
index 0000000..2e5f1e2
--- /dev/null
+++ b/lib/qr/qrspec.h
@@ -0,0 +1,178 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * QR Code specification in convenient format.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __QRSPEC_H__
+#define __QRSPEC_H__
+
+#include <linux/qrencode.h>
+
+/******************************************************************************
+ * Version and capacity
+ *****************************************************************************/
+
+/**
+ * Maximum width of a symbol
+ */
+#define QRSPEC_WIDTH_MAX 177
+
+/**
+ * Return maximum data code length (bytes) for the version.
+ * @param version
+ * @param level
+ * @return maximum size (bytes)
+ */
+extern int QRspec_getDataLength(int version, enum QRecLevel level);
+
+/**
+ * Return maximum error correction code length (bytes) for the version.
+ * @param version
+ * @param level
+ * @return ECC size (bytes)
+ */
+extern int QRspec_getECCLength(int version, enum QRecLevel level);
+
+/**
+ * Return a version number that satisfies the input code length.
+ * @param size input code length (byte)
+ * @param level
+ * @return version number
+ */
+extern int QRspec_getMinimumVersion(int size, enum QRecLevel level);
+
+/**
+ * Return the width of the symbol for the version.
+ * @param version
+ * @return width
+ */
+extern int QRspec_getWidth(int version);
+
+/**
+ * Return the numer of remainder bits.
+ * @param version
+ * @return number of remainder bits
+ */
+extern int QRspec_getRemainder(int version);
+
+/******************************************************************************
+ * Length indicator
+ *****************************************************************************/
+
+/**
+ * Return the size of lenght indicator for the mode and version.
+ * @param mode
+ * @param version
+ * @return the size of the appropriate length indicator (bits).
+ */
+extern int QRspec_lengthIndicator(enum QRencodeMode mode, int version);
+
+/**
+ * Return the maximum length for the mode and version.
+ * @param mode
+ * @param version
+ * @return the maximum length (bytes)
+ */
+extern int QRspec_maximumWords(enum QRencodeMode mode, int version);
+
+/******************************************************************************
+ * Error correction code
+ *****************************************************************************/
+
+/**
+ * Return an array of ECC specification.
+ * @param version
+ * @param level
+ * @param spec an array of ECC specification contains as following:
+ * {# of type1 blocks, # of data code, # of ecc code,
+ *  # of type2 blocks, # of data code}
+ */
+void QRspec_getEccSpec(int version, enum QRecLevel level, int spec[5]);
+
+#define QRspec_rsBlockNum(__spec__) (__spec__[0] + __spec__[3])
+#define QRspec_rsBlockNum1(__spec__) (__spec__[0])
+#define QRspec_rsDataCodes1(__spec__) (__spec__[1])
+#define QRspec_rsEccCodes1(__spec__) (__spec__[2])
+#define QRspec_rsBlockNum2(__spec__) (__spec__[3])
+#define QRspec_rsDataCodes2(__spec__) (__spec__[4])
+#define QRspec_rsEccCodes2(__spec__) (__spec__[2])
+
+#define QRspec_rsDataLength(__spec__) \
+	((QRspec_rsBlockNum1(__spec__) * QRspec_rsDataCodes1(__spec__)) + \
+	 (QRspec_rsBlockNum2(__spec__) * QRspec_rsDataCodes2(__spec__)))
+#define QRspec_rsEccLength(__spec__) \
+	(QRspec_rsBlockNum(__spec__) * QRspec_rsEccCodes1(__spec__))
+
+/******************************************************************************
+ * Version information pattern
+ *****************************************************************************/
+
+/**
+ * Return BCH encoded version information pattern that is used for the symbol
+ * of version 7 or greater. Use lower 18 bits.
+ * @param version
+ * @return BCH encoded version information pattern
+ */
+extern unsigned int QRspec_getVersionPattern(int version);
+
+/******************************************************************************
+ * Format information
+ *****************************************************************************/
+
+/**
+ * Return BCH encoded format information pattern.
+ * @param mask
+ * @param level
+ * @return BCH encoded format information pattern
+ */
+extern unsigned int QRspec_getFormatInfo(int mask, enum QRecLevel level);
+
+/******************************************************************************
+ * Frame
+ *****************************************************************************/
+
+/**
+ * Return a copy of initialized frame.
+ * When the same version is requested twice or more, a copy of cached frame
+ * is returned.
+ * @param version
+ * @return Array of unsigned char. You can free it by free().
+ */
+extern unsigned char *QRspec_newFrame(int version);
+
+/**
+ * Clear the frame cache. Typically for debug.
+ */
+extern void QRspec_clearCache(void);
+
+/******************************************************************************
+ * Mode indicator
+ *****************************************************************************/
+
+/**
+ * Mode indicator. See Table 2 of JIS X0510:2004, pp.16.
+ */
+#define QRSPEC_MODEID_ECI        7
+#define QRSPEC_MODEID_NUM        1
+#define QRSPEC_MODEID_AN         2
+#define QRSPEC_MODEID_8          4
+#define QRSPEC_MODEID_KANJI      8
+#define QRSPEC_MODEID_FNC1FIRST  5
+#define QRSPEC_MODEID_FNC1SECOND 9
+#define QRSPEC_MODEID_STRUCTURE  3
+#define QRSPEC_MODEID_TERMINATOR 0
+
+#endif /* __QRSPEC_H__ */
diff --git a/lib/qr/rscode.c b/lib/qr/rscode.c
new file mode 100644
index 0000000..7ef7b4b
--- /dev/null
+++ b/lib/qr/rscode.c
@@ -0,0 +1,325 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Reed solomon encoder. This code is taken from Phil Karn's libfec then
+ * editted and packed into a pair of .c and .h files.
+ *
+ * Copyright (C) 2002, 2003, 2004, 2006 Phil Karn, KA9Q
+ * (libfec is released under the GNU Lesser General Public License.)
+ *
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include "rscode.h"
+
+
+/**
+ * Reed-Solomon codec control block
+ */
+struct RS {
+	int mm;			/* Bits per symbol */
+	int nn;			/* Symbols per block (= (1<<mm)-1) */
+	unsigned char *alpha_to;	/* log lookup table */
+	unsigned char *index_of;	/* Antilog lookup table */
+	unsigned char *genpoly;	/* Generator polynomial */
+	/* Number of generator roots = number of parity symbols */
+	int nroots;
+	int fcr;		/* First consecutive root, index form */
+	int prim;		/* Primitive element, index form */
+	int iprim;		/* prim-th root of 1, index form */
+	int pad;		/* Padding bytes in shortened block */
+	int gfpoly;
+	struct RS *next;
+};
+
+static struct RS *rslist;
+
+static inline int modnn(struct RS *rs, int x)
+{
+	while (x >= rs->nn) {
+		x -= rs->nn;
+		x = (x >> rs->mm) + (x & rs->nn);
+	}
+	return x;
+}
+
+#define MODNN(x) modnn(rs, x)
+
+#define MM (rs->mm)
+#define NN (rs->nn)
+#define ALPHA_TO (rs->alpha_to)
+#define INDEX_OF (rs->index_of)
+#define GENPOLY (rs->genpoly)
+#define NROOTS (rs->nroots)
+#define FCR (rs->fcr)
+#define PRIM (rs->prim)
+#define IPRIM (rs->iprim)
+#define PAD (rs->pad)
+#define A0 (NN)
+
+/* Initialize a Reed-Solomon codec
+ * symsize = symbol size, bits
+ * gfpoly = Field generator polynomial coefficients
+ * fcr = first root of RS code generator polynomial, index form
+ * prim = primitive element to generate polynomial roots
+ * nroots = RS code generator polynomial degree (number of roots)
+ * pad = padding bytes at front of shortened block
+ */
+static struct RS *init_rs_char(int symsize, int gfpoly, int fcr,
+			       int prim, int nroots, int pad)
+{
+	struct RS *rs;
+
+/* Common code for intializing a Reed-Solomon control block
+ * (char or int symbols)
+ * Copyright 2004 Phil Karn, KA9Q
+ * May be used under the terms of the GNU General Public License (GPL)
+ */
+	int i, j, sr, root, iprim;
+
+	rs = NULL;
+	/* Check parameter ranges */
+	if (symsize < 0 || symsize > (int)(8 * sizeof(unsigned char)))
+		goto done;
+
+	if (fcr < 0 || fcr >= (1 << symsize))
+		goto done;
+	if (prim <= 0 || prim >= (1 << symsize))
+		goto done;
+	if (nroots < 0 || nroots >= (1 << symsize))
+		goto done;	/* Can't have more roots than symbol values! */
+	if (pad < 0 || pad >= ((1 << symsize) - 1 - nroots))
+		goto done;	/* Too much padding */
+
+	rs = kcalloc(1, sizeof(struct RS), GFP_ATOMIC);
+	if (rs == NULL)
+		goto done;
+
+	rs->mm = symsize;
+	rs->nn = (1 << symsize) - 1;
+	rs->pad = pad;
+
+	rs->alpha_to = kmalloc(sizeof(unsigned char) * (rs->nn + 1),
+			       GFP_ATOMIC);
+	if (rs->alpha_to == NULL) {
+		kfree(rs);
+		rs = NULL;
+		goto done;
+	}
+	rs->index_of = kmalloc(sizeof(unsigned char) * (rs->nn + 1),
+			       GFP_ATOMIC);
+	if (rs->index_of == NULL) {
+		kfree(rs->alpha_to);
+		kfree(rs);
+		rs = NULL;
+		goto done;
+	}
+
+	/* Generate Galois field lookup tables */
+	rs->index_of[0] = A0;	/* log(zero) = -inf */
+	rs->alpha_to[A0] = 0;	/* alpha**-inf = 0 */
+	sr = 1;
+	for (i = 0; i < rs->nn; i++) {
+		rs->index_of[sr] = i;
+		rs->alpha_to[i] = sr;
+		sr <<= 1;
+		if (sr & (1 << symsize))
+			sr ^= gfpoly;
+		sr &= rs->nn;
+	}
+	if (sr != 1) {
+		/* field generator polynomial is not primitive! */
+		kfree(rs->alpha_to);
+		kfree(rs->index_of);
+		kfree(rs);
+		rs = NULL;
+		goto done;
+	}
+
+	/* Form RS code generator polynomial from its roots */
+	rs->genpoly = kmalloc(sizeof(unsigned char) * (nroots + 1), GFP_ATOMIC);
+	if (rs->genpoly == NULL) {
+		kfree(rs->alpha_to);
+		kfree(rs->index_of);
+		kfree(rs);
+		rs = NULL;
+		goto done;
+	}
+	rs->fcr = fcr;
+	rs->prim = prim;
+	rs->nroots = nroots;
+	rs->gfpoly = gfpoly;
+
+	/* Find prim-th root of 1, used in decoding */
+	for (iprim = 1; (iprim % prim) != 0; iprim += rs->nn)
+		;
+	rs->iprim = iprim / prim;
+
+	rs->genpoly[0] = 1;
+	for (i = 0, root = fcr * prim; i < nroots; i++, root += prim) {
+		rs->genpoly[i + 1] = 1;
+
+		/* Multiply rs->genpoly[] by  @**(root + x) */
+		for (j = i; j > 0; j--) {
+			if (rs->genpoly[j] != 0)
+				rs->genpoly[j] =
+				    rs->genpoly[j -
+						1] ^ rs->alpha_to[modnn(rs,
+									rs->
+									index_of
+									[rs->
+									 genpoly
+									 [j]] +
+									root)];
+			else
+				rs->genpoly[j] = rs->genpoly[j - 1];
+		}
+		/* rs->genpoly[0] can never be zero */
+		rs->genpoly[0] =
+		    rs->
+		    alpha_to[modnn(rs, rs->index_of[rs->genpoly[0]] + root)];
+	}
+	/* convert rs->genpoly[] to index form for quicker encoding */
+	for (i = 0; i <= nroots; i++)
+		rs->genpoly[i] = rs->index_of[rs->genpoly[i]];
+done:;
+
+	return rs;
+}
+
+struct RS *init_rs(int symsize, int gfpoly, int fcr, int prim,
+		   int nroots, int pad)
+{
+	struct RS *rs;
+
+	for (rs = rslist; rs != NULL; rs = rs->next) {
+		if (rs->pad != pad)
+			continue;
+		if (rs->nroots != nroots)
+			continue;
+		if (rs->mm != symsize)
+			continue;
+		if (rs->gfpoly != gfpoly)
+			continue;
+		if (rs->fcr != fcr)
+			continue;
+		if (rs->prim != prim)
+			continue;
+
+		goto DONE;
+	}
+
+	rs = init_rs_char(symsize, gfpoly, fcr, prim, nroots, pad);
+	if (rs == NULL)
+		goto DONE;
+	rs->next = rslist;
+	rslist = rs;
+
+DONE:
+	return rs;
+}
+
+void free_rs_char(struct RS *rs)
+{
+	kfree(rs->alpha_to);
+	kfree(rs->index_of);
+	kfree(rs->genpoly);
+	kfree(rs);
+}
+
+void free_rs_cache(void)
+{
+	struct RS *rs, *next;
+
+	rs = rslist;
+	while (rs != NULL) {
+		next = rs->next;
+		free_rs_char(rs);
+		rs = next;
+	}
+	rslist = NULL;
+}
+
+/* The guts of the Reed-Solomon encoder, meant to be #included
+ * into a function body with the following typedefs, macros and
+ * variables supplied according to the code parameters:
+
+ * data_t - a typedef for the data symbol
+ * data_t data[] - array of NN-NROOTS-PAD and type data_t to be encoded
+ * data_t parity[] - an array of NROOTS and type data_t to be written
+ *                   with parity symbols
+ * NROOTS - the number of roots in the RS code generator polynomial,
+ *          which is the same as the number of parity symbols in a block.
+ *          Integer variable or literal.
+ *
+ * NN - the total number of symbols in a RS block. Integer variable or literal.
+ * PAD - the number of pad symbols in a block. Integer variable or literal.
+ * ALPHA_TO - The address of an array of NN elements to convert Galois field
+ *            elements in index (log) form to polynomial form. Read only.
+ * INDEX_OF - The address of an array of NN elements to convert Galois field
+ *            elements in polynomial form to index (log) form. Read only.
+ * MODNN - a function to reduce its argument modulo NN. May be inline or a macro
+ * GENPOLY - an array of NROOTS+1 elements containing the generator polynomial
+ *           in index form
+
+ * The memset() and memmove() functions are used. The appropriate header
+ * file declaring these functions (usually <string.h>) must be included by
+ * the calling program.
+
+ * Copyright 2004, Phil Karn, KA9Q
+ * May be used under the terms of the GNU Lesser General Public License (LGPL)
+ */
+
+#undef A0
+/* Special reserved value encoding zero in index form */
+#define A0 (NN)
+
+void encode_rs_char(struct RS *rs, const unsigned char *data,
+		    unsigned char *parity)
+{
+	int i, j;
+	unsigned char feedback;
+
+	memset(parity, 0, NROOTS * sizeof(unsigned char));
+
+	for (i = 0; i < NN - NROOTS - PAD; i++) {
+		feedback = INDEX_OF[data[i] ^ parity[0]];
+		if (feedback != A0) {	/* feedback term is non-zero */
+#ifdef UNNORMALIZED
+			/*
+			 * This line is unnecessary when GENPOLY[NROOTS]
+			 * is unity, as it must always be for the polynomials
+			 * constructed by init_rs()
+			 */
+			feedback = MODNN(NN - GENPOLY[NROOTS] + feedback);
+#endif
+			for (j = 1; j < NROOTS; j++)
+				parity[j] ^=
+				    ALPHA_TO[MODNN
+					     (feedback + GENPOLY[NROOTS - j])];
+		}
+		/* Shift */
+		memmove(&parity[0], &parity[1],
+			sizeof(unsigned char) * (NROOTS - 1));
+		if (feedback != A0)
+			parity[NROOTS - 1] =
+			    ALPHA_TO[MODNN(feedback + GENPOLY[0])];
+		else
+			parity[NROOTS - 1] = 0;
+	}
+}
diff --git a/lib/qr/rscode.h b/lib/qr/rscode.h
new file mode 100644
index 0000000..9b238b5
--- /dev/null
+++ b/lib/qr/rscode.h
@@ -0,0 +1,38 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Reed solomon encoder. This code is taken from Phil Karn's libfec then
+ * editted and packed into a pair of .c and .h files.
+ *
+ * Copyright (C) 2002, 2003, 2004, 2006 Phil Karn, KA9Q
+ * (libfec is released under the GNU Lesser General Public License.)
+ *
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __RSCODE_H__
+#define __RSCODE_H__
+
+/*
+ * General purpose RS codec, 8-bit symbols.
+ */
+
+extern struct RS *init_rs(int symsize, int gfpoly, int fcr, int prim,
+			  int nroots, int pad);
+extern void encode_rs_char(struct RS *rs, const unsigned char *data,
+			   unsigned char *parity);
+extern void free_rs_char(struct RS *rs);
+extern void free_rs_cache(void);
+
+#endif /* __RSCODE_H__ */
diff --git a/lib/qr/split.c b/lib/qr/split.c
new file mode 100644
index 0000000..17ef97d
--- /dev/null
+++ b/lib/qr/split.c
@@ -0,0 +1,331 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Input data splitter.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * The following data / specifications are taken from
+ * "Two dimensional symbol -- QR-code -- Basic Specification" (JIS X0510:2004)
+ *  or
+ * "Automatic identification and data capture techniques --
+ *  QR Code 2005 bar code symbology specification" (ISO/IEC 18004:2006)
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <linux/qrencode.h>
+#include "qrinput.h"
+#include "qrspec.h"
+#include "split.h"
+
+#define isdigit(__c__) ((unsigned char)((signed char)(__c__) - '0') < 10)
+#define isalnum(__c__) (QRinput_lookAnTable(__c__) >= 0)
+
+char *strdup(const char *s)
+{
+	size_t len = strlen(s) + 1;
+	void *new = kmalloc(len, GFP_ATOMIC);
+	if (new == NULL)
+		return NULL;
+	return (char *)memcpy(new, s, len);
+}
+
+static enum QRencodeMode Split_identifyMode(const char *string,
+					    enum QRencodeMode hint)
+{
+	unsigned char c, d;
+	unsigned int word;
+
+	c = string[0];
+
+	if (c == '\0')
+		return QR_MODE_NUL;
+	if (isdigit(c)) {
+		return QR_MODE_NUM;
+	} else if (isalnum(c)) {
+		return QR_MODE_AN;
+	} else if (hint == QR_MODE_KANJI) {
+		d = string[1];
+		if (d != '\0') {
+			word = ((unsigned int)c << 8) | d;
+			if ((word >= 0x8140 && word <= 0x9ffc)
+			    || (word >= 0xe040 && word <= 0xebbf)) {
+				return QR_MODE_KANJI;
+			}
+		}
+	}
+
+	return QR_MODE_8;
+}
+
+static int Split_eatNum(const char *string, struct QRinput *input,
+			enum QRencodeMode hint);
+static int Split_eatAn(const char *string, struct QRinput *input,
+		       enum QRencodeMode hint);
+static int Split_eat8(const char *string, struct QRinput *input,
+		      enum QRencodeMode hint);
+static int Split_eatKanji(const char *string, struct QRinput *input,
+			  enum QRencodeMode hint);
+
+static int Split_eatNum(const char *string, struct QRinput *input,
+			enum QRencodeMode hint)
+{
+	const char *p;
+	int ret;
+	int run;
+	int dif;
+	int ln;
+	enum QRencodeMode mode;
+
+	ln = QRspec_lengthIndicator(QR_MODE_NUM, input->version);
+
+	p = string;
+	while (isdigit(*p))
+		p++;
+	run = p - string;
+	mode = Split_identifyMode(p, hint);
+	if (mode == QR_MODE_8) {
+		dif = QRinput_estimateBitsModeNum(run) + 4 + ln
+			+ QRinput_estimateBitsMode8(1)	/* + 4 + l8 */
+			- QRinput_estimateBitsMode8(run + 1); /* - 4 - l8 */
+		if (dif > 0)
+			return Split_eat8(string, input, hint);
+	}
+	if (mode == QR_MODE_AN) {
+		dif = QRinput_estimateBitsModeNum(run) + 4 + ln
+			+ QRinput_estimateBitsModeAn(1)	/* + 4 + la */
+			- QRinput_estimateBitsModeAn(run + 1); /* - 4 - la */
+		if (dif > 0)
+			return Split_eatAn(string, input, hint);
+	}
+
+	ret = QRinput_append(input, QR_MODE_NUM, run, (unsigned char *)string);
+	if (ret < 0)
+		return -1;
+
+	return run;
+}
+
+static int Split_eatAn(const char *string, struct QRinput *input,
+		       enum QRencodeMode hint)
+{
+	const char *p, *q;
+	int ret;
+	int run;
+	int dif;
+	int la, ln;
+
+	la = QRspec_lengthIndicator(QR_MODE_AN, input->version);
+	ln = QRspec_lengthIndicator(QR_MODE_NUM, input->version);
+
+	p = string;
+	while (isalnum(*p)) {
+		if (isdigit(*p)) {
+			q = p;
+			while (isdigit(*q))
+				q++;
+			dif = QRinput_estimateBitsModeAn(p - string)
+				/* + 4 + la */
+				+ QRinput_estimateBitsModeNum(q - p) + 4 + ln
+				+ (isalnum(*q) ? (4 + ln) : 0)
+				- QRinput_estimateBitsModeAn(q - string)
+				/* - 4 - la */
+			    ;
+			if (dif < 0)
+				break;
+			else
+				p = q;
+		} else {
+			p++;
+		}
+	}
+
+	run = p - string;
+
+	if (*p && !isalnum(*p)) {
+		dif = QRinput_estimateBitsModeAn(run) + 4 + la
+			+ QRinput_estimateBitsMode8(1) /* + 4 + l8 */
+			- QRinput_estimateBitsMode8(run + 1); /* - 4 - l8 */
+		if (dif > 0)
+			return Split_eat8(string, input, hint);
+	}
+
+	ret = QRinput_append(input, QR_MODE_AN, run, (unsigned char *)string);
+	if (ret < 0)
+		return -1;
+
+	return run;
+}
+
+static int Split_eatKanji(const char *string, struct QRinput *input,
+			  enum QRencodeMode hint)
+{
+	const char *p;
+	int ret;
+	int run;
+
+	p = string;
+	while (Split_identifyMode(p, hint) == QR_MODE_KANJI)
+		p += 2;
+	run = p - string;
+	ret =
+	    QRinput_append(input, QR_MODE_KANJI, run, (unsigned char *)string);
+	if (ret < 0)
+		return -1;
+
+	return run;
+}
+
+static int Split_eat8(const char *string, struct QRinput *input,
+		      enum QRencodeMode hint)
+{
+	const char *p, *q;
+	enum QRencodeMode mode;
+	int ret;
+	int run;
+	int dif;
+	int la, ln, l8;
+	int swcost;
+
+	la = QRspec_lengthIndicator(QR_MODE_AN, input->version);
+	ln = QRspec_lengthIndicator(QR_MODE_NUM, input->version);
+	l8 = QRspec_lengthIndicator(QR_MODE_8, input->version);
+
+	p = string + 1;
+	while (*p != '\0') {
+		mode = Split_identifyMode(p, hint);
+		if (mode == QR_MODE_KANJI)
+			break;
+		if (mode == QR_MODE_NUM) {
+			q = p;
+			while (isdigit(*q))
+				q++;
+
+			if (Split_identifyMode(q, hint) == QR_MODE_8)
+				swcost = 4 + l8;
+			else
+				swcost = 0;
+			dif = QRinput_estimateBitsMode8(p - string)
+				/* + 4 + l8 */
+				+ QRinput_estimateBitsModeNum(q - p) + 4 + ln
+				+ swcost
+				- QRinput_estimateBitsMode8(q - string);
+				/* - 4 - l8 */
+			if (dif < 0)
+				break;
+			else
+				p = q;
+		} else if (mode == QR_MODE_AN) {
+			q = p;
+			while (isalnum(*q))
+				q++;
+			if (Split_identifyMode(q, hint) == QR_MODE_8)
+				swcost = 4 + l8;
+			else
+				swcost = 0;
+			dif = QRinput_estimateBitsMode8(p - string)
+				/* + 4 + l8 */
+				+ QRinput_estimateBitsModeAn(q - p) + 4 + la
+				+ swcost
+				- QRinput_estimateBitsMode8(q - string);
+				/* - 4 - l8 */
+			if (dif < 0)
+				break;
+			else
+				p = q;
+
+		} else {
+			p++;
+		}
+	}
+
+	run = p - string;
+	ret = QRinput_append(input, QR_MODE_8, run, (unsigned char *)string);
+	if (ret < 0)
+		return -1;
+
+	return run;
+}
+
+static int Split_splitString(const char *string, struct QRinput *input,
+			     enum QRencodeMode hint)
+{
+	int length;
+	enum QRencodeMode mode;
+
+	if (*string == '\0')
+		return 0;
+
+	mode = Split_identifyMode(string, hint);
+	if (mode == QR_MODE_NUM)
+		length = Split_eatNum(string, input, hint);
+	else if (mode == QR_MODE_AN)
+		length = Split_eatAn(string, input, hint);
+	else if (mode == QR_MODE_KANJI && hint == QR_MODE_KANJI)
+		length = Split_eatKanji(string, input, hint);
+	else
+		length = Split_eat8(string, input, hint);
+	if (length == 0)
+		return 0;
+	if (length < 0)
+		return -1;
+	return Split_splitString(&string[length], input, hint);
+}
+
+static char *dupAndToUpper(const char *str, enum QRencodeMode hint)
+{
+	char *newstr, *p;
+	enum QRencodeMode mode;
+
+	newstr = strdup(str);
+	if (newstr == NULL)
+		return NULL;
+
+	p = newstr;
+	while (*p != '\0') {
+		mode = Split_identifyMode(p, hint);
+		if (mode == QR_MODE_KANJI)
+			p += 2;
+		else {
+			if (*p >= 'a' && *p <= 'z')
+				*p = (char)((int)*p - 32);
+			p++;
+		}
+	}
+
+	return newstr;
+}
+
+int Split_splitStringToQRinput(const char *string, struct QRinput *input,
+			       enum QRencodeMode hint, int casesensitive)
+{
+	char *newstr;
+	int ret;
+
+	if (string == NULL || *string == '\0')
+		return -1;
+	if (!casesensitive) {
+		newstr = dupAndToUpper(string, hint);
+		if (newstr == NULL)
+			return -1;
+		ret = Split_splitString(newstr, input, hint);
+		kfree(newstr);
+	} else {
+		ret = Split_splitString(string, input, hint);
+	}
+
+	return ret;
+}
diff --git a/lib/qr/split.h b/lib/qr/split.h
new file mode 100644
index 0000000..003a1b3
--- /dev/null
+++ b/lib/qr/split.h
@@ -0,0 +1,44 @@
+/*
+ * qrencode - QR Code encoder
+ *
+ * Input data splitter.
+ * Copyright (C) 2006-2011 Kentaro Fukuchi <kentaro@fukuchi.org>
+ *
+ * The following data / specifications are taken from
+ * "Two dimensional symbol -- QR-code -- Basic Specification" (JIS X0510:2004)
+ *  or
+ * "Automatic identification and data capture techniques --
+ *  QR Code 2005 bar code symbology specification" (ISO/IEC 18004:2006)
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __SPLIT_H__
+#define __SPLIT_H__
+
+#include <linux/qrencode.h>
+
+/**
+ * Split the input string (null terminated) into QRinput.
+ * @param string input string
+ * @param hint give QR_MODE_KANJI if the input string contains Kanji character encoded in Shift-JIS. If not, give QR_MODE_8.
+ * @param casesensitive 0 for case-insensitive encoding (all alphabet characters are replaced to UPPER-CASE CHARACTERS.
+ * @retval 0 success.
+ * @retval -1 an error occurred. errno is set to indicate the error. See
+ *               Exceptions for the details.
+ * @throw EINVAL invalid input object.
+ * @throw ENOMEM unable to allocate memory for input objects.
+ */
+extern int Split_splitStringToQRinput(const char *string, struct QRinput *input,
+		enum QRencodeMode hint, int casesensitive);
+
+#endif /* __SPLIT_H__ */
-- 
1.8.3.2

