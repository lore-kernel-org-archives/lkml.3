Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab3BGMYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:24:22 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:57562 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758382Ab3BGMW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:22:58 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 6/8] virtio-net: unmark scatterlist ending after virtqueue_add_buf
Date: Thu,  7 Feb 2013 13:22:30 +0100
Message-Id: <1360239752-2470-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for when virtqueue_add_buf will use sg_next instead of
ignoring ending markers.

Note that for_each_sg (and thus virtqueue_add_buf) allows you
to pass a "truncated" scatterlist that does not have a marker
on the last item.  We rely on this in add_recvbuf_mergeable.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	This is the only part that survived of Rusty's ideas. :)

 drivers/net/virtio_net.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 35c00c5..ce08b54 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -440,13 +440,17 @@ static int add_recvbuf_small(struct receive_queue *rq, gfp_t gfp)
 
 	hdr = skb_vnet_hdr(skb);
 	sg_set_buf(rq->sg, &hdr->hdr, sizeof hdr->hdr);
-
 	skb_to_sgvec(skb, rq->sg + 1, 0, skb->len);
 
 	err = virtqueue_add_buf(rq->vq, rq->sg, 0, 2, skb, gfp);
 	if (err < 0)
 		dev_kfree_skb(skb);
 
+	/*
+	 * An optimization: clear the end bit set by skb_to_sgvec, so
+	 * we can simply re-use rq->sg[] next time.
+	 */
+	sg_unmark_end(rq->sg + 1);
 	return err;
 }
 
@@ -505,8 +509,7 @@ static int add_recvbuf_mergeable(struct receive_queue *rq, gfp_t gfp)
 	if (!page)
 		return -ENOMEM;
 
-	sg_init_one(rq->sg, page_address(page), PAGE_SIZE);
-
+	sg_set_page(rq->sg, page, PAGE_SIZE, 0);
 	err = virtqueue_add_buf(rq->vq, rq->sg, 0, 1, page, gfp);
 	if (err < 0)
 		give_pages(rq, page);
@@ -671,6 +674,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	unsigned num_sg;
+	int ret;
 
 	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
 
@@ -710,8 +714,15 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 		sg_set_buf(sq->sg, &hdr->hdr, sizeof hdr->hdr);
 
 	num_sg = skb_to_sgvec(skb, sq->sg + 1, 0, skb->len) + 1;
-	return virtqueue_add_buf(sq->vq, sq->sg, num_sg,
-				 0, skb, GFP_ATOMIC);
+	ret = virtqueue_add_buf(sq->vq, sq->sg, num_sg,
+				0, skb, GFP_ATOMIC);
+
+	/*
+	 * An optimization: clear the end bit set by skb_to_sgvec, so
+	 * we can simply re-use sq->sg[] next time.
+	 */
+	sg_unmark_end(&sq->sg[num_sg-1]);
+	return ret;
 }
 
 static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
-- 
1.7.1


