Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaAMQLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:11:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaAMQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Michael Dalton <mwdalton@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 189/208] virtio_net: fix error handling for mergeable buffers
Date: Mon, 13 Jan 2014 16:00:30 +0000
Message-Id: <1389628849-1614-190-git-send-email-luis.henriques@canonical.com>
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

commit 8fc3b9e9a229778e5af3aa453c44f1a3857ba769 upstream.

Eric Dumazet noticed that if we encounter an error
when processing a mergeable buffer, we don't
dequeue all of the buffers from this packet,
the result is almost sure to be loss of networking.

Jason Wang noticed that we also leak a page and that we don't decrement
the rq buf count, so we won't repost buffers (a resource leak).

Fix both issues.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael Dalton <mwdalton@google.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.11: used davem's backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/virtio_net.c | 66 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5055eb7..ad9b385 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -294,26 +294,33 @@ static struct sk_buff *page_to_skb(struct receive_queue *rq,
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
@@ -323,7 +330,25 @@ static int receive_mergeable(struct receive_queue *rq, struct sk_buff *skb)
 
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
@@ -351,17 +376,18 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
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
-- 
1.8.3.2

