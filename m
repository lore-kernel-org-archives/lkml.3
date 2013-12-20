Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab3LTL4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:56:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3LTL4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:56:08 -0500
Date: Fri, 20 Dec 2013 03:54:25 -0800
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-19952a92037e752f9d3bbbad552d596f9a56e146@git.kernel.org>
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
In-Reply-To: <1387481759-14535-2-git-send-email-keescook@chromium.org>
References: <1387481759-14535-2-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/stackprotector] stackprotector:
  Unify the HAVE_CC_STACKPROTECTOR logic between architectures
Git-Commit-ID: 19952a92037e752f9d3bbbad552d596f9a56e146
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 20 Dec 2013 03:54:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19952a92037e752f9d3bbbad552d596f9a56e146
Gitweb:     http://git.kernel.org/tip/19952a92037e752f9d3bbbad552d596f9a56e146
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 19 Dec 2013 11:35:58 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Dec 2013 09:38:40 +0100

stackprotector: Unify the HAVE_CC_STACKPROTECTOR logic between architectures

Instead of duplicating the CC_STACKPROTECTOR Kconfig and
Makefile logic in each architecture, switch to using
HAVE_CC_STACKPROTECTOR and keep everything in one place. This
retains the x86-specific bug verification scripts.

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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@linux-mips.org
Cc: linux-arch@vger.kernel.org
Link: http://lkml.kernel.org/r/1387481759-14535-2-git-send-email-keescook@chromium.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Makefile           | 14 +++++++++++---
 arch/Kconfig       | 22 ++++++++++++++++++++++
 arch/arm/Kconfig   | 13 +------------
 arch/arm/Makefile  |  4 ----
 arch/mips/Kconfig  | 14 +-------------
 arch/mips/Makefile |  4 ----
 arch/sh/Kconfig    | 15 +--------------
 arch/sh/Makefile   |  4 ----
 arch/x86/Kconfig   | 17 +----------------
 arch/x86/Makefile  |  8 +++-----
 10 files changed, 40 insertions(+), 75 deletions(-)

diff --git a/Makefile b/Makefile
index 858a147..84fb5cd 100644
--- a/Makefile
+++ b/Makefile
@@ -595,10 +595,18 @@ ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
-# Force gcc to behave correct even for buggy distributions
-ifndef CONFIG_CC_STACKPROTECTOR
-KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
+# Handle stack protector mode.
+ifdef CONFIG_CC_STACKPROTECTOR
+  stackp-flag := -fstack-protector
+  ifeq ($(call cc-option, $(stackp-flag)),)
+    $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
+	      -fstack-protector not supported by compiler))
+  endif
+else
+  # Force off for distro compilers that enable stack protector by default.
+  stackp-flag := $(call cc-option, -fno-stack-protector)
 endif
+KBUILD_CFLAGS += $(stackp-flag)
 
 # This warning generated too much noise in a regular build.
 # Use make W=1 to enable this warning (see scripts/Makefile.build)
diff --git a/arch/Kconfig b/arch/Kconfig
index f1cf895..24e026d 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -336,6 +336,28 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_CC_STACKPROTECTOR
+	bool
+	help
+	  An arch should select this symbol if:
+	  - its compiler supports the -fstack-protector option
+	  - it has implemented a stack canary (e.g. __stack_chk_guard)
+
+config CC_STACKPROTECTOR
+	bool "Enable -fstack-protector buffer overflow detection"
+	depends on HAVE_CC_STACKPROTECTOR
+	help
+	  This option turns on the -fstack-protector GCC feature. This
+	  feature puts, at the beginning of functions, a canary value on
+	  the stack just before the return address, and validates
+	  the value just before actually returning.  Stack based buffer
+	  overflows (that need to overwrite this return address) now also
+	  overwrite the canary, which gets detected and the attack is then
+	  neutralized via a kernel panic.
+
+	  This feature requires gcc version 4.2 or above, or a distribution
+	  gcc with the feature backported.
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
 
