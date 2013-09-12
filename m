Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3ILSXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:23:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3ILR7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Jarno Rajahalme <jrajahalme@nicira.com>,
        Ansis Atteka <aatteka@nicira.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 17/46] ip_tunnel: Do not use inner ip-header-id for tunnel ip-header-id.
Date: Thu, 12 Sep 2013 10:58:28 -0700
Message-Id: <20130912175722.909645185@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

[ Upstream commit 4221f40513233fa8edeef7fc82e44163fde03b9b ]

Using inner-id for tunnel id is not safe in some rare cases.
E.g. packets coming from multiple sources entering same tunnel
can have same id. Therefore on tunnel packet receive we
could have packets from two different stream but with same
source and dst IP with same ip-id which could confuse ip packet
reassembly.

Following patch reverts optimization from commit
490ab08127 (IP_GRE: Fix IP-Identification.)

Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
CC: Jarno Rajahalme <jrajahalme@nicira.com>
CC: Ansis Atteka <aatteka@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c      |    2 +-
 include/net/ip_tunnels.h |   14 --------------
 net/ipv4/ip_tunnel.c     |    2 +-
 3 files changed, 2 insertions(+), 16 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1090,7 +1090,7 @@ static netdev_tx_t vxlan_xmit_one(struct
 	iph->daddr	= dst;
 	iph->saddr	= fl4.saddr;
 	iph->ttl	= ttl ? : ip4_dst_hoplimit(&rt->dst);
-	tunnel_ip_select_ident(skb, old_iph, &rt->dst);
+	__ip_select_ident(iph, &rt->dst, (skb_shinfo(skb)->gso_segs ?: 1) - 1);
 
 	nf_reset(skb);
 
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -141,20 +141,6 @@ static inline u8 ip_tunnel_ecn_encap(u8
 	return INET_ECN_encapsulate(tos, inner);
 }
 
-static inline void tunnel_ip_select_ident(struct sk_buff *skb,
-					  const struct iphdr  *old_iph,
-					  struct dst_entry *dst)
-{
-	struct iphdr *iph = ip_hdr(skb);
-
-	/* Use inner packet iph-id if possible. */
-	if (skb->protocol == htons(ETH_P_IP) && old_iph->id)
-		iph->id	= old_iph->id;
-	else
-		__ip_select_ident(iph, dst,
-				  (skb_shinfo(skb)->gso_segs ?: 1) - 1);
-}
-
 static inline void iptunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	int err;
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -686,7 +686,7 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	iph->daddr	=	fl4.daddr;
 	iph->saddr	=	fl4.saddr;
 	iph->ttl	=	ttl;
-	tunnel_ip_select_ident(skb, inner_iph, &rt->dst);
+	__ip_select_ident(iph, &rt->dst, (skb_shinfo(skb)->gso_segs ?: 1) - 1);
 
 	iptunnel_xmit(skb, dev);
 	return;


