Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaJUJAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:00:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62602 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaJUIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:53:58 -0400
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
Subject: [PATCH 4/9] net: pxa168_eth: Remove HW auto-negotiaion
Date: Tue, 21 Oct 2014 10:53:42 +0200
Message-Id: <1413881627-21639-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413881627-21639-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413881627-21639-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marvell Ethernet IP supports PHY negotiation driven by HW. This
fundamentally clashes with libphy (software) driven negotiation and
also cannot cope with quirky PHYs. Therefore, always disable any HW
negotiation features and properly use libphy's phy_device.

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
 drivers/net/ethernet/marvell/pxa168_eth.c | 100 +++++++++++++++++++++++++-----
 1 file changed, 85 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 332700144d81..6d671f70e484 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -106,6 +106,7 @@
 #define SDMA_CMD_ERD		(1 << 7)
 
 /* Bit definitions of the Port Config Reg */
+#define PCR_DUPLEX_FULL		(1 << 15)
 #define PCR_HS			(1 << 12)
 #define PCR_EN			(1 << 7)
 #define PCR_PM			(1 << 0)
@@ -113,11 +114,17 @@
 /* Bit definitions of the Port Config Extend Reg */
 #define PCXR_2BSM		(1 << 28)
 #define PCXR_DSCP_EN		(1 << 21)
+#define PCXR_RMII_EN		(1 << 20)
+#define PCXR_AN_SPEED_DIS	(1 << 19)
+#define PCXR_SPEED_100		(1 << 18)
 #define PCXR_MFL_1518		(0 << 14)
 #define PCXR_MFL_1536		(1 << 14)
 #define PCXR_MFL_2048		(2 << 14)
 #define PCXR_MFL_64K		(3 << 14)
+#define PCXR_FLOWCTL_DIS	(1 << 12)
 #define PCXR_FLP		(1 << 11)
+#define PCXR_AN_FLOWCTL_DIS	(1 << 10)
+#define PCXR_AN_DUPLEX_DIS	(1 << 9)
 #define PCXR_PRIO_TX_OFF	3
 #define PCXR_TX_HIGH_PRI	(7 << PCXR_PRIO_TX_OFF)
 
@@ -272,6 +279,7 @@ enum hash_table_entry {
 static int pxa168_get_settings(struct net_device *dev, struct ethtool_cmd *cmd);
 static int pxa168_set_settings(struct net_device *dev, struct ethtool_cmd *cmd);
 static int pxa168_init_hw(struct pxa168_eth_private *pep);
+static int pxa168_init_phy(struct net_device *dev);
 static void eth_port_reset(struct net_device *dev);
 static void eth_port_start(struct net_device *dev);
 static int pxa168_eth_open(struct net_device *dev);
@@ -658,14 +666,7 @@ static void eth_port_start(struct net_device *dev)
 	struct pxa168_eth_private *pep = netdev_priv(dev);
 	int tx_curr_desc, rx_curr_desc;
 
-	/* Perform PHY reset, if there is a PHY. */
-	if (pep->phy != NULL) {
-		struct ethtool_cmd cmd;
-
-		pxa168_get_settings(pep->dev, &cmd);
-		phy_init_hw(pep->phy);
-		pxa168_set_settings(pep->dev, &cmd);
-	}
+	phy_start(pep->phy);
 
 	/* Assignment of Tx CTRP of given queue */
 	tx_curr_desc = pep->tx_curr_desc_q;
@@ -720,6 +721,8 @@ static void eth_port_reset(struct net_device *dev)
 	val = rdl(pep, PORT_CONFIG);
 	val &= ~PCR_EN;
 	wrl(pep, PORT_CONFIG, val);
+
+	phy_stop(pep->phy);
 }
 
 /*
@@ -981,8 +984,11 @@ static int set_port_config_ext(struct pxa168_eth_private *pep)
 		skb_size = PCXR_MFL_64K;
 
 	/* Extended Port Configuration */
-	wrl(pep,
-	    PORT_CONFIG_EXT, PCXR_2BSM | /* Two byte prefix aligns IP hdr */
+	wrl(pep, PORT_CONFIG_EXT,
+	    PCXR_AN_SPEED_DIS |		 /* Disable HW AN */
+	    PCXR_AN_DUPLEX_DIS |
+	    PCXR_AN_FLOWCTL_DIS |
+	    PCXR_2BSM |			 /* Two byte prefix aligns IP hdr */
 	    PCXR_DSCP_EN |		 /* Enable DSCP in IP */
 	    skb_size | PCXR_FLP |	 /* do not force link pass */
 	    PCXR_TX_HIGH_PRI);		 /* Transmit - high priority queue */
@@ -990,6 +996,69 @@ static int set_port_config_ext(struct pxa168_eth_private *pep)
 	return 0;
 }
 
+static void pxa168_eth_adjust_link(struct net_device *dev)
+{
+	struct pxa168_eth_private *pep = netdev_priv(dev);
+	struct phy_device *phy = pep->phy;
+	u32 cfg, cfg_o = rdl(pep, PORT_CONFIG);
+	u32 cfgext, cfgext_o = rdl(pep, PORT_CONFIG_EXT);
+
+	cfg = cfg_o & ~PCR_DUPLEX_FULL;
+	cfgext = cfgext_o & ~(PCXR_SPEED_100 | PCXR_FLOWCTL_DIS | PCXR_RMII_EN);
+
+	if (phy->interface == PHY_INTERFACE_MODE_RMII)
+		cfgext |= PCXR_RMII_EN;
+	if (phy->speed == SPEED_100)
+		cfgext |= PCXR_SPEED_100;
+	if (phy->duplex)
+		cfg |= PCR_DUPLEX_FULL;
+	if (!phy->pause)
+		cfgext |= PCXR_FLOWCTL_DIS;
+
+	/* Bail out if there has nothing changed */
+	if (cfg == cfg_o && cfgext == cfgext_o)
+		return;
+
+	wrl(pep, PORT_CONFIG, cfg);
+	wrl(pep, PORT_CONFIG_EXT, cfgext);
+
+	phy_print_status(phy);
+}
+
+static int pxa168_init_phy(struct net_device *dev)
+{
+	struct pxa168_eth_private *pep = netdev_priv(dev);
+	struct ethtool_cmd cmd;
+	int err;
+
+	if (pep->phy)
+		return 0;
+
+	pep->phy = mdiobus_scan(pep->smi_bus, pep->phy_addr);
+	if (!pep->phy)
+		return -ENODEV;
+
+	err = phy_connect_direct(dev, pep->phy, pxa168_eth_adjust_link,
+				 pep->phy_intf);
+	if (err)
+		return err;
+
+	err = pxa168_get_settings(dev, &cmd);
+	if (err)
+		return err;
+
+	cmd.phy_address = pep->phy_addr;
+	cmd.speed = pep->phy_speed;
+	cmd.duplex = pep->phy_duplex;
+	cmd.advertising = PHY_BASIC_FEATURES;
+	cmd.autoneg = AUTONEG_ENABLE;
+
+	if (cmd.speed != 0)
+		cmd.autoneg = AUTONEG_DISABLE;
+
+	return pxa168_set_settings(dev, &cmd);
+}
+
 static int pxa168_init_hw(struct pxa168_eth_private *pep)
 {
 	int err = 0;
@@ -1136,6 +1205,10 @@ static int pxa168_eth_open(struct net_device *dev)
 	struct pxa168_eth_private *pep = netdev_priv(dev);
 	int err;
 
+	err = pxa168_init_phy(dev);
+	if (err)
+		return err;
+
 	err = request_irq(dev->irq, pxa168_eth_int_handler, 0, dev->name, dev);
 	if (err) {
 		dev_err(&dev->dev, "can't assign irq\n");
@@ -1596,9 +1669,6 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 		goto err_free_mdio;
 
 	pxa168_init_hw(pep);
-	err = ethernet_phy_setup(dev);
-	if (err)
-		goto err_mdiobus;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	err = register_netdev(dev);
 	if (err)
@@ -1629,13 +1699,13 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 				  pep->htpr, pep->htpr_dma);
 		pep->htpr = NULL;
 	}
+	if (pep->phy)
+		phy_disconnect(pep->phy);
 	if (pep->clk) {
 		clk_disable(pep->clk);
 		clk_put(pep->clk);
 		pep->clk = NULL;
 	}
-	if (pep->phy != NULL)
-		phy_detach(pep->phy);
 
 	iounmap(pep->base);
 	pep->base = NULL;
-- 
2.1.1

