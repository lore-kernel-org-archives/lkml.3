Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3FDWnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:21 -0400
Received: from 1wt.eu ([62.212.114.60]:35684 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab3FDWnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:13 -0400
Message-Id: <20130604172136.519104713@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Benjamin LaHaise <bcrl@kvack.org>, Willy Tarreau <w@1wt.eu>
Subject: [ 150/184] ipv4: check rt_genid in dst_check
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin LaHaise <bcrl@kvack.org>

commit d11a4dc18bf41719c9f0d7ed494d295dd2973b92
Author: Timo Teräs <timo.teras@iki.fi>
Date:   Thu Mar 18 23:20:20 2010 +0000

    ipv4: check rt_genid in dst_check

    Xfrm_dst keeps a reference to ipv4 rtable entries on each
    cached bundle. The only way to renew xfrm_dst when the underlying
    route has changed, is to implement dst_check for this. This is
    what ipv6 side does too.

    The problems started after 87c1e12b5eeb7b30b4b41291bef8e0b41fc3dde9
    ("ipsec: Fix bogus bundle flowi") which fixed a bug causing xfrm_dst
    to not get reused, until that all lookups always generated new
    xfrm_dst with new route reference and path mtu worked. But after the
    fix, the old routes started to get reused even after they were expired
    causing pmtu to break (well it would occationally work if the rtable
    gc had run recently and marked the route obsolete causing dst_check to
    get called).

    Signed-off-by: Timo Teras <timo.teras@iki.fi>
    Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
    Signed-off-by: David S. Miller <davem@davemloft.net>

This commit is based on the above, with the addition of verifying blackhole
routes in the same manner.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/route.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 58f141b..f16d19b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1412,7 +1412,7 @@ void ip_rt_redirect(__be32 old_gw, __be32 daddr, __be32 new_gw,
 					dev_hold(rt->u.dst.dev);
 				if (rt->idev)
 					in_dev_hold(rt->idev);
-				rt->u.dst.obsolete	= 0;
+				rt->u.dst.obsolete	= -1;
 				rt->u.dst.lastuse	= jiffies;
 				rt->u.dst.path		= &rt->u.dst;
 				rt->u.dst.neighbour	= NULL;
@@ -1477,7 +1477,7 @@ static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst)
 	struct dst_entry *ret = dst;
 
 	if (rt) {
-		if (dst->obsolete) {
+		if (dst->obsolete > 0) {
 			ip_rt_put(rt);
 			ret = NULL;
 		} else if ((rt->rt_flags & RTCF_REDIRECTED) ||
@@ -1700,7 +1700,9 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, u32 mtu)
 
 static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie)
 {
-	return NULL;
+	if (rt_is_expired((struct rtable *)dst))
+		return NULL;
+	return dst;
 }
 
 static void ipv4_dst_destroy(struct dst_entry *dst)
@@ -1862,7 +1864,8 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (!rth)
 		goto e_nobufs;
 
-	rth->u.dst.output= ip_rt_bug;
+	rth->u.dst.output = ip_rt_bug;
+	rth->u.dst.obsolete = -1;
 
 	atomic_set(&rth->u.dst.__refcnt, 1);
 	rth->u.dst.flags= DST_HOST;
@@ -2023,6 +2026,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	rth->fl.oif 	= 0;
 	rth->rt_spec_dst= spec_dst;
 
+	rth->u.dst.obsolete = -1;
 	rth->u.dst.input = ip_forward;
 	rth->u.dst.output = ip_output;
 	rth->rt_genid = rt_genid(dev_net(rth->u.dst.dev));
@@ -2187,6 +2191,7 @@ local_input:
 		goto e_nobufs;
 
 	rth->u.dst.output= ip_rt_bug;
+	rth->u.dst.obsolete = -1;
 	rth->rt_genid = rt_genid(net);
 
 	atomic_set(&rth->u.dst.__refcnt, 1);
@@ -2411,7 +2416,8 @@ static int __mkroute_output(struct rtable **result,
 	rth->rt_gateway = fl->fl4_dst;
 	rth->rt_spec_dst= fl->fl4_src;
 
-	rth->u.dst.output=ip_output;
+	rth->u.dst.output = ip_output;
+	rth->u.dst.obsolete = -1;
 	rth->rt_genid = rt_genid(dev_net(dev_out));
 
 	RT_CACHE_STAT_INC(out_slow_tot);
@@ -2741,6 +2747,7 @@ static int ipv4_dst_blackhole(struct net *net, struct rtable **rp, struct flowi
 	if (rt) {
 		struct dst_entry *new = &rt->u.dst;
 
+		new->obsolete = -1;
 		atomic_set(&new->__refcnt, 1);
 		new->__use = 1;
 		new->input = dst_discard;
-- 
1.7.12.2.21.g234cd45.dirty



