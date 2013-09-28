Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3I1Vuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:50:32 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:64089 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3I1Vty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:49:54 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/14] sysfs: rename sysfs_buffer to sysfs_open_file
Date: Sat, 28 Sep 2013 17:49:35 -0400
Message-Id: <1380404984-31858-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs read path will be converted to use seq_file which will handle
buffering making sysfs_buffer a misnomer.  Rename sysfs_buffer to
sysfs_open_file, and sysfs_open_dirent->buffers to ->files.

This path is pure rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c | 127 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 63 insertions(+), 64 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 499cff8..4b55bcf 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -25,14 +25,14 @@
 #include "sysfs.h"
 
 /*
- * There's one sysfs_buffer for each open file and one sysfs_open_dirent
+ * There's one sysfs_open_file for each open file and one sysfs_open_dirent
  * for each sysfs_dirent with one or more open files.
  *
  * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open is
  * protected by sysfs_open_dirent_lock.
  *
- * filp->private_data points to sysfs_buffer which is chained at
- * sysfs_open_dirent->buffers, which is protected by sysfs_open_file_mutex.
+ * filp->private_data points to sysfs_open_file which is chained at
+ * sysfs_open_dirent->files, which is protected by sysfs_open_file_mutex.
  */
 static DEFINE_SPINLOCK(sysfs_open_dirent_lock);
 static DEFINE_MUTEX(sysfs_open_file_mutex);
@@ -41,10 +41,10 @@ struct sysfs_open_dirent {
 	atomic_t		refcnt;
 	atomic_t		event;
 	wait_queue_head_t	poll;
-	struct list_head	buffers; /* goes through sysfs_buffer.list */
+	struct list_head	files; /* goes through sysfs_open_file.list */
 };
 
-struct sysfs_buffer {
+struct sysfs_open_file {
 	size_t			count;
 	char			*page;
 	struct mutex		mutex;
@@ -75,7 +75,7 @@ static const struct sysfs_ops *sysfs_file_ops(struct sysfs_dirent *sd)
  *	This is called only once, on the file's first read unless an error
  *	is returned.
  */
-static int fill_read_buffer(struct dentry *dentry, struct sysfs_buffer *buffer)
+static int fill_read_buffer(struct dentry *dentry, struct sysfs_open_file *of)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
@@ -83,19 +83,19 @@ static int fill_read_buffer(struct dentry *dentry, struct sysfs_buffer *buffer)
 	int ret = 0;
 	ssize_t count;
 
-	if (!buffer->page)
-		buffer->page = (char *) get_zeroed_page(GFP_KERNEL);
-	if (!buffer->page)
+	if (!of->page)
+		of->page = (char *) get_zeroed_page(GFP_KERNEL);
+	if (!of->page)
 		return -ENOMEM;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active(attr_sd))
 		return -ENODEV;
 
-	buffer->event = atomic_read(&attr_sd->s_attr.open->event);
+	of->event = atomic_read(&attr_sd->s_attr.open->event);
 
 	ops = sysfs_file_ops(attr_sd);
-	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
+	count = ops->show(kobj, attr_sd->s_attr.attr, of->page);
 
 	sysfs_put_active(attr_sd);
 
@@ -110,7 +110,7 @@ static int fill_read_buffer(struct dentry *dentry, struct sysfs_buffer *buffer)
 		count = PAGE_SIZE - 1;
 	}
 	if (count >= 0)
-		buffer->count = count;
+		of->count = count;
 	else
 		ret = count;
 	return ret;
@@ -138,63 +138,62 @@ static int fill_read_buffer(struct dentry *dentry, struct sysfs_buffer *buffer)
 static ssize_t
 sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	struct sysfs_buffer *buffer = file->private_data;
+	struct sysfs_open_file *of = file->private_data;
 	ssize_t retval = 0;
 
-	mutex_lock(&buffer->mutex);
+	mutex_lock(&of->mutex);
 	/*
 	 * Fill on zero offset and the first read so that silly things like
 	 * "dd bs=1 skip=N" can work on sysfs files.
 	 */
-	if (*ppos == 0 || !buffer->page) {
-		retval = fill_read_buffer(file->f_path.dentry, buffer);
+	if (*ppos == 0 || !of->page) {
+		retval = fill_read_buffer(file->f_path.dentry, of);
 		if (retval)
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
-		 __func__, count, *ppos, buffer->page);
-	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
-					 buffer->count);
+		 __func__, count, *ppos, of->page);
+	retval = simple_read_from_buffer(buf, count, ppos, of->page, of->count);
 out:
-	mutex_unlock(&buffer->mutex);
+	mutex_unlock(&of->mutex);
 	return retval;
 }
 
 /**
  *	fill_write_buffer - copy buffer from userspace.
- *	@buffer:	data buffer for file.
+ *	@of:		open file struct.
  *	@buf:		data from user.
  *	@count:		number of bytes in @userbuf.
  *
- *	Allocate @buffer->page if it hasn't been already, then
- *	copy the user-supplied buffer into it.
+ *	Allocate @of->page if it hasn't been already, then copy the
+ *	user-supplied buffer into it.
  */
-static int fill_write_buffer(struct sysfs_buffer *buffer,
+static int fill_write_buffer(struct sysfs_open_file *of,
 			     const char __user *buf, size_t count)
 {
 	int error;
 
-	if (!buffer->page)
-		buffer->page = (char *)get_zeroed_page(GFP_KERNEL);
-	if (!buffer->page)
+	if (!of->page)
+		of->page = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!of->page)
 		return -ENOMEM;
 
 	if (count >= PAGE_SIZE)
 		count = PAGE_SIZE - 1;
-	error = copy_from_user(buffer->page, buf, count);
+	error = copy_from_user(of->page, buf, count);
 
 	/*
 	 * If buf is assumed to contain a string, terminate it by \0, so
 	 * e.g. sscanf() can scan the string easily.
 	 */
-	buffer->page[count] = 0;
+	of->page[count] = 0;
 	return error ? -EFAULT : count;
 }
 
 /**
  *	flush_write_buffer - push buffer to kobject.
  *	@dentry:	dentry to the attribute
- *	@buffer:	data buffer for file.
+ *	@of:		open file
  *	@count:		number of bytes
  *
  *	Get the correct pointers for the kobject and the attribute we're
@@ -202,7 +201,7 @@ static int fill_write_buffer(struct sysfs_buffer *buffer,
  *	passing the buffer that we acquired in fill_write_buffer().
  */
 static int flush_write_buffer(struct dentry *dentry,
-			      struct sysfs_buffer *buffer, size_t count)
+			      struct sysfs_open_file *of, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
@@ -214,7 +213,7 @@ static int flush_write_buffer(struct dentry *dentry,
 		return -ENODEV;
 
 	ops = sysfs_file_ops(attr_sd);
-	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
+	rc = ops->store(kobj, attr_sd->s_attr.attr, of->page, count);
 
 	sysfs_put_active(attr_sd);
 
@@ -240,27 +239,26 @@ static int flush_write_buffer(struct dentry *dentry,
 static ssize_t sysfs_write_file(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct sysfs_buffer *buffer = file->private_data;
+	struct sysfs_open_file *of = file->private_data;
 	ssize_t len;
 
-	mutex_lock(&buffer->mutex);
-	len = fill_write_buffer(buffer, buf, count);
+	mutex_lock(&of->mutex);
+	len = fill_write_buffer(of, buf, count);
 	if (len > 0)
-		len = flush_write_buffer(file->f_path.dentry, buffer, len);
+		len = flush_write_buffer(file->f_path.dentry, of, len);
 	if (len > 0)
 		*ppos += len;
-	mutex_unlock(&buffer->mutex);
+	mutex_unlock(&of->mutex);
 	return len;
 }
 
 /**
  *	sysfs_get_open_dirent - get or create sysfs_open_dirent
  *	@sd: target sysfs_dirent
- *	@buffer: sysfs_buffer for this instance of open
+ *	@of: sysfs_open_file for this instance of open
  *
  *	If @sd->s_attr.open exists, increment its reference count;
- *	otherwise, create one.  @buffer is chained to the buffers
- *	list.
+ *	otherwise, create one.  @of is chained to the files list.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
@@ -269,7 +267,7 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *buf,
  *	0 on success, -errno on failure.
  */
 static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
-				 struct sysfs_buffer *buffer)
+				 struct sysfs_open_file *of)
 {
 	struct sysfs_open_dirent *od, *new_od = NULL;
 
@@ -285,7 +283,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 	od = sd->s_attr.open;
 	if (od) {
 		atomic_inc(&od->refcnt);
-		list_add_tail(&buffer->list, &od->buffers);
+		list_add_tail(&of->list, &od->files);
 	}
 
 	spin_unlock_irq(&sysfs_open_dirent_lock);
@@ -304,23 +302,23 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 	atomic_set(&new_od->refcnt, 0);
 	atomic_set(&new_od->event, 1);
 	init_waitqueue_head(&new_od->poll);
-	INIT_LIST_HEAD(&new_od->buffers);
+	INIT_LIST_HEAD(&new_od->files);
 	goto retry;
 }
 
 /**
  *	sysfs_put_open_dirent - put sysfs_open_dirent
  *	@sd: target sysfs_dirent
- *	@buffer: associated sysfs_buffer
+ *	@of: associated sysfs_open_file
  *
- *	Put @sd->s_attr.open and unlink @buffer from the buffers list.
- *	If reference count reaches zero, disassociate and free it.
+ *	Put @sd->s_attr.open and unlink @of from the files list.  If
+ *	reference count reaches zero, disassociate and free it.
  *
  *	LOCKING:
  *	None.
  */
 static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
-				  struct sysfs_buffer *buffer)
+				  struct sysfs_open_file *of)
 {
 	struct sysfs_open_dirent *od = sd->s_attr.open;
 	unsigned long flags;
@@ -328,7 +326,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 	mutex_lock(&sysfs_open_file_mutex);
 	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
-	list_del(&buffer->list);
+	list_del(&of->list);
 	if (atomic_dec_and_test(&od->refcnt))
 		sd->s_attr.open = NULL;
 	else
@@ -344,7 +342,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_buffer *buffer;
+	struct sysfs_open_file *of;
 	const struct sysfs_ops *ops;
 	int error = -EACCES;
 
@@ -377,19 +375,20 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 			goto err_out;
 	}
 
-	/* No error? Great, allocate a buffer for the file, and store it
-	 * it in file->private_data for easy access.
+	/*
+	 * No error? Great, allocate a sysfs_open_file for the file, and
+	 * store it it in file->private_data for easy access.
 	 */
 	error = -ENOMEM;
-	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
-	if (!buffer)
+	of = kzalloc(sizeof(struct sysfs_open_file), GFP_KERNEL);
+	if (!of)
 		goto err_out;
 
-	mutex_init(&buffer->mutex);
-	file->private_data = buffer;
+	mutex_init(&of->mutex);
+	file->private_data = of;
 
 	/* make sure we have open dirent struct */
-	error = sysfs_get_open_dirent(attr_sd, buffer);
+	error = sysfs_get_open_dirent(attr_sd, of);
 	if (error)
 		goto err_free;
 
@@ -398,7 +397,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	return 0;
 
  err_free:
-	kfree(buffer);
+	kfree(of);
  err_out:
 	sysfs_put_active(attr_sd);
 	return error;
@@ -407,13 +406,13 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 static int sysfs_release(struct inode *inode, struct file *filp)
 {
 	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
-	struct sysfs_buffer *buffer = filp->private_data;
+	struct sysfs_open_file *of = filp->private_data;
 
-	sysfs_put_open_dirent(sd, buffer);
+	sysfs_put_open_dirent(sd, of);
 
-	if (buffer->page)
-		free_page((unsigned long)buffer->page);
-	kfree(buffer);
+	if (of->page)
+		free_page((unsigned long)of->page);
+	kfree(of);
 
 	return 0;
 }
@@ -433,7 +432,7 @@ static int sysfs_release(struct inode *inode, struct file *filp)
  */
 static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
-	struct sysfs_buffer *buffer = filp->private_data;
+	struct sysfs_open_file *of = filp->private_data;
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_open_dirent *od = attr_sd->s_attr.open;
 
@@ -445,7 +444,7 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 
 	sysfs_put_active(attr_sd);
 
-	if (buffer->event != atomic_read(&od->event))
+	if (of->event != atomic_read(&od->event))
 		goto trigger;
 
 	return DEFAULT_POLLMASK;
-- 
1.8.3.1

