Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaLaNXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:23:17 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:43172 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaLaNXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:23:12 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 2/5] block: loop: improve performance via blk-mq
Date: Wed, 31 Dec 2014 13:22:57 +0000
Message-Id: <1420032180-30256-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420032180-30256-1-git-send-email-ming.lei@canonical.com>
References: <1420032180-30256-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion is a bit straightforward, and use work queue to
dispatch requests of loop block, and one big change is that requests
is submitted to backend file/device concurrently with work queue,
so throughput may get improved much. Given write requests over same
file are often run exclusively, so don't handle them concurrently for
avoiding extra context switch cost, possible lock contention and work
schedule cost. Also with blk-mq, there is opportunity to get loop I/O
merged before submitting to backend file/device.

In the following test:
	- base: v3.19-rc2-2041231
	- loop over file in ext4 file system on SSD disk
	- bs: 4k, libaio, io depth: 64, O_DIRECT, num of jobs: 1
	- throughput: IOPS

	------------------------------------------------------
	|            | base      | base with loop-mq | delta |
	------------------------------------------------------
	| randread   | 1740      | 25318             | +1355%|
	------------------------------------------------------
	| read       | 42196     | 51771             | +22.6%|
	-----------------------------------------------------
	| randwrite  | 35709     | 34624             | -3%   |
	-----------------------------------------------------
	| write      | 39137     | 40326             | +3%   |
	-----------------------------------------------------

So loop-mq can improve throughput for both read and randread, meantime,
performance of write and randwrite isn't hurted basically.

Another benefit is that loop driver code gets simplified
much after blk-mq conversion, and the patch can be thought as
cleanup too.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c |  327 +++++++++++++++++++++++++-------------------------
 drivers/block/loop.h |   17 ++-
 2 files changed, 174 insertions(+), 170 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6cb1beb..c678eb2 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -75,6 +75,7 @@
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
+#include <linux/blk-mq.h>
 #include "loop.h"
 
 #include <asm/uaccess.h>
@@ -85,6 +86,8 @@ static DEFINE_MUTEX(loop_index_mutex);
 static int max_part;
 static int part_shift;
 
+static struct workqueue_struct *loop_wq;
+
 /*
  * Transfer functions
  */
@@ -466,109 +469,36 @@ out:
 	return ret;
 }
 
-/*
- * Add bio to back of pending list
- */
-static void loop_add_bio(struct loop_device *lo, struct bio *bio)
-{
-	lo->lo_bio_count++;
-	bio_list_add(&lo->lo_bio_list, bio);
-}
-
-/*
- * Grab first pending buffer
- */
-static struct bio *loop_get_bio(struct loop_device *lo)
-{
-	lo->lo_bio_count--;
-	return bio_list_pop(&lo->lo_bio_list);
-}
-
-static void loop_make_request(struct request_queue *q, struct bio *old_bio)
-{
-	struct loop_device *lo = q->queuedata;
-	int rw = bio_rw(old_bio);
-
-	if (rw == READA)
-		rw = READ;
-
-	BUG_ON(!lo || (rw != READ && rw != WRITE));
-
-	spin_lock_irq(&lo->lo_lock);
-	if (lo->lo_state != Lo_bound)
-		goto out;
-	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
-		goto out;
-	if (lo->lo_bio_count >= q->nr_congestion_on)
-		wait_event_lock_irq(lo->lo_req_wait,
-				    lo->lo_bio_count < q->nr_congestion_off,
-				    lo->lo_lock);
-	loop_add_bio(lo, old_bio);
-	wake_up(&lo->lo_event);
-	spin_unlock_irq(&lo->lo_lock);
-	return;
-
-out:
-	spin_unlock_irq(&lo->lo_lock);
-	bio_io_error(old_bio);
-}
-
 struct switch_request {
 	struct file *file;
 	struct completion wait;
 };
 
-static void do_loop_switch(struct loop_device *, struct switch_request *);
-
-static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
+static inline int loop_handle_bio(struct loop_device *lo, struct bio *bio)
 {
-	if (unlikely(!bio->bi_bdev)) {
-		do_loop_switch(lo, bio->bi_private);
-		bio_put(bio);
-	} else {
-		int ret = do_bio_filebacked(lo, bio);
-		bio_endio(bio, ret);
-	}
+	return do_bio_filebacked(lo, bio);
 }
 
 /*
- * worker thread that handles reads/writes to file backed loop devices,
- * to avoid blocking in our make_request_fn. it also does loop decrypting
- * on reads for block backed loop, as that is too heavy to do from
- * b_end_io context where irqs may be disabled.
- *
- * Loop explanation:  loop_clr_fd() sets lo_state to Lo_rundown before
- * calling kthread_stop().  Therefore once kthread_should_stop() is
- * true, make_request will not place any more requests.  Therefore
- * once kthread_should_stop() is true and lo_bio is NULL, we are
- * done with the loop.
+ * Do the actual switch; called from the BIO completion routine
  */
-static int loop_thread(void *data)
+static void do_loop_switch(struct loop_device *lo, struct switch_request *p)
 {
-	struct loop_device *lo = data;
-	struct bio *bio;
-
-	set_user_nice(current, MIN_NICE);
-
-	while (!kthread_should_stop() || !bio_list_empty(&lo->lo_bio_list)) {
-
-		wait_event_interruptible(lo->lo_event,
-				!bio_list_empty(&lo->lo_bio_list) ||
-				kthread_should_stop());
-
-		if (bio_list_empty(&lo->lo_bio_list))
-			continue;
-		spin_lock_irq(&lo->lo_lock);
-		bio = loop_get_bio(lo);
-		if (lo->lo_bio_count < lo->lo_queue->nr_congestion_off)
-			wake_up(&lo->lo_req_wait);
-		spin_unlock_irq(&lo->lo_lock);
+	struct file *file = p->file;
+	struct file *old_file = lo->lo_backing_file;
+	struct address_space *mapping;
 
-		BUG_ON(!bio);
-		loop_handle_bio(lo, bio);
-	}
+	/* if no new file, only flush of queued bios requested */
+	if (!file)
+		return;
 
-	return 0;
+	mapping = file->f_mapping;
+	mapping_set_gfp_mask(old_file->f_mapping, lo->old_gfp_mask);
+	lo->lo_backing_file = file;
+	lo->lo_blocksize = S_ISBLK(mapping->host->i_mode) ?
+		mapping->host->i_bdev->bd_block_size : PAGE_SIZE;
+	lo->old_gfp_mask = mapping_gfp_mask(mapping);
+	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 }
 
 /*
@@ -579,15 +509,18 @@ static int loop_thread(void *data)
 static int loop_switch(struct loop_device *lo, struct file *file)
 {
 	struct switch_request w;
-	struct bio *bio = bio_alloc(GFP_KERNEL, 0);
-	if (!bio)
-		return -ENOMEM;
-	init_completion(&w.wait);
+
 	w.file = file;
-	bio->bi_private = &w;
-	bio->bi_bdev = NULL;
-	loop_make_request(lo->lo_queue, bio);
-	wait_for_completion(&w.wait);
+
+	/* freeze queue and wait for completion of scheduled requests */
+	blk_mq_freeze_queue(lo->lo_queue);
+
+	/* do the switch action */
+	do_loop_switch(lo, &w);
+
+	/* unfreeze */
+	blk_mq_unfreeze_queue(lo->lo_queue);
+
 	return 0;
 }
 
@@ -596,39 +529,10 @@ static int loop_switch(struct loop_device *lo, struct file *file)
  */
 static int loop_flush(struct loop_device *lo)
 {
-	/* loop not yet configured, no running thread, nothing to flush */
-	if (!lo->lo_thread)
-		return 0;
-
 	return loop_switch(lo, NULL);
 }
 
 /*
- * Do the actual switch; called from the BIO completion routine
- */
-static void do_loop_switch(struct loop_device *lo, struct switch_request *p)
-{
-	struct file *file = p->file;
-	struct file *old_file = lo->lo_backing_file;
-	struct address_space *mapping;
-
-	/* if no new file, only flush of queued bios requested */
-	if (!file)
-		goto out;
-
-	mapping = file->f_mapping;
-	mapping_set_gfp_mask(old_file->f_mapping, lo->old_gfp_mask);
-	lo->lo_backing_file = file;
-	lo->lo_blocksize = S_ISBLK(mapping->host->i_mode) ?
-		mapping->host->i_bdev->bd_block_size : PAGE_SIZE;
-	lo->old_gfp_mask = mapping_gfp_mask(mapping);
-	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
-out:
-	complete(&p->wait);
-}
-
-
-/*
  * loop_change_fd switched the backing store of a loopback device to
  * a new file. This is useful for operating system installers to free up
  * the original file and in High Availability environments to switch to
@@ -889,12 +793,9 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->transfer = transfer_none;
 	lo->ioctl = NULL;
 	lo->lo_sizelimit = 0;
-	lo->lo_bio_count = 0;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
-	bio_list_init(&lo->lo_bio_list);
-
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
 
@@ -906,14 +807,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	set_blocksize(bdev, lo_blocksize);
 
-	lo->lo_thread = kthread_create(loop_thread, lo, "loop%d",
-						lo->lo_number);
-	if (IS_ERR(lo->lo_thread)) {
-		error = PTR_ERR(lo->lo_thread);
-		goto out_clr;
-	}
 	lo->lo_state = Lo_bound;
-	wake_up_process(lo->lo_thread);
 	if (part_shift)
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
@@ -925,18 +819,6 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	bdgrab(bdev);
 	return 0;
 
-out_clr:
-	loop_sysfs_exit(lo);
-	lo->lo_thread = NULL;
-	lo->lo_device = NULL;
-	lo->lo_backing_file = NULL;
-	lo->lo_flags = 0;
-	set_capacity(lo->lo_disk, 0);
-	invalidate_bdev(bdev);
-	bd_set_size(bdev, 0);
-	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
-	mapping_set_gfp_mask(mapping, lo->old_gfp_mask);
-	lo->lo_state = Lo_unbound;
  out_putf:
 	fput(file);
  out:
@@ -1012,11 +894,6 @@ static int loop_clr_fd(struct loop_device *lo)
 
 	spin_lock_irq(&lo->lo_lock);
 	lo->lo_state = Lo_rundown;
-	spin_unlock_irq(&lo->lo_lock);
-
-	kthread_stop(lo->lo_thread);
-
-	spin_lock_irq(&lo->lo_lock);
 	lo->lo_backing_file = NULL;
 	spin_unlock_irq(&lo->lo_lock);
 
@@ -1028,7 +905,6 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_offset = 0;
 	lo->lo_sizelimit = 0;
 	lo->lo_encrypt_key_size = 0;
-	lo->lo_thread = NULL;
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
@@ -1601,6 +1477,108 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
+static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
+{
+	struct loop_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
+
+	blk_mq_start_request(bd->rq);
+
+	if (cmd->rq->cmd_flags & REQ_WRITE) {
+		struct loop_device *lo = cmd->rq->q->queuedata;
+		bool need_sched = true;
+
+		spin_lock_irq(&lo->lo_lock);
+		if (lo->write_started)
+			need_sched = false;
+		else
+			lo->write_started = true;
+		list_add_tail(&cmd->list, &lo->write_cmd_head);
+		spin_unlock_irq(&lo->lo_lock);
+
+		if (need_sched)
+			queue_work(loop_wq, &lo->write_work);
+	} else {
+		queue_work(loop_wq, &cmd->read_work);
+	}
+
+	return BLK_MQ_RQ_QUEUE_OK;
+}
+
+static void loop_handle_cmd(struct loop_cmd *cmd)
+{
+	const bool write = cmd->rq->cmd_flags & REQ_WRITE;
+	struct loop_device *lo = cmd->rq->q->queuedata;
+	int ret = -EIO;
+	struct bio *bio;
+
+	if (lo->lo_state != Lo_bound)
+		goto failed;
+
+	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY))
+		goto failed;
+
+	ret = 0;
+	__rq_for_each_bio(bio, cmd->rq)
+		ret |= loop_handle_bio(lo, bio);
+
+ failed:
+	if (ret)
+		cmd->rq->errors = -EIO;
+	blk_mq_complete_request(cmd->rq);
+}
+
+static void loop_queue_write_work(struct work_struct *work)
+{
+	struct loop_device *lo =
+		container_of(work, struct loop_device, write_work);
+	LIST_HEAD(cmd_list);
+
+	spin_lock_irq(&lo->lo_lock);
+ repeat:
+	list_splice_init(&lo->write_cmd_head, &cmd_list);
+	spin_unlock_irq(&lo->lo_lock);
+
+	while (!list_empty(&cmd_list)) {
+		struct loop_cmd *cmd = list_first_entry(&cmd_list,
+				struct loop_cmd, list);
+		list_del_init(&cmd->list);
+		loop_handle_cmd(cmd);
+	}
+
+	spin_lock_irq(&lo->lo_lock);
+	if (!list_empty(&lo->write_cmd_head))
+		goto repeat;
+	lo->write_started = false;
+	spin_unlock_irq(&lo->lo_lock);
+}
+
+static void loop_queue_read_work(struct work_struct *work)
+{
+	struct loop_cmd *cmd =
+		container_of(work, struct loop_cmd, read_work);
+
+	loop_handle_cmd(cmd);
+}
+
+static int loop_init_request(void *data, struct request *rq,
+		unsigned int hctx_idx, unsigned int request_idx,
+		unsigned int numa_node)
+{
+	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
+
+	cmd->rq = rq;
+	INIT_WORK(&cmd->read_work, loop_queue_read_work);
+
+	return 0;
+}
+
+static struct blk_mq_ops loop_mq_ops = {
+	.queue_rq       = loop_queue_rq,
+	.map_queue      = blk_mq_map_queue,
+	.init_request	= loop_init_request,
+};
+
 static int loop_add(struct loop_device **l, int i)
 {
 	struct loop_device *lo;
@@ -1627,16 +1605,28 @@ static int loop_add(struct loop_device **l, int i)
 	i = err;
 
 	err = -ENOMEM;
-	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
-	if (!lo->lo_queue)
+	lo->tag_set.ops = &loop_mq_ops;
+	lo->tag_set.nr_hw_queues = 1;
+	lo->tag_set.queue_depth = 128;
+	lo->tag_set.numa_node = NUMA_NO_NODE;
+	lo->tag_set.cmd_size = sizeof(struct loop_cmd);
+	lo->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	lo->tag_set.driver_data = lo;
+
+	err = blk_mq_alloc_tag_set(&lo->tag_set);
+	if (err)
 		goto out_free_idr;
 
-	/*
-	 * set queue make_request_fn
-	 */
-	blk_queue_make_request(lo->lo_queue, loop_make_request);
+	lo->lo_queue = blk_mq_init_queue(&lo->tag_set);
+	if (IS_ERR_OR_NULL(lo->lo_queue)) {
+		err = PTR_ERR(lo->lo_queue);
+		goto out_cleanup_tags;
+	}
 	lo->lo_queue->queuedata = lo;
 
+	INIT_LIST_HEAD(&lo->write_cmd_head);
+	INIT_WORK(&lo->write_work, loop_queue_write_work);
+
 	disk = lo->lo_disk = alloc_disk(1 << part_shift);
 	if (!disk)
 		goto out_free_queue;
@@ -1664,9 +1654,6 @@ static int loop_add(struct loop_device **l, int i)
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	mutex_init(&lo->lo_ctl_mutex);
 	lo->lo_number		= i;
-	lo->lo_thread		= NULL;
-	init_waitqueue_head(&lo->lo_event);
-	init_waitqueue_head(&lo->lo_req_wait);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i << part_shift;
@@ -1680,6 +1667,8 @@ static int loop_add(struct loop_device **l, int i)
 
 out_free_queue:
 	blk_cleanup_queue(lo->lo_queue);
+out_cleanup_tags:
+	blk_mq_free_tag_set(&lo->tag_set);
 out_free_idr:
 	idr_remove(&loop_index_idr, i);
 out_free_dev:
@@ -1692,6 +1681,7 @@ static void loop_remove(struct loop_device *lo)
 {
 	del_gendisk(lo->lo_disk);
 	blk_cleanup_queue(lo->lo_queue);
+	blk_mq_free_tag_set(&lo->tag_set);
 	put_disk(lo->lo_disk);
 	kfree(lo);
 }
@@ -1875,6 +1865,13 @@ static int __init loop_init(void)
 		goto misc_out;
 	}
 
+	loop_wq = alloc_workqueue("kloopd",
+			WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_UNBOUND, 0);
+	if (!loop_wq) {
+		err = -ENOMEM;
+		goto misc_out;
+	}
+
 	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
 				  THIS_MODULE, loop_probe, NULL, NULL);
 
@@ -1912,6 +1909,8 @@ static void __exit loop_exit(void)
 	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
 	unregister_blkdev(LOOP_MAJOR, "loop");
 
+	destroy_workqueue(loop_wq);
+
 	misc_deregister(&loop_misc);
 }
 
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index 90df5d6..e20cdbb 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/workqueue.h>
 #include <uapi/linux/loop.h>
 
 /* Possible states of device */
@@ -52,19 +53,23 @@ struct loop_device {
 	gfp_t		old_gfp_mask;
 
 	spinlock_t		lo_lock;
-	struct bio_list		lo_bio_list;
-	unsigned int		lo_bio_count;
+	struct list_head	write_cmd_head;
+	struct work_struct	write_work;
+	bool			write_started;
 	int			lo_state;
 	struct mutex		lo_ctl_mutex;
-	struct task_struct	*lo_thread;
-	wait_queue_head_t	lo_event;
-	/* wait queue for incoming requests */
-	wait_queue_head_t	lo_req_wait;
 
 	struct request_queue	*lo_queue;
+	struct blk_mq_tag_set	tag_set;
 	struct gendisk		*lo_disk;
 };
 
+struct loop_cmd {
+	struct work_struct read_work;
+	struct request *rq;
+	struct list_head list;
+};
+
 /* Support for loadable transfer modules */
 struct loop_func_table {
 	int number;	/* filter type */ 
-- 
1.7.9.5

