Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbaGWW5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:57:39 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63034 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbaGWW5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:57:36 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 3/9] block: loop: convert to blk-mq
Date: Thu, 24 Jul 2014 06:55:24 +0800
Message-Id: <1406156130-15575-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion is a bit straightforward, and use work queue to
dispatch reqests of loop block, so scalability gets improved a
lot, and also thoughput is increased a lot in case of concurrent
I/O requests.

Another benefit is that loop driver code gets simplified
much, and the patch can be thought as cleanup too.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c |  294 ++++++++++++++++++++++----------------------------
 drivers/block/loop.h |   14 +--
 2 files changed, 137 insertions(+), 171 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6cb1beb..1af5265 100644
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
@@ -466,109 +469,37 @@ out:
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
@@ -579,15 +510,18 @@ static int loop_thread(void *data)
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
 
@@ -596,39 +530,10 @@ static int loop_switch(struct loop_device *lo, struct file *file)
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
@@ -889,12 +794,9 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
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
 
@@ -906,14 +808,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
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
@@ -925,18 +820,6 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
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
@@ -1012,11 +895,6 @@ static int loop_clr_fd(struct loop_device *lo)
 
 	spin_lock_irq(&lo->lo_lock);
 	lo->lo_state = Lo_rundown;
-	spin_unlock_irq(&lo->lo_lock);
-
-	kthread_stop(lo->lo_thread);
-
-	spin_lock_irq(&lo->lo_lock);
 	lo->lo_backing_file = NULL;
 	spin_unlock_irq(&lo->lo_lock);
 
@@ -1028,7 +906,6 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_offset = 0;
 	lo->lo_sizelimit = 0;
 	lo->lo_encrypt_key_size = 0;
-	lo->lo_thread = NULL;
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
@@ -1601,6 +1478,84 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
+static int loop_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
+{
+	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
+
+	queue_work(loop_wq, &cmd->work);
+	return BLK_MQ_RQ_QUEUE_OK;
+}
+
+static int loop_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+			  unsigned int index)
+{
+	struct loop_device *lo = data;
+
+	hctx->driver_data = lo;
+	return 0;
+}
+
+static void loop_softirq_done_fn(struct request *rq)
+{
+	blk_mq_end_io(rq, rq->errors);
+}
+
+static void loop_queue_work(struct work_struct *work)
+{
+	struct loop_cmd *cmd =
+		container_of(work, struct loop_cmd, work);
+	const bool write = cmd->rq->cmd_flags & REQ_WRITE;
+	struct loop_device *lo = cmd->lo;
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
+	cmd->lo = data;
+	INIT_WORK(&cmd->work, loop_queue_work);
+
+	return 0;
+}
+
+static int loop_init_flush_rq(void *data, struct request_queue *q,
+		struct request *flush_rq,
+		const struct request *src_rq)
+{
+	/* borrow initialization helper for common rq */
+	loop_init_request(data, flush_rq, 0, -1, NUMA_NO_NODE);
+	return 0;
+}
+
+static struct blk_mq_ops loop_mq_ops = {
+	.queue_rq       = loop_queue_rq,
+	.map_queue      = blk_mq_map_queue,
+	.init_hctx	= loop_init_hctx,
+	.init_request	= loop_init_request,
+	.init_flush_rq  = loop_init_flush_rq,
+	.complete	= loop_softirq_done_fn,
+};
+
 static int loop_add(struct loop_device **l, int i)
 {
 	struct loop_device *lo;
@@ -1627,15 +1582,20 @@ static int loop_add(struct loop_device **l, int i)
 	i = err;
 
 	err = -ENOMEM;
-	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
-	if (!lo->lo_queue)
+	lo->tag_set.ops = &loop_mq_ops;
+	lo->tag_set.nr_hw_queues = 1;
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
@@ -1664,9 +1624,6 @@ static int loop_add(struct loop_device **l, int i)
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	mutex_init(&lo->lo_ctl_mutex);
 	lo->lo_number		= i;
-	lo->lo_thread		= NULL;
-	init_waitqueue_head(&lo->lo_event);
-	init_waitqueue_head(&lo->lo_req_wait);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i << part_shift;
@@ -1680,6 +1637,8 @@ static int loop_add(struct loop_device **l, int i)
 
 out_free_queue:
 	blk_cleanup_queue(lo->lo_queue);
+out_cleanup_tags:
+	blk_mq_free_tag_set(&lo->tag_set);
 out_free_idr:
 	idr_remove(&loop_index_idr, i);
 out_free_dev:
@@ -1692,6 +1651,7 @@ static void loop_remove(struct loop_device *lo)
 {
 	del_gendisk(lo->lo_disk);
 	blk_cleanup_queue(lo->lo_queue);
+	blk_mq_free_tag_set(&lo->tag_set);
 	put_disk(lo->lo_disk);
 	kfree(lo);
 }
@@ -1884,6 +1844,10 @@ static int __init loop_init(void)
 		loop_add(&lo, i);
 	mutex_unlock(&loop_index_mutex);
 
+	loop_wq = alloc_workqueue("kloopd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
+	if (!loop_wq)
+		panic("Failed to create kloopd\n");
+
 	printk(KERN_INFO "loop: module loaded\n");
 	return 0;
 
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index 90df5d6..be796c7 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/workqueue.h>
 #include <uapi/linux/loop.h>
 
 /* Possible states of device */
@@ -52,19 +53,20 @@ struct loop_device {
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
 
+struct loop_cmd {
+	struct work_struct work;
+	struct request *rq;
+	struct loop_device *lo;
+};
+
 /* Support for loadable transfer modules */
 struct loop_func_table {
 	int number;	/* filter type */ 
-- 
1.7.9.5

