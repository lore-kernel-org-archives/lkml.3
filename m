Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaJTGtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbaJTGtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:49:11 -0400
Date: Mon, 20 Oct 2014 09:52:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC v3 3/3] virtio-net: optimize free_old_xmit_skbs stats
Message-ID: <1413787824-16130-4-git-send-email-mst@redhat.com>
References: <1413787824-16130-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413787824-16130-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

We already have counters for sent packets and sent bytes.
Use them to reduce the number of u64_stats_update_begin/end().

Take care not to bother with stats update when called
speculatively.

Based on a patch by Jason Wang.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b83d39d..c2b69f8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -233,16 +233,22 @@ static unsigned int free_old_xmit_skbs(struct netdev_queue *txq,
 	       (skb = virtqueue_get_buf(sq->vq, &len)) != NULL) {
 		pr_debug("Sent skb %p\n", skb);
 
-		u64_stats_update_begin(&stats->tx_syncp);
-		stats->tx_bytes += skb->len;
 		bytes += skb->len;
-		stats->tx_packets++;
-		u64_stats_update_end(&stats->tx_syncp);
+		packets++;
 
 		dev_kfree_skb_any(skb);
-		packets++;
 	}
 
+	/* Avoid overhead when no packets have been processed
+	 * happens when called speculatively from start_xmit. */
+	if (!packets)
+		return 0;
+
+	u64_stats_update_begin(&stats->tx_syncp);
+	stats->tx_bytes += bytes;
+	stats->tx_packets += packets;
+	u64_stats_update_end(&stats->tx_syncp);
+
 	netdev_tx_completed_queue(txq, packets, bytes);
 
 	if (sq->vq->num_free >= 2+MAX_SKB_FRAGS)
-- 
MST

