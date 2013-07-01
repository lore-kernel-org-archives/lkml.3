Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3GAUFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:05:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:49020 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab3GAUEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:04:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="363734589"
Subject: [PATCH 6/7] kconfig: consolidate printk options
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 01 Jul 2013 13:04:49 -0700
References: <20130701200440.712D8B4E@viggo.jf.intel.com>
In-Reply-To: <20130701200440.712D8B4E@viggo.jf.intel.com>
Message-Id: <20130701200449.984D093C@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Same deal, take the printk-related things and hide them in a menu.
This takes another 4 items out of the top-level menu.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/lib/Kconfig.debug |  177 +++++++++++++++++------------------
 1 file changed, 90 insertions(+), 87 deletions(-)

diff -puN lib/Kconfig.debug~printk-options lib/Kconfig.debug
--- linux.git/lib/Kconfig.debug~printk-options	2013-07-01 12:53:21.781543517 -0700
+++ linux.git-davehans/lib/Kconfig.debug	2013-07-01 12:53:21.785543695 -0700
@@ -1,3 +1,4 @@
+menu "printk and dmesg options"
 
 config PRINTK_TIME
 	bool "Show timing information on printks"
@@ -25,6 +26,95 @@ config DEFAULT_MESSAGE_LOGLEVEL
 	  that are auditing their logs closely may want to set it to a lower
 	  priority.
 
+config BOOT_PRINTK_DELAY
+	bool "Delay each boot printk message by N milliseconds"
+	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
+	help
+	  This build option allows you to read kernel boot messages
+	  by inserting a short delay after each one.  The delay is
+	  specified in milliseconds on the kernel command line,
+	  using "boot_delay=N".
+
+	  It is likely that you would also need to use "lpj=M" to preset
+	  the "loops per jiffie" value.
+	  See a previous boot log for the "lpj" value to use for your
+	  system, and then set "lpj=M" before setting "boot_delay=N".
+	  NOTE:  Using this option may adversely affect SMP systems.
+	  I.e., processors other than the first one may not boot up.
+	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
+	  what it believes to be lockup conditions.
+
+config DYNAMIC_DEBUG
+	bool "Enable dynamic printk() support"
+	default n
+	depends on PRINTK
+	depends on DEBUG_FS
+	help
+
+	  Compiles debug level messages into the kernel, which would not
+	  otherwise be available at runtime. These messages can then be
+	  enabled/disabled based on various levels of scope - per source file,
+	  function, module, format string, and line number. This mechanism
+	  implicitly compiles in all pr_debug() and dev_dbg() calls, which
+	  enlarges the kernel text size by about 2%.
+
+	  If a source file is compiled with DEBUG flag set, any
+	  pr_debug() calls in it are enabled by default, but can be
+	  disabled at runtime as below.  Note that DEBUG flag is
+	  turned on by many CONFIG_*DEBUG* options.
+
+	  Usage:
+
+	  Dynamic debugging is controlled via the 'dynamic_debug/control' file,
+	  which is contained in the 'debugfs' filesystem. Thus, the debugfs
+	  filesystem must first be mounted before making use of this feature.
+	  We refer the control file as: <debugfs>/dynamic_debug/control. This
+	  file contains a list of the debug statements that can be enabled. The
+	  format for each line of the file is:
+
+		filename:lineno [module]function flags format
+
+	  filename : source file of the debug statement
+	  lineno : line number of the debug statement
+	  module : module that contains the debug statement
+	  function : function that contains the debug statement
+          flags : '=p' means the line is turned 'on' for printing
+          format : the format used for the debug statement
+
+	  From a live system:
+
+		nullarbor:~ # cat <debugfs>/dynamic_debug/control
+		# filename:lineno [module]function flags format
+		fs/aio.c:222 [aio]__put_ioctx =_ "__put_ioctx:\040freeing\040%p\012"
+		fs/aio.c:248 [aio]ioctx_alloc =_ "ENOMEM:\040nr_events\040too\040high\012"
+		fs/aio.c:1770 [aio]sys_io_cancel =_ "calling\040cancel\012"
+
+	  Example usage:
+
+		// enable the message at line 1603 of file svcsock.c
+		nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
+						<debugfs>/dynamic_debug/control
+
+		// enable all the messages in file svcsock.c
+		nullarbor:~ # echo -n 'file svcsock.c +p' >
+						<debugfs>/dynamic_debug/control
+
+		// enable all the messages in the NFS server module
+		nullarbor:~ # echo -n 'module nfsd +p' >
+						<debugfs>/dynamic_debug/control
+
+		// enable all 12 messages in the function svc_process()
+		nullarbor:~ # echo -n 'func svc_process +p' >
+						<debugfs>/dynamic_debug/control
+
+		// disable all 12 messages in the function svc_process()
+		nullarbor:~ # echo -n 'func svc_process -p' >
+						<debugfs>/dynamic_debug/control
+
+	  See Documentation/dynamic-debug-howto.txt for additional information.
+
+endmenu # "printk and dmesg options"
+
 menu "Compile-time checks and compiler options"
 
 config DEBUG_INFO
@@ -940,24 +1030,6 @@ config DEBUG_CREDENTIALS
 
 	  If unsure, say N.
 
-config BOOT_PRINTK_DELAY
-	bool "Delay each boot printk message by N milliseconds"
-	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
-	help
-	  This build option allows you to read kernel boot messages
-	  by inserting a short delay after each one.  The delay is
-	  specified in milliseconds on the kernel command line,
-	  using "boot_delay=N".
-
-	  It is likely that you would also need to use "lpj=M" to preset
-	  the "loops per jiffie" value.
-	  See a previous boot log for the "lpj" value to use for your
-	  system, and then set "lpj=M" before setting "boot_delay=N".
-	  NOTE:  Using this option may adversely affect SMP systems.
-	  I.e., processors other than the first one may not boot up.
-	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
-	  what it believes to be lockup conditions.
-
 menu "RCU Debugging"
 
 config PROVE_RCU
@@ -1441,75 +1513,6 @@ config BUILD_DOCSRC
 
 	  Say N if you are unsure.
 
-config DYNAMIC_DEBUG
-	bool "Enable dynamic printk() support"
-	default n
-	depends on PRINTK
-	depends on DEBUG_FS
-	help
-
-	  Compiles debug level messages into the kernel, which would not
-	  otherwise be available at runtime. These messages can then be
-	  enabled/disabled based on various levels of scope - per source file,
-	  function, module, format string, and line number. This mechanism
-	  implicitly compiles in all pr_debug() and dev_dbg() calls, which
-	  enlarges the kernel text size by about 2%.
-
-	  If a source file is compiled with DEBUG flag set, any
-	  pr_debug() calls in it are enabled by default, but can be
-	  disabled at runtime as below.  Note that DEBUG flag is
-	  turned on by many CONFIG_*DEBUG* options.
-
-	  Usage:
-
-	  Dynamic debugging is controlled via the 'dynamic_debug/control' file,
-	  which is contained in the 'debugfs' filesystem. Thus, the debugfs
-	  filesystem must first be mounted before making use of this feature.
-	  We refer the control file as: <debugfs>/dynamic_debug/control. This
-	  file contains a list of the debug statements that can be enabled. The
-	  format for each line of the file is:
-
-		filename:lineno [module]function flags format
-
-	  filename : source file of the debug statement
-	  lineno : line number of the debug statement
-	  module : module that contains the debug statement
-	  function : function that contains the debug statement
-          flags : '=p' means the line is turned 'on' for printing
-          format : the format used for the debug statement
-
-	  From a live system:
-
-		nullarbor:~ # cat <debugfs>/dynamic_debug/control
-		# filename:lineno [module]function flags format
-		fs/aio.c:222 [aio]__put_ioctx =_ "__put_ioctx:\040freeing\040%p\012"
-		fs/aio.c:248 [aio]ioctx_alloc =_ "ENOMEM:\040nr_events\040too\040high\012"
-		fs/aio.c:1770 [aio]sys_io_cancel =_ "calling\040cancel\012"
-
-	  Example usage:
-
-		// enable the message at line 1603 of file svcsock.c
-		nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
-						<debugfs>/dynamic_debug/control
-
-		// enable all the messages in file svcsock.c
-		nullarbor:~ # echo -n 'file svcsock.c +p' >
-						<debugfs>/dynamic_debug/control
-
-		// enable all the messages in the NFS server module
-		nullarbor:~ # echo -n 'module nfsd +p' >
-						<debugfs>/dynamic_debug/control
-
-		// enable all 12 messages in the function svc_process()
-		nullarbor:~ # echo -n 'func svc_process +p' >
-						<debugfs>/dynamic_debug/control
-
-		// disable all 12 messages in the function svc_process()
-		nullarbor:~ # echo -n 'func svc_process -p' >
-						<debugfs>/dynamic_debug/control
-
-	  See Documentation/dynamic-debug-howto.txt for additional information.
-
 config DMA_API_DEBUG
 	bool "Enable debugging of DMA-API usage"
 	depends on HAVE_DMA_API_DEBUG
_
