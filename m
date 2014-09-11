Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaIKX67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:58:59 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54532 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbaIKX5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:57:31 -0400
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc: hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com, avanzini.arianna@gmail.com
Subject: [PATCH RFC v2 1/5] xen, blkfront: port to the the multi-queue block layer API
Date: Fri, 12 Sep 2014 01:57:20 +0200
Message-Id: <1410479844-2864-2-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit introduces support for the multi-queue block layer API,
and at the same time removes the existing request_queue API support.
The changes are only structural, and the number of supported hardware
contexts is forcedly set to one.

Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 drivers/block/xen-blkfront.c | 171 ++++++++++++++++++++-----------------------
 1 file changed, 80 insertions(+), 91 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 5deb235..109add6 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -37,6 +37,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/hdreg.h>
 #include <linux/cdrom.h>
 #include <linux/module.h>
@@ -134,6 +135,8 @@ struct blkfront_info
 	unsigned int feature_persistent:1;
 	unsigned int max_indirect_segments;
 	int is_ready;
+	/* Block layer tags. */
+	struct blk_mq_tag_set tag_set;
 };
 
 static unsigned int nr_minors;
@@ -582,66 +585,69 @@ static inline void flush_requests(struct blkfront_info *info)
 		notify_remote_via_irq(info->irq);
 }
 
-/*
- * do_blkif_request
- *  read a block; request is in a request queue
- */
-static void do_blkif_request(struct request_queue *rq)
+static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 {
-	struct blkfront_info *info = NULL;
-	struct request *req;
-	int queued;
-
-	pr_debug("Entered do_blkif_request\n");
-
-	queued = 0;
-
-	while ((req = blk_peek_request(rq)) != NULL) {
-		info = req->rq_disk->private_data;
+	struct blkfront_info *info = req->rq_disk->private_data;
 
-		if (RING_FULL(&info->ring))
-			goto wait;
+	spin_lock_irq(&info->io_lock);
+	if (RING_FULL(&info->ring))
+		goto wait;
 
-		blk_start_request(req);
+	if ((req->cmd_type != REQ_TYPE_FS) ||
+			((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
+			 !info->flush_op)) {
+		req->errors = -EIO;
+		blk_mq_complete_request(req);
+		spin_unlock_irq(&info->io_lock);
+		return BLK_MQ_RQ_QUEUE_ERROR;
+	}
 
-		if ((req->cmd_type != REQ_TYPE_FS) ||
-		    ((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
-		    !info->flush_op)) {
-			__blk_end_request_all(req, -EIO);
-			continue;
-		}
+	if (blkif_queue_request(req)) {
+		blk_mq_requeue_request(req);
+		goto wait;
+	}
 
-		pr_debug("do_blk_req %p: cmd %p, sec %lx, "
-			 "(%u/%u) [%s]\n",
-			 req, req->cmd, (unsigned long)blk_rq_pos(req),
-			 blk_rq_cur_sectors(req), blk_rq_sectors(req),
-			 rq_data_dir(req) ? "write" : "read");
+	flush_requests(info);
+	spin_unlock_irq(&info->io_lock);
+	return BLK_MQ_RQ_QUEUE_OK;
 
-		if (blkif_queue_request(req)) {
-			blk_requeue_request(rq, req);
 wait:
-			/* Avoid pointless unplugs. */
-			blk_stop_queue(rq);
-			break;
-		}
-
-		queued++;
-	}
-
-	if (queued != 0)
-		flush_requests(info);
+	/* Avoid pointless unplugs. */
+	blk_mq_stop_hw_queue(hctx);
+	spin_unlock_irq(&info->io_lock);
+	return BLK_MQ_RQ_QUEUE_BUSY;
 }
 
+static struct blk_mq_ops blkfront_mq_ops = {
+	.queue_rq = blkfront_queue_rq,
+	.map_queue = blk_mq_map_queue,
+};
+
 static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 				unsigned int physical_sector_size,
 				unsigned int segments)
 {
 	struct request_queue *rq;
 	struct blkfront_info *info = gd->private_data;
+	int ret;
+
+	memset(&info->tag_set, 0, sizeof(info->tag_set));
+	info->tag_set.ops = &blkfront_mq_ops;
+	info->tag_set.nr_hw_queues = 1;
+	info->tag_set.queue_depth = BLK_RING_SIZE;
+	info->tag_set.numa_node = NUMA_NO_NODE;
+	info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	info->tag_set.cmd_size = 0;
+	info->tag_set.driver_data = info;
 
-	rq = blk_init_queue(do_blkif_request, &info->io_lock);
-	if (rq == NULL)
-		return -1;
+	if ((ret = blk_mq_alloc_tag_set(&info->tag_set)))
+		return ret;
+	rq = blk_mq_init_queue(&info->tag_set);
+	if (IS_ERR(rq)) {
+		blk_mq_free_tag_set(&info->tag_set);
+		return PTR_ERR(rq);
+	}
+	rq->queuedata = info;
 
 	queue_flag_set_unlocked(QUEUE_FLAG_VIRT, rq);
 
@@ -871,7 +877,7 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
 	spin_lock_irqsave(&info->io_lock, flags);
 
 	/* No more blkif_request(). */
-	blk_stop_queue(info->rq);
+	blk_mq_stop_hw_queues(info->rq);
 
 	/* No more gnttab callback work. */
 	gnttab_cancel_free_callback(&info->callback);
@@ -887,30 +893,32 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
 	xlbd_release_minors(minor, nr_minors);
 
 	blk_cleanup_queue(info->rq);
+	blk_mq_free_tag_set(&info->tag_set);
 	info->rq = NULL;
 
 	put_disk(info->gd);
 	info->gd = NULL;
 }
 
-static void kick_pending_request_queues(struct blkfront_info *info)
+static void kick_pending_request_queues(struct blkfront_info *info,
+					unsigned long *flags)
 {
 	if (!RING_FULL(&info->ring)) {
-		/* Re-enable calldowns. */
-		blk_start_queue(info->rq);
-		/* Kick things off immediately. */
-		do_blkif_request(info->rq);
+		spin_unlock_irqrestore(&info->io_lock, *flags);
+		blk_mq_start_stopped_hw_queues(info->rq, 0);
+		spin_lock_irqsave(&info->io_lock, *flags);
 	}
 }
 
 static void blkif_restart_queue(struct work_struct *work)
 {
 	struct blkfront_info *info = container_of(work, struct blkfront_info, work);
+	unsigned long flags;
 
-	spin_lock_irq(&info->io_lock);
+	spin_lock_irqsave(&info->io_lock, flags);
 	if (info->connected == BLKIF_STATE_CONNECTED)
-		kick_pending_request_queues(info);
-	spin_unlock_irq(&info->io_lock);
+		kick_pending_request_queues(info, &flags);
+	spin_unlock_irqrestore(&info->io_lock, flags);
 }
 
 static void blkif_free(struct blkfront_info *info, int suspend)
@@ -925,7 +933,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
 	/* No more blkif_request(). */
 	if (info->rq)
-		blk_stop_queue(info->rq);
+		blk_mq_stop_hw_queues(info->rq);
 
 	/* Remove all persistent grants */
 	if (!list_empty(&info->grants)) {
@@ -1150,37 +1158,37 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 			continue;
 		}
 
-		error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
+		error = req->errors = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
 		switch (bret->operation) {
 		case BLKIF_OP_DISCARD:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
 				struct request_queue *rq = info->rq;
 				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
 					   info->gd->disk_name, op_name(bret->operation));
-				error = -EOPNOTSUPP;
+				error = req->errors = -EOPNOTSUPP;
 				info->feature_discard = 0;
 				info->feature_secdiscard = 0;
 				queue_flag_clear(QUEUE_FLAG_DISCARD, rq);
 				queue_flag_clear(QUEUE_FLAG_SECDISCARD, rq);
 			}
-			__blk_end_request_all(req, error);
+			blk_mq_complete_request(req);
 			break;
 		case BLKIF_OP_FLUSH_DISKCACHE:
 		case BLKIF_OP_WRITE_BARRIER:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
 				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
 				       info->gd->disk_name, op_name(bret->operation));
-				error = -EOPNOTSUPP;
+				error = req->errors = -EOPNOTSUPP;
 			}
 			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
 				     info->shadow[id].req.u.rw.nr_segments == 0)) {
 				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
 				       info->gd->disk_name, op_name(bret->operation));
-				error = -EOPNOTSUPP;
+				error = req->errors = -EOPNOTSUPP;
 			}
 			if (unlikely(error)) {
 				if (error == -EOPNOTSUPP)
-					error = 0;
+					error = req->errors = 0;
 				info->feature_flush = 0;
 				info->flush_op = 0;
 				xlvbd_flush(info);
@@ -1192,7 +1200,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			__blk_end_request_all(req, error);
+			blk_mq_complete_request(req);
 			break;
 		default:
 			BUG();
@@ -1209,7 +1217,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 	} else
 		info->ring.sring->rsp_event = i + 1;
 
-	kick_pending_request_queues(info);
+	blkif_restart_queue_callback(info);
 
 	spin_unlock_irqrestore(&info->io_lock, flags);
 
@@ -1439,6 +1447,7 @@ static int blkif_recover(struct blkfront_info *info)
 	struct bio *bio, *cloned_bio;
 	struct bio_list bio_list, merge_bio;
 	unsigned int segs, offset;
+	unsigned long flags;
 	int pending, size;
 	struct split_bio *split_bio;
 	struct list_head requests;
@@ -1492,45 +1501,24 @@ static int blkif_recover(struct blkfront_info *info)
 
 	kfree(copy);
 
-	/*
-	 * Empty the queue, this is important because we might have
-	 * requests in the queue with more segments than what we
-	 * can handle now.
-	 */
-	spin_lock_irq(&info->io_lock);
-	while ((req = blk_fetch_request(info->rq)) != NULL) {
-		if (req->cmd_flags &
-		    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
-			list_add(&req->queuelist, &requests);
-			continue;
-		}
-		merge_bio.head = req->bio;
-		merge_bio.tail = req->biotail;
-		bio_list_merge(&bio_list, &merge_bio);
-		req->bio = NULL;
-		if (req->cmd_flags & (REQ_FLUSH | REQ_FUA))
-			pr_alert("diskcache flush request found!\n");
-		__blk_put_request(info->rq, req);
-	}
-	spin_unlock_irq(&info->io_lock);
-
 	xenbus_switch_state(info->xbdev, XenbusStateConnected);
 
-	spin_lock_irq(&info->io_lock);
+	spin_lock_irqsave(&info->io_lock, flags);
 
 	/* Now safe for us to use the shared ring */
 	info->connected = BLKIF_STATE_CONNECTED;
 
 	/* Kick any other new requests queued since we resumed */
-	kick_pending_request_queues(info);
+	kick_pending_request_queues(info, &flags);
 
 	list_for_each_entry_safe(req, n, &requests, queuelist) {
 		/* Requeue pending requests (flush or discard) */
 		list_del_init(&req->queuelist);
 		BUG_ON(req->nr_phys_segments > segs);
-		blk_requeue_request(info->rq, req);
+		blk_mq_requeue_request(req);
 	}
-	spin_unlock_irq(&info->io_lock);
+
+	spin_unlock_irqrestore(&info->io_lock, flags);
 
 	while ((bio = bio_list_pop(&bio_list)) != NULL) {
 		/* Traverse the list of pending bios and re-queue them */
@@ -1741,6 +1729,7 @@ static void blkfront_connect(struct blkfront_info *info)
 {
 	unsigned long long sectors;
 	unsigned long sector_size;
+	unsigned long flags;
 	unsigned int physical_sector_size;
 	unsigned int binfo;
 	int err;
@@ -1865,10 +1854,10 @@ static void blkfront_connect(struct blkfront_info *info)
 	xenbus_switch_state(info->xbdev, XenbusStateConnected);
 
 	/* Kick pending requests. */
-	spin_lock_irq(&info->io_lock);
+	spin_lock_irqsave(&info->io_lock, flags);
 	info->connected = BLKIF_STATE_CONNECTED;
-	kick_pending_request_queues(info);
-	spin_unlock_irq(&info->io_lock);
+	kick_pending_request_queues(info, &flags);
+	spin_unlock_irqrestore(&info->io_lock, flags);
 
 	add_disk(info->gd);
 
-- 
2.1.0

