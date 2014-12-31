Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaLaIqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:46:10 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57175 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbaLaIp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:45:56 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] phy: phy-ti-pipe3: fix inconsistent enumeration of PCIe gen2 cards
Date: Wed, 31 Dec 2014 14:15:49 +0530
Message-ID: <1420015549-20697-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420015549-20697-1-git-send-email-kishon@ti.com>
References: <1420015549-20697-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vignesh R <vigneshr@ti.com>

Prior to DRA74x silicon rev 1.1, pcie_pcs register bits 8-15 and bits 16-23
were used to configure RC delay count for phy1 and phy2 respectively.
phyid was used as index to distinguish the phys and to configure the delay
values appropriately.

As of DRA74x silicon rev 1.1, pcie_pcs register definition has changed.
Bits 16-23 are used to configure delay values for *both* phy1 and phy2.

Hence phyid is no longer required.

So, drop id field from ti_pipe3 structure and its subsequent references
for configuring pcie_pcs register.

Also, pcie_pcs register now needs to be configured with delay value of 0x96
at bit positions 16-23. See register description of CTRL_CORE_PCIE_PCS in
ARM572x TRM, SPRUHZ6, October 2014, section 18.5.2.2, table 18-1804.

This is needed to ensure Gen2 cards are enumerated consistently.

DRA72x silicon behaves same way as DRA74x rev 1.1 as far as this functionality
is considered.

Test results on DRA74x and DRA72x EVMs:

Before patch
------------
DRA74x ES 1.0: Gen1 cards work, Gen2 cards do not work (expected result due to
silicon errata)
DRA74x ES 1.1: Gen1 cards work, Gen2 cards do not work sometimes due to incorrect
programming of register

DRA72x: Gen1 cards work, Gen2 cards do not work sometimes due to incorrect
programming of register

After patch
-----------
DRA74x ES 1.0: Gen1 cards work, Gen2 cards do not work (expected result due to
silicon errata)
DRA74x ES 1.1: Gen1 cards work, Gen2 cards work consistently.

DRA72x: Gen1 and Gen2 cards enumerate consistently.

Signed-off-by: Vignesh R <vigneshr@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-omap-control.c       |    7 +++----
 drivers/phy/phy-ti-pipe3.c           |   10 ++++++----
 include/linux/phy/omap_control_phy.h |    6 +++---
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
index c96e818..efe724f 100644
--- a/drivers/phy/phy-omap-control.c
+++ b/drivers/phy/phy-omap-control.c
@@ -29,10 +29,9 @@
 /**
  * omap_control_pcie_pcs - set the PCS delay count
  * @dev: the control module device
- * @id: index of the pcie PHY (should be 1 or 2)
  * @delay: 8 bit delay value
  */
-void omap_control_pcie_pcs(struct device *dev, u8 id, u8 delay)
+void omap_control_pcie_pcs(struct device *dev, u8 delay)
 {
 	u32 val;
 	struct omap_control_phy	*control_phy;
@@ -55,8 +54,8 @@ void omap_control_pcie_pcs(struct device *dev, u8 id, u8 delay)
 
 	val = readl(control_phy->pcie_pcs);
 	val &= ~(OMAP_CTRL_PCIE_PCS_MASK <<
-		(id * OMAP_CTRL_PCIE_PCS_DELAY_COUNT_SHIFT));
-	val |= delay << (id * OMAP_CTRL_PCIE_PCS_DELAY_COUNT_SHIFT);
+		OMAP_CTRL_PCIE_PCS_DELAY_COUNT_SHIFT);
+	val |= (delay << OMAP_CTRL_PCIE_PCS_DELAY_COUNT_SHIFT);
 	writel(val, control_phy->pcie_pcs);
 }
 EXPORT_SYMBOL_GPL(omap_control_pcie_pcs);
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 1387b4d..465de2c 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -82,7 +82,6 @@ struct ti_pipe3 {
 	struct clk		*refclk;
 	struct clk		*div_clk;
 	struct pipe3_dpll_map	*dpll_map;
-	u8			id;
 };
 
 static struct pipe3_dpll_map dpll_map_usb[] = {
@@ -217,8 +216,13 @@ static int ti_pipe3_init(struct phy *x)
 	u32 val;
 	int ret = 0;
 
+	/*
+	 * Set pcie_pcs register to 0x96 for proper functioning of phy
+	 * as recommended in AM572x TRM SPRUHZ6, section 18.5.2.2, table
+	 * 18-1804.
+	 */
 	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-pcie")) {
-		omap_control_pcie_pcs(phy->control_dev, phy->id, 0xF1);
+		omap_control_pcie_pcs(phy->control_dev, 0x96);
 		return 0;
 	}
 
@@ -347,8 +351,6 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 	}
 
 	if (of_device_is_compatible(node, "ti,phy-pipe3-pcie")) {
-		if (of_property_read_u8(node, "id", &phy->id) < 0)
-			phy->id = 1;
 
 		clk = devm_clk_get(phy->dev, "dpll_ref");
 		if (IS_ERR(clk)) {
diff --git a/include/linux/phy/omap_control_phy.h b/include/linux/phy/omap_control_phy.h
index e9e6cfb..eb7d4a1 100644
--- a/include/linux/phy/omap_control_phy.h
+++ b/include/linux/phy/omap_control_phy.h
@@ -66,7 +66,7 @@ enum omap_control_usb_mode {
 #define	OMAP_CTRL_PIPE3_PHY_TX_RX_POWEROFF	0x0
 
 #define	OMAP_CTRL_PCIE_PCS_MASK			0xff
-#define	OMAP_CTRL_PCIE_PCS_DELAY_COUNT_SHIFT	0x8
+#define	OMAP_CTRL_PCIE_PCS_DELAY_COUNT_SHIFT	16
 
 #define OMAP_CTRL_USB2_PHY_PD		BIT(28)
 
@@ -79,7 +79,7 @@ enum omap_control_usb_mode {
 void omap_control_phy_power(struct device *dev, int on);
 void omap_control_usb_set_mode(struct device *dev,
 			       enum omap_control_usb_mode mode);
-void omap_control_pcie_pcs(struct device *dev, u8 id, u8 delay);
+void omap_control_pcie_pcs(struct device *dev, u8 delay);
 #else
 
 static inline void omap_control_phy_power(struct device *dev, int on)
@@ -91,7 +91,7 @@ static inline void omap_control_usb_set_mode(struct device *dev,
 {
 }
 
-static inline void omap_control_pcie_pcs(struct device *dev, u8 id, u8 delay)
+static inline void omap_control_pcie_pcs(struct device *dev, u8 delay)
 {
 }
 #endif
-- 
1.7.9.5

