Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbaJ3KVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:21:44 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63061 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758951AbaJ3KVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:21:41 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] phy: berlin-sata: Move PHY_BASE into private data struct
Date: Thu, 30 Oct 2014 11:21:24 +0100
Message-Id: <1414664488-5911-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1414664488-5911-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413882477-27922-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1414664488-5911-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, Berlin SATA PHY driver assumes PHY_BASE address being
constant. While this PHY_BASE is correct for BG2Q, older BG2 PHY_BASE
is different. Prepare the driver for BG2 support by moving the phy_base
into private driver data.

Acked-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- None
v2->v3:
- Do not use of_device_id.data for phy_base (Suggested by
  Kishon Vijay Abraham I)

Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/phy/phy-berlin-sata.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
index 69ced52d72aa..cdb46d1203a4 100644
--- a/drivers/phy/phy-berlin-sata.c
+++ b/drivers/phy/phy-berlin-sata.c
@@ -30,7 +30,7 @@
 #define MBUS_WRITE_REQUEST_SIZE_128	(BIT(2) << 16)
 #define MBUS_READ_REQUEST_SIZE_128	(BIT(2) << 19)
 
-#define PHY_BASE		0x200
+#define BG2Q_PHY_BASE		0x200
 
 /* register 0x01 */
 #define REF_FREF_SEL_25		BIT(0)
@@ -61,15 +61,16 @@ struct phy_berlin_priv {
 	struct clk		*clk;
 	struct phy_berlin_desc	**phys;
 	unsigned		nphys;
+	u32			phy_base;
 };
 
-static inline void phy_berlin_sata_reg_setbits(void __iomem *ctrl_reg, u32 reg,
-					       u32 mask, u32 val)
+static inline void phy_berlin_sata_reg_setbits(void __iomem *ctrl_reg,
+			       u32 phy_base, u32 reg, u32 mask, u32 val)
 {
 	u32 regval;
 
 	/* select register */
-	writel(PHY_BASE + reg, ctrl_reg + PORT_VSR_ADDR);
+	writel(phy_base + reg, ctrl_reg + PORT_VSR_ADDR);
 
 	/* set bits */
 	regval = readl(ctrl_reg + PORT_VSR_DATA);
@@ -103,17 +104,20 @@ static int phy_berlin_sata_power_on(struct phy *phy)
 	writel(regval, priv->base + HOST_VSA_DATA);
 
 	/* set PHY mode and ref freq to 25 MHz */
-	phy_berlin_sata_reg_setbits(ctrl_reg, 0x1, 0xff,
-				    REF_FREF_SEL_25 | PHY_MODE_SATA);
+	phy_berlin_sata_reg_setbits(ctrl_reg, priv->phy_base, 0x01,
+				    0x00ff, REF_FREF_SEL_25 | PHY_MODE_SATA);
 
 	/* set PHY up to 6 Gbps */
-	phy_berlin_sata_reg_setbits(ctrl_reg, 0x25, 0xc00, PHY_GEN_MAX_6_0);
+	phy_berlin_sata_reg_setbits(ctrl_reg, priv->phy_base, 0x25,
+				    0x0c00, PHY_GEN_MAX_6_0);
 
 	/* set 40 bits width */
-	phy_berlin_sata_reg_setbits(ctrl_reg, 0x23,  0xc00, DATA_BIT_WIDTH_40);
+	phy_berlin_sata_reg_setbits(ctrl_reg, priv->phy_base, 0x23,
+				    0x0c00, DATA_BIT_WIDTH_40);
 
 	/* use max pll rate */
-	phy_berlin_sata_reg_setbits(ctrl_reg, 0x2, 0x0, USE_MAX_PLL_RATE);
+	phy_berlin_sata_reg_setbits(ctrl_reg, priv->phy_base, 0x02,
+				    0x0000, USE_MAX_PLL_RATE);
 
 	/* set Gen3 controller speed */
 	regval = readl(ctrl_reg + PORT_SCR_CTL);
@@ -218,6 +222,8 @@ static int phy_berlin_sata_probe(struct platform_device *pdev)
 	if (!priv->phys)
 		return -ENOMEM;
 
+	priv->phy_base = BG2Q_PHY_BASE;
+
 	dev_set_drvdata(dev, priv);
 	spin_lock_init(&priv->lock);
 
-- 
2.1.1

