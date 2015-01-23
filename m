Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbbAWSiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:38:07 -0500
Received: from mga14.intel.com ([192.55.52.115]:15256 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477AbbAWSiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:38:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444305425"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 08/10] drivers/char: Support compiling out /dev/urandom
Date: Fri, 23 Jan 2015 12:37:14 -0600
Message-Id: <d290225cb95d42a41a08a454da670ff427a43004.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some embedded systems with tightly controlled userspace have no use
for /dev/urandom, and could benefit from the size savings gained by
omitting it.  Add a new EMBEDDED config option to disable it.

bloat-o-meter (based on tinyconfig):

add/remove: 0/2 grow/shrink: 1/0 up/down: 77/-212 (-135)
function                                     old     new   delta
sys_getrandom                                211     288     +77
urandom_read                                  96       -     -96
urandom_fops                                 116       -    -116

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/char/Kconfig  | 11 +++++++++++
 drivers/char/mem.c    |  2 ++
 drivers/char/random.c |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 9416b7e..1af4551 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -78,6 +78,17 @@ config DEVRANDOM
 	  disabled on systems that will never use it in production,
 	  such as many embedded systems.  When in doubt, say "Y".
 
+config DEVURANDOM
+	bool "/dev/urandom virtual device support" if EMBEDDED
+	depends on DEVMEM_BASE
+	default y
+	help
+	  Say Y here if you want to support the /dev/urandom
+	  device. The /dev/urandom device is the nonblocking userspace
+	  interface to the kernel random number generator, and can be
+	  disabled on systems that will never use it in production,
+	  such as many embedded systems.  When in doubt, say "Y".
+
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f226714..5315f63 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -829,7 +829,9 @@ static const struct memdev {
 #ifdef CONFIG_DEVRANDOM
 	 [8] = { "random", 0666, &random_fops, NULL },
 #endif
+#ifdef CONFIG_DEVURANDOM
 	 [9] = { "urandom", 0666, &urandom_fops, NULL },
+#endif
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
 #endif
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8547056..7e5a423 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1520,6 +1520,7 @@ const struct file_operations random_fops = {
 };
 #endif
 
+#ifdef CONFIG_DEVURANDOM
 const struct file_operations urandom_fops = {
 	.read  = urandom_read,
 	.write = random_write,
@@ -1527,6 +1528,7 @@ const struct file_operations urandom_fops = {
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
 };
+#endif
 
 SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 		unsigned int, flags)
-- 
1.9.3

