Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaCEPHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:07:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41103 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbaCEO0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 081/131] net: core: introduce netif_skb_dev_features
Date: Wed,  5 Mar 2014 14:23:25 +0000
Message-Id: <1394029455-23128-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit d206940319c41df4299db75ed56142177bb2e5f6 upstream.

Will be used by upcoming ipv4 forward path change that needs to
determine feature mask using skb->dst->dev instead of skb->dev.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/netdevice.h |  7 ++++++-
 net/core/dev.c            | 22 ++++++++++++----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 324521b..c5310ed 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2842,7 +2842,12 @@ void netdev_change_features(struct net_device *dev);
 void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 					struct net_device *dev);
 
-netdev_features_t netif_skb_features(struct sk_buff *skb);
+netdev_features_t netif_skb_dev_features(struct sk_buff *skb,
+					 const struct net_device *dev);
+static inline netdev_features_t netif_skb_features(struct sk_buff *skb)
+{
+	return netif_skb_dev_features(skb, skb->dev);
+}
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index bf33219..d31d822 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2401,7 +2401,7 @@ EXPORT_SYMBOL(netdev_rx_csum_fault);
  * 2. No high memory really exists on this machine.
  */
 
-static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
+static int illegal_highdma(const struct net_device *dev, struct sk_buff *skb)
 {
 #ifdef CONFIG_HIGHMEM
 	int i;
@@ -2481,34 +2481,36 @@ static int dev_gso_segment(struct sk_buff *skb, netdev_features_t features)
 }
 
 static netdev_features_t harmonize_features(struct sk_buff *skb,
-	netdev_features_t features)
+					    const struct net_device *dev,
+					    netdev_features_t features)
 {
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, skb_network_protocol(skb))) {
 		features &= ~NETIF_F_ALL_CSUM;
-	} else if (illegal_highdma(skb->dev, skb)) {
+	} else if (illegal_highdma(dev, skb)) {
 		features &= ~NETIF_F_SG;
 	}
 
 	return features;
 }
 
-netdev_features_t netif_skb_features(struct sk_buff *skb)
+netdev_features_t netif_skb_dev_features(struct sk_buff *skb,
+					 const struct net_device *dev)
 {
 	__be16 protocol = skb->protocol;
-	netdev_features_t features = skb->dev->features;
+	netdev_features_t features = dev->features;
 
-	if (skb_shinfo(skb)->gso_segs > skb->dev->gso_max_segs)
+	if (skb_shinfo(skb)->gso_segs > dev->gso_max_segs)
 		features &= ~NETIF_F_GSO_MASK;
 
 	if (protocol == htons(ETH_P_8021Q) || protocol == htons(ETH_P_8021AD)) {
 		struct vlan_ethhdr *veh = (struct vlan_ethhdr *)skb->data;
 		protocol = veh->h_vlan_encapsulated_proto;
 	} else if (!vlan_tx_tag_present(skb)) {
-		return harmonize_features(skb, features);
+		return harmonize_features(skb, dev, features);
 	}
 
-	features &= (skb->dev->vlan_features | NETIF_F_HW_VLAN_CTAG_TX |
+	features &= (dev->vlan_features | NETIF_F_HW_VLAN_CTAG_TX |
 					       NETIF_F_HW_VLAN_STAG_TX);
 
 	if (protocol == htons(ETH_P_8021Q) || protocol == htons(ETH_P_8021AD))
@@ -2516,9 +2518,9 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 				NETIF_F_GEN_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_STAG_TX;
 
-	return harmonize_features(skb, features);
+	return harmonize_features(skb, dev, features);
 }
-EXPORT_SYMBOL(netif_skb_features);
+EXPORT_SYMBOL(netif_skb_dev_features);
 
 /*
  * Returns true if either:
-- 
1.9.0

