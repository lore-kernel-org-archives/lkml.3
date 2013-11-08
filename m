Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3KHCQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:16:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34450 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab3KHCQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pravin B Shelar <pshelar@nicira.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 08/91] net: Add skb_unclone() helper function.
Date: Thu,  7 Nov 2013 18:14:23 -0800
Message-Id: <1383876946-2396-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

commit 14bbd6a565e1bcdc240d44687edb93f721cfdf99 upstream.

This function will be used in next GRE_GSO patch. This patch does
not change any functionality.

Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Acked-by: Eric Dumazet <edumazet@google.com>
[ kamal: 3.8-stable prereq for c52e2421f7368fd36cbe330d2cf41b10452e39a9
  "tcp: must unclone packets before mangling them" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ppp/ppp_generic.c           |  3 +--
 include/linux/skbuff.h                  | 10 ++++++++++
 net/ipv4/ah4.c                          |  3 +--
 net/ipv4/ip_fragment.c                  |  2 +-
 net/ipv4/tcp_output.c                   |  2 +-
 net/ipv4/xfrm4_input.c                  |  2 +-
 net/ipv4/xfrm4_mode_tunnel.c            |  3 +--
 net/ipv6/ah6.c                          |  3 +--
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/reassembly.c                   |  2 +-
 net/ipv6/xfrm6_mode_tunnel.c            |  3 +--
 net/sched/act_ipt.c                     |  6 ++----
 net/sched/act_pedit.c                   |  3 +--
 13 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 508570e..3db9131 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1813,8 +1813,7 @@ ppp_receive_nonmp_frame(struct ppp *ppp, struct sk_buff *skb)
 		/* the filter instructions are constructed assuming
 		   a four-byte PPP header on each packet */
 		if (ppp->pass_filter || ppp->active_filter) {
-			if (skb_cloned(skb) &&
-			    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+			if (skb_unclone(skb, GFP_ATOMIC))
 				goto err;
 
 			*skb_push(skb, 2) = 0;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9fe54b6..24f93a1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -797,6 +797,16 @@ static inline int skb_cloned(const struct sk_buff *skb)
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
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index a69b4e4..2e7f194 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -321,8 +321,7 @@ static int ah_input(struct xfrm_state *x, struct sk_buff *skb)
 
 	/* We are going to _remove_ AH header to keep sockets happy,
 	 * so... Later this can change. */
-	if (skb_cloned(skb) &&
-	    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		goto out;
 
 	skb->ip_summed = CHECKSUM_NONE;
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 0fcfee3..24f20a0 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -598,7 +598,7 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *prev,
 		goto out_oversize;
 
 	/* Head of list must not be cloned. */
-	if (skb_cloned(head) && pskb_expand_head(head, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(head, GFP_ATOMIC))
 		goto out_nomem;
 
 	/* If the first fragment is fragmented itself, we split
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bef538f..acda728 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1331,7 +1331,7 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
 /* Remove acked data from a packet in the transmit queue. */
 int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 {
-	if (skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		return -ENOMEM;
 
 	__pskb_trim_head(skb, len);
diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index 06814b6..1f12c8b 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -132,7 +132,7 @@ int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 	 * header and optional ESP marker bytes) and then modify the
 	 * protocol to ESP, and then call into the transform receiver.
 	 */
-	if (skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		goto drop;
 
 	/* Now we can update and verify the packet length... */
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 91ab23b..57dfe2b 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -142,8 +142,7 @@ static int xfrm4_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 	for_each_input_rcu(rcv_notify_handlers, handler)
 		handler->handler(skb);
 
-	if (skb_cloned(skb) &&
-	    (err = pskb_expand_head(skb, 0, 0, GFP_ATOMIC)))
+	if (err = skb_unclone(skb, GFP_ATOMIC))
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 3842331..bb02e17 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -521,8 +521,7 @@ static int ah6_input(struct xfrm_state *x, struct sk_buff *skb)
 
 	/* We are going to _remove_ AH header to keep sockets happy,
 	 * so... Later this can change. */
-	if (skb_cloned(skb) &&
-	    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		goto out;
 
 	skb->ip_summed = CHECKSUM_NONE;
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 2f3a018..d05b6ee 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -369,7 +369,7 @@ nf_ct_frag6_reasm(struct frag_queue *fq, struct net_device *dev)
 	}
 
 	/* Head of list must not be cloned. */
-	if (skb_cloned(head) && pskb_expand_head(head, 0, 0, GFP_ATOMIC)) {
+	if (skb_unclone(head, GFP_ATOMIC)) {
 		pr_debug("skb is cloned but can't expand head");
 		goto out_oom;
 	}
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1aa1434..6090a11 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -419,7 +419,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 		goto out_oversize;
 
 	/* Head of list must not be cloned. */
-	if (skb_cloned(head) && pskb_expand_head(head, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(head, GFP_ATOMIC))
 		goto out_oom;
 
 	/* If the first fragment is fragmented itself, we split
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index 9f2095b..93c41a8 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -69,8 +69,7 @@ static int xfrm6_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto out;
 
-	if (skb_cloned(skb) &&
-	    (err = pskb_expand_head(skb, 0, 0, GFP_ATOMIC)))
+	if (err = skb_unclone(skb, GFP_ATOMIC))
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index c1a8138..ae64870 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -207,10 +207,8 @@ static int tcf_ipt(struct sk_buff *skb, const struct tc_action *a,
 	struct tcf_ipt *ipt = a->priv;
 	struct xt_action_param par;
 
-	if (skb_cloned(skb)) {
-		if (pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
-			return TC_ACT_UNSPEC;
-	}
+	if (skb_unclone(skb, GFP_ATOMIC))
+		return TC_ACT_UNSPEC;
 
 	spin_lock(&ipt->tcf_lock);
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 45c53ab..fe4bb5b 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -130,8 +130,7 @@ static int tcf_pedit(struct sk_buff *skb, const struct tc_action *a,
 	int i, munged = 0;
 	unsigned int off;
 
-	if (skb_cloned(skb) &&
-	    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+	if (skb_unclone(skb, GFP_ATOMIC))
 		return p->tcf_action;
 
 	off = skb_network_offset(skb);
-- 
1.8.1.2

