Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab3HAUZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:25:09 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:12037 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab3HAUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:25:03 -0400
Message-ID: <201308012025.r71KP3le029955@farm-0021.internal.tilera.com>
From: Ken Steele <ken@tilera.com>
Date: Thu, 1 Aug 2013 15:55:07 -0400
Subject: [PATCH] tile: optimize strnlen using SIMD instructions
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using strlen as a model, add length checking to create strnlen.

Signed-off-by: Ken Steele <ken@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/string.h |  2 ++
 arch/tile/lib/Makefile         |  2 +-
 arch/tile/lib/strnlen_32.c     | 49 ++++++++++++++++++++++++++++++++++++++++++
 arch/tile/lib/strnlen_64.c     | 48 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 arch/tile/lib/strnlen_32.c
 create mode 100644 arch/tile/lib/strnlen_64.c

diff --git a/arch/tile/include/asm/string.h b/arch/tile/include/asm/string.h
index 7535cf1..92b271b 100644
--- a/arch/tile/include/asm/string.h
+++ b/arch/tile/include/asm/string.h
@@ -21,8 +21,10 @@
 #define __HAVE_ARCH_MEMMOVE
 #define __HAVE_ARCH_STRCHR
 #define __HAVE_ARCH_STRLEN
+#define __HAVE_ARCH_STRNLEN
 
 extern __kernel_size_t strlen(const char *);
+extern __kernel_size_t strnlen(const char *, __kernel_size_t);
 extern char *strchr(const char *s, int c);
 extern void *memchr(const void *s, int c, size_t n);
 extern void *memset(void *, int, __kernel_size_t);
diff --git a/arch/tile/lib/Makefile b/arch/tile/lib/Makefile
index 985f598..5d84437 100644
--- a/arch/tile/lib/Makefile
+++ b/arch/tile/lib/Makefile
@@ -4,7 +4,7 @@
 
 lib-y = cacheflush.o checksum.o cpumask.o delay.o uaccess.o \
 	memmove.o memcpy_$(BITS).o memchr_$(BITS).o memset_$(BITS).o \
-	strchr_$(BITS).o strlen_$(BITS).o
+	strchr_$(BITS).o strlen_$(BITS).o strnlen_$(BITS).o
 
 ifeq ($(CONFIG_TILEGX),y)
 CFLAGS_REMOVE_memcpy_user_64.o = -fno-omit-frame-pointer
diff --git a/arch/tile/lib/strnlen_32.c b/arch/tile/lib/strnlen_32.c
new file mode 100644
index 0000000..4490cf9
--- /dev/null
+++ b/arch/tile/lib/strnlen_32.c
@@ -0,0 +1,49 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+size_t strnlen(const char *s, size_t count)
+{
+	/* Get an aligned pointer. */
+	const uintptr_t s_int = (uintptr_t) s;
+	const uint32_t *p = (const uint32_t *)(s_int & -4);
+	size_t bytes_read = sizeof(*p) - (s_int & (sizeof(*p) - 1));
+	size_t len;
+	uint32_t v, bits;
+
+	/* Avoid page fault risk by not reading any bytes when count is 0. */
+	if (count == 0)
+		return 0;
+
+	/* Read the first word, but force bytes before the string to be nonzero.
+	 * This expression works because we know shift counts are taken mod 32.
+	 */
+	v = *p | ((1 << (s_int << 3)) - 1);
+
+	while ((bits = __insn_seqb(v, 0)) == 0) {
+		if (bytes_read >= count) {
+			/* Read COUNT bytes and didn't find the terminator. */
+			return count;
+		}
+		v = *++p;
+		bytes_read += sizeof(v);
+	}
+
+	len = ((const char *) p) + (__insn_ctz(bits) >> 3) - s;
+	return (len < count ? len : count);
+}
+EXPORT_SYMBOL(strnlen);
diff --git a/arch/tile/lib/strnlen_64.c b/arch/tile/lib/strnlen_64.c
new file mode 100644
index 0000000..2e8de6a
--- /dev/null
+++ b/arch/tile/lib/strnlen_64.c
@@ -0,0 +1,48 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include "string-endian.h"
+
+size_t strnlen(const char *s, size_t count)
+{
+	/* Get an aligned pointer. */
+	const uintptr_t s_int = (uintptr_t) s;
+	const uint64_t *p = (const uint64_t *)(s_int & -8);
+	size_t bytes_read = sizeof(*p) - (s_int & (sizeof(*p) - 1));
+	size_t len;
+	uint64_t v, bits;
+
+	/* Avoid page fault risk by not reading any bytes when count is 0. */
+	if (count == 0)
+		return 0;
+
+	/* Read and MASK the first word. */
+	v = *p | MASK(s_int);
+
+	while ((bits = __insn_v1cmpeqi(v, 0)) == 0) {
+		if (bytes_read >= count) {
+			/* Read COUNT bytes and didn't find the terminator. */
+			return count;
+		}
+		v = *++p;
+		bytes_read += sizeof(v);
+	}
+
+	len = ((const char *) p) + (CFZ(bits) >> 3) - s;
+	return (len < count ? len : count);
+}
+EXPORT_SYMBOL(strnlen);
-- 
1.8.3.1

