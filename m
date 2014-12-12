Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031076AbaLLRRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:17:35 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:33683 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030596AbaLLRRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:17:32 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 2/5] phy: qcom: Add Qualcomm PCIe PHY
Date: Fri, 12 Dec 2014 19:13:58 +0200
Message-Id: <1418404441-5518-3-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
References: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a PCIe PHY driver used by PCIe host controller driver
on Qualcomm SoCs like Snapdragon 805.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/phy/Kconfig         |    7 +
 drivers/phy/Makefile        |    1 +
 drivers/phy/phy-qcom-pcie.c |  311 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 319 insertions(+), 0 deletions(-)
 create mode 100644 drivers/phy/phy-qcom-pcie.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 2a436e6..135bdcc 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -218,6 +218,13 @@ config PHY_QCOM_IPQ806X_SATA
 	depends on OF
 	select GENERIC_PHY
 
+config PHY_QCOM_PCIE
+	tristate "Qualcomm PCIe SerDes/PHY driver"
+	depends on ARCH_QCOM
+	depends on HAS_IOMEM
+	depends on OF
+	select GENERIC_PHY
+
 config PHY_ST_SPEAR1310_MIPHY
 	tristate "ST SPEAR1310-MIPHY driver"
 	select GENERIC_PHY
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index c4590fc..e7662fb 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -26,6 +26,7 @@ phy-exynos-usb2-$(CONFIG_PHY_S5PV210_USB2)	+= phy-s5pv210-usb2.o
 obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
 obj-$(CONFIG_PHY_QCOM_APQ8064_SATA)	+= phy-qcom-apq8064-sata.o
 obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
+obj-$(CONFIG_PHY_QCOM_PCIE)		+= phy-qcom-pcie.o
 obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
 obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
diff --git a/drivers/phy/phy-qcom-pcie.c b/drivers/phy/phy-qcom-pcie.c
new file mode 100644
index 0000000..3db348a
--- /dev/null
+++ b/drivers/phy/phy-qcom-pcie.c
@@ -0,0 +1,311 @@
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
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#define QSERDES_COM_PLL_CP_SETI			0x024
+#define QSERDES_COM_PLL_IP_SETP			0x028
+#define QSERDES_COM_PLL_CP_SETP			0x02c
+#define QSERDES_COM_SYSCLK_EN_SEL		0x038
+#define QSERDES_COM_RESETSM_CNTRL		0x040
+#define QSERDES_COM_PLLLOCK_CMP1		0x044
+#define QSERDES_COM_PLLLOCK_CMP2		0x048
+#define QSERDES_COM_PLLLOCK_CMP_EN		0x050
+#define QSERDES_COM_DEC_START1			0x064
+#define QSERDES_COM_DIV_FRAC_START1		0x098
+#define QSERDES_COM_DIV_FRAC_START2		0x09c
+#define QSERDES_COM_DIV_FRAC_START3		0x0a0
+#define QSERDES_COM_DEC_START2			0x0a4
+#define QSERDES_COM_PLL_RXTXEPCLK_EN		0x0a8
+#define QSERDES_COM_PLL_CRCTRL			0x0ac
+
+#define QSERDES_RX_CDR_CONTROL			0x400
+#define QSERDES_RX_CDR_CONTROL2			0x410
+#define QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE	0x42c
+#define QSERDES_RX_RX_EQ_GAIN12			0x430
+
+#define PCIE_PHY_SW_RESET			0x600
+#define PCIE_PHY_POWER_DOWN_CONTROL		0x604
+#define PCIE_PHY_START				0x608
+#define PCIE_PHY_ENDPOINT_REFCLK_DRIVE		0x648
+#define PCIE_PHY_POWER_STATE_CONFIG1		0x650
+#define PCIE_PHY_POWER_STATE_CONFIG2		0x654
+#define PCIE_PHY_PWRUP_RESET_DLY_TIME_SYSCLK	0x678
+#define PCIE_PHY_PWRUP_RESET_DLY_TIME_AUXCLK	0x67c
+#define PCIE_PHY_PCS_STATUS			0x6c8
+
+#define PHY_DELAY_MIN_US			995
+#define PHY_DELAY_MAX_US			1005
+#define PHY_RETRIES_COUNT			10
+
+#define PIPE_CLK_DELAY_MIN_US			5000
+#define PIPE_CLK_DELAY_MAX_US			5100
+#define PIPE_CLK_RETRIES_COUNT			10
+
+struct qcom_pcie_phy {
+	void __iomem *base;
+	struct clk *clk;
+	struct reset_control *res_phy;
+	struct regulator *vdda_pll;
+	struct regulator *vdda;
+	struct device *dev;
+};
+
+struct phy_regs {
+	u32 reg_offset;
+	u32 val;
+};
+
+static const struct phy_regs pcie_phy_regs[] = {
+	{ PCIE_PHY_POWER_DOWN_CONTROL,			0x03 },
+	{ QSERDES_COM_SYSCLK_EN_SEL,			0x08 },
+	{ QSERDES_COM_DEC_START1,			0x82 },
+	{ QSERDES_COM_DEC_START2,			0x03 },
+	{ QSERDES_COM_DIV_FRAC_START1,			0xd5 },
+	{ QSERDES_COM_DIV_FRAC_START2,			0xaa },
+	{ QSERDES_COM_DIV_FRAC_START3,			0x13 },
+	{ QSERDES_COM_PLLLOCK_CMP_EN,			0x01 },
+	{ QSERDES_COM_PLLLOCK_CMP1,			0x2b },
+	{ QSERDES_COM_PLLLOCK_CMP2,			0x68 },
+	{ QSERDES_COM_PLL_CRCTRL,			0xff },
+	{ QSERDES_COM_PLL_CP_SETI,			0x3f },
+	{ QSERDES_COM_PLL_IP_SETP,			0x07 },
+	{ QSERDES_COM_PLL_CP_SETP,			0x03 },
+	{ QSERDES_RX_CDR_CONTROL,			0xf3 },
+	{ QSERDES_RX_CDR_CONTROL2,			0x6b },
+	{ QSERDES_COM_RESETSM_CNTRL,			0x10 },
+	{ QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE,	0x87 },
+	{ QSERDES_RX_RX_EQ_GAIN12,			0x54 },
+	{ PCIE_PHY_POWER_STATE_CONFIG1,			0xa3 },
+	{ PCIE_PHY_POWER_STATE_CONFIG2,			0xcb },
+	{ QSERDES_COM_PLL_RXTXEPCLK_EN,			0x10 },
+	{ PCIE_PHY_ENDPOINT_REFCLK_DRIVE,		0x10 },
+	{ PCIE_PHY_SW_RESET,				0x00 },
+	{ PCIE_PHY_START,				0x03 },
+};
+
+static void qcom_pcie_phy_init(struct qcom_pcie_phy *pcie)
+{
+	const struct phy_regs *regs = pcie_phy_regs;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(pcie_phy_regs); i++)
+		writel(regs[i].val, pcie->base + regs[i].reg_offset);
+}
+
+static bool qcom_pcie_phy_is_ready(struct qcom_pcie_phy *pcie)
+{
+	u32 val = readl(pcie->base + PCIE_PHY_PCS_STATUS);
+
+	return val & BIT(6) ? false : true;
+}
+
+static int qcom_pcie_phy_power_on(struct phy *phy)
+{
+	struct qcom_pcie_phy *pcie = phy_get_drvdata(phy);
+	struct device *dev = pcie->dev;
+	int ret, retries;
+
+	ret = regulator_enable(pcie->vdda_pll);
+	if (ret) {
+		dev_err(dev, "cannot enable vdda_pll regulator\n");
+		return ret;
+	}
+
+	ret = regulator_enable(pcie->vdda);
+	if (ret) {
+		dev_err(dev, "cannot enable vdda regulator\n");
+		goto fail_vdda_pll;
+	}
+
+	ret = reset_control_deassert(pcie->res_phy);
+	if (ret) {
+		dev_err(dev, "cannot deassert phy reset\n");
+		goto fail_vdda;
+	}
+
+	qcom_pcie_phy_init(pcie);
+
+	usleep_range(PHY_DELAY_MIN_US, PHY_DELAY_MAX_US);
+
+	ret = clk_set_rate(pcie->clk, ~0);
+	if (ret) {
+		dev_err(dev, "cannot set pipe clk rate\n");
+		goto fail_res;
+	}
+
+	/*
+	 * setting pipe rate takes time, try arbitrary delay before enabling
+	 * the clock
+	 */
+	retries = PIPE_CLK_RETRIES_COUNT;
+	do {
+		usleep_range(PIPE_CLK_DELAY_MIN_US, PIPE_CLK_DELAY_MAX_US);
+
+		ret = clk_prepare_enable(pcie->clk);
+		if (!ret)
+			break;
+	} while (retries--);
+
+	if (retries < 0) {
+		dev_err(dev, "cannot enable phy clock\n");
+		goto fail_res;
+	}
+
+	retries = PHY_RETRIES_COUNT;
+	do {
+		ret = qcom_pcie_phy_is_ready(pcie);
+		if (ret)
+			break;
+		usleep_range(PHY_DELAY_MIN_US, PHY_DELAY_MAX_US);
+	} while (retries--);
+
+	if (retries < 0) {
+		dev_err(dev, "phy failed to come up\n");
+		ret = -ETIMEDOUT;
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	clk_disable_unprepare(pcie->clk);
+fail_res:
+	reset_control_assert(pcie->res_phy);
+fail_vdda:
+	regulator_disable(pcie->vdda);
+fail_vdda_pll:
+	regulator_disable(pcie->vdda_pll);
+
+	return ret;
+}
+
+static int qcom_pcie_phy_power_off(struct phy *phy)
+{
+	struct qcom_pcie_phy *pcie = phy_get_drvdata(phy);
+
+	writel(1, pcie->base + PCIE_PHY_SW_RESET);
+	writel(0, pcie->base + PCIE_PHY_POWER_DOWN_CONTROL);
+
+	reset_control_assert(pcie->res_phy);
+	clk_disable_unprepare(pcie->clk);
+	regulator_disable(pcie->vdda);
+	regulator_disable(pcie->vdda_pll);
+
+	return 0;
+}
+
+static struct phy_ops qcom_pcie_phy_ops = {
+	.power_on = qcom_pcie_phy_power_on,
+	.power_off = qcom_pcie_phy_power_off,
+	.owner = THIS_MODULE,
+};
+
+static int qcom_pcie_phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy_provider *provider;
+	struct qcom_pcie_phy *pcie;
+	struct resource *res;
+	struct phy *phy;
+
+	pcie = devm_kzalloc(dev, sizeof(*pcie), GFP_KERNEL);
+	if (!pcie)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pcie->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(pcie->base))
+		return PTR_ERR(pcie->base);
+
+	pcie->clk = devm_clk_get(dev, "core");
+	if (IS_ERR(pcie->clk)) {
+		dev_err(dev, "failed to get pcie phy clock\n");
+		return PTR_ERR(pcie->clk);
+	}
+
+	pcie->vdda = devm_regulator_get(dev, "vdda");
+	if (IS_ERR(pcie->vdda)) {
+		dev_err(dev, "failed to get vdda regulator\n");
+		return PTR_ERR(pcie->vdda);
+	}
+
+	pcie->vdda_pll = devm_regulator_get(dev, "vdda_pll");
+	if (IS_ERR(pcie->vdda_pll)) {
+		dev_err(dev, "failed to get vdda_pll regulator\n");
+		return PTR_ERR(pcie->vdda_pll);
+	}
+
+	pcie->res_phy = devm_reset_control_get(dev, "phy");
+	if (IS_ERR(pcie->res_phy)) {
+		dev_err(dev, "cannot get phy reset controller");
+		return PTR_ERR(pcie->res_phy);
+	}
+
+	phy = devm_phy_create(dev, NULL, &qcom_pcie_phy_ops, NULL);
+	if (IS_ERR(phy)) {
+		dev_err(dev, "failed to create phy\n");
+		return PTR_ERR(phy);
+	}
+
+	provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(provider)) {
+		dev_err(dev, "failed to register phy provider\n");
+		return PTR_ERR(provider);
+	}
+
+	pcie->dev = dev;
+	phy_set_drvdata(phy, pcie);
+	platform_set_drvdata(pdev, pcie);
+
+	return 0;
+}
+
+static int qcom_pcie_phy_remove(struct platform_device *pdev)
+{
+	struct qcom_pcie_phy *pcie = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(pcie->clk);
+
+	return 0;
+}
+
+static const struct of_device_id qcom_pcie_phy_of_match[] = {
+	{ .compatible = "qcom,pcie-phy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, qcom_pcie_phy_of_match);
+
+static struct platform_driver qcom_pcie_phy_driver = {
+	.probe = qcom_pcie_phy_probe,
+	.remove = qcom_pcie_phy_remove,
+	.driver = {
+		.name = "pcie-phy",
+		.of_match_table = qcom_pcie_phy_of_match,
+	}
+};
+module_platform_driver(qcom_pcie_phy_driver);
+
+MODULE_AUTHOR("Stanimir Varbanov <svarbanov@mm-sol.com>");
+MODULE_DESCRIPTION("QCOM PCIe PHY driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:pcie-phy");
-- 
1.7.0.4

