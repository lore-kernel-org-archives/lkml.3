Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaH3QJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:09:51 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62086 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaH3QJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:09:48 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 3/6] block: loop: convert to blk-mq
Date: Sun, 31 Aug 2014 00:08:24 +0800
Message-Id: <1409414907-22238-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
References: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion is a bit straightforward, and use per-hw_queue
kthread work queue to dispatch reqests of loop block, so
scalability gets improved a lot if nr_hw_queues is increased.

Another benefit is that loop driver code gets simplified
much, and the patch can be thought as cleanup too.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c |  322 +++++++++++++++++++++++++++-----------------------
 drivers/block/loop.h |   20 +++-
 2 files changed, 187 insertions(+), 155 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6cb1beb..b02122d 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -75,6 +75,7 @@
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
+#include <linux/blk-mq.h>
 #include "loop.h"
 
 #include <asm/uaccess.h>
@@ -466,109 +467,37 @@ out:
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
+	int ret = do_bio_filebacked(lo, bio);
+	return ret;
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
@@ -579,15 +508,18 @@ static int loop_thread(void *data)
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
 
@@ -596,39 +528,10 @@ static int loop_switch(struct loop_device *lo, struct file *file)
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
@@ -820,6 +723,48 @@ static void loop_config_discard(struct loop_device *lo)
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 }
 
+static void loop_unprepare_hctxs(struct loop_device *lo, unsigned int to)
+{
+	struct blk_mq_hw_ctx *hctx;
+	struct loop_hctx_data *data;
+	unsigned int i;
+
+	queue_for_each_hw_ctx(lo->lo_queue, hctx, i) {
+		if (i == to)
+			break;
+
+		data = hctx->driver_data;
+		flush_kthread_worker(&data->worker);
+		kthread_stop(data->worker_task);
+	}
+}
+
+static int loop_prepare_hctxs(struct loop_device *lo)
+{
+	struct request_queue *q = lo->lo_queue;
+	struct blk_mq_hw_ctx *hctx;
+	struct loop_hctx_data *data;
+	unsigned int i;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		BUG_ON(i >= lo->tag_set.nr_hw_queues);
+		data = hctx->driver_data;
+
+		data->lo = lo;
+		init_kthread_worker(&data->worker);
+		data->worker_task = kthread_run(kthread_worker_fn,
+				&data->worker, "loop%d-%d",
+				lo->lo_number, i);
+		if (IS_ERR(data->worker_task)) {
+			loop_unprepare_hctxs(lo, i);
+			return -ENOMEM;
+		}
+		set_user_nice(data->worker_task, MIN_NICE);
+		sched_getaffinity(data->worker_task->pid, hctx->cpumask);
+	}
+	return 0;
+}
+
 static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 		       struct block_device *bdev, unsigned int arg)
 {
@@ -889,12 +834,9 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
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
 
@@ -906,14 +848,10 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	set_blocksize(bdev, lo_blocksize);
 
-	lo->lo_thread = kthread_create(loop_thread, lo, "loop%d",
-						lo->lo_number);
-	if (IS_ERR(lo->lo_thread)) {
-		error = PTR_ERR(lo->lo_thread);
+	if ((error = loop_prepare_hctxs(lo)) != 0)
 		goto out_clr;
-	}
+
 	lo->lo_state = Lo_bound;
-	wake_up_process(lo->lo_thread);
 	if (part_shift)
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
@@ -927,7 +865,6 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 out_clr:
 	loop_sysfs_exit(lo);
-	lo->lo_thread = NULL;
 	lo->lo_device = NULL;
 	lo->lo_backing_file = NULL;
 	lo->lo_flags = 0;
@@ -1014,7 +951,7 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state = Lo_rundown;
 	spin_unlock_irq(&lo->lo_lock);
 
-	kthread_stop(lo->lo_thread);
+	loop_unprepare_hctxs(lo, lo->tag_set.nr_hw_queues);
 
 	spin_lock_irq(&lo->lo_lock);
 	lo->lo_backing_file = NULL;
@@ -1028,7 +965,6 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_offset = 0;
 	lo->lo_sizelimit = 0;
 	lo->lo_encrypt_key_size = 0;
-	lo->lo_thread = NULL;
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
@@ -1560,6 +1496,9 @@ module_param(max_loop, int, S_IRUGO);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 module_param(max_part, int, S_IRUGO);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per loop device");
+static int nr_queues = 1;
+module_param(nr_queues, int, S_IRUGO);
+MODULE_PARM_DESC(nr_queues, "Number of hw queues per loop device, default: 1");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1601,6 +1540,86 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
+static int loop_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
+{
+	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
+	struct loop_hctx_data *data = hctx->driver_data;
+
+	cmd->hctx_data = data;
+	queue_kthread_work(&data->worker, &cmd->work);
+	return BLK_MQ_RQ_QUEUE_OK;
+}
+
+static void loop_queue_work(struct kthread_work *work)
+{
+	struct loop_cmd *cmd =
+		container_of(work, struct loop_cmd, work);
+	const bool write = cmd->rq->cmd_flags & REQ_WRITE;
+	struct loop_device *lo = cmd->hctx_data->lo;
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
+static int loop_init_request(void *data, struct request *rq,
+		unsigned int hctx_idx, unsigned int request_idx,
+		unsigned int numa_node)
+{
+	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
+
+	cmd->rq = rq;
+	init_kthread_work(&cmd->work, loop_queue_work);
+
+	return 0;
+}
+
+static int loop_prepare_flush_rq(void *data, struct request_queue *q,
+		struct request *flush_rq,
+		const struct request *src_rq)
+{
+	/* borrow initialization helper for common rq */
+	loop_init_request(data, flush_rq, 0, -1, NUMA_NO_NODE);
+	return 0;
+}
+
+static int loop_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+		unsigned int index)
+{
+	hctx->driver_data = kmalloc(sizeof(struct loop_hctx_data),
+			GFP_KERNEL);
+	if (!hctx->driver_data)
+		return -ENOMEM;
+	return 0;
+}
+
+static void loop_exit_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
+{
+	kfree(hctx->driver_data);
+}
+
+static struct blk_mq_ops loop_mq_ops = {
+	.queue_rq       = loop_queue_rq,
+	.map_queue      = blk_mq_map_queue,
+	.init_request	= loop_init_request,
+	.init_hctx	= loop_init_hctx,
+	.exit_hctx	= loop_exit_hctx,
+	.prepare_flush_rq  = loop_prepare_flush_rq,
+};
+
 static int loop_add(struct loop_device **l, int i)
 {
 	struct loop_device *lo;
@@ -1627,15 +1646,20 @@ static int loop_add(struct loop_device **l, int i)
 	i = err;
 
 	err = -ENOMEM;
-	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
-	if (!lo->lo_queue)
+	lo->tag_set.ops = &loop_mq_ops;
+	lo->tag_set.nr_hw_queues = nr_queues;
+	lo->tag_set.queue_depth = 128;
+	lo->tag_set.numa_node = NUMA_NO_NODE;
+	lo->tag_set.cmd_size = sizeof(struct loop_cmd);
+	lo->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+	lo->tag_set.driver_data = lo;
+
+	if (blk_mq_alloc_tag_set(&lo->tag_set))
 		goto out_free_idr;
 
-	/*
-	 * set queue make_request_fn
-	 */
-	blk_queue_make_request(lo->lo_queue, loop_make_request);
-	lo->lo_queue->queuedata = lo;
+	lo->lo_queue = blk_mq_init_queue(&lo->tag_set);
+	if (!lo->lo_queue)
+		goto out_cleanup_tags;
 
 	disk = lo->lo_disk = alloc_disk(1 << part_shift);
 	if (!disk)
@@ -1664,9 +1688,6 @@ static int loop_add(struct loop_device **l, int i)
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	mutex_init(&lo->lo_ctl_mutex);
 	lo->lo_number		= i;
-	lo->lo_thread		= NULL;
-	init_waitqueue_head(&lo->lo_event);
-	init_waitqueue_head(&lo->lo_req_wait);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i << part_shift;
@@ -1680,6 +1701,8 @@ static int loop_add(struct loop_device **l, int i)
 
 out_free_queue:
 	blk_cleanup_queue(lo->lo_queue);
+out_cleanup_tags:
+	blk_mq_free_tag_set(&lo->tag_set);
 out_free_idr:
 	idr_remove(&loop_index_idr, i);
 out_free_dev:
@@ -1692,6 +1715,7 @@ static void loop_remove(struct loop_device *lo)
 {
 	del_gendisk(lo->lo_disk);
 	blk_cleanup_queue(lo->lo_queue);
+	blk_mq_free_tag_set(&lo->tag_set);
 	put_disk(lo->lo_disk);
 	kfree(lo);
 }
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index 90df5d6..adfcf4a 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/workqueue.h>
 #include <uapi/linux/loop.h>
 
 /* Possible states of device */
@@ -52,19 +53,26 @@ struct loop_device {
 	gfp_t		old_gfp_mask;
 
 	spinlock_t		lo_lock;
-	struct bio_list		lo_bio_list;
-	unsigned int		lo_bio_count;
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
 
+struct loop_hctx_data {
+	struct kthread_worker worker;
+	struct task_struct *worker_task;
+	struct loop_device *lo;
+};
+
+struct loop_cmd {
+	struct kthread_work work;
+	struct request *rq;
+	struct loop_hctx_data *hctx_data;
+};
+
 /* Support for loadable transfer modules */
 struct loop_func_table {
 	int number;	/* filter type */ 
-- 
1.7.9.5

