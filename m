Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbaBWIFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 03:05:34 -0500
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:48591 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751006AbaBWIFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 03:05:33 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:3874:4321:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lake13_6a2c83becce3a
X-Filterd-Recvd-Size: 2906
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] bridge: Use ether_addr_copy and ETH_ALEN
Date: Sun, 23 Feb 2014 00:05:25 -0800
Message-Id: <06d3e7e463c2bbfa8b5264e67daace1181ada090.1393142669.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the more obvious uses of memcpy to ether_addr_copy.

There are still uses of memcpy that could be converted but
these addresses are __aligned(2).

Convert a couple uses of 6 in gr_private.h to ETH_ALEN.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/bridge/br_device.c    | 2 +-
 net/bridge/br_multicast.c | 4 ++--
 net/bridge/br_private.h   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index bf34451..b063050 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -367,7 +367,7 @@ void br_dev_setup(struct net_device *dev)
 	br->bridge_id.prio[0] = 0x80;
 	br->bridge_id.prio[1] = 0x00;
 
-	memcpy(br->group_addr, eth_reserved_addr_base, ETH_ALEN);
+	ether_addr_copy(br->group_addr, eth_reserved_addr_base);
 
 	br->stp_enabled = BR_NO_STP;
 	br->group_fwd_mask = BR_GROUPFWD_DEFAULT;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index ef66365..c97c3c8 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -363,7 +363,7 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	skb_reset_mac_header(skb);
 	eth = eth_hdr(skb);
 
-	memcpy(eth->h_source, br->dev->dev_addr, ETH_ALEN);
+	ether_addr_copy(eth->h_source, br->dev->dev_addr);
 	eth->h_dest[0] = 1;
 	eth->h_dest[1] = 0;
 	eth->h_dest[2] = 0x5e;
@@ -433,7 +433,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 	skb_reset_mac_header(skb);
 	eth = eth_hdr(skb);
 
-	memcpy(eth->h_source, br->dev->dev_addr, ETH_ALEN);
+	ether_addr_copy(eth->h_source, br->dev->dev_addr);
 	eth->h_proto = htons(ETH_P_IPV6);
 	skb_put(skb, sizeof(*eth));
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 3ba11bc..e1ca1dc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -46,12 +46,12 @@ typedef __u16 port_id;
 struct bridge_id
 {
 	unsigned char	prio[2];
-	unsigned char	addr[6];
+	unsigned char	addr[ETH_ALEN];
 };
 
 struct mac_addr
 {
-	unsigned char	addr[6];
+	unsigned char	addr[ETH_ALEN];
 };
 
 struct br_ip
-- 
1.8.1.2.459.gbcd45b4.dirty

