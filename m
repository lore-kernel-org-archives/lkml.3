Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3DVRjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 13:39:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35163 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab3DVRji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 13:39:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] re-order CONFIG_EXPERT options to fix menuconfig display
Date: Mon, 22 Apr 2013 13:39:38 -0400
Message-Id: <1366652378-29558-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kconfig language requires that dependent options all follow the
menuconfig symbol in order to be collapsed below it.  Recently some
hidden options were added below the EXPERT menuconfig, but did not
depend on EXPERT (because hidden options can't).  This broke the
display.  So re-order all these options, and while we're here stick
the PCI quirks under the EXPERT menu (since it isn't sitting with
any related options).

Before this commit, we get:
	[*] Configure standard kernel features (expert users)  --->
	[ ] Sysctl syscall support
	[*] Load all symbols for debugging/ksymoops
	...
	[ ] Embedded system

Now we get the older (and correct) behavior:
	[*] Configure standard kernel features (expert users)  --->
	[ ] Embedded system
And if you go into the expert menu you get the expert options:
	[ ] Sysctl syscall support
	[*] Load all symbols for debugging/ksymoops
	...

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 init/Kconfig | 80 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 5341d72..01b216c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1177,6 +1177,35 @@ config SYSCTL
 config ANON_INODES
 	bool
 
+config HAVE_UID16
+	bool
+
+config SYSCTL_EXCEPTION_TRACE
+	bool
+	help
+	  Enable support for /proc/sys/debug/exception-trace.
+
+config SYSCTL_ARCH_UNALIGN_NO_WARN
+	bool
+	help
+	  Enable support for /proc/sys/kernel/ignore-unaligned-usertrap
+	  Allows arch to define/use @no_unaligned_warning to possibly warn
+	  about unaligned access emulation going on under the hood.
+
+config SYSCTL_ARCH_UNALIGN_ALLOW
+	bool
+	help
+	  Enable support for /proc/sys/kernel/unaligned-trap
+	  Allows arches to define/use @unaligned_enabled to runtime toggle
+	  the unaligned access emulation.
+	  see arch/parisc/kernel/unaligned.c for reference
+
+config HOTPLUG
+	def_bool y
+
+config HAVE_PCSPKR_PLATFORM
+	bool
+
 menuconfig EXPERT
 	bool "Configure standard kernel features (expert users)"
 	# Unhide debug options, to make the on-by-default options visible
@@ -1187,9 +1216,6 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
-config HAVE_UID16
-	bool
-
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on HAVE_UID16
@@ -1214,26 +1240,6 @@ config SYSCTL_SYSCALL
 
 	  If unsure say N here.
 
-config SYSCTL_EXCEPTION_TRACE
-	bool
-	help
-	  Enable support for /proc/sys/debug/exception-trace.
-
-config SYSCTL_ARCH_UNALIGN_NO_WARN
-	bool
-	help
-	  Enable support for /proc/sys/kernel/ignore-unaligned-usertrap
-	  Allows arch to define/use @no_unaligned_warning to possibly warn
-	  about unaligned access emulation going on under the hood.
-
-config SYSCTL_ARCH_UNALIGN_ALLOW
-	bool
-	help
-	  Enable support for /proc/sys/kernel/unaligned-trap
-	  Allows arches to define/use @unaligned_enabled to runtime toggle
-	  the unaligned access emulation.
-	  see arch/parisc/kernel/unaligned.c for reference
-
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EXPERT
 	 default y
@@ -1259,9 +1265,6 @@ config KALLSYMS_ALL
 
 	   Say N unless you really need all symbols.
 
-config HOTPLUG
-	def_bool y
-
 config PRINTK
 	default y
 	bool "Enable support for printk" if EXPERT
@@ -1300,9 +1303,6 @@ config PCSPKR_PLATFORM
           This option allows to disable the internal PC-Speaker
           support, saving some memory.
 
-config HAVE_PCSPKR_PLATFORM
-	bool
-
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EXPERT
@@ -1374,8 +1374,17 @@ config AIO
 	default y
 	help
 	  This option enables POSIX asynchronous I/O which may by used
-          by some high performance threaded applications. Disabling
-          this option saves about 7k.
+	  by some high performance threaded applications. Disabling
+	  this option saves about 7k.
+
+config PCI_QUIRKS
+	default y
+	bool "Enable PCI quirk workarounds" if EXPERT
+	depends on PCI
+	help
+	  This enables workarounds for various PCI chipset
+	  bugs/quirks. Disable this only if your target machine is
+	  unaffected by PCI quirks.
 
 config EMBEDDED
 	bool "Embedded system"
@@ -1450,15 +1459,6 @@ config VM_EVENT_COUNTERS
 	  on EXPERT systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.
 
-config PCI_QUIRKS
-	default y
-	bool "Enable PCI quirk workarounds" if EXPERT
-	depends on PCI
-	help
-	  This enables workarounds for various PCI chipset
-          bugs/quirks. Disable this only if your target machine is
-          unaffected by PCI quirks.
-
 config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EXPERT
-- 
1.8.2.1

