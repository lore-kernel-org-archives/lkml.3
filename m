Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbaAMQLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:11:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbaAMQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 190/208] virtio-net: make all RX paths handle errors consistently
Date: Mon, 13 Jan 2014 16:00:31 +0000
Message-Id: <1389628849-1614-191-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit f121159d72091f25afb22007c833e60a6845e912 upstream.

receive mergeable now handles errors internally.
Do same for big and small packet paths, otherwise
the logic is too hard to follow.

Cc: Jason Wang <jasowang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Michael Dalton <mwdalton@google.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/virtio_net.c | 56 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ad9b385..ec0e9f2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -294,6 +294,34 @@ static struct sk_buff *page_to_skb(struct receive_queue *rq,
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
@@ -357,7 +385,6 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
 	struct net_device *dev = vi->dev;
 	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
 	struct sk_buff *skb;
-	struct page *page;
 	struct skb_vnet_hdr *hdr;
 
 	if (unlikely(len < sizeof(struct virtio_net_hdr) + ETH_HLEN)) {
@@ -369,26 +396,15 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
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
1.8.3.2

