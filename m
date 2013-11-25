Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab3KYO3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:29:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58829 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335Ab3KYNxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:35 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yuchung Cheng" <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Eric Dumazet" <edumazet@google.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.372799186@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 01/87] tcp: must unclone packets before mangling them
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/ipv4/tcp_output.c  |  9 ++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index efe50af..6978936 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -737,6 +737,16 @@ static inline int skb_cloned(const struct sk_buff *skb)
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
index 3add486..0d5a118 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -933,6 +933,9 @@ static void tcp_queue_skb(struct sock *sk, struct sk_buff *skb)
 static void tcp_set_skb_tso_segs(const struct sock *sk, struct sk_buff *skb,
 				 unsigned int mss_now)
 {
+	/* Make sure we own this skb before messing gso_size/gso_segs */
+	WARN_ON_ONCE(skb_cloned(skb));
+
 	if (skb->len <= mss_now || !sk_can_gso(sk) ||
 	    skb->ip_summed == CHECKSUM_NONE) {
 		/* Avoid the costly divide in the normal
@@ -1014,9 +1017,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (skb_cloned(skb) &&
-	    skb_is_nonlinear(skb) &&
-	    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
@@ -2129,6 +2130,8 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 		int oldpcount = tcp_skb_pcount(skb);
 
 		if (unlikely(oldpcount > 1)) {
+			if (skb_unclone(skb, GFP_ATOMIC))
+				return -ENOMEM;
 			tcp_init_tso_segs(sk, skb, cur_mss);
 			tcp_adjust_pcount(sk, skb, oldpcount - tcp_skb_pcount(skb));
 		}

