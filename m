Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaDAQJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44370 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaDAQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 13/86] net: core: introduce netif_skb_dev_features
Date: Tue,  1 Apr 2014 09:07:26 -0700
Message-Id: <1396368519-12728-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit d206940319c41df4299db75ed56142177bb2e5f6 upstream.

Will be used by upcoming ipv4 forward path change that needs to
determine feature mask using skb->dst->dev instead of skb->dev.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/netdevice.h |  7 ++++++-
 net/core/dev.c            | 27 ++++++++++++++++-----------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0cabad8..48b1504 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2679,7 +2679,12 @@ void netdev_change_features(struct net_device *dev);
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
index 4fe7689..59a5ce7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2153,7 +2153,7 @@ EXPORT_SYMBOL(netdev_rx_csum_fault);
  * 2. No high memory really exists on this machine.
  */
 
-static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
+static int illegal_highdma(const struct net_device *dev, struct sk_buff *skb)
 {
 #ifdef CONFIG_HIGHMEM
 	int i;
@@ -2244,45 +2244,50 @@ static bool can_checksum_protocol(netdev_features_t features, __be16 protocol)
 }
 
 static netdev_features_t harmonize_features(struct sk_buff *skb,
-	__be16 protocol, netdev_features_t features)
+					    __be16 protocol,
+					    const struct net_device *dev,
+					    netdev_features_t features)
 {
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, protocol)) {
 		features &= ~NETIF_F_ALL_CSUM;
 		features &= ~NETIF_F_SG;
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
 
 	if (protocol == htons(ETH_P_8021Q)) {
 		struct vlan_ethhdr *veh = (struct vlan_ethhdr *)skb->data;
 		protocol = veh->h_vlan_encapsulated_proto;
 	} else if (!vlan_tx_tag_present(skb)) {
-		return harmonize_features(skb, protocol, features);
+		return harmonize_features(skb, protocol, dev, features);
 	}
 
-	features &= (skb->dev->vlan_features | NETIF_F_HW_VLAN_TX);
+	features &= (dev->vlan_features | NETIF_F_HW_VLAN_TX);
 
 	if (protocol != htons(ETH_P_8021Q)) {
-		return harmonize_features(skb, protocol, features);
+		return harmonize_features(skb, protocol, dev, features);
 	} else {
 		features &= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST |
 				NETIF_F_GEN_CSUM | NETIF_F_HW_VLAN_TX;
-		return harmonize_features(skb, protocol, features);
+		return harmonize_features(skb, protocol, dev, features);
 	}
+
+	return harmonize_features(skb, protocol, dev, features);
 }
-EXPORT_SYMBOL(netif_skb_features);
+EXPORT_SYMBOL(netif_skb_dev_features);
 
 /*
  * Returns true if either:
-- 
1.8.3.2

