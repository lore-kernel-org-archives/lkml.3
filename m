Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaFJXOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38710 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaFJXNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:13:49 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 02/10] tools: Create <tools/unaligned.h> and an unaligned subdirectory
Date: Tue, 10 Jun 2014 16:13:06 -0700
Message-Id: <1402441994-16780-3-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create <tools/unaligned.h> and create an unaligned subdirectory for
specific implementations -- currently including the existing
be_byteshift.h and le_byteshift.h.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/mkpiggy.c           |  2 +-
 arch/x86/boot/tools/build.c                  |  2 +-
 arch/x86/tools/relocs.h                      |  2 +-
 scripts/sortextable.c                        |  3 +-
 tools/include/tools/be_byteshift.h           | 52 ----------------------------
 tools/include/tools/le_byteshift.h           | 52 ----------------------------
 tools/include/tools/unaligned.h              |  2 ++
 tools/include/tools/unaligned/be_byteshift.h | 52 ++++++++++++++++++++++++++++
 tools/include/tools/unaligned/le_byteshift.h | 52 ++++++++++++++++++++++++++++
 tools/usb/ffs-test.c                         |  2 +-
 10 files changed, 111 insertions(+), 110 deletions(-)
 delete mode 100644 tools/include/tools/be_byteshift.h
 delete mode 100644 tools/include/tools/le_byteshift.h
 create mode 100644 tools/include/tools/unaligned.h
 create mode 100644 tools/include/tools/unaligned/be_byteshift.h
 create mode 100644 tools/include/tools/unaligned/le_byteshift.h

diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index b669ab65bf6c..dc009d80dd34 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -29,7 +29,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <inttypes.h>
-#include <tools/le_byteshift.h>
+#include <tools/unaligned.h>
 
 int main(int argc, char *argv[])
 {
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 1a2f2121cada..010892234f94 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -33,7 +33,7 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/mman.h>
-#include <tools/le_byteshift.h>
+#include <tools/unaligned.h>
 
 typedef unsigned char  u8;
 typedef unsigned short u16;
diff --git a/arch/x86/tools/relocs.h b/arch/x86/tools/relocs.h
index f59590645b68..69ae4d2b121c 100644
--- a/arch/x86/tools/relocs.h
+++ b/arch/x86/tools/relocs.h
@@ -14,7 +14,7 @@
 #define USE_BSD
 #include <endian.h>
 #include <regex.h>
-#include <tools/le_byteshift.h>
+#include <tools/unaligned.h>
 
 void die(char *fmt, ...);
 
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index cc49062acdee..a17a7dbd8dce 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -28,8 +28,7 @@
 #include <string.h>
 #include <unistd.h>
 
-#include <tools/be_byteshift.h>
-#include <tools/le_byteshift.h>
+#include <tools/unaligned.h>
 
 #ifndef EM_ARCOMPACT
 #define EM_ARCOMPACT	93
diff --git a/tools/include/tools/be_byteshift.h b/tools/include/tools/be_byteshift.h
deleted file mode 100644
index 9850c7df2667..000000000000
--- a/tools/include/tools/be_byteshift.h
+++ /dev/null
@@ -1,52 +0,0 @@
-#ifndef _TOOLS_BE_BYTESHIFT_H
-#define _TOOLS_BE_BYTESHIFT_H
-
-#include <stdint.h>
-
-static inline uint16_t get_unaligned_be16(const void *_p)
-{
-	const uint8_t *p = _p;
-
-	return p[0] << 8 | p[1];
-}
-
-static inline uint32_t get_unaligned_be32(const void *_p)
-{
-	const uint8_t *p = _p;
-
-	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
-}
-
-static inline uint64_t get_unaligned_be64(const void *_p)
-{
-	const uint8_t *p = _p;
-
-	return (uint64_t)get_unaligned_be32(p) << 32 |
-		get_unaligned_be32(p + 4);
-}
-
-static inline void put_unaligned_be16(uint16_t val, void *_p)
-{
-	uint8_t *p = _p;
-
-	*p++ = val >> 8;
-	*p++ = val;
-}
-
-static inline void put_unaligned_be32(uint32_t val, void *_p)
-{
-	uint8_t *p = _p;
-
-	put_unaligned_be16(val >> 16, p);
-	put_unaligned_be16(val, p + 2);
-}
-
-static inline void put_unaligned_be64(uint64_t val, void *_p)
-{
-	uint8_t *p = _p;
-
-	put_unaligned_be32(val >> 32, p);
-	put_unaligned_be32(val, p + 4);
-}
-
-#endif /* _TOOLS_BE_BYTESHIFT_H */
diff --git a/tools/include/tools/le_byteshift.h b/tools/include/tools/le_byteshift.h
deleted file mode 100644
index 819ba186ede5..000000000000
--- a/tools/include/tools/le_byteshift.h
+++ /dev/null
@@ -1,52 +0,0 @@
-#ifndef _TOOLS_LE_BYTESHIFT_H
-#define _TOOLS_LE_BYTESHIFT_H
-
-#include <stdint.h>
-
-static inline uint16_t get_unaligned_le16(const void *_p)
-{
-	const uint8_t *p = _p;
-
-	return p[0] | p[1] << 8;
-}
-
-static inline uint32_t get_unaligned_le32(const void *_p)
-{
-	const uint8_t *p = _p;
-
-	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
-}
-
-static inline uint64_t get_unaligned_le64(const void *_p)
-{
-	const uint8_t *p = _p;
-
-	return (uint64_t)get_unaligned_le32(p + 4) << 32 |
-		get_unaligned_le32(p);
-}
-
-static inline void put_unaligned_le16(uint16_t val, void *_p)
-{
-	uint8_t *p = _p;
-
-	*p++ = val;
-	*p++ = val >> 8;
-}
-
-static inline void put_unaligned_le32(uint32_t val, void *_p)
-{
-	uint8_t *p = _p;
-
-	put_unaligned_le16(val, p);
-	put_unaligned_le16(val >> 16, p + 2);
-}
-
-static inline void put_unaligned_le64(uint64_t val, void *_p)
-{
-	uint8_t *p = _p;
-
-	put_unaligned_le32(val, p);
-	put_unaligned_le32(val >> 32, p + 4);
-}
-
-#endif /* _TOOLS_LE_BYTESHIFT_H */
diff --git a/tools/include/tools/unaligned.h b/tools/include/tools/unaligned.h
new file mode 100644
index 000000000000..f89c089b6148
--- /dev/null
+++ b/tools/include/tools/unaligned.h
@@ -0,0 +1,2 @@
+#include <tools/unaligned/le_byteshift.h>
+#include <tools/unaligned/be_byteshift.h>
diff --git a/tools/include/tools/unaligned/be_byteshift.h b/tools/include/tools/unaligned/be_byteshift.h
new file mode 100644
index 000000000000..9850c7df2667
--- /dev/null
+++ b/tools/include/tools/unaligned/be_byteshift.h
@@ -0,0 +1,52 @@
+#ifndef _TOOLS_BE_BYTESHIFT_H
+#define _TOOLS_BE_BYTESHIFT_H
+
+#include <stdint.h>
+
+static inline uint16_t get_unaligned_be16(const void *_p)
+{
+	const uint8_t *p = _p;
+
+	return p[0] << 8 | p[1];
+}
+
+static inline uint32_t get_unaligned_be32(const void *_p)
+{
+	const uint8_t *p = _p;
+
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline uint64_t get_unaligned_be64(const void *_p)
+{
+	const uint8_t *p = _p;
+
+	return (uint64_t)get_unaligned_be32(p) << 32 |
+		get_unaligned_be32(p + 4);
+}
+
+static inline void put_unaligned_be16(uint16_t val, void *_p)
+{
+	uint8_t *p = _p;
+
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void put_unaligned_be32(uint32_t val, void *_p)
+{
+	uint8_t *p = _p;
+
+	put_unaligned_be16(val >> 16, p);
+	put_unaligned_be16(val, p + 2);
+}
+
+static inline void put_unaligned_be64(uint64_t val, void *_p)
+{
+	uint8_t *p = _p;
+
+	put_unaligned_be32(val >> 32, p);
+	put_unaligned_be32(val, p + 4);
+}
+
+#endif /* _TOOLS_BE_BYTESHIFT_H */
diff --git a/tools/include/tools/unaligned/le_byteshift.h b/tools/include/tools/unaligned/le_byteshift.h
new file mode 100644
index 000000000000..819ba186ede5
--- /dev/null
+++ b/tools/include/tools/unaligned/le_byteshift.h
@@ -0,0 +1,52 @@
+#ifndef _TOOLS_LE_BYTESHIFT_H
+#define _TOOLS_LE_BYTESHIFT_H
+
+#include <stdint.h>
+
+static inline uint16_t get_unaligned_le16(const void *_p)
+{
+	const uint8_t *p = _p;
+
+	return p[0] | p[1] << 8;
+}
+
+static inline uint32_t get_unaligned_le32(const void *_p)
+{
+	const uint8_t *p = _p;
+
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+}
+
+static inline uint64_t get_unaligned_le64(const void *_p)
+{
+	const uint8_t *p = _p;
+
+	return (uint64_t)get_unaligned_le32(p + 4) << 32 |
+		get_unaligned_le32(p);
+}
+
+static inline void put_unaligned_le16(uint16_t val, void *_p)
+{
+	uint8_t *p = _p;
+
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void put_unaligned_le32(uint32_t val, void *_p)
+{
+	uint8_t *p = _p;
+
+	put_unaligned_le16(val, p);
+	put_unaligned_le16(val >> 16, p + 2);
+}
+
+static inline void put_unaligned_le64(uint64_t val, void *_p)
+{
+	uint8_t *p = _p;
+
+	put_unaligned_le32(val, p);
+	put_unaligned_le32(val >> 32, p + 4);
+}
+
+#endif /* _TOOLS_LE_BYTESHIFT_H */
diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index fe1e66b6ef40..39695d18b3e7 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -36,7 +36,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <unistd.h>
-#include <tools/le_byteshift.h>
+#include <tools/unaligned.h>
 
 #include "../../include/uapi/linux/usb/functionfs.h"
 
-- 
1.9.3

