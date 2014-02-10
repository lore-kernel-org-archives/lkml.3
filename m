Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaBJIxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:53:09 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:49029 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbaBJIxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:53:04 -0500
From: Mohit Kumar <mohit.kumar@st.com>
To: <arnd@arndb.de>
Cc: Pratyush Anand <pratyush.anand@st.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <spear-devel@list.st.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V5 4/8] phy: st-miphy-40lp: Add skeleton driver
Date: Mon, 10 Feb 2014 14:21:55 +0530
Message-ID: <fb505abd332645671d9ad125003d8253b6346715.1391871170.git.pratyush.anand@st.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1391871170.git.pratyush.anand@st.com>
References: <cover.1391871170.git.pratyush.anand@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

ST miphy-40lp supports PCIe, SATA and Super Speed USB. This driver adds
skeleton support for the same.

This skeleton defines function corresponding to phy ops as well as sleep
pm ops. Any platform using this phy can add its own platform specific
ops(if needed) corresponding to each phy ops.

Phy specific modifications will require phy register space, which is
passed from DT as a resource. Currently only SPEAr1310 and SPEAr1340 are
known user of this phy, which do not need to modify phy registers
normally. Therefore we have not retrieved phy base address from DT and
hence not io-remapped it. However, same can be added in future if
required.

SoC specific modifications should be done in plat specific ops and phy
specific modifications should be done in phy ops itself. As a general
rule, follow the convention of modifying misc reg space in plat ops and
phy reg space in phy ops.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Tested-by: Mohit Kumar <mohit.kumar@st.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: spear-devel@list.st.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/phy/st-miphy40lp.txt       |  12 ++
 drivers/phy/Kconfig                                |   6 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-miphy40lp.c                        | 229 +++++++++++++++++++++
 4 files changed, 248 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/st-miphy40lp.txt
 create mode 100644 drivers/phy/phy-miphy40lp.c

diff --git a/Documentation/devicetree/bindings/phy/st-miphy40lp.txt b/Documentation/devicetree/bindings/phy/st-miphy40lp.txt
new file mode 100644
index 0000000..d0c7096
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/st-miphy40lp.txt
@@ -0,0 +1,12 @@
+Required properties:
+- compatible : should be "st,miphy40lp-phy"
+	Other supported soc specific compatible:
+		"st,spear1310-miphy"
+		"st,spear1340-miphy"
+- reg : offset and length of the PHY register set.
+- misc: phandle for the syscon node to access misc registers
+- phy-id: Instance id of the phy.
+- #phy-cells : from the generic PHY bindings, must be 1.
+	- 1st cell: phandle to the phy node.
+	- 2nd cell: 0 if phy (in 1st cell) is to be used for SATA, 1 for PCIe
+	  and 2 for Super Speed USB.
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index afa2354..2f58993 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -64,4 +64,10 @@ config BCM_KONA_USB2_PHY
 	help
 	  Enable this to support the Broadcom Kona USB 2.0 PHY.
 
+config PHY_ST_MIPHY40LP
+	tristate "ST MIPHY 40LP driver"
+	help
+	  Support for ST MIPHY 40LP which can be used for PCIe, SATA and Super Speed USB.
+	select GENERIC_PHY
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index b57c253..c061091 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
+obj-$(CONFIG_PHY_ST_MIPHY40LP)		+= phy-miphy40lp.o
diff --git a/drivers/phy/phy-miphy40lp.c b/drivers/phy/phy-miphy40lp.c
new file mode 100644
index 0000000..3a9ada1
--- /dev/null
+++ b/drivers/phy/phy-miphy40lp.c
@@ -0,0 +1,229 @@
+/*
+ * ST MiPHY-40LP PHY driver
+ *
+ * Copyright (C) 2014 ST Microelectronics
+ * Pratyush Anand <pratyush.anand@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/phy/phy.h>
+#include <linux/regmap.h>
+
+enum phy_mode {
+	SATA,
+	PCIE,
+	SS_USB,
+};
+
+struct miphy40lp_priv;
+
+/* platform specific function struct */
+struct miphy40lp_plat_ops {
+	int	(*plat_init)(struct miphy40lp_priv *priv);
+	int	(*plat_exit)(struct miphy40lp_priv *priv);
+	int	(*plat_power_off)(struct miphy40lp_priv *priv);
+	int	(*plat_power_on)(struct miphy40lp_priv *priv);
+	int	(*plat_suspend)(struct miphy40lp_priv *priv);
+	int	(*plat_resume)(struct miphy40lp_priv *priv);
+};
+
+struct miphy40lp_priv {
+	/* regmap for any soc specific misc registers */
+	struct regmap			*misc;
+	/* phy struct pointer */
+	struct phy			*phy;
+	/* phy mode: 0 for SATA 1 for PCIe and 2 for SS-USB */
+	enum phy_mode			mode;
+	/* instance id of this phy */
+	u32				id;
+	/* platform specific callbacks */
+	struct miphy40lp_plat_ops	*plat_ops;
+};
+
+static int miphy40lp_init(struct phy *phy)
+{
+	struct miphy40lp_priv *priv = phy_get_drvdata(phy);
+	struct miphy40lp_plat_ops *ops = priv->plat_ops;
+	int ret = 0;
+
+	if (ops && ops->plat_init)
+		ret = ops->plat_init(priv);
+
+	return ret;
+}
+
+static int miphy40lp_exit(struct phy *phy)
+{
+	struct miphy40lp_priv *priv = phy_get_drvdata(phy);
+	struct miphy40lp_plat_ops *ops = priv->plat_ops;
+	int ret = 0;
+
+	if (ops && ops->plat_exit)
+		ret = ops->plat_exit(priv);
+
+	return ret;
+}
+
+static int miphy40lp_power_off(struct phy *phy)
+{
+	struct miphy40lp_priv *priv = phy_get_drvdata(phy);
+	struct miphy40lp_plat_ops *ops = priv->plat_ops;
+	int ret = 0;
+
+	if (ops && ops->plat_init)
+		ret = ops->plat_init(priv);
+
+	return ret;
+}
+
+static int miphy40lp_power_on(struct phy *phy)
+{
+	struct miphy40lp_priv *priv = phy_get_drvdata(phy);
+	struct miphy40lp_plat_ops *ops = priv->plat_ops;
+	int ret = 0;
+
+	if (ops && ops->plat_power_on)
+		ret = ops->plat_power_on(priv);
+
+	return ret;
+}
+
+static const struct of_device_id miphy40lp_of_match[] = {
+	{ .compatible = "st,miphy40lp-phy", .data = NULL },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, miphy40lp_of_match);
+
+static struct phy_ops miphy40lp_ops = {
+	.init = miphy40lp_init,
+	.exit = miphy40lp_exit,
+	.power_off = miphy40lp_power_off,
+	.power_on = miphy40lp_power_on,
+	.owner = THIS_MODULE,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int miphy40lp_suspend(struct device *dev)
+{
+	struct miphy40lp_priv *priv = dev_get_drvdata(dev);
+	struct miphy40lp_plat_ops *ops = priv->plat_ops;
+	int ret = 0;
+
+	if (ops && ops->plat_suspend)
+		ret = ops->plat_suspend(priv);
+
+	return ret;
+}
+
+static int miphy40lp_resume(struct device *dev)
+{
+	struct miphy40lp_priv *priv = dev_get_drvdata(dev);
+	struct miphy40lp_plat_ops *ops = priv->plat_ops;
+	int ret = 0;
+
+	if (ops && ops->plat_resume)
+		ret = ops->plat_resume(priv);
+
+	return ret;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(miphy40lp_pm_ops, miphy40lp_suspend,
+		miphy40lp_resume);
+
+static struct phy *miphy40lp_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct miphy40lp_priv *priv = dev_get_drvdata(dev);
+
+	if (args->args_count < 1) {
+		dev_err(dev, "DT did not pass correct no of args\n");
+		return NULL;
+	}
+
+	priv->mode = args->args[0];
+
+	return priv->phy;
+}
+
+static int __init miphy40lp_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct miphy40lp_priv *priv;
+	struct phy_provider *phy_provider;
+	const struct of_device_id *of_id;
+
+	of_id = of_match_device(miphy40lp_of_match, dev);
+	if (!of_id) {
+		dev_err(dev, "can't find a matching platform\n");
+		return -EINVAL;
+	}
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(dev, "can't alloc miphy40lp private date memory\n");
+		return -ENOMEM;
+	}
+
+	priv->plat_ops = (struct miphy40lp_plat_ops *)of_id->data;
+
+	priv->misc =
+		syscon_regmap_lookup_by_phandle(dev->of_node, "misc");
+	if (IS_ERR(priv->misc)) {
+		dev_err(dev, "failed to find misc regmap\n");
+		return PTR_ERR(priv->misc);
+	}
+
+	if (of_property_read_u32(dev->of_node, "phy-id", &priv->id)) {
+		dev_err(dev, "failed to find phy id\n");
+		return -EINVAL;
+	}
+
+	priv->phy = devm_phy_create(dev, &miphy40lp_ops, NULL);
+	if (IS_ERR(priv->phy)) {
+		dev_err(dev, "failed to create SATA PCIe PHY\n");
+		return PTR_ERR(priv->phy);
+	}
+
+	dev_set_drvdata(dev, priv);
+	phy_set_drvdata(priv->phy, priv);
+
+	phy_provider = devm_of_phy_provider_register(dev, miphy40lp_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(dev, "failed to register phy provider\n");
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static struct platform_driver miphy40lp_driver = {
+	.driver = {
+		.name = "miphy40lp-phy",
+		.owner = THIS_MODULE,
+		.pm = &miphy40lp_pm_ops,
+		.of_match_table = of_match_ptr(miphy40lp_of_match),
+	},
+};
+
+static int __init miphy40lp_phy_init(void)
+{
+
+	return platform_driver_probe(&miphy40lp_driver,
+				miphy40lp_probe);
+}
+module_init(miphy40lp_phy_init);
+
+MODULE_DESCRIPTION("ST MIPHY-40LP driver");
+MODULE_AUTHOR("Pratyush Anand <pratyush.anand@st.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.2

