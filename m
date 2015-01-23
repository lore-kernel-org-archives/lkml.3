Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbbAWSjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:39:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:52939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443AbbAWShw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:37:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="674944826"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 06/10] drivers/char: Support compiling out /dev/full
Date: Fri, 23 Jan 2015 12:37:12 -0600
Message-Id: <42f8b4b6c8b37e1f349c4607feceff4472cc9d6c.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most embedded systems have no use for /dev/full, and omitting it saves
space.  Add a new EMBEDDED config option to disable it.

bloat-o-meter (based on tinyconfig):

add/remove: 0/2 grow/shrink: 0/0 up/down: 0/-122 (-122)
function                                     old     new   delta
write_full                                     6       -      -6
full_fops                                    116       -    -116

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/char/Kconfig | 11 +++++++++++
 drivers/char/mem.c   |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 00f9b8a..62290e0 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -56,6 +56,17 @@ config DEVZERO
 	  systems with strictly controlled userspace may not need it.
 	  When in doubt, say "Y".
 
+config DEVFULL
+	bool "/dev/full virtual device support" if EMBEDDED
+	depends on DEVMEM_BASE
+	default y
+	help
+	  Say Y here if you want to support the /dev/full device. The
+	  /dev/full device is used mainly for testing how programs
+	  respond to ENOSPC, and can be disabled on systems that will
+	  never use it in production, such as many embedded systems.
+	  When in doubt, say "Y".
+
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 96f7a9d..5b60003 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -665,11 +665,13 @@ static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 }
 #endif
 
+#ifdef CONFIG_DEVFULL
 static ssize_t write_full(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	return -ENOSPC;
 }
+#endif
 
 /*
  * Special lseek() function for /dev/null and /dev/zero.  Most notably, you
@@ -791,12 +793,14 @@ static struct backing_dev_info zero_bdi = {
 };
 #endif
 
+#ifdef CONFIG_DEVFULL
 static const struct file_operations full_fops = {
 	.llseek		= full_lseek,
 	.read		= new_sync_read,
 	.read_iter	= read_iter_zero,
 	.write		= write_full,
 };
+#endif
 
 static const struct memdev {
 	const char *name;
@@ -819,7 +823,9 @@ static const struct memdev {
 #ifdef CONFIG_DEVZERO
 	 [5] = { "zero", 0666, &zero_fops, &zero_bdi },
 #endif
+#ifdef CONFIG_DEVFULL
 	 [7] = { "full", 0666, &full_fops, NULL },
+#endif
 	 [8] = { "random", 0666, &random_fops, NULL },
 	 [9] = { "urandom", 0666, &urandom_fops, NULL },
 #ifdef CONFIG_PRINTK
-- 
1.9.3

