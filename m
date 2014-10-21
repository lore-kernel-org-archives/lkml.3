Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaJUI5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:57:51 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:49065 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaJUIyA (ORCPT
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
Subject: [PATCH 5/9] net: pxa168_eth: Remove in-driver PHY mangling
Date: Tue, 21 Oct 2014 10:53:43 +0200
Message-Id: <1413881627-21639-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413881627-21639-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413881627-21639-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With properly using libphy PHYs now, remove the in-driver PHY
mangling.

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
 drivers/net/ethernet/marvell/pxa168_eth.c | 126 ------------------------------
 1 file changed, 126 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 6d671f70e484..0374eac76fdf 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -177,7 +177,6 @@
 #define LINK_UP			(1 << 3)
 
 /* Bit definitions for work to be done */
-#define WORK_LINK		(1 << 0)
 #define WORK_TX_DONE		(1 << 1)
 
 /*
@@ -284,7 +283,6 @@ static void eth_port_reset(struct net_device *dev);
 static void eth_port_start(struct net_device *dev);
 static int pxa168_eth_open(struct net_device *dev);
 static int pxa168_eth_stop(struct net_device *dev);
-static int ethernet_phy_setup(struct net_device *dev);
 
 static inline u32 rdl(struct pxa168_eth_private *pep, int offset)
 {
@@ -316,26 +314,6 @@ static void abort_dma(struct pxa168_eth_private *pep)
 		netdev_err(pep->dev, "%s : DMA Stuck\n", __func__);
 }
 
-static int ethernet_phy_get(struct pxa168_eth_private *pep)
-{
-	unsigned int reg_data;
-
-	reg_data = rdl(pep, PHY_ADDRESS);
-
-	return (reg_data >> (5 * pep->port_num)) & 0x1f;
-}
-
-static void ethernet_phy_set_addr(struct pxa168_eth_private *pep, int phy_addr)
-{
-	u32 reg_data;
-	int addr_shift = 5 * pep->port_num;
-
-	reg_data = rdl(pep, PHY_ADDRESS);
-	reg_data &= ~(0x1f << addr_shift);
-	reg_data |= (phy_addr & 0x1f) << addr_shift;
-	wrl(pep, PHY_ADDRESS, reg_data);
-}
-
 static void rxq_refill(struct net_device *dev)
 {
 	struct pxa168_eth_private *pep = netdev_priv(dev);
@@ -890,43 +868,9 @@ static int pxa168_eth_collect_events(struct pxa168_eth_private *pep,
 	}
 	if (icr & ICR_RXBUF)
 		ret = 1;
-	if (icr & ICR_MII_CH) {
-		pep->work_todo |= WORK_LINK;
-		ret = 1;
-	}
 	return ret;
 }
 
-static void handle_link_event(struct pxa168_eth_private *pep)
-{
-	struct net_device *dev = pep->dev;
-	u32 port_status;
-	int speed;
-	int duplex;
-	int fc;
-
-	port_status = rdl(pep, PORT_STATUS);
-	if (!(port_status & LINK_UP)) {
-		if (netif_carrier_ok(dev)) {
-			netdev_info(dev, "link down\n");
-			netif_carrier_off(dev);
-			txq_reclaim(dev, 1);
-		}
-		return;
-	}
-	if (port_status & PORT_SPEED_100)
-		speed = 100;
-	else
-		speed = 10;
-
-	duplex = (port_status & FULL_DUPLEX) ? 1 : 0;
-	fc = (port_status & FLOW_CONTROL_DISABLED) ? 0 : 1;
-	netdev_info(dev, "link up, %d Mb/s, %s duplex, flow control %sabled\n",
-		    speed, duplex ? "full" : "half", fc ? "en" : "dis");
-	if (!netif_carrier_ok(dev))
-		netif_carrier_on(dev);
-}
-
 static irqreturn_t pxa168_eth_int_handler(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
@@ -1307,10 +1251,6 @@ static int pxa168_rx_poll(struct napi_struct *napi, int budget)
 	struct net_device *dev = pep->dev;
 	int work_done = 0;
 
-	if (unlikely(pep->work_todo & WORK_LINK)) {
-		pep->work_todo &= ~(WORK_LINK);
-		handle_link_event(pep);
-	}
 	/*
 	 * We call txq_reclaim every time since in NAPI interupts are disabled
 	 * and due to this we miss the TX_DONE interrupt,which is not updated in
@@ -1433,72 +1373,6 @@ static int pxa168_eth_do_ioctl(struct net_device *dev, struct ifreq *ifr,
 	return -EOPNOTSUPP;
 }
 
-static struct phy_device *phy_scan(struct pxa168_eth_private *pep, int phy_addr)
-{
-	struct mii_bus *bus = pep->smi_bus;
-	struct phy_device *phydev;
-	int start;
-	int num;
-	int i;
-
-	if (phy_addr == PXA168_ETH_PHY_ADDR_DEFAULT) {
-		/* Scan entire range */
-		start = ethernet_phy_get(pep);
-		num = 32;
-	} else {
-		/* Use phy addr specific to platform */
-		start = phy_addr & 0x1f;
-		num = 1;
-	}
-	phydev = NULL;
-	for (i = 0; i < num; i++) {
-		int addr = (start + i) & 0x1f;
-		if (bus->phy_map[addr] == NULL)
-			mdiobus_scan(bus, addr);
-
-		if (phydev == NULL) {
-			phydev = bus->phy_map[addr];
-			if (phydev != NULL)
-				ethernet_phy_set_addr(pep, addr);
-		}
-	}
-
-	return phydev;
-}
-
-static void phy_init(struct pxa168_eth_private *pep)
-{
-	struct phy_device *phy = pep->phy;
-
-	phy_attach(pep->dev, dev_name(&phy->dev), pep->phy_intf);
-
-	phy->speed = pep->phy_speed;
-	phy->duplex = pep->phy_duplex;
-	phy->autoneg = AUTONEG_ENABLE;
-	phy->supported &= PHY_BASIC_FEATURES;
-	phy->advertising = phy->supported | ADVERTISED_Autoneg;
-
-	if (pep->phy_speed != 0) {
-		phy->autoneg = AUTONEG_DISABLE;
-		phy->advertising = 0;
-	}
-
-	phy_start_aneg(phy);
-}
-
-static int ethernet_phy_setup(struct net_device *dev)
-{
-	struct pxa168_eth_private *pep = netdev_priv(dev);
-
-	pep->phy = phy_scan(pep, pep->phy_addr & 0x1f);
-	if (pep->phy != NULL)
-		phy_init(pep);
-
-	update_hash_table_mac_address(pep, NULL, dev->dev_addr);
-
-	return 0;
-}
-
 static int pxa168_get_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 {
 	struct pxa168_eth_private *pep = netdev_priv(dev);
-- 
2.1.1

