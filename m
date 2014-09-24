Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaIXNuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:50:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51006 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbaIXNrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:51 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/22] phy: phy-stih41x-usb: Add usb phy support for STiH41x SoCs.
Date: Wed, 24 Sep 2014 19:17:16 +0530
Message-ID: <1411566440-19169-19-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

This driver adds support for USB (1.1 and 2.0) phy for STiH415 and
STiH416 System-On-Chips from STMicroelectronics.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig           |    8 ++
 drivers/phy/Makefile          |    1 +
 drivers/phy/phy-stih41x-usb.c |  187 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 196 insertions(+)
 create mode 100644 drivers/phy/phy-stih41x-usb.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 11c66d7..2a436e6 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -248,4 +248,12 @@ config PHY_STIH407_USB
 	  Enable this support to enable the picoPHY device used by USB2
 	  and USB3 controllers on STMicroelectronics STiH407 SoC families.
 
+config PHY_STIH41X_USB
+	tristate "STMicroelectronics USB2 PHY driver for STiH41x series"
+	depends on ARCH_STI
+	select GENERIC_PHY
+	help
+	  Enable this to support the USB transceiver that is part of
+	  STMicroelectronics STiH41x SoC series.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index a8d1e11..c4590fc 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
 obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
 obj-$(CONFIG_PHY_STIH407_USB)		+= phy-stih407-usb.o
+obj-$(CONFIG_PHY_STIH41X_USB)		+= phy-stih41x-usb.o
diff --git a/drivers/phy/phy-stih41x-usb.c b/drivers/phy/phy-stih41x-usb.c
new file mode 100644
index 0000000..9f16cb8
--- /dev/null
+++ b/drivers/phy/phy-stih41x-usb.c
@@ -0,0 +1,187 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics
+ *
+ * STMicroelectronics PHY driver for STiH41x USB.
+ *
+ * Author: Maxime Coquelin <maxime.coquelin@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/clk.h>
+#include <linux/phy/phy.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+
+#define SYSCFG332  0x80
+#define SYSCFG2520 0x820
+
+/**
+ * struct stih41x_usb_cfg - SoC specific PHY register mapping
+ * @syscfg: Offset in syscfg registers bank
+ * @cfg_mask: Bits mask for PHY configuration
+ * @cfg: Static configuration value for PHY
+ * @oscok: Notify the PHY oscillator clock is ready
+ *	   Setting this bit enable the PHY
+ */
+struct stih41x_usb_cfg {
+	u32 syscfg;
+	u32 cfg_mask;
+	u32 cfg;
+	u32 oscok;
+};
+
+/**
+ * struct stih41x_usb_phy - Private data for the PHY
+ * @dev: device for this controller
+ * @regmap: Syscfg registers bank in which PHY is configured
+ * @cfg: SoC specific PHY register mapping
+ * @clk: Oscillator used by the PHY
+ */
+struct stih41x_usb_phy {
+	struct device *dev;
+	struct regmap *regmap;
+	const struct stih41x_usb_cfg *cfg;
+	struct clk *clk;
+};
+
+static struct stih41x_usb_cfg stih415_usb_phy_cfg = {
+	.syscfg = SYSCFG332,
+	.cfg_mask = 0x3f,
+	.cfg = 0x38,
+	.oscok = BIT(6),
+};
+
+static struct stih41x_usb_cfg stih416_usb_phy_cfg = {
+	.syscfg = SYSCFG2520,
+	.cfg_mask = 0x33f,
+	.cfg = 0x238,
+	.oscok = BIT(6),
+};
+
+static int stih41x_usb_phy_init(struct phy *phy)
+{
+	struct stih41x_usb_phy *phy_dev = phy_get_drvdata(phy);
+
+	return regmap_update_bits(phy_dev->regmap, phy_dev->cfg->syscfg,
+			   phy_dev->cfg->cfg_mask, phy_dev->cfg->cfg);
+}
+
+static int stih41x_usb_phy_power_on(struct phy *phy)
+{
+	struct stih41x_usb_phy *phy_dev = phy_get_drvdata(phy);
+	int ret;
+
+	ret = clk_prepare_enable(phy_dev->clk);
+	if (ret) {
+		dev_err(phy_dev->dev, "Failed to enable osc_phy clock\n");
+		return ret;
+	}
+
+	return regmap_update_bits(phy_dev->regmap, phy_dev->cfg->syscfg,
+			phy_dev->cfg->oscok, phy_dev->cfg->oscok);
+}
+
+static int stih41x_usb_phy_power_off(struct phy *phy)
+{
+	struct stih41x_usb_phy *phy_dev = phy_get_drvdata(phy);
+	int ret;
+
+	ret = regmap_update_bits(phy_dev->regmap, phy_dev->cfg->syscfg,
+			phy_dev->cfg->oscok, 0);
+	if (ret) {
+		dev_err(phy_dev->dev, "Failed to clear oscok bit\n");
+		return ret;
+	}
+
+	clk_disable_unprepare(phy_dev->clk);
+
+	return 0;
+}
+
+static struct phy_ops stih41x_usb_phy_ops = {
+	.init		= stih41x_usb_phy_init,
+	.power_on	= stih41x_usb_phy_power_on,
+	.power_off	= stih41x_usb_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static const struct of_device_id stih41x_usb_phy_of_match[];
+
+static int stih41x_usb_phy_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
+	struct stih41x_usb_phy *phy_dev;
+	struct device *dev = &pdev->dev;
+	struct phy_provider *phy_provider;
+	struct phy *phy;
+
+	phy_dev = devm_kzalloc(dev, sizeof(*phy_dev), GFP_KERNEL);
+	if (!phy_dev)
+		return -ENOMEM;
+
+	match = of_match_device(stih41x_usb_phy_of_match, &pdev->dev);
+	if (!match)
+		return -ENODEV;
+
+	phy_dev->cfg = match->data;
+
+	phy_dev->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
+	if (IS_ERR(phy_dev->regmap)) {
+		dev_err(dev, "No syscfg phandle specified\n");
+		return PTR_ERR(phy_dev->regmap);
+	}
+
+	phy_dev->clk = devm_clk_get(dev, "osc_phy");
+	if (IS_ERR(phy_dev->clk)) {
+		dev_err(dev, "osc_phy clk not found\n");
+		return PTR_ERR(phy_dev->clk);
+	}
+
+	phy = devm_phy_create(dev, NULL, &stih41x_usb_phy_ops, NULL);
+
+	if (IS_ERR(phy)) {
+		dev_err(dev, "failed to create phy\n");
+		return PTR_ERR(phy);
+	}
+
+	phy_dev->dev = dev;
+
+	phy_set_drvdata(phy, phy_dev);
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	return 0;
+}
+
+static const struct of_device_id stih41x_usb_phy_of_match[] = {
+	{ .compatible = "st,stih415-usb-phy", .data = &stih415_usb_phy_cfg },
+	{ .compatible = "st,stih416-usb-phy", .data = &stih416_usb_phy_cfg },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, stih41x_usb_phy_of_match);
+
+static struct platform_driver stih41x_usb_phy_driver = {
+	.probe	= stih41x_usb_phy_probe,
+	.driver = {
+		.name	= "stih41x-usb-phy",
+		.of_match_table	= stih41x_usb_phy_of_match,
+	}
+};
+module_platform_driver(stih41x_usb_phy_driver);
+
+MODULE_AUTHOR("Maxime Coquelin <maxime.coquelin@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics USB PHY driver for STiH41x series");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

