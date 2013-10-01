Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3JAVoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:44:55 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:65111 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3JAVm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:26 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH 07/15] sysfs: use transient write buffer
Date: Tue,  1 Oct 2013 17:42:01 -0400
Message-Id: <1380663729-18243-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't much to be gained by keeping around kernel buffer while a
file is open especially as the read path planned to be converted to
use seq_file and won't use the buffer.  This patch makes
sysfs_write_file() use per-write transient buffer instead of
sysfs_open_file->page.

This simplifies the write path, enables removing sysfs_open_file->page
once read path is updated and will help merging bin file write path
which already requires the use of a transient buffer due to a locking
order issue.

As the function comments of flush_write_buffer() and
sysfs_write_buffer() are being updated anyway, reformat them so that
they're more conventional.

v2: Use min_t() instead of min() in sysfs_write_file() to avoid build
    warning on arm.  Reported by build test robot.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: kbuild test robot <fengguang.wu@intel.com>
---
 fs/sysfs/file.c | 114 ++++++++++++++++++++++++++------------------------------
 1 file changed, 52 insertions(+), 62 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index af6e909..53cc096 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -162,92 +162,82 @@ out:
 }
 
 /**
- *	fill_write_buffer - copy buffer from userspace.
- *	@of:		open file struct.
- *	@buf:		data from user.
- *	@count:		number of bytes in @userbuf.
+ * flush_write_buffer - push buffer to kobject
+ * @of: open file
+ * @buf: data buffer for file
+ * @count: number of bytes
  *
- *	Allocate @of->page if it hasn't been already, then copy the
- *	user-supplied buffer into it.
+ * Get the correct pointers for the kobject and the attribute we're dealing
+ * with, then call the store() method for it with @buf.
  */
-static int fill_write_buffer(struct sysfs_open_file *of,
-			     const char __user *buf, size_t count)
-{
-	int error;
-
-	if (!of->page)
-		of->page = (char *)get_zeroed_page(GFP_KERNEL);
-	if (!of->page)
-		return -ENOMEM;
-
-	if (count >= PAGE_SIZE)
-		count = PAGE_SIZE - 1;
-	error = copy_from_user(of->page, buf, count);
-
-	/*
-	 * If buf is assumed to contain a string, terminate it by \0, so
-	 * e.g. sscanf() can scan the string easily.
-	 */
-	of->page[count] = 0;
-	return error ? -EFAULT : count;
-}
-
-/**
- *	flush_write_buffer - push buffer to kobject.
- *	@of:		open file
- *	@count:		number of bytes
- *
- *	Get the correct pointers for the kobject and the attribute we're
- *	dealing with, then call the store() method for the attribute,
- *	passing the buffer that we acquired in fill_write_buffer().
- */
-static int flush_write_buffer(struct sysfs_open_file *of, size_t count)
+static int flush_write_buffer(struct sysfs_open_file *of, char *buf,
+			      size_t count)
 {
 	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
 	const struct sysfs_ops *ops;
-	int rc;
+	int rc = 0;
 
-	/* need @of->sd for attr and ops, its parent for kobj */
-	if (!sysfs_get_active(of->sd))
+	/*
+	 * Need @of->sd for attr and ops, its parent for kobj.  @of->mutex
+	 * nests outside active ref and is just to ensure that the ops
+	 * aren't called concurrently for the same open file.
+	 */
+	mutex_lock(&of->mutex);
+	if (!sysfs_get_active(of->sd)) {
+		mutex_unlock(&of->mutex);
 		return -ENODEV;
+	}
 
 	ops = sysfs_file_ops(of->sd);
-	rc = ops->store(kobj, of->sd->s_attr.attr, of->page, count);
+	rc = ops->store(kobj, of->sd->s_attr.attr, buf, count);
 
 	sysfs_put_active(of->sd);
+	mutex_unlock(&of->mutex);
 
 	return rc;
 }
 
 /**
- *	sysfs_write_file - write an attribute.
- *	@file:	file pointer
- *	@buf:	data to write
- *	@count:	number of bytes
- *	@ppos:	starting offset
+ * sysfs_write_file - write an attribute
+ * @file: file pointer
+ * @user_buf: data to write
+ * @count: number of bytes
+ * @ppos: starting offset
  *
- *	Similar to sysfs_read_file(), though working in the opposite direction.
- *	We allocate and fill the data from the user in fill_write_buffer(),
- *	then push it to the kobject in flush_write_buffer().
- *	There is no easy way for us to know if userspace is only doing a partial
- *	write, so we don't support them. We expect the entire buffer to come
- *	on the first write.
- *	Hint: if you're writing a value, first read the file, modify only the
- *	the value you're changing, then write entire buffer back.
+ * Copy data in from userland and pass it to the matching
+ * sysfs_ops->store() by invoking flush_write_buffer().
+ *
+ * There is no easy way for us to know if userspace is only doing a partial
+ * write, so we don't support them. We expect the entire buffer to come on
+ * the first write.  Hint: if you're writing a value, first read the file,
+ * modify only the the value you're changing, then write entire buffer
+ * back.
  */
-static ssize_t sysfs_write_file(struct file *file, const char __user *buf,
+static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
 	struct sysfs_open_file *of = file->private_data;
-	ssize_t len;
+	ssize_t len = min_t(size_t, count, PAGE_SIZE - 1);
+	char *buf;
 
-	mutex_lock(&of->mutex);
-	len = fill_write_buffer(of, buf, count);
-	if (len > 0)
-		len = flush_write_buffer(of, len);
+	if (!len)
+		return 0;
+
+	buf = kmalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, user_buf, len)) {
+		len = -EFAULT;
+		goto out_free;
+	}
+	buf[len] = '\0';	/* guarantee string termination */
+
+	len = flush_write_buffer(of, buf, len);
 	if (len > 0)
 		*ppos += len;
-	mutex_unlock(&of->mutex);
+out_free:
+	kfree(buf);
 	return len;
 }
 
-- 
1.8.3.1

