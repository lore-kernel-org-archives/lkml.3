Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab3KZUi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:38:28 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38204 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757755Ab3KZUiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:38:25 -0500
Date: Tue, 26 Nov 2013 12:37:28 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olofj@chromium.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] use -fstack-protector-strong
Message-ID: <20131126203727.GA352@www.outflux.net>
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

The stack protector options available in gcc are:

-fstack-protector-all:
Adds the stack-canary saving prefix and stack-canary checking suffix to
_all_ function entry and exit. Results in substantial use of stack space
for saving the canary for deep stack users (e.g. historically xfs), and
measurable (though shockingly still low) performance hit due to all the
saving/checking. Really not suitable for sane systems, and was entirely
removed as an option from the kernel many years ago.

-fstack-protector:
Adds the canary save/check to functions that define an 8
(--param=ssp-buffer-size=N, N=8 by default) or more byte local char
array. Traditionally, stack overflows happened with string-based
manipulations, so this was a way to find those functions. Very few
total functions actually get the canary; no measurable performance or
size overhead.

-fstack-protector-strong
Adds the canary for a wider set of functions, since history has shown that
it's not just those with strings that have ultimately been vulnerable to
stack-busting attacks. With this superset, more functions end up with
a canary, but it still remains small compared to all functions with no
measurable change in performance. Based on the original design document,
a function gets the canary when it contains any of:
- local variable's address used as part of the RHS of an assignment or
  function argument
- local variable is an array (or union containing an array), regardless
  of array type or length
- uses register local variables
https://docs.google.com/a/google.com/document/d/1xXBH6rRZue4f296vGt9YQcuLVQHeE516stHwt8M9xyU

Chrome OS x86_64 build is less than 0.16% larger:

-rwxr-xr-x 1 kees kees 118219343 Apr 17 12:26 vmlinux.orig
-rwxr-xr-x 1 kees kees 118407919 Apr 19 15:00 vmlinux

Ubuntu x86_64 build, using 14.04's config is less than 0.14% larger:

-rwxrwxr-x 1 kees kees 174384144 Nov 26 11:00 vmlinux.ubuntu-gcc-4.9
-rwxrwxr-x 1 kees kees 174627120 Nov 26 11:09 vmlinux.ubuntu-gcc-4.9+strong

On a defconfig x86_64 build (with CONFIG_CC_STACKPROTECTOR enabled), the
delta in size is just under 9% larger:

-rwxrwxr-x 1 kees kees  22134340 Nov 26 10:28 vmlinux.gcc-4.8
-rwxrwxr-x 1 kees kees  22123870 Nov 26 10:40 vmlinux.gcc-4.9
-rwxrwxr-x 1 kees kees  24225118 Nov 26 10:42 vmlinux.gcc-4.9+strong

ARM's compressed boot code now triggers stack protection, so a static
guard was added. Since this is only used during decompression and was
never protected before, the exposure here is very small. Once it switches
to the full kernel, the stack guard is back to normal.

Chrome OS has been using -fstack-protector-strong for its kernel builds
for the last 8 months with no problems.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - added description of all stack protector options
 - added size comparisons for Ubuntu and defconfig
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
