Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaAOV4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:56:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaAOV4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:56:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 139/166] net: do not pretend FRAGLIST support
Date: Wed, 15 Jan 2014 13:52:33 -0800
Message-Id: <1389822780-4729-140-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 28e24c62ab3062e965ef1b3bcc244d50aee7fa85 ]

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c         | 2 +-
 drivers/net/ethernet/tehuti/tehuti.c              | 1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c       | 2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 19b64de..69e5296 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -3029,7 +3029,7 @@ static struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
 
 	dev->hw_features = NETIF_F_SG | NETIF_F_TSO
 		      | NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_TX;
-	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_TSO
+	dev->features = NETIF_F_SG | NETIF_F_TSO
 		      | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_TX
 		      | NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_FILTER
 		      | NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 1e4d743..aab44f2 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2020,7 +2020,6 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ndev->features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO
 		    | NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX |
 		    NETIF_F_HW_VLAN_FILTER | NETIF_F_RXCSUM
-		    /*| NETIF_F_FRAGLIST */
 		    ;
 		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
 			NETIF_F_TSO | NETIF_F_HW_VLAN_TX;
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 33c111d..42d4173 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1026,7 +1026,7 @@ static int temac_of_probe(struct platform_device *op)
 	dev_set_drvdata(&op->dev, ndev);
 	SET_NETDEV_DEV(ndev, &op->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &temac_netdev_ops;
 	ndev->ethtool_ops = &temac_ethtool_ops;
 #if 0
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 6f47100..26176eb 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1500,7 +1500,7 @@ static int axienet_of_probe(struct platform_device *op)
 
 	SET_NETDEV_DEV(ndev, &op->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &axienet_netdev_ops;
 	ndev->ethtool_ops = &axienet_ethtool_ops;
 
-- 
1.8.3.2

