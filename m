Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaHVLT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:19:29 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44188 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbaHVLT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:19:26 -0400
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc: bob.liu@oracle.com, felipe.franciosi@citrix.com, axboe@fb.com,
        avanzini.arianna@gmail.com
Subject: [PATCH RFC 1/4] xen, blkfront: add support for the multi-queue block layer API
Date: Fri, 22 Aug 2014 13:20:01 +0200
Message-Id: <1408706404-6614-2-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit introduces support for the multi-queue block layer API.
The changes are only structural, and force both the use of the
multi-queue API and the use of a single I/O ring, by initializing
statically the number of hardware queues to one.

Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 drivers/block/xen-blkfront.c | 133 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 116 insertions(+), 17 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 5deb235..0407ad5 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -37,6 +37,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/hdreg.h>
 #include <linux/cdrom.h>
 #include <linux/module.h>
@@ -98,6 +99,8 @@ static unsigned int xen_blkif_max_segments = 32;
 module_param_named(max, xen_blkif_max_segments, int, S_IRUGO);
 MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default is 32)");
 
+static unsigned int hardware_queues = 1;
+
 #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
 
 /*
@@ -134,6 +137,8 @@ struct blkfront_info
 	unsigned int feature_persistent:1;
 	unsigned int max_indirect_segments;
 	int is_ready;
+	/* Block layer tags. */
+	struct blk_mq_tag_set tag_set;
 };
 
 static unsigned int nr_minors;
@@ -385,6 +390,7 @@ static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
  * and writes are handled as expected.
  *
  * @req: a request struct
+ * @ring_idx: index of the ring the request is to be inserted in
  */
 static int blkif_queue_request(struct request *req)
 {
@@ -632,6 +638,61 @@ wait:
 		flush_requests(info);
 }
 
+static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
+{
+	struct blkfront_info *info = req->rq_disk->private_data;
+
+	pr_debug("Entered blkfront_queue_rq\n");
+
+	spin_lock_irq(&info->io_lock);
+	if (RING_FULL(&info->ring))
+		goto wait;
+
+	if ((req->cmd_type != REQ_TYPE_FS) ||
+			((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
+			 !info->flush_op)) {
+		req->errors = -EIO;
+		blk_mq_complete_request(req);
+		spin_unlock_irq(&info->io_lock);
+		return BLK_MQ_RQ_QUEUE_ERROR;
+	}
+
+	pr_debug("blkfront_queue_req %p: cmd %p, sec %lx, ""(%u/%u) [%s]\n",
+			req, req->cmd, (unsigned long)blk_rq_pos(req),
+			blk_rq_cur_sectors(req), blk_rq_sectors(req),
+			rq_data_dir(req) ? "write" : "read");
+
+	if (blkif_queue_request(req)) {
+wait:
+		/* Avoid pointless unplugs. */
+		blk_mq_stop_hw_queue(hctx);
+		spin_unlock_irq(&info->io_lock);
+		return BLK_MQ_RQ_QUEUE_BUSY;
+	}
+
+	flush_requests(info);
+	spin_unlock_irq(&info->io_lock);
+	return BLK_MQ_RQ_QUEUE_OK;
+}
+
+static int blkfront_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+			  unsigned int index)
+{
+	return 0;
+}
+
+static void blkfront_complete(struct request *req)
+{
+	blk_mq_end_io(req, req->errors);
+}
+
+static struct blk_mq_ops blkfront_mq_ops = {
+	.queue_rq = blkfront_queue_rq,
+	.init_hctx = blkfront_init_hctx,
+	.complete = blkfront_complete,
+	.map_queue = blk_mq_map_queue,
+};
+
 static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 				unsigned int physical_sector_size,
 				unsigned int segments)
@@ -639,9 +700,29 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 	struct request_queue *rq;
 	struct blkfront_info *info = gd->private_data;
 
-	rq = blk_init_queue(do_blkif_request, &info->io_lock);
-	if (rq == NULL)
-		return -1;
+	if (hardware_queues) {
+		memset(&info->tag_set, 0, sizeof(info->tag_set));
+		info->tag_set.ops = &blkfront_mq_ops;
+		info->tag_set.nr_hw_queues = hardware_queues;
+		info->tag_set.queue_depth = BLK_RING_SIZE;
+		info->tag_set.numa_node = NUMA_NO_NODE;
+		info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+		info->tag_set.cmd_size = 0;
+		info->tag_set.driver_data = info;
+
+		if (blk_mq_alloc_tag_set(&info->tag_set))
+			return -1;
+		rq = blk_mq_init_queue(&info->tag_set);
+		if (!rq) {
+			blk_mq_free_tag_set(&info->tag_set);
+			return -1;
+		}
+	} else {
+		rq = blk_init_queue(do_blkif_request, &info->io_lock);
+		if (rq == NULL)
+			return -1;
+	}
+	rq->queuedata = info;
 
 	queue_flag_set_unlocked(QUEUE_FLAG_VIRT, rq);
 
@@ -871,7 +952,10 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
 	spin_lock_irqsave(&info->io_lock, flags);
 
 	/* No more blkif_request(). */
-	blk_stop_queue(info->rq);
+	if (hardware_queues)
+		blk_mq_stop_hw_queues(info->rq);
+	else
+		blk_stop_queue(info->rq);
 
 	/* No more gnttab callback work. */
 	gnttab_cancel_free_callback(&info->callback);
@@ -887,6 +971,7 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
 	xlbd_release_minors(minor, nr_minors);
 
 	blk_cleanup_queue(info->rq);
+	blk_mq_free_tag_set(&info->tag_set);
 	info->rq = NULL;
 
 	put_disk(info->gd);
@@ -896,10 +981,14 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
 static void kick_pending_request_queues(struct blkfront_info *info)
 {
 	if (!RING_FULL(&info->ring)) {
-		/* Re-enable calldowns. */
-		blk_start_queue(info->rq);
-		/* Kick things off immediately. */
-		do_blkif_request(info->rq);
+		if (hardware_queues) {
+			blk_mq_start_stopped_hw_queues(info->rq, 0);
+		} else {
+			/* Re-enable calldowns. */
+			blk_start_queue(info->rq);
+			/* Kick things off immediately. */
+			do_blkif_request(info->rq);
+		}
 	}
 }
 
@@ -924,8 +1013,12 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	info->connected = suspend ?
 		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
 	/* No more blkif_request(). */
-	if (info->rq)
-		blk_stop_queue(info->rq);
+	if (info->rq) {
+		if (hardware_queues)
+			blk_mq_stop_hw_queues(info->rq);
+		else
+			blk_stop_queue(info->rq);
+	}
 
 	/* Remove all persistent grants */
 	if (!list_empty(&info->grants)) {
@@ -1150,37 +1243,40 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
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
+			if (hardware_queues)
+				blk_mq_complete_request(req);
+			else
+				__blk_end_request_all(req, error);
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
@@ -1192,7 +1288,10 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			__blk_end_request_all(req, error);
+			if (hardware_queues)
+				blk_mq_complete_request(req);
+			else
+				__blk_end_request_all(req, error);
 			break;
 		default:
 			BUG();
-- 
2.0.4

