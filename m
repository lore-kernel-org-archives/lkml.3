Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3KTJIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:08:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab3KTJH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:07:57 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>, Shirley Ma <xma@us.ibm.com>
Subject: [PATCH net 1/3] virtio-net: drop the rest of buffers when we can't allocate skb
Date: Wed, 20 Nov 2013 17:07:25 +0800
Message-Id: <1384938447-3775-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mergeable buffer were used, we only put the first page buf leave the rest
of buffers in the virt queue. This will cause the driver could not get the
correct head buffer any more. Fix this by dropping the rest of buffers for this
packet.

The bug was introduced by commit 9ab86bbcf8be755256f0a5e994e0b38af6b4d399
(virtio_net: Defer skb allocation in receive path).

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michael Dalton <mwdalton@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Shirley Ma <xma@us.ibm.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
This patch was needed for stable
---
 drivers/net/virtio_net.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7bab4de..24fd502 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -222,6 +222,17 @@ static void skb_xmit_done(struct virtqueue *vq)
 	netif_wake_subqueue(vi->dev, vq2txq(vq));
 }
 
+static void drop_mergeable_buffer(struct receive_queue *rq, int num_buf)
+{
+	char *buf;
+	int len;
+
+	while (--num_buf && (buf = virtqueue_get_buf(rq->vq, &len)) != NULL) {
+		--rq->num;
+		put_page(virt_to_head_page(buf));
+	}
+}
+
 /* Called from bottom half context */
 static struct sk_buff *page_to_skb(struct receive_queue *rq,
 				   struct page *page, unsigned int offset,
@@ -237,8 +248,13 @@ static struct sk_buff *page_to_skb(struct receive_queue *rq,
 
 	/* copy small packet so we can reuse these pages for small data */
 	skb = netdev_alloc_skb_ip_align(vi->dev, GOOD_COPY_LEN);
-	if (unlikely(!skb))
+	if (unlikely(!skb)) {
+		if (vi->mergeable_rx_bufs) {
+			hdr = (struct skb_vnet_hdr *)p;
+			drop_mergeable_buffer(rq, hdr->mhdr.num_buffers);
+		}
 		return NULL;
+	}
 
 	hdr = skb_vnet_hdr(skb);
 
-- 
1.8.3.2

