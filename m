Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaANA5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:57:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaANA1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 3.10 30/62] virtio_net: fix error handling for mergeable buffers
Date: Mon, 13 Jan 2014 16:26:55 -0800
Message-Id: <20140114002711.320522560@linuxfoundation.org>
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

Eric Dumazet noticed that if we encounter an error
when processing a mergeable buffer, we don't
dequeue all of the buffers from this packet,
the result is almost sure to be loss of networking.

Fix this issue.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael Dalton <mwdalton@google.com>
Acked-by: Michael Dalton <mwdalton@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
(cherry picked from commit 8fc3b9e9a229778e5af3aa453c44f1a3857ba769)
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   66 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 20 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -294,26 +294,33 @@ static struct sk_buff *page_to_skb(struc
 	return skb;
 }
 
-static int receive_mergeable(struct receive_queue *rq, struct sk_buff *skb)
+static struct sk_buff *receive_mergeable(struct net_device *dev,
+					 struct receive_queue *rq,
+					 void *buf,
+					 unsigned int len)
 {
-	struct skb_vnet_hdr *hdr = skb_vnet_hdr(skb);
-	struct page *page;
-	int num_buf, i, len;
+	struct skb_vnet_hdr *hdr = page_address(buf);
+	int num_buf = hdr->mhdr.num_buffers;
+	struct page *page = buf;
+	struct sk_buff *skb = page_to_skb(rq, page, len);
+	int i;
+
+	if (unlikely(!skb))
+		goto err_skb;
 
-	num_buf = hdr->mhdr.num_buffers;
 	while (--num_buf) {
 		i = skb_shinfo(skb)->nr_frags;
 		if (i >= MAX_SKB_FRAGS) {
 			pr_debug("%s: packet too long\n", skb->dev->name);
 			skb->dev->stats.rx_length_errors++;
-			return -EINVAL;
+			return NULL;
 		}
 		page = virtqueue_get_buf(rq->vq, &len);
 		if (!page) {
-			pr_debug("%s: rx error: %d buffers missing\n",
-				 skb->dev->name, hdr->mhdr.num_buffers);
-			skb->dev->stats.rx_length_errors++;
-			return -EINVAL;
+			pr_debug("%s: rx error: %d buffers %d missing\n",
+				 dev->name, hdr->mhdr.num_buffers, num_buf);
+			dev->stats.rx_length_errors++;
+			goto err_buf;
 		}
 
 		if (len > PAGE_SIZE)
@@ -323,7 +330,25 @@ static int receive_mergeable(struct rece
 
 		--rq->num;
 	}
-	return 0;
+	return skb;
+err_skb:
+	give_pages(rq, page);
+	while (--num_buf) {
+		buf = virtqueue_get_buf(rq->vq, &len);
+		if (unlikely(!buf)) {
+			pr_debug("%s: rx error: %d buffers missing\n",
+				 dev->name, num_buf);
+			dev->stats.rx_length_errors++;
+			break;
+		}
+		page = buf;
+		give_pages(rq, page);
+		--rq->num;
+	}
+err_buf:
+	dev->stats.rx_dropped++;
+	dev_kfree_skb(skb);
+	return NULL;
 }
 
 static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
@@ -351,17 +376,18 @@ static void receive_buf(struct receive_q
 		skb_trim(skb, len);
 	} else {
 		page = buf;
-		skb = page_to_skb(rq, page, len);
-		if (unlikely(!skb)) {
-			dev->stats.rx_dropped++;
-			give_pages(rq, page);
-			return;
-		}
-		if (vi->mergeable_rx_bufs)
-			if (receive_mergeable(rq, skb)) {
-				dev_kfree_skb(skb);
+		if (vi->mergeable_rx_bufs) {
+			skb = receive_mergeable(dev, rq, page, len);
+			if (unlikely(!skb))
+				return;
+		} else {
+			skb = page_to_skb(rq, page, len);
+			if (unlikely(!skb)) {
+				dev->stats.rx_dropped++;
+				give_pages(rq, page);
 				return;
 			}
+		}
 	}
 
 	hdr = skb_vnet_hdr(skb);


