Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3AKRBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:01:02 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38373 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab3AKRA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:00:58 -0500
Subject: [PATCH] consolidate per-arch stack overflow debugging options
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>,
        David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 11 Jan 2013 09:00:43 -0800
Message-Id: <20130111170043.D7CC39DC@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011117-5806-0000-0000-00001E1E226D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm looking for some Acked-bys on this from the various arch
maintainers that it affects.  I'd like to send it up to Linus
in the next merge window.  This is part of a larger series to
clean up the "Kernel Hacking" menu:

	https://lkml.org/lkml/2012/12/17/306

--

Several architectures have similar stack debugging config options.
They all pretty much do the same thing, some with slightly
differing help text.

This patch changes the architectures to instead enable a Kconfig
boolean, and then use that boolean in the generic Kconfig.debug
to present the actual menu option.  This removes a bunch of
duplication and adds consistency across arches.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
---

 linux-2.6.git-dave/arch/blackfin/Kconfig       |    1 +
 linux-2.6.git-dave/arch/blackfin/Kconfig.debug |    7 -------
 linux-2.6.git-dave/arch/frv/Kconfig            |    1 +
 linux-2.6.git-dave/arch/frv/Kconfig.debug      |    4 ----
 linux-2.6.git-dave/arch/m32r/Kconfig           |    1 +
 linux-2.6.git-dave/arch/m32r/Kconfig.debug     |    7 -------
 linux-2.6.git-dave/arch/mips/Kconfig           |    1 +
 linux-2.6.git-dave/arch/mips/Kconfig.debug     |    9 ---------
 linux-2.6.git-dave/arch/mn10300/Kconfig        |    1 +
 linux-2.6.git-dave/arch/mn10300/Kconfig.debug  |    4 ----
 linux-2.6.git-dave/arch/powerpc/Kconfig        |    1 +
 linux-2.6.git-dave/arch/powerpc/Kconfig.debug  |    7 -------
 linux-2.6.git-dave/arch/tile/Kconfig           |    1 +
 linux-2.6.git-dave/arch/tile/Kconfig.debug     |    7 -------
 linux-2.6.git-dave/arch/x86/Kconfig            |    1 +
 linux-2.6.git-dave/arch/x86/Kconfig.debug      |   10 ----------
 linux-2.6.git-dave/lib/Kconfig.debug           |   21 +++++++++++++++++++++
 17 files changed, 29 insertions(+), 55 deletions(-)

diff -puN arch/blackfin/Kconfig~consolidat-stack-debugging-configs arch/blackfin/Kconfig
--- linux-2.6.git/arch/blackfin/Kconfig~consolidat-stack-debugging-configs	2013-01-11 08:05:18.902335435 -0800
+++ linux-2.6.git-dave/arch/blackfin/Kconfig	2013-01-11 08:05:18.942335775 -0800
@@ -45,6 +45,7 @@ config BLACKFIN
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config GENERIC_CSUM
 	def_bool y
diff -puN arch/blackfin/Kconfig.debug~consolidat-stack-debugging-configs arch/blackfin/Kconfig.debug
--- linux-2.6.git/arch/blackfin/Kconfig.debug~consolidat-stack-debugging-configs	2013-01-11 08:05:18.902335435 -0800
+++ linux-2.6.git-dave/arch/blackfin/Kconfig.debug	2013-01-11 08:05:18.942335775 -0800
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
--- linux-2.6.git/arch/frv/Kconfig~consolidat-stack-debugging-configs	2013-01-11 08:05:18.906335469 -0800
+++ linux-2.6.git-dave/arch/frv/Kconfig	2013-01-11 08:05:18.942335775 -0800
@@ -12,6 +12,7 @@ config FRV
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config ZONE_DMA
 	bool
diff -puN arch/frv/Kconfig.debug~consolidat-stack-debugging-configs arch/frv/Kconfig.debug
--- linux-2.6.git/arch/frv/Kconfig.debug~consolidat-stack-debugging-configs	2013-01-11 08:05:18.906335469 -0800
+++ linux-2.6.git-dave/arch/frv/Kconfig.debug	2013-01-11 08:05:18.942335775 -0800
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
--- linux-2.6.git/arch/m32r/Kconfig~consolidat-stack-debugging-configs	2013-01-11 08:05:18.910335503 -0800
+++ linux-2.6.git-dave/arch/m32r/Kconfig	2013-01-11 08:05:18.942335775 -0800
@@ -15,6 +15,7 @@ config M32R
 	select GENERIC_ATOMIC64
 	select ARCH_USES_GETTIMEOFFSET
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config SBUS
 	bool
diff -puN arch/m32r/Kconfig.debug~consolidat-stack-debugging-configs arch/m32r/Kconfig.debug
--- linux-2.6.git/arch/m32r/Kconfig.debug~consolidat-stack-debugging-configs	2013-01-11 08:05:18.914335537 -0800
+++ linux-2.6.git-dave/arch/m32r/Kconfig.debug	2013-01-11 08:05:18.942335775 -0800
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
diff -puN arch/mips/Kconfig~consolidat-stack-debugging-configs arch/mips/Kconfig
--- linux-2.6.git/arch/mips/Kconfig~consolidat-stack-debugging-configs	2013-01-11 08:05:18.914335537 -0800
+++ linux-2.6.git-dave/arch/mips/Kconfig	2013-01-11 08:05:18.942335775 -0800
@@ -41,6 +41,7 @@ config MIPS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_REL if MODULES
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
+	select HAVE_DEBUG_STACKOVERFLOW
 
 menu "Machine selection"
 
diff -puN arch/mips/Kconfig.debug~consolidat-stack-debugging-configs arch/mips/Kconfig.debug
--- linux-2.6.git/arch/mips/Kconfig.debug~consolidat-stack-debugging-configs	2013-01-11 08:05:18.918335571 -0800
+++ linux-2.6.git-dave/arch/mips/Kconfig.debug	2013-01-11 08:05:18.942335775 -0800
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
--- linux-2.6.git/arch/mn10300/Kconfig~consolidat-stack-debugging-configs	2013-01-11 08:05:18.918335571 -0800
+++ linux-2.6.git-dave/arch/mn10300/Kconfig	2013-01-11 08:05:18.942335775 -0800
@@ -9,6 +9,7 @@ config MN10300
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config AM33_2
 	def_bool n
diff -puN arch/mn10300/Kconfig.debug~consolidat-stack-debugging-configs arch/mn10300/Kconfig.debug
--- linux-2.6.git/arch/mn10300/Kconfig.debug~consolidat-stack-debugging-configs	2013-01-11 08:05:18.922335605 -0800
+++ linux-2.6.git-dave/arch/mn10300/Kconfig.debug	2013-01-11 08:05:18.942335775 -0800
@@ -2,10 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-
 config DEBUG_DECOMPRESS_KERNEL
 	bool "Using serial port during decompressing kernel"
 	depends on DEBUG_KERNEL
diff -puN arch/powerpc/Kconfig~consolidat-stack-debugging-configs arch/powerpc/Kconfig
--- linux-2.6.git/arch/powerpc/Kconfig~consolidat-stack-debugging-configs	2013-01-11 08:05:18.922335605 -0800
+++ linux-2.6.git-dave/arch/powerpc/Kconfig	2013-01-11 08:05:18.946335809 -0800
@@ -144,6 +144,7 @@ config PPC
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config EARLY_PRINTK
 	bool
diff -puN arch/powerpc/Kconfig.debug~consolidat-stack-debugging-configs arch/powerpc/Kconfig.debug
--- linux-2.6.git/arch/powerpc/Kconfig.debug~consolidat-stack-debugging-configs	2013-01-11 08:05:18.926335639 -0800
+++ linux-2.6.git-dave/arch/powerpc/Kconfig.debug	2013-01-11 08:05:18.946335809 -0800
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
--- linux-2.6.git/arch/tile/Kconfig~consolidat-stack-debugging-configs	2013-01-11 08:05:18.930335673 -0800
+++ linux-2.6.git-dave/arch/tile/Kconfig	2013-01-11 08:05:18.946335809 -0800
@@ -21,6 +21,7 @@ config TILE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff -puN arch/tile/Kconfig.debug~consolidat-stack-debugging-configs arch/tile/Kconfig.debug
--- linux-2.6.git/arch/tile/Kconfig.debug~consolidat-stack-debugging-configs	2013-01-11 08:05:18.930335673 -0800
+++ linux-2.6.git-dave/arch/tile/Kconfig.debug	2013-01-11 08:05:18.946335809 -0800
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
--- linux-2.6.git/arch/x86/Kconfig~consolidat-stack-debugging-configs	2013-01-11 08:05:18.934335707 -0800
+++ linux-2.6.git-dave/arch/x86/Kconfig	2013-01-11 08:05:18.946335809 -0800
@@ -114,6 +114,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select GENERIC_SIGALTSTACK
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config INSTRUCTION_DECODER
 	def_bool y
diff -puN arch/x86/Kconfig.debug~consolidat-stack-debugging-configs arch/x86/Kconfig.debug
--- linux-2.6.git/arch/x86/Kconfig.debug~consolidat-stack-debugging-configs	2013-01-11 08:05:18.934335707 -0800
+++ linux-2.6.git-dave/arch/x86/Kconfig.debug	2013-01-11 08:05:18.946335809 -0800
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
--- linux-2.6.git/lib/Kconfig.debug~consolidat-stack-debugging-configs	2013-01-11 08:05:18.938335741 -0800
+++ linux-2.6.git-dave/lib/Kconfig.debug	2013-01-11 08:05:18.946335809 -0800
@@ -1441,6 +1441,27 @@ config ASYNC_RAID6_TEST
 
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

