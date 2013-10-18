Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3JRRzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:55:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26527 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3JRRzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:55:41 -0400
Message-ID: <526175FA.5050501@oracle.com>
Date: Fri, 18 Oct 2013 12:55:06 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH V9.1 17/33] loop: use aio to perform io on the underlying
 file
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com> <1381932286-14978-18-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1381932286-14978-18-git-send-email-dave.kleikamp@oracle.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I made a mistake with my last change to this patch. I misunderstood
what bdev_io_min() was all about. I needed to stick with
logical_block_size.]

This uses the new kernel aio interface to process loopback IO by
submitting concurrent direct aio.  Previously loop's IO was serialized
by synchronous processing in a thread.

The aio operations specify the memory for the IO with the bio_vec arrays
directly instead of mappings of the pages.

The use of aio operations is enabled when the backing file supports the
read_iter, write_iter and direct_IO methods.

Signed-off-by: Zach Brown <zab@zabbo.net>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/block/loop.c      | 158 ++++++++++++++++++++++++++++++++++------------
 include/uapi/linux/loop.h |   1 +
 2 files changed, 119 insertions(+), 40 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 40e7155..e564769 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -75,6 +75,7 @@
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
+#include <linux/aio.h>
 #include "loop.h"
 
 #include <asm/uaccess.h>
@@ -218,6 +219,48 @@ lo_do_transfer(struct loop_device *lo, int cmd,
 	return lo->transfer(lo, cmd, rpage, roffs, lpage, loffs, size, rblock);
 }
 
+#ifdef CONFIG_AIO
+static void lo_rw_aio_complete(u64 data, long res)
+{
+	struct bio *bio = (struct bio *)(uintptr_t)data;
+
+	if (res > 0)
+		res = 0;
+	else if (res < 0)
+		res = -EIO;
+
+	bio_endio(bio, res);
+}
+
+static int lo_rw_aio(struct loop_device *lo, struct bio *bio)
+{
+	struct file *file = lo->lo_backing_file;
+	struct kiocb *iocb;
+	unsigned int op;
+	struct iov_iter iter;
+	struct bio_vec *bvec;
+	size_t nr_segs;
+	loff_t pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
+
+	iocb = aio_kernel_alloc(GFP_NOIO);
+	if (!iocb)
+		return -ENOMEM;
+
+	if (bio_rw(bio) & WRITE)
+		op = IOCB_CMD_WRITE_ITER;
+	else
+		op = IOCB_CMD_READ_ITER;
+
+	bvec = bio_iovec_idx(bio, bio->bi_idx);
+	nr_segs = bio_segments(bio);
+	iov_iter_init_bvec(&iter, bvec, nr_segs, bvec_length(bvec, nr_segs), 0);
+	aio_kernel_init_rw(iocb, file, iov_iter_count(&iter), pos);
+	aio_kernel_init_callback(iocb, lo_rw_aio_complete, (u64)(uintptr_t)bio);
+
+	return aio_kernel_submit(iocb, op, &iter);
+}
+#endif /* CONFIG_AIO */
+
 /**
  * __do_lo_send_write - helper for writing data to a loop device
  *
@@ -418,50 +461,33 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
 
 	if (bio_rw(bio) == WRITE) {
-		struct file *file = lo->lo_backing_file;
-
-		if (bio->bi_rw & REQ_FLUSH) {
-			ret = vfs_fsync(file, 0);
-			if (unlikely(ret && ret != -EINVAL)) {
-				ret = -EIO;
-				goto out;
-			}
-		}
+		ret = lo_send(lo, bio, pos);
+	} else
+		ret = lo_receive(lo, bio, lo->lo_blocksize, pos);
 
-		/*
-		 * We use punch hole to reclaim the free space used by the
-		 * image a.k.a. discard. However we do not support discard if
-		 * encryption is enabled, because it may give an attacker
-		 * useful information.
-		 */
-		if (bio->bi_rw & REQ_DISCARD) {
-			struct file *file = lo->lo_backing_file;
-			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+	return ret;
+}
 
-			if ((!file->f_op->fallocate) ||
-			    lo->lo_encrypt_key_size) {
-				ret = -EOPNOTSUPP;
-				goto out;
-			}
-			ret = file->f_op->fallocate(file, mode, pos,
-						    bio->bi_size);
-			if (unlikely(ret && ret != -EINVAL &&
-				     ret != -EOPNOTSUPP))
-				ret = -EIO;
-			goto out;
-		}
+static int lo_discard(struct loop_device *lo, struct bio *bio)
+{
+	struct file *file = lo->lo_backing_file;
+	int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+	loff_t pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
+	int ret;
 
-		ret = lo_send(lo, bio, pos);
+	/*
+	 * We use punch hole to reclaim the free space used by the
+	 * image a.k.a. discard. However we do not support discard if
+	 * encryption is enabled, because it may give an attacker
+	 * useful information.
+	 */
 
-		if ((bio->bi_rw & REQ_FUA) && !ret) {
-			ret = vfs_fsync(file, 0);
-			if (unlikely(ret && ret != -EINVAL))
-				ret = -EIO;
-		}
-	} else
-		ret = lo_receive(lo, bio, lo->lo_blocksize, pos);
+	if ((!file->f_op->fallocate) || lo->lo_encrypt_key_size)
+		return -EOPNOTSUPP;
 
-out:
+	ret = file->f_op->fallocate(file, mode, pos, bio->bi_size);
+	if (unlikely(ret && ret != -EINVAL && ret != -EOPNOTSUPP))
+		ret = -EIO;
 	return ret;
 }
 
@@ -525,7 +551,35 @@ static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
 		do_loop_switch(lo, bio->bi_private);
 		bio_put(bio);
 	} else {
-		int ret = do_bio_filebacked(lo, bio);
+		int ret;
+
+		if (bio_rw(bio) == WRITE) {
+			if (bio->bi_rw & REQ_FLUSH) {
+				ret = vfs_fsync(lo->lo_backing_file, 1);
+				if (unlikely(ret && ret != -EINVAL))
+					goto out;
+			}
+			if (bio->bi_rw & REQ_DISCARD) {
+				ret = lo_discard(lo, bio);
+				goto out;
+			}
+		}
+#ifdef CONFIG_AIO
+		if (lo->lo_flags & LO_FLAGS_USE_AIO &&
+		    lo->transfer == transfer_none) {
+			ret = lo_rw_aio(lo, bio);
+			if (ret == 0)
+				return;
+		} else
+#endif
+			ret = do_bio_filebacked(lo, bio);
+
+		if ((bio_rw(bio) == WRITE) && bio->bi_rw & REQ_FUA && !ret) {
+			ret = vfs_fsync(lo->lo_backing_file, 0);
+			if (unlikely(ret && ret != -EINVAL))
+				ret = -EIO;
+		}
+out:
 		bio_endio(bio, ret);
 	}
 }
@@ -547,6 +601,12 @@ static int loop_thread(void *data)
 	struct loop_device *lo = data;
 	struct bio *bio;
 
+	/*
+	 * In cases where the underlying filesystem calls balance_dirty_pages()
+	 * we want less throttling to avoid lock ups trying to write dirty
+	 * pages through the loop device
+	 */
+	current->flags |= PF_LESS_THROTTLE;
 	set_user_nice(current, -20);
 
 	while (!kthread_should_stop() || !bio_list_empty(&lo->lo_bio_list)) {
@@ -869,6 +929,14 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	    !file->f_op->write)
 		lo_flags |= LO_FLAGS_READ_ONLY;
 
+#ifdef CONFIG_AIO
+	if (file->f_op->write_iter && file->f_op->read_iter &&
+	    mapping->a_ops->direct_IO) {
+		file->f_flags |= O_DIRECT;
+		lo_flags |= LO_FLAGS_USE_AIO;
+	}
+#endif
+
 	lo_blocksize = S_ISBLK(inode->i_mode) ?
 		inode->i_bdev->bd_block_size : PAGE_SIZE;
 
@@ -912,6 +980,16 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	set_blocksize(bdev, lo_blocksize);
 
+#ifdef CONFIG_AIO
+	/*
+	 * We must not send too-small direct-io requests, so we inherit
+	 * the logical block size from the underlying device
+	 */
+	if ((lo_flags & LO_FLAGS_USE_AIO) && inode->i_sb->s_bdev)
+		blk_queue_logical_block_size(lo->lo_queue,
+				bdev_logical_block_size(inode->i_sb->s_bdev));
+#endif
+
 	lo->lo_thread = kthread_create(loop_thread, lo, "loop%d",
 						lo->lo_number);
 	if (IS_ERR(lo->lo_thread)) {
diff --git a/include/uapi/linux/loop.h b/include/uapi/linux/loop.h
index e0cecd2..6edc6b6 100644
--- a/include/uapi/linux/loop.h
+++ b/include/uapi/linux/loop.h
@@ -21,6 +21,7 @@ enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_AUTOCLEAR	= 4,
 	LO_FLAGS_PARTSCAN	= 8,
+	LO_FLAGS_USE_AIO	= 16,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
-- 
1.8.4.1

