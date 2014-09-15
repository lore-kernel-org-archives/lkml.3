Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaIOOFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:05:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38259 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752831AbaIOOB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:01:58 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/9] net: pxa168_eth: add device tree support
Date: Mon, 15 Sep 2014 16:01:46 +0200
Message-Id: <1410789713-15341-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410789713-15341-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410789713-15341-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree support to the pxa168_eth driver.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 67 ++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index b370162dbe02..a27cd85c030d 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -193,6 +193,7 @@ struct tx_desc {
 
 struct pxa168_eth_private {
 	int port_num;		/* User Ethernet port number    */
+	int phy_addr;
 
 	int rx_resource_err;	/* Rx ring resource error flag */
 
@@ -1360,24 +1361,25 @@ static struct phy_device *phy_scan(struct pxa168_eth_private *pep, int phy_addr)
 	return phydev;
 }
 
-static void phy_init(struct pxa168_eth_private *pep, int speed, int duplex)
+static void phy_init(struct pxa168_eth_private *pep)
 {
 	struct phy_device *phy = pep->phy;
 
 	phy_attach(pep->dev, dev_name(&phy->dev), PHY_INTERFACE_MODE_MII);
 
-	if (speed == 0) {
+	if (pep->pd && pep->pd->speed != 0) {
+		phy->autoneg = AUTONEG_DISABLE;
+		phy->advertising = 0;
+		phy->speed = pep->pd->speed;
+		phy->duplex = pep->pd->duplex;
+	} else {
 		phy->autoneg = AUTONEG_ENABLE;
 		phy->speed = 0;
 		phy->duplex = 0;
 		phy->supported &= PHY_BASIC_FEATURES;
 		phy->advertising = phy->supported | ADVERTISED_Autoneg;
-	} else {
-		phy->autoneg = AUTONEG_DISABLE;
-		phy->advertising = 0;
-		phy->speed = speed;
-		phy->duplex = duplex;
 	}
+
 	phy_start_aneg(phy);
 }
 
@@ -1385,11 +1387,13 @@ static int ethernet_phy_setup(struct net_device *dev)
 {
 	struct pxa168_eth_private *pep = netdev_priv(dev);
 
-	if (pep->pd->init)
+	if (pep->pd && pep->pd->init)
 		pep->pd->init();
-	pep->phy = phy_scan(pep, pep->pd->phy_addr & 0x1f);
+
+	pep->phy = phy_scan(pep, pep->phy_addr & 0x1f);
 	if (pep->phy != NULL)
-		phy_init(pep, pep->pd->speed, pep->pd->duplex);
+		phy_init(pep);
+
 	update_hash_table_mac_address(pep, NULL, dev->dev_addr);
 
 	return 0;
@@ -1453,12 +1457,12 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 	printk(KERN_NOTICE "PXA168 10/100 Ethernet Driver\n");
 
-	clk = clk_get(&pdev->dev, "MFUCLK");
+	clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "Fast Ethernet failed to get clock\n");
 		return -ENODEV;
 	}
-	clk_enable(clk);
+	clk_prepare_enable(clk);
 
 	dev = alloc_etherdev(sizeof(struct pxa168_eth_private));
 	if (!dev) {
@@ -1475,8 +1479,8 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 		err = -ENODEV;
 		goto err_netdev;
 	}
-	pep->base = ioremap(res->start, resource_size(res));
-	if (pep->base == NULL) {
+	pep->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pep->base)) {
 		err = -ENOMEM;
 		goto err_netdev;
 	}
@@ -1493,16 +1497,26 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "Using random mac address\n");
 	eth_hw_addr_random(dev);
 
-	pep->pd = dev_get_platdata(&pdev->dev);
 	pep->rx_ring_size = NUM_RX_DESCS;
-	if (pep->pd->rx_queue_size)
-		pep->rx_ring_size = pep->pd->rx_queue_size;
-
 	pep->tx_ring_size = NUM_TX_DESCS;
-	if (pep->pd->tx_queue_size)
-		pep->tx_ring_size = pep->pd->tx_queue_size;
 
-	pep->port_num = pep->pd->port_number;
+	pep->pd = dev_get_platdata(&pdev->dev);
+	if (pep->pd) {
+		if (pep->pd->rx_queue_size)
+			pep->rx_ring_size = pep->pd->rx_queue_size;
+
+		if (pep->pd->tx_queue_size)
+			pep->tx_ring_size = pep->pd->tx_queue_size;
+
+		pep->port_num = pep->pd->port_number;
+		pep->phy_addr = pep->pd->phy_addr;
+	} else if (pdev->dev.of_node) {
+		of_property_read_u32(pdev->dev.of_node, "port-id",
+				     &pep->port_num);
+		of_property_read_u32(pdev->dev.of_node, "phy-addr",
+				     &pep->phy_addr);
+	}
+
 	/* Hardware supports only 3 ports */
 	BUG_ON(pep->port_num > 2);
 	netif_napi_add(dev, &pep->napi, pxa168_rx_poll, pep->rx_ring_size);
@@ -1603,6 +1617,12 @@ static int pxa168_eth_suspend(struct platform_device *pdev, pm_message_t state)
 #define pxa168_eth_suspend NULL
 #endif
 
+static const struct of_device_id pxa168_eth_of_match[] = {
+	{ .compatible = "marvell,pxa168-eth" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pxa168_eth_of_match)
+
 static struct platform_driver pxa168_eth_driver = {
 	.probe = pxa168_eth_probe,
 	.remove = pxa168_eth_remove,
@@ -1610,8 +1630,9 @@ static struct platform_driver pxa168_eth_driver = {
 	.resume = pxa168_eth_resume,
 	.suspend = pxa168_eth_suspend,
 	.driver = {
-		   .name = DRIVER_NAME,
-		   },
+		.name		= DRIVER_NAME,
+		.of_match_table	= of_match_ptr(pxa168_eth_of_match),
+	},
 };
 
 module_platform_driver(pxa168_eth_driver);
-- 
1.9.1

