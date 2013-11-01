Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3KAWHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:07:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab3KAWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:07:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 03/66] tcp: must unclone packets before mangling them
Date: Fri,  1 Nov 2013 15:06:39 -0700
Message-Id: <20131101220635.931878380@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -981,6 +981,9 @@ static void tcp_queue_skb(struct sock *s
 static void tcp_set_skb_tso_segs(const struct sock *sk, struct sk_buff *skb,
 				 unsigned int mss_now)
 {
+	/* Make sure we own this skb before messing gso_size/gso_segs */
+	WARN_ON_ONCE(skb_cloned(skb));
+
 	if (skb->len <= mss_now || !sk_can_gso(sk) ||
 	    skb->ip_summed == CHECKSUM_NONE) {
 		/* Avoid the costly divide in the normal
@@ -1062,9 +1065,7 @@ int tcp_fragment(struct sock *sk, struct
 	if (nsize < 0)
 		nsize = 0;
 
-	if (skb_cloned(skb) &&
-	    skb_is_nonlinear(skb) &&
-	    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
@@ -2339,6 +2340,8 @@ int __tcp_retransmit_skb(struct sock *sk
 		int oldpcount = tcp_skb_pcount(skb);
 
 		if (unlikely(oldpcount > 1)) {
+			if (skb_unclone(skb, GFP_ATOMIC))
+				return -ENOMEM;
 			tcp_init_tso_segs(sk, skb, cur_mss);
 			tcp_adjust_pcount(sk, skb, oldpcount - tcp_skb_pcount(skb));
 		}


