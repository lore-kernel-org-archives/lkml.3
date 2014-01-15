Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaAOW3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:29:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40966 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaAOV5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamala R <kamala@aristanetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 138/166] IPv6: Fixed support for blackhole and prohibit routes
Date: Wed, 15 Jan 2014 13:52:32 -0800
Message-Id: <1389822780-4729-139-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamala R <kamala@aristanetworks.com>

[ Upstream commit 7150aede5dd241539686e17d9592f5ebd28a2cda ]

The behaviour of blackhole and prohibit routes has been corrected by setting
the input and output pointers of the dst variable appropriately. For
blackhole routes, they are set to dst_discard and to ip6_pkt_discard and
ip6_pkt_discard_out respectively for prohibit routes.

ipv6: ip6_pkt_prohibit(_out) should not depend on
CONFIG_IPV6_MULTIPLE_TABLES

We need ip6_pkt_prohibit(_out) available without
CONFIG_IPV6_MULTIPLE_TABLES

Signed-off-by: Kamala R <kamala@aristanetworks.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/route.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index abf3556..9b530eb 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -78,6 +78,8 @@ static int		 ip6_dst_gc(struct dst_ops *ops);
 
 static int		ip6_pkt_discard(struct sk_buff *skb);
 static int		ip6_pkt_discard_out(struct sk_buff *skb);
+static int		ip6_pkt_prohibit(struct sk_buff *skb);
+static int		ip6_pkt_prohibit_out(struct sk_buff *skb);
 static void		ip6_link_failure(struct sk_buff *skb);
 static void		ip6_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 					   struct sk_buff *skb, u32 mtu);
@@ -240,9 +242,6 @@ static const struct rt6_info ip6_null_entry_template = {
 
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 
-static int ip6_pkt_prohibit(struct sk_buff *skb);
-static int ip6_pkt_prohibit_out(struct sk_buff *skb);
-
 static const struct rt6_info ip6_prohibit_entry_template = {
 	.dst = {
 		.__refcnt	= ATOMIC_INIT(1),
@@ -1512,21 +1511,24 @@ int ip6_route_add(struct fib6_config *cfg)
 				goto out;
 			}
 		}
-		rt->dst.output = ip6_pkt_discard_out;
-		rt->dst.input = ip6_pkt_discard;
 		rt->rt6i_flags = RTF_REJECT|RTF_NONEXTHOP;
 		switch (cfg->fc_type) {
 		case RTN_BLACKHOLE:
 			rt->dst.error = -EINVAL;
+			rt->dst.output = dst_discard;
+			rt->dst.input = dst_discard;
 			break;
 		case RTN_PROHIBIT:
 			rt->dst.error = -EACCES;
+			rt->dst.output = ip6_pkt_prohibit_out;
+			rt->dst.input = ip6_pkt_prohibit;
 			break;
 		case RTN_THROW:
-			rt->dst.error = -EAGAIN;
-			break;
 		default:
-			rt->dst.error = -ENETUNREACH;
+			rt->dst.error = (cfg->fc_type == RTN_THROW) ? -EAGAIN
+					: -ENETUNREACH;
+			rt->dst.output = ip6_pkt_discard_out;
+			rt->dst.input = ip6_pkt_discard;
 			break;
 		}
 		goto install_route;
@@ -2106,8 +2108,6 @@ static int ip6_pkt_discard_out(struct sk_buff *skb)
 	return ip6_pkt_drop(skb, ICMPV6_NOROUTE, IPSTATS_MIB_OUTNOROUTES);
 }
 
-#ifdef CONFIG_IPV6_MULTIPLE_TABLES
-
 static int ip6_pkt_prohibit(struct sk_buff *skb)
 {
 	return ip6_pkt_drop(skb, ICMPV6_ADM_PROHIBITED, IPSTATS_MIB_INNOROUTES);
@@ -2119,8 +2119,6 @@ static int ip6_pkt_prohibit_out(struct sk_buff *skb)
 	return ip6_pkt_drop(skb, ICMPV6_ADM_PROHIBITED, IPSTATS_MIB_OUTNOROUTES);
 }
 
-#endif
-
 /*
  *	Allocate a dst for local (unicast / anycast) address.
  */
-- 
1.8.3.2

