Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbbANJ5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:57:46 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57549 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbbANJ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:56:54 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 1/3] phy: miphy28lp: Pass sysconfig register offsets via syscfg dt property.
Date: Wed, 14 Jan 2015 10:54:57 +0100
Message-Id: <1421229299-8206-2-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421229299-8206-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1421229299-8206-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_04:2015-01-14,2015-01-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Arnds review comments here https://lkml.org/lkml/2014/11/13/161,
update the miphy28lp phy driver to access sysconfig register offsets via
syscfg dt property.

This is because the reg property should not be mixing address spaces like
it does currently for miphy28lp. This change then also aligns us to how other
platforms such as keystone and bcm7445 pass there syscon offsets via DT.

I have updated the miphy28lp phy driver same way as Peter's implementation.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 .../devicetree/bindings/phy/phy-miphy28lp.txt      | 43 ++++++---------
 drivers/phy/phy-miphy28lp.c                        | 61 ++++++++++++----------
 2 files changed, 48 insertions(+), 56 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
index 46a135d..89caa88 100644
--- a/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
+++ b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
@@ -26,6 +26,7 @@ Required properties (port (child) node):
 		  filled in "reg". It can also contain the offset of the system configuration
 		  registers used as glue-logic to setup the device for SATA/PCIe or USB3
 		  devices.
+- st,syscfg	: Offset of the parent configuration register.
 - resets	: phandle to the parent reset controller.
 - reset-names	: Associated name must be "miphy-sw-rst".
 
@@ -54,18 +55,12 @@ example:
 			phy_port0: port@9b22000 {
 				reg = <0x9b22000 0xff>,
 				      <0x9b09000 0xff>,
-				      <0x9b04000 0xff>,
-				      <0x114 0x4>, /* sysctrl MiPHY cntrl */
-				      <0x818 0x4>, /* sysctrl MiPHY status*/
-				      <0xe0  0x4>, /* sysctrl PCIe */
-				      <0xec  0x4>; /* sysctrl SATA */
+				      <0x9b04000 0xff>;
 				reg-names = "sata-up",
 					    "pcie-up",
-					    "pipew",
-					    "miphy-ctrl-glue",
-					    "miphy-status-glue",
-					    "pcie-glue",
-					    "sata-glue";
+					    "pipew";
+
+				st,syscfg = <0x114 0x818 0xe0 0xec>;
 				#phy-cells = <1>;
 				st,osc-rdy;
 				reset-names = "miphy-sw-rst";
@@ -75,18 +70,13 @@ example:
 			phy_port1: port@9b2a000 {
 				reg = <0x9b2a000 0xff>,
 				      <0x9b19000 0xff>,
-				      <0x9b14000 0xff>,
-				      <0x118 0x4>,
-				      <0x81c 0x4>,
-				      <0xe4  0x4>,
-				      <0xf0  0x4>;
+				      <0x9b14000 0xff>;
 				reg-names = "sata-up",
 					    "pcie-up",
-					    "pipew",
-					    "miphy-ctrl-glue",
-					    "miphy-status-glue",
-					    "pcie-glue",
-					    "sata-glue";
+					    "pipew";
+
+				st,syscfg = <0x118 0x81c 0xe4 0xf0>;
+
 				#phy-cells = <1>;
 				st,osc-force-ext;
 				reset-names = "miphy-sw-rst";
@@ -95,13 +85,12 @@ example:
 
 			phy_port2: port@8f95000 {
 				reg = <0x8f95000 0xff>,
-				      <0x8f90000 0xff>,
-				      <0x11c 0x4>,
-				      <0x820 0x4>;
+				      <0x8f90000 0xff>;
 				reg-names = "pipew",
-				    "usb3-up",
-				    "miphy-ctrl-glue",
-				    "miphy-status-glue";
+					    "usb3-up";
+
+				st,syscfg = <0x11c 0x820>;
+
 				#phy-cells = <1>;
 				reset-names = "miphy-sw-rst";
 				resets = <&softreset STIH407_MIPHY2_SOFTRESET>;
@@ -125,4 +114,4 @@ example:
 
 Macro definitions for the supported miphy configuration can be found in:
 
-include/dt-bindings/phy/phy-miphy28lp.h
+include/dt-bindings/phy/phy.h
diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
index 27fa62c..9b2848e 100644
--- a/drivers/phy/phy-miphy28lp.c
+++ b/drivers/phy/phy-miphy28lp.c
@@ -194,6 +194,14 @@
 #define MIPHY_SATA_BANK_NB	3
 #define MIPHY_PCIE_BANK_NB	2
 
+enum {
+	SYSCFG_CTRL,
+	SYSCFG_STATUS,
+	SYSCFG_PCI,
+	SYSCFG_SATA,
+	SYSCFG_REG_MAX,
+};
+
 struct miphy28lp_phy {
 	struct phy *phy;
 	struct miphy28lp_dev *phydev;
@@ -211,10 +219,7 @@ struct miphy28lp_phy {
 	u32 sata_gen;
 
 	/* Sysconfig registers offsets needed to configure the device */
-	u32 syscfg_miphy_ctrl;
-	u32 syscfg_miphy_status;
-	u32 syscfg_pci;
-	u32 syscfg_sata;
+	u32 syscfg_reg[SYSCFG_REG_MAX];
 	u8 type;
 };
 
@@ -834,12 +839,12 @@ static int miphy_osc_is_ready(struct miphy28lp_phy *miphy_phy)
 	if (!miphy_phy->osc_rdy)
 		return 0;
 
-	if (!miphy_phy->syscfg_miphy_status)
+	if (!miphy_phy->syscfg_reg[SYSCFG_STATUS])
 		return -EINVAL;
 
 	do {
-		regmap_read(miphy_dev->regmap, miphy_phy->syscfg_miphy_status,
-			    &val);
+		regmap_read(miphy_dev->regmap,
+				miphy_phy->syscfg_reg[SYSCFG_STATUS], &val);
 
 		if ((val & MIPHY_OSC_RDY) != MIPHY_OSC_RDY)
 			cpu_relax();
@@ -888,7 +893,7 @@ static int miphy28lp_setup(struct miphy28lp_phy *miphy_phy, u32 miphy_val)
 	int err;
 	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
 
-	if (!miphy_phy->syscfg_miphy_ctrl)
+	if (!miphy_phy->syscfg_reg[SYSCFG_CTRL])
 		return -EINVAL;
 
 	err = reset_control_assert(miphy_phy->miphy_rst);
@@ -900,7 +905,8 @@ static int miphy28lp_setup(struct miphy28lp_phy *miphy_phy, u32 miphy_val)
 	if (miphy_phy->osc_force_ext)
 		miphy_val |= MIPHY_OSC_FORCE_EXT;
 
-	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_miphy_ctrl,
+	regmap_update_bits(miphy_dev->regmap,
+			   miphy_phy->syscfg_reg[SYSCFG_CTRL],
 			   MIPHY_CTRL_MASK, miphy_val);
 
 	err = reset_control_deassert(miphy_phy->miphy_rst);
@@ -917,8 +923,9 @@ static int miphy28lp_init_sata(struct miphy28lp_phy *miphy_phy)
 	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
 	int err, sata_conf = SATA_CTRL_SELECT_SATA;
 
-	if ((!miphy_phy->syscfg_sata) || (!miphy_phy->syscfg_pci)
-		|| (!miphy_phy->base))
+	if ((!miphy_phy->syscfg_reg[SYSCFG_SATA]) ||
+			(!miphy_phy->syscfg_reg[SYSCFG_PCI]) ||
+			(!miphy_phy->base))
 		return -EINVAL;
 
 	dev_info(miphy_dev->dev, "sata-up mode, addr 0x%p\n", miphy_phy->base);
@@ -926,10 +933,11 @@ static int miphy28lp_init_sata(struct miphy28lp_phy *miphy_phy)
 	/* Configure the glue-logic */
 	sata_conf |= ((miphy_phy->sata_gen - SATA_GEN1) << SATA_SPDMODE);
 
-	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_sata,
+	regmap_update_bits(miphy_dev->regmap,
+			   miphy_phy->syscfg_reg[SYSCFG_SATA],
 			   SATA_CTRL_MASK, sata_conf);
 
-	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_pci,
+	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_reg[SYSCFG_PCI],
 			   PCIE_CTRL_MASK, SATA_CTRL_SELECT_PCIE);
 
 	/* MiPHY path and clocking init */
@@ -951,17 +959,19 @@ static int miphy28lp_init_pcie(struct miphy28lp_phy *miphy_phy)
 	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
 	int err;
 
-	if ((!miphy_phy->syscfg_sata) || (!miphy_phy->syscfg_pci)
+	if ((!miphy_phy->syscfg_reg[SYSCFG_SATA]) ||
+			(!miphy_phy->syscfg_reg[SYSCFG_PCI])
 		|| (!miphy_phy->base) || (!miphy_phy->pipebase))
 		return -EINVAL;
 
 	dev_info(miphy_dev->dev, "pcie-up mode, addr 0x%p\n", miphy_phy->base);
 
 	/* Configure the glue-logic */
-	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_sata,
+	regmap_update_bits(miphy_dev->regmap,
+			   miphy_phy->syscfg_reg[SYSCFG_SATA],
 			   SATA_CTRL_MASK, SATA_CTRL_SELECT_PCIE);
 
-	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_pci,
+	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_reg[SYSCFG_PCI],
 			   PCIE_CTRL_MASK, SYSCFG_PCIE_PCIE_VAL);
 
 	/* MiPHY path and clocking init */
@@ -1156,7 +1166,8 @@ static int miphy28lp_probe_resets(struct device_node *node,
 static int miphy28lp_of_probe(struct device_node *np,
 			      struct miphy28lp_phy *miphy_phy)
 {
-	struct resource res;
+	int i;
+	u32 ctrlreg;
 
 	miphy_phy->osc_force_ext =
 		of_property_read_bool(np, "st,osc-force-ext");
@@ -1175,18 +1186,10 @@ static int miphy28lp_of_probe(struct device_node *np,
 	if (!miphy_phy->sata_gen)
 		miphy_phy->sata_gen = SATA_GEN1;
 
-	if (!miphy28lp_get_resource_byname(np, "miphy-ctrl-glue", &res))
-		miphy_phy->syscfg_miphy_ctrl = res.start;
-
-	if (!miphy28lp_get_resource_byname(np, "miphy-status-glue", &res))
-		miphy_phy->syscfg_miphy_status = res.start;
-
-	if (!miphy28lp_get_resource_byname(np, "pcie-glue", &res))
-		miphy_phy->syscfg_pci = res.start;
-
-	if (!miphy28lp_get_resource_byname(np, "sata-glue", &res))
-		miphy_phy->syscfg_sata = res.start;
-
+	for (i = 0; i < SYSCFG_REG_MAX; i++) {
+		if (!of_property_read_u32_index(np, "st,syscfg", i, &ctrlreg))
+			miphy_phy->syscfg_reg[i] = ctrlreg;
+	}
 
 	return 0;
 }
-- 
1.9.1

