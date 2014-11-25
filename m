Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaKYKwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:52:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59168 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaKYKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dwight Engen <dwight.engen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 229/254] vio: fix reuse of vio_dring slot
Date: Tue, 25 Nov 2014 10:39:39 +0000
Message-Id: <1416912004-5928-230-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dwight Engen <dwight.engen@oracle.com>

commit d0aedcd4f14a22e23b313f42b7e6e6ebfc0fbc31 upstream.

vio_dring_avail() will allow use of every dring entry, but when the last
entry is allocated then dr->prod == dr->cons which is indistinguishable from
the ring empty condition. This causes the next allocation to reuse an entry.
When this happens in sunvdc, the server side vds driver begins nack'ing the
messages and ends up resetting the ldc channel. This problem does not effect
sunvnet since it checks for < 2.

The fix here is to just never allocate the very last dring slot so that full
and empty are not the same condition. The request start path was changed to
check for the ring being full a bit earlier, and to stop the blk_queue if
there is no space left. The blk_queue will be restarted once the ring is
only half full again. The number of ring entries was increased to 512 which
matches the sunvnet and Solaris vdc drivers, and greatly reduces the
frequency of hitting the ring full condition and the associated blk_queue
stop/starting. The checks in sunvent were adjusted to account for
vio_dring_avail() returning 1 less.

Orabug: 19441666
OraBZ: 14983

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/include/asm/vio.h       |  2 +-
 drivers/block/sunvdc.c             | 39 ++++++++++++++++++++++----------------
 drivers/net/ethernet/sun/sunvnet.c |  4 ++--
 3 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/sparc/include/asm/vio.h b/arch/sparc/include/asm/vio.h
index 76290c868b01..2986120acac5 100644
--- a/arch/sparc/include/asm/vio.h
+++ b/arch/sparc/include/asm/vio.h
@@ -265,7 +265,7 @@ static inline u32 vio_dring_avail(struct vio_dring_state *dr,
 				  unsigned int ring_size)
 {
 	return (dr->pending -
-		((dr->prod - dr->cons) & (ring_size - 1)));
+		((dr->prod - dr->cons) & (ring_size - 1)) - 1);
 }
 
 #define VIO_MAX_TYPE_LEN	32
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 1a9360da1f54..756b8ec00f16 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -33,7 +33,7 @@ MODULE_DESCRIPTION("Sun LDOM virtual disk client driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
-#define VDC_TX_RING_SIZE	256
+#define VDC_TX_RING_SIZE	512
 
 #define WAITING_FOR_LINK_UP	0x01
 #define WAITING_FOR_TX_SPACE	0x02
@@ -283,7 +283,9 @@ static void vdc_end_one(struct vdc_port *port, struct vio_dring_state *dr,
 
 	__blk_end_request(req, (desc->status ? -EIO : 0), desc->size);
 
-	if (blk_queue_stopped(port->disk->queue))
+	/* restart blk queue when ring is half emptied */
+	if (blk_queue_stopped(port->disk->queue) &&
+	    vdc_tx_dring_avail(dr) * 100 / VDC_TX_RING_SIZE >= 50)
 		blk_start_queue(port->disk->queue);
 }
 
@@ -435,12 +437,6 @@ static int __send_request(struct request *req)
 	for (i = 0; i < nsg; i++)
 		len += sg[i].length;
 
-	if (unlikely(vdc_tx_dring_avail(dr) < 1)) {
-		blk_stop_queue(port->disk->queue);
-		err = -ENOMEM;
-		goto out;
-	}
-
 	desc = vio_dring_cur(dr);
 
 	err = ldc_map_sg(port->vio.lp, sg, nsg,
@@ -480,21 +476,32 @@ static int __send_request(struct request *req)
 		port->req_id++;
 		dr->prod = (dr->prod + 1) & (VDC_TX_RING_SIZE - 1);
 	}
-out:
 
 	return err;
 }
 
-static void do_vdc_request(struct request_queue *q)
+static void do_vdc_request(struct request_queue *rq)
 {
-	while (1) {
-		struct request *req = blk_fetch_request(q);
+	struct request *req;
 
-		if (!req)
-			break;
+	while ((req = blk_peek_request(rq)) != NULL) {
+		struct vdc_port *port;
+		struct vio_dring_state *dr;
 
-		if (__send_request(req) < 0)
-			__blk_end_request_all(req, -EIO);
+		port = req->rq_disk->private_data;
+		dr = &port->vio.drings[VIO_DRIVER_TX_RING];
+		if (unlikely(vdc_tx_dring_avail(dr) < 1))
+			goto wait;
+
+		blk_start_request(req);
+
+		if (__send_request(req) < 0) {
+			blk_requeue_request(rq, req);
+wait:
+			/* Avoid pointless unplugs. */
+			blk_stop_queue(rq);
+			break;
+		}
 	}
 }
 
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index d813bfb1a847..f947ed821808 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -668,7 +668,7 @@ static int vnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	spin_lock_irqsave(&port->vio.lock, flags);
 
 	dr = &port->vio.drings[VIO_DRIVER_TX_RING];
-	if (unlikely(vnet_tx_dring_avail(dr) < 2)) {
+	if (unlikely(vnet_tx_dring_avail(dr) < 1)) {
 		if (!netif_queue_stopped(dev)) {
 			netif_stop_queue(dev);
 
@@ -716,7 +716,7 @@ static int vnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev->stats.tx_bytes += skb->len;
 
 	dr->prod = (dr->prod + 1) & (VNET_TX_RING_SIZE - 1);
-	if (unlikely(vnet_tx_dring_avail(dr) < 2)) {
+	if (unlikely(vnet_tx_dring_avail(dr) < 1)) {
 		netif_stop_queue(dev);
 		if (vnet_tx_dring_avail(dr) > VNET_TX_WAKEUP_THRESH(dr))
 			netif_wake_queue(dev);
-- 
2.1.0

