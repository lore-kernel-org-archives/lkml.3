Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaJTGtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:49:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaJTGtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:49:07 -0400
Date: Mon, 20 Oct 2014 09:52:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC v3 2/3] virtio_net: bql
Message-ID: <1413787824-16130-3-git-send-email-mst@redhat.com>
References: <1413787824-16130-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413787824-16130-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve tx batching using byte queue limits.
Should be especially effective for MQ.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 14f4cda..b83d39d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -227,6 +227,7 @@ static unsigned int free_old_xmit_skbs(struct netdev_queue *txq,
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
 	unsigned int packets = 0;
+	unsigned int bytes = 0;
 
 	while (packets < budget &&
 	       (skb = virtqueue_get_buf(sq->vq, &len)) != NULL) {
@@ -234,6 +235,7 @@ static unsigned int free_old_xmit_skbs(struct netdev_queue *txq,
 
 		u64_stats_update_begin(&stats->tx_syncp);
 		stats->tx_bytes += skb->len;
+		bytes += skb->len;
 		stats->tx_packets++;
 		u64_stats_update_end(&stats->tx_syncp);
 
@@ -241,6 +243,8 @@ static unsigned int free_old_xmit_skbs(struct netdev_queue *txq,
 		packets++;
 	}
 
+	netdev_tx_completed_queue(txq, packets, bytes);
+
 	if (sq->vq->num_free >= 2+MAX_SKB_FRAGS)
 		netif_tx_start_queue(txq);
 
@@ -959,6 +963,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	int err;
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
 	bool kick = !skb->xmit_more;
+	unsigned int bytes = skb->len;
 
 	virtqueue_disable_cb(sq->vq);
 
@@ -976,6 +981,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
+	netdev_tx_sent_queue(txq, bytes);
+
 	/* Apparently nice girls don't return TX_BUSY; stop the queue
 	 * before it gets out of hand.  Naturally, this wastes entries. */
 	if (sq->vq->num_free < 2+MAX_SKB_FRAGS)
-- 
MST

