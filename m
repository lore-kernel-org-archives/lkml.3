Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaELBzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:55:03 -0400
Received: from 1wt.eu ([62.212.114.60]:34704 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbaELBnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:15 -0400
Message-Id: <20140512003201.755592531@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 027/143] tcp: must unclone packets before mangling them
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c52e2421f7368fd36cbe330d2cf41b10452e39a9 ]

TCP stack should make sure it owns skbs before mangling them.

We had various crashes using bnx2x, and it turned out gso_size
was cleared right before bnx2x driver was populating TC descriptor
of the _previous_ packet send. TCP stack can sometime retransmit
packets that are still in Qdisc.

Of course we could make bnx2x driver more robust (using
ACCESS_ONCE(shinfo->gso_size) for example), but the bug is TCP stack.

We have identified two points where skb_unclone() was needed.

This patch adds a WARN_ON_ONCE() to warn us if we missed another
fix of this kind.

Kudos to Neal for finding the root cause of this bug. Its visible
using small MSS.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/ipv4/tcp_output.c  |  9 ++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4e647bb..ae77862 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -641,6 +641,16 @@ static inline int skb_cloned(const struct sk_buff *skb)
 	       (atomic_read(&skb_shinfo(skb)->dataref) & SKB_DATAREF_MASK) != 1;
 }
 
+static inline int skb_unclone(struct sk_buff *skb, gfp_t pri)
+{
+	might_sleep_if(pri & __GFP_WAIT);
+
+	if (skb_cloned(skb))
+		return pskb_expand_head(skb, 0, 0, pri);
+
+	return 0;
+}
+
 /**
  *	skb_header_cloned - is the header a clone
  *	@skb: buffer to check
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 38a23e4..49da29e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -744,6 +744,9 @@ static void tcp_queue_skb(struct sock *sk, struct sk_buff *skb)
 static void tcp_set_skb_tso_segs(struct sock *sk, struct sk_buff *skb,
 				 unsigned int mss_now)
 {
+	/* Make sure we own this skb before messing gso_size/gso_segs */
+	WARN_ON_ONCE(skb_cloned(skb));
+
 	if (skb->len <= mss_now || !sk_can_gso(sk) ||
 	    skb->ip_summed == CHECKSUM_NONE) {
 		/* Avoid the costly divide in the normal
@@ -824,9 +827,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (skb_cloned(skb) &&
-	    skb_is_nonlinear(skb) &&
-	    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
@@ -1932,6 +1933,8 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 		int oldpcount = tcp_skb_pcount(skb);
 
 		if (unlikely(oldpcount > 1)) {
+			if (skb_unclone(skb, GFP_ATOMIC))
+				return -ENOMEM;
 			tcp_init_tso_segs(sk, skb, cur_mss);
 			tcp_adjust_pcount(sk, skb, oldpcount - tcp_skb_pcount(skb));
 		}
-- 
1.7.12.2.21.g234cd45.dirty



