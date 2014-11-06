Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaKFXY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:24:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaKFWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 018/162] xfrm: Generate blackhole routes only from route lookup functions
Date: Thu,  6 Nov 2014 14:34:42 -0800
Message-Id: <1415313426-9622-19-git-send-email-kamal@canonical.com>
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

[ Upstream commit f92ee61982d6da15a9e49664ecd6405a15a2ee56 ]

Currently we genarate a blackhole route route whenever we have
matching policies but can not resolve the states. Here we assume
that dst_output() is called to kill the balckholed packets.
Unfortunately this assumption is not true in all cases, so
it is possible that these packets leave the system unwanted.

We fix this by generating blackhole routes only from the
route lookup functions, here we can guarantee a call to
dst_output() afterwards.

Fixes: 2774c131b1d ("xfrm: Handle blackhole route creation via afinfo.")
Reported-by: Konstantinos Kolelis <k.kolelis@sirrix.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/dst.h      | 15 ++++++++++++++-
 net/ipv4/route.c       |  6 +++---
 net/ipv6/ip6_output.c  |  4 ++--
 net/xfrm/xfrm_policy.c | 18 +++++++++++++++++-
 4 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 44995c1..8211e32 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -477,7 +477,16 @@ static inline struct dst_entry *xfrm_lookup(struct net *net,
 					    int flags)
 {
 	return dst_orig;
-} 
+}
+
+static inline struct dst_entry *xfrm_lookup_route(struct net *net,
+						  struct dst_entry *dst_orig,
+						  const struct flowi *fl,
+						  struct sock *sk,
+						  int flags)
+{
+	return dst_orig;
+}
 
 static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
 {
@@ -489,6 +498,10 @@ struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
 			      const struct flowi *fl, struct sock *sk,
 			      int flags);
 
+struct dst_entry *xfrm_lookup_route(struct net *net, struct dst_entry *dst_orig,
+				    const struct flowi *fl, struct sock *sk,
+				    int flags);
+
 /* skb attached with this dst needs transformation if dst->xfrm is valid */
 static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
 {
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index caadba0..4107687 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2270,9 +2270,9 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
 		return rt;
 
 	if (flp4->flowi4_proto)
-		rt = (struct rtable *) xfrm_lookup(net, &rt->dst,
-						   flowi4_to_flowi(flp4),
-						   sk, 0);
+		rt = (struct rtable *)xfrm_lookup_route(net, &rt->dst,
+							flowi4_to_flowi(flp4),
+							sk, 0);
 
 	return rt;
 }
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 6622e14..e34ca3d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -991,7 +991,7 @@ struct dst_entry *ip6_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 	if (can_sleep)
 		fl6->flowi6_flags |= FLOWI_FLAG_CAN_SLEEP;
 
-	return xfrm_lookup(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
+	return xfrm_lookup_route(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
 }
 EXPORT_SYMBOL_GPL(ip6_dst_lookup_flow);
 
@@ -1027,7 +1027,7 @@ struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 	if (can_sleep)
 		fl6->flowi6_flags |= FLOWI_FLAG_CAN_SLEEP;
 
-	return xfrm_lookup(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
+	return xfrm_lookup_route(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
 }
 EXPORT_SYMBOL_GPL(ip6_sk_dst_lookup_flow);
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 9a91f74..eb918d3 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2150,7 +2150,7 @@ restart:
 			xfrm_pols_put(pols, drop_pols);
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTNOSTATES);
 
-			return make_blackhole(net, family, dst_orig);
+			return ERR_PTR(-EREMOTE);
 		}
 		if (fl->flowi_flags & FLOWI_FLAG_CAN_SLEEP) {
 			DECLARE_WAITQUEUE(wait, current);
@@ -2222,6 +2222,22 @@ dropdst:
 }
 EXPORT_SYMBOL(xfrm_lookup);
 
+/* Callers of xfrm_lookup_route() must ensure a call to dst_output().
+ * Otherwise we may send out blackholed packets.
+ */
+struct dst_entry *xfrm_lookup_route(struct net *net, struct dst_entry *dst_orig,
+				    const struct flowi *fl,
+				    struct sock *sk, int flags)
+{
+	struct dst_entry *dst = xfrm_lookup(net, dst_orig, fl, sk, flags);
+
+	if (IS_ERR(dst) && PTR_ERR(dst) == -EREMOTE)
+		return make_blackhole(net, dst_orig->ops->family, dst_orig);
+
+	return dst;
+}
+EXPORT_SYMBOL(xfrm_lookup_route);
+
 static inline int
 xfrm_secpath_reject(int idx, struct sk_buff *skb, const struct flowi *fl)
 {
-- 
1.9.1

