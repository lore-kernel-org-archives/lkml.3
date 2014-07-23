Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbaGWW7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:59:44 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44223 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548AbaGWW7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:59:42 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 9/9] block: loop: support to submit I/O via kernel aio based
Date: Thu, 24 Jul 2014 06:55:30 +0800
Message-Id: <1406156130-15575-10-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the patch is based on Dave's previous post.

It is easy to observe that loop block device thoughput
can be increased by > 100% in single job randread,
libaio engine, direct I/O fio test.

Cc: Zach Brown <zab@zabbo.net>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c      |  128 ++++++++++++++++++++++++++++++++++++++++++---
 drivers/block/loop.h      |    1 +
 include/uapi/linux/loop.h |    1 +
 3 files changed, 122 insertions(+), 8 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 96a8913..2279d26 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -76,6 +76,7 @@
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
 #include <linux/blk-mq.h>
+#include <linux/aio.h>
 #include "loop.h"
 
 #include <asm/uaccess.h>
@@ -451,22 +452,112 @@ static int lo_req_flush(struct loop_device *lo, struct request *rq)
 	return ret;
 }
 
-static int do_bio_filebacked(struct loop_device *lo, struct request *rq)
+#ifdef CONFIG_AIO
+static void lo_rw_aio_complete(u64 data, long res)
+{
+	struct loop_cmd *cmd = (struct loop_cmd *)(uintptr_t)data;
+	struct request *rq = cmd->rq;
+
+	if (res > 0)
+		res = 0;
+	else if (res < 0)
+		res = -EIO;
+
+	rq->errors = res;
+	aio_kernel_free(cmd->iocb);
+	blk_mq_complete_request(rq);
+}
+
+static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
+		     bool write, loff_t pos)
+{
+	struct file *file = lo->lo_backing_file;
+	struct request *rq = cmd->rq;
+	struct kiocb *iocb;
+	unsigned int op, i = 0;
+	struct iov_iter iter;
+	struct bio_vec *bvec, bv;
+	size_t nr_segs = 0;
+	struct req_iterator r_iter;
+	int ret = -EIO;
+
+	/* how many segments */
+	rq_for_each_segment(bv, rq, r_iter)
+		nr_segs++;
+
+	iocb = aio_kernel_alloc(GFP_NOIO, nr_segs * sizeof(*bvec));
+	if (!iocb) {
+		ret = -ENOMEM;
+		goto failed;
+	}
+
+	cmd->iocb = iocb;
+	bvec = (struct bio_vec *)(iocb + 1);
+	rq_for_each_segment(bv, rq, r_iter)
+		bvec[i++] = bv;
+
+	if (write)
+		op = IOCB_CMD_WRITE_ITER;
+	else
+		op = IOCB_CMD_READ_ITER;
+
+	iter.type = ITER_BVEC | (write ? WRITE : 0);
+	iter.bvec = bvec;
+	iter.nr_segs = nr_segs;
+	iter.count = blk_rq_bytes(rq);
+	iter.iov_offset = 0;
+
+	aio_kernel_init_rw(iocb, file, iov_iter_count(&iter), pos,
+			   lo_rw_aio_complete, (u64)(uintptr_t)cmd);
+	ret = aio_kernel_submit(iocb, op, &iter);
+
+	/*
+	 * use same policy with userspace aio, req may have been
+	 * completed already, so relase it by aio completion.
+	 */
+	if (ret != -EIOCBQUEUED)
+		lo_rw_aio_complete((u64)cmd, ret);
+	return 0;
+ failed:
+	return ret;
+}
+#endif /* CONFIG_AIO */
+
+static int lo_io_rw(struct loop_device *lo, struct loop_cmd *cmd,
+		    bool write, loff_t pos)
+{
+#ifdef CONFIG_AIO
+	if (lo->lo_flags & LO_FLAGS_USE_AIO)
+		return lo_rw_aio(lo, cmd, write, pos);
+#endif
+	if (write)
+		return lo_send(lo, cmd->rq, pos);
+	else
+		return lo_receive(lo, cmd->rq, lo->lo_blocksize, pos);
+}
+
+static int do_bio_filebacked(struct loop_device *lo,
+			     struct loop_cmd *cmd, bool *sync)
 {
 	loff_t pos;
 	int ret;
+	struct request *rq = cmd->rq;
 
+	*sync = false;
 	pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 
 	if (rq->cmd_flags & REQ_WRITE) {
-		if (rq->cmd_flags & REQ_FLUSH)
+		if (rq->cmd_flags & REQ_FLUSH) {
 			ret = lo_req_flush(lo, rq);
-		else if (rq->cmd_flags & REQ_DISCARD)
+			*sync = true;
+		} else if (rq->cmd_flags & REQ_DISCARD) {
 			ret = lo_discard(lo, rq, pos);
-		else
-			ret = lo_send(lo, rq, pos);
+			*sync = true;
+		} else {
+			ret = lo_io_rw(lo, cmd, true, pos);
+		}
 	} else
-		ret = lo_receive(lo, rq, lo->lo_blocksize, pos);
+		ret = lo_io_rw(lo, cmd, false, pos);
 
 	return ret;
 }
@@ -771,6 +862,14 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
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
 
@@ -804,6 +903,17 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	set_blocksize(bdev, lo_blocksize);
 
+#ifdef CONFIG_AIO
+	/*
+	 * We must not send too-small direct-io requests, so we reflect
+	 * the minimum io size to the loop device's logical block size
+	 */
+	if ((lo_flags & LO_FLAGS_USE_AIO) && inode->i_sb->s_bdev)
+		blk_queue_logical_block_size(lo->lo_queue,
+					     bdev_io_min(inode->i_sb->s_bdev));
+#endif
+
+
 	lo->lo_state = Lo_bound;
 	if (part_shift)
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
@@ -1503,6 +1613,7 @@ static void loop_queue_work(struct work_struct *work)
 	const bool write = cmd->rq->cmd_flags & REQ_WRITE;
 	struct loop_device *lo = cmd->lo;
 	int ret = -EIO;
+	bool sync = true;
 
 	if (lo->lo_state != Lo_bound)
 		goto failed;
@@ -1510,12 +1621,13 @@ static void loop_queue_work(struct work_struct *work)
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY))
 		goto failed;
 
-	ret = do_bio_filebacked(lo, cmd->rq);
+	ret = do_bio_filebacked(lo, cmd, &sync);
 
  failed:
 	if (ret)
 		cmd->rq->errors = -EIO;
-	blk_mq_complete_request(cmd->rq);
+	if (!(lo->lo_flags & LO_FLAGS_USE_AIO) || sync || ret)
+		blk_mq_complete_request(cmd->rq);
 }
 
 static int loop_init_request(void *data, struct request *rq,
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index be796c7..4004af5 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -65,6 +65,7 @@ struct loop_cmd {
 	struct work_struct work;
 	struct request *rq;
 	struct loop_device *lo;
+	struct kiocb *iocb;
 };
 
 /* Support for loadable transfer modules */
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
1.7.9.5

