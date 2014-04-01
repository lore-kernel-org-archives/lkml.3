Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaDASw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:52:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaDASw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:52:56 -0400
Date: Tue, 1 Apr 2014 11:52:33 -0700
Message-Id: <201404011852.s31IqXuk025145@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/boot changes for v3.15
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: hpa@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patchset is a set of cleanups aiming at librarize some of the
common code from the boot environments.  We currently have three
different "little environments" (boot, boot/compressed, and
realmode/rm) in x86, and we are likely to soon get a fourth one
(kexec/purgatory, which will have to be integrated in the kernel to
support secure kexec).  This is primarily a cleanup in the
anticipation of the latter.

While Vivek implemented this, he ran into some bugs, in particular the
memcmp implementation for when gcc punts from using the builtin would
have a misnamed symbol, causing compilation errors if we were ever
unlucky enough that gcc didn't want to inline the test.

The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15:

  Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/boot

for you to fetch changes up to 04999550f93234bf05597a9b7d26e2bfe27ba883:

  x86, boot: Move memset() definition in compressed/string.c (2014-03-19 15:44:09 -0700)

----------------------------------------------------------------
Vivek Goyal (5):
      x86, boot: Undef memcmp before providing a new definition
      x86, boot: Create a separate string.h file to provide standard string functions
      x86, boot: Move optimized memcpy() 32/64 bit versions to compressed/string.c
      x86, boot: Move memcmp() into string.h and string.c
      x86, boot: Move memset() definition in compressed/string.c

 arch/x86/boot/boot.h              | 13 ----------
 arch/x86/boot/compressed/misc.c   | 51 ++++++---------------------------------
 arch/x86/boot/compressed/string.c | 46 ++++++++++++++++++++++++++++++-----
 arch/x86/boot/cpucheck.c          |  1 +
 arch/x86/boot/edd.c               |  1 +
 arch/x86/boot/main.c              |  1 +
 arch/x86/boot/regs.c              |  1 +
 arch/x86/boot/string.c            | 14 +++++++++++
 arch/x86/boot/string.h            | 21 ++++++++++++++++
 arch/x86/boot/video-vesa.c        |  1 +
 10 files changed, 88 insertions(+), 62 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 50f8c5e..bd49ec6 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -177,14 +177,6 @@ static inline void wrgs32(u32 v, addr_t addr)
 }
 
 /* Note: these only return true/false, not a signed return value! */
-static inline int memcmp(const void *s1, const void *s2, size_t len)
-{
-	u8 diff;
-	asm("repe; cmpsb; setnz %0"
-	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
-	return diff;
-}
-
 static inline int memcmp_fs(const void *s1, addr_t s2, size_t len)
 {
 	u8 diff;
@@ -228,11 +220,6 @@ void copy_to_fs(addr_t dst, void *src, size_t len);
 void *copy_from_fs(void *dst, addr_t src, size_t len);
 void copy_to_gs(addr_t dst, void *src, size_t len);
 void *copy_from_gs(void *dst, addr_t src, size_t len);
-void *memcpy(void *dst, void *src, size_t len);
-void *memset(void *dst, int c, size_t len);
-
-#define memcpy(d,s,l) __builtin_memcpy(d,s,l)
-#define memset(d,c,l) __builtin_memset(d,c,l)
 
 /* a20.c */
 int enable_a20(void);
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 196eaf3..1768461 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -10,6 +10,7 @@
  */
 
 #include "misc.h"
+#include "../string.h"
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
@@ -97,8 +98,14 @@
  */
 #define STATIC		static
 
-#undef memset
 #undef memcpy
+
+/*
+ * Use a normal definition of memset() from string.c. There are already
+ * included header files which expect a definition of memset() and by
+ * the time we define memset macro, it is too late.
+ */
+#undef memset
 #define memzero(s, n)	memset((s), 0, (n))
 
 
@@ -109,9 +116,6 @@ static void error(char *m);
  */
 struct boot_params *real_mode;		/* Pointer to real-mode data */
 
-void *memset(void *s, int c, size_t n);
-void *memcpy(void *dest, const void *src, size_t n);
-
 memptr free_mem_ptr;
 memptr free_mem_end_ptr;
 
@@ -216,45 +220,6 @@ void __putstr(const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
-void *memset(void *s, int c, size_t n)
-{
-	int i;
-	char *ss = s;
-
-	for (i = 0; i < n; i++)
-		ss[i] = c;
-	return s;
-}
-#ifdef CONFIG_X86_32
-void *memcpy(void *dest, const void *src, size_t n)
-{
-	int d0, d1, d2;
-	asm volatile(
-		"rep ; movsl\n\t"
-		"movl %4,%%ecx\n\t"
-		"rep ; movsb\n\t"
-		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		: "0" (n >> 2), "g" (n & 3), "1" (dest), "2" (src)
-		: "memory");
-
-	return dest;
-}
-#else
-void *memcpy(void *dest, const void *src, size_t n)
-{
-	long d0, d1, d2;
-	asm volatile(
-		"rep ; movsq\n\t"
-		"movq %4,%%rcx\n\t"
-		"rep ; movsb\n\t"
-		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		: "0" (n >> 3), "g" (n & 7), "1" (dest), "2" (src)
-		: "memory");
-
-	return dest;
-}
-#endif
-
 static void error(char *x)
 {
 	error_putstr("\n\n");
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index ffb9c5c..f3c57e3 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,11 +1,45 @@
 #include "misc.h"
+#include "../string.c"
+
+/* misc.h might pull in string_32.h which has a macro for memcpy. undef that */
+#undef memcpy
 
-int memcmp(const void *s1, const void *s2, size_t len)
+#ifdef CONFIG_X86_32
+void *memcpy(void *dest, const void *src, size_t n)
 {
-	u8 diff;
-	asm("repe; cmpsb; setnz %0"
-	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
-	return diff;
+	int d0, d1, d2;
+	asm volatile(
+		"rep ; movsl\n\t"
+		"movl %4,%%ecx\n\t"
+		"rep ; movsb\n\t"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n >> 2), "g" (n & 3), "1" (dest), "2" (src)
+		: "memory");
+
+	return dest;
 }
+#else
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	long d0, d1, d2;
+	asm volatile(
+		"rep ; movsq\n\t"
+		"movq %4,%%rcx\n\t"
+		"rep ; movsb\n\t"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n >> 3), "g" (n & 7), "1" (dest), "2" (src)
+		: "memory");
 
-#include "../string.c"
+	return dest;
+}
+#endif
+
+void *memset(void *s, int c, size_t n)
+{
+	int i;
+	char *ss = s;
+
+	for (i = 0; i < n; i++)
+		ss[i] = c;
+	return s;
+}
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 100a9a1..086c4f4 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -27,6 +27,7 @@
 #include <asm/processor-flags.h>
 #include <asm/required-features.h>
 #include <asm/msr-index.h>
+#include "string.h"
 
 static u32 err_flags[NCAPINTS];
 
diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index c501a5b..223e425 100644
--- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -15,6 +15,7 @@
 
 #include "boot.h"
 #include <linux/edd.h>
+#include "string.h"
 
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index cf6083d..fd6c9f2 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -14,6 +14,7 @@
  */
 
 #include "boot.h"
+#include "string.h"
 
 struct boot_params boot_params __attribute__((aligned(16)));
 
diff --git a/arch/x86/boot/regs.c b/arch/x86/boot/regs.c
index 958019b..c0fb356 100644
--- a/arch/x86/boot/regs.c
+++ b/arch/x86/boot/regs.c
@@ -17,6 +17,7 @@
  */
 
 #include "boot.h"
+#include "string.h"
 
 void initregs(struct biosregs *reg)
 {
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index 574dedf..5339040 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -14,6 +14,20 @@
 
 #include "boot.h"
 
+/*
+ * This file gets included in compressed/string.c which might pull in
+ * string_32.h and which in turn maps memcmp to __builtin_memcmp(). Undo
+ * that first.
+ */
+#undef memcmp
+int memcmp(const void *s1, const void *s2, size_t len)
+{
+	u8 diff;
+	asm("repe; cmpsb; setnz %0"
+	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
+	return diff;
+}
+
 int strcmp(const char *str1, const char *str2)
 {
 	const unsigned char *s1 = (const unsigned char *)str1;
diff --git a/arch/x86/boot/string.h b/arch/x86/boot/string.h
new file mode 100644
index 0000000..725e820
--- /dev/null
+++ b/arch/x86/boot/string.h
@@ -0,0 +1,21 @@
+#ifndef BOOT_STRING_H
+#define BOOT_STRING_H
+
+/* Undef any of these macros coming from string_32.h. */
+#undef memcpy
+#undef memset
+#undef memcmp
+
+void *memcpy(void *dst, const void *src, size_t len);
+void *memset(void *dst, int c, size_t len);
+int memcmp(const void *s1, const void *s2, size_t len);
+
+/*
+ * Access builtin version by default. If one needs to use optimized version,
+ * do "undef memcpy" in .c file and link against right string.c
+ */
+#define memcpy(d,s,l) __builtin_memcpy(d,s,l)
+#define memset(d,c,l) __builtin_memset(d,c,l)
+#define memcmp	__builtin_memcmp
+
+#endif /* BOOT_STRING_H */
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 11e8c6e..ba3e100 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -16,6 +16,7 @@
 #include "boot.h"
 #include "video.h"
 #include "vesa.h"
+#include "string.h"
 
 /* VESA information */
 static struct vesa_general_info vginfo;
