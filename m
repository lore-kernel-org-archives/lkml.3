Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3KAWSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:18:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab3KAWIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 44/66] ipv6: fill rt6i_gateway with nexthop address
Date: Fri,  1 Nov 2013 15:07:20 -0700
Message-Id: <20131101220646.832236772@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 550bab42f83308c9d6ab04a980cc4333cef1c8fa ]

Make sure rt6i_gateway contains nexthop information in
all routes returned from lookup or when routes are directly
attached to skb for generated ICMP packets.

The effect of this patch should be a faster version of
rt6_nexthop() and the consideration of local addresses as
nexthop.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_route.h |    6 ++----
 net/ipv6/ip6_output.c   |    4 ++--
 net/ipv6/route.c        |    8 ++++++--
 3 files changed, 10 insertions(+), 8 deletions(-)

--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -196,11 +196,9 @@ static inline int ip6_skb_dst_mtu(struct
 	       skb_dst(skb)->dev->mtu : dst_mtu(skb_dst(skb));
 }
 
-static inline struct in6_addr *rt6_nexthop(struct rt6_info *rt, struct in6_addr *dest)
+static inline struct in6_addr *rt6_nexthop(struct rt6_info *rt)
 {
-	if (rt->rt6i_flags & RTF_GATEWAY || !ipv6_addr_any(&rt->rt6i_gateway))
-		return &rt->rt6i_gateway;
-	return dest;
+	return &rt->rt6i_gateway;
 }
 
 #endif
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -130,7 +130,7 @@ static int ip6_finish_output2(struct sk_
 	}
 
 	rcu_read_lock_bh();
-	nexthop = rt6_nexthop((struct rt6_info *)dst, &ipv6_hdr(skb)->daddr);
+	nexthop = rt6_nexthop((struct rt6_info *)dst);
 	neigh = __ipv6_neigh_lookup_noref(dst->dev, nexthop);
 	if (unlikely(!neigh))
 		neigh = __neigh_create(&nd_tbl, nexthop, dst->dev, false);
@@ -899,7 +899,7 @@ static int ip6_dst_lookup_tail(struct so
 	 */
 	rt = (struct rt6_info *) *dst;
 	rcu_read_lock_bh();
-	n = __ipv6_neigh_lookup_noref(rt->dst.dev, rt6_nexthop(rt, &fl6->daddr));
+	n = __ipv6_neigh_lookup_noref(rt->dst.dev, rt6_nexthop(rt));
 	err = n && !(n->nud_state & NUD_VALID) ? -EINVAL : 0;
 	rcu_read_unlock_bh();
 
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -852,7 +852,6 @@ static struct rt6_info *rt6_alloc_cow(st
 			if (ort->rt6i_dst.plen != 128 &&
 			    ipv6_addr_equal(&ort->rt6i_dst.addr, daddr))
 				rt->rt6i_flags |= RTF_ANYCAST;
-			rt->rt6i_gateway = *daddr;
 		}
 
 		rt->rt6i_flags |= RTF_CACHE;
@@ -1270,6 +1269,7 @@ struct dst_entry *icmp6_dst_alloc(struct
 	rt->dst.flags |= DST_HOST;
 	rt->dst.output  = ip6_output;
 	atomic_set(&rt->dst.__refcnt, 1);
+	rt->rt6i_gateway  = fl6->daddr;
 	rt->rt6i_dst.addr = fl6->daddr;
 	rt->rt6i_dst.plen = 128;
 	rt->rt6i_idev     = idev;
@@ -1824,7 +1824,10 @@ static struct rt6_info *ip6_rt_copy(stru
 			in6_dev_hold(rt->rt6i_idev);
 		rt->dst.lastuse = jiffies;
 
-		rt->rt6i_gateway = ort->rt6i_gateway;
+		if (ort->rt6i_flags & RTF_GATEWAY)
+			rt->rt6i_gateway = ort->rt6i_gateway;
+		else
+			rt->rt6i_gateway = *dest;
 		rt->rt6i_flags = ort->rt6i_flags;
 		if ((ort->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) ==
 		    (RTF_DEFAULT | RTF_ADDRCONF))
@@ -2111,6 +2114,7 @@ struct rt6_info *addrconf_dst_alloc(stru
 	else
 		rt->rt6i_flags |= RTF_LOCAL;
 
+	rt->rt6i_gateway  = *addr;
 	rt->rt6i_dst.addr = *addr;
 	rt->rt6i_dst.plen = 128;
 	rt->rt6i_table = fib6_get_table(net, RT6_TABLE_LOCAL);


