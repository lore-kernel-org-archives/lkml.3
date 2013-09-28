Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3I1Vu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:50:57 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:48297 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab3I1VuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:50:02 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/14] sysfs: prepare read path for unified regular / bin file handling
Date: Sat, 28 Sep 2013 17:49:41 -0400
Message-Id: <1380404984-31858-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs bin file handling will be merged into the regular file support.
This patch prepares the read path.

This is a bit tricky as read support is quite different between
regular and bin files.  bin file supports arbitrarily large file size
and passes the read offset and size directly to the callback as long
as the size is <= PAGE_SIZE.  While it's doable to preserve the offset
and size parameters from userland and pass them to
bin_attribute->read() callback, none of the current users seems to
depend on the behavior and it's a lot simpler and more efficient to
implement pagniated behavior.  After all, it is an extremely bad idea
to make reads of sysfs files to have side-effects.

sysfs_bin_start/next/stop() are implemented so that seq_file iterator
pointer is 1-based page index and sysfs_seq_show() is updated to
transfer data from bin_attribute->read() to seq_file buffer
page-by-page.  A comment clarifying that ->read() must not have
side-effects is added to bin_attribute definition.

This is a preparation and the new bin file path isn't used yet.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay@vrfy.org>
---
 fs/sysfs/file.c       | 96 +++++++++++++++++++++++++++++++++++++++++++--------
 include/linux/sysfs.h |  7 ++++
 2 files changed, 89 insertions(+), 14 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 5380009..46f7d59 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -52,6 +52,8 @@ struct sysfs_open_file {
 	struct mutex		mutex;
 	int			event;
 	struct list_head	list;
+
+	void			*private_data;
 };
 
 static bool sysfs_is_bin(struct sysfs_dirent *sd)
@@ -112,7 +114,6 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
 	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
-	const struct sysfs_ops *ops;
 	char *buf;
 	ssize_t count;
 
@@ -136,9 +137,48 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
 
 	of->event = atomic_read(&of->sd->s_attr.open->event);
 
-	/* lookup @ops and invoke show() */
-	ops = sysfs_file_ops(of->sd);
-	count = ops->show(kobj, of->sd->s_attr.attr, buf);
+	/* lookup ops and invoke read/show() */
+	if (sysfs_is_bin(of->sd)) {
+		struct bin_attribute *battr = of->sd->s_bin_attr.bin_attr;
+		size_t idx = (unsigned long)v - 1;
+		loff_t off = idx << PAGE_SHIFT;
+		size_t size = file_inode(of->file)->i_size;
+
+		if (size)
+			size = min_t(size_t, size - off, PAGE_SIZE);
+		else
+			size = PAGE_SIZE;
+
+		/* @battr may be implementing only ->mmap() */
+		count = -EIO;
+		if (battr->read) {
+			count = battr->read(of->file, kobj, battr, buf, off,
+					    size);
+			/*
+			 * If read() returned zero, it is the end of the
+			 * file.  Record it so that ->next() terminates on
+			 * the next invocation.
+			 */
+			if (!count)
+				of->private_data = (void *)(unsigned long)idx;
+		}
+	} else {
+		const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
+
+		count = ops->show(kobj, of->sd->s_attr.attr, buf);
+
+		/*
+		 * The code works fine with PAGE_SIZE return but it's
+		 * likely to indicate truncated result or overflow in
+		 * normal use cases.
+		 */
+		if (unlikely(count >= (ssize_t)PAGE_SIZE)) {
+			print_symbol("fill_read_buffer: %s returned bad count\n",
+				     (unsigned long)ops->show);
+			/* Try to struggle along */
+			count = PAGE_SIZE - 1;
+		}
+	}
 
 	sysfs_put_active(of->sd);
 	mutex_unlock(&of->mutex);
@@ -146,20 +186,48 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
 	if (count < 0)
 		return count;
 
-	/*
-	 * The code works fine with PAGE_SIZE return but it's likely to
-	 * indicate truncated result or overflow in normal use cases.
-	 */
-	if (count >= (ssize_t)PAGE_SIZE) {
-		print_symbol("fill_read_buffer: %s returned bad count\n",
-			(unsigned long)ops->show);
-		/* Try to struggle along */
-		count = PAGE_SIZE - 1;
-	}
 	seq_commit(sf, count);
 	return 0;
 }
 
+static void *sysfs_bin_seq_start(struct seq_file *sf, loff_t *pidx)
+{
+	struct sysfs_open_file *of = sf->private;
+	loff_t size = file_inode(of->file)->i_size;
+	size_t nr_pages = DIV_ROUND_UP(size, PAGE_SIZE);
+
+	/* record number of pages in private_data */
+	of->private_data = (void *)(unsigned long)nr_pages;
+
+	if (nr_pages && *pidx >= nr_pages)
+		return NULL;
+
+	/* 1 based page index as NULL is term condition */
+	return (void *)(unsigned long)(1 + *pidx);
+}
+
+static void *sysfs_bin_seq_next(struct seq_file *sf, void *v, loff_t *pidx)
+{
+	struct sysfs_open_file *of = sf->private;
+	size_t nr_pages = (unsigned long)of->private_data;
+
+	if (nr_pages && *pidx >= nr_pages)
+		return NULL;
+
+	return (void *)(unsigned long)(1 + ++(*pidx));
+}
+
+static void sysfs_bin_seq_stop(struct seq_file *sf, void *v)
+{
+}
+
+static struct seq_operations sysfs_bin_seq_ops = {
+	.start		= sysfs_bin_seq_start,
+	.next		= sysfs_bin_seq_next,
+	.stop		= sysfs_bin_seq_stop,
+	.show		= sysfs_seq_show,
+};
+
 /**
  * flush_write_buffer - push buffer to kobject
  * @of: open file
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 6695040..f99a4c2 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -120,6 +120,13 @@ struct bin_attribute {
 	struct attribute	attr;
 	size_t			size;
 	void			*private;
+
+	/*
+	 * Reads are buffered by seq_file and offset and length passed to
+	 * ->read() may not match the parameters specified in read(2).
+	 * ->read() may also be invoked while seeking.  As such, ->read()
+	 * must not have side-effects.
+	 */
 	ssize_t (*read)(struct file *, struct kobject *, struct bin_attribute *,
 			char *, loff_t, size_t);
 	ssize_t (*write)(struct file *, struct kobject *, struct bin_attribute *,
-- 
1.8.3.1

