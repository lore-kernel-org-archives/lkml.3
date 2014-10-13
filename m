Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaJMC0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:26:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaJMC0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantinos Kolelis <k.kolelis@sirrix.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 3.14 22/37] xfrm: Generate blackhole routes only from route lookup functions
Date: Mon, 13 Oct 2014 04:24:19 +0200
Message-Id: <20141013022401.221078127@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h      |   15 ++++++++++++++-
 net/ipv4/route.c       |    6 +++---
 net/ipv6/ip6_output.c  |    4 ++--
 net/xfrm/xfrm_policy.c |   18 +++++++++++++++++-
 4 files changed, 36 insertions(+), 7 deletions(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -476,7 +476,16 @@ static inline struct dst_entry *xfrm_loo
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
@@ -488,6 +497,10 @@ struct dst_entry *xfrm_lookup(struct net
 			      const struct flowi *fl, struct sock *sk,
 			      int flags);
 
+struct dst_entry *xfrm_lookup_route(struct net *net, struct dst_entry *dst_orig,
+				    const struct flowi *fl, struct sock *sk,
+				    int flags);
+
 /* skb attached with this dst needs transformation if dst->xfrm is valid */
 static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
 {
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2268,9 +2268,9 @@ struct rtable *ip_route_output_flow(stru
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
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1008,7 +1008,7 @@ struct dst_entry *ip6_dst_lookup_flow(st
 	if (final_dst)
 		fl6->daddr = *final_dst;
 
-	return xfrm_lookup(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
+	return xfrm_lookup_route(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
 }
 EXPORT_SYMBOL_GPL(ip6_dst_lookup_flow);
 
@@ -1040,7 +1040,7 @@ struct dst_entry *ip6_sk_dst_lookup_flow
 	if (final_dst)
 		fl6->daddr = *final_dst;
 
-	return xfrm_lookup(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
+	return xfrm_lookup_route(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
 }
 EXPORT_SYMBOL_GPL(ip6_sk_dst_lookup_flow);
 
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2155,7 +2155,7 @@ struct dst_entry *xfrm_lookup(struct net
 			xfrm_pols_put(pols, drop_pols);
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTNOSTATES);
 
-			return make_blackhole(net, family, dst_orig);
+			return ERR_PTR(-EREMOTE);
 		}
 
 		err = -EAGAIN;
@@ -2212,6 +2212,22 @@ dropdst:
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


