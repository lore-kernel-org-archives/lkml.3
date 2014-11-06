Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaKFXYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:24:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58426 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaKFWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 019/162] xfrm: Generate queueing routes only from route lookup functions
Date: Thu,  6 Nov 2014 14:34:43 -0800
Message-Id: <1415313426-9622-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit b8c203b2d2fc961bafd53b41d5396bbcdec55998 ]

Currently we genarate a queueing route if we have matching policies
but can not resolve the states and the sysctl xfrm_larval_drop is
disabled. Here we assume that dst_output() is called to kill the
queued packets. Unfortunately this assumption is not true in all
cases, so it is possible that these packets leave the system unwanted.

We fix this by generating queueing routes only from the
route lookup functions, here we can guarantee a call to
dst_output() afterwards.

Fixes: a0073fe18e71 ("xfrm: Add a state resolution packet queue")
Reported-by: Konstantinos Kolelis <k.kolelis@sirrix.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/dst.h      |  1 +
 net/xfrm/xfrm_policy.c | 32 ++++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 8211e32..4b368ae 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -467,6 +467,7 @@ void dst_init(void);
 /* Flags for xfrm_lookup flags argument. */
 enum {
 	XFRM_LOOKUP_ICMP = 1 << 0,
+	XFRM_LOOKUP_QUEUE = 1 << 1,
 };
 
 struct flowi;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index eb918d3..0ee05f0 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -46,6 +46,11 @@ static DEFINE_SPINLOCK(xfrm_policy_sk_bundle_lock);
 static struct dst_entry *xfrm_policy_sk_bundles;
 static DEFINE_RWLOCK(xfrm_policy_lock);
 
+struct xfrm_flo {
+	struct dst_entry *dst_orig;
+	u8 flags;
+};
+
 static DEFINE_SPINLOCK(xfrm_policy_afinfo_lock);
 static struct xfrm_policy_afinfo __rcu *xfrm_policy_afinfo[NPROTO]
 						__read_mostly;
@@ -1882,13 +1887,14 @@ static int xdst_queue_output(struct sk_buff *skb)
 }
 
 static struct xfrm_dst *xfrm_create_dummy_bundle(struct net *net,
-						 struct dst_entry *dst,
+						 struct xfrm_flo *xflo,
 						 const struct flowi *fl,
 						 int num_xfrms,
 						 u16 family)
 {
 	int err;
 	struct net_device *dev;
+	struct dst_entry *dst;
 	struct dst_entry *dst1;
 	struct xfrm_dst *xdst;
 
@@ -1896,10 +1902,13 @@ static struct xfrm_dst *xfrm_create_dummy_bundle(struct net *net,
 	if (IS_ERR(xdst))
 		return xdst;
 
-	if (net->xfrm.sysctl_larval_drop || num_xfrms <= 0 ||
+	if (!(xflo->flags & XFRM_LOOKUP_QUEUE) ||
+	    net->xfrm.sysctl_larval_drop ||
+	    num_xfrms <= 0 ||
 	    (fl->flowi_flags & FLOWI_FLAG_CAN_SLEEP))
 		return xdst;
 
+	dst = xflo->dst_orig;
 	dst1 = &xdst->u.dst;
 	dst_hold(dst);
 	xdst->route = dst;
@@ -1941,7 +1950,7 @@ static struct flow_cache_object *
 xfrm_bundle_lookup(struct net *net, const struct flowi *fl, u16 family, u8 dir,
 		   struct flow_cache_object *oldflo, void *ctx)
 {
-	struct dst_entry *dst_orig = (struct dst_entry *)ctx;
+	struct xfrm_flo *xflo = (struct xfrm_flo *)ctx;
 	struct xfrm_policy *pols[XFRM_POLICY_TYPE_MAX];
 	struct xfrm_dst *xdst, *new_xdst;
 	int num_pols = 0, num_xfrms = 0, i, err, pol_dead;
@@ -1982,7 +1991,8 @@ xfrm_bundle_lookup(struct net *net, const struct flowi *fl, u16 family, u8 dir,
 			goto make_dummy_bundle;
 	}
 
-	new_xdst = xfrm_resolve_and_create_bundle(pols, num_pols, fl, family, dst_orig);
+	new_xdst = xfrm_resolve_and_create_bundle(pols, num_pols, fl, family,
+						  xflo->dst_orig);
 	if (IS_ERR(new_xdst)) {
 		err = PTR_ERR(new_xdst);
 		if (err != -EAGAIN)
@@ -2016,7 +2026,7 @@ make_dummy_bundle:
 	/* We found policies, but there's no bundles to instantiate:
 	 * either because the policy blocks, has no transformations or
 	 * we could not build template (no xfrm_states).*/
-	xdst = xfrm_create_dummy_bundle(net, dst_orig, fl, num_xfrms, family);
+	xdst = xfrm_create_dummy_bundle(net, xflo, fl, num_xfrms, family);
 	if (IS_ERR(xdst)) {
 		xfrm_pols_put(pols, num_pols);
 		return ERR_CAST(xdst);
@@ -2116,13 +2126,18 @@ restart:
 	}
 
 	if (xdst == NULL) {
+		struct xfrm_flo xflo;
+
+		xflo.dst_orig = dst_orig;
+		xflo.flags = flags;
+
 		/* To accelerate a bit...  */
 		if ((dst_orig->flags & DST_NOXFRM) ||
 		    !net->xfrm.policy_count[XFRM_POLICY_OUT])
 			goto nopol;
 
 		flo = flow_cache_lookup(net, fl, family, dir,
-					xfrm_bundle_lookup, dst_orig);
+					xfrm_bundle_lookup, &xflo);
 		if (flo == NULL)
 			goto nopol;
 		if (IS_ERR(flo)) {
@@ -2229,7 +2244,8 @@ struct dst_entry *xfrm_lookup_route(struct net *net, struct dst_entry *dst_orig,
 				    const struct flowi *fl,
 				    struct sock *sk, int flags)
 {
-	struct dst_entry *dst = xfrm_lookup(net, dst_orig, fl, sk, flags);
+	struct dst_entry *dst = xfrm_lookup(net, dst_orig, fl, sk,
+					    flags | XFRM_LOOKUP_QUEUE);
 
 	if (IS_ERR(dst) && PTR_ERR(dst) == -EREMOTE)
 		return make_blackhole(net, dst_orig->ops->family, dst_orig);
@@ -2503,7 +2519,7 @@ int __xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 
 	skb_dst_force(skb);
 
-	dst = xfrm_lookup(net, skb_dst(skb), &fl, NULL, 0);
+	dst = xfrm_lookup(net, skb_dst(skb), &fl, NULL, XFRM_LOOKUP_QUEUE);
 	if (IS_ERR(dst)) {
 		res = 0;
 		dst = NULL;
-- 
1.9.1

