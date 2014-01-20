Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaATLrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:47:33 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51271 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaATLra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:47:30 -0500
Date: Mon, 20 Jan 2014 12:47:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Stackprotector updates for v3.14
Message-ID: <20140120114724.GA10173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-stackprotector-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-stackprotector-for-linus

   # HEAD: 8779657d29c0ebcc0c94ede4df2f497baf1b563f stackprotector: Introduce CONFIG_CC_STACKPROTECTOR_STRONG

This tree adds a CONFIG_CC_STACKPROTECTOR_STRONG=y, a new, stronger 
stack canary checking method supported by the newest GCC versions (4.9 
and later).

Here's the 'intensity comparison' between the various protection 
modes:

      - defconfig
        11430641 kernel text size
        36110 function bodies
    
      - defconfig + CONFIG_CC_STACKPROTECTOR_REGULAR
        11468490 kernel text size (+0.33%)
        1015 of 36110 functions are stack-protected (2.81%)
    
      - defconfig + CONFIG_CC_STACKPROTECTOR_STRONG via this patch
        11692790 kernel text size (+2.24%)
        7401 of 36110 functions are stack-protected (20.5%)

the strong model comes with non-trivial costs, which is why we 
preserved the 'regular' and 'none' models as well.

 Thanks,

	Ingo

------------------>
Kees Cook (2):
      stackprotector: Unify the HAVE_CC_STACKPROTECTOR logic between architectures
      stackprotector: Introduce CONFIG_CC_STACKPROTECTOR_STRONG


 Makefile                        | 20 ++++++++++--
 arch/Kconfig                    | 67 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/Kconfig                | 13 +-------
 arch/arm/Makefile               |  4 ---
 arch/arm/boot/compressed/misc.c | 14 +++++++++
 arch/mips/Kconfig               | 14 +--------
 arch/mips/Makefile              |  4 ---
 arch/sh/Kconfig                 | 15 +--------
 arch/sh/Makefile                |  4 ---
 arch/x86/Kconfig                | 17 +----------
 arch/x86/Makefile               |  8 ++---
 11 files changed, 105 insertions(+), 75 deletions(-)

diff --git a/Makefile b/Makefile
index 858a147..5271b96 100644
--- a/Makefile
+++ b/Makefile
@@ -595,10 +595,24 @@ ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
-# Force gcc to behave correct even for buggy distributions
-ifndef CONFIG_CC_STACKPROTECTOR
-KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
+# Handle stack protector mode.
+ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
+  stackp-flag := -fstack-protector
+  ifeq ($(call cc-option, $(stackp-flag)),)
+    $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
+	      -fstack-protector not supported by compiler))
+  endif
+else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
+  stackp-flag := -fstack-protector-strong
+  ifeq ($(call cc-option, $(stackp-flag)),)
+    $(warning Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: \
+	      -fstack-protector-strong not supported by compiler)
+  endif
+else
+  # Force off for distro compilers that enable stack protector by default.
+  stackp-flag := $(call cc-option, -fno-stack-protector)
 endif
+KBUILD_CFLAGS += $(stackp-flag)
 
 # This warning generated too much noise in a regular build.
 # Use make W=1 to enable this warning (see scripts/Makefile.build)
diff --git a/arch/Kconfig b/arch/Kconfig
index f1cf895..80bbb8c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -336,6 +336,73 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_CC_STACKPROTECTOR
+	bool
+	help
+	  An arch should select this symbol if:
+	  - its compiler supports the -fstack-protector option
+	  - it has implemented a stack canary (e.g. __stack_chk_guard)
+
+config CC_STACKPROTECTOR
+	def_bool n
+	help
+	  Set when a stack-protector mode is enabled, so that the build
+	  can enable kernel-side support for the GCC feature.
+
+choice
+	prompt "Stack Protector buffer overflow detection"
+	depends on HAVE_CC_STACKPROTECTOR
+	default CC_STACKPROTECTOR_NONE
+	help
+	  This option turns on the "stack-protector" GCC feature. This
+	  feature puts, at the beginning of functions, a canary value on
+	  the stack just before the return address, and validates
+	  the value just before actually returning.  Stack based buffer
+	  overflows (that need to overwrite this return address) now also
+	  overwrite the canary, which gets detected and the attack is then
+	  neutralized via a kernel panic.
+
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
+	  This feature requires gcc version 4.2 or above, or a distribution
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
+
 config HAVE_CONTEXT_TRACKING
 	bool
 	help
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c1f1a7e..9c909fc 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -30,6 +30,7 @@ config ARM
 	select HAVE_BPF_JIT
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_CC_STACKPROTECTOR
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
@@ -1856,18 +1857,6 @@ config SECCOMP
 	  and the task is only allowed to execute a few safe syscalls
 	  defined by each seccomp mode.
 
-config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	help
-	  This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of functions, a canary value on
-	  the stack just before the return address, and validates
-	  the value just before actually returning.  Stack based buffer
-	  overflows (that need to overwrite this return address) now also
-	  overwrite the canary, which gets detected and the attack is then
-	  neutralized via a kernel panic.
-	  This feature requires gcc version 4.2 or above.
-
 config SWIOTLB
 	def_bool y
 
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index c99b108..55b4255 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -40,10 +40,6 @@ ifeq ($(CONFIG_FRAME_POINTER),y)
 KBUILD_CFLAGS	+=-fno-omit-frame-pointer -mapcs -mno-sched-prolog
 endif
 
-ifeq ($(CONFIG_CC_STACKPROTECTOR),y)
-KBUILD_CFLAGS	+=-fstack-protector
-endif
-
 ifeq ($(CONFIG_CPU_BIG_ENDIAN),y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 AS		+= -EB
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
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 650de39..c93d92b 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -47,6 +47,7 @@ config MIPS
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select CLONE_BACKWARDS
 	select HAVE_DEBUG_STACKOVERFLOW
+	select HAVE_CC_STACKPROTECTOR
 
 menu "Machine selection"
 
@@ -2322,19 +2323,6 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
-config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	help
-	  This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of functions, a canary value on
-	  the stack just before the return address, and validates
-	  the value just before actually returning.  Stack based buffer
-	  overflows (that need to overwrite this return address) now also
-	  overwrite the canary, which gets detected and the attack is then
-	  neutralized via a kernel panic.
-
-	  This feature requires gcc version 4.2 or above.
-
 config USE_OF
 	bool
 	select OF
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index de300b9..efe50787 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -232,10 +232,6 @@ bootvars-y	= VMLINUX_LOAD_ADDRESS=$(load-y) \
 
 LDFLAGS			+= -m $(ld-emul)
 
-ifdef CONFIG_CC_STACKPROTECTOR
-  KBUILD_CFLAGS += -fstack-protector
-endif
-
 ifdef CONFIG_MIPS
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	egrep -vw '__GNUC_(|MINOR_|PATCHLEVEL_)_' | \
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 9b0979f..ce29831 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -66,6 +66,7 @@ config SUPERH32
 	select PERF_EVENTS
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select SPARSE_IRQ
+	select HAVE_CC_STACKPROTECTOR
 
 config SUPERH64
 	def_bool ARCH = "sh64"
@@ -695,20 +696,6 @@ config SECCOMP
 
 	  If unsure, say N.
 
-config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on SUPERH32
-	help
-	  This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of functions, a canary value on
-	  the stack just before the return address, and validates
-	  the value just before actually returning.  Stack based buffer
-	  overflows (that need to overwrite this return address) now also
-	  overwrite the canary, which gets detected and the attack is then
-	  neutralized via a kernel panic.
-
-	  This feature requires gcc version 4.2 or above.
-
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on SYS_SUPPORTS_SMP
diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index aed701c..d4d16e4 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -199,10 +199,6 @@ ifeq ($(CONFIG_DWARF_UNWINDER),y)
   KBUILD_CFLAGS += -fasynchronous-unwind-tables
 endif
 
-ifeq ($(CONFIG_CC_STACKPROTECTOR),y)
-  KBUILD_CFLAGS += -fstack-protector
-endif
-
 libs-$(CONFIG_SUPERH32)		:= arch/sh/lib/	$(libs-y)
 libs-$(CONFIG_SUPERH64)		:= arch/sh/lib64/ $(libs-y)
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0952ecd..838e7c3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -125,6 +125,7 @@ config X86
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
+	select HAVE_CC_STACKPROTECTOR
 
 config INSTRUCTION_DECODER
 	def_bool y
@@ -1617,22 +1618,6 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
-config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection"
-	---help---
-	  This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of functions, a canary value on
-	  the stack just before the return address, and validates
-	  the value just before actually returning.  Stack based buffer
-	  overflows (that need to overwrite this return address) now also
-	  overwrite the canary, which gets detected and the attack is then
-	  neutralized via a kernel panic.
-
-	  This feature requires gcc version 4.2 or above, or a distribution
-	  gcc with the feature backported. Older versions are automatically
-	  detected and for those versions, this configuration option is
-	  ignored. (and a warning is printed during bootup)
-
 source kernel/Kconfig.hz
 
 config KEXEC
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 57d0215..13b22e0 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -89,13 +89,11 @@ else
         KBUILD_CFLAGS += -maccumulate-outgoing-args
 endif
 
+# Make sure compiler does not have buggy stack-protector support.
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
-                stackp-y := -fstack-protector
-                KBUILD_CFLAGS += $(stackp-y)
-        else
-                $(warning stack protector enabled but no compiler support)
+        ifneq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
+                $(warning stack-protector enabled but compiler support broken)
         endif
 endif
 
