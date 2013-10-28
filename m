Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3J1Ote (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:49:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51186 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab3J1Ot0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 37/64] tcp: must unclone packets before mangling them
Date: Mon, 28 Oct 2013 14:47:56 +0000
Message-Id: <1382971703-17393-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit c52e2421f7368fd36cbe330d2cf41b10452e39a9 upstream.

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
[ luis: backported to 3.5, using davem's port to 3.4:
  - skb_unclone() function definition to include/linux/skbuff.h ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/ipv4/tcp_output.c  |  9 ++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e1c1e64..0ec4788 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -774,6 +774,16 @@ static inline int skb_cloned(const struct sk_buff *skb)
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
index 4a1e840..d06b130 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -934,6 +934,9 @@ static void tcp_queue_skb(struct sock *sk, struct sk_buff *skb)
 static void tcp_set_skb_tso_segs(const struct sock *sk, struct sk_buff *skb,
 				 unsigned int mss_now)
 {
+	/* Make sure we own this skb before messing gso_size/gso_segs */
+	WARN_ON_ONCE(skb_cloned(skb));
+
 	if (skb->len <= mss_now || !sk_can_gso(sk) ||
 	    skb->ip_summed == CHECKSUM_NONE) {
 		/* Avoid the costly divide in the normal
@@ -1015,9 +1018,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (skb_cloned(skb) &&
-	    skb_is_nonlinear(skb) &&
-	    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
@@ -2150,6 +2151,8 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 		int oldpcount = tcp_skb_pcount(skb);
 
 		if (unlikely(oldpcount > 1)) {
+			if (skb_unclone(skb, GFP_ATOMIC))
+				return -ENOMEM;
 			tcp_init_tso_segs(sk, skb, cur_mss);
 			tcp_adjust_pcount(sk, skb, oldpcount - tcp_skb_pcount(skb));
 		}
-- 
1.8.3.2

