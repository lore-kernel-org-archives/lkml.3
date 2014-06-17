Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaFQH6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:58:23 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38005 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbaFQH6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:58:19 -0400
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>, arnd@arndb.de,
        mark.rutland@arm.com, haifeng.yan@linaro.org, jchxue@gmail.com,
        zhangfei.gao@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Jiancheng Xue <xuejiancheng@huawei.com>
Subject: [PATCH 2/2] phy: add hix5hd2-sata-phy driver
Date: Tue, 17 Jun 2014 15:58:01 +0800
Message-Id: <1402991881-27676-3-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402991881-27676-1-git-send-email-zhangfei.gao@linaro.org>
References: <1402991881-27676-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiancheng Xue <xuejiancheng@huawei.com>

Add hix5hd2-sata-phy driver on Hisilicon hix5hd2 soc.

Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/phy/Kconfig            |    8 ++
 drivers/phy/Makefile           |    1 +
 drivers/phy/phy-hix5hd2-sata.c |  192 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 201 insertions(+)
 create mode 100644 drivers/phy/phy-hix5hd2-sata.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 16a2f06..782953d 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -109,6 +109,14 @@ config PHY_EXYNOS5250_SATA
 	  SATA 3.0 Gb/s, SATA 6.0 Gb/s speeds. It supports one SATA host
 	  port to accept one SATA device.
 
+config PHY_HIX5HD2_SATA
+	tristate "HIX5HD2 SATA PHY Driver"
+	depends on ARCH_HIX5HD2 && OF
+	select GENERIC_PHY
+	select MFD_SYSCON
+	help
+	  Support for SATA PHY on Hisilicon hix5hd2 Soc.
+
 config PHY_SUN4I_USB
 	tristate "Allwinner sunxi SoC USB PHY driver"
 	depends on ARCH_SUNXI && HAS_IOMEM && OF
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index b4f1d57..54f04d0 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TI_PIPE3)			+= phy-ti-pipe3.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
 obj-$(CONFIG_PHY_EXYNOS5250_SATA)	+= phy-exynos5250-sata.o
+obj-$(CONFIG_PHY_HIX5HD2_SATA)		+= phy-hix5hd2-sata.o
 obj-$(CONFIG_PHY_SUN4I_USB)		+= phy-sun4i-usb.o
 obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-exynos-usb2.o
 phy-exynos-usb2-y			+= phy-samsung-usb2.o
diff --git a/drivers/phy/phy-hix5hd2-sata.c b/drivers/phy/phy-hix5hd2-sata.c
new file mode 100644
index 0000000..107804b4
--- /dev/null
+++ b/drivers/phy/phy-hix5hd2-sata.c
@@ -0,0 +1,192 @@
+/*
+ * Copyright (c) 2014 Linaro Ltd.
+ * Copyright (c) 2014 Hisilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/phy/phy.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+
+#define SATA_PHY0_CTLL		0xa0
+#define MPLL_MULTIPLIER_SHIFT	1
+#define MPLL_MULTIPLIER_WIDTH	7
+#define MPLL_MULTIPLIER_50M	0x3c
+#define MPLL_MULTIPLIER_100M	0x1e
+#define PHY_RESET		BIT(0)
+#define REF_SSP_EN		BIT(9)
+#define SSC_EN			BIT(10)
+#define REF_USE_PAD		BIT(23)
+
+#define SATA_PORT_PHYCTL	0x174
+#define HALF_RATE_SHIFT		16
+#define HALF_RATE_WIDTH		2
+#define PHY_CONFIG_SHIFT	18
+#define PHY_CONFIG_WIDTH	2
+#define GEN2_EN_SHIFT		21
+#define GEN2_EN_WIDTH		2
+#define SPEED_CTRL		BIT(20)
+
+struct hix5hd2_priv {
+	void __iomem	*base;
+	struct regmap	*peri_ctrl;
+	struct phy	*phy;
+};
+
+enum phy_speed_mode {
+	SPEED_MODE_GEN1 = 0,
+	SPEED_MODE_GEN2	= 1,
+	SPEED_MODE_GEN3	= 2,
+};
+
+static void hix5hd2_sata_phy_write(void __iomem *addr, int shift,
+				   int width, int value)
+{
+	int reg, mask;
+
+	mask = BIT(width) - 1;
+	reg = readl_relaxed(addr);
+	reg &= ~(mask << shift);
+	reg |= (value & mask) << shift;
+	writel_relaxed(reg, addr);
+}
+
+static void hix5hd2_sata_phy_setspeed(struct hix5hd2_priv *priv,
+				      enum phy_speed_mode mode)
+{
+	hix5hd2_sata_phy_write(priv->base + SATA_PORT_PHYCTL, HALF_RATE_SHIFT,
+			       HALF_RATE_WIDTH, mode);
+	hix5hd2_sata_phy_write(priv->base + SATA_PORT_PHYCTL, PHY_CONFIG_SHIFT,
+			       PHY_CONFIG_WIDTH, mode);
+	hix5hd2_sata_phy_write(priv->base + SATA_PORT_PHYCTL, GEN2_EN_SHIFT,
+			       GEN2_EN_WIDTH, mode);
+}
+
+static int hix5hd2_sata_phy_init(struct phy *phy)
+{
+	struct hix5hd2_priv *priv = phy_get_drvdata(phy);
+	u32 offset, shift, width, value, data[2];
+	const __be32 *paddr;
+	int i, lenp, ret;
+
+	if (priv->peri_ctrl) {
+		ret = of_property_read_u32_array(phy->dev.of_node,
+						 "hisilicon,power-reg",
+						 &data[0], 2);
+		if (ret)
+			dev_warn(&phy->dev, "Fail read hisilicon,power-reg\n");
+
+		regmap_update_bits(priv->peri_ctrl, data[0],
+				   BIT(data[1]), BIT(data[1]));
+	}
+
+	/* reset phy */
+	hix5hd2_sata_phy_write(priv->base + SATA_PHY0_CTLL,
+			       MPLL_MULTIPLIER_SHIFT, MPLL_MULTIPLIER_WIDTH,
+			       MPLL_MULTIPLIER_50M);
+	value = readl_relaxed(priv->base + SATA_PHY0_CTLL);
+	value &= ~(REF_USE_PAD);
+	value |= (REF_SSP_EN | PHY_RESET);
+	writel_relaxed(value, priv->base + SATA_PHY0_CTLL);
+	msleep(20);
+	value &= ~(PHY_RESET);
+	writel_relaxed(value, priv->base + SATA_PHY0_CTLL);
+
+	paddr = of_get_property(phy->dev.of_node, "hisilicon,reg-init", &lenp);
+	if (!paddr || lenp < 4 * sizeof(*paddr))
+		return 0;
+
+	lenp /= sizeof(*paddr);
+	for (i = 0; i < lenp - 3; i += 4) {
+		offset = be32_to_cpup(paddr + i);
+		shift = be32_to_cpup(paddr + i + 1);
+		width = be32_to_cpup(paddr + i + 2);
+		value = be32_to_cpup(paddr + i + 3);
+		hix5hd2_sata_phy_write(priv->base + offset,
+				       shift, width, value);
+	}
+
+	/* ensure reg-init takes effect */
+	value = readl_relaxed(priv->base + SATA_PORT_PHYCTL);
+	value |= SPEED_CTRL;
+	writel_relaxed(value, priv->base + SATA_PORT_PHYCTL);
+	hix5hd2_sata_phy_setspeed(priv, SPEED_MODE_GEN1);
+	msleep(20);
+	hix5hd2_sata_phy_setspeed(priv, SPEED_MODE_GEN3);
+	value = readl_relaxed(priv->base + SATA_PORT_PHYCTL);
+	value &= ~(SPEED_CTRL);
+	writel_relaxed(value, priv->base + SATA_PORT_PHYCTL);
+	hix5hd2_sata_phy_setspeed(priv, SPEED_MODE_GEN2);
+
+	return 0;
+}
+
+static struct phy_ops hix5hd2_sata_phy_ops = {
+	.init		= hix5hd2_sata_phy_init,
+	.owner		= THIS_MODULE,
+};
+
+static int hix5hd2_sata_phy_probe(struct platform_device *pdev)
+{
+	struct phy_provider *phy_provider;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct hix5hd2_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!priv->base)
+		return -ENOMEM;
+
+	priv->peri_ctrl = syscon_regmap_lookup_by_phandle(dev->of_node,
+						"hisilicon,peri-syscon");
+	if (IS_ERR(priv->peri_ctrl))
+		priv->peri_ctrl = NULL;
+
+	priv->phy = devm_phy_create(dev, &hix5hd2_sata_phy_ops, NULL);
+	if (IS_ERR(priv->phy)) {
+		dev_err(dev, "failed to create PHY\n");
+		return PTR_ERR(priv->phy);
+	}
+
+	phy_set_drvdata(priv->phy, priv);
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	return 0;
+}
+
+static const struct of_device_id hix5hd2_sata_phy_of_match[] = {
+	{.compatible = "hisilicon,hix5hd2-sata-phy",},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, hix5hd2_sata_phy_of_match);
+
+static struct platform_driver hix5hd2_sata_phy_driver = {
+	.probe	= hix5hd2_sata_phy_probe,
+	.driver = {
+		.name	= "hix5hd2-sata-phy",
+		.owner	= THIS_MODULE,
+		.of_match_table	= hix5hd2_sata_phy_of_match,
+	}
+};
+module_platform_driver(hix5hd2_sata_phy_driver);
+
+MODULE_AUTHOR("Jiancheng Xue <xuejiancheng@huawei.com>");
+MODULE_DESCRIPTION("HISILICON HIX5HD2 SATA PHY driver");
+MODULE_ALIAS("platform:hix5hd2-sata-phy");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

