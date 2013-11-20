Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3KTORe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:17:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3KTORb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:17:31 -0500
Date: Wed, 20 Nov 2013 16:20:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>, Shirley Ma <xma@us.ibm.com>
Subject: Re: [PATCH RFC] virtio_net: fix error handling for mergeable buffers
Message-ID: <20131120142032.GA13492@redhat.com>
References: <1384938447-3775-1-git-send-email-jasowang@redhat.com>
 <20131120132657.GA8455@redhat.com>
 <125586345.27477452.1384955642143.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <125586345.27477452.1384955642143.JavaMail.root@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:54:02AM -0500, Jason Wang wrote:
> 
> 
> ----- 原始邮件 -----
> > On Wed, Nov 20, 2013 at 05:07:25PM +0800, Jason Wang wrote:
> > > When mergeable buffer were used, we only put the first page buf leave the
> > > rest
> > > of buffers in the virt queue. This will cause the driver could not get the
> > > correct head buffer any more. Fix this by dropping the rest of buffers for
> > > this
> > > packet.
> > > 
> > > The bug was introduced by commit 9ab86bbcf8be755256f0a5e994e0b38af6b4d399
> > > (virtio_net: Defer skb allocation in receive path).
> > > 
> > > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Michael Dalton <mwdalton@google.com>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Shirley Ma <xma@us.ibm.com>
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > 
> > Just to clarify my previous comment: it was not about the
> > idea of adding drop_mergeable_buffer - rather, I think that
> > adding knowledge about mergeable buffers into page_to_skb creates an
> > ugly internal API.
> > 
> > Let's move the call to page_to_skb within receive_mergeable instead:
> > it's also nice that int offset = buf - page_address(page) logic
> > is not spread around like it was.
> > 
> > Also, it's not nice that we ignore length errors when we drop
> > packets because of OOM.
> > 
> > So I came up with the following - it seems to work but I didn't
> > stress test yet.
> 
> I've no objection on this. But I've rather like my small and direct patch 
> to be applied to -net first. It has lower risk and was much more easier to 
> be backported to stable trees. Then we can do the re-factor like this in 
> net-next. 

It makes the interfaces too messy. We are not in code freeze in -net -
only feature freeze, so no reason to make code like spagetty,
and it's only 25 lines changed as compared to 40.
It's not a huge refactoring.

It's just as easy to backport my patch too.
You just drop the goto in the new code path we added.

Let me show you (untested) - your patch is not smaller.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>



commit 9b442fe970d5c71311d4314edef26ee2eb16e7fb
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Wed Nov 20 12:44:14 2013 +0200

    virtio_net: fix resource leak on alloc failure
    
    virtio net got confused, started dropping packets.
    
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9fbdfcd..df4b9d0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -297,13 +297,22 @@ static struct sk_buff *page_to_skb(struct receive_queue *rq,
 	return skb;
 }
 
-static int receive_mergeable(struct receive_queue *rq, struct sk_buff *skb)
+static struct sk_buff *receive_mergeable(struct net_device *dev,
+					 struct receive_queue *rq,
+					 struct page *page,
+					 unsigned int len)
 {
-	struct skb_vnet_hdr *hdr = skb_vnet_hdr(skb);
-	struct page *page;
-	int num_buf, i, len;
+	struct skb_vnet_hdr *hdr = page_address(buf);
+	int num_buf = hdr->mhdr.num_buffers;
+	struct sk_buff *skb = page_to_skb(rq, page, len);
+	int i;
+
+	skb = page_to_skb(rq, page, len);
+
+	if (unlikely(!skb))
+		goto err_skb;
+
 
-	num_buf = hdr->mhdr.num_buffers;
 	while (--num_buf) {
 		i = skb_shinfo(skb)->nr_frags;
 		if (i >= MAX_SKB_FRAGS) {
@@ -313,10 +322,10 @@ static int receive_mergeable(struct receive_queue *rq, struct sk_buff *skb)
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
@@ -326,7 +335,25 @@ static int receive_mergeable(struct receive_queue *rq, struct sk_buff *skb)
 
 		--rq->num;
 	}
-	return 0;
+	return skb;
+err_skb:
+	put_page(page);
+err_buf:
+	dev->stats.rx_dropped++;
+	dev_kfree_skb(head_skb);
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
+	return NULL;
 }
 
 static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
@@ -354,17 +381,18 @@ static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
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
