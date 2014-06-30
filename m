Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaF3MXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:23:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51914 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbaF3LxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 018/181] xfrm: fix race between netns cleanup and state expire notification
Date: Mon, 30 Jun 2014 13:50:39 +0200
Message-Id: <3f8fd8ad48b66a4fc44f60cde0ea575155a45eff.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 21ee543edc0dea36ab58d24523fcd42b8a270df8 upstream.

The xfrm_user module registers its pernet init/exit after xfrm
itself so that its net exit function xfrm_user_net_exit() is
executed before xfrm_net_exit() which calls xfrm_state_fini() to
cleanup the SA's (xfrm states). This opens a window between
zeroing net->xfrm.nlsk pointer and deleting all xfrm_state
instances which may access it (via the timer). If an xfrm state
expires in this window, xfrm_exp_state_notify() will pass null
pointer as socket to nlmsg_multicast().

As the notifications are called inside rcu_read_lock() block, it
is sufficient to retrieve the nlsk socket with rcu_dereference()
and check the it for null.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/xfrm/xfrm_user.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 352dfa4c39ee..32a2dd39b785 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -930,6 +930,20 @@ static struct sk_buff *xfrm_state_netlink(struct sk_buff *in_skb,
 	return skb;
 }
 
+/* A wrapper for nlmsg_multicast() checking that nlsk is still available.
+ * Must be called with RCU read lock.
+ */
+static inline int xfrm_nlmsg_multicast(struct net *net, struct sk_buff *skb,
+				       u32 pid, unsigned int group)
+{
+	struct sock *nlsk = rcu_dereference(net->xfrm.nlsk);
+
+	if (nlsk)
+		return nlmsg_multicast(nlsk, skb, pid, group, GFP_ATOMIC);
+	else
+		return -1;
+}
+
 static inline size_t xfrm_spdinfo_msgsize(void)
 {
 	return NLMSG_ALIGN(4)
@@ -2253,7 +2267,7 @@ static int xfrm_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	if (build_migrate(skb, m, num_migrate, k, sel, dir, type) < 0)
 		BUG();
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_MIGRATE, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_MIGRATE);
 }
 #else
 static int xfrm_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
@@ -2440,7 +2454,7 @@ static int xfrm_exp_state_notify(struct xfrm_state *x, const struct km_event *c)
 		return -EMSGSIZE;
 	}
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_EXPIRE, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_EXPIRE);
 }
 
 static int xfrm_aevent_state_notify(struct xfrm_state *x, const struct km_event *c)
@@ -2455,7 +2469,7 @@ static int xfrm_aevent_state_notify(struct xfrm_state *x, const struct km_event
 	if (build_aevent(skb, x, c) < 0)
 		BUG();
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_AEVENTS, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_AEVENTS);
 }
 
 static int xfrm_notify_sa_flush(const struct km_event *c)
@@ -2481,7 +2495,7 @@ static int xfrm_notify_sa_flush(const struct km_event *c)
 
 	nlmsg_end(skb, nlh);
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_SA, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_SA);
 }
 
 static inline size_t xfrm_sa_len(struct xfrm_state *x)
@@ -2568,7 +2582,7 @@ static int xfrm_notify_sa(struct xfrm_state *x, const struct km_event *c)
 
 	nlmsg_end(skb, nlh);
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_SA, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_SA);
 
 out_free_skb:
 	kfree_skb(skb);
@@ -2659,7 +2673,7 @@ static int xfrm_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *xt,
 	if (build_acquire(skb, x, xt, xp) < 0)
 		BUG();
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_ACQUIRE, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_ACQUIRE);
 }
 
 /* User gives us xfrm_user_policy_info followed by an array of 0
@@ -2773,7 +2787,7 @@ static int xfrm_exp_policy_notify(struct xfrm_policy *xp, int dir, const struct
 	if (build_polexpire(skb, xp, dir, c) < 0)
 		BUG();
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_EXPIRE, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_EXPIRE);
 }
 
 static int xfrm_notify_policy(struct xfrm_policy *xp, int dir, const struct km_event *c)
@@ -2835,7 +2849,7 @@ static int xfrm_notify_policy(struct xfrm_policy *xp, int dir, const struct km_e
 
 	nlmsg_end(skb, nlh);
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_POLICY, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
 
 out_free_skb:
 	kfree_skb(skb);
@@ -2863,7 +2877,7 @@ static int xfrm_notify_policy_flush(const struct km_event *c)
 
 	nlmsg_end(skb, nlh);
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_POLICY, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
 
 out_free_skb:
 	kfree_skb(skb);
@@ -2932,7 +2946,7 @@ static int xfrm_send_report(struct net *net, u8 proto,
 	if (build_report(skb, proto, sel, addr) < 0)
 		BUG();
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_REPORT, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_REPORT);
 }
 
 static inline size_t xfrm_mapping_msgsize(void)
@@ -2984,7 +2998,7 @@ static int xfrm_send_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr,
 	if (build_mapping(skb, x, ipaddr, sport) < 0)
 		BUG();
 
-	return nlmsg_multicast(net->xfrm.nlsk, skb, 0, XFRMNLGRP_MAPPING, GFP_ATOMIC);
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_MAPPING);
 }
 
 static struct xfrm_mgr netlink_mgr = {
-- 
2.0.0

