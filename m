Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3GAUIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:08:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:27223 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab3GAUIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:08:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="262765201"
Subject: [PATCH 1/7] consolidate per-arch stack overflow debugging options
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 01 Jul 2013 13:04:42 -0700
References: <20130701200440.712D8B4E@viggo.jf.intel.com>
In-Reply-To: <20130701200440.712D8B4E@viggo.jf.intel.com>
Message-Id: <20130701200442.6D80125A@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave@linux.vnet.ibm.com>

Original posting:

	http://lkml.kernel.org/r/20121214184202.F54094D9@kernel.stglabs.ibm.com

Several architectures have similar stack debugging config options.
They all pretty much do the same thing, some with slightly
differing help text.

This patch changes the architectures to instead enable a Kconfig
boolean, and then use that boolean in the generic Kconfig.debug
to present the actual menu option.  This removes a bunch of
duplication and adds consistency across arches.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com> [for tile]
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/arc/Kconfig            |    1 +
 linux.git-davehans/arch/arc/Kconfig.debug      |    7 -------
 linux.git-davehans/arch/blackfin/Kconfig       |    1 +
 linux.git-davehans/arch/blackfin/Kconfig.debug |    7 -------
 linux.git-davehans/arch/frv/Kconfig            |    1 +
 linux.git-davehans/arch/frv/Kconfig.debug      |    4 ----
 linux.git-davehans/arch/m32r/Kconfig           |    1 +
 linux.git-davehans/arch/m32r/Kconfig.debug     |    7 -------
 linux.git-davehans/arch/metag/Kconfig          |    1 +
 linux.git-davehans/arch/metag/Kconfig.debug    |    7 -------
 linux.git-davehans/arch/mips/Kconfig           |    1 +
 linux.git-davehans/arch/mips/Kconfig.debug     |    9 ---------
 linux.git-davehans/arch/mn10300/Kconfig        |    1 +
 linux.git-davehans/arch/mn10300/Kconfig.debug  |    4 ----
 linux.git-davehans/arch/openrisc/Kconfig       |   11 +----------
 linux.git-davehans/arch/parisc/Kconfig         |    1 +
 linux.git-davehans/arch/parisc/Kconfig.debug   |   11 -----------
 linux.git-davehans/arch/powerpc/Kconfig        |    1 +
 linux.git-davehans/arch/powerpc/Kconfig.debug  |    7 -------
 linux.git-davehans/arch/tile/Kconfig           |    1 +
 linux.git-davehans/arch/tile/Kconfig.debug     |    7 -------
 linux.git-davehans/arch/x86/Kconfig            |    1 +
 linux.git-davehans/arch/x86/Kconfig.debug      |   10 ----------
 linux.git-davehans/lib/Kconfig.debug           |   21 +++++++++++++++++++++
 24 files changed, 33 insertions(+), 90 deletions(-)

diff -puN arch/arc/Kconfig~consolidat-stack-debugging-configs arch/arc/Kconfig
--- linux.git/arch/arc/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.213474005 -0700
+++ linux.git-davehans/arch/arc/Kconfig	2013-07-01 12:53:20.255475867 -0700
@@ -34,6 +34,7 @@ config ARC
 	select OF
 	select OF_EARLY_FLATTREE
 	select PERF_USE_VMALLOC
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff -puN arch/arc/Kconfig.debug~consolidat-stack-debugging-configs arch/arc/Kconfig.debug
--- linux.git/arch/arc/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.214474050 -0700
+++ linux.git-davehans/arch/arc/Kconfig.debug	2013-07-01 12:53:20.256475912 -0700
@@ -15,13 +15,6 @@ config EARLY_PRINTK
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config 16KSTACKS
 	bool "Use 16Kb for kernel stacks instead of 8Kb"
 	help
diff -puN arch/blackfin/Kconfig~consolidat-stack-debugging-configs arch/blackfin/Kconfig
--- linux.git/arch/blackfin/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.216474138 -0700
+++ linux.git-davehans/arch/blackfin/Kconfig	2013-07-01 12:53:20.256475912 -0700
@@ -41,6 +41,7 @@ config BLACKFIN
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config GENERIC_CSUM
 	def_bool y
diff -puN arch/blackfin/Kconfig.debug~consolidat-stack-debugging-configs arch/blackfin/Kconfig.debug
--- linux.git/arch/blackfin/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.218474227 -0700
+++ linux.git-davehans/arch/blackfin/Kconfig.debug	2013-07-01 12:53:20.257475956 -0700
@@ -2,13 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config DEBUG_VERBOSE
 	bool "Verbose fault messages"
 	default y
diff -puN arch/frv/Kconfig~consolidat-stack-debugging-configs arch/frv/Kconfig
--- linux.git/arch/frv/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.220474316 -0700
+++ linux.git-davehans/arch/frv/Kconfig	2013-07-01 12:53:20.257475956 -0700
@@ -14,6 +14,7 @@ config FRV
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config ZONE_DMA
 	bool
diff -puN arch/frv/Kconfig.debug~consolidat-stack-debugging-configs arch/frv/Kconfig.debug
--- linux.git/arch/frv/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.221474360 -0700
+++ linux.git-davehans/arch/frv/Kconfig.debug	2013-07-01 12:53:20.258476000 -0700
@@ -2,10 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-
 config GDBSTUB
 	bool "Remote GDB kernel debugging"
 	depends on DEBUG_KERNEL
diff -puN arch/m32r/Kconfig~consolidat-stack-debugging-configs arch/m32r/Kconfig
--- linux.git/arch/m32r/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.223474448 -0700
+++ linux.git-davehans/arch/m32r/Kconfig	2013-07-01 12:53:20.258476000 -0700
@@ -16,6 +16,7 @@ config M32R
 	select GENERIC_ATOMIC64
 	select ARCH_USES_GETTIMEOFFSET
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config SBUS
 	bool
diff -puN arch/m32r/Kconfig.debug~consolidat-stack-debugging-configs arch/m32r/Kconfig.debug
--- linux.git/arch/m32r/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.225474537 -0700
+++ linux.git-davehans/arch/m32r/Kconfig.debug	2013-07-01 12:53:20.258476000 -0700
@@ -2,13 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL && BROKEN
diff -puN arch/metag/Kconfig~consolidat-stack-debugging-configs arch/metag/Kconfig
--- linux.git/arch/metag/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.226474582 -0700
+++ linux.git-davehans/arch/metag/Kconfig	2013-07-01 12:53:20.259476044 -0700
@@ -30,6 +30,7 @@ config METAG
 	select OF
 	select OF_EARLY_FLATTREE
 	select SPARSE_IRQ
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config STACKTRACE_SUPPORT
 	def_bool y
diff -puN arch/metag/Kconfig.debug~consolidat-stack-debugging-configs arch/metag/Kconfig.debug
--- linux.git/arch/metag/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.228474670 -0700
+++ linux.git-davehans/arch/metag/Kconfig.debug	2013-07-01 12:53:20.259476044 -0700
@@ -6,13 +6,6 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
diff -puN arch/mips/Kconfig~consolidat-stack-debugging-configs arch/mips/Kconfig
--- linux.git/arch/mips/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.230474759 -0700
+++ linux.git-davehans/arch/mips/Kconfig	2013-07-01 12:53:20.260476089 -0700
@@ -42,6 +42,7 @@ config MIPS
 	select MODULES_USE_ELF_REL if MODULES
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select CLONE_BACKWARDS
+	select HAVE_DEBUG_STACKOVERFLOW
 
 menu "Machine selection"
 
diff -puN arch/mips/Kconfig.debug~consolidat-stack-debugging-configs arch/mips/Kconfig.debug
--- linux.git/arch/mips/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.231474803 -0700
+++ linux.git-davehans/arch/mips/Kconfig.debug	2013-07-01 12:53:20.260476089 -0700
@@ -67,15 +67,6 @@ config CMDLINE_OVERRIDE
 
 	  Normally, you will choose 'N' here.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit(2GB on MIPS). The debugging option
-	  provides another way to check stack overflow happened on kernel mode
-	  stack usually caused by nested interruption.
-
 config SMTC_IDLE_HOOK_DEBUG
 	bool "Enable additional debug checks before going into CPU idle loop"
 	depends on DEBUG_KERNEL && MIPS_MT_SMTC
diff -puN arch/mn10300/Kconfig~consolidat-stack-debugging-configs arch/mn10300/Kconfig
--- linux.git/arch/mn10300/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.233474892 -0700
+++ linux.git-davehans/arch/mn10300/Kconfig	2013-07-01 12:53:20.261476133 -0700
@@ -13,6 +13,7 @@ config MN10300
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config AM33_2
 	def_bool n
diff -puN arch/mn10300/Kconfig.debug~consolidat-stack-debugging-configs arch/mn10300/Kconfig.debug
--- linux.git/arch/mn10300/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.235474981 -0700
+++ linux.git-davehans/arch/mn10300/Kconfig.debug	2013-07-01 12:53:20.261476133 -0700
@@ -2,10 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-
 config DEBUG_DECOMPRESS_KERNEL
 	bool "Using serial port during decompressing kernel"
 	depends on DEBUG_KERNEL
diff -puN arch/openrisc/Kconfig~consolidat-stack-debugging-configs arch/openrisc/Kconfig
--- linux.git/arch/openrisc/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.237475069 -0700
+++ linux.git-davehans/arch/openrisc/Kconfig	2013-07-01 12:53:20.262476177 -0700
@@ -22,6 +22,7 @@ config OPENRISC
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config MMU
 	def_bool y
@@ -128,16 +129,6 @@ config CMDLINE
 
 menu "Debugging options"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for kernel stack overflow"
-	default y
-	help
-	  Make extra checks for space available on stack in some
-          critical functions. This will cause kernel to run a bit slower,
-	  but will catch most of kernel stack overruns and exit gracefully.
-
-	  Say Y if you are unsure.
-
 config JUMP_UPON_UNHANDLED_EXCEPTION
 	bool "Try to die gracefully"
 	default y
diff -puN arch/parisc/Kconfig~consolidat-stack-debugging-configs arch/parisc/Kconfig
--- linux.git/arch/parisc/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.238475113 -0700
+++ linux.git-davehans/arch/parisc/Kconfig	2013-07-01 12:53:20.262476177 -0700
@@ -27,6 +27,7 @@ config PARISC
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
 	select TTY # Needed for pdc_cons.c
+	select HAVE_DEBUG_STACKOVERFLOW
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff -puN arch/parisc/Kconfig.debug~consolidat-stack-debugging-configs arch/parisc/Kconfig.debug
--- linux.git/arch/parisc/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.240475202 -0700
+++ linux.git-davehans/arch/parisc/Kconfig.debug	2013-07-01 12:53:20.262476177 -0700
@@ -13,14 +13,3 @@ config DEBUG_RODATA
          If in doubt, say "N".
 
 endmenu
-
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	default y
-	depends on DEBUG_KERNEL
-	---help---
-	  Say Y here if you want to check the overflows of kernel, IRQ
-	  and exception stacks. This option will cause messages of the
-	  stacks in detail when free stack space drops below a certain
-	  limit.
-	  If in doubt, say "N".
diff -puN arch/powerpc/Kconfig~consolidat-stack-debugging-configs arch/powerpc/Kconfig
--- linux.git/arch/powerpc/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.242475291 -0700
+++ linux.git-davehans/arch/powerpc/Kconfig	2013-07-01 12:53:20.263476221 -0700
@@ -138,6 +138,7 @@ config PPC
 	select ARCH_USE_BUILTIN_BSWAP
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION if PPC32
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config EARLY_PRINTK
 	bool
diff -puN arch/powerpc/Kconfig.debug~consolidat-stack-debugging-configs arch/powerpc/Kconfig.debug
--- linux.git/arch/powerpc/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.243475335 -0700
+++ linux.git-davehans/arch/powerpc/Kconfig.debug	2013-07-01 12:53:20.263476221 -0700
@@ -28,13 +28,6 @@ config PRINT_STACK_DEPTH
 	  too small and stack traces cause important information to
 	  scroll off the screen.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS && TRACEPOINTS
diff -puN arch/tile/Kconfig~consolidat-stack-debugging-configs arch/tile/Kconfig
--- linux.git/arch/tile/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.245475424 -0700
+++ linux.git-davehans/arch/tile/Kconfig	2013-07-01 12:53:20.264476266 -0700
@@ -25,6 +25,7 @@ config TILE
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_SYSCALL_TRACEPOINTS
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select HAVE_DEBUG_STACKOVERFLOW
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff -puN arch/tile/Kconfig.debug~consolidat-stack-debugging-configs arch/tile/Kconfig.debug
--- linux.git/arch/tile/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.247475512 -0700
+++ linux.git-davehans/arch/tile/Kconfig.debug	2013-07-01 12:53:20.264476266 -0700
@@ -14,13 +14,6 @@ config EARLY_PRINTK
 	  with klogd/syslogd. You should normally N here,
 	  unless you want to debug such a crash.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config DEBUG_EXTRA_FLAGS
 	string "Additional compiler arguments when building with '-g'"
 	depends on DEBUG_INFO
diff -puN arch/x86/Kconfig~consolidat-stack-debugging-configs arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~consolidat-stack-debugging-configs	2013-07-01 12:53:20.248475557 -0700
+++ linux.git-davehans/arch/x86/Kconfig	2013-07-01 12:53:20.265476311 -0700
@@ -121,6 +121,7 @@ config X86
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
 	select RTC_LIB
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config INSTRUCTION_DECODER
 	def_bool y
diff -puN arch/x86/Kconfig.debug~consolidat-stack-debugging-configs arch/x86/Kconfig.debug
--- linux.git/arch/x86/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.250475646 -0700
+++ linux.git-davehans/arch/x86/Kconfig.debug	2013-07-01 12:53:20.266476355 -0700
@@ -59,16 +59,6 @@ config EARLY_PRINTK_DBGP
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash. You need usb debug device.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	---help---
-	  Say Y here if you want to check the overflows of kernel, IRQ
-	  and exception stacks. This option will cause messages of the
-	  stacks in detail when free stack space drops below a certain
-	  limit.
-	  If in doubt, say "N".
-
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff -puN lib/Kconfig.debug~consolidat-stack-debugging-configs lib/Kconfig.debug
--- linux.git/lib/Kconfig.debug~consolidat-stack-debugging-configs	2013-07-01 12:53:20.252475734 -0700
+++ linux.git-davehans/lib/Kconfig.debug	2013-07-01 12:53:20.266476355 -0700
@@ -1475,6 +1475,27 @@ config ASYNC_RAID6_TEST
 
 	  If unsure, say N.
 
+config HAVE_DEBUG_STACKOVERFLOW
+	bool
+
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on DEBUG_KERNEL && HAVE_DEBUG_STACKOVERFLOW
+	---help---
+	  Say Y here if you want to check for overflows of kernel, IRQ
+	  and exception stacks (if your archicture uses them). This
+	  option will show detailed messages if free stack space drops
+	  below a certain limit.
+
+	  These kinds of bugs usually occur when call-chains in the
+	  kernel get too deep, especially when interrupts are
+	  involved.
+
+	  Use this in cases where you see apparently random memory
+	  corruption, especially if it appears in 'struct thread_info'
+
+	  If in doubt, say "N".
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
_
