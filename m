Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab3CHWw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:52:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36106 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431Ab3CHWw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:56 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Asias He <asias@redhat.com>, Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V7 -next 26/33] block_dev: add support for read_iter, write_iter
Date: Fri,  8 Mar 2013 16:52:21 -0600
Message-Id: <1362783148-22736-27-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Asias He <asias@redhat.com>

Signed-off-by: Asias He <asias@redhat.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 drivers/char/raw.c |  4 ++--
 fs/block_dev.c     | 19 +++++++++----------
 include/linux/fs.h |  4 ++--
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index f3223aa..db5fa4e 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -285,9 +285,9 @@ static long raw_ctl_compat_ioctl(struct file *file, unsigned int cmd,
 
 static const struct file_operations raw_fops = {
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= blkdev_aio_write,
+	.write_iter	= blkdev_write_iter,
 	.fsync		= blkdev_fsync,
 	.open		= raw_open,
 	.release	= raw_release,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0d71c44..44edaf7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1523,8 +1523,7 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
  * Does not take i_mutex for the write and thus is not for general purpose
  * use.
  */
-ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
-			 unsigned long nr_segs, loff_t pos)
+ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
 	struct blk_plug plug;
@@ -1533,7 +1532,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	BUG_ON(iocb->ki_pos != pos);
 
 	blk_start_plug(&plug);
-	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
+	ret = __generic_file_write_iter(iocb, iter, &iocb->ki_pos);
 	if (ret > 0 || ret == -EIOCBQUEUED) {
 		ssize_t err;
 
@@ -1544,10 +1543,10 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	blk_finish_plug(&plug);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(blkdev_aio_write);
+EXPORT_SYMBOL_GPL(blkdev_write_iter);
 
-static ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
-			 unsigned long nr_segs, loff_t pos)
+static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *iter,
+			 loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *bd_inode = file->f_mapping->host;
@@ -1558,8 +1557,8 @@ static ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
 
 	size -= pos;
 	if (size < INT_MAX)
-		nr_segs = iov_shorten((struct iovec *)iov, nr_segs, size);
-	return generic_file_aio_read(iocb, iov, nr_segs, pos);
+		iov_iter_shorten(iter, size);
+	return generic_file_read_iter(iocb, iter, pos);
 }
 
 /*
@@ -1592,8 +1591,8 @@ const struct file_operations def_blk_fops = {
 	.llseek		= block_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= blkdev_aio_read,
-	.aio_write	= blkdev_aio_write,
+	.read_iter	= blkdev_read_iter,
+	.write_iter	= blkdev_write_iter,
 	.mmap		= generic_file_mmap,
 	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73fb7a7..a8dc250 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2509,8 +2509,8 @@ extern int generic_segment_checks(const struct iovec *iov,
 		unsigned long *nr_segs, size_t *count, int access_flags);
 
 /* fs/block_dev.c */
-extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos);
+extern ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				 loff_t pos);
 extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
 			int datasync);
 extern void block_sync_page(struct page *page);
-- 
1.8.1.5

