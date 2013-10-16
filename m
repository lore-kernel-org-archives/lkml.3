Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740Ab3JPOGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:06:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39694 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934655Ab3JPOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:06:00 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org
Subject: [PATCH V9 19/33] fs: use read_iter and write_iter rather than aio_read and aio_write
Date: Wed, 16 Oct 2013 09:04:32 -0500
Message-Id: <1381932286-14978-20-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File systems implementing read_iter & write_iter should not be required
to keep aio_read and aio_write as well. The vfs should always call
read/write_iter if they exist. This will make it easier to remove the
aio_read/write operation in the future.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-aio@kvack.org
---
 fs/aio.c           |  4 ++--
 fs/bad_inode.c     | 14 ++++++++++++
 fs/internal.h      |  4 ++++
 fs/read_write.c    | 64 ++++++++++++++++++++++++++++++++++++++++++++++++------
 include/linux/fs.h |  6 +++--
 5 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index b1d257a..a563070 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1262,14 +1262,14 @@ static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
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
index 7c93953..38651e5 100644
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
 static int bad_file_readdir(struct file *file, struct dir_context *ctx)
 {
 	return -EIO;
@@ -151,7 +163,9 @@ static const struct file_operations bad_file_ops =
 	.read		= bad_file_read,
 	.write		= bad_file_write,
 	.aio_read	= bad_file_aio_read,
+	.read_iter	= bad_file_read_iter,
 	.aio_write	= bad_file_aio_write,
+	.write_iter	= bad_file_write_iter,
 	.iterate	= bad_file_readdir,
 	.poll		= bad_file_poll,
 	.unlocked_ioctl	= bad_file_unlocked_ioctl,
diff --git a/fs/internal.h b/fs/internal.h
index 513e0d8..6964003 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -140,6 +140,10 @@ extern long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan,
  */
 extern ssize_t __kernel_write(struct file *, const char *, size_t, loff_t *);
 extern int rw_verify_area(int, struct file *, const loff_t *, size_t);
+extern ssize_t do_aio_read(struct kiocb *kiocb, const struct iovec *iov,
+			   unsigned long nr_segs, loff_t pos);
+extern ssize_t do_aio_write(struct kiocb *kiocb, const struct iovec *iov,
+			    unsigned long nr_segs, loff_t pos);
 
 /*
  * splice.c
diff --git a/fs/read_write.c b/fs/read_write.c
index f92f74f..296b571 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -29,7 +29,7 @@ typedef ssize_t (*iov_fn_t)(struct kiocb *, const struct iovec *,
 const struct file_operations generic_ro_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.mmap		= generic_file_readonly_mmap,
 	.splice_read	= generic_file_splice_read,
 };
@@ -359,6 +359,29 @@ int rw_verify_area(int read_write, struct file *file, const loff_t *ppos, size_t
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
@@ -369,7 +392,7 @@ ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *pp
 	kiocb.ki_pos = *ppos;
 	kiocb.ki_nbytes = len;
 
-	ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
+	ret = do_aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
 	if (-EIOCBQUEUED == ret)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
@@ -408,6 +431,29 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 
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
@@ -418,7 +464,7 @@ ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, lof
 	kiocb.ki_pos = *ppos;
 	kiocb.ki_nbytes = len;
 
-	ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
+	ret = do_aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
 	if (-EIOCBQUEUED == ret)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
@@ -745,10 +791,12 @@ static ssize_t do_readv_writev(int type, struct file *file,
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
 		file_start_write(file);
 	}
 
@@ -927,10 +975,12 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
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
 		file_start_write(file);
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5ffec5e..747755e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1652,12 +1652,14 @@ struct file_operations {
 
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
1.8.4

