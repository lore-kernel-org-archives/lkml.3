Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaIKX5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:57:38 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:54158 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbaIKX5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:57:35 -0400
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc: hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com, avanzini.arianna@gmail.com
Subject: [PATCH RFC v2 3/5] xen, blkfront: negotiate the number of block rings with the backend
Date: Fri, 12 Sep 2014 01:57:22 +0200
Message-Id: <1410479844-2864-4-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit implements the negotiation of the number of block rings
to be used; as a default, the number of rings is decided by the
frontend driver and is equal to the number of hardware queues that
the backend makes available. In case of guest migration towards a
host whose devices expose a different number of hardware queues, the
number of I/O rings used by the frontend driver remains the same;
XenStore keys may vary if the frontend needs to be compatible with
a host not having multi-queue support.

Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 drivers/block/xen-blkfront.c | 95 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 11 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9282df1..77e311d 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -137,7 +137,7 @@ struct blkfront_info
 	int vdevice;
 	blkif_vdev_t handle;
 	enum blkif_state connected;
-	unsigned int nr_rings;
+	unsigned int nr_rings, old_nr_rings;
 	struct blkfront_ring_info *rinfo;
 	struct request_queue *rq;
 	unsigned int feature_flush;
@@ -147,6 +147,7 @@ struct blkfront_info
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	unsigned int feature_persistent:1;
+	unsigned int hardware_queues;
 	unsigned int max_indirect_segments;
 	int is_ready;
 	/* Block layer tags. */
@@ -669,7 +670,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 
 	memset(&info->tag_set, 0, sizeof(info->tag_set));
 	info->tag_set.ops = &blkfront_mq_ops;
-	info->tag_set.nr_hw_queues = 1;
+	info->tag_set.nr_hw_queues = info->hardware_queues ? : 1;
 	info->tag_set.queue_depth = BLK_RING_SIZE;
 	info->tag_set.numa_node = NUMA_NO_NODE;
 	info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
@@ -938,6 +939,7 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
 	info->gd = NULL;
 }
 
+/* Must be called with io_lock held */
 static void kick_pending_request_queues(struct blkfront_ring_info *rinfo,
 					unsigned long *flags)
 {
@@ -1351,10 +1353,24 @@ again:
 		goto destroy_blkring;
 	}
 
+	/* Advertise the number of rings */
+	err = xenbus_printf(xbt, dev->nodename, "nr_blk_rings",
+			    "%u", info->nr_rings);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "advertising number of rings");
+		goto abort_transaction;
+	}
+
 	for (i = 0 ; i < info->nr_rings ; i++) {
-		BUG_ON(i > 0);
-		snprintf(ring_ref_s, 64, "ring-ref");
-		snprintf(evtchn_s, 64, "event-channel");
+		if (!info->hardware_queues) {
+			BUG_ON(i > 0);
+			/* Support old XenStore keys */
+			snprintf(ring_ref_s, 64, "ring-ref");
+			snprintf(evtchn_s, 64, "event-channel");
+		} else {
+			snprintf(ring_ref_s, 64, "ring-ref-%d", i);
+			snprintf(evtchn_s, 64, "event-channel-%d", i);
+		}
 		err = xenbus_printf(xbt, dev->nodename,
 				    ring_ref_s, "%u", info->rinfo[i].ring_ref);
 		if (err) {
@@ -1403,6 +1419,14 @@ again:
 	return err;
 }
 
+static inline int blkfront_gather_hw_queues(struct blkfront_info *info,
+					    unsigned int *nr_queues)
+{
+	return xenbus_gather(XBT_NIL, info->xbdev->otherend,
+			     "nr_supported_hw_queues", "%u", nr_queues,
+			     NULL);
+}
+
 /**
  * Entry point to this code when a new device is created.  Allocate the basic
  * structures and the ring buffer for communication with the backend, and
@@ -1414,6 +1438,7 @@ static int blkfront_probe(struct xenbus_device *dev,
 {
 	int err, vdevice, i, r;
 	struct blkfront_info *info;
+	unsigned int nr_queues;
 
 	/* FIXME: Use dynamic device id if this is not set. */
 	err = xenbus_scanf(XBT_NIL, dev->nodename,
@@ -1472,10 +1497,19 @@ static int blkfront_probe(struct xenbus_device *dev,
 	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
 	dev_set_drvdata(&dev->dev, info);
 
-	/* Allocate the correct number of rings. */
-	info->nr_rings = 1;
-	pr_info("blkfront: %s: %d rings\n",
-		info->gd->disk_name, info->nr_rings);
+	/* Gather the number of hardware queues as soon as possible */
+	err = blkfront_gather_hw_queues(info, &nr_queues);
+	if (err)
+		info->hardware_queues = 0;
+	else
+		info->hardware_queues = nr_queues;
+	/*
+	 * The backend has told us the number of hw queues he wants.
+	 * Allocate the correct number of rings.
+	 */
+	info->nr_rings = info->hardware_queues ? : 1;
+	pr_info("blkfront: %s: %d hardware queues, %d rings\n",
+		info->gd->disk_name, info->hardware_queues, info->nr_rings);
 
 	info->rinfo = kzalloc(info->nr_rings *
 				sizeof(struct blkfront_ring_info),
@@ -1556,7 +1590,7 @@ static int blkif_recover(struct blkfront_info *info)
 
 	segs = blkfront_gather_indirect(info);
 
-	for (r = 0 ; r < info->nr_rings ; r++) {
+	for (r = 0 ; r < info->old_nr_rings ; r++) {
 		rc |= blkif_setup_shadow(&info->rinfo[r], &copy);
 		rc |= blkfront_setup_indirect(&info->rinfo[r], segs);
 		if (rc) {
@@ -1599,7 +1633,7 @@ static int blkif_recover(struct blkfront_info *info)
 	/* Now safe for us to use the shared ring */
 	info->connected = BLKIF_STATE_CONNECTED;
 
-	for (i = 0 ; i < info->nr_rings ; i++) {
+	for (i = 0 ; i < info->old_nr_rings ; i++) {
 		spin_lock_irqsave(&info->rinfo[i].io_lock, flags);
 		/* Kick any other new requests queued since we resumed */
 		kick_pending_request_queues(&info->rinfo[i], &flags);
@@ -1659,11 +1693,46 @@ static int blkfront_resume(struct xenbus_device *dev)
 {
 	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 	int err;
+	unsigned int nr_queues, prev_nr_queues;
+	bool mq_to_rq_transition;
 
 	dev_dbg(&dev->dev, "blkfront_resume: %s\n", dev->nodename);
 
+	prev_nr_queues = info->hardware_queues;
+
+	err = blkfront_gather_hw_queues(info, &nr_queues);
+	if (err < 0)
+		nr_queues = 0;
+	mq_to_rq_transition = prev_nr_queues && !nr_queues;
+
+	if (prev_nr_queues != nr_queues) {
+		printk(KERN_INFO "blkfront: %s: hw queues %u -> %u\n",
+		       info->gd->disk_name, prev_nr_queues, nr_queues);
+		if (mq_to_rq_transition) {
+			struct blk_mq_hw_ctx *hctx;
+			unsigned int i;
+			/*
+			 * Switch from multi-queue to single-queue:
+			 * update hctx-to-ring mapping before
+			 * resubmitting any requests
+			 */
+			queue_for_each_hw_ctx(info->rq, hctx, i)
+				hctx->driver_data = &info->rinfo[0];
+		}
+		info->hardware_queues = nr_queues;
+	}
+
 	blkif_free(info, info->connected == BLKIF_STATE_CONNECTED);
 
+	/* Free with old number of rings, but rebuild with new */
+	info->old_nr_rings = info->nr_rings;
+	/*
+	 * Must not update if transition didn't happen, we're keeping
+	 * the old number of rings.
+	 */
+	if (mq_to_rq_transition)
+		info->nr_rings = 1;
+
 	err = talk_to_blkback(dev, info);
 
 	/*
@@ -1863,6 +1932,10 @@ static void blkfront_connect(struct blkfront_info *info)
 		 * supports indirect descriptors, and how many.
 		 */
 		blkif_recover(info);
+		info->rinfo = krealloc(info->rinfo,
+				       info->nr_rings * sizeof(struct blkfront_ring_info),
+				       GFP_KERNEL);
+
 		return;
 
 	default:
-- 
2.1.0

