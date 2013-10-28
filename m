Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3J1Qdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:33:44 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:56642 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab3J1Qdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:33:42 -0400
Date: Mon, 28 Oct 2013 12:33:34 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Pavel Machek <pavel@ucw.cz>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH v3 14/34] sysfs, kernfs: prepare read path for kernfs
Message-ID: <20131028163334.GE13548@mtj.dyndns.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
 <1382629780-10006-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382629780-10006-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're in the process of separating out core sysfs functionality into
kernfs which will deal with sysfs_dirents directly.  This patch
rearranges read path so that the kernfs and sysfs parts are separate.

* Regular file read path is refactored such that
  kernfs_seq_start/next/stop/show() handle all the boilerplate work
  including locking and updating event count for poll, while
  sysfs_kf_seq_show() deals with interaction with kobj show method.

* Bin file read path is refactored such that kernfs_file_direct_read()
  handles all the boilerplate work including buffer management and
  locking, while sysfs_kf_bin_read() deals with interaction with
  bin_attribute read method.

kernfs_file_read() is added.  It invokes either the seq_file or direct
read path depending on the file type.  This will eventually allow
using the same file_operations for both file types, which is necessary
to separate out kernfs.

While this patch changes the order of some operations, it shouldn't
change any visible behavior.

v2: Dropped unnecessary zeroing of @count from sysfs_kf_seq_show().
    Add comments explaining single_open() behavior.  Both suggested by
    Pavel.

v3: seq_stop() is called even after seq_start() failed.
    kernfs_seq_start() updated so that it doesn't unlock
    sysfs_open_file->mutex on failure so that kernfs_seq_stop()
    doesn't try to unlock an already unlocked mutex.  Reported by
    Fengguang.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 fs/sysfs/file.c | 191 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 126 insertions(+), 65 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 444615d..dcf9155 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -86,13 +86,13 @@ static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
  * details like buffering and seeking.  The following function pipes
  * sysfs_ops->show() result through seq_file.
  */
-static int sysfs_seq_show(struct seq_file *sf, void *v)
+static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
 {
 	struct sysfs_open_file *of = sf->private;
 	struct kobject *kobj = of->sd->s_parent->priv;
-	const struct sysfs_ops *ops;
-	char *buf;
+	const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
 	ssize_t count;
+	char *buf;
 
 	/* acquire buffer and ensure that it's >= PAGE_SIZE */
 	count = seq_get_buf(sf, &buf);
@@ -102,33 +102,14 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
 	}
 
 	/*
-	 * Need @of->sd for attr and ops, its parent for kobj.  @of->mutex
-	 * nests outside active ref and is just to ensure that the ops
-	 * aren't called concurrently for the same open file.
+	 * Invoke show().  Control may reach here via seq file lseek even
+	 * if @ops->show() isn't implemented.
 	 */
-	mutex_lock(&of->mutex);
-	if (!sysfs_get_active(of->sd)) {
-		mutex_unlock(&of->mutex);
-		return -ENODEV;
-	}
-
-	of->event = atomic_read(&of->sd->s_attr.open->event);
-
-	/*
-	 * Lookup @ops and invoke show().  Control may reach here via seq
-	 * file lseek even if @ops->show() isn't implemented.
-	 */
-	ops = sysfs_file_ops(of->sd);
-	if (ops->show)
+	if (ops->show) {
 		count = ops->show(kobj, of->sd->priv, buf);
-	else
-		count = 0;
-
-	sysfs_put_active(of->sd);
-	mutex_unlock(&of->mutex);
-
-	if (count < 0)
-		return count;
+		if (count < 0)
+			return count;
+	}
 
 	/*
 	 * The code works fine with PAGE_SIZE return but it's likely to
@@ -144,68 +125,146 @@ static int sysfs_seq_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
-/*
- * Read method for bin files.  As reading a bin file can have side-effects,
- * the exact offset and bytes specified in read(2) call should be passed to
- * the read callback making it difficult to use seq_file.  Implement
- * simplistic custom buffering for bin files.
- */
-static ssize_t sysfs_bin_read(struct file *file, char __user *userbuf,
-			      size_t bytes, loff_t *off)
+static ssize_t sysfs_kf_bin_read(struct sysfs_open_file *of, char *buf,
+				 size_t count, loff_t pos)
 {
-	struct sysfs_open_file *of = sysfs_of(file);
 	struct bin_attribute *battr = of->sd->priv;
 	struct kobject *kobj = of->sd->s_parent->priv;
-	loff_t size = file_inode(file)->i_size;
-	int count = min_t(size_t, bytes, PAGE_SIZE);
-	loff_t offs = *off;
-	char *buf;
+	loff_t size = file_inode(of->file)->i_size;
 
-	if (!bytes)
+	if (!count)
 		return 0;
 
 	if (size) {
-		if (offs > size)
+		if (pos > size)
 			return 0;
-		if (offs + count > size)
-			count = size - offs;
+		if (pos + count > size)
+			count = size - pos;
 	}
 
-	buf = kmalloc(count, GFP_KERNEL);
+	if (!battr->read)
+		return -EIO;
+
+	return battr->read(of->file, kobj, battr, buf, pos, count);
+}
+
+static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
+{
+	struct sysfs_open_file *of = sf->private;
+
+	/*
+	 * @of->mutex nests outside active ref and is just to ensure that
+	 * the ops aren't called concurrently for the same open file.
+	 */
+	mutex_lock(&of->mutex);
+	if (!sysfs_get_active(of->sd))
+		return ERR_PTR(-ENODEV);
+
+	/*
+	 * The same behavior and code as single_open().  Returns !NULL if
+	 * pos is at the beginning; otherwise, NULL.
+	 */
+	return NULL + !*ppos;
+}
+
+static void *kernfs_seq_next(struct seq_file *sf, void *v, loff_t *ppos)
+{
+	/*
+	 * The same behavior and code as single_open(), always terminate
+	 * after the initial read.
+	 */
+	++*ppos;
+	return NULL;
+}
+
+static void kernfs_seq_stop(struct seq_file *sf, void *v)
+{
+	struct sysfs_open_file *of = sf->private;
+
+	sysfs_put_active(of->sd);
+	mutex_unlock(&of->mutex);
+}
+
+static int kernfs_seq_show(struct seq_file *sf, void *v)
+{
+	struct sysfs_open_file *of = sf->private;
+
+	of->event = atomic_read(&of->sd->s_attr.open->event);
+
+	return sysfs_kf_seq_show(sf, v);
+}
+
+static const struct seq_operations kernfs_seq_ops = {
+	.start = kernfs_seq_start,
+	.next = kernfs_seq_next,
+	.stop = kernfs_seq_stop,
+	.show = kernfs_seq_show,
+};
+
+/*
+ * As reading a bin file can have side-effects, the exact offset and bytes
+ * specified in read(2) call should be passed to the read callback making
+ * it difficult to use seq_file.  Implement simplistic custom buffering for
+ * bin files.
+ */
+static ssize_t kernfs_file_direct_read(struct sysfs_open_file *of,
+				       char __user *user_buf, size_t count,
+				       loff_t *ppos)
+{
+	ssize_t len = min_t(size_t, count, PAGE_SIZE);
+	char *buf;
+
+	buf = kmalloc(len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	/* need of->sd for battr, its parent for kobj */
+	/*
+	 * @of->mutex nests outside active ref and is just to ensure that
+	 * the ops aren't called concurrently for the same open file.
+	 */
 	mutex_lock(&of->mutex);
 	if (!sysfs_get_active(of->sd)) {
-		count = -ENODEV;
+		len = -ENODEV;
 		mutex_unlock(&of->mutex);
 		goto out_free;
 	}
 
-	if (battr->read)
-		count = battr->read(file, kobj, battr, buf, offs, count);
-	else
-		count = -EIO;
+	len = sysfs_kf_bin_read(of, buf, len, *ppos);
 
 	sysfs_put_active(of->sd);
 	mutex_unlock(&of->mutex);
 
-	if (count < 0)
+	if (len < 0)
 		goto out_free;
 
-	if (copy_to_user(userbuf, buf, count)) {
-		count = -EFAULT;
+	if (copy_to_user(user_buf, buf, len)) {
+		len = -EFAULT;
 		goto out_free;
 	}
 
-	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
-
-	*off = offs + count;
+	*ppos += len;
 
  out_free:
 	kfree(buf);
-	return count;
+	return len;
+}
+
+/**
+ * kernfs_file_read - kernfs vfs read callback
+ * @file: file pointer
+ * @user_buf: data to write
+ * @count: number of bytes
+ * @ppos: starting offset
+ */
+static ssize_t kernfs_file_read(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct sysfs_open_file *of = sysfs_of(file);
+
+	if (sysfs_is_bin(of->sd))
+		return kernfs_file_direct_read(of, user_buf, count, ppos);
+	else
+		return seq_read(file, user_buf, count, ppos);
 }
 
 /**
@@ -660,12 +719,14 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 * and readable regular files are the vast majority anyway.
 	 */
 	if (sysfs_is_bin(attr_sd))
-		error = single_open(file, NULL, of);
+		error = seq_open(file, NULL);
 	else
-		error = single_open(file, sysfs_seq_show, of);
+		error = seq_open(file, &kernfs_seq_ops);
 	if (error)
 		goto err_free;
 
+	((struct seq_file *)file->private_data)->private = of;
+
 	/* seq_file clears PWRITE unconditionally, restore it if WRITE */
 	if (file->f_mode & FMODE_WRITE)
 		file->f_mode |= FMODE_PWRITE;
@@ -680,7 +741,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	return 0;
 
 err_close:
-	single_release(inode, file);
+	seq_release(inode, file);
 err_free:
 	kfree(of);
 err_out:
@@ -694,7 +755,7 @@ static int sysfs_release(struct inode *inode, struct file *filp)
 	struct sysfs_open_file *of = sysfs_of(filp);
 
 	sysfs_put_open_dirent(sd, of);
-	single_release(inode, filp);
+	seq_release(inode, filp);
 	kfree(of);
 
 	return 0;
@@ -799,7 +860,7 @@ void sysfs_notify(struct kobject *k, const char *dir, const char *attr)
 EXPORT_SYMBOL_GPL(sysfs_notify);
 
 const struct file_operations sysfs_file_operations = {
-	.read		= seq_read,
+	.read		= kernfs_file_read,
 	.write		= sysfs_write_file,
 	.llseek		= seq_lseek,
 	.open		= sysfs_open_file,
@@ -808,7 +869,7 @@ const struct file_operations sysfs_file_operations = {
 };
 
 const struct file_operations sysfs_bin_operations = {
-	.read		= sysfs_bin_read,
+	.read		= kernfs_file_read,
 	.write		= sysfs_write_file,
 	.llseek		= generic_file_llseek,
 	.mmap		= sysfs_bin_mmap,
-- 
1.8.3.1

