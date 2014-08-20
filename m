Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaHTGdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:33:47 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:25536
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750789AbaHTGdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:33:46 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Vince Bridgers <vbridger@altera.com>
Subject: [PATCH] net: stmmac: add fix_mac_speed support for socfpga
Date: Wed, 20 Aug 2014 14:33:33 +0800
Message-ID: <1408516413-2928-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(88136002)(77982001)(80022001)(44976005)(77096002)(50226001)(79102001)(47776003)(104166001)(87936001)(68736004)(77156001)(64706001)(50466002)(84676001)(48376002)(102836001)(81542001)(83322001)(19580395003)(76482001)(97736001)(87286001)(99396002)(50986999)(19580405001)(6806004)(4396001)(85306004)(89996001)(107046002)(105596002)(74502001)(31966008)(20776003)(95666004)(42186005)(92726001)(86362001)(83072002)(21056001)(93916002)(81342001)(74662001)(36756003)(33646002)(46102001)(92566001)(106466001)(229853001)(85852003)(62966002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0641;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03094A4065
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds fix_mac_speed() support for
Altera socfpga Ethernet controller. Emac splitter is a
soft IP core in FPGA system that converts GMII interface from
Synopsys mac to RGMII/SGMII interface. This splitter core is
an optional IP if user would like to use RGMII/SGMII
interface in their system. Software needs to update a register
in splitter core when there is speed change.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 .../devicetree/bindings/net/socfpga-dwmac.txt      |  4 ++
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    | 63 ++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/socfpga-dwmac.txt b/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
index 2a60cd3..3a9d679 100644
--- a/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
+++ b/Documentation/devicetree/bindings/net/socfpga-dwmac.txt
@@ -12,6 +12,10 @@ Required properties:
  - altr,sysmgr-syscon : Should be the phandle to the system manager node that
    encompasses the glue register, the register offset, and the register shift.
 
+Optional properties:
+altr,emac-splitter: Should be the phandle to the emac splitter soft IP node if
+		DWMAC controller is connected emac splitter.
+
 Example:
 
 gmac0: ethernet@ff700000 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index ec632e6..cd613d7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -17,6 +17,7 @@
 
 #include <linux/mfd/syscon.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_net.h>
 #include <linux/phy.h>
 #include <linux/regmap.h>
@@ -30,6 +31,12 @@
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_WIDTH 2
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_MASK 0x00000003
 
+#define EMAC_SPLITTER_CTRL_REG			0x0
+#define EMAC_SPLITTER_CTRL_SPEED_MASK		0x3
+#define EMAC_SPLITTER_CTRL_SPEED_10		0x2
+#define EMAC_SPLITTER_CTRL_SPEED_100		0x3
+#define EMAC_SPLITTER_CTRL_SPEED_1000		0x0
+
 struct socfpga_dwmac {
 	int	interface;
 	u32	reg_offset;
@@ -37,14 +44,46 @@ struct socfpga_dwmac {
 	struct	device *dev;
 	struct regmap *sys_mgr_base_addr;
 	struct reset_control *stmmac_rst;
+	void __iomem *splitter_base;
 };
 
+static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
+{
+	struct socfpga_dwmac *dwmac = (struct socfpga_dwmac *)priv;
+	void __iomem *splitter_base = dwmac->splitter_base;
+	u32 val;
+
+	if (!splitter_base)
+		return;
+
+	val = readl(splitter_base + EMAC_SPLITTER_CTRL_REG);
+	val &= ~EMAC_SPLITTER_CTRL_SPEED_MASK;
+
+	switch (speed) {
+	case 1000:
+		val |= EMAC_SPLITTER_CTRL_SPEED_1000;
+		break;
+	case 100:
+		val |= EMAC_SPLITTER_CTRL_SPEED_100;
+		break;
+	case 10:
+		val |= EMAC_SPLITTER_CTRL_SPEED_10;
+		break;
+	default:
+		return;
+	}
+
+	writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
+}
+
 static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *dev)
 {
 	struct device_node *np = dev->of_node;
 	struct regmap *sys_mgr_base_addr;
 	u32 reg_offset, reg_shift;
 	int ret;
+	struct device_node *np_splitter;
+	struct resource res_splitter;
 
 	dwmac->stmmac_rst = devm_reset_control_get(dev,
 						  STMMAC_RESOURCE_NAME);
@@ -73,6 +112,21 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 		return -EINVAL;
 	}
 
+	np_splitter = of_parse_phandle(np, "altr,emac-splitter", 0);
+	if (np_splitter) {
+		if (of_address_to_resource(np_splitter, 0, &res_splitter)) {
+			dev_info(dev, "Missing emac splitter address\n");
+			return -EINVAL;
+		}
+
+		dwmac->splitter_base = (void *)devm_ioremap_resource(dev,
+			&res_splitter);
+		if (!dwmac->splitter_base) {
+			dev_info(dev, "Failed to mapping emac splitter\n");
+			return -EINVAL;
+		}
+	}
+
 	dwmac->reg_offset = reg_offset;
 	dwmac->reg_shift = reg_shift;
 	dwmac->sys_mgr_base_addr = sys_mgr_base_addr;
@@ -91,6 +145,7 @@ static int socfpga_dwmac_setup(struct socfpga_dwmac *dwmac)
 
 	switch (phymode) {
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
 		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII;
 		break;
 	case PHY_INTERFACE_MODE_MII:
@@ -102,6 +157,13 @@ static int socfpga_dwmac_setup(struct socfpga_dwmac *dwmac)
 		return -EINVAL;
 	}
 
+	/* Overwrite val to GMII if splitter core is enabled. The phymode here
+	 * is the actual phy mode on phy hardware, but phy interface from
+	 * EMAC core is GMII.
+	 */
+	if (dwmac->splitter_base)
+		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII;
+
 	regmap_read(sys_mgr_base_addr, reg_offset, &ctrl);
 	ctrl &= ~(SYSMGR_EMACGRP_CTRL_PHYSEL_MASK << reg_shift);
 	ctrl |= val << reg_shift;
@@ -196,4 +258,5 @@ const struct stmmac_of_data socfpga_gmac_data = {
 	.setup = socfpga_dwmac_probe,
 	.init = socfpga_dwmac_init,
 	.exit = socfpga_dwmac_exit,
+	.fix_mac_speed = socfpga_dwmac_fix_mac_speed,
 };
-- 
1.8.2.1

