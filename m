Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3ETJpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:45:00 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:53837 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3ETJo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:44:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Remove inline strcpy() and strcat() implementations
Date: Mon, 20 May 2013 11:44:37 +0200
Message-Id: <1369043077-31375-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc may replace calls to standard string functions by open code and/or
calls to other standard string functions. If the replacement function is
not available out-of-line, link errors will happen.

To avoid this, the out-of-line versions were provided by
arch/m68k/lib/string.c, but they were usually not linked in anymore as
typically none of its symbols are referenced by built-in code.
However, if any module would need them, they would not be available.

Hence remove the inline strcpy() and strcat() implementations, remove
arch/m68k/lib/string.c, and let the generic string library code handle it.

Impact on a typical kernel build seems minimal or nonexistent:

-      .text : 0x00001000 - 0x002aac74   (2728 KiB)
-      .data : 0x002ada48 - 0x00392148   ( 914 KiB)
+      .text : 0x00001000 - 0x002aacf4   (2728 KiB)
+      .data : 0x002adac8 - 0x00392148   ( 914 KiB)

See also commit e00c73ee05dc38ecaccced55d4f5fc58b0b769f7 ("m68k: Remove
inline strlen() implementation").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/string.h |   32 --------------------------------
 arch/m68k/lib/Makefile         |    2 +-
 arch/m68k/lib/string.c         |   22 ----------------------
 3 files changed, 1 insertions(+), 55 deletions(-)
 delete mode 100644 arch/m68k/lib/string.c

diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
index 9aea9f1..c30c03d 100644
--- a/arch/m68k/include/asm/string.h
+++ b/arch/m68k/include/asm/string.h
@@ -4,20 +4,6 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-static inline char *__kernel_strcpy(char *dest, const char *src)
-{
-	char *xdest = dest;
-
-	asm volatile ("\n"
-		"1:	move.b	(%1)+,(%0)+\n"
-		"	jne	1b"
-		: "+a" (dest), "+a" (src)
-		: : "memory");
-	return xdest;
-}
-
-#ifndef __IN_STRING_C
-
 #define __HAVE_ARCH_STRNLEN
 static inline size_t strnlen(const char *s, size_t count)
 {
@@ -34,16 +20,6 @@ static inline size_t strnlen(const char *s, size_t count)
 	return sc - s;
 }
 
-#define __HAVE_ARCH_STRCPY
-#if __GNUC__ >= 4
-#define strcpy(d, s)	(__builtin_constant_p(s) &&	\
-			 __builtin_strlen(s) <= 32 ?	\
-			 __builtin_strcpy(d, s) :	\
-			 __kernel_strcpy(d, s))
-#else
-#define strcpy(d, s)	__kernel_strcpy(d, s)
-#endif
-
 #define __HAVE_ARCH_STRNCPY
 static inline char *strncpy(char *dest, const char *src, size_t n)
 {
@@ -61,12 +37,6 @@ static inline char *strncpy(char *dest, const char *src, size_t n)
 	return xdest;
 }
 
-#define __HAVE_ARCH_STRCAT
-#define strcat(d, s)	({			\
-	char *__d = (d);			\
-	strcpy(__d + strlen(__d), (s));		\
-})
-
 #ifndef CONFIG_COLDFIRE
 #define __HAVE_ARCH_STRCMP
 static inline int strcmp(const char *cs, const char *ct)
@@ -100,6 +70,4 @@ extern void *memset(void *, int, __kernel_size_t);
 extern void *memcpy(void *, const void *, __kernel_size_t);
 #define memcpy(d, s, n) __builtin_memcpy(d, s, n)
 
-#endif
-
 #endif /* _M68K_STRING_H_ */
diff --git a/arch/m68k/lib/Makefile b/arch/m68k/lib/Makefile
index a9d782d..fcd8eb1 100644
--- a/arch/m68k/lib/Makefile
+++ b/arch/m68k/lib/Makefile
@@ -6,7 +6,7 @@
 lib-y	:= ashldi3.o ashrdi3.o lshrdi3.o muldi3.o \
 	   memcpy.o memset.o memmove.o
 
-lib-$(CONFIG_MMU) += string.o uaccess.o
+lib-$(CONFIG_MMU) += uaccess.o
 lib-$(CONFIG_CPU_HAS_NO_MULDIV64) += mulsi3.o divsi3.o udivsi3.o
 lib-$(CONFIG_CPU_HAS_NO_MULDIV64) += modsi3.o umodsi3.o
 
diff --git a/arch/m68k/lib/string.c b/arch/m68k/lib/string.c
deleted file mode 100644
index 4d61fa8..0000000
--- a/arch/m68k/lib/string.c
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
- */
-
-#define __IN_STRING_C
-
-#include <linux/module.h>
-#include <linux/string.h>
-
-char *strcpy(char *dest, const char *src)
-{
-	return __kernel_strcpy(dest, src);
-}
-EXPORT_SYMBOL(strcpy);
-
-char *strcat(char *dest, const char *src)
-{
-	return __kernel_strcpy(dest + strlen(dest), src);
-}
-EXPORT_SYMBOL(strcat);
-- 
1.7.0.4

