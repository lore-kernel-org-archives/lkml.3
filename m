Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3JAVno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:43:44 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:65103 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3JAVmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:32 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/15] sysfs: prepare path write for unified regular / bin file handling
Date: Tue,  1 Oct 2013 17:42:05 -0400
Message-Id: <1380663729-18243-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs bin file handling will be merged into the regular file support.
This patch prepares the write path.

bin file write is almost identical to regular file write except that
the write length is capped by the inode size and @off is passed to the
write method.  This patch adds bin file handling to sysfs_write_file()
so that it can handle both regular and bin files.

A new file_operations struct sysfs_bin_operations is added, which
currently only hosts sysfs_write_file() and generic_file_llseek().
This isn't used yet but will eventually replace fs/sysfs/bin.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c  | 40 ++++++++++++++++++++++++++++++++++------
 fs/sysfs/sysfs.h |  1 +
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4921bda..b36473f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -54,6 +54,11 @@ struct sysfs_open_file {
 	struct list_head	list;
 };
 
+static bool sysfs_is_bin(struct sysfs_dirent *sd)
+{
+	return sysfs_type(sd) == SYSFS_KOBJ_BIN_ATTR;
+}
+
 static struct sysfs_open_file *sysfs_of(struct file *file)
 {
 	return ((struct seq_file *)file->private_data)->private;
@@ -138,16 +143,16 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
  * flush_write_buffer - push buffer to kobject
  * @of: open file
  * @buf: data buffer for file
+ * @off: file offset to write to
  * @count: number of bytes
  *
  * Get the correct pointers for the kobject and the attribute we're dealing
  * with, then call the store() method for it with @buf.
  */
-static int flush_write_buffer(struct sysfs_open_file *of, char *buf,
+static int flush_write_buffer(struct sysfs_open_file *of, char *buf, loff_t off,
 			      size_t count)
 {
 	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
-	const struct sysfs_ops *ops;
 	int rc = 0;
 
 	/*
@@ -161,8 +166,18 @@ static int flush_write_buffer(struct sysfs_open_file *of, char *buf,
 		return -ENODEV;
 	}
 
-	ops = sysfs_file_ops(of->sd);
-	rc = ops->store(kobj, of->sd->s_attr.attr, buf, count);
+	if (sysfs_is_bin(of->sd)) {
+		struct bin_attribute *battr = of->sd->s_bin_attr.bin_attr;
+
+		rc = -EIO;
+		if (battr->write)
+			rc = battr->write(of->file, kobj, battr, buf, off,
+					  count);
+	} else {
+		const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
+
+		rc = ops->store(kobj, of->sd->s_attr.attr, buf, count);
+	}
 
 	sysfs_put_active(of->sd);
 	mutex_unlock(&of->mutex);
@@ -190,9 +205,17 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
 	struct sysfs_open_file *of = sysfs_of(file);
-	ssize_t len = min_t(size_t, count, PAGE_SIZE - 1);
+	ssize_t len = min_t(size_t, count, PAGE_SIZE);
 	char *buf;
 
+	if (sysfs_is_bin(of->sd)) {
+		loff_t size = file_inode(file)->i_size;
+
+		if (size <= *ppos)
+			return 0;
+		len = min_t(ssize_t, len, size - *ppos);
+	}
+
 	if (!len)
 		return 0;
 
@@ -206,7 +229,7 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 	}
 	buf[len] = '\0';	/* guarantee string termination */
 
-	len = flush_write_buffer(of, buf, len);
+	len = flush_write_buffer(of, buf, *ppos, len);
 	if (len > 0)
 		*ppos += len;
 out_free:
@@ -471,6 +494,11 @@ const struct file_operations sysfs_file_operations = {
 	.poll		= sysfs_poll,
 };
 
+const struct file_operations sysfs_bin_operations = {
+	.write		= sysfs_write_file,
+	.llseek		= generic_file_llseek,
+};
+
 int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 			   const struct attribute *attr, int type,
 			   umode_t amode, const void *ns)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 4b1d825..f103bac 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -212,6 +212,7 @@ int sysfs_inode_init(void);
  * file.c
  */
 extern const struct file_operations sysfs_file_operations;
+extern const struct file_operations sysfs_bin_operations;
 
 int sysfs_add_file(struct sysfs_dirent *dir_sd,
 		   const struct attribute *attr, int type);
-- 
1.8.3.1

