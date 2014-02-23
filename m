Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaBWIFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 03:05:44 -0500
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:48598 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751006AbaBWIFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 03:05:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:3872:4321:4605:5007:6261:7903:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MS
X-HE-Tag: gate83_6ad39a11f3b40
X-Filterd-Recvd-Size: 4368
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bart De Schuymer <bart.de.schuymer@pandora.be>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH 2/2] bridge: netfilter: Use ether_addr_copy
Date: Sun, 23 Feb 2014 00:05:26 -0800
Message-Id: <8ffb523682d29d344873ad09b9c27faddcb90b5f.1393142669.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <06d3e7e463c2bbfa8b5264e67daace1181ada090.1393142669.git.joe@perches.com>
References: <06d3e7e463c2bbfa8b5264e67daace1181ada090.1393142669.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the uses of memcpy to ether_addr_copy because
for some architectures it is smaller and faster.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/bridge/br_netfilter.c           | 2 +-
 net/bridge/netfilter/ebt_among.c    | 2 +-
 net/bridge/netfilter/ebt_dnat.c     | 2 +-
 net/bridge/netfilter/ebt_redirect.c | 6 +++---
 net/bridge/netfilter/ebt_snat.c     | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index b008c59..df0f114 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -506,7 +506,7 @@ bridged_dnat:
 					       1);
 				return 0;
 			}
-			memcpy(eth_hdr(skb)->h_dest, dev->dev_addr, ETH_ALEN);
+			ether_addr_copy(eth_hdr(skb)->h_dest, dev->dev_addr);
 			skb->pkt_type = PACKET_HOST;
 		}
 	} else {
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 3fb3c84..9024283 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -28,7 +28,7 @@ static bool ebt_mac_wormhash_contains(const struct ebt_mac_wormhash *wh,
 	uint32_t cmp[2] = { 0, 0 };
 	int key = ((const unsigned char *)mac)[5];
 
-	memcpy(((char *) cmp) + 2, mac, ETH_ALEN);
+	ether_addr_copy(((char *) cmp) + 2, mac);
 	start = wh->table[key];
 	limit = wh->table[key + 1];
 	if (ip) {
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index c59f7bf..4e0b0c3 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -22,7 +22,7 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	if (!skb_make_writable(skb, 0))
 		return EBT_DROP;
 
-	memcpy(eth_hdr(skb)->h_dest, info->mac, ETH_ALEN);
+	ether_addr_copy(eth_hdr(skb)->h_dest, info->mac);
 	return info->target;
 }
 
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 46624bb..20396499 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -25,10 +25,10 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 	if (par->hooknum != NF_BR_BROUTING)
 		/* rcu_read_lock()ed by nf_hook_slow */
-		memcpy(eth_hdr(skb)->h_dest,
-		       br_port_get_rcu(par->in)->br->dev->dev_addr, ETH_ALEN);
+		ether_addr_copy(eth_hdr(skb)->h_dest,
+				br_port_get_rcu(par->in)->br->dev->dev_addr);
 	else
-		memcpy(eth_hdr(skb)->h_dest, par->in->dev_addr, ETH_ALEN);
+		ether_addr_copy(eth_hdr(skb)->h_dest, par->in->dev_addr);
 	skb->pkt_type = PACKET_HOST;
 	return info->target;
 }
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 0f6b118..e56ccd0 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -24,7 +24,7 @@ ebt_snat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	if (!skb_make_writable(skb, 0))
 		return EBT_DROP;
 
-	memcpy(eth_hdr(skb)->h_source, info->mac, ETH_ALEN);
+	ether_addr_copy(eth_hdr(skb)->h_source, info->mac);
 	if (!(info->target & NAT_ARP_BIT) &&
 	    eth_hdr(skb)->h_proto == htons(ETH_P_ARP)) {
 		const struct arphdr *ap;
-- 
1.8.1.2.459.gbcd45b4.dirty

