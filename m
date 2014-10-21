Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaJUI5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:57:49 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51222 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaJUIyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:54:00 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] net: pxa168_eth: Prepare proper libphy handling
Date: Tue, 21 Oct 2014 10:53:41 +0200
Message-Id: <1413881627-21639-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413881627-21639-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413881627-21639-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current libphy handling in pxa168_eth lacks proper phy_connect. Prepare
to fix this by first moving phy properties from platform_data to private
driver data.

Tested-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 38 +++++++++++++++++++------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index c3b209cd0660..332700144d81 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -197,6 +197,9 @@ struct tx_desc {
 struct pxa168_eth_private {
 	int port_num;		/* User Ethernet port number    */
 	int phy_addr;
+	int phy_speed;
+	int phy_duplex;
+	phy_interface_t phy_intf;
 
 	int rx_resource_err;	/* Rx ring resource error flag */
 
@@ -1394,19 +1397,17 @@ static void phy_init(struct pxa168_eth_private *pep)
 {
 	struct phy_device *phy = pep->phy;
 
-	phy_attach(pep->dev, dev_name(&phy->dev), PHY_INTERFACE_MODE_MII);
+	phy_attach(pep->dev, dev_name(&phy->dev), pep->phy_intf);
 
-	if (pep->pd && pep->pd->speed != 0) {
+	phy->speed = pep->phy_speed;
+	phy->duplex = pep->phy_duplex;
+	phy->autoneg = AUTONEG_ENABLE;
+	phy->supported &= PHY_BASIC_FEATURES;
+	phy->advertising = phy->supported | ADVERTISED_Autoneg;
+
+	if (pep->phy_speed != 0) {
 		phy->autoneg = AUTONEG_DISABLE;
 		phy->advertising = 0;
-		phy->speed = pep->pd->speed;
-		phy->duplex = pep->pd->duplex;
-	} else {
-		phy->autoneg = AUTONEG_ENABLE;
-		phy->speed = 0;
-		phy->duplex = 0;
-		phy->supported &= PHY_BASIC_FEATURES;
-		phy->advertising = phy->supported | ADVERTISED_Autoneg;
 	}
 
 	phy_start_aneg(phy);
@@ -1416,9 +1417,6 @@ static int ethernet_phy_setup(struct net_device *dev)
 {
 	struct pxa168_eth_private *pep = netdev_priv(dev);
 
-	if (pep->pd && pep->pd->init)
-		pep->pd->init();
-
 	pep->phy = phy_scan(pep, pep->phy_addr & 0x1f);
 	if (pep->phy != NULL)
 		phy_init(pep);
@@ -1552,13 +1550,23 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 		pep->port_num = pep->pd->port_number;
 		pep->phy_addr = pep->pd->phy_addr;
+		pep->phy_speed = pep->pd->speed;
+		pep->phy_duplex = pep->pd->duplex;
+		pep->phy_intf = pep->pd->intf;
+
+		if (pep->pd->init)
+			pep->pd->init();
 	} else if (pdev->dev.of_node) {
 		of_property_read_u32(pdev->dev.of_node, "port-id",
 				     &pep->port_num);
 
 		np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
-		if (np)
-			of_property_read_u32(np, "reg", &pep->phy_addr);
+		if (!np) {
+			dev_err(&pdev->dev, "missing phy-handle\n");
+			return -EINVAL;
+		}
+		of_property_read_u32(np, "reg", &pep->phy_addr);
+		pep->phy_intf = of_get_phy_mode(np);
 	}
 
 	/* Hardware supports only 3 ports */
-- 
2.1.1

