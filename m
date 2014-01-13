Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaAMOlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:41:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51529 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaAMO0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 74/96] net: do not pretend FRAGLIST support
Date: Mon, 13 Jan 2014 14:24:37 +0000
Message-Id: <1389623099-18783-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 28e24c62ab3062e965ef1b3bcc244d50aee7fa85 upstream.

Few network drivers really supports frag_list : virtual drivers.

Some drivers wrongly advertise NETIF_F_FRAGLIST feature.

If skb with a frag_list is given to them, packet on the wire will be
corrupt.

Remove this flag, as core networking stack will make sure to
provide packets that can be sent without corruption.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: Anirudha Sarangi <anirudh@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: used davem's backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/calxeda/xgmac.c              | 2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c         | 2 +-
 drivers/net/ethernet/tehuti/tehuti.c              | 1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c       | 2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 5 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 8a3cd87..e59baaf 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1761,7 +1761,7 @@ static int xgmac_probe(struct platform_device *pdev)
 	if (device_can_wakeup(priv->device))
 		priv->wolopts = WAKE_MAGIC;	/* Magic Frame as default */
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA;
+	ndev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA;
 	if (readl(priv->base + XGMAC_DMA_HW_FEATURE) & DMA_HW_FEAT_TXCOESEL)
 		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				     NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index f4d2da0..8b3da6e 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -3029,7 +3029,7 @@ static struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
 
 	dev->hw_features = NETIF_F_SG | NETIF_F_TSO
 		      | NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_TX | NETIF_F_LRO;
-	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_TSO
+	dev->features = NETIF_F_SG | NETIF_F_TSO
 		      | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_TX
 		      | NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_FILTER
 		      | NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 447a693..4446992 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1991,7 +1991,6 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ndev->features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO
 		    | NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX |
 		    NETIF_F_HW_VLAN_FILTER | NETIF_F_RXCSUM
-		    /*| NETIF_F_FRAGLIST */
 		    ;
 		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
 			NETIF_F_TSO | NETIF_F_HW_VLAN_TX;
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 26e487b..3ddbecf 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1027,7 +1027,7 @@ static int __devinit temac_of_probe(struct platform_device *op)
 	dev_set_drvdata(&op->dev, ndev);
 	SET_NETDEV_DEV(ndev, &op->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &temac_netdev_ops;
 	ndev->ethtool_ops = &temac_ethtool_ops;
 #if 0
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9c365e1..fde716d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1494,7 +1494,7 @@ static int __devinit axienet_of_probe(struct platform_device *op)
 
 	SET_NETDEV_DEV(ndev, &op->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &axienet_netdev_ops;
 	ndev->ethtool_ops = &axienet_ethtool_ops;
 
-- 
1.8.3.2

