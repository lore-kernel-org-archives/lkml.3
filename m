Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3LSTiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:38:05 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57507 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab3LSThu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:37:50 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Shawn Guo <shawn.guo@linaro.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        keescook@chromium.org
Subject: [PATCH v5 2/2] provide -fstack-protector-strong build option
Date: Thu, 19 Dec 2013 11:35:59 -0800
Message-Id: <1387481759-14535-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387481759-14535-1-git-send-email-keescook@chromium.org>
References: <1387481759-14535-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the stack protector config option into a choice of "None",
"Regular", and "Strong". For "Strong", the kernel is built with
-fstack-protector-strong (gcc 4.9 and later). This options increases
the coverage of the stack protector without the heavy performance hit
of -fstack-protector-all.

For reference, the stack protector options available in gcc are:

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
Adds the canary for a wider set of functions, since it's not just those
with strings that have ultimately been vulnerable to stack-busting. With
this superset, more functions end up with a canary, but it still
remains small compared to all functions with no measurable change in
performance. Based on the original design document, a function gets the
canary when it contains any of:
- local variable's address used as part of the RHS of an assignment or
  function argument
- local variable is an array (or union containing an array), regardless
  of array type or length
- uses register local variables
https://docs.google.com/a/google.com/document/d/1xXBH6rRZue4f296vGt9YQcuLVQHeE516stHwt8M9xyU

Comparison of "size" and "objdump" output when built with gcc-4.9 in
three configurations:
- defconfig
	11430641 text size
	36110 function bodies
- defconfig + CONFIG_CC_STACKPROTECTOR
	11468490 text size (+0.33%)
	1015 of 36110 functions stack-protected (2.81%)
- defconfig + CONFIG_CC_STACKPROTECTOR_STRONG via this patch
	11692790 text size (+2.24%)
	7401 of 36110 functions stack-protected (20.5%)

With -strong, ARM's compressed boot code now triggers stack protection,
so a static guard was added. Since this is only used during decompression
and was never used before, the exposure here is very small. Once it
switches to the full kernel, the stack guard is back to normal.

Chrome OS has been using -fstack-protector-strong for its kernel builds
for the last 8 months with no problems.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v5:
 - add function counts to help text
 - switch from Makefile error to warning to not kill silentoldconfig
v4:
 - add objdump analysis to comparison
v3:
 - split off type of stack protection as a distinct config
v2:
 - added description of all stack protector options
 - added size comparisons for Ubuntu and defconfig
---
 Makefile                        |    8 ++++++-
 arch/Kconfig                    |   50 ++++++++++++++++++++++++++++++++++++---
 arch/arm/boot/compressed/misc.c |   14 +++++++++++
 3 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 84fb5cd092d2..5271b9623aa3 100644
--- a/Makefile
+++ b/Makefile
@@ -596,12 +596,18 @@ KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
 # Handle stack protector mode.
-ifdef CONFIG_CC_STACKPROTECTOR
+ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   ifeq ($(call cc-option, $(stackp-flag)),)
     $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
 	      -fstack-protector not supported by compiler))
   endif
+else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
+  stackp-flag := -fstack-protector-strong
+  ifeq ($(call cc-option, $(stackp-flag)),)
+    $(warning Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: \
+	      -fstack-protector-strong not supported by compiler)
+  endif
 else
   # Force off for distro compilers that enable stack protector by default.
   stackp-flag := $(call cc-option, -fno-stack-protector)
diff --git a/arch/Kconfig b/arch/Kconfig
index 24e026d83072..d6411a3af71e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -344,10 +344,17 @@ config HAVE_CC_STACKPROTECTOR
 	  - it has implemented a stack canary (e.g. __stack_chk_guard)
 
 config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection"
+	def_bool n
+	help
+	  Set when a stack-protector mode is enabled, so that the build
+	  can enable kernel-side support for the GCC feature.
+
+choice
+	prompt "Stack Protector buffer overflow detection"
 	depends on HAVE_CC_STACKPROTECTOR
+	default CC_STACKPROTECTOR_NONE
 	help
-	  This option turns on the -fstack-protector GCC feature. This
+	  This option turns on the "stack-protector" GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
 	  the stack just before the return address, and validates
 	  the value just before actually returning.  Stack based buffer
@@ -355,8 +362,45 @@ config CC_STACKPROTECTOR
 	  overwrite the canary, which gets detected and the attack is then
 	  neutralized via a kernel panic.
 
+config CC_STACKPROTECTOR_NONE
+	bool "None"
+	help
+	  Disable "stack-protector" GCC feature.
+
+config CC_STACKPROTECTOR_REGULAR
+	bool "Regular"
+	select CC_STACKPROTECTOR
+	help
+	  Functions will have the stack-protector canary logic added if they
+	  have an 8-byte or larger character array on the stack.
+
 	  This feature requires gcc version 4.2 or above, or a distribution
-	  gcc with the feature backported.
+	  gcc with the feature backported ("-fstack-protector").
+
+	  On an x86 "defconfig" build, this feature adds canary checks to
+	  about 3% of all kernel functions, which increases kernel code size
+	  by about 0.3%.
+
+config CC_STACKPROTECTOR_STRONG
+	bool "Strong"
+	select CC_STACKPROTECTOR
+	help
+	  Functions will have the stack-protector canary logic added in any
+	  of the following conditions:
+	  - local variable's address used as part of the RHS of an
+	    assignment or function argument
+	  - local variable is an array (or union containing an array),
+	    regardless of array type or length
+	  - uses register local variables
+
+	  This feature requires gcc version 4.9 or above, or a distribution
+	  gcc with the feature backported ("-fstack-protector-strong").
+
+	  On an x86 "defconfig" build, this feature adds canary checks to
+	  about 20% of all kernel functions, which increases the kernel code
+	  size by about 2%.
+
+endchoice
 
 config HAVE_CONTEXT_TRACKING
 	bool
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
-- 
1.7.9.5

