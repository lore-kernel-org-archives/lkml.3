Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaGVK5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:57:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46577 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbaGVK5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/28] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
Date: Tue, 22 Jul 2014 16:26:39 +0530
Message-ID: <1406026611-30493-17-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Add a PHY driver for uses with AHCI based SATA controller driver on the
APQ8064 family of SoCs.

This patch is a forward port from Qualcomm's v3.4 andriod kernel.

Tested on IFC6410 board.

CC: Sujit Reddy Thumma <sthumma@codeaurora.org>
Tested-by: Kiran Padwal <kiran.padwal@smartplayin.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig                 |    7 +
 drivers/phy/Makefile                |    1 +
 drivers/phy/phy-qcom-apq8064-sata.c |  288 +++++++++++++++++++++++++++++++++++
 3 files changed, 296 insertions(+)
 create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 778e126..6911152 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -177,4 +177,11 @@ config PHY_XGENE
 	help
 	  This option enables support for APM X-Gene SoC multi-purpose PHY.
 
+config PHY_QCOM_APQ8064_SATA
+	tristate "Qualcomm APQ8064 SATA SerDes/PHY driver"
+	depends on ARCH_QCOM
+	depends on HAS_IOMEM
+	depends on OF
+	select GENERIC_PHY
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 54f04d0..a4819d3 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -21,3 +21,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
 obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
+obj-$(CONFIG_PHY_QCOM_APQ8064_SATA)	+= phy-qcom-apq8064-sata.o
diff --git a/drivers/phy/phy-qcom-apq8064-sata.c b/drivers/phy/phy-qcom-apq8064-sata.c
new file mode 100644
index 0000000..c9b4dd6
--- /dev/null
+++ b/drivers/phy/phy-qcom-apq8064-sata.c
@@ -0,0 +1,288 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/time.h>
+#include <linux/delay.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/phy/phy.h>
+
+/* PHY registers */
+#define UNIPHY_PLL_REFCLK_CFG		0x000
+#define UNIPHY_PLL_PWRGEN_CFG		0x014
+#define UNIPHY_PLL_GLB_CFG		0x020
+#define UNIPHY_PLL_SDM_CFG0		0x038
+#define UNIPHY_PLL_SDM_CFG1		0x03C
+#define UNIPHY_PLL_SDM_CFG2		0x040
+#define UNIPHY_PLL_SDM_CFG3		0x044
+#define UNIPHY_PLL_SDM_CFG4		0x048
+#define UNIPHY_PLL_SSC_CFG0		0x04C
+#define UNIPHY_PLL_SSC_CFG1		0x050
+#define UNIPHY_PLL_SSC_CFG2		0x054
+#define UNIPHY_PLL_SSC_CFG3		0x058
+#define UNIPHY_PLL_LKDET_CFG0		0x05C
+#define UNIPHY_PLL_LKDET_CFG1		0x060
+#define UNIPHY_PLL_LKDET_CFG2		0x064
+#define UNIPHY_PLL_CAL_CFG0		0x06C
+#define UNIPHY_PLL_CAL_CFG8		0x08C
+#define UNIPHY_PLL_CAL_CFG9		0x090
+#define UNIPHY_PLL_CAL_CFG10		0x094
+#define UNIPHY_PLL_CAL_CFG11		0x098
+#define UNIPHY_PLL_STATUS		0x0C0
+
+#define SATA_PHY_SER_CTRL		0x100
+#define SATA_PHY_TX_DRIV_CTRL0		0x104
+#define SATA_PHY_TX_DRIV_CTRL1		0x108
+#define SATA_PHY_TX_IMCAL0		0x11C
+#define SATA_PHY_TX_IMCAL2		0x124
+#define SATA_PHY_RX_IMCAL0		0x128
+#define SATA_PHY_EQUAL			0x13C
+#define SATA_PHY_OOB_TERM		0x144
+#define SATA_PHY_CDR_CTRL0		0x148
+#define SATA_PHY_CDR_CTRL1		0x14C
+#define SATA_PHY_CDR_CTRL2		0x150
+#define SATA_PHY_CDR_CTRL3		0x154
+#define SATA_PHY_PI_CTRL0		0x168
+#define SATA_PHY_POW_DWN_CTRL0		0x180
+#define SATA_PHY_POW_DWN_CTRL1		0x184
+#define SATA_PHY_TX_DATA_CTRL		0x188
+#define SATA_PHY_ALIGNP			0x1A4
+#define SATA_PHY_TX_IMCAL_STAT		0x1E4
+#define SATA_PHY_RX_IMCAL_STAT		0x1E8
+
+#define UNIPHY_PLL_LOCK		BIT(0)
+#define SATA_PHY_TX_CAL		BIT(0)
+#define SATA_PHY_RX_CAL		BIT(0)
+
+/* default timeout set to 1 sec */
+#define TIMEOUT_MS		10000
+#define DELAY_INTERVAL_US	100
+
+struct qcom_apq8064_sata_phy {
+	void __iomem *mmio;
+	struct clk *cfg_clk;
+	struct device *dev;
+};
+
+/* Helper function to do poll and timeout */
+static int read_poll_timeout(void __iomem *addr, u32 mask)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(TIMEOUT_MS);
+
+	do {
+		if (readl_relaxed(addr) & mask)
+			return 0;
+
+		 usleep_range(DELAY_INTERVAL_US, DELAY_INTERVAL_US + 50);
+	} while (!time_after(jiffies, timeout));
+
+	return -ETIMEDOUT;
+}
+
+static int qcom_apq8064_sata_phy_init(struct phy *generic_phy)
+{
+	struct qcom_apq8064_sata_phy *phy = phy_get_drvdata(generic_phy);
+	void __iomem *base = phy->mmio;
+	int ret = 0;
+
+	/* SATA phy initialization */
+	writel_relaxed(0x01, base + SATA_PHY_SER_CTRL);
+	writel_relaxed(0xB1, base + SATA_PHY_POW_DWN_CTRL0);
+	/* Make sure the power down happens before power up */
+	mb();
+	usleep_range(10, 60);
+
+	writel_relaxed(0x01, base + SATA_PHY_POW_DWN_CTRL0);
+	writel_relaxed(0x3E, base + SATA_PHY_POW_DWN_CTRL1);
+	writel_relaxed(0x01, base + SATA_PHY_RX_IMCAL0);
+	writel_relaxed(0x01, base + SATA_PHY_TX_IMCAL0);
+	writel_relaxed(0x02, base + SATA_PHY_TX_IMCAL2);
+
+	/* Write UNIPHYPLL registers to configure PLL */
+	writel_relaxed(0x04, base + UNIPHY_PLL_REFCLK_CFG);
+	writel_relaxed(0x00, base + UNIPHY_PLL_PWRGEN_CFG);
+
+	writel_relaxed(0x0A, base + UNIPHY_PLL_CAL_CFG0);
+	writel_relaxed(0xF3, base + UNIPHY_PLL_CAL_CFG8);
+	writel_relaxed(0x01, base + UNIPHY_PLL_CAL_CFG9);
+	writel_relaxed(0xED, base + UNIPHY_PLL_CAL_CFG10);
+	writel_relaxed(0x02, base + UNIPHY_PLL_CAL_CFG11);
+
+	writel_relaxed(0x36, base + UNIPHY_PLL_SDM_CFG0);
+	writel_relaxed(0x0D, base + UNIPHY_PLL_SDM_CFG1);
+	writel_relaxed(0xA3, base + UNIPHY_PLL_SDM_CFG2);
+	writel_relaxed(0xF0, base + UNIPHY_PLL_SDM_CFG3);
+	writel_relaxed(0x00, base + UNIPHY_PLL_SDM_CFG4);
+
+	writel_relaxed(0x19, base + UNIPHY_PLL_SSC_CFG0);
+	writel_relaxed(0xE1, base + UNIPHY_PLL_SSC_CFG1);
+	writel_relaxed(0x00, base + UNIPHY_PLL_SSC_CFG2);
+	writel_relaxed(0x11, base + UNIPHY_PLL_SSC_CFG3);
+
+	writel_relaxed(0x04, base + UNIPHY_PLL_LKDET_CFG0);
+	writel_relaxed(0xFF, base + UNIPHY_PLL_LKDET_CFG1);
+
+	writel_relaxed(0x02, base + UNIPHY_PLL_GLB_CFG);
+	/* make sure global config LDO power down happens before power up */
+	mb();
+
+	writel_relaxed(0x03, base + UNIPHY_PLL_GLB_CFG);
+	writel_relaxed(0x05, base + UNIPHY_PLL_LKDET_CFG2);
+
+	/* PLL Lock wait */
+	ret = read_poll_timeout(base + UNIPHY_PLL_STATUS, UNIPHY_PLL_LOCK);
+	if (ret) {
+		dev_err(phy->dev, "poll timeout UNIPHY_PLL_STATUS\n");
+		return ret;
+	}
+
+	/* TX Calibration */
+	ret = read_poll_timeout(base + SATA_PHY_TX_IMCAL_STAT, SATA_PHY_TX_CAL);
+	if (ret) {
+		dev_err(phy->dev, "poll timeout SATA_PHY_TX_IMCAL_STAT\n");
+		return ret;
+	}
+
+	/* RX Calibration */
+	ret = read_poll_timeout(base + SATA_PHY_RX_IMCAL_STAT, SATA_PHY_RX_CAL);
+	if (ret) {
+		dev_err(phy->dev, "poll timeout SATA_PHY_RX_IMCAL_STAT\n");
+		return ret;
+	}
+
+	/* SATA phy calibrated succesfully, power up to functional mode */
+	writel_relaxed(0x3E, base + SATA_PHY_POW_DWN_CTRL1);
+	writel_relaxed(0x01, base + SATA_PHY_RX_IMCAL0);
+	writel_relaxed(0x01, base + SATA_PHY_TX_IMCAL0);
+
+	writel_relaxed(0x00, base + SATA_PHY_POW_DWN_CTRL1);
+	writel_relaxed(0x59, base + SATA_PHY_CDR_CTRL0);
+	writel_relaxed(0x04, base + SATA_PHY_CDR_CTRL1);
+	writel_relaxed(0x00, base + SATA_PHY_CDR_CTRL2);
+	writel_relaxed(0x00, base + SATA_PHY_PI_CTRL0);
+	writel_relaxed(0x00, base + SATA_PHY_CDR_CTRL3);
+	writel_relaxed(0x01, base + SATA_PHY_POW_DWN_CTRL0);
+
+	writel_relaxed(0x11, base + SATA_PHY_TX_DATA_CTRL);
+	writel_relaxed(0x43, base + SATA_PHY_ALIGNP);
+	writel_relaxed(0x04, base + SATA_PHY_OOB_TERM);
+
+	writel_relaxed(0x01, base + SATA_PHY_EQUAL);
+	writel_relaxed(0x09, base + SATA_PHY_TX_DRIV_CTRL0);
+	writel_relaxed(0x09, base + SATA_PHY_TX_DRIV_CTRL1);
+
+	return 0;
+}
+
+static int qcom_apq8064_sata_phy_exit(struct phy *generic_phy)
+{
+	struct qcom_apq8064_sata_phy *phy = phy_get_drvdata(generic_phy);
+	void __iomem *base = phy->mmio;
+
+	/* Power down PHY */
+	writel_relaxed(0xF8, base + SATA_PHY_POW_DWN_CTRL0);
+	writel_relaxed(0xFE, base + SATA_PHY_POW_DWN_CTRL1);
+
+	/* Power down PLL block */
+	writel_relaxed(0x00, base + UNIPHY_PLL_GLB_CFG);
+
+	return 0;
+}
+
+static struct phy_ops qcom_apq8064_sata_phy_ops = {
+	.init		= qcom_apq8064_sata_phy_init,
+	.exit		= qcom_apq8064_sata_phy_exit,
+	.owner		= THIS_MODULE,
+};
+
+static int qcom_apq8064_sata_phy_probe(struct platform_device *pdev)
+{
+	struct qcom_apq8064_sata_phy *phy;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct phy_provider *phy_provider;
+	struct phy *generic_phy;
+	int ret;
+
+	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	phy->mmio = devm_ioremap_resource(dev, res);
+	if (IS_ERR(phy->mmio))
+		return PTR_ERR(phy->mmio);
+
+	generic_phy = devm_phy_create(dev, &qcom_apq8064_sata_phy_ops, NULL);
+	if (IS_ERR(generic_phy)) {
+		dev_err(dev, "%s: failed to create phy\n", __func__);
+		return PTR_ERR(generic_phy);
+	}
+
+	phy->dev = dev;
+	phy_set_drvdata(generic_phy, phy);
+	platform_set_drvdata(pdev, phy);
+
+	phy->cfg_clk = devm_clk_get(dev, "cfg");
+	if (IS_ERR(phy->cfg_clk)) {
+		dev_err(dev, "Failed to get sata cfg clock\n");
+		return PTR_ERR(phy->cfg_clk);
+	}
+
+	ret = clk_prepare_enable(phy->cfg_clk);
+	if (ret)
+		return ret;
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider)) {
+		clk_disable_unprepare(phy->cfg_clk);
+		dev_err(dev, "%s: failed to register phy\n", __func__);
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static int qcom_apq8064_sata_phy_remove(struct platform_device *pdev)
+{
+	struct qcom_apq8064_sata_phy *phy = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(phy->cfg_clk);
+
+	return 0;
+}
+
+static const struct of_device_id qcom_apq8064_sata_phy_of_match[] = {
+	{ .compatible = "qcom,apq8064-sata-phy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, qcom_apq8064_sata_phy_of_match);
+
+static struct platform_driver qcom_apq8064_sata_phy_driver = {
+	.probe	= qcom_apq8064_sata_phy_probe,
+	.remove	= qcom_apq8064_sata_phy_remove,
+	.driver = {
+		.name	= "qcom-apq8064-sata-phy",
+		.owner	= THIS_MODULE,
+		.of_match_table	= qcom_apq8064_sata_phy_of_match,
+	}
+};
+module_platform_driver(qcom_apq8064_sata_phy_driver);
+
+MODULE_DESCRIPTION("QCOM apq8064 SATA PHY driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

