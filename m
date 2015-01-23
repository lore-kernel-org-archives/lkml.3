Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbbAWSj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:39:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:16173 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbbAWShv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:37:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="666611187"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 04/10] drivers/char: Support compiling out /dev/null
Date: Fri, 23 Jan 2015 12:37:10 -0600
Message-Id: <331a37ea64bd58f9d66869fd2ccd8034ab1566d6.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some embedded systems with tightly controlled userspace have no use
for /dev/null, and could benefit from the size savings gained by
omitting it.  Add a new EMBEDDED config option to disable it.

write_null() and aio_write_null() are shared between /dev/null and
/dev/zero; making it __maybe_unused prevents them from emitting
warnings if both devices are compiled out, while avoiding ugly
compound ifdefs.  Similarly for null_lseek, shared between /dev/null,
/dev/zero, and /dev/full.

bloat-o-meter (based on tinyconfig):

add/remove: 0/5 grow/shrink: 0/0 up/down: 0/-150 (-150)
function                                     old     new   delta
read_null                                      3       -      -3
aio_read_null                                  3       -      -3
pipe_to_null                                   4       -      -4
splice_write_null                             24       -     -24
null_fops                                    116       -    -116

bloat-o-meter showing the difference between only CONFIG_DEVZERO and
CONFIG_DEVFULL off and both those plus CONFIG_DEVNULL off:

add/remove: 0/8 grow/shrink: 0/0 up/down: 0/-196 (-196)
function                                     old     new   delta
write_null                                     3       -      -3
read_null                                      3       -      -3
aio_read_null                                  3       -      -3
pipe_to_null                                   4       -      -4
aio_write_null                                18       -     -18
splice_write_null                             24       -     -24
null_lseek                                    25       -     -25
null_fops                                    116       -    -116

So with DEVZERO also configured out, we see the shared write_null,
aio_write_null, and null_lseek drop out.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/char/Kconfig | 10 ++++++++++
 drivers/char/mem.c   | 35 ++++++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 5a6c060..17f6ddf 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -36,6 +36,16 @@ config DEVMEM
 	  disabled on systems that will never use either, such as many
 	  embedded systems.  When in doubt, say "Y".
 
+config DEVNULL
+	bool "/dev/null virtual device support" if EMBEDDED
+	depends on DEVMEM_BASE
+	default y
+	help
+	  Say Y here if you want to support the /dev/null device. The
+	  /dev/null device is used by many programs, but some embedded
+	  systems with strictly controlled userspace may not need it.
+	  When in doubt, say "Y".
+
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 5944d87..25d6f5b 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -593,30 +593,19 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 }
 #endif
 
+#ifdef CONFIG_DEVNULL
 static ssize_t read_null(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	return 0;
 }
 
-static ssize_t write_null(struct file *file, const char __user *buf,
-			  size_t count, loff_t *ppos)
-{
-	return count;
-}
-
 static ssize_t aio_read_null(struct kiocb *iocb, const struct iovec *iov,
 			     unsigned long nr_segs, loff_t pos)
 {
 	return 0;
 }
 
-static ssize_t aio_write_null(struct kiocb *iocb, const struct iovec *iov,
-			      unsigned long nr_segs, loff_t pos)
-{
-	return iov_length(iov, nr_segs);
-}
-
 static int pipe_to_null(struct pipe_inode_info *info, struct pipe_buffer *buf,
 			struct splice_desc *sd)
 {
@@ -628,6 +617,21 @@ static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
 {
 	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
 }
+#endif
+
+static ssize_t __maybe_unused write_null(struct file *file,
+					 const char __user *buf,
+					 size_t count, loff_t *ppos)
+{
+	return count;
+}
+
+static ssize_t __maybe_unused aio_write_null(struct kiocb *iocb,
+					     const struct iovec *iov,
+					     unsigned long nr_segs, loff_t pos)
+{
+	return iov_length(iov, nr_segs);
+}
 
 static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
 {
@@ -669,7 +673,8 @@ static ssize_t write_full(struct file *file, const char __user *buf,
  * can fopen() both devices with "a" now.  This was previously impossible.
  * -- SRB.
  */
-static loff_t null_lseek(struct file *file, loff_t offset, int orig)
+static loff_t __maybe_unused null_lseek(struct file *file, loff_t offset,
+					int orig)
 {
 	return file->f_pos = 0;
 }
@@ -742,6 +747,7 @@ static const struct file_operations kmem_fops = {
 };
 #endif
 
+#ifdef CONFIG_DEVNULL
 static const struct file_operations null_fops = {
 	.llseek		= null_lseek,
 	.read		= read_null,
@@ -750,6 +756,7 @@ static const struct file_operations null_fops = {
 	.aio_write	= aio_write_null,
 	.splice_write	= splice_write_null,
 };
+#endif
 
 #ifdef CONFIG_DEVPORT
 static const struct file_operations port_fops = {
@@ -798,7 +805,9 @@ static const struct memdev {
 #ifdef CONFIG_DEVKMEM
 	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
 #endif
+#ifdef CONFIG_DEVNULL
 	 [3] = { "null", 0666, &null_fops, NULL },
+#endif
 #ifdef CONFIG_DEVPORT
 	 [4] = { "port", 0, &port_fops, NULL },
 #endif
-- 
1.9.3

