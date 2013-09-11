Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3ILFks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:40:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3ILFko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:40:44 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=o0XBl3Y7Yq0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=V8evxG79gNcA:10 a=iox4zFpeAAAA:8 a=tHz9FfFoAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=8IsVUKzTTlyunI_23dgA:9 a=n9GBPR9yFnkA:10 a=6O0IECtVFhoA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042908.648069941@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Beulich <jbeulich@suse.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [098/251] xen-netfront: pull on receive skb may need to happen earlier
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0098-xen-netfront-pull-on-receive-skb-may-need-to-happen-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

[ Upstream commit 093b9c71b6e450e375f4646ba86faed0195ec7df ]

Due to commit 3683243b ("xen-netfront: use __pskb_pull_tail to ensure
linear area is big enough on RX") xennet_fill_frags() may end up
filling MAX_SKB_FRAGS + 1 fragments in a receive skb, and only reduce
the fragment count subsequently via __pskb_pull_tail(). That's a
result of xennet_get_responses() allowing a maximum of one more slot to
be consumed (and intermediately transformed into a fragment) if the
head slot has a size less than or equal to RX_COPY_THRESHOLD.

Hence we need to adjust xennet_fill_frags() to pull earlier if we
reached the maximum fragment count - due to the described behavior of
xennet_get_responses() this guarantees that at least the first fragment
will get completely consumed, and hence the fragment count reduced.

In order to not needlessly call __pskb_pull_tail() twice, make the
original call conditional upon the pull target not having been reached
yet, and defer the newly added one as much as possible (an alternative
would have been to always call the function right before the call to
xennet_fill_frags(), but that would imply more frequent cases of
needing to call it twice).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Wei Liu <wei.liu2@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: stable@vger.kernel.org (3.6 onwards)
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/xen-netfront.c |   50 ++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 37 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index ecac034..110c26c 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -275,8 +275,7 @@ no_skb:
 			break;
 		}
 
-		__skb_fill_page_desc(skb, 0, page, 0, 0);
-		skb_shinfo(skb)->nr_frags = 1;
+		skb_add_rx_frag(skb, 0, page, 0, 0, PAGE_SIZE);
 		__skb_queue_tail(&np->rx_batch, skb);
 	}
 
@@ -771,7 +770,6 @@ static RING_IDX xennet_fill_frags(struct netfront_info *np,
 				  struct sk_buff_head *list)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
-	int nr_frags = shinfo->nr_frags;
 	RING_IDX cons = np->rx.rsp_cons;
 	struct sk_buff *nskb;
 
@@ -780,19 +778,21 @@ static RING_IDX xennet_fill_frags(struct netfront_info *np,
 			RING_GET_RESPONSE(&np->rx, ++cons);
 		skb_frag_t *nfrag = &skb_shinfo(nskb)->frags[0];
 
-		__skb_fill_page_desc(skb, nr_frags,
-				     skb_frag_page(nfrag),
-				     rx->offset, rx->status);
+		if (shinfo->nr_frags == MAX_SKB_FRAGS) {
+			unsigned int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
 
-		skb->data_len += rx->status;
+			BUG_ON(pull_to <= skb_headlen(skb));
+			__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
+		}
+		BUG_ON(shinfo->nr_frags >= MAX_SKB_FRAGS);
+
+		skb_add_rx_frag(skb, shinfo->nr_frags, skb_frag_page(nfrag),
+				rx->offset, rx->status, PAGE_SIZE);
 
 		skb_shinfo(nskb)->nr_frags = 0;
 		kfree_skb(nskb);
-
-		nr_frags++;
 	}
 
-	shinfo->nr_frags = nr_frags;
 	return cons;
 }
 
@@ -878,7 +878,8 @@ static int handle_incoming_queue(struct net_device *dev,
 	while ((skb = __skb_dequeue(rxq)) != NULL) {
 		int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
 
-		__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
+		if (pull_to > skb_headlen(skb))
+			__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
 
 		/* Ethernet work: Delayed to here as it peeks the header. */
 		skb->protocol = eth_type_trans(skb, dev);
@@ -964,35 +965,10 @@ err:
 		skb_shinfo(skb)->frags[0].page_offset = rx->offset;
 		skb_frag_size_set(&skb_shinfo(skb)->frags[0], rx->status);
 		skb->data_len = rx->status;
+		skb->len += rx->status;
 
 		i = xennet_fill_frags(np, skb, &tmpq);
 
-		/*
-		 * Truesize approximates the size of true data plus
-		 * any supervisor overheads. Adding hypervisor
-		 * overheads has been shown to significantly reduce
-		 * achievable bandwidth with the default receive
-		 * buffer size. It is therefore not wise to account
-		 * for it here.
-		 *
-		 * After alloc_skb(RX_COPY_THRESHOLD), truesize is set
-		 * to RX_COPY_THRESHOLD + the supervisor
-		 * overheads. Here, we add the size of the data pulled
-		 * in xennet_fill_frags().
-		 *
-		 * We also adjust for any unused space in the main
-		 * data area by subtracting (RX_COPY_THRESHOLD -
-		 * len). This is especially important with drivers
-		 * which split incoming packets into header and data,
-		 * using only 66 bytes of the main data area (see the
-		 * e1000 driver for example.)  On such systems,
-		 * without this last adjustement, our achievable
-		 * receive throughout using the standard receive
-		 * buffer size was cut by 25%(!!!).
-		 */
-		skb->truesize += skb->data_len - RX_COPY_THRESHOLD;
-		skb->len += skb->data_len;
-
 		if (rx->flags & XEN_NETRXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;
 		else if (rx->flags & XEN_NETRXF_data_validated)
-- 
1.7.10.4


