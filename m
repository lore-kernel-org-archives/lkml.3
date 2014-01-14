Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaANA2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:28:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaANA2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 02/77] net: do not pretend FRAGLIST support
Date: Mon, 13 Jan 2014 16:27:23 -0800
Message-Id: <20140114002752.568975152@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |    2 +-
 drivers/net/ethernet/tehuti/tehuti.c              |    1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c       |    2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -3033,7 +3033,7 @@ static struct ehea_port *ehea_setup_sing
 
 	dev->hw_features = NETIF_F_SG | NETIF_F_TSO |
 		      NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_CTAG_TX;
-	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_TSO |
+	dev->features = NETIF_F_SG | NETIF_F_TSO |
 		      NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
 		      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 		      NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM;
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2019,7 +2019,6 @@ bdx_probe(struct pci_dev *pdev, const st
 		ndev->features = NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO
 		    | NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 		    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM
-		    /*| NETIF_F_FRAGLIST */
 		    ;
 		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
 			NETIF_F_TSO | NETIF_F_HW_VLAN_CTAG_TX;
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1016,7 +1016,7 @@ static int temac_of_probe(struct platfor
 	platform_set_drvdata(op, ndev);
 	SET_NETDEV_DEV(ndev, &op->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &temac_netdev_ops;
 	ndev->ethtool_ops = &temac_ethtool_ops;
 #if 0
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1486,7 +1486,7 @@ static int axienet_of_probe(struct platf
 
 	SET_NETDEV_DEV(ndev, &op->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	ndev->features = NETIF_F_SG;
 	ndev->netdev_ops = &axienet_netdev_ops;
 	ndev->ethtool_ops = &axienet_ethtool_ops;
 


