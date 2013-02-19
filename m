Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab3BSIFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:05:24 -0500
Received: from ozlabs.org ([203.10.76.45]:41477 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251Ab3BSICs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 09/16] virtio_net: use simplified virtqueue accessors.
Date: Tue, 19 Feb 2013 18:26:27 +1030
Message-Id: <1361260594-601-10-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never add buffers with input and output parts, so use the new accessors.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/virtio_net.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index dbd5cd1..8ca69c0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -443,7 +443,7 @@ static int add_recvbuf_small(struct receive_queue *rq, gfp_t gfp)
 
 	skb_to_sgvec(skb, rq->sg + 1, 0, skb->len);
 
-	err = virtqueue_add_buf(rq->vq, rq->sg, 0, 2, skb, gfp);
+	err = virtqueue_add_inbuf(rq->vq, rq->sg, 2, skb, gfp);
 	if (err < 0)
 		dev_kfree_skb(skb);
 
@@ -488,8 +488,8 @@ static int add_recvbuf_big(struct receive_queue *rq, gfp_t gfp)
 
 	/* chain first in list head */
 	first->private = (unsigned long)list;
-	err = virtqueue_add_buf(rq->vq, rq->sg, 0, MAX_SKB_FRAGS + 2,
-				first, gfp);
+	err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
+				  first, gfp);
 	if (err < 0)
 		give_pages(rq, first);
 
@@ -507,7 +507,7 @@ static int add_recvbuf_mergeable(struct receive_queue *rq, gfp_t gfp)
 
 	sg_init_one(rq->sg, page_address(page), PAGE_SIZE);
 
-	err = virtqueue_add_buf(rq->vq, rq->sg, 0, 1, page, gfp);
+	err = virtqueue_add_inbuf(rq->vq, rq->sg, 1, page, gfp);
 	if (err < 0)
 		give_pages(rq, page);
 
@@ -710,8 +710,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 		sg_set_buf(sq->sg, &hdr->hdr, sizeof hdr->hdr);
 
 	num_sg = skb_to_sgvec(skb, sq->sg + 1, 0, skb->len) + 1;
-	return virtqueue_add_buf(sq->vq, sq->sg, num_sg,
-				 0, skb, GFP_ATOMIC);
+	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
 }
 
 static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
-- 
1.7.10.4

