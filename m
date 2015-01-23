Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbbAWSh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:37:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:17665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450AbbAWShx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:37:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="655613544"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 05/10] drivers/char: Support compiling out /dev/zero
Date: Fri, 23 Jan 2015 12:37:11 -0600
Message-Id: <79846ac644fe9103ef9b7cb0ab69e6f196f27853.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some embedded systems with tightly controlled userspace have no use
for /dev/zero, and could benefit from the size savings gained by
omitting it.  Add a new EMBEDDED config option to disable it.

bloat-o-meter (based on tinyconfig):

add/remove: 0/3 grow/shrink: 0/1 up/down: 0/-391 (-391)
function                                     old     new   delta
chr_dev_init                                 162     147     -15
mmap_zero                                     16       -     -16
zero_fops                                    116       -    -116
zero_bdi                                     244       -    -244

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/char/Kconfig | 10 ++++++++++
 drivers/char/mem.c   | 15 +++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 17f6ddf..00f9b8a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -46,6 +46,16 @@ config DEVNULL
 	  systems with strictly controlled userspace may not need it.
 	  When in doubt, say "Y".
 
+config DEVZERO
+	bool "/dev/zero virtual device support" if EMBEDDED
+	depends on DEVMEM_BASE
+	default y
+	help
+	  Say Y here if you want to support the /dev/zero device. The
+	  /dev/zero device is used by many programs, but some embedded
+	  systems with strictly controlled userspace may not need it.
+	  When in doubt, say "Y".
+
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 25d6f5b..96f7a9d 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -633,7 +633,8 @@ static ssize_t __maybe_unused aio_write_null(struct kiocb *iocb,
 	return iov_length(iov, nr_segs);
 }
 
-static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
+static ssize_t __maybe_unused read_iter_zero(struct kiocb *iocb,
+					     struct iov_iter *iter)
 {
 	size_t written = 0;
 
@@ -652,6 +653,7 @@ static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
 	return written;
 }
 
+#ifdef CONFIG_DEVZERO
 static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 {
 #ifndef CONFIG_MMU
@@ -661,6 +663,7 @@ static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 		return shmem_zero_setup(vma);
 	return 0;
 }
+#endif
 
 static ssize_t write_full(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
@@ -767,6 +770,7 @@ static const struct file_operations port_fops = {
 };
 #endif
 
+#ifdef CONFIG_DEVZERO
 static const struct file_operations zero_fops = {
 	.llseek		= zero_lseek,
 	.read		= new_sync_read,
@@ -785,6 +789,7 @@ static struct backing_dev_info zero_bdi = {
 	.name		= "char/mem",
 	.capabilities	= BDI_CAP_MAP_COPY | BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
+#endif
 
 static const struct file_operations full_fops = {
 	.llseek		= full_lseek,
@@ -811,7 +816,9 @@ static const struct memdev {
 #ifdef CONFIG_DEVPORT
 	 [4] = { "port", 0, &port_fops, NULL },
 #endif
+#ifdef CONFIG_DEVZERO
 	 [5] = { "zero", 0666, &zero_fops, &zero_bdi },
+#endif
 	 [7] = { "full", 0666, &full_fops, NULL },
 	 [8] = { "random", 0666, &random_fops, NULL },
 	 [9] = { "urandom", 0666, &urandom_fops, NULL },
@@ -864,12 +871,12 @@ static struct class *mem_class;
 static int __init chr_dev_init(void)
 {
 	int minor;
-	int err;
 
-	err = bdi_init(&zero_bdi);
+#ifdef CONFIG_DEVZERO
+	int err = bdi_init(&zero_bdi);
 	if (err)
 		return err;
-
+#endif
 	if (register_chrdev(MEM_MAJOR, "mem", &memory_fops))
 		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
 
-- 
1.9.3

