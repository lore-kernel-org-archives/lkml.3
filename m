Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaFJXOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38709 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaFJXNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:13:49 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 08/10] tools: Move unaligned common infrastructure into <tools/unaligned.h>
Date: Tue, 10 Jun 2014 16:13:12 -0700
Message-Id: <1402441994-16780-9-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move common includes and infrastructure into <tools/unaligned.h>.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 tools/include/tools/unaligned.h              | 34 ++++++++++++++++++++++++++++
 tools/include/tools/unaligned/be_bswap.h     |  2 --
 tools/include/tools/unaligned/be_byteshift.h |  2 --
 tools/include/tools/unaligned/be_direct.h    |  2 --
 tools/include/tools/unaligned/be_endian.h    |  6 -----
 tools/include/tools/unaligned/be_struct.h    | 14 ------------
 tools/include/tools/unaligned/le_bswap.h     |  2 --
 tools/include/tools/unaligned/le_byteshift.h |  2 --
 tools/include/tools/unaligned/le_direct.h    |  2 --
 tools/include/tools/unaligned/le_endian.h    |  6 -----
 tools/include/tools/unaligned/le_struct.h    | 12 ----------
 11 files changed, 34 insertions(+), 50 deletions(-)

diff --git a/tools/include/tools/unaligned.h b/tools/include/tools/unaligned.h
index f89c089b6148..a3d43989bd25 100644
--- a/tools/include/tools/unaligned.h
+++ b/tools/include/tools/unaligned.h
@@ -1,2 +1,36 @@
+#ifndef TOOLS_UNALIGNED_H
+#define TOOLS_UNALIGNED_H
+
+#include <stdint.h>
+
+#ifndef _BSD_SOURCE
+# define _BSD_SOURCE 1
+#endif
+#include <endian.h>
+
+#ifdef __GNUC__
+
+struct _packed_u16_struct {
+	uint16_t v;
+} __attribute__((packed));
+
+struct _packed_u32_struct {
+	uint32_t v;
+} __attribute__((packed));
+
+struct _packed_u64_struct {
+	uint64_t v;
+} __attribute__((packed));
+
+#define TOOLS_UNALIGNED_GCC ((__GNUC__ << 16) + (__GNUC_MINOR__ << 8) + __GNUC_PATCHLEVEL__)
+
+#else
+
+#define TOOLS_UNALIGNED_GCC 0
+
+#endif /* __GNUC__ */
+
 #include <tools/unaligned/le_byteshift.h>
 #include <tools/unaligned/be_byteshift.h>
+
+#endif /* TOOLS_UNALIGNED_H */
diff --git a/tools/include/tools/unaligned/be_bswap.h b/tools/include/tools/unaligned/be_bswap.h
index 5e63da922d23..72855d3af5f2 100644
--- a/tools/include/tools/unaligned/be_bswap.h
+++ b/tools/include/tools/unaligned/be_bswap.h
@@ -1,8 +1,6 @@
 #ifndef TOOLS_BE_BSWAP_H
 #define TOOLS_BE_BSWAP_H
 
-#include <stdint.h>
-
 static inline uint16_t get_unaligned_be16(const void *_p)
 {
 	return __builtin_bswap16(get_unaligned_le16(_p));
diff --git a/tools/include/tools/unaligned/be_byteshift.h b/tools/include/tools/unaligned/be_byteshift.h
index 068a5a8b47b2..ee0ff62c63cc 100644
--- a/tools/include/tools/unaligned/be_byteshift.h
+++ b/tools/include/tools/unaligned/be_byteshift.h
@@ -1,8 +1,6 @@
 #ifndef TOOLS_BE_BYTESHIFT_H
 #define TOOLS_BE_BYTESHIFT_H
 
-#include <stdint.h>
-
 static inline uint16_t get_unaligned_be16(const void *_p)
 {
 	const uint8_t *p = _p;
diff --git a/tools/include/tools/unaligned/be_direct.h b/tools/include/tools/unaligned/be_direct.h
index 4f446856aa84..1ce1c4a94a01 100644
--- a/tools/include/tools/unaligned/be_direct.h
+++ b/tools/include/tools/unaligned/be_direct.h
@@ -1,8 +1,6 @@
 #ifndef TOOLS_BE_DIRECT_H
 #define TOOLS_BE_DIRECT_H
 
-#include <stdint.h>
-
 static inline uint16_t get_unaligned_be16(const void *_p)
 {
 	const uint16_t *p = _p;
diff --git a/tools/include/tools/unaligned/be_endian.h b/tools/include/tools/unaligned/be_endian.h
index 52ee4a47e23c..bed93fd0c88b 100644
--- a/tools/include/tools/unaligned/be_endian.h
+++ b/tools/include/tools/unaligned/be_endian.h
@@ -1,12 +1,6 @@
 #ifndef TOOLS_BE_ENDIAN_H
 #define TOOLS_BE_ENDIAN_H
 
-#ifndef _BSD_SOURCE
-# define _BSD_SOURCE 1
-#endif
-#include <endian.h>
-#include <stdint.h>
-
 static inline uint16_t get_unaligned_be16(const void *_p)
 {
 	return be16toh(get_unaligned_le16(_p));
diff --git a/tools/include/tools/unaligned/be_struct.h b/tools/include/tools/unaligned/be_struct.h
index 2543fee4acda..127ecfdc1ac0 100644
--- a/tools/include/tools/unaligned/be_struct.h
+++ b/tools/include/tools/unaligned/be_struct.h
@@ -1,20 +1,6 @@
 #ifndef TOOLS_BE_STRUCT_H
 #define TOOLS_BE_STRUCT_H
 
-#include <stdint.h>
-
-struct _packed_u16_struct {
-	uint16_t v;
-} __attribute__((packed));
-
-struct _packed_u32_struct {
-	uint32_t v;
-} __attribute__((packed));
-
-struct _packed_u64_struct {
-	uint64_t v;
-} __attribute__((packed));
-
 static inline uint16_t get_unaligned_be16(const void *_p)
 {
 	const struct _packed_u16_struct *p = _p;
diff --git a/tools/include/tools/unaligned/le_bswap.h b/tools/include/tools/unaligned/le_bswap.h
index 199b42a7b862..f9717b7e072d 100644
--- a/tools/include/tools/unaligned/le_bswap.h
+++ b/tools/include/tools/unaligned/le_bswap.h
@@ -1,8 +1,6 @@
 #ifndef TOOLS_LE_BSWAP_H
 #define TOOLS_LE_BSWAP_H
 
-#include <stdint.h>
-
 static inline uint16_t get_unaligned_le16(const void *_p)
 {
 	return __builtin_bswap16(get_unaligned_be16(_p));
diff --git a/tools/include/tools/unaligned/le_byteshift.h b/tools/include/tools/unaligned/le_byteshift.h
index dfd5d42b9783..bf54188b5210 100644
--- a/tools/include/tools/unaligned/le_byteshift.h
+++ b/tools/include/tools/unaligned/le_byteshift.h
@@ -1,8 +1,6 @@
 #ifndef TOOLS_LE_BYTESHIFT_H
 #define TOOLS_LE_BYTESHIFT_H
 
-#include <stdint.h>
-
 static inline uint16_t get_unaligned_le16(const void *_p)
 {
 	const uint8_t *p = _p;
diff --git a/tools/include/tools/unaligned/le_direct.h b/tools/include/tools/unaligned/le_direct.h
index 17b773284edd..b599020be21f 100644
--- a/tools/include/tools/unaligned/le_direct.h
+++ b/tools/include/tools/unaligned/le_direct.h
@@ -1,8 +1,6 @@
 #ifndef TOOLS_LE_DIRECT_H
 #define TOOLS_LE_DIRECT_H
 
-#include <stdint.h>
-
 static inline uint16_t get_unaligned_le16(const void *_p)
 {
 	const uint16_t *p = _p;
diff --git a/tools/include/tools/unaligned/le_endian.h b/tools/include/tools/unaligned/le_endian.h
index bc8c2d41be0e..a412af39eda9 100644
--- a/tools/include/tools/unaligned/le_endian.h
+++ b/tools/include/tools/unaligned/le_endian.h
@@ -1,12 +1,6 @@
 #ifndef TOOLS_LE_ENDIAN_H
 #define TOOLS_LE_ENDIAN_H
 
-#ifndef _BSD_SOURCE
-# define _BSD_SOURCE 1
-#endif
-#include <endian.h>
-#include <stdint.h>
-
 static inline uint16_t get_unaligned_le16(const void *_p)
 {
 	return le16toh(get_unaligned_be16(_p));
diff --git a/tools/include/tools/unaligned/le_struct.h b/tools/include/tools/unaligned/le_struct.h
index f6f271a5824b..b1ac490dcb3f 100644
--- a/tools/include/tools/unaligned/le_struct.h
+++ b/tools/include/tools/unaligned/le_struct.h
@@ -3,18 +3,6 @@
 
 #include <stdint.h>
 
-struct _packed_u16_struct {
-	uint16_t v;
-} __attribute__((packed));
-
-struct _packed_u32_struct {
-	uint32_t v;
-} __attribute__((packed));
-
-struct _packed_u64_struct {
-	uint64_t v;
-} __attribute__((packed));
-
 static inline uint16_t get_unaligned_le16(const void *_p)
 {
 	const struct _packed_u16_struct *p = _p;
-- 
1.9.3

