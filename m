Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbaGILlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:41:39 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36586 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbaGILlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:41:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v3 4/5] phy: miphy365x: Represent each PHY channel as a DT subnode
Date: Wed,  9 Jul 2014 12:41:13 +0100
Message-Id: <1404906074-31992-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the added advantages of being able to enable/disable each
of the channels as simply as enabling/disabling the DT node.

Suggested-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/phy/phy-miphy365x.c | 256 ++++++++++++++++++++++++--------------------
 1 file changed, 138 insertions(+), 118 deletions(-)

diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
index 65ecd04..e111baf 100644
--- a/drivers/phy/phy-miphy365x.c
+++ b/drivers/phy/phy-miphy365x.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_address.h>
 #include <linux/clk.h>
 #include <linux/phy/phy.h>
 #include <linux/delay.h>
@@ -28,10 +29,8 @@
 
 #define HFC_TIMEOUT		100
 
-#define SYSCFG_2521		0x824
-#define SYSCFG_2522		0x828
-#define SYSCFG_PCIE_SATA_MASK	BIT(1)
-#define SYSCFG_PCIE_SATA_POS	1
+#define SYSCFG_SELECT_SATA_MASK	BIT(1)
+#define SYSCFG_SELECT_SATA_POS	1
 
 /* MiPHY365x register definitions */
 #define RESET_REG		0x00
@@ -136,25 +135,21 @@
 #define BIT_LOCK_LEVEL		0x01
 #define BIT_LOCK_CNT_512	(0x03 << 5)
 
-static u8 ports[] = { MIPHY_PORT_0, MIPHY_PORT_1 };
-
 struct miphy365x_phy {
 	struct phy *phy;
 	void __iomem *base;
-	void __iomem *sata;
-	void __iomem *pcie;
+	bool pcie_tx_pol_inv;
+	bool sata_tx_pol_inv;
+	u32 sata_gen;
+	u64 ctrlreg;
 	u8 type;
-	u8 port;
 };
 
 struct miphy365x_dev {
 	struct device *dev;
 	struct regmap *regmap;
 	struct mutex miphy_mutex;
-	struct miphy365x phys[ARRAY_SIZE(ports)];
-	bool pcie_tx_pol_inv;
-	bool sata_tx_pol_inv;
-	u32 sata_gen;
+	struct miphy365x_phy **phys;
 };
 
 /*
@@ -180,27 +175,12 @@ static u8 rx_tx_spd[] = {
 static int miphy365x_set_path(struct miphy365x_phy *miphy_phy,
 			      struct miphy365x_dev *miphy_dev)
 {
-	u8 config = miphy_phy->type | miphy_phy->port;
-	u32 mask  = SYSCFG_PCIE_SATA_MASK;
-	u32 reg;
-	bool sata;
-
-	switch (config) {
-	case MIPHY_SATA_PORT0:
-		reg = SYSCFG_2521;
-		sata = true;
-		break;
-	case MIPHY_PCIE_PORT1:
-		reg = SYSCFG_2522;
-		sata = false;
-		break;
-	default:
-		dev_err(miphy_dev->dev, "Configuration not supported\n");
-		return -EINVAL;
-	}
+	bool sata = (miphy_phy->type == MIPHY_TYPE_SATA);
 
-	return regmap_update_bits(miphy_dev->regmap, reg, mask,
-				  sata << SYSCFG_PCIE_SATA_POS);
+	return regmap_update_bits(miphy_dev->regmap,
+				  (unsigned int)miphy_phy->ctrlreg,
+				  SYSCFG_SELECT_SATA_MASK,
+				  sata << SYSCFG_SELECT_SATA_POS);
 }
 
 static int miphy365x_init_pcie_port(struct miphy365x_phy *miphy_phy,
@@ -261,14 +241,14 @@ static inline void miphy365x_set_comp(struct miphy365x_phy *miphy_phy,
 {
 	u8 val, mask;
 
-	if (miphy_dev->sata_gen == SATA_GEN1)
+	if (miphy_phy->sata_gen == SATA_GEN1)
 		writeb_relaxed(COMP_2MHZ_RAT_GEN1,
 			       miphy_phy->base + COMP_CTRL2_REG);
 	else
 		writeb_relaxed(COMP_2MHZ_RAT,
 			       miphy_phy->base + COMP_CTRL2_REG);
 
-	if (miphy_dev->sata_gen != SATA_GEN3) {
+	if (miphy_phy->sata_gen != SATA_GEN3) {
 		writeb_relaxed(COMSR_COMP_REF,
 			       miphy_phy->base + COMP_CTRL3_REG);
 		/*
@@ -312,7 +292,7 @@ static inline void miphy365x_set_ssc(struct miphy365x_phy *miphy_phy,
 		       miphy_phy->base + PLL_SSC_PER_LSB_REG);
 
 	/* SSC Settings complete */
-	if (miphy_dev->sata_gen == SATA_GEN1) {
+	if (miphy_phy->sata_gen == SATA_GEN1) {
 		val = PLL_START_CAL | BUF_EN | SYNCHRO_TX | CONFIG_PLL;
 		writeb_relaxed(val, miphy_phy->base + PLL_CTRL1_REG);
 	} else {
@@ -334,7 +314,7 @@ static int miphy365x_init_sata_port(struct miphy365x_phy *miphy_phy,
 	val = RST_PLL | RST_PLL_CAL | RST_RX | RST_MACRO;
 	writeb_relaxed(val, miphy_phy->base + RESET_REG);
 
-	if (miphy_dev->sata_tx_pol_inv)
+	if (miphy_phy->sata_tx_pol_inv)
 		writeb_relaxed(TX_POL, miphy_phy->base + CTRL_REG);
 
 	/*
@@ -344,7 +324,7 @@ static int miphy365x_init_sata_port(struct miphy365x_phy *miphy_phy,
 	 */
 	writeb_relaxed(SPDSEL_SEL, miphy_phy->base + BOUNDARY1_REG);
 	writeb_relaxed(START_CLK_HF, miphy_phy->base + IDLL_TEST_REG);
-	val = rx_tx_spd[miphy_dev->sata_gen];
+	val = rx_tx_spd[miphy_phy->sata_gen];
 	writeb_relaxed(val, miphy_phy->base + BOUNDARY3_REG);
 
 	/* Wait for HFC_READY = 0 */
@@ -355,7 +335,7 @@ static int miphy365x_init_sata_port(struct miphy365x_phy *miphy_phy,
 	/* Compensation Recalibration */
 	miphy365x_set_comp(miphy_phy, miphy_dev);
 
-	switch (miphy_dev->sata_gen) {
+	switch (miphy_phy->sata_gen) {
 	case SATA_GEN3:
 		/*
 		 * TX Swing target 550-600mv peak to peak diff
@@ -423,7 +403,7 @@ static int miphy365x_init_sata_port(struct miphy365x_phy *miphy_phy,
 	writeb_relaxed(0x00, miphy_phy->base + BOUNDARY1_REG);
 	writeb_relaxed(0x00, miphy_phy->base + IDLL_TEST_REG);
 	writeb_relaxed(RST_RX, miphy_phy->base + RESET_REG);
-	val = miphy_dev->sata_tx_pol_inv ?
+	val = miphy_phy->sata_tx_pol_inv ?
 		(TX_POL | DES_BIT_LOCK_EN) : DES_BIT_LOCK_EN;
 	writeb_relaxed(val, miphy_phy->base + CTRL_REG);
 
@@ -459,40 +439,95 @@ static int miphy365x_init(struct phy *phy)
 	return ret;
 }
 
+int miphy365x_get_addr(struct device *dev, struct miphy365x_phy *miphy_phy,
+		       int index)
+{
+	struct device_node *phynode = miphy_phy->phy->dev.of_node;
+	const char *name;
+	const __be32 *taddr;
+	int type = miphy_phy->type;
+	int ret;
+
+	ret = of_property_read_string_index(phynode, "reg-names", index, &name);
+	if (ret) {
+		dev_err(dev, "no reg-names property not found\n");
+		return ret;
+	}
+
+	if (!strncmp(name, "syscfg", 6)) {
+		taddr = of_get_address(phynode, index, NULL, NULL);
+		if (!taddr) {
+			dev_err(dev, "failed to fetch syscfg address\n");
+			return -EINVAL;
+		}
+
+		miphy_phy->ctrlreg = of_translate_address(phynode, taddr);
+		if (miphy_phy->ctrlreg == OF_BAD_ADDR) {
+			dev_err(dev, "failed to translate syscfg address\n");
+			return -EINVAL;
+		}
+
+		return 0;
+	}
+
+	if (!((!strncmp(name, "sata", 4) && type == MIPHY_TYPE_SATA) ||
+	      (!strncmp(name, "pcie", 4) && type == MIPHY_TYPE_PCIE)))
+		return 0;
+
+	miphy_phy->base = of_iomap(phynode, index);
+	if (!miphy_phy->base) {
+		dev_err(dev, "Failed to map %s\n", phynode->full_name);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static struct phy *miphy365x_xlate(struct device *dev,
 				   struct of_phandle_args *args)
 {
-	struct miphy365x_dev *state = dev_get_drvdata(dev);
-	u8 port, type;
+	struct miphy365x_dev *miphy_dev = dev_get_drvdata(dev);
+	struct miphy365x_phy *miphy_phy = NULL;
+	struct device_node *phynode = args->np;
+	int ret, index;
+
+	if (!of_device_is_available(phynode)) {
+		dev_warn(dev, "Requested PHY is disabled\n");
+		return ERR_PTR(-ENODEV);
+	}
 
-	if (args->count != 2) {
+	if (args->args_count != 1) {
 		dev_err(dev, "Invalid number of cells in 'phy' property\n");
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (args->args[0] & 0xFFFFFF00 || args->args[1] & 0xFFFFFF00) {
-		dev_err(dev, "Unsupported flags set in 'phy' property\n");
+	for (index = 0; index < of_get_child_count(dev->of_node); index++)
+		if (phynode == miphy_dev->phys[index]->phy->dev.of_node) {
+			miphy_phy = miphy_dev->phys[index];
+			break;
+		}
+
+	if (!miphy_phy) {
+		dev_err(dev, "Failed to find appropriate phy\n");
 		return ERR_PTR(-EINVAL);
 	}
 
-	port = args->args[0];
-	type = args->args[1];
-
-	if (WARN_ON(port >= ARRAY_SIZE(ports)))
-		return ERR_PTR(-EINVAL);
+	miphy_phy->type = args->args[0];
 
-	if (type == MIPHY_TYPE_SATA)
-		state->phys[port].base = state->phys[port].sata;
-	else if (type == MIPHY_TYPE_PCIE)
-		state->phys[port].base = state->phys[port].pcie;
-	else {
-		WARN(1, "Invalid type specified in DT");
+	if (!(miphy_phy->type == MIPHY_TYPE_SATA ||
+	      miphy_phy->type == MIPHY_TYPE_PCIE)) {
+		dev_err(dev, "Unsupported device type: %d\n", miphy_phy->type);
 		return ERR_PTR(-EINVAL);
 	}
 
-	state->phys[port].type = type;
+	/* Each port handles SATA and PCIE - third entry is always sysconf. */
+	for (index = 0; index < 3; index++) {
+		ret = miphy365x_get_addr(dev, miphy_phy, index);
+		if (ret < 0)
+			return ERR_PTR(ret);
+	}
 
-	return state->phys[port].phy;
+	return miphy_phy->phy;
 }
 
 static struct phy_ops miphy365x_ops = {
@@ -500,95 +535,80 @@ static struct phy_ops miphy365x_ops = {
 	.owner		= THIS_MODULE,
 };
 
-static int miphy365x_get_base_addr(struct platform_device *pdev,
-				   struct miphy365x_phy *phy, u8 port)
+static int miphy365x_of_probe(struct device_node *phynode,
+			      struct miphy365x_phy *miphy_phy)
 {
-	struct resource *res;
-	char type[6];
+	of_property_read_u32(phynode, "st,sata-gen", &miphy_phy->sata_gen);
+	if (!miphy_phy->sata_gen)
+		miphy_phy->sata_gen = SATA_GEN1;
 
-	sprintf(type, "sata%d", port);
+	miphy_phy->pcie_tx_pol_inv =
+		of_property_read_bool(phynode, "st,pcie-tx-pol-inv");
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, type);
-	phy->sata = devm_ioremap_resource(&pdev->dev, res));
-	if (!phy->sata)
-		return -ENOMEM;
-
-	sprintf(type, "pcie%d", port);
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, type);
-	phy->pcie = devm_ioremap_resource(&pdev->dev, res));
-	if (!phy->pcie)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static int miphy365x_of_probe(struct device_node *np,
-			      struct miphy365x_dev *phy_dev)
-{
-	phy_dev->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
-	if (IS_ERR(phy_dev->regmap)) {
-		dev_err(phy_dev->dev, "No syscfg phandle specified\n");
-		return PTR_ERR(phy_dev->regmap);
-	}
-
-	of_property_read_u32(np, "st,sata-gen", &phy_dev->sata_gen);
-	if (!phy_dev->sata_gen)
-		phy_dev->sata_gen = SATA_GEN1;
-
-	phy_dev->pcie_tx_pol_inv =
-		of_property_read_bool(np, "st,pcie-tx-pol-inv");
-
-	phy_dev->sata_tx_pol_inv =
-		of_property_read_bool(np, "st,sata-tx-pol-inv");
+	miphy_phy->sata_tx_pol_inv =
+		of_property_read_bool(phynode, "st,sata-tx-pol-inv");
 
 	return 0;
 }
 
 static int miphy365x_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
-	struct miphy365x_dev *phy_dev;
-	struct device *dev = &pdev->dev;
+	struct device_node *child, *np = pdev->dev.of_node;
+	struct miphy365x_dev *miphy_dev;
 	struct phy_provider *provider;
-	u8 port;
+	struct phy *phy;
+	int chancount, port = 0;
 	int ret;
 
-	phy_dev = devm_kzalloc(dev, sizeof(*phy_dev), GFP_KERNEL);
-	if (!phy_dev)
+	miphy_dev = devm_kzalloc(&pdev->dev, sizeof(*miphy_dev), GFP_KERNEL);
+	if (!miphy_dev)
 		return -ENOMEM;
 
-	ret = miphy365x_of_probe(np, phy_dev);
-	if (ret)
-		return ret;
+	chancount = of_get_child_count(np);
+	miphy_dev->phys = devm_kzalloc(&pdev->dev, sizeof(phy) * chancount,
+				       GFP_KERNEL);
+	if (!miphy_dev->phys)
+		return -ENOMEM;
+
+	miphy_dev->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
+	if (IS_ERR(miphy_dev->regmap)) {
+		dev_err(miphy_dev->dev, "No syscfg phandle specified\n");
+		return PTR_ERR(miphy_dev->regmap);
+	}
+
+	miphy_dev->dev = &pdev->dev;
+
+	dev_set_drvdata(&pdev->dev, miphy_dev);
 
-	phy_dev->dev = dev;
+	mutex_init(&miphy_dev->miphy_mutex);
 
-	dev_set_drvdata(dev, phy_dev);
+	for_each_child_of_node(np, child) {
+		struct miphy365x_phy *miphy_phy;
 
-	mutex_init(&phy_dev->miphy_mutex);
+		miphy_phy = devm_kzalloc(&pdev->dev, sizeof(*miphy_phy),
+					 GFP_KERNEL);
+		if (!miphy_phy)
+			return -ENOMEM;
 
-	for (port = 0; port < ARRAY_SIZE(ports); port++) {
-		struct phy *phy;
+		miphy_dev->phys[port] = miphy_phy;
 
-		phy = devm_phy_create(dev, &miphy365x_ops, NULL);
+		phy = devm_phy_create(&pdev->dev, child, &miphy365x_ops, NULL);
 		if (IS_ERR(phy)) {
-			dev_err(dev, "failed to create PHY on port %d\n", port);
+			dev_err(&pdev->dev, "failed to create PHY\n");
 			return PTR_ERR(phy);
 		}
 
-		phy_dev->phys[port].phy  = phy;
-		phy_dev->phys[port].port = port;
+		miphy_dev->phys[port]->phy = phy;
 
-		ret = miphy365x_get_base_addr(pdev,
-					&phy_dev->phys[port], port);
+		ret = miphy365x_of_probe(child, miphy_phy);
 		if (ret)
 			return ret;
 
-		phy_set_drvdata(phy, &phy_dev->phys[port]);
+		phy_set_drvdata(phy, miphy_dev->phys[port]);
+		port++;
 	}
 
-	provider = devm_of_phy_provider_register(dev, miphy365x_xlate);
+	provider = devm_of_phy_provider_register(&pdev->dev, miphy365x_xlate);
 	if (IS_ERR(provider))
 		return PTR_ERR(provider);
 
-- 
1.8.3.2

