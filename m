Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3KYWPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:15:16 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48838 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab3KYWPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:15:11 -0500
Date: Mon, 25 Nov 2013 14:14:00 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olofj@chromium.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] use -fstack-protector-strong
Message-ID: <20131125221400.GA11041@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build the kernel with -fstack-protector-strong when it is available
(gcc 4.9 and later). This increases the coverage of the stack protector
without the heavy performance hit of -fstack-protector-all.

On a Chrome OS kernel build, this grows the uncompressed kernel image
by less than 0.16% on x86:

  -rwxr-xr-x 1 keescook portage 118219343 Apr 17 12:26 vmlinux.old
  -rwxr-xr-x 1 keescook portage 118407919 Apr 19 15:00 vmlinux

ARM's compressed boot code now triggers stack protection, so a static
guard was added. Since this is only used during decompression and was
never used before, the exposure here is very small. Once it switches to
the full kernel, the stack guard is back to normal.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/Makefile               |    3 ++-
 arch/arm/boot/compressed/misc.c |   14 ++++++++++++++
 arch/x86/Makefile               |    2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index c99b1086d83d..c6d3ea1c063e 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -41,7 +41,8 @@ KBUILD_CFLAGS	+=-fno-omit-frame-pointer -mapcs -mno-sched-prolog
 endif
 
 ifeq ($(CONFIG_CC_STACKPROTECTOR),y)
-KBUILD_CFLAGS	+=-fstack-protector
+KBUILD_CFLAGS	+= $(call cc-option,-fstack-protector-strong,-fstack-protector)
+
 endif
 
 ifeq ($(CONFIG_CPU_BIG_ENDIAN),y)
diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 31bd43b82095..d4f891f56996 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -127,6 +127,18 @@ asmlinkage void __div0(void)
 	error("Attempting division by 0!");
 }
 
+unsigned long __stack_chk_guard;
+
+void __stack_chk_guard_setup(void)
+{
+	__stack_chk_guard = 0x000a0dff;
+}
+
+void __stack_chk_fail(void)
+{
+	error("stack-protector: Kernel stack is corrupted\n");
+}
+
 extern int do_decompress(u8 *input, int len, u8 *output, void (*error)(char *x));
 
 
@@ -137,6 +149,8 @@ decompress_kernel(unsigned long output_start, unsigned long free_mem_ptr_p,
 {
 	int ret;
 
+	__stack_chk_guard_setup();
+
 	output_data		= (unsigned char *)output_start;
 	free_mem_ptr		= free_mem_ptr_p;
 	free_mem_end_ptr	= free_mem_ptr_end_p;
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 41250fb33985..4ebb054cc323 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -86,7 +86,7 @@ endif
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
         ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
-                stackp-y := -fstack-protector
+                stackp-y := $(call cc-option,-fstack-protector-strong,-fstack-protector)
                 KBUILD_CFLAGS += $(stackp-y)
         else
                 $(warning stack protector enabled but no compiler support)
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
