Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3JAVmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:42:36 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:47892 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3JAVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:33 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/15] sysfs: add sysfs_bin_read()
Date: Tue,  1 Oct 2013 17:42:06 -0400
Message-Id: <1380663729-18243-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs bin file handling will be merged into the regular file support.
This patch prepares the read path.

Copy fs/sysfs/bin.c::read() to fs/sysfs/file.c and make it use
sysfs_open_file instead of bin_buffer.  The function is identical copy
except for the use of sysfs_open_file.

The new function is added to sysfs_bin_operations.  This isn't used
yet but will eventually replace fs/sysfs/bin.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b36473f..9ba492a 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -139,6 +139,70 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
+/*
+ * Read method for bin files.  As reading a bin file can have side-effects,
+ * the exact offset and bytes specified in read(2) call should be passed to
+ * the read callback making it difficult to use seq_file.  Implement
+ * simplistic custom buffering for bin files.
+ */
+static ssize_t sysfs_bin_read(struct file *file, char __user *userbuf,
+			      size_t bytes, loff_t *off)
+{
+	struct sysfs_open_file *of = sysfs_of(file);
+	struct bin_attribute *battr = of->sd->s_bin_attr.bin_attr;
+	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
+	int size = file_inode(file)->i_size;
+	int count = min_t(size_t, bytes, PAGE_SIZE);
+	loff_t offs = *off;
+	char *buf;
+
+	if (!bytes)
+		return 0;
+
+	if (size) {
+		if (offs > size)
+			return 0;
+		if (offs + count > size)
+			count = size - offs;
+	}
+
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* need of->sd for battr, its parent for kobj */
+	mutex_lock(&of->mutex);
+	if (!sysfs_get_active(of->sd)) {
+		count = -ENODEV;
+		mutex_unlock(&of->mutex);
+		goto out_free;
+	}
+
+	if (battr->read)
+		count = battr->read(file, kobj, battr, buf, offs, count);
+	else
+		count = -EIO;
+
+	sysfs_put_active(of->sd);
+	mutex_unlock(&of->mutex);
+
+	if (count < 0)
+		goto out_free;
+
+	if (copy_to_user(userbuf, buf, count)) {
+		count = -EFAULT;
+		goto out_free;
+	}
+
+	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
+
+	*off = offs + count;
+
+ out_free:
+	kfree(buf);
+	return count;
+}
+
 /**
  * flush_write_buffer - push buffer to kobject
  * @of: open file
@@ -495,6 +559,7 @@ const struct file_operations sysfs_file_operations = {
 };
 
 const struct file_operations sysfs_bin_operations = {
+	.read		= sysfs_bin_read,
 	.write		= sysfs_write_file,
 	.llseek		= generic_file_llseek,
 };
-- 
1.8.3.1

