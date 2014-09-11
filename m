Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaIKX5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:57:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43212 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbaIKX5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:57:40 -0400
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc: hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com, avanzini.arianna@gmail.com
Subject: [PATCH RFC v2 5/5] xen, blkback: negotiate of the number of block rings with the frontend
Date: Fri, 12 Sep 2014 01:57:24 +0200
Message-Id: <1410479844-2864-6-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit lets the backend driver advertise the number of available
hardware queues; it also implements gathering from the frontend driver
the number of rings actually available for mapping.

Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 drivers/block/xen-blkback/xenbus.c | 44 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index a4f13cc..9ff6ced 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -477,6 +477,34 @@ static void xen_vbd_free(struct xen_vbd *vbd)
 	vbd->bdev = NULL;
 }
 
+static int xen_advertise_hw_queues(struct xen_blkif *blkif,
+				   struct request_queue *q)
+{
+	struct xen_vbd *vbd = &blkif->vbd;
+	struct xenbus_transaction xbt;
+	int err;
+
+	if (q && q->mq_ops)
+		vbd->nr_supported_hw_queues = q->nr_hw_queues;
+
+	err = xenbus_transaction_start(&xbt);
+	if (err) {
+		BUG_ON(!blkif->be);
+		xenbus_dev_fatal(blkif->be->dev, err, "starting transaction (hw queues)");
+		return err;
+	}
+
+	err = xenbus_printf(xbt, blkif->be->dev->nodename, "nr_supported_hw_queues", "%u",
+			    blkif->vbd.nr_supported_hw_queues);
+	if (err)
+		xenbus_dev_error(blkif->be->dev, err, "writing %s/nr_supported_hw_queues",
+				 blkif->be->dev->nodename);
+
+	xenbus_transaction_end(xbt, 0);
+
+	return err;
+}
+
 static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 			  unsigned major, unsigned minor, int readonly,
 			  int cdrom)
@@ -484,6 +512,7 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 	struct xen_vbd *vbd;
 	struct block_device *bdev;
 	struct request_queue *q;
+	int err;
 
 	vbd = &blkif->vbd;
 	vbd->handle   = handle;
@@ -522,6 +551,10 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 	if (q && blk_queue_secdiscard(q))
 		vbd->discard_secure = true;
 
+	err = xen_advertise_hw_queues(blkif, q);
+	if (err)
+		return -ENOENT;
+
 	DPRINTK("Successful creation of handle=%04x (dom=%u)\n",
 		handle, blkif->domid);
 	return 0;
@@ -935,7 +968,16 @@ static int connect_ring(struct backend_info *be)
 
 	DPRINTK("%s", dev->otherend);
 
-	blkif->nr_rings = 1;
+	err = xenbus_gather(XBT_NIL, dev->otherend, "nr_blk_rings",
+			    "%u", &blkif->nr_rings, NULL);
+	if (err) {
+		/*
+		 * Frontend does not support multiqueue; force compatibility
+		 * mode of the driver.
+		 */
+		blkif->vbd.nr_supported_hw_queues = 0;
+		blkif->nr_rings = 1;
+	}
 
 	ring_ref = kzalloc(sizeof(unsigned long) * blkif->nr_rings, GFP_KERNEL);
 	if (!ring_ref)
-- 
2.1.0

