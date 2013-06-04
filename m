Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3FDXAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:00:54 -0400
Received: from 1wt.eu ([62.212.114.60]:35679 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab3FDWnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:11 -0400
Message-Id: <20130604172137.222275043@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 167/184] ipv6: discard overlapping fragment
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 70789d7052239992824628db8133de08dc78e593 upstream

RFC5722 prohibits reassembling fragments when some data overlaps.

Bug spotted by Zhang Zuotao <zuotao.zhang@6wind.com>.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/reassembly.c | 74 +++++++++++----------------------------------------
 1 file changed, 15 insertions(+), 59 deletions(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 4d18699..105de22 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -148,16 +148,6 @@ int ip6_frag_match(struct inet_frag_queue *q, void *a)
 }
 EXPORT_SYMBOL(ip6_frag_match);
 
-/* Memory Tracking Functions. */
-static inline void frag_kfree_skb(struct netns_frags *nf,
-		struct sk_buff *skb, int *work)
-{
-	if (work)
-		*work -= skb->truesize;
-	atomic_sub(skb->truesize, &nf->mem);
-	kfree_skb(skb);
-}
-
 void ip6_frag_init(struct inet_frag_queue *q, void *a)
 {
 	struct frag_queue *fq = container_of(q, struct frag_queue, q);
@@ -348,58 +338,22 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 		prev = next;
 	}
 
-	/* We found where to put this one.  Check for overlap with
-	 * preceding fragment, and, if needed, align things so that
-	 * any overlaps are eliminated.
+	/* RFC5722, Section 4:
+	 *                                  When reassembling an IPv6 datagram, if
+	 *   one or more its constituent fragments is determined to be an
+	 *   overlapping fragment, the entire datagram (and any constituent
+	 *   fragments, including those not yet received) MUST be silently
+	 *   discarded.
 	 */
-	if (prev) {
-		int i = (FRAG6_CB(prev)->offset + prev->len) - offset;
 
-		if (i > 0) {
-			offset += i;
-			if (end <= offset)
-				goto err;
-			if (!pskb_pull(skb, i))
-				goto err;
-			if (skb->ip_summed != CHECKSUM_UNNECESSARY)
-				skb->ip_summed = CHECKSUM_NONE;
-		}
-	}
+	/* Check for overlap with preceding fragment. */
+	if (prev &&
+	    (FRAG6_CB(prev)->offset + prev->len) - offset > 0)
+		goto discard_fq;
 
-	/* Look for overlap with succeeding segments.
-	 * If we can merge fragments, do it.
-	 */
-	while (next && FRAG6_CB(next)->offset < end) {
-		int i = end - FRAG6_CB(next)->offset; /* overlap is 'i' bytes */
-
-		if (i < next->len) {
-			/* Eat head of the next overlapped fragment
-			 * and leave the loop. The next ones cannot overlap.
-			 */
-			if (!pskb_pull(next, i))
-				goto err;
-			FRAG6_CB(next)->offset += i;	/* next fragment */
-			fq->q.meat -= i;
-			if (next->ip_summed != CHECKSUM_UNNECESSARY)
-				next->ip_summed = CHECKSUM_NONE;
-			break;
-		} else {
-			struct sk_buff *free_it = next;
-
-			/* Old fragment is completely overridden with
-			 * new one drop it.
-			 */
-			next = next->next;
-
-			if (prev)
-				prev->next = next;
-			else
-				fq->q.fragments = next;
-
-			fq->q.meat -= free_it->len;
-			frag_kfree_skb(fq->q.net, free_it, NULL);
-		}
-	}
+	/* Look for overlap with succeeding segment. */
+	if (next && FRAG6_CB(next)->offset < end)
+		goto discard_fq;
 
 	FRAG6_CB(skb)->offset = offset;
 
@@ -436,6 +390,8 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 	write_unlock(&ip6_frags.lock);
 	return -1;
 
+discard_fq:
+	fq_kill(fq);
 err:
 	IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
 		      IPSTATS_MIB_REASMFAILS);
-- 
1.7.12.2.21.g234cd45.dirty



