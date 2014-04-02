Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbaDBPoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:44:34 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40766 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaDBPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:44:31 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: [RFC v2 10/10] kdb: Allow access to sensitive commands to be restricted by default
Date: Wed,  2 Apr 2014 16:44:00 +0100
Message-Id: <1396453440-16445-11-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kiosk mode must be explicitly requested by the bootloader or
userspace. It is convenient to be able to change the default value in a
similar manner to CONFIG_MAGIC_SYSRQ_DEFAULT_MASK.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 kernel/debug/kdb/kdb_main.c |  2 +-
 lib/Kconfig.kgdb            | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 77b6e61..34f0989 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -47,7 +47,7 @@
 #undef	MODULE_PARAM_PREFIX
 #define	MODULE_PARAM_PREFIX "kdb."
 
-static bool kdb_kiosk;
+static bool kdb_kiosk = CONFIG_KDB_KIOSK_DEFAULT_ENABLE;
 module_param_named(kiosk, kdb_kiosk, bool, 0600);
 
 #define GREP_LEN 256
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 358eb81..a284327 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -73,6 +73,27 @@ config KGDB_KDB
 	help
 	  KDB frontend for kernel
 
+config KDB_KIOSK_DEFAULT_ENABLE
+	bool "KDB: enable kiosk mode at kernel boot time"
+	depends on KGDB_KDB
+	default n
+	help
+	  Kiosk mode disables kdb commands that can be trivially used to
+	  escalate privilege or dump sensitive data. Those commands that
+	  remain are sufficient for certain types of fault diagnosis but
+	  not fully fledged debugging.
+
+	  Note that it is assumed that neither the process list, the
+	  kernel log buffer nor the (kernel) backtrace of running
+	  processes contain sensitive information.
+
+	  The config option merely sets the default at boot time. Both
+	  issuing 'echo X > /sys/module/kdb/parameters/kiosk' or
+          booting with kdb.kiosk=X kernel command line option will override
+	  the default settings.
+
+	  If unsure, say N.
+
 config KDB_KEYBOARD
 	bool "KGDB_KDB: keyboard as input device"
 	depends on VT && KGDB_KDB
-- 
1.9.0

