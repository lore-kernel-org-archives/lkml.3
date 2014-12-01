Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaLAKTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:19:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbaLAKRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:17:25 -0500
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Cc: pagupta@redhat.com, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH RFC v4 net-next 2/5] virtio_net: bql
Date: Mon,  1 Dec 2014 18:17:05 +0800
Message-Id: <1417429028-11971-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1417429028-11971-1-git-send-email-jasowang@redhat.com>
References: <1417429028-11971-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

Improve tx batching using byte queue limits.
Should be especially effective for MQ.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f68114e..0ed24ff 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -224,6 +224,7 @@ static unsigned int free_old_xmit_skbs(struct netdev_queue *txq,
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
 	unsigned int packets = 0;
+	unsigned int bytes = 0;
 
 	while (packets < budget &&
 	       (skb = virtqueue_get_buf(sq->vq, &len)) != NULL) {
@@ -231,6 +232,7 @@ static unsigned int free_old_xmit_skbs(struct netdev_queue *txq,
 
 		u64_stats_update_begin(&stats->tx_syncp);
 		stats->tx_bytes += skb->len;
+		bytes += skb->len;
 		stats->tx_packets++;
 		u64_stats_update_end(&stats->tx_syncp);
 
@@ -238,6 +240,8 @@ static unsigned int free_old_xmit_skbs(struct netdev_queue *txq,
 		packets++;
 	}
 
+	netdev_tx_completed_queue(txq, packets, bytes);
+
 	if (sq->vq->num_free >= 2+MAX_SKB_FRAGS)
 		netif_tx_start_queue(txq);
 
@@ -964,6 +968,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	int err;
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
 	bool kick = !skb->xmit_more;
+	unsigned int bytes = skb->len;
 
 	virtqueue_disable_cb(sq->vq);
 
@@ -981,6 +986,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
+	netdev_tx_sent_queue(txq, bytes);
+
 	/* Apparently nice girls don't return TX_BUSY; stop the queue
 	 * before it gets out of hand.  Naturally, this wastes entries. */
 	if (sq->vq->num_free < 2+MAX_SKB_FRAGS)
-- 
1.8.3.1

