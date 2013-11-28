Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab3K1L1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:27:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab3K1L1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:27:45 -0500
Date: Thu, 28 Nov 2013 13:30:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/2] virtio-net: make all RX paths handle erors
 consistently
Message-ID: <1385638044-27467-2-git-send-email-mst@redhat.com>
References: <1385638044-27467-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385638044-27467-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

receive mergeable now handles errors internally.
Do same for big and small packet paths, otherwise
the logic is too hard to follow.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---

I don't see a bug in current code but I think it's still
a good idea to queue this in 3.13, for consistency.

 drivers/net/virtio_net.c | 54 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5408de6..4b01946 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -299,6 +299,35 @@ static struct sk_buff *page_to_skb(struct receive_queue *rq,
 	return skb;
 }
 
+static struct sk_buff *receive_small(void *buf, unsigned int len)
+{
+	struct sk_buff * skb = buf;
+
+	len -= sizeof(struct virtio_net_hdr);
+	skb_trim(skb, len);
+
+	return skb;
+}
+
+static struct sk_buff *receive_big(struct net_device *dev,
+				   struct receive_queue *rq,
+				   void *buf,
+				   unsigned int len)
+{
+	struct page *page = buf;
+	struct sk_buff *skb = page_to_skb(rq, page, 0, len, PAGE_SIZE);
+
+	if (unlikely(!skb))
+		goto err;
+
+	return skb;
+
+err:
+	dev->stats.rx_dropped++;
+	give_pages(rq, page);
+	return NULL;
+}
+
 static struct sk_buff *receive_mergeable(struct net_device *dev,
 					 struct receive_queue *rq,
 					 void *buf,
@@ -392,7 +421,6 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
 	struct net_device *dev = vi->dev;
 	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
 	struct sk_buff *skb;
-	struct page *page;
 	struct skb_vnet_hdr *hdr;
 
 	if (unlikely(len < sizeof(struct virtio_net_hdr) + ETH_HLEN)) {
@@ -407,23 +435,15 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
 		return;
 	}
 
-	if (!vi->mergeable_rx_bufs && !vi->big_packets) {
-		skb = buf;
-		len -= sizeof(struct virtio_net_hdr);
-		skb_trim(skb, len);
-	} else if (vi->mergeable_rx_bufs) {
+	if (vi->mergeable_rx_bufs)
 		skb = receive_mergeable(dev, rq, buf, len);
-		if (unlikely(!skb))
-			return;
-	} else {
-		page = buf;
-		skb = page_to_skb(rq, page, 0, len, PAGE_SIZE);
-		if (unlikely(!skb)) {
-			dev->stats.rx_dropped++;
-			give_pages(rq, page);
-			return;
-		}
-	}
+	else if (vi->big_packets)
+		skb = receive_big(dev, rq, buf, len);
+	else
+		skb = receive_small(buf, len);
+
+	if (unlikely(!skb))
+		return;
 
 	hdr = skb_vnet_hdr(skb);
 
-- 
MST

