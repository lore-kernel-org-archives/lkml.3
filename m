Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbaANBGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:06:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaANA1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kamala R <kamala@aristanetworks.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 05/62] IPv6: Fixed support for blackhole and prohibit routes
Date: Mon, 13 Jan 2014 16:26:30 -0800
Message-Id: <20140114002710.618915858@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -84,6 +84,8 @@ static int		 ip6_dst_gc(struct dst_ops *
 
 static int		ip6_pkt_discard(struct sk_buff *skb);
 static int		ip6_pkt_discard_out(struct sk_buff *skb);
+static int		ip6_pkt_prohibit(struct sk_buff *skb);
+static int		ip6_pkt_prohibit_out(struct sk_buff *skb);
 static void		ip6_link_failure(struct sk_buff *skb);
 static void		ip6_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 					   struct sk_buff *skb, u32 mtu);
@@ -233,9 +235,6 @@ static const struct rt6_info ip6_null_en
 
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 
-static int ip6_pkt_prohibit(struct sk_buff *skb);
-static int ip6_pkt_prohibit_out(struct sk_buff *skb);
-
 static const struct rt6_info ip6_prohibit_entry_template = {
 	.dst = {
 		.__refcnt	= ATOMIC_INIT(1),
@@ -1498,21 +1497,24 @@ int ip6_route_add(struct fib6_config *cf
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
@@ -2077,8 +2079,6 @@ static int ip6_pkt_discard_out(struct sk
 	return ip6_pkt_drop(skb, ICMPV6_NOROUTE, IPSTATS_MIB_OUTNOROUTES);
 }
 
-#ifdef CONFIG_IPV6_MULTIPLE_TABLES
-
 static int ip6_pkt_prohibit(struct sk_buff *skb)
 {
 	return ip6_pkt_drop(skb, ICMPV6_ADM_PROHIBITED, IPSTATS_MIB_INNOROUTES);
@@ -2090,8 +2090,6 @@ static int ip6_pkt_prohibit_out(struct s
 	return ip6_pkt_drop(skb, ICMPV6_ADM_PROHIBITED, IPSTATS_MIB_OUTNOROUTES);
 }
 
-#endif
-
 /*
  *	Allocate a dst for local (unicast / anycast) address.
  */


