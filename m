Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaJMCtC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:49:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaJMC2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:28:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 17/55] net: fix checksum features handling in netif_skb_features()
Date: Mon, 13 Oct 2014 04:24:31 +0200
Message-Id: <20141013022444.468386141@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michal=20Kube=C4=8Dek?= <mkubecek@suse.cz>

[ Upstream commit db115037bb57cdfe97078b13da762213f7980e81 ]

This is follow-up to

  da08143b8520 ("vlan: more careful checksum features handling")

which introduced more careful feature intersection in vlan code,
taking into account that HW_CSUM should be considered superset
of IP_CSUM/IPV6_CSUM. The same is needed in netif_skb_features()
in order to avoid offloading mismatch warning when vlan is
created on top of a bond consisting of slaves supporting IP/IPv6
checksumming but not vlan Tx offloading.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2576,13 +2576,19 @@ netdev_features_t netif_skb_features(str
 		return harmonize_features(skb, features);
 	}
 
-	features &= (skb->dev->vlan_features | NETIF_F_HW_VLAN_CTAG_TX |
-					       NETIF_F_HW_VLAN_STAG_TX);
+	features = netdev_intersect_features(features,
+					     skb->dev->vlan_features |
+					     NETIF_F_HW_VLAN_CTAG_TX |
+					     NETIF_F_HW_VLAN_STAG_TX);
 
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


