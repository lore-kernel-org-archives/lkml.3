Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3LTL4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:56:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43011 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3LTL4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:56:15 -0500
Date: Fri, 20 Dec 2013 03:54:37 -0800
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        akpm@linux-foundation.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, james.hogan@imgtec.com, mmarek@suse.cz,
        lethal@linux-sh.org, shawn.guo@linaro.org, keescook@chromium.org,
        sfr@canb.auug.org.au
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        linux@arm.linux.org.uk, ralf@linux-mips.org, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        james.hogan@imgtec.com, mmarek@suse.cz, lethal@linux-sh.org,
        shawn.guo@linaro.org, keescook@chromium.org, sfr@canb.auug.org.au
In-Reply-To: <1387481759-14535-3-git-send-email-keescook@chromium.org>
References: <1387481759-14535-3-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/stackprotector] stackprotector:
  Introduce CONFIG_CC_STACKPROTECTOR_STRONG
Git-Commit-ID: 8779657d29c0ebcc0c94ede4df2f497baf1b563f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 20 Dec 2013 03:54:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8779657d29c0ebcc0c94ede4df2f497baf1b563f
Gitweb:     http://git.kernel.org/tip/8779657d29c0ebcc0c94ede4df2f497baf1b563f
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 19 Dec 2013 11:35:59 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Dec 2013 09:38:40 +0100

stackprotector: Introduce CONFIG_CC_STACKPROTECTOR_STRONG

This changes the stack protector config option into a choice of
"None", "Regular", and "Strong":

   CONFIG_CC_STACKPROTECTOR_NONE
   CONFIG_CC_STACKPROTECTOR_REGULAR
   CONFIG_CC_STACKPROTECTOR_STRONG

"Regular" means the old CONFIG_CC_STACKPROTECTOR=y option.

"Strong" is a new mode introduced by this patch. With "Strong" the
kernel is built with -fstack-protector-strong (available in
gcc 4.9 and later). This option increases the coverage of the stack
protector without the heavy performance hit of -fstack-protector-all.

For reference, the stack protector options available in gcc are:

-fstack-protector-all:
  Adds the stack-canary saving prefix and stack-canary checking
  suffix to _all_ function entry and exit. Results in substantial
  use of stack space for saving the canary for deep stack users
  (e.g. historically xfs), and measurable (though shockingly still
  low) performance hit due to all the saving/checking. Really not
  suitable for sane systems, and was entirely removed as an option
  from the kernel many years ago.

-fstack-protector:
  Adds the canary save/check to functions that define an 8
  (--param=ssp-buffer-size=N, N=8 by default) or more byte local
  char array. Traditionally, stack overflows happened with
  string-based manipulations, so this was a way to find those
  functions. Very few total functions actually get the canary; no
  measurable performance or size overhead.

-fstack-protector-strong
  Adds the canary for a wider set of functions, since it's not
  just those with strings that have ultimately been vulnerable to
  stack-busting. With this superset, more functions end up with a
  canary, but it still remains small compared to all functions
  with only a small change in performance. Based on the original
  design document, a function gets the canary when it contains any
  of:

    - local variable's address used as part of the right hand side
      of an assignment or function argument
    - local variable is an array (or union containing an array),
      regardless of array type or length
    - uses register local variables

  https://docs.google.com/a/google.com/document/d/1xXBH6rRZue4f296vGt9YQcuLVQHeE516stHwt8M9xyU

Find below a comparison of "size" and "objdump" output when built with
gcc-4.9 in three configurations:

  - defconfig
	11430641 kernel text size
	36110 function bodies

  - defconfig + CONFIG_CC_STACKPROTECTOR_REGULAR
	11468490 kernel text size (+0.33%)
	1015 of 36110 functions are stack-protected (2.81%)

  - defconfig + CONFIG_CC_STACKPROTECTOR_STRONG via this patch
	11692790 kernel text size (+2.24%)
	7401 of 36110 functions are stack-protected (20.5%)

With -strong, ARM's compressed boot code now triggers stack
protection, so a static guard was added. Since this is only used
during decompression and was never used before, the exposure
here is very small. Once it switches to the full kernel, the
stack guard is back to normal.

Chrome OS has been using -fstack-protector-strong for its kernel
builds for the last 8 months with no problems.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@linux-mips.org
Cc: linux-arch@vger.kernel.org
Link: http://lkml.kernel.org/r/1387481759-14535-3-git-send-email-keescook@chromium.org
[ Improved the changelog and descriptions some more. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Makefile                        |  8 ++++++-
 arch/Kconfig                    | 51 ++++++++++++++++++++++++++++++++++++++---
 arch/arm/boot/compressed/misc.c | 14 +++++++++++
 3 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 84fb5cd..5271b96 100644
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
index 24e026d..80bbb8c 100644
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
@@ -355,8 +362,46 @@ config CC_STACKPROTECTOR
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
+
+	  - local variable's address used as part of the right hand side of an
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
index 31bd43b..d4f891f 100644
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
