Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab3LFVw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab3LFVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Paasch <christoph.paasch@uclouvain.be>,
        Jerry Chu <hkchu@google.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 46/83] gso: handle new frag_list of frags GRO packets
Date: Fri,  6 Dec 2013 13:51:36 -0800
Message-Id: <20131206214644.342967610@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 9d8506cc2d7ea1f911c72c100193a3677f6668c3 ]

Recently GRO started generating packets with frag_lists of frags.
This was not handled by GSO, thus leading to a crash.

Thankfully these packets are of a regular form and are easy to
handle.  This patch handles them in two ways.  For completely
non-linear frag_list entries, we simply continue to iterate over
the frag_list frags once we exhaust the normal frags.  For frag_list
entries with linear parts, we call pskb_trim on the first part
of the frag_list skb, and then process the rest of the frags in
the usual way.

This patch also kills a chunk of dead frag_list code that has
obviously never ever been run since it ends up generating a bogus
GSO-segmented packet with a frag_list entry.

Future work is planned to split super big packets into TSO
ones.

Fixes: 8a29111c7ca6 ("net: gro: allow to build full sized skb")
Reported-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Reported-by: Jerry Chu <hkchu@google.com>
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Tested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   75 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 25 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2755,6 +2755,7 @@ struct sk_buff *skb_segment(struct sk_bu
 	struct sk_buff *segs = NULL;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *fskb = skb_shinfo(skb)->frag_list;
+	skb_frag_t *skb_frag = skb_shinfo(skb)->frags;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 	unsigned int doffset = skb->data - skb_mac_header(skb);
 	unsigned int offset = doffset;
@@ -2794,16 +2795,38 @@ struct sk_buff *skb_segment(struct sk_bu
 		if (hsize > len || !sg)
 			hsize = len;
 
-		if (!hsize && i >= nfrags) {
-			BUG_ON(fskb->len != len);
+		if (!hsize && i >= nfrags && skb_headlen(fskb) &&
+		    (skb_headlen(fskb) == len || sg)) {
+			BUG_ON(skb_headlen(fskb) > len);
+
+			i = 0;
+			nfrags = skb_shinfo(fskb)->nr_frags;
+			skb_frag = skb_shinfo(fskb)->frags;
+			pos += skb_headlen(fskb);
+
+			while (pos < offset + len) {
+				BUG_ON(i >= nfrags);
+
+				size = skb_frag_size(skb_frag);
+				if (pos + size > offset + len)
+					break;
+
+				i++;
+				pos += size;
+				skb_frag++;
+			}
 
-			pos += len;
 			nskb = skb_clone(fskb, GFP_ATOMIC);
 			fskb = fskb->next;
 
 			if (unlikely(!nskb))
 				goto err;
 
+			if (unlikely(pskb_trim(nskb, len))) {
+				kfree_skb(nskb);
+				goto err;
+			}
+
 			hsize = skb_end_offset(nskb);
 			if (skb_cow_head(nskb, doffset + headroom)) {
 				kfree_skb(nskb);
@@ -2847,7 +2870,7 @@ struct sk_buff *skb_segment(struct sk_bu
 						 nskb->data - tnl_hlen,
 						 doffset + tnl_hlen);
 
-		if (fskb != skb_shinfo(skb)->frag_list)
+		if (nskb->len == len + doffset)
 			goto perform_csum_check;
 
 		if (!sg) {
@@ -2865,8 +2888,28 @@ struct sk_buff *skb_segment(struct sk_bu
 
 		skb_shinfo(nskb)->tx_flags = skb_shinfo(skb)->tx_flags & SKBTX_SHARED_FRAG;
 
-		while (pos < offset + len && i < nfrags) {
-			*frag = skb_shinfo(skb)->frags[i];
+		while (pos < offset + len) {
+			if (i >= nfrags) {
+				BUG_ON(skb_headlen(fskb));
+
+				i = 0;
+				nfrags = skb_shinfo(fskb)->nr_frags;
+				skb_frag = skb_shinfo(fskb)->frags;
+
+				BUG_ON(!nfrags);
+
+				fskb = fskb->next;
+			}
+
+			if (unlikely(skb_shinfo(nskb)->nr_frags >=
+				     MAX_SKB_FRAGS)) {
+				net_warn_ratelimited(
+					"skb_segment: too many frags: %u %u\n",
+					pos, mss);
+				goto err;
+			}
+
+			*frag = *skb_frag;
 			__skb_frag_ref(frag);
 			size = skb_frag_size(frag);
 
@@ -2879,6 +2922,7 @@ struct sk_buff *skb_segment(struct sk_bu
 
 			if (pos + size <= offset + len) {
 				i++;
+				skb_frag++;
 				pos += size;
 			} else {
 				skb_frag_size_sub(frag, pos + size - (offset + len));
@@ -2888,25 +2932,6 @@ struct sk_buff *skb_segment(struct sk_bu
 			frag++;
 		}
 
-		if (pos < offset + len) {
-			struct sk_buff *fskb2 = fskb;
-
-			BUG_ON(pos + fskb->len != offset + len);
-
-			pos += fskb->len;
-			fskb = fskb->next;
-
-			if (fskb2->next) {
-				fskb2 = skb_clone(fskb2, GFP_ATOMIC);
-				if (!fskb2)
-					goto err;
-			} else
-				skb_get(fskb2);
-
-			SKB_FRAG_ASSERT(nskb);
-			skb_shinfo(nskb)->frag_list = fskb2;
-		}
-
 skip_fraglist:
 		nskb->data_len = len - hsize;
 		nskb->len += nskb->data_len;


