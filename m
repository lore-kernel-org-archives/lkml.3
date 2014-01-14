Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaANA4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:56:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaANA1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Dalton <mwdalton@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 3.10 31/62] virtio-net: make all RX paths handle errors consistently
Date: Mon, 13 Jan 2014 16:26:56 -0800
Message-Id: <20140114002711.351847425@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

receive mergeable now handles errors internally.
Do same for big and small packet paths, otherwise
the logic is too hard to follow.

Cc: Jason Wang <jasowang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Michael Dalton <mwdalton@google.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
(cherry picked from commit f121159d72091f25afb22007c833e60a6845e912)
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   56 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 20 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -294,6 +294,34 @@ static struct sk_buff *page_to_skb(struc
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
@@ -357,7 +385,6 @@ static void receive_buf(struct receive_q
 	struct net_device *dev = vi->dev;
 	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
 	struct sk_buff *skb;
-	struct page *page;
 	struct skb_vnet_hdr *hdr;
 
 	if (unlikely(len < sizeof(struct virtio_net_hdr) + ETH_HLEN)) {
@@ -369,26 +396,15 @@ static void receive_buf(struct receive_q
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
 


