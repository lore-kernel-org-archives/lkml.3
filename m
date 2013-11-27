Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3K0Q2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:28:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab3K0Q2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:28:13 -0500
Date: Wed, 27 Nov 2013 18:31:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>, Jason Wang <jasowang@redhat.com>
Subject: [PATCH 2/2] virtio-net: make all RX paths handle erors consistently
Message-ID: <1385569684-26595-2-git-send-email-mst@redhat.com>
References: <1385569684-26595-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385569684-26595-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

receive mergeable now handles errors internally.
Do same for big and small packet paths, otherwise
the logic is too hard to follow.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

While I can't point at a bug this fixes, I'm not sure
there's no bug in the existing logic.
So not exactly a bug fix bug I think it's justified for net.

 drivers/net/virtio_net.c | 53 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0e6ea69..97c6212 100644
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
@@ -407,23 +436,15 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
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

