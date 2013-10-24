Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3JXJqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:46:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37109 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3JXJqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:46:02 -0400
Date: Thu, 24 Oct 2013 10:46:00 +0100
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 05/11] direct-io: only inc/dec inode->i_dio_count for
 file systems
Message-ID: <20131024094600.GS14598@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-6-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382606764-8309-6-git-send-email-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24 2013, Jens Axboe wrote:
> We don't need truncate protection for block devices, so add a flag
> bypassing this cache line dirtying twice for every IO. This easily
> contributes to 5-10% of the CPU time on high IOPS O_DIRECT testing.

There's a merge error in this patch, please find the correct one below.

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1e86823..e20b7c1 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -172,7 +172,8 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	struct inode *inode = file->f_mapping->host;
 
 	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
-				    nr_segs, blkdev_get_block, NULL, NULL, 0);
+				    nr_segs, blkdev_get_block, NULL, NULL,
+				    DIO_IGNORE_TRUNCATE);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 0e04142..acc1471 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -265,7 +265,11 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
 	if (dio->end_io && dio->result)
 		dio->end_io(dio->iocb, offset, transferred, dio->private);
 
-	inode_dio_done(dio->inode);
+	if (dio->flags & DIO_IGNORE_TRUNCATE)
+		__inode_dio_done(dio->inode);
+	else
+		inode_dio_done(dio->inode);
+
 	if (is_async) {
 		if (dio->rw & WRITE) {
 			int err;
@@ -1223,9 +1227,12 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	}
 
 	/*
-	 * Will be decremented at I/O completion time.
+	 * Will be decremented at I/O completion time. For a block device
+	 * we don't need to protect against truncate, so don't increment
+	 * the inode direct IO count.
 	 */
-	atomic_inc(&inode->i_dio_count);
+	if (!(dio->flags & DIO_IGNORE_TRUNCATE))
+		atomic_inc(&inode->i_dio_count);
 
 	retval = 0;
 	sdio.blkbits = blkbits;
diff --git a/fs/inode.c b/fs/inode.c
index b33ba8e..22319db 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1854,6 +1854,11 @@ void inode_dio_wait(struct inode *inode)
 }
 EXPORT_SYMBOL(inode_dio_wait);
 
+void __inode_dio_done(struct inode *inode)
+{
+	wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
+}
+
 /*
  * inode_dio_done - signal finish of a direct I/O requests
  * @inode: inode the direct I/O happens on
@@ -1864,6 +1869,6 @@ EXPORT_SYMBOL(inode_dio_wait);
 void inode_dio_done(struct inode *inode)
 {
 	if (atomic_dec_and_test(&inode->i_dio_count))
-		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
+		__inode_dio_done(inode);
 }
 EXPORT_SYMBOL(inode_dio_done);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3f40547..d90a688 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2468,6 +2468,9 @@ enum {
 
 	/* filesystem does not support filling holes */
 	DIO_SKIP_HOLES	= 0x02,
+
+	/* inode/fs/bdev does not need truncate protection */
+	DIO_IGNORE_TRUNCATE = 0x04,
 };
 
 void dio_end_io(struct bio *bio, int error);
@@ -2488,6 +2491,7 @@ static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
 #endif
 
 void inode_dio_wait(struct inode *inode);
+void __inode_dio_done(struct inode *inode);
 void inode_dio_done(struct inode *inode);
 
 extern const struct file_operations generic_ro_fops;

-- 
Jens Axboe

