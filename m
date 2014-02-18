Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaBRShZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:37:25 -0500
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:36380 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751043AbaBRShX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:37:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1345:1437:1535:1605:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3867:3870:3871:3872:3874:4049:4117:4250:4321:4605:5007:6119:6261:7875:7903:7974:8957:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13141:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: slip76_5d4f36a5ef522
X-Filterd-Recvd-Size: 6685
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Arvid Brodin <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] hsr: Use ether_addr_copy
Date: Tue, 18 Feb 2014 10:37:20 -0800
Message-Id: <675e6a59ebb87d5e18633df578a62a1202f6172e.1392748500.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's slightly smaller/faster for some architectures.
Make sure def_multicast_addr is __aligned(2)

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/hsr/hsr_device.c   | 10 +++++-----
 net/hsr/hsr_framereg.c | 20 ++++++++++----------
 net/hsr/hsr_main.c     |  4 ++--
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index cac505f..e5302b7 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -209,7 +209,7 @@ static int slave_xmit(struct sk_buff *skb, struct hsr_priv *hsr_priv,
 	/* Address substitution (IEC62439-3 pp 26, 50): replace mac
 	 * address of outgoing frame with that of the outgoing slave's.
 	 */
-	memcpy(hsr_ethhdr->ethhdr.h_source, skb->dev->dev_addr, ETH_ALEN);
+	ether_addr_copy(hsr_ethhdr->ethhdr.h_source, skb->dev->dev_addr);
 
 	return dev_queue_xmit(skb);
 }
@@ -346,7 +346,7 @@ static void send_hsr_supervision_frame(struct net_device *hsr_dev, u8 type)
 
 	/* Payload: MacAddressA */
 	hsr_sp = (typeof(hsr_sp)) skb_put(skb, sizeof(*hsr_sp));
-	memcpy(hsr_sp->MacAddressA, hsr_dev->dev_addr, ETH_ALEN);
+	ether_addr_copy(hsr_sp->MacAddressA, hsr_dev->dev_addr);
 
 	dev_queue_xmit(skb);
 	return;
@@ -493,7 +493,7 @@ static int check_slave_ok(struct net_device *dev)
 
 
 /* Default multicast address for HSR Supervision frames */
-static const unsigned char def_multicast_addr[ETH_ALEN] = {
+static const unsigned char def_multicast_addr[ETH_ALEN] __aligned(2) = {
 	0x01, 0x15, 0x4e, 0x00, 0x01, 0x00
 };
 
@@ -519,7 +519,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	hsr_priv->announce_timer.function = hsr_announce;
 	hsr_priv->announce_timer.data = (unsigned long) hsr_priv;
 
-	memcpy(hsr_priv->sup_multicast_addr, def_multicast_addr, ETH_ALEN);
+	ether_addr_copy(hsr_priv->sup_multicast_addr, def_multicast_addr);
 	hsr_priv->sup_multicast_addr[ETH_ALEN - 1] = multicast_spec;
 
 /* FIXME: should I modify the value of these?
@@ -547,7 +547,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	hsr_dev->features |= NETIF_F_VLAN_CHALLENGED;
 
 	/* Set hsr_dev's MAC address to that of mac_slave1 */
-	memcpy(hsr_dev->dev_addr, hsr_priv->slave[0]->dev_addr, ETH_ALEN);
+	ether_addr_copy(hsr_dev->dev_addr, hsr_priv->slave[0]->dev_addr);
 
 	/* Set required header length */
 	for (i = 0; i < HSR_MAX_SLAVE; i++) {
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 327060c..3d0100f 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -108,8 +108,8 @@ int hsr_create_self_node(struct list_head *self_node_db,
 	if (!node)
 		return -ENOMEM;
 
-	memcpy(node->MacAddressA, addr_a, ETH_ALEN);
-	memcpy(node->MacAddressB, addr_b, ETH_ALEN);
+	ether_addr_copy(node->MacAddressA, addr_a);
+	ether_addr_copy(node->MacAddressB, addr_b);
 
 	rcu_read_lock();
 	oldnode = list_first_or_null_rcu(self_node_db,
@@ -199,7 +199,7 @@ struct node_entry *hsr_merge_node(struct hsr_priv *hsr_priv,
 		/* Node is known, but frame was received from an unknown
 		 * address. Node is PICS_SUBS capable; merge its AddrB.
 		 */
-		memcpy(node->MacAddressB, hsr_ethsup->ethhdr.h_source, ETH_ALEN);
+		ether_addr_copy(node->MacAddressB, hsr_ethsup->ethhdr.h_source);
 		node->AddrB_if = dev_idx;
 		return node;
 	}
@@ -208,8 +208,8 @@ struct node_entry *hsr_merge_node(struct hsr_priv *hsr_priv,
 	if (!node)
 		return NULL;
 
-	memcpy(node->MacAddressA, hsr_sp->MacAddressA, ETH_ALEN);
-	memcpy(node->MacAddressB, hsr_ethsup->ethhdr.h_source, ETH_ALEN);
+	ether_addr_copy(node->MacAddressA, hsr_sp->MacAddressA);
+	ether_addr_copy(node->MacAddressB, hsr_ethsup->ethhdr.h_source);
 	if (!ether_addr_equal(hsr_sp->MacAddressA, hsr_ethsup->ethhdr.h_source))
 		node->AddrB_if = dev_idx;
 	else
@@ -250,7 +250,7 @@ void hsr_addr_subst_source(struct hsr_priv *hsr_priv, struct sk_buff *skb)
 	rcu_read_lock();
 	node = find_node_by_AddrB(&hsr_priv->node_db, ethhdr->h_source);
 	if (node)
-		memcpy(ethhdr->h_source, node->MacAddressA, ETH_ALEN);
+		ether_addr_copy(ethhdr->h_source, node->MacAddressA);
 	rcu_read_unlock();
 }
 
@@ -272,7 +272,7 @@ void hsr_addr_subst_dest(struct hsr_priv *hsr_priv, struct ethhdr *ethhdr,
 	rcu_read_lock();
 	node = find_node_by_AddrA(&hsr_priv->node_db, ethhdr->h_dest);
 	if (node && (node->AddrB_if == dev_idx))
-		memcpy(ethhdr->h_dest, node->MacAddressB, ETH_ALEN);
+		ether_addr_copy(ethhdr->h_dest, node->MacAddressB);
 	rcu_read_unlock();
 }
 
@@ -428,13 +428,13 @@ void *hsr_get_next_node(struct hsr_priv *hsr_priv, void *_pos,
 		node = list_first_or_null_rcu(&hsr_priv->node_db,
 						struct node_entry, mac_list);
 		if (node)
-			memcpy(addr, node->MacAddressA, ETH_ALEN);
+			ether_addr_copy(addr, node->MacAddressA);
 		return node;
 	}
 
 	node = _pos;
 	list_for_each_entry_continue_rcu(node, &hsr_priv->node_db, mac_list) {
-		memcpy(addr, node->MacAddressA, ETH_ALEN);
+		ether_addr_copy(addr, node->MacAddressA);
 		return node;
 	}
 
@@ -462,7 +462,7 @@ int hsr_get_node_data(struct hsr_priv *hsr_priv,
 		return -ENOENT;	/* No such entry */
 	}
 
-	memcpy(addr_b, node->MacAddressB, ETH_ALEN);
+	ether_addr_copy(addr_b, node->MacAddressB);
 
 	tdiff = jiffies - node->time_in[HSR_DEV_SLAVE_A];
 	if (node->time_in_stale[HSR_DEV_SLAVE_A])
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index af68dd8..10010c5 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -138,8 +138,8 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 			break;
 
 		if (dev == hsr_priv->slave[0])
-			memcpy(hsr_priv->dev->dev_addr,
-			       hsr_priv->slave[0]->dev_addr, ETH_ALEN);
+			ether_addr_copy(hsr_priv->dev->dev_addr,
+					hsr_priv->slave[0]->dev_addr);
 
 		/* Make sure we recognize frames from ourselves in hsr_rcv() */
 		res = hsr_create_self_node(&hsr_priv->self_node_db,
-- 
1.8.1.2.459.gbcd45b4.dirty

