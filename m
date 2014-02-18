Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaBRRmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:42:55 -0500
Received: from smtprelay0187.hostedemail.com ([216.40.44.187]:46163 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753464AbaBRRmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:42:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3352:3868:3872:4321:4385:4605:5007:6261:10004:10026:10848:11026:11233:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: board35_35f13beaac859
X-Filterd-Recvd-Size: 3313
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] bonding: More use of ether_addr_copy
Date: Tue, 18 Feb 2014 09:42:45 -0800
Message-Id: <e0827821f932f8c8ad3b2b32c7ffe7ce8a9e0d90.1392745013.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1392745013.git.joe@perches.com>
References: <cover.1392745013.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's smaller and faster for some architectures.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/bonding/bond_3ad.c  | 4 ++--
 drivers/net/bonding/bond_alb.c  | 5 ++---
 drivers/net/bonding/bond_main.c | 6 +++---
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index e9edd84..7cb51f9 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2386,8 +2386,8 @@ int __bond_3ad_get_active_agg_info(struct bonding *bond,
 		ad_info->ports = aggregator->num_of_ports;
 		ad_info->actor_key = aggregator->actor_oper_aggregator_key;
 		ad_info->partner_key = aggregator->partner_oper_aggregator_key;
-		memcpy(ad_info->partner_system,
-		       aggregator->partner_system.mac_addr_value, ETH_ALEN);
+		ether_addr_copy(ad_info->partner_system,
+				aggregator->partner_system.mac_addr_value);
 		return 0;
 	}
 
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 538913e..97a43a20 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1449,9 +1449,8 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 
 	if (tx_slave && SLAVE_IS_OK(tx_slave)) {
 		if (tx_slave != rcu_dereference(bond->curr_active_slave)) {
-			memcpy(eth_data->h_source,
-			       tx_slave->dev->dev_addr,
-			       ETH_ALEN);
+			ether_addr_copy(eth_data->h_source,
+					tx_slave->dev->dev_addr);
 		}
 
 		bond_dev_queue_xmit(bond, skb, tx_slave->dev);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3bce855..4690b11 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -674,8 +674,8 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 
 		if (old_active) {
 			ether_addr_copy(tmp_mac, new_active->dev->dev_addr);
-			memcpy(saddr.sa_data, old_active->dev->dev_addr,
-			       ETH_ALEN);
+			ether_addr_copy(saddr.sa_data,
+					old_active->dev->dev_addr);
 			saddr.sa_family = new_active->dev->type;
 		} else {
 			ether_addr_copy(saddr.sa_data, bond->dev->dev_addr);
@@ -1142,7 +1142,7 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 			kfree_skb(skb);
 			return RX_HANDLER_CONSUMED;
 		}
-		memcpy(eth_hdr(skb)->h_dest, bond->dev->dev_addr, ETH_ALEN);
+		ether_addr_copy(eth_hdr(skb)->h_dest, bond->dev->dev_addr);
 	}
 
 	return ret;
-- 
1.8.1.2.459.gbcd45b4.dirty

