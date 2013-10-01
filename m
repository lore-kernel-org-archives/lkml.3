Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3JAVoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:44:37 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:45591 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3JAVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:42:28 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/15] sysfs: use seq_file when reading regular files
Date: Tue,  1 Oct 2013 17:42:02 -0400
Message-Id: <1380663729-18243-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380663729-18243-1-git-send-email-tj@kernel.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs read path implements its own buffering scheme between userland
and kernel callbacks, which essentially is a degenerate duplicate of
seq_file.  This patch replaces the custom read buffering
implementation in sysfs with seq_file.

While the amount of code reduction is small, this reduces low level
hairiness and enables future development of a new versatile API based
on seq_file so that sysfs features can be shared with other
subsystems.

As write path was already converted to not use sysfs_open_file->page,
this patch makes ->page and ->count unused and removes them.

Userland behavior remains the same except for some extreme corner
cases - e.g. sysfs will now regenerate the content each time a file is
read after a non-contiguous seek whereas the original code would keep
using the same content.  While this is a userland visible behavior
change, it is extremely unlikely to be noticeable and brings sysfs
behavior closer to that of procfs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay@vrfy.org>
---
 fs/sysfs/file.c | 164 +++++++++++++++++++++++++-------------------------------
 1 file changed, 73 insertions(+), 91 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 53cc096..4921bda 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -21,6 +21,7 @@
 #include <linux/mutex.h>
 #include <linux/limits.h>
 #include <linux/uaccess.h>
+#include <linux/seq_file.h>
 
 #include "sysfs.h"
 
@@ -31,7 +32,8 @@
  * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open is
  * protected by sysfs_open_dirent_lock.
  *
- * filp->private_data points to sysfs_open_file which is chained at
+ * filp->private_data points to seq_file whose ->private points to
+ * sysfs_open_file.  sysfs_open_files are chained at
  * sysfs_open_dirent->files, which is protected by sysfs_open_file_mutex.
  */
 static DEFINE_SPINLOCK(sysfs_open_dirent_lock);
@@ -47,13 +49,16 @@ struct sysfs_open_dirent {
 struct sysfs_open_file {
 	struct sysfs_dirent	*sd;
 	struct file		*file;
-	size_t			count;
-	char			*page;
 	struct mutex		mutex;
 	int			event;
 	struct list_head	list;
 };
 
+static struct sysfs_open_file *sysfs_of(struct file *file)
+{
+	return ((struct seq_file *)file->private_data)->private;
+}
+
 /*
  * Determine ktype->sysfs_ops for the given sysfs_dirent.  This function
  * must be called while holding an active reference.
@@ -66,40 +71,54 @@ static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
 	return kobj->ktype ? kobj->ktype->sysfs_ops : NULL;
 }
 
-/**
- *	fill_read_buffer - allocate and fill buffer from object.
- *	@dentry:	dentry pointer.
- *	@buffer:	data buffer for file.
- *
- *	Allocate @buffer->page, if it hasn't been already, then call the
- *	kobject's show() method to fill the buffer with this attribute's
- *	data.
- *	This is called only once, on the file's first read unless an error
- *	is returned.
+/*
+ * Reads on sysfs are handled through seq_file, which takes care of hairy
+ * details like buffering and seeking.  The following function pipes
+ * sysfs_ops->show() result through seq_file.
  */
-static int fill_read_buffer(struct dentry *dentry, struct sysfs_open_file *of)
+static int sysfs_seq_show(struct seq_file *sf, void *v)
 {
-	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct sysfs_open_file *of = sf->private;
+	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
 	const struct sysfs_ops *ops;
-	int ret = 0;
+	char *buf;
 	ssize_t count;
 
-	if (!of->page)
-		of->page = (char *) get_zeroed_page(GFP_KERNEL);
-	if (!of->page)
-		return -ENOMEM;
+	/* acquire buffer and ensure that it's >= PAGE_SIZE */
+	count = seq_get_buf(sf, &buf);
+	if (count < PAGE_SIZE) {
+		seq_commit(sf, -1);
+		return 0;
+	}
 
-	/* need attr_sd for attr and ops, its parent for kobj */
-	if (!sysfs_get_active(attr_sd))
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
 
-	of->event = atomic_read(&attr_sd->s_attr.open->event);
+	of->event = atomic_read(&of->sd->s_attr.open->event);
 
-	ops = sysfs_file_ops(attr_sd);
-	count = ops->show(kobj, attr_sd->s_attr.attr, of->page);
+	/*
+	 * Lookup @ops and invoke show().  Control may reach here via seq
+	 * file lseek even if @ops->show() isn't implemented.
+	 */
+	ops = sysfs_file_ops(of->sd);
+	if (ops->show)
+		count = ops->show(kobj, of->sd->s_attr.attr, buf);
+	else
+		count = 0;
 
-	sysfs_put_active(attr_sd);
+	sysfs_put_active(of->sd);
+	mutex_unlock(&of->mutex);
+
+	if (count < 0)
+		return count;
 
 	/*
 	 * The code works fine with PAGE_SIZE return but it's likely to
@@ -111,54 +130,8 @@ static int fill_read_buffer(struct dentry *dentry, struct sysfs_open_file *of)
 		/* Try to struggle along */
 		count = PAGE_SIZE - 1;
 	}
-	if (count >= 0)
-		of->count = count;
-	else
-		ret = count;
-	return ret;
-}
-
-/**
- *	sysfs_read_file - read an attribute.
- *	@file:	file pointer.
- *	@buf:	buffer to fill.
- *	@count:	number of bytes to read.
- *	@ppos:	starting offset in file.
- *
- *	Userspace wants to read an attribute file. The attribute descriptor
- *	is in the file's ->d_fsdata. The target object is in the directory's
- *	->d_fsdata.
- *
- *	We call fill_read_buffer() to allocate and fill the buffer from the
- *	object's show() method exactly once (if the read is happening from
- *	the beginning of the file). That should fill the entire buffer with
- *	all the data the object has to offer for that attribute.
- *	We then call flush_read_buffer() to copy the buffer to userspace
- *	in the increments specified.
- */
-
-static ssize_t
-sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
-{
-	struct sysfs_open_file *of = file->private_data;
-	ssize_t retval = 0;
-
-	mutex_lock(&of->mutex);
-	/*
-	 * Fill on zero offset and the first read so that silly things like
-	 * "dd bs=1 skip=N" can work on sysfs files.
-	 */
-	if (*ppos == 0 || !of->page) {
-		retval = fill_read_buffer(file->f_path.dentry, of);
-		if (retval)
-			goto out;
-	}
-	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
-		 __func__, count, *ppos, of->page);
-	retval = simple_read_from_buffer(buf, count, ppos, of->page, of->count);
-out:
-	mutex_unlock(&of->mutex);
-	return retval;
+	seq_commit(sf, count);
+	return 0;
 }
 
 /**
@@ -216,7 +189,7 @@ static int flush_write_buffer(struct sysfs_open_file *of, char *buf,
 static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
-	struct sysfs_open_file *of = file->private_data;
+	struct sysfs_open_file *of = sysfs_of(file);
 	ssize_t len = min_t(size_t, count, PAGE_SIZE - 1);
 	char *buf;
 
@@ -364,10 +337,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 			goto err_out;
 	}
 
-	/*
-	 * No error? Great, allocate a sysfs_open_file for the file, and
-	 * store it it in file->private_data for easy access.
-	 */
+	/* allocate a sysfs_open_file for the file */
 	error = -ENOMEM;
 	of = kzalloc(sizeof(struct sysfs_open_file), GFP_KERNEL);
 	if (!of)
@@ -376,20 +346,34 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	mutex_init(&of->mutex);
 	of->sd = attr_sd;
 	of->file = file;
-	file->private_data = of;
+
+	/*
+	 * Always instantiate seq_file even if read access is not
+	 * implemented or requested.  This unifies private data access and
+	 * most files are readable anyway.
+	 */
+	error = single_open(file, sysfs_seq_show, of);
+	if (error)
+		goto err_free;
+
+	/* seq_file clears PWRITE unconditionally, restore it if WRITE */
+	if (file->f_mode & FMODE_WRITE)
+		file->f_mode |= FMODE_PWRITE;
 
 	/* make sure we have open dirent struct */
 	error = sysfs_get_open_dirent(attr_sd, of);
 	if (error)
-		goto err_free;
+		goto err_close;
 
 	/* open succeeded, put active references */
 	sysfs_put_active(attr_sd);
 	return 0;
 
- err_free:
+err_close:
+	single_release(inode, file);
+err_free:
 	kfree(of);
- err_out:
+err_out:
 	sysfs_put_active(attr_sd);
 	return error;
 }
@@ -397,12 +381,10 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 static int sysfs_release(struct inode *inode, struct file *filp)
 {
 	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
-	struct sysfs_open_file *of = filp->private_data;
+	struct sysfs_open_file *of = sysfs_of(filp);
 
 	sysfs_put_open_dirent(sd, of);
-
-	if (of->page)
-		free_page((unsigned long)of->page);
+	single_release(inode, filp);
 	kfree(of);
 
 	return 0;
@@ -423,7 +405,7 @@ static int sysfs_release(struct inode *inode, struct file *filp)
  */
 static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
-	struct sysfs_open_file *of = filp->private_data;
+	struct sysfs_open_file *of = sysfs_of(filp);
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_open_dirent *od = attr_sd->s_attr.open;
 
@@ -481,9 +463,9 @@ void sysfs_notify(struct kobject *k, const char *dir, const char *attr)
 EXPORT_SYMBOL_GPL(sysfs_notify);
 
 const struct file_operations sysfs_file_operations = {
-	.read		= sysfs_read_file,
+	.read		= seq_read,
 	.write		= sysfs_write_file,
-	.llseek		= generic_file_llseek,
+	.llseek		= seq_lseek,
 	.open		= sysfs_open_file,
 	.release	= sysfs_release,
 	.poll		= sysfs_poll,
-- 
1.8.3.1

