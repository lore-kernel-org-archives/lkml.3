Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbaCRT1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:27:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880AbaCRT04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/5] x86/boot: Create a separate string.h file to provide standard string functions
Date: Tue, 18 Mar 2014 15:26:37 -0400
Message-Id: <1395170800-11059-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1395170800-11059-1-git-send-email-vgoyal@redhat.com>
References: <1395170800-11059-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a separate arch/x86/boot/string.h file to provide declaration of
some of the common string functions.

By default memcpy, memset and memcmp functions will default to gcc
builtin functions. If code wants to use an optimized version of any
of these functions, they need to #undef the respective macro and link
against a local file providing definition of undefed function.

For example, arch/x86/boot/* code links against copy.S to get memcpy()
and memcmp() definitions. arch/86/boot/compressed/* links against
compressed/string.c.

There are quite a few places in arch/x86/ where these functions are
used. Idea is to try to consilidate  their declaration and possibly
definitions so that it can be reused.

I am planning to reuse boot/string.h in arch/x86/purgatory/ and use
gcc builtin functions for memcpy, memset and memcmp.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/boot/boot.h       |  5 -----
 arch/x86/boot/cpucheck.c   |  1 +
 arch/x86/boot/edd.c        |  1 +
 arch/x86/boot/main.c       |  1 +
 arch/x86/boot/regs.c       |  1 +
 arch/x86/boot/string.h     | 19 +++++++++++++++++++
 arch/x86/boot/video-vesa.c |  1 +
 7 files changed, 24 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/boot/string.h

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 50f8c5e..bed9665 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -228,11 +228,6 @@ void copy_to_fs(addr_t dst, void *src, size_t len);
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
diff --git a/arch/x86/boot/string.h b/arch/x86/boot/string.h
new file mode 100644
index 0000000..10939d8
--- /dev/null
+++ b/arch/x86/boot/string.h
@@ -0,0 +1,19 @@
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
+
+/*
+ * Access builtin version by default. If one needs to use optimized version,
+ * do "undef memcpy" in .c file and link against right string.c
+ */
+#define memcpy(d,s,l) __builtin_memcpy(d,s,l)
+#define memset(d,c,l) __builtin_memset(d,c,l)
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
-- 
1.8.5.3

