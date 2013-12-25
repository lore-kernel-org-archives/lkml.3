Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3LYOwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 09:52:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3LYOwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 09:52:32 -0500
Date: Wed, 25 Dec 2013 16:56:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Rusty Russell <rusty@rustcorp.com.au>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH stable 2/2] virtio-net: make all RX paths handle erors
 consistently
Message-ID: <1387983339-1172-3-git-send-email-mst@redhat.com>
References: <1387983339-1172-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387983339-1172-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

receive mergeable now handles errors internally.
Do same for big and small packet paths, otherwise
the logic is too hard to follow.

Cc: Jason Wang <jasowang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

(cherry picked from commit f121159d72091f25afb22007c833e60a6845e912)
---
 drivers/net/virtio_net.c | 56 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 435076f..c0ed6d5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -297,6 +297,34 @@ static struct sk_buff *page_to_skb(struct receive_queue *rq,
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
+				   void *buf)
+{
+	struct page *page = buf;
+	struct sk_buff *skb = page_to_skb(rq, page, 0);
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
@@ -360,7 +388,6 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
 	struct net_device *dev = vi->dev;
 	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
 	struct sk_buff *skb;
-	struct page *page;
 	struct skb_vnet_hdr *hdr;
 
 	if (unlikely(len < sizeof(struct virtio_net_hdr) + ETH_HLEN)) {
@@ -372,26 +399,15 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
 			dev_kfree_skb(buf);
 		return;
 	}
+	if (vi->mergeable_rx_bufs)
+		skb = receive_mergeable(dev, rq, buf, len);
+	else if (vi->big_packets)
+		skb = receive_big(dev, rq, buf);
+	else
+		skb = receive_small(buf, len);
 
-	if (!vi->mergeable_rx_bufs && !vi->big_packets) {
-		skb = buf;
-		len -= sizeof(struct virtio_net_hdr);
-		skb_trim(skb, len);
-	} else {
-		page = buf;
-		if (vi->mergeable_rx_bufs) {
-			skb = receive_mergeable(dev, rq, page, len);
-			if (unlikely(!skb))
-				return;
-		} else {
-			skb = page_to_skb(rq, page, len);
-			if (unlikely(!skb)) {
-				dev->stats.rx_dropped++;
-				give_pages(rq, page);
-				return;
-			}
-		}
-	}
+	if (unlikely(!skb))
+		return;
 
 	hdr = skb_vnet_hdr(skb);
 
-- 
MST

