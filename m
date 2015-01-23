Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbbAWSiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:38:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:49909 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbbAWSiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:38:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="516734433"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 09/10] drivers/char: Support compiling out /dev/kmsg
Date: Fri, 23 Jan 2015 12:37:15 -0600
Message-Id: <d6aa6b4ddb71e34d173f9b2874de60c2836ecc6c.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some embedded systems with tightly controlled userspace have no use
for /dev/kmsg, and could benefit from the size savings gained by
omitting it.  Add a new EMBEDDED config option to disable it.

bloat-o-meter (based on tinyconfig):

add/remove: 0/8 grow/shrink: 1/1 up/down: 92/-1538 (-1446)
function                                     old     new   delta
do_syslog                                   1027    1119     +92
devkmsg_release                               15       -     -15
devlist                                      192     160     -32
devkmsg_poll                                  97       -     -97
devkmsg_open                                 112       -    -112
check_syslog_permissions                     114       -    -114
kmsg_fops                                    116       -    -116
devkmsg_llseek                               144       -    -144
devkmsg_write                                209       -    -209
devkmsg_read                                 699       -    -699

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/char/Kconfig   | 14 ++++++++++++++
 drivers/char/mem.c     |  2 +-
 kernel/printk/printk.c |  2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 1af4551..25fe627 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -89,6 +89,20 @@ config DEVURANDOM
 	  disabled on systems that will never use it in production,
 	  such as many embedded systems.  When in doubt, say "Y".
 
+config DEVKMSG
+	bool "/dev/kmsg virtual device support" if EMBEDDED
+	depends on DEVMEM_BASE && PRINTK
+	default y
+	help
+	  Say Y here if you want to support the /dev/kmsg device. The
+	  /dev/kmsg device provides access to the raw kernel message
+	  ring buffer, and can be disabled on systems that will never
+	  use it in production, such as many embedded systems.  The
+	  kernel log buffer is also accessible via the syslog() kernel
+	  interface and userspace tools such as dmesg (using -S) can
+	  be directed to use that interface instead.  When in doubt,
+	  say "Y".
+
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 5315f63..6cc26ea 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -832,7 +832,7 @@ static const struct memdev {
 #ifdef CONFIG_DEVURANDOM
 	 [9] = { "urandom", 0666, &urandom_fops, NULL },
 #endif
-#ifdef CONFIG_PRINTK
+#ifdef CONFIG_DEVKMSG
 	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
 #endif
 };
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 02d6b6d..fbd05d8 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -505,6 +505,7 @@ int check_syslog_permissions(int type, bool from_file)
 	return security_syslog(type);
 }
 
+#ifdef CONFIG_DEVKMSG
 
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
@@ -797,6 +798,7 @@ const struct file_operations kmsg_fops = {
 	.poll = devkmsg_poll,
 	.release = devkmsg_release,
 };
+#endif
 
 #ifdef CONFIG_KEXEC
 /*
-- 
1.9.3

