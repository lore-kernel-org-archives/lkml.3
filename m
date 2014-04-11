Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422869AbaDKQjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:39:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759599AbaDKQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 43/65] virtio-net: correct error handling of virtqueue_kick()
Date: Fri, 11 Apr 2014 09:11:15 -0700
Message-Id: <20140411161003.625009111@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 681daee2443291419c57cccb0671f5f94a839005 ]

Current error handling of virtqueue_kick() was wrong in two places:
- The skb were freed immediately when virtqueue_kick() fail during
  xmit. This may lead double free since the skb was not detached from
  the virtqueue.
- try_fill_recv() returns false when virtqueue_kick() fail. This will
  lead unnecessary rescheduling of refill work.

Actually, it's safe to just ignore the kick failure in those two
places. So this patch fixes this by partially revert commit
67975901183799af8e93ec60e322f9e2a1940b9b.

Fixes 67975901183799af8e93ec60e322f9e2a1940b9b
(virtio_net: verify if virtqueue_kick() succeeded).

Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -633,8 +633,7 @@ static bool try_fill_recv(struct receive
 	} while (rq->vq->num_free);
 	if (unlikely(rq->num > rq->max))
 		rq->max = rq->num;
-	if (unlikely(!virtqueue_kick(rq->vq)))
-		return false;
+	virtqueue_kick(rq->vq);
 	return !oom;
 }
 
@@ -840,7 +839,7 @@ static netdev_tx_t start_xmit(struct sk_
 	err = xmit_skb(sq, skb);
 
 	/* This should not happen! */
-	if (unlikely(err) || unlikely(!virtqueue_kick(sq->vq))) {
+	if (unlikely(err)) {
 		dev->stats.tx_fifo_errors++;
 		if (net_ratelimit())
 			dev_warn(&dev->dev,
@@ -849,6 +848,7 @@ static netdev_tx_t start_xmit(struct sk_
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
+	virtqueue_kick(sq->vq);
 
 	/* Don't wait up for transmitted skbs to be freed. */
 	skb_orphan(skb);


