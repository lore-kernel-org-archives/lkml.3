Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaIKRDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:03:33 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:35053 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaIKRDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:03:09 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        b.zolnierkie@samsung.com, patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: [PATCH v3 1/4] phy: phy-stih407-usb: Add usb picoPHY driver found on stih407 SoC family
Date: Thu, 11 Sep 2014 18:02:44 +0100
Message-Id: <1410454967-21500-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410454967-21500-1-git-send-email-peter.griffin@linaro.org>
References: <1410454967-21500-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the generic phy driver for the picoPHY ports used by the
USB2 and USB3 Host controllers when controlling usb2/1.1 devices. It
is found on STiH407 SoC family from STMicroelectronics.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/phy/Kconfig           |   9 +++
 drivers/phy/Makefile          |   2 +
 drivers/phy/phy-stih407-usb.c | 177 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+)
 create mode 100644 drivers/phy/phy-stih407-usb.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 0dd7427..d361d98 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -230,4 +230,13 @@ config PHY_XGENE
 	help
 	  This option enables support for APM X-Gene SoC multi-purpose PHY.
 
+config PHY_STIH407_USB
+	tristate "STMicroelectronics USB2 picoPHY driver for STiH407 family"
+	depends on RESET_CONTROLLER
+	depends on ARCH_STI || COMPILE_TEST
+	select GENERIC_PHY
+	help
+	  Enable this support to enable the picoPHY device used by USB2
+	  and USB3 controllers on STMicroelectronics STiH407 SoC families.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 95c69ed..c82ac59 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -28,3 +28,5 @@ obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
 obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
 obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
+obj-$(CONFIG_PHY_STIH407_USB)		+= phy-stih407-usb.o
+
diff --git a/drivers/phy/phy-stih407-usb.c b/drivers/phy/phy-stih407-usb.c
new file mode 100644
index 0000000..42428d4
--- /dev/null
+++ b/drivers/phy/phy-stih407-usb.c
@@ -0,0 +1,177 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics
+ *
+ * STMicroelectronics Generic PHY driver for STiH407 USB2.
+ *
+ * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/clk.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+#include <linux/mfd/syscon.h>
+#include <linux/phy/phy.h>
+
+/* Default PHY_SEL and REFCLKSEL configuration */
+#define STIH407_USB_PICOPHY_CTRL_PORT_CONF	0x6
+#define STIH407_USB_PICOPHY_CTRL_PORT_MASK	0x1f
+
+/* ports parameters overriding */
+#define STIH407_USB_PICOPHY_PARAM_DEF		0x39a4dc
+#define STIH407_USB_PICOPHY_PARAM_MASK		0xffffffff
+
+struct stih407_usb2_picophy {
+	struct phy *phy;
+	struct regmap *regmap;
+	struct device *dev;
+	struct reset_control *rstc;
+	struct reset_control *rstport;
+	int ctrl;
+	int param;
+};
+
+static int stih407_usb2_pico_ctrl(struct stih407_usb2_picophy *phy_dev)
+{
+	reset_control_deassert(phy_dev->rstc);
+
+	return regmap_update_bits(phy_dev->regmap, phy_dev->ctrl,
+				  STIH407_USB_PICOPHY_CTRL_PORT_MASK,
+				  STIH407_USB_PICOPHY_CTRL_PORT_CONF);
+}
+
+static int stih407_usb2_init_port(struct phy *phy)
+{
+	int ret;
+	struct stih407_usb2_picophy *phy_dev = phy_get_drvdata(phy);
+
+	stih407_usb2_pico_ctrl(phy_dev);
+
+	ret = regmap_update_bits(phy_dev->regmap,
+				 phy_dev->param,
+				 STIH407_USB_PICOPHY_PARAM_MASK,
+				 STIH407_USB_PICOPHY_PARAM_DEF);
+	if (ret)
+		return ret;
+
+	return reset_control_deassert(phy_dev->rstport);
+}
+
+static int stih407_usb2_exit_port(struct phy *phy)
+{
+	struct stih407_usb2_picophy *phy_dev = phy_get_drvdata(phy);
+
+	/*
+	 * Only port reset is asserted, phy global reset is kept untouched
+	 * as other ports may still be active. When all ports are in reset
+	 * state, assumption is made that power will be cut off on the phy, in
+	 * case of suspend for instance. Theoretically, asserting individual
+	 * reset (like here) or global reset should be equivalent.
+	 */
+	return reset_control_assert(phy_dev->rstport);
+}
+
+static const struct phy_ops stih407_usb2_picophy_data = {
+	.init = stih407_usb2_init_port,
+	.exit = stih407_usb2_exit_port,
+	.owner = THIS_MODULE,
+};
+
+static int stih407_usb2_picophy_probe(struct platform_device *pdev)
+{
+	struct stih407_usb2_picophy *phy_dev;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct phy_provider *phy_provider;
+	struct phy *phy;
+	struct resource *res;
+
+	phy_dev = devm_kzalloc(dev, sizeof(*phy_dev), GFP_KERNEL);
+	if (!phy_dev)
+		return -ENOMEM;
+
+	phy_dev->dev = dev;
+	dev_set_drvdata(dev, phy_dev);
+
+	phy_dev->rstc = devm_reset_control_get(dev, "global");
+	if (IS_ERR(phy_dev->rstc)) {
+		dev_err(dev, "failed to ctrl picoPHY reset\n");
+		return PTR_ERR(phy_dev->rstc);
+	}
+
+	phy_dev->rstport = devm_reset_control_get(dev, "port");
+	if (IS_ERR(phy_dev->rstport)) {
+		dev_err(dev, "failed to ctrl picoPHY reset\n");
+		return PTR_ERR(phy_dev->rstport);
+	}
+
+	/* Reset port by default: only deassert it in phy init */
+	reset_control_assert(phy_dev->rstport);
+
+	phy_dev->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
+	if (IS_ERR(phy_dev->regmap)) {
+		dev_err(dev, "No syscfg phandle specified\n");
+		return PTR_ERR(phy_dev->regmap);
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ctrl");
+	if (!res) {
+		dev_err(dev, "No ctrl reg found\n");
+		return -ENXIO;
+	}
+	phy_dev->ctrl = res->start;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "param");
+	if (!res) {
+		dev_err(dev, "No param reg found\n");
+		return -ENXIO;
+	}
+	phy_dev->param = res->start;
+
+	phy = devm_phy_create(dev, NULL, &stih407_usb2_picophy_data, NULL);
+	if (IS_ERR(phy)) {
+		dev_err(dev, "failed to create Display Port PHY\n");
+		return PTR_ERR(phy);
+	}
+
+	phy_dev->phy = phy;
+	phy_set_drvdata(phy, phy_dev);
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	dev_info(dev, "STiH407 USB Generic picoPHY driver probed!");
+
+	return 0;
+}
+
+static const struct of_device_id stih407_usb2_picophy_of_match[] = {
+	{ .compatible = "st,stih407-usb2-phy" },
+	{ /*sentinel */ },
+};
+
+MODULE_DEVICE_TABLE(of, stih407_usb2_picophy_of_match);
+
+static struct platform_driver stih407_usb2_picophy_driver = {
+	.probe = stih407_usb2_picophy_probe,
+	.driver = {
+		   .name = "stih407-usb-genphy",
+		   .of_match_table = stih407_usb2_picophy_of_match,
+		   }
+};
+
+module_platform_driver(stih407_usb2_picophy_driver);
+
+MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics Generic picoPHY driver for STiH407");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

