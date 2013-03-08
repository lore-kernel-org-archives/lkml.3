Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab3CHW6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:58:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30407 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab3CHWwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:46 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH V7 -next 19/33] fs: use read_iter and write_iter rather than aio_read and aio_write
Date: Fri,  8 Mar 2013 16:52:14 -0600
Message-Id: <1362783148-22736-20-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File systems implementing read_iter & write_iter should not be required
to keep aio_read and aio_write as well. The vfs should always call
read/write_iter if they exist. This will make it easier to remove the
aio_read/write operation in the future.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/aio.c           |  6 ++++--
 fs/bad_inode.c     | 14 +++++++++++++
 fs/compat.c        |  6 ++++--
 fs/read_write.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/read_write.h    |  4 ++++
 include/linux/fs.h |  6 ++++--
 6 files changed, 83 insertions(+), 11 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 51d3afa..0d52d07 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -42,6 +42,8 @@
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
 
+#include "read_write.h"
+
 #define AIO_RING_MAGIC			0xa10a10a1
 #define AIO_RING_COMPAT_FEATURES	1
 #define AIO_RING_INCOMPAT_FEATURES	0
@@ -1204,14 +1206,14 @@ static ssize_t aio_run_iocb(struct kiocb *req, bool compat)
 	case IOCB_CMD_PREADV:
 		mode	= FMODE_READ;
 		rw	= READ;
-		rw_op	= file->f_op->aio_read;
+		rw_op	= do_aio_read;
 		goto rw_common;
 
 	case IOCB_CMD_PWRITE:
 	case IOCB_CMD_PWRITEV:
 		mode	= FMODE_WRITE;
 		rw	= WRITE;
-		rw_op	= file->f_op->aio_write;
+		rw_op	= do_aio_write;
 		goto rw_common;
 rw_common:
 		if (unlikely(!(file->f_mode & mode)))
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 922ad46..988c04a 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -39,12 +39,24 @@ static ssize_t bad_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	return -EIO;
 }
 
+static ssize_t bad_file_read_iter(struct kiocb *iocb, struct iov_iter *iter,
+			loff_t pos)
+{
+	return -EIO;
+}
+
 static ssize_t bad_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			unsigned long nr_segs, loff_t pos)
 {
 	return -EIO;
 }
 
+static ssize_t bad_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+			loff_t pos)
+{
+	return -EIO;
+}
+
 static int bad_file_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	return -EIO;
@@ -151,7 +163,9 @@ static const struct file_operations bad_file_ops =
 	.read		= bad_file_read,
 	.write		= bad_file_write,
 	.aio_read	= bad_file_aio_read,
+	.read_iter	= bad_file_read_iter,
 	.aio_write	= bad_file_aio_write,
+	.write_iter	= bad_file_write_iter,
 	.readdir	= bad_file_readdir,
 	.poll		= bad_file_poll,
 	.unlocked_ioctl	= bad_file_unlocked_ioctl,
diff --git a/fs/compat.c b/fs/compat.c
index b8a1f27..80daf28 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1098,10 +1098,12 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 	fnv = NULL;
 	if (type == READ) {
 		fn = file->f_op->read;
-		fnv = file->f_op->aio_read;
+		if (file->f_op->aio_read || file->f_op->read_iter)
+			fnv = do_aio_read;
 	} else {
 		fn = (io_fn_t)file->f_op->write;
-		fnv = file->f_op->aio_write;
+		if (file->f_op->aio_write || file->f_op->write_iter)
+			fnv = do_aio_write;
 	}
 
 	if (fnv)
diff --git a/fs/read_write.c b/fs/read_write.c
index 9d645fe..77b4b0a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -25,7 +25,7 @@
 const struct file_operations generic_ro_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.mmap		= generic_file_readonly_mmap,
 	.splice_read	= generic_file_splice_read,
 };
@@ -326,6 +326,29 @@ int rw_verify_area(int read_write, struct file *file, loff_t *ppos, size_t count
 	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;
 }
 
+ssize_t do_aio_read(struct kiocb *kiocb, const struct iovec *iov,
+		    unsigned long nr_segs, loff_t pos)
+{
+	struct file *file = kiocb->ki_filp;
+
+	if (file->f_op->read_iter) {
+		size_t count;
+		struct iov_iter iter;
+		int ret;
+
+		count = 0;
+		ret = generic_segment_checks(iov, &nr_segs, &count,
+					     VERIFY_WRITE);
+		if (ret)
+			return ret;
+
+		iov_iter_init(&iter, iov, nr_segs, count, 0);
+		return file->f_op->read_iter(kiocb, &iter, pos);
+	}
+
+	return file->f_op->aio_read(kiocb, iov, nr_segs, pos);
+}
+
 ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = buf, .iov_len = len };
@@ -337,7 +360,7 @@ ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *pp
 	kiocb.ki_left = len;
 	kiocb.ki_nbytes = len;
 
-	ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
+	ret = do_aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
 	if (-EIOCBQUEUED == ret)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
@@ -376,6 +399,29 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 
 EXPORT_SYMBOL(vfs_read);
 
+ssize_t do_aio_write(struct kiocb *kiocb, const struct iovec *iov,
+		     unsigned long nr_segs, loff_t pos)
+{
+	struct file *file = kiocb->ki_filp;
+
+	if (file->f_op->write_iter) {
+		size_t count;
+		struct iov_iter iter;
+		int ret;
+
+		count = 0;
+		ret = generic_segment_checks(iov, &nr_segs, &count,
+					     VERIFY_READ);
+		if (ret)
+			return ret;
+
+		iov_iter_init(&iter, iov, nr_segs, count, 0);
+		return file->f_op->write_iter(kiocb, &iter, pos);
+	}
+
+	return file->f_op->aio_write(kiocb, iov, nr_segs, pos);
+}
+
 ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = len };
@@ -387,7 +433,7 @@ ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, lof
 	kiocb.ki_left = len;
 	kiocb.ki_nbytes = len;
 
-	ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
+	ret = do_aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
 	if (-EIOCBQUEUED == ret)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
@@ -684,10 +730,12 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	fnv = NULL;
 	if (type == READ) {
 		fn = file->f_op->read;
-		fnv = file->f_op->aio_read;
+		if (file->f_op->aio_read || file->f_op->read_iter)
+			fnv = do_aio_read;
 	} else {
 		fn = (io_fn_t)file->f_op->write;
-		fnv = file->f_op->aio_write;
+		if (file->f_op->aio_write || file->f_op->write_iter)
+			fnv = do_aio_write;
 	}
 
 	if (fnv)
diff --git a/fs/read_write.h b/fs/read_write.h
index d07b954..7501d80 100644
--- a/fs/read_write.h
+++ b/fs/read_write.h
@@ -8,6 +8,10 @@ typedef ssize_t (*io_fn_t)(struct file *, char __user *, size_t, loff_t *);
 typedef ssize_t (*iov_fn_t)(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t);
 
+ssize_t do_aio_read(struct kiocb *kiocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos);
+ssize_t do_aio_write(struct kiocb *kiocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos);
 ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn);
 ssize_t do_loop_readv_writev(struct file *filp, struct iovec *iov,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0fd242..5efb5f7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1653,12 +1653,14 @@ struct file_operations {
 
 static inline int file_readable(struct file *filp)
 {
-	return filp && (filp->f_op->read || filp->f_op->aio_read);
+	return filp && (filp->f_op->read || filp->f_op->aio_read ||
+			filp->f_op->read_iter);
 }
 
 static inline int file_writable(struct file *filp)
 {
-	return filp && (filp->f_op->write || filp->f_op->aio_write);
+	return filp && (filp->f_op->write || filp->f_op->aio_write ||
+			filp->f_op->write_iter);
 }
 
 struct inode_operations {
-- 
1.8.1.5

