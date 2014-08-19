Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaHSOC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:02:27 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:50961 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaHSOCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:02:25 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Subject: [RESEND PATCH v5 3.17-rc1 8/8] kdb: Allow access to sensitive commands to be restricted by default
Date: Tue, 19 Aug 2014 15:02:02 +0100
Message-Id: <1408456922-12221-9-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408456922-12221-1-git-send-email-daniel.thompson@linaro.org>
References: <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
 <1408456922-12221-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kiosk mode must be explicitly requested by the bootloader or
userspace. It is convenient to be able to change the default value in a
similar manner to CONFIG_MAGIC_SYSRQ_DEFAULT_MASK.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net
---
 kernel/debug/kdb/kdb_main.c |  2 +-
 lib/Kconfig.kgdb            | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index fe1ac56..8d84979 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -47,7 +47,7 @@
 #undef	MODULE_PARAM_PREFIX
 #define	MODULE_PARAM_PREFIX "kdb."
 
-static int kdb_cmd_enabled;
+static int kdb_cmd_enabled = CONFIG_KDB_DEFAULT_ENABLE;
 module_param_named(cmd_enable, kdb_cmd_enabled, int, 0600);
 
 #define GREP_LEN 256
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 358eb81..fbbcff6 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -73,6 +73,31 @@ config KGDB_KDB
 	help
 	  KDB frontend for kernel
 
+config KDB_DEFAULT_ENABLE
+	hex "KDB: Select kdb command functions to be enabled by default"
+	depends on KGDB_KDB
+	default 0x1
+	help
+	  Specifiers which kdb commands are enabled by default. This may
+	  be set to 1 or 0 to enable all commands or disable almost all
+	  commands.
+
+	  Alternatively the following bitmask applies:
+
+	    0x0002 - allow arbitrary reads from memory and symbol lookup
+	    0x0004 - allow arbitrary writes to memory
+	    0x0008 - allow current register state to be inspected
+	    0x0010 - allow current register state to be modified
+	    0x0020 - allow passive inspection (backtrace, process list, lsmod)
+	    0x0040 - allow flow control management (breakpoint, single step)
+	    0x0080 - enable signalling of processes
+	    0x0100 - allow machine to be rebooted
+
+	  The config option merely sets the default at boot time. Both
+	  issuing 'echo X > /sys/module/kdb/parameters/kdb.cmd_enable' or
+          setting with kdb.cmd_enable=X kernel command line option will
+	  override the default settings.
+
 config KDB_KEYBOARD
 	bool "KGDB_KDB: keyboard as input device"
 	depends on VT && KGDB_KDB
-- 
1.9.3

