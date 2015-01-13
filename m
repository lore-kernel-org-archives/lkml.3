Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbbAMPqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:46:08 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55496 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbbAMPqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:46:04 -0500
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 4/4] block: loop: support to submit I/O via kernel aio based
Date: Tue, 13 Jan 2015 23:44:48 +0800
Message-Id: <1421163888-21452-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the patch is based on Dave's previous post.

This patch submits I/O to fs via kernel aio, and we
can obtain following benefits:

	- double cache in both loop file system and backend file
	gets avoided
	- context switch decreased a lot, and finally CPU utilization
	is decreased
	- cached memory got decreased a lot

One main side effect is that throughput is decreased when
accessing raw loop block(not by filesystem) with kernel aio.

This patch has passed xfstests test(./check -g auto), and
both test and scratch devices are loop block, file system is ext4.

Follows two fio tests' result:

1. fio test inside ext4 file system over loop block
1) How to run
	- linux kernel base: 3.19.0-rc3-next-20150108(loop-mq merged)
	- loop over SSD image 1 in ext4
	- linux psync, 16 jobs, size 200M, ext4 over loop block
	- test result: IOPS from fio output

2) Throughput result:
	-------------------------------------------------------------
	test cases          |randread   |read   |randwrite  |write  |
	-------------------------------------------------------------
	base                |16799      |59508  |31059      |58829
	-------------------------------------------------------------
	base+kernel aio     |15480      |64453  |30187      |57222
	-------------------------------------------------------------

3) CPU
	- context switch decreased to 1/3 ~ 1/2 with kernel aio,
	depends on load, see 'Contexts' of [1] and [2]
	- CPU utilization decreased to 1/2 ~ 2/3 with kernel aio,
	depends on load, see 'CPUs' of [1] and [2]
	- less processes created with kernel aio, see 'Processes' of
	[1] and [2]

4) memory(free, cached)
	- After these four tests with kernel aio: ~10% memory becomes used
	- After these four tests without kernel aio: ~60% memory becomes used
	- see 'Memory Usage' of [1] and [2]

2. fio test over loop block directly
1) How to run
	- linux kernel base: 3.19.0-rc3-next-20150108(loop-mq merged)
	- loop over SSD image 2 in ext4
	- linux aio/O_DIRECT/bs: 4K/64 io depth/one job over loop block
	- test result: IOPS from fio output

2) Throughput result:
	-------------------------------------------------------------
	test cases          |randread   |read   |randwrite  |write  |
	-------------------------------------------------------------
	base                |24568      |55141  |34231      |43694
	-------------------------------------------------------------
	base+kernel aio     |25130      |22813  |24441      |40880
	-------------------------------------------------------------

3) CPU:
	- CPU utilization decreased to 1/2 ~ 2/3 with kernel aio during
	randread, read test and randwrite test, but a bit increased
	in write tests, See 'Cpus' of [3] and [4]
	- Context switch has similar result with above too, see 'Contexts'
	of [3] and [4]
	- Less processes created in randread test, a bit more processes
	in write test with kernel aio

4) Memory:
	- After these four tests with kernel aio: ~15% memory becomes used
	- After these four tests without kernel aio: ~90% memory becomes used
	- see 'Memory Usage' of [3] and [4]

3. sar monitor result in graphical style
[1], linux kernel base: sar monitor result in case of fio test 1
	http://kernel.ubuntu.com/~ming/block/loop-mq-aio/v2/vm-loop-mq-fio-ext4.pdf

[2], linux kernel base plus kernel aio patch: sar monitor result in case of fio test 1
	http://kernel.ubuntu.com/~ming/block/loop-mq-aio/v2/vm-loop-mq-aio-fio-ext4.pdf

[3], linux kernel base: sar monitor result in case of fio test 2
	http://kernel.ubuntu.com/~ming/block/loop-mq-aio/v2/vm-loop-mq-fio-disk.pdf

[4], linux kernel base plus kernel aio patch: sar monitor result in case of fio test 2
	http://kernel.ubuntu.com/~ming/block/loop-mq-aio/v2/vm-loop-mq-aio-fio-disk.pdf

Cc: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/block/loop.h |   10 ++++
 2 files changed, 146 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 47af456..bce06e7 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -450,10 +450,84 @@ static int lo_req_flush(struct loop_device *lo, struct request *rq)
 	return ret;
 }
 
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
+	kfree(cmd->alloc_bv);
+	rq->errors = res;
+	blk_mq_complete_request(rq);
+}
+
+static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
+		     bool write, loff_t pos)
+{
+	unsigned int i = 0;
+	struct iov_iter iter;
+	struct bio_vec *bvec, bv;
+	size_t nr_segs = 0;
+	struct req_iterator r_iter;
+
+	rq_for_each_segment(bv, cmd->rq, r_iter)
+		nr_segs++;
+
+	if (nr_segs > LOOP_CMD_BVEC_CNT) {
+		cmd->alloc_bv = kmalloc(nr_segs * sizeof(*cmd->alloc_bv),
+					GFP_NOIO);
+		if (!cmd->alloc_bv)
+			return -ENOMEM;
+		bvec = cmd->alloc_bv;
+	} else {
+		bvec = cmd->bv;
+		cmd->alloc_bv = NULL;
+	}
+
+	rq_for_each_segment(bv, cmd->rq, r_iter)
+		bvec[i++] = bv;
+
+	iter.type = ITER_BVEC | (write ? WRITE : 0);
+	iter.bvec = bvec;
+	iter.nr_segs = nr_segs;
+	iter.count = blk_rq_bytes(cmd->rq);
+	iter.iov_offset = 0;
+
+	aio_kernel_init_rw(&cmd->iocb, lo->lo_backing_file,
+			   iov_iter_count(&iter), pos,
+			   lo_rw_aio_complete, (u64)(uintptr_t)cmd);
+
+	return aio_kernel_submit(&cmd->iocb, write, &iter);
+}
+#else
+static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
+		     bool write, loff_t pos)
+{
+	return -EIO;
+}
+#endif /* CONFIG_AIO */
+
+static int lo_io_rw(struct loop_device *lo, struct loop_cmd *cmd,
+		    bool write, loff_t pos)
+{
+	if (cmd->use_aio)
+		return lo_rw_aio(lo, cmd, write, pos);
+	if (write)
+		return lo_send(lo, cmd->rq, pos);
+	else
+		return lo_receive(lo, cmd->rq, lo->lo_blocksize, pos);
+}
+
 static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 {
 	loff_t pos;
 	int ret;
+	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
 
 	pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 
@@ -463,9 +537,9 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 		else if (rq->cmd_flags & REQ_DISCARD)
 			ret = lo_discard(lo, rq, pos);
 		else
-			ret = lo_send(lo, rq, pos);
+			ret = lo_io_rw(lo, cmd, true, pos);
 	} else
-		ret = lo_receive(lo, rq, lo->lo_blocksize, pos);
+		ret = lo_io_rw(lo, cmd, false, pos);
 
 	return ret;
 }
@@ -684,6 +758,15 @@ ssize_t loop_attr_do_store_use_aio(struct device *dev,
 		lo->use_aio = true;
 	else
 		lo->use_aio = false;
+
+	if (lo->use_aio != lo->can_use_aio) {
+		if (lo->use_aio)
+			return -EPERM;
+
+		lo->lo_backing_file->f_flags &= O_DIRECT;
+		lo->can_use_aio = false;
+	}
+
 	return count;
 }
 
@@ -803,6 +886,14 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	    !file->f_op->write)
 		lo_flags |= LO_FLAGS_READ_ONLY;
 
+#ifdef CONFIG_AIO
+	if (file->f_op->write_iter && file->f_op->read_iter &&
+	    mapping->a_ops->direct_IO) {
+		file->f_flags |= O_DIRECT;
+		lo->can_use_aio = true;
+	}
+#endif
+
 	lo_blocksize = S_ISBLK(inode->i_mode) ?
 		inode->i_bdev->bd_block_size : PAGE_SIZE;
 
@@ -836,6 +927,14 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	set_blocksize(bdev, lo_blocksize);
 
+	/*
+	 * We must not send too-small direct-io requests, so we reflect
+	 * the minimum io size to the loop device's logical block size
+	 */
+	if (lo->can_use_aio && inode->i_sb->s_bdev)
+		blk_queue_logical_block_size(lo->lo_queue,
+					     bdev_io_min(inode->i_sb->s_bdev));
+
 	lo->lo_state = Lo_bound;
 	if (part_shift)
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
@@ -1506,14 +1605,33 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
+/* return true for single queue schedule */
+static bool loop_prep_sched_rq(struct loop_cmd *cmd)
+{
+	struct loop_device *lo = cmd->rq->q->queuedata;
+	bool single_queue = false;
+
+	cmd->use_aio = false;
+	if (lo->can_use_aio && (lo->transfer == transfer_none)) {
+		if (!(cmd->rq->cmd_flags & (REQ_FLUSH | REQ_DISCARD)))
+			cmd->use_aio = true;
+	}
+
+	if ((cmd->rq->cmd_flags & REQ_WRITE) || cmd->use_aio)
+		single_queue = true;
+
+	return single_queue;
+}
+
 static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
 	struct loop_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
+	bool single_queue = loop_prep_sched_rq(cmd);
 
 	blk_mq_start_request(bd->rq);
 
-	if (cmd->rq->cmd_flags & REQ_WRITE) {
+	if (single_queue) {
 		struct loop_device *lo = cmd->rq->q->queuedata;
 		bool need_sched = true;
 
@@ -1551,7 +1669,8 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
  failed:
 	if (ret)
 		cmd->rq->errors = -EIO;
-	blk_mq_complete_request(cmd->rq);
+	if (!cmd->use_aio || ret)
+		blk_mq_complete_request(cmd->rq);
 }
 
 static void loop_queue_write_work(struct work_struct *work)
@@ -1653,6 +1772,19 @@ static int loop_add(struct loop_device **l, int i)
 	INIT_LIST_HEAD(&lo->write_cmd_head);
 	INIT_WORK(&lo->write_work, loop_queue_write_work);
 
+	blk_queue_max_segments(lo->lo_queue, LOOP_CMD_SEG_CNT);
+	blk_queue_max_hw_sectors(lo->lo_queue, -1U);
+	blk_queue_max_segment_size(lo->lo_queue, -1U);
+
+	/*
+	 * kernel aio can avoid double cache, decrease CPU load
+	 * and won't affect throughput much if I/O originates from
+	 * file system. But suggest to disable kernel aio via sysfs
+	 * for obtaining better throughput in case that loop block
+	 * device is accessed directly.
+	 */
+	lo->use_aio = true;
+
 	disk = lo->lo_disk = alloc_disk(1 << part_shift);
 	if (!disk)
 		goto out_free_queue;
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index 15049e9..c917633 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -16,6 +16,8 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <uapi/linux/loop.h>
+#include <linux/aio.h>
+#include <linux/scatterlist.h>
 
 /* Possible states of device */
 enum {
@@ -24,6 +26,9 @@ enum {
 	Lo_rundown,
 };
 
+#define LOOP_CMD_SEG_CNT    32
+#define LOOP_CMD_BVEC_CNT   (LOOP_CMD_SEG_CNT * 4)
+
 struct loop_func_table;
 
 struct loop_device {
@@ -58,6 +63,7 @@ struct loop_device {
 	struct work_struct	write_work;
 	bool			write_started;
 	bool			use_aio;
+	bool			can_use_aio;
 	int			lo_state;
 	struct mutex		lo_ctl_mutex;
 
@@ -70,6 +76,10 @@ struct loop_cmd {
 	struct work_struct read_work;
 	struct request *rq;
 	struct list_head list;
+	bool use_aio;
+	struct kiocb iocb;
+	struct bio_vec bv[LOOP_CMD_BVEC_CNT];
+	struct bio_vec *alloc_bv;
 };
 
 /* Support for loadable transfer modules */
-- 
1.7.9.5

