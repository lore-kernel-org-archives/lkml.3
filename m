Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaBRTPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:15:50 -0500
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:55112 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751239AbaBRTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:15:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1437:1535:1544:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3867:3870:3872:3874:4321:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: death53_89b8a15abcf5e
X-Filterd-Recvd-Size: 5217
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jesse Gross <jesse@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] openvswitch: Use ether_addr_copy
Date: Tue, 18 Feb 2014 11:15:45 -0800
Message-Id: <fee7d53a1cfdec0aec7ea35a1f2f4b5e66766ee3.1392750899.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's slightly smaller/faster for some architectures.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/openvswitch/actions.c      |  4 ++--
 net/openvswitch/flow.c         | 16 ++++++++--------
 net/openvswitch/flow_netlink.c | 12 ++++++------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 2c77e7b..c36856a 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -134,8 +134,8 @@ static int set_eth_addr(struct sk_buff *skb,
 
 	skb_postpull_rcsum(skb, eth_hdr(skb), ETH_ALEN * 2);
 
-	memcpy(eth_hdr(skb)->h_source, eth_key->eth_src, ETH_ALEN);
-	memcpy(eth_hdr(skb)->h_dest, eth_key->eth_dst, ETH_ALEN);
+	ether_addr_copy(eth_hdr(skb)->h_source, eth_key->eth_src);
+	ether_addr_copy(eth_hdr(skb)->h_dest, eth_key->eth_dst);
 
 	ovs_skb_postpush_rcsum(skb, eth_hdr(skb), ETH_ALEN * 2);
 
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 16f4b46..bd67bb4 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -385,14 +385,14 @@ static int parse_icmpv6(struct sk_buff *skb, struct sw_flow_key *key,
 			    && opt_len == 8) {
 				if (unlikely(!is_zero_ether_addr(key->ipv6.nd.sll)))
 					goto invalid;
-				memcpy(key->ipv6.nd.sll,
-				    &nd->opt[offset+sizeof(*nd_opt)], ETH_ALEN);
+				ether_addr_copy(key->ipv6.nd.sll,
+						&nd->opt[offset+sizeof(*nd_opt)]);
 			} else if (nd_opt->nd_opt_type == ND_OPT_TARGET_LL_ADDR
 				   && opt_len == 8) {
 				if (unlikely(!is_zero_ether_addr(key->ipv6.nd.tll)))
 					goto invalid;
-				memcpy(key->ipv6.nd.tll,
-				    &nd->opt[offset+sizeof(*nd_opt)], ETH_ALEN);
+				ether_addr_copy(key->ipv6.nd.tll,
+						&nd->opt[offset+sizeof(*nd_opt)]);
 			}
 
 			icmp_len -= opt_len;
@@ -452,8 +452,8 @@ int ovs_flow_extract(struct sk_buff *skb, u16 in_port, struct sw_flow_key *key)
 	 * header in the linear data area.
 	 */
 	eth = eth_hdr(skb);
-	memcpy(key->eth.src, eth->h_source, ETH_ALEN);
-	memcpy(key->eth.dst, eth->h_dest, ETH_ALEN);
+	ether_addr_copy(key->eth.src, eth->h_source);
+	ether_addr_copy(key->eth.dst, eth->h_dest);
 
 	__skb_pull(skb, 2 * ETH_ALEN);
 	/* We are going to push all headers that we pull, so no need to
@@ -551,8 +551,8 @@ int ovs_flow_extract(struct sk_buff *skb, u16 in_port, struct sw_flow_key *key)
 				key->ip.proto = ntohs(arp->ar_op);
 			memcpy(&key->ipv4.addr.src, arp->ar_sip, sizeof(key->ipv4.addr.src));
 			memcpy(&key->ipv4.addr.dst, arp->ar_tip, sizeof(key->ipv4.addr.dst));
-			memcpy(key->ipv4.arp.sha, arp->ar_sha, ETH_ALEN);
-			memcpy(key->ipv4.arp.tha, arp->ar_tha, ETH_ALEN);
+			ether_addr_copy(key->ipv4.arp.sha, arp->ar_sha);
+			ether_addr_copy(key->ipv4.arp.tha, arp->ar_tha);
 		}
 	} else if (key->eth.type == htons(ETH_P_IPV6)) {
 		int nh_len;             /* IPv6 Header + Extensions */
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 4d000ac..c883b18 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -982,8 +982,8 @@ int ovs_nla_put_flow(const struct sw_flow_key *swkey,
 		goto nla_put_failure;
 
 	eth_key = nla_data(nla);
-	memcpy(eth_key->eth_src, output->eth.src, ETH_ALEN);
-	memcpy(eth_key->eth_dst, output->eth.dst, ETH_ALEN);
+	ether_addr_copy(eth_key->eth_src, output->eth.src);
+	ether_addr_copy(eth_key->eth_dst, output->eth.dst);
 
 	if (swkey->eth.tci || swkey->eth.type == htons(ETH_P_8021Q)) {
 		__be16 eth_type;
@@ -1055,8 +1055,8 @@ int ovs_nla_put_flow(const struct sw_flow_key *swkey,
 		arp_key->arp_sip = output->ipv4.addr.src;
 		arp_key->arp_tip = output->ipv4.addr.dst;
 		arp_key->arp_op = htons(output->ip.proto);
-		memcpy(arp_key->arp_sha, output->ipv4.arp.sha, ETH_ALEN);
-		memcpy(arp_key->arp_tha, output->ipv4.arp.tha, ETH_ALEN);
+		ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
+		ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
 	}
 
 	if ((swkey->eth.type == htons(ETH_P_IP) ||
@@ -1143,8 +1143,8 @@ int ovs_nla_put_flow(const struct sw_flow_key *swkey,
 				nd_key = nla_data(nla);
 				memcpy(nd_key->nd_target, &output->ipv6.nd.target,
 							sizeof(nd_key->nd_target));
-				memcpy(nd_key->nd_sll, output->ipv6.nd.sll, ETH_ALEN);
-				memcpy(nd_key->nd_tll, output->ipv6.nd.tll, ETH_ALEN);
+				ether_addr_copy(nd_key->nd_sll, output->ipv6.nd.sll);
+				ether_addr_copy(nd_key->nd_tll, output->ipv6.nd.tll);
 			}
 		}
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

