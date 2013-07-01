Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3GAUGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:06:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:49020 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab3GAUEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:04:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="363734574"
Subject: [PATCH 4/7] consolidate compilation option configs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 01 Jul 2013 13:04:46 -0700
References: <20130701200440.712D8B4E@viggo.jf.intel.com>
In-Reply-To: <20130701200440.712D8B4E@viggo.jf.intel.com>
Message-Id: <20130701200446.F8AA3CF7@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave@linux.vnet.ibm.com>

Original Post:

	http://lkml.kernel.org/r/20121214184207.6E00DDEC@kernel.stglabs.ibm.com

Again, trying to come up with some common themes of the stuff in
the kernel hacking menu...  There are quite a few options to
tweak compilation in some way, or perform extra compile-time
checks.  Give them their own menu.

The diff here looks a bit funny... makes it look like I'm
moving debugfs even though I'm actually moving the options on
either side of it.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/lib/Kconfig.debug |  156 +++++++++++++++++------------------
 1 file changed, 80 insertions(+), 76 deletions(-)

diff -puN lib/Kconfig.debug~consolidate-compilation-configs lib/Kconfig.debug
--- linux.git/lib/Kconfig.debug~consolidate-compilation-configs	2013-07-01 12:53:21.262520509 -0700
+++ linux.git-davehans/lib/Kconfig.debug	2013-07-01 12:53:21.266520686 -0700
@@ -25,6 +25,34 @@ config DEFAULT_MESSAGE_LOGLEVEL
 	  that are auditing their logs closely may want to set it to a lower
 	  priority.
 
+menu "Compile-time checks and compiler options"
+
+config DEBUG_INFO
+	bool "Compile the kernel with debug info"
+	depends on DEBUG_KERNEL
+	help
+          If you say Y here the resulting kernel image will include
+	  debugging info resulting in a larger kernel image.
+	  This adds debug symbols to the kernel and modules (gcc -g), and
+	  is needed if you intend to use kernel crashdump or binary object
+	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
+	  Say Y here only if you plan to debug the kernel.
+
+	  If unsure, say N.
+
+config DEBUG_INFO_REDUCED
+	bool "Reduce debugging information"
+	depends on DEBUG_INFO
+	help
+	  If you say Y here gcc is instructed to generate less debugging
+	  information for structure types. This means that tools that
+	  need full debugging information (like kgdb or systemtap) won't
+	  be happy. But if you merely need debugging information to
+	  resolve line numbers there is no loss. Advantage is that
+	  build directory object sizes shrink dramatically over a full
+	  DEBUG_INFO build and compile times are reduced too.
+	  Only works with newer gcc versions.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
@@ -52,20 +80,6 @@ config FRAME_WARN
 	  Setting it to 0 disables the warning.
 	  Requires gcc 4.4
 
-config MAGIC_SYSRQ
-	bool "Magic SysRq key"
-	depends on !UML
-	help
-	  If you say Y here, you will have some control over the system even
-	  if the system crashes for example during kernel debugging (e.g., you
-	  will be able to flush the buffer cache to disk, reboot the system
-	  immediately or dump some status information). This is accomplished
-	  by pressing various keys while holding SysRq (Alt+PrintScreen). It
-	  also works on a serial console (on PC hardware at least), if you
-	  send a BREAK and then within 5 seconds a command keypress. The
-	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
-	  unless you really know what this hack does.
-
 config STRIP_ASM_SYMS
 	bool "Strip assembler-generated symbols during link"
 	default n
@@ -156,6 +170,58 @@ config DEBUG_SECTION_MISMATCH
 	  - Enable verbose reporting from modpost in order to help resolve
 	    the section mismatches that are reported.
 
+#
+# Select this config option from the architecture Kconfig, if it
+# is preferred to always offer frame pointers as a config
+# option on the architecture (regardless of KERNEL_DEBUG):
+#
+config ARCH_WANT_FRAME_POINTERS
+	bool
+	help
+
+config FRAME_POINTER
+	bool "Compile the kernel with frame pointers"
+	depends on DEBUG_KERNEL && \
+		(CRIS || M68K || FRV || UML || \
+		 AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || \
+		ARCH_WANT_FRAME_POINTERS
+	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
+	help
+	  If you say Y here the resulting kernel image will be slightly
+	  larger and slower, but it gives very useful debugging information
+	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
+
+config DEBUG_FORCE_WEAK_PER_CPU
+	bool "Force weak per-cpu definitions"
+	depends on DEBUG_KERNEL
+	help
+	  s390 and alpha require percpu variables in modules to be
+	  defined weak to work around addressing range issue which
+	  puts the following two restrictions on percpu variable
+	  definitions.
+
+	  1. percpu symbols must be unique whether static or not
+	  2. percpu variables can't be defined inside a function
+
+	  To ensure that generic code follows the above rules, this
+	  option forces all percpu variables to be defined as weak.
+
+endmenu # "Compiler options"
+
+config MAGIC_SYSRQ
+	bool "Magic SysRq key"
+	depends on !UML
+	help
+	  If you say Y here, you will have some control over the system even
+	  if the system crashes for example during kernel debugging (e.g., you
+	  will be able to flush the buffer cache to disk, reboot the system
+	  immediately or dump some status information). This is accomplished
+	  by pressing various keys while holding SysRq (Alt+PrintScreen). It
+	  also works on a serial console (on PC hardware at least), if you
+	  send a BREAK and then within 5 seconds a command keypress. The
+	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
+	  unless you really know what this hack does.
+
 config DEBUG_KERNEL
 	bool "Kernel debugging"
 	help
@@ -816,32 +882,6 @@ config DEBUG_BUGVERBOSE
 	  of the BUG call as well as the EIP and oops trace.  This aids
 	  debugging but costs about 70-100K of memory.
 
-config DEBUG_INFO
-	bool "Compile the kernel with debug info"
-	depends on DEBUG_KERNEL
-	help
-          If you say Y here the resulting kernel image will include
-	  debugging info resulting in a larger kernel image.
-	  This adds debug symbols to the kernel and modules (gcc -g), and
-	  is needed if you intend to use kernel crashdump or binary object
-	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
-	  Say Y here only if you plan to debug the kernel.
-
-	  If unsure, say N.
-
-config DEBUG_INFO_REDUCED
-	bool "Reduce debugging information"
-	depends on DEBUG_INFO
-	help
-	  If you say Y here gcc is instructed to generate less debugging
-	  information for structure types. This means that tools that
-	  need full debugging information (like kgdb or systemtap) won't
-	  be happy. But if you merely need debugging information to
-	  resolve line numbers there is no loss. Advantage is that
-	  build directory object sizes shrink dramatically over a full
-	  DEBUG_INFO build and compile times are reduced too.
-	  Only works with newer gcc versions.
-
 config DEBUG_WRITECOUNT
 	bool "Debug filesystem writers count"
 	depends on DEBUG_KERNEL
@@ -896,27 +936,6 @@ config DEBUG_CREDENTIALS
 
 	  If unsure, say N.
 
-#
-# Select this config option from the architecture Kconfig, if it
-# is preferred to always offer frame pointers as a config
-# option on the architecture (regardless of KERNEL_DEBUG):
-#
-config ARCH_WANT_FRAME_POINTERS
-	bool
-	help
-
-config FRAME_POINTER
-	bool "Compile the kernel with frame pointers"
-	depends on DEBUG_KERNEL && \
-		(CRIS || M68K || FRV || UML || \
-		 AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || \
-		ARCH_WANT_FRAME_POINTERS
-	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
-	help
-	  If you say Y here the resulting kernel image will be slightly
-	  larger and slower, but it gives very useful debugging information
-	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
-
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
 	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
@@ -1100,21 +1119,6 @@ config DEBUG_BLOCK_EXT_DEVT
 
 	  Say N if you are unsure.
 
-config DEBUG_FORCE_WEAK_PER_CPU
-	bool "Force weak per-cpu definitions"
-	depends on DEBUG_KERNEL
-	help
-	  s390 and alpha require percpu variables in modules to be
-	  defined weak to work around addressing range issue which
-	  puts the following two restrictions on percpu variable
-	  definitions.
-
-	  1. percpu symbols must be unique whether static or not
-	  2. percpu variables can't be defined inside a function
-
-	  To ensure that generic code follows the above rules, this
-	  option forces all percpu variables to be defined as weak.
-
 config NOTIFIER_ERROR_INJECTION
 	tristate "Notifier error injection"
 	depends on DEBUG_KERNEL
_
