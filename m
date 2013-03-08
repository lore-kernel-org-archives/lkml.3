Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878Ab3CHW6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:58:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36036 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab3CHWwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:46 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V7 -next 18/33] fs: create file_readable() and file_writable() functions
Date: Fri,  8 Mar 2013 16:52:13 -0600
Message-Id: <1362783148-22736-19-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create functions to simplify if file_ops contain either a read
or aio_read op, or likewise write or aio_write. We will be adding
read_iter and write_iter and don't need to be complicating the code
in multiple places.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 drivers/mtd/nand/nandsim.c           |  4 ++--
 drivers/staging/ccg/storage_common.c |  4 ++--
 drivers/usb/gadget/storage_common.c  |  4 ++--
 fs/compat.c                          |  4 ++--
 fs/read_write.c                      |  8 ++++----
 include/linux/fs.h                   | 10 ++++++++++
 6 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index cb38f3d..6a44ba6 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -576,12 +576,12 @@ static int alloc_device(struct nandsim *ns)
 		cfile = filp_open(cache_file, O_CREAT | O_RDWR | O_LARGEFILE, 0600);
 		if (IS_ERR(cfile))
 			return PTR_ERR(cfile);
-		if (!cfile->f_op || (!cfile->f_op->read && !cfile->f_op->aio_read)) {
+		if (!file_readable(cfile)) {
 			NS_ERR("alloc_device: cache file not readable\n");
 			err = -EINVAL;
 			goto err_close;
 		}
-		if (!cfile->f_op->write && !cfile->f_op->aio_write) {
+		if (!file_writable(cfile)) {
 			NS_ERR("alloc_device: cache file not writeable\n");
 			err = -EINVAL;
 			goto err_close;
diff --git a/drivers/staging/ccg/storage_common.c b/drivers/staging/ccg/storage_common.c
index abb01ac..135ad3c 100644
--- a/drivers/staging/ccg/storage_common.c
+++ b/drivers/staging/ccg/storage_common.c
@@ -666,11 +666,11 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	 * If we can't read the file, it's no good.
 	 * If we can't write the file, use it read-only.
 	 */
-	if (!(filp->f_op->read || filp->f_op->aio_read)) {
+	if (!file_readable(filp)) {
 		LINFO(curlun, "file not readable: %s\n", filename);
 		goto out;
 	}
-	if (!(filp->f_op->write || filp->f_op->aio_write))
+	if (!file_writable(filp))
 		ro = 1;
 
 	size = i_size_read(inode->i_mapping->host);
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index dbce3a9..a801a00 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -450,11 +450,11 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	 * If we can't read the file, it's no good.
 	 * If we can't write the file, use it read-only.
 	 */
-	if (!(filp->f_op->read || filp->f_op->aio_read)) {
+	if (!file_readable(filp)) {
 		LINFO(curlun, "file not readable: %s\n", filename);
 		goto out;
 	}
-	if (!(filp->f_op->write || filp->f_op->aio_write))
+	if (!file_writable(filp))
 		ro = 1;
 
 	size = i_size_read(inode->i_mapping->host);
diff --git a/fs/compat.c b/fs/compat.c
index 2825322..b8a1f27 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1132,7 +1132,7 @@ static size_t compat_readv(struct file *file,
 		goto out;
 
 	ret = -EINVAL;
-	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
+	if (!file_readable(file))
 		goto out;
 
 	ret = compat_do_readv_writev(READ, file, vec, vlen, pos);
@@ -1198,7 +1198,7 @@ static size_t compat_writev(struct file *file,
 		goto out;
 
 	ret = -EINVAL;
-	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
+	if (!file_writable(file))
 		goto out;
 
 	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
diff --git a/fs/read_write.c b/fs/read_write.c
index 47417a0..9d645fe 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -352,7 +352,7 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->read && !file->f_op->aio_read))
+	if (!file_readable(file))
 		return -EINVAL;
 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
 		return -EFAULT;
@@ -402,7 +402,7 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->write && !file->f_op->aio_write))
+	if (!file_writable(file))
 		return -EINVAL;
 	if (unlikely(!access_ok(VERIFY_READ, buf, count)))
 		return -EFAULT;
@@ -713,7 +713,7 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 {
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
+	if (!file_readable(file))
 		return -EINVAL;
 
 	return do_readv_writev(READ, file, vec, vlen, pos);
@@ -726,7 +726,7 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 {
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
+	if (!file_writable(file))
 		return -EINVAL;
 
 	return do_readv_writev(WRITE, file, vec, vlen, pos);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6db6ab5..e0fd242 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1651,6 +1651,16 @@ struct file_operations {
 	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
+static inline int file_readable(struct file *filp)
+{
+	return filp && (filp->f_op->read || filp->f_op->aio_read);
+}
+
+static inline int file_writable(struct file *filp)
+{
+	return filp && (filp->f_op->write || filp->f_op->aio_write);
+}
+
 struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
-- 
1.8.1.5

