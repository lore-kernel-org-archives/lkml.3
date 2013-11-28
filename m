Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751Ab3K1UDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:03:46 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:43186 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3K1Ty7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:54:59 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/34] sysfs, kernfs: prepare write path for kernfs
Date: Thu, 28 Nov 2013 14:54:17 -0500
Message-Id: <1385668487-10181-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're in the process of separating out core sysfs functionality into
kernfs which will deal with sysfs_dirents directly.  This patch
rearranges write path so that the kernfs and sysfs parts are separate.

kernfs_file_write() handles all boilerplate work including buffer
management and locking and invokes sysfs_kf_write() or
sysfs_kf_bin_write() depending on the file type which deals with the
interaction with kobj store or bin_attribute write method.

While this patch changes the order of some operations, it shouldn't
change any visible behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 103 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 50 insertions(+), 53 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b695b8b..2f849e8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -267,61 +267,50 @@ static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
 		return seq_read(file, user_buf, count, ppos);
 }
 
-/**
- * flush_write_buffer - push buffer to kobject
- * @of: open file
- * @buf: data buffer for file
- * @off: file offset to write to
- * @count: number of bytes
- *
- * Get the correct pointers for the kobject and the attribute we're dealing
- * with, then call the store() method for it with @buf.
- */
-static int flush_write_buffer(struct sysfs_open_file *of, char *buf, loff_t off,
-			      size_t count)
+/* kernfs write callback for regular sysfs files */
+static ssize_t sysfs_kf_write(struct sysfs_open_file *of, char *buf,
+			      size_t count, loff_t pos)
 {
+	const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
 	struct kobject *kobj = of->sd->s_parent->priv;
-	int rc = 0;
 
-	/*
-	 * Need @of->sd for attr and ops, its parent for kobj.  @of->mutex
-	 * nests outside active ref and is just to ensure that the ops
-	 * aren't called concurrently for the same open file.
-	 */
-	mutex_lock(&of->mutex);
-	if (!sysfs_get_active(of->sd)) {
-		mutex_unlock(&of->mutex);
-		return -ENODEV;
-	}
+	if (!count)
+		return 0;
 
-	if (sysfs_is_bin(of->sd)) {
-		struct bin_attribute *battr = of->sd->priv;
+	return ops->store(kobj, of->sd->priv, buf, count);
+}
 
-		rc = -EIO;
-		if (battr->write)
-			rc = battr->write(of->file, kobj, battr, buf, off,
-					  count);
-	} else {
-		const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
+/* kernfs write callback for bin sysfs files */
+static ssize_t sysfs_kf_bin_write(struct sysfs_open_file *of, char *buf,
+				  size_t count, loff_t pos)
+{
+	struct bin_attribute *battr = of->sd->priv;
+	struct kobject *kobj = of->sd->s_parent->priv;
+	loff_t size = file_inode(of->file)->i_size;
 
-		rc = ops->store(kobj, of->sd->priv, buf, count);
+	if (size) {
+		if (size <= pos)
+			return 0;
+		count = min_t(ssize_t, count, size - pos);
 	}
+	if (!count)
+		return 0;
 
-	sysfs_put_active(of->sd);
-	mutex_unlock(&of->mutex);
+	if (!battr->write)
+		return -EIO;
 
-	return rc;
+	return battr->write(of->file, kobj, battr, buf, pos, count);
 }
 
 /**
- * sysfs_write_file - write an attribute
+ * kernfs_file_write - kernfs vfs write callback
  * @file: file pointer
  * @user_buf: data to write
  * @count: number of bytes
  * @ppos: starting offset
  *
- * Copy data in from userland and pass it to the matching
- * sysfs_ops->store() by invoking flush_write_buffer().
+ * Copy data in from userland and pass it to the matching kernfs write
+ * operation.
  *
  * There is no easy way for us to know if userspace is only doing a partial
  * write, so we don't support them. We expect the entire buffer to come on
@@ -329,23 +318,13 @@ static int flush_write_buffer(struct sysfs_open_file *of, char *buf, loff_t off,
  * modify only the the value you're changing, then write entire buffer
  * back.
  */
-static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
-				size_t count, loff_t *ppos)
+static ssize_t kernfs_file_write(struct file *file, const char __user *user_buf,
+				 size_t count, loff_t *ppos)
 {
 	struct sysfs_open_file *of = sysfs_of(file);
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
-	loff_t size = file_inode(file)->i_size;
 	char *buf;
 
-	if (sysfs_is_bin(of->sd) && size) {
-		if (size <= *ppos)
-			return 0;
-		len = min_t(ssize_t, len, size - *ppos);
-	}
-
-	if (!len)
-		return 0;
-
 	buf = kmalloc(len + 1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -356,7 +335,25 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 	}
 	buf[len] = '\0';	/* guarantee string termination */
 
-	len = flush_write_buffer(of, buf, *ppos, len);
+	/*
+	 * @of->mutex nests outside active ref and is just to ensure that
+	 * the ops aren't called concurrently for the same open file.
+	 */
+	mutex_lock(&of->mutex);
+	if (!sysfs_get_active(of->sd)) {
+		mutex_unlock(&of->mutex);
+		len = -ENODEV;
+		goto out_free;
+	}
+
+	if (sysfs_is_bin(of->sd))
+		len = sysfs_kf_bin_write(of, buf, len, *ppos);
+	else
+		len = sysfs_kf_write(of, buf, len, *ppos);
+
+	sysfs_put_active(of->sd);
+	mutex_unlock(&of->mutex);
+
 	if (len > 0)
 		*ppos += len;
 out_free:
@@ -878,7 +875,7 @@ EXPORT_SYMBOL_GPL(sysfs_notify);
 
 const struct file_operations sysfs_file_operations = {
 	.read		= kernfs_file_read,
-	.write		= sysfs_write_file,
+	.write		= kernfs_file_write,
 	.llseek		= generic_file_llseek,
 	.open		= sysfs_open_file,
 	.release	= sysfs_release,
@@ -887,7 +884,7 @@ const struct file_operations sysfs_file_operations = {
 
 const struct file_operations sysfs_bin_operations = {
 	.read		= kernfs_file_read,
-	.write		= sysfs_write_file,
+	.write		= kernfs_file_write,
 	.llseek		= generic_file_llseek,
 	.mmap		= sysfs_bin_mmap,
 	.open		= sysfs_open_file,
-- 
1.8.4.2

