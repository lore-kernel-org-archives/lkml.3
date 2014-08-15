Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaHOJ4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:56:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbaHOJ4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:56:20 -0400
From: Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] net: fix checksum features handling in
 netif_skb_features()
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140815095617.3006CA0BED@unicorn.suse.cz>
Date: Fri, 15 Aug 2014 11:56:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is follow-up to

  da08143b8520 ("vlan: more careful checksum features handling")

which introduced more careful feature intersection in vlan code,
taking into account that HW_CSUM should be considered superset
of IP_CSUM/IPV6_CSUM. The same is needed in netif_skb_features()
in order to avoid offloading mismatch warning when vlan is
created on top of a bond consisting of slaves supporting IP/IPv6
checksumming but not vlan Tx offloading.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/core/dev.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b65a505..75f0096 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2587,13 +2587,18 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		return harmonize_features(skb, features);
 	}
 
-	features &= (skb->dev->vlan_features | NETIF_F_HW_VLAN_CTAG_TX |
-					       NETIF_F_HW_VLAN_STAG_TX);
+	features = netdev_intersect_features(features, skb->dev->vlan_features |
+						       NETIF_F_HW_VLAN_CTAG_TX |
+						       NETIF_F_HW_VLAN_STAG_TX);
 
 	if (protocol == htons(ETH_P_8021Q) || protocol == htons(ETH_P_8021AD))
-		features &= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST |
-				NETIF_F_GEN_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_STAG_TX;
+		features = netdev_intersect_features(features,
+						     NETIF_F_SG |
+						     NETIF_F_HIGHDMA |
+						     NETIF_F_FRAGLIST |
+						     NETIF_F_GEN_CSUM |
+						     NETIF_F_HW_VLAN_CTAG_TX |
+						     NETIF_F_HW_VLAN_STAG_TX);
 
 	return harmonize_features(skb, features);
 }
-- 
1.8.4.5

