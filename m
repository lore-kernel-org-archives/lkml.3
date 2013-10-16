Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898Ab3JPOKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:10:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39655 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628Ab3JPOF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:05:57 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V9 18/33] fs: create file_readable() and file_writable() functions
Date: Wed, 16 Oct 2013 09:04:31 -0500
Message-Id: <1381932286-14978-19-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create functions to simplify if file_ops contain either a read
or aio_read op, or likewise write or aio_write. We will be adding
read_iter and write_iter and don't need to be complicating the code
in multiple places.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/mtd/nand/nandsim.c          |  4 ++--
 drivers/usb/gadget/storage_common.c |  4 ++--
 fs/read_write.c                     | 14 +++++++-------
 include/linux/fs.h                  | 10 ++++++++++
 4 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index bdc1d15..414f522 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -575,12 +575,12 @@ static int alloc_device(struct nandsim *ns)
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
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 08a1a32..cd1431d 100644
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
diff --git a/fs/read_write.c b/fs/read_write.c
index e3cd280..f92f74f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -384,7 +384,7 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->read && !file->f_op->aio_read))
+	if (!file_readable(file))
 		return -EINVAL;
 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
 		return -EFAULT;
@@ -433,7 +433,7 @@ ssize_t __kernel_write(struct file *file, const char *buf, size_t count, loff_t
 	const char __user *p;
 	ssize_t ret;
 
-	if (!file->f_op || (!file->f_op->write && !file->f_op->aio_write))
+	if (!file_writable(file))
 		return -EINVAL;
 
 	old_fs = get_fs();
@@ -460,7 +460,7 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->write && !file->f_op->aio_write))
+	if (!file_writable(file))
 		return -EINVAL;
 	if (unlikely(!access_ok(VERIFY_READ, buf, count)))
 		return -EFAULT;
@@ -778,7 +778,7 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 {
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
+	if (!file_readable(file))
 		return -EINVAL;
 
 	return do_readv_writev(READ, file, vec, vlen, pos);
@@ -791,7 +791,7 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 {
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
-	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
+	if (!file_writable(file))
 		return -EINVAL;
 
 	return do_readv_writev(WRITE, file, vec, vlen, pos);
@@ -965,7 +965,7 @@ static size_t compat_readv(struct file *file,
 		goto out;
 
 	ret = -EINVAL;
-	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
+	if (!file_readable(file))
 		goto out;
 
 	ret = compat_do_readv_writev(READ, file, vec, vlen, pos);
@@ -1032,7 +1032,7 @@ static size_t compat_writev(struct file *file,
 		goto out;
 
 	ret = -EINVAL;
-	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
+	if (!file_writable(file))
 		goto out;
 
 	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ab43916..5ffec5e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1650,6 +1650,16 @@ struct file_operations {
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
1.8.4

