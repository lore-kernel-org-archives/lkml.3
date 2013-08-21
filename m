Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3HUNcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:32:02 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49255 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab3HUNbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:31:01 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v5 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers for DW PHY's
Date: Wed, 21 Aug 2013 16:29:45 +0300
Message-Id: <1377091786-5613-3-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377091786-5613-1-git-send-email-iivanov@mm-sol.com>
References: <1377091786-5613-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

These drivers handles control and configuration of the HS
and SS USB PHY transceivers. They are part of the driver
which manage Synopsys DesignWare USB3 controller stack
inside Qualcomm SoC's.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/Kconfig         |   11 ++
 drivers/usb/phy/Makefile        |    2 +
 drivers/usb/phy/phy-msm-dw-hs.c |  327 ++++++++++++++++++++++++++++++++++
 drivers/usb/phy/phy-msm-dw-ss.c |  374 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 714 insertions(+)
 create mode 100644 drivers/usb/phy/phy-msm-dw-hs.c
 create mode 100644 drivers/usb/phy/phy-msm-dw-ss.c

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index d5589f9..bbb2d0e 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -214,6 +214,17 @@ config USB_RCAR_PHY
 	  To compile this driver as a module, choose M here: the
 	  module will be called phy-rcar-usb.
 
+config USB_MSM_DW_PHYS
+	tristate "Qualcomm USB controller DW PHY's wrappers support"
+	depends on (USB || USB_GADGET) && ARCH_MSM
+	select USB_PHY
+	help
+	  Enable this to support the DW USB PHY transceivers on MSM chips
+	  with DWC3 USB core. It handles PHY initialization, clock
+	  management required after resetting the hardware and power
+	  management. This driver is required even for peripheral only or
+	  host only mode configurations.
+
 config USB_ULPI
 	bool "Generic ULPI Transceiver Driver"
 	depends on ARM
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 2135e85..4813eb5 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -26,6 +26,8 @@ obj-$(CONFIG_USB_EHCI_TEGRA)		+= phy-tegra-usb.o
 obj-$(CONFIG_USB_GPIO_VBUS)		+= phy-gpio-vbus-usb.o
 obj-$(CONFIG_USB_ISP1301)		+= phy-isp1301.o
 obj-$(CONFIG_USB_MSM_OTG)		+= phy-msm-usb.o
+obj-$(CONFIG_USB_MSM_DW_PHYS)		+= phy-msm-dw-hs.o
+obj-$(CONFIG_USB_MSM_DW_PHYS)		+= phy-msm-dw-ss.o
 obj-$(CONFIG_USB_MV_OTG)		+= phy-mv-usb.o
 obj-$(CONFIG_USB_MXS_PHY)		+= phy-mxs-usb.o
 obj-$(CONFIG_USB_RCAR_PHY)		+= phy-rcar-usb.o
diff --git a/drivers/usb/phy/phy-msm-dw-hs.c b/drivers/usb/phy/phy-msm-dw-hs.c
new file mode 100644
index 0000000..52994d2
--- /dev/null
+++ b/drivers/usb/phy/phy-msm-dw-hs.c
@@ -0,0 +1,327 @@
+/* Copyright (c) 2013, Code Aurora Forum. All rights reserved.
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
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/usb/phy.h>
+
+/**
+ *  USB QSCRATCH Hardware registers
+ */
+#define QSCRATCH_CTRL_REG		(0x04)
+#define QSCRATCH_GENERAL_CFG		(0x08)
+#define PHY_CTRL_REG			(0x10)
+#define PARAMETER_OVERRIDE_X_REG	(0x14)
+#define CHARGING_DET_CTRL_REG		(0x18)
+#define CHARGING_DET_OUTPUT_REG		(0x1c)
+#define ALT_INTERRUPT_EN_REG		(0x20)
+#define PHY_IRQ_STAT_REG		(0x24)
+#define CGCTL_REG			(0x28)
+
+#define PHY_3P3_VOL_MIN			3050000 /* uV */
+#define PHY_3P3_VOL_MAX			3300000 /* uV */
+#define PHY_3P3_HPM_LOAD		16000	/* uA */
+
+#define PHY_1P8_VOL_MIN			1800000 /* uV */
+#define PHY_1P8_VOL_MAX			1800000 /* uV */
+#define PHY_1P8_HPM_LOAD		19000	/* uA */
+
+/* TODO: these are suspicious */
+#define USB_VDDCX_NO			1	/* uV */
+#define USB_VDDCX_MIN			5	/* uV */
+#define USB_VDDCX_MAX			7	/* uV */
+
+struct msm_dw_hs_phy {
+	struct usb_phy		phy;
+	void __iomem		*base;
+	struct device		*dev;
+
+	struct clk		*xo_clk;
+	struct clk		*sleep_a_clk;
+
+	struct regulator	*v3p3;
+	struct regulator	*v1p8;
+	struct regulator	*vddcx;
+	struct regulator	*vbus;
+};
+
+#define	phy_to_dw_phy(x)	container_of((x), struct msm_dw_hs_phy, phy)
+
+
+/**
+ * Write register.
+ *
+ * @base - MSM DWC3 PHY base virtual address.
+ * @offset - register offset.
+ * @val - value to write.
+ */
+static inline void msm_dw_hs_write(void __iomem *base, u32 offset, u32 val)
+{
+	iowrite32(val, base + offset);
+}
+
+/**
+ * Write register and read back masked value to confirm it is written
+ *
+ * @base - MSM DWC3 PHY base virtual address.
+ * @offset - register offset.
+ * @mask - register bitmask specifying what should be updated
+ * @val - value to write.
+ */
+static inline void msm_dw_hs_write_readback(void __iomem *base, u32 offset,
+					    const u32 mask, u32 val)
+{
+	u32 write_val, tmp = ioread32(base + offset);
+
+	tmp &= ~mask;		/* retain other bits */
+	write_val = tmp | val;
+
+	iowrite32(write_val, base + offset);
+
+	/* Read back to see if val was written */
+	tmp = ioread32(base + offset);
+	tmp &= mask;		/* clear other bits */
+
+	if (tmp != val)
+		pr_err("write: %x to QSCRATCH: %x FAILED\n", val, offset);
+}
+
+static void msm_dw_hs_phy_shutdown(struct usb_phy *x)
+{
+	struct msm_dw_hs_phy *phy = phy_to_dw_phy(x);
+	int ret;
+
+	ret = regulator_set_voltage(phy->v3p3, 0, PHY_3P3_VOL_MAX);
+	if (ret)
+		dev_err(phy->dev, "cannot set voltage for v3p3\n");
+
+	ret = regulator_set_voltage(phy->v1p8, 0, PHY_1P8_VOL_MAX);
+	if (ret)
+		dev_err(phy->dev, "cannot set voltage for v1p8\n");
+
+	ret = regulator_disable(phy->v1p8);
+	if (ret)
+		dev_err(phy->dev, "cannot disable v1p8\n");
+
+	ret = regulator_disable(phy->v3p3);
+	if (ret)
+		dev_err(phy->dev, "cannot disable v3p3\n");
+
+	ret = regulator_set_voltage(phy->vddcx, USB_VDDCX_NO, USB_VDDCX_MAX);
+	if (ret)
+		dev_err(phy->dev, "cannot set voltage for vddcx\n");
+
+	ret = regulator_disable(phy->vddcx);
+	if (ret)
+		dev_err(phy->dev, "cannot enable vddcx\n");
+
+	clk_disable_unprepare(phy->sleep_a_clk);
+}
+
+static int msm_dw_hs_phy_init(struct usb_phy *x)
+{
+	struct msm_dw_hs_phy	*phy = phy_to_dw_phy(x);
+	int ret;
+
+	clk_prepare_enable(phy->sleep_a_clk);
+
+	ret = regulator_set_voltage(phy->vddcx, USB_VDDCX_MIN, USB_VDDCX_MAX);
+	if (ret) {
+		dev_err(phy->dev, "cannot set voltage for vddcx\n");
+		return ret;
+	}
+
+	ret = regulator_enable(phy->vddcx);
+	if (ret) {
+		dev_err(phy->dev, "cannot enable vddcx\n");
+		return ret;
+	}
+
+	ret = regulator_set_voltage(phy->v3p3, PHY_3P3_VOL_MIN,
+				    PHY_3P3_VOL_MAX);
+	if (ret) {
+		dev_err(phy->dev, "cannot set voltage for v3p3\n");
+		return ret;
+	}
+
+	ret = regulator_set_voltage(phy->v1p8, PHY_1P8_VOL_MIN,
+				    PHY_1P8_VOL_MAX);
+	if (ret) {
+		dev_err(phy->dev, "cannot set voltage for v1p8\n");
+		return ret;
+	}
+
+	ret = regulator_set_optimum_mode(phy->v1p8, PHY_1P8_HPM_LOAD);
+	if (ret < 0) {
+		dev_err(phy->dev, "cannot set HPM of regulator v1p8\n");
+		return ret;
+	}
+
+	ret = regulator_enable(phy->v1p8);
+	if (ret) {
+		dev_err(phy->dev, "cannot enable v1p8\n");
+		return ret;
+	}
+
+	ret = regulator_set_optimum_mode(phy->v3p3, PHY_3P3_HPM_LOAD);
+	if (ret < 0) {
+		dev_err(phy->dev, "cannot set HPM of regulator v3p3\n");
+		return ret;
+	}
+
+	ret = regulator_enable(phy->v3p3);
+	if (ret) {
+		dev_err(phy->dev, "cannot enable v3p3\n");
+		return ret;
+	}
+
+	/*
+	 * HSPHY Initialization: Enable UTMI clock and clamp enable HVINTs,
+	 * and disable RETENTION (power-on default is ENABLED)
+	 */
+	msm_dw_hs_write(phy->base, PHY_CTRL_REG, 0x5220bb2);
+	usleep_range(2000, 2200);
+
+	/*
+	 * write HSPHY init value to QSCRATCH reg to set HSPHY parameters like
+	 * VBUS valid threshold, disconnect valid threshold, DC voltage level,
+	 * preempasis and rise/fall time.
+	 */
+	msm_dw_hs_write_readback(phy->base, PARAMETER_OVERRIDE_X_REG,
+				0x03ffffff, 0x00d191a4);
+
+	/* Disable (bypass) VBUS and ID filters */
+	msm_dw_hs_write(phy->base, QSCRATCH_GENERAL_CFG, 0x78);
+
+	return 0;
+}
+
+static int msm_dw_hs_phy_set_vbus(struct usb_phy *x, int on)
+{
+	struct msm_dw_hs_phy	*phy = phy_to_dw_phy(x);
+	int ret;
+
+	if (on)
+		ret = regulator_enable(phy->vbus);
+	else
+		ret = regulator_disable(phy->vbus);
+
+	if (ret)
+		dev_err(x->dev, "Cannot %s Vbus\n", on ? "set" : "off");
+	return ret;
+}
+
+static int msm_dw_hs_probe(struct platform_device *pdev)
+{
+	struct msm_dw_hs_phy	*phy;
+	struct resource		*res;
+	void __iomem		*base;
+
+	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, phy);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	phy->vddcx = devm_regulator_get(&pdev->dev, "vddcx");
+	if (IS_ERR(phy->vddcx)) {
+		dev_dbg(&pdev->dev, "cannot get vddcx\n");
+		return  PTR_ERR(phy->vddcx);
+	}
+
+	phy->v3p3 = devm_regulator_get(phy->dev, "v3p3");
+	if (IS_ERR(phy->v3p3)) {
+		dev_dbg(phy->dev, "cannot get v3p3\n");
+		return PTR_ERR(phy->v3p3);
+	}
+
+	phy->v1p8 = devm_regulator_get(phy->dev, "v1p8");
+	if (IS_ERR(phy->v1p8)) {
+		dev_dbg(phy->dev, "cannot get v1p8\n");
+		return PTR_ERR(phy->v1p8);
+	}
+
+	phy->vbus = devm_regulator_get(&pdev->dev, "vbus");
+	if (IS_ERR(phy->vbus)) {
+		dev_dbg(phy->dev, "Failed to get vbus\n");
+		return PTR_ERR(phy->vbus);
+	}
+
+	phy->xo_clk = devm_clk_get(&pdev->dev, "xo");
+	if (IS_ERR(phy->xo_clk)) {
+		dev_dbg(&pdev->dev, "cannot get TCXO buffer handle\n");
+		return PTR_ERR(phy->xo_clk);
+	}
+
+	phy->sleep_a_clk = devm_clk_get(&pdev->dev, "sleep_a");
+	if (IS_ERR(phy->sleep_a_clk)) {
+		dev_dbg(&pdev->dev, "failed to get sleep_a clock\n");
+		return PTR_ERR(phy->sleep_a_clk);
+	}
+
+	clk_prepare_enable(phy->xo_clk);
+
+	phy->dev		= &pdev->dev;
+	phy->base		= base;
+	phy->phy.dev		= phy->dev;
+	phy->phy.label		= "msm-dw-hsphy";
+	phy->phy.init		= msm_dw_hs_phy_init;
+	phy->phy.shutdown	= msm_dw_hs_phy_shutdown;
+	phy->phy.set_vbus	= msm_dw_hs_phy_set_vbus;
+	phy->phy.type		= USB_PHY_TYPE_USB2;
+	phy->phy.state          = OTG_STATE_UNDEFINED;
+
+	usb_add_phy_dev(&phy->phy);
+
+	return 0;
+}
+
+static int msm_dw_hs_remove(struct platform_device *pdev)
+{
+	struct msm_dw_hs_phy *phy = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(phy->xo_clk);
+	usb_remove_phy(&phy->phy);
+	return 0;
+}
+
+static const struct of_device_id msm_dw_hs_id_table[] = {
+	{ .compatible = "qcom,dw-hsphy" },
+	{ /* Sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, msm_dw_hs_id_table);
+
+static struct platform_driver msm_dw_hs_driver = {
+	.probe		= msm_dw_hs_probe,
+	.remove		= msm_dw_hs_remove,
+	.driver		= {
+		.name	= "msm-dw-hsphy",
+		.owner	= THIS_MODULE,
+		.of_match_table = msm_dw_hs_id_table,
+	},
+};
+
+module_platform_driver(msm_dw_hs_driver);
+
+MODULE_ALIAS("platform:msm_dw_hsphy");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("DesignWare USB3 MSM HS-PHY driver");
diff --git a/drivers/usb/phy/phy-msm-dw-ss.c b/drivers/usb/phy/phy-msm-dw-ss.c
new file mode 100644
index 0000000..ffb7481
--- /dev/null
+++ b/drivers/usb/phy/phy-msm-dw-ss.c
@@ -0,0 +1,374 @@
+/* Copyright (c) 2013, Code Aurora Forum. All rights reserved.
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
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/usb/phy.h>
+
+/**
+ *  USB QSCRATCH Hardware registers
+ */
+#define PHY_CTRL_REG			(0x00)
+#define PHY_PARAM_CTRL_1		(0x04)
+#define PHY_PARAM_CTRL_2		(0x08)
+#define CR_PROTOCOL_DATA_IN_REG		(0x0c)
+#define CR_PROTOCOL_DATA_OUT_REG	(0x10)
+#define CR_PROTOCOL_CAP_ADDR_REG	(0x14)
+#define CR_PROTOCOL_CAP_DATA_REG	(0x18)
+#define CR_PROTOCOL_READ_REG		(0x1c)
+#define CR_PROTOCOL_WRITE_REG		(0x20)
+
+#define PHY_1P8_VOL_MIN			1800000 /* uV */
+#define PHY_1P8_VOL_MAX			1800000 /* uV */
+#define PHY_1P8_HPM_LOAD		23000	/* uA */
+
+/* TODO: these are suspicious */
+#define USB_VDDCX_NO			1	/* uV */
+#define USB_VDDCX_MIN			5	/* uV */
+#define USB_VDDCX_MAX			7	/* uV */
+
+struct msm_dw_ss_phy {
+	struct usb_phy		phy;
+	void __iomem		*base;
+	struct device		*dev;
+
+	struct regulator	*v1p8;
+	struct regulator	*vddcx;
+
+	struct clk		*xo_clk;
+	struct clk		*ref_clk;
+};
+
+#define	phy_to_dw_phy(x)	container_of((x), struct msm_dw_ss_phy, phy)
+
+
+/**
+ * Write register
+ *
+ * @base - MSM DWC3 PHY base virtual address.
+ * @offset - register offset.
+ * @val - value to write.
+ */
+static inline void msm_dw_ss_write(void __iomem *base, u32 offset, u32 val)
+{
+	iowrite32(val, base + offset);
+}
+
+/**
+ * Write register and read back masked value to confirm it is written
+ *
+ * @base - MSM DWC3 PHY base virtual address.
+ * @offset - register offset.
+ * @mask - register bitmask specifying what should be updated
+ * @val - value to write.
+ */
+static inline void msm_dw_ss_write_readback(void __iomem *base, u32 offset,
+					    const u32 mask, u32 val)
+{
+	u32 write_val, tmp = ioread32(base + offset);
+
+	tmp &= ~mask;		/* retain other bits */
+	write_val = tmp | val;
+
+	iowrite32(write_val, base + offset);
+
+	/* Read back to see if val was written */
+	tmp = ioread32(base + offset);
+	tmp &= mask;		/* clear other bits */
+
+	if (tmp != val)
+		pr_err("write: %x to QSCRATCH: %x FAILED\n", val, offset);
+}
+
+/**
+ * Write SSPHY register
+ *
+ * @base - MSM DWC3 PHY base virtual address.
+ * @addr - SSPHY address to write.
+ * @val - value to write.
+ */
+static void msm_dw_ss_write_phycreg(void __iomem *base, u32 addr, u32 val)
+{
+	iowrite32(addr, base + CR_PROTOCOL_DATA_IN_REG);
+	iowrite32(0x1, base + CR_PROTOCOL_CAP_ADDR_REG);
+	while (ioread32(base + CR_PROTOCOL_CAP_ADDR_REG))
+		cpu_relax();
+
+	iowrite32(val, base + CR_PROTOCOL_DATA_IN_REG);
+	iowrite32(0x1, base + CR_PROTOCOL_CAP_DATA_REG);
+	while (ioread32(base + CR_PROTOCOL_CAP_DATA_REG))
+		cpu_relax();
+
+	iowrite32(0x1, base + CR_PROTOCOL_WRITE_REG);
+	while (ioread32(base + CR_PROTOCOL_WRITE_REG))
+		cpu_relax();
+}
+
+/**
+ * Read SSPHY register.
+ *
+ * @base - MSM DWC3 PHY base virtual address.
+ * @addr - SSPHY address to read.
+ */
+static u32 msm_dw_ss_read_phycreg(void __iomem *base, u32 addr)
+{
+	bool first_read = true;
+
+	iowrite32(addr, base + CR_PROTOCOL_DATA_IN_REG);
+	iowrite32(0x1, base + CR_PROTOCOL_CAP_ADDR_REG);
+	while (ioread32(base + CR_PROTOCOL_CAP_ADDR_REG))
+		cpu_relax();
+
+	/*
+	 * Due to hardware bug, first read of SSPHY register might be
+	 * incorrect. Hence as workaround, SW should perform SSPHY register
+	 * read twice, but use only second read and ignore first read.
+	 */
+retry:
+	iowrite32(0x1, base + CR_PROTOCOL_READ_REG);
+	while (ioread32(base + CR_PROTOCOL_READ_REG))
+		cpu_relax();
+
+	if (first_read) {
+		ioread32(base + CR_PROTOCOL_DATA_OUT_REG);
+		first_read = false;
+		goto retry;
+	}
+
+	return ioread32(base + CR_PROTOCOL_DATA_OUT_REG);
+}
+
+static void msm_dw_ss_phy_shutdown(struct usb_phy *x)
+{
+	struct msm_dw_ss_phy *phy = phy_to_dw_phy(x);
+	int ret;
+
+	/* Sequence to put SSPHY in low power state:
+	 * 1. Clear REF_PHY_EN in PHY_CTRL_REG
+	 * 2. Clear REF_USE_PAD in PHY_CTRL_REG
+	 * 3. Set TEST_POWERED_DOWN in PHY_CTRL_REG to enable PHY retention
+	 * 4. Disable SSPHY ref clk
+	 */
+	msm_dw_ss_write_readback(phy->base, PHY_CTRL_REG, (1 << 8), 0x0);
+	msm_dw_ss_write_readback(phy->base, PHY_CTRL_REG, (1 << 28), 0x0);
+	msm_dw_ss_write_readback(phy->base, PHY_CTRL_REG,
+				    (1 << 26), (1 << 26));
+
+	usleep_range(1000, 1200);
+	clk_disable_unprepare(phy->ref_clk);
+
+	ret = regulator_set_voltage(phy->vddcx, USB_VDDCX_NO, USB_VDDCX_MAX);
+	if (ret)
+		dev_err(phy->dev, "cannot set voltage for vddcx\n");
+
+	regulator_disable(phy->vddcx);
+
+	ret = regulator_set_voltage(phy->v1p8, 0, PHY_1P8_VOL_MAX);
+	if (ret)
+		dev_err(phy->dev, "cannot set v1p8\n");
+
+	regulator_disable(phy->v1p8);
+}
+
+static int msm_dw_ss_phy_init(struct usb_phy *x)
+{
+	struct msm_dw_ss_phy *phy = phy_to_dw_phy(x);
+	u32 data = 0;
+	int ret;
+
+	ret = regulator_set_voltage(phy->vddcx, USB_VDDCX_MIN, USB_VDDCX_MAX);
+	if (ret) {
+		dev_err(phy->dev, "cannot set voltage for vddcx\n");
+		return ret;
+	}
+
+	ret = regulator_enable(phy->vddcx);
+	if (ret) {
+		dev_err(phy->dev, "cannot enable vddcx\n");
+		return ret;
+	}
+
+	ret = regulator_set_voltage(phy->v1p8, PHY_1P8_VOL_MIN,
+				    PHY_1P8_VOL_MAX);
+	if (ret) {
+		regulator_disable(phy->vddcx);
+		dev_err(phy->dev, "cannot set v1p8\n");
+		return ret;
+	}
+
+	ret = regulator_enable(phy->v1p8);
+	if (ret) {
+		regulator_disable(phy->vddcx);
+		dev_err(phy->dev, "cannot enable v1p8\n");
+		return ret;
+	}
+
+	clk_prepare_enable(phy->ref_clk);
+	usleep_range(1000, 1200);
+
+	/* SSPHY Initialization: Use ref_clk from pads and set its parameters */
+	msm_dw_ss_write(phy->base, PHY_CTRL_REG, 0x10210002);
+	msleep(30);
+	/* Assert SSPHY reset */
+	msm_dw_ss_write(phy->base, PHY_CTRL_REG, 0x10210082);
+	usleep_range(2000, 2200);
+	/* De-assert SSPHY reset - power and ref_clock must be ON */
+	msm_dw_ss_write(phy->base, PHY_CTRL_REG, 0x10210002);
+	usleep_range(2000, 2200);
+	/* Ref clock must be stable now, enable ref clock for HS mode */
+	msm_dw_ss_write(phy->base, PHY_CTRL_REG, 0x10210102);
+	usleep_range(2000, 2200);
+
+	/*
+	 * WORKAROUND: There is SSPHY suspend bug due to which USB enumerates
+	 * in HS mode instead of SS mode. Workaround it by asserting
+	 * LANE0.TX_ALT_BLOCK.EN_ALT_BUS to enable TX to use alt bus mode
+	 */
+	data = msm_dw_ss_read_phycreg(phy->base, 0x102d);
+	data |= (1 << 7);
+	msm_dw_ss_write_phycreg(phy->base, 0x102D, data);
+
+	data = msm_dw_ss_read_phycreg(phy->base, 0x1010);
+	data &= ~0xff0;
+	data |= 0x20;
+	msm_dw_ss_write_phycreg(phy->base, 0x1010, data);
+
+	/*
+	 * Fix RX Equalization setting as follows
+	 * LANE0.RX_OVRD_IN_HI. RX_EQ_EN set to 0
+	 * LANE0.RX_OVRD_IN_HI.RX_EQ_EN_OVRD set to 1
+	 * LANE0.RX_OVRD_IN_HI.RX_EQ set to 3
+	 * LANE0.RX_OVRD_IN_HI.RX_EQ_OVRD set to 1
+	 */
+	data = msm_dw_ss_read_phycreg(phy->base, 0x1006);
+	data &= ~(1 << 6);
+	data |= (1 << 7);
+	data &= ~(0x7 << 8);
+	data |= (0x3 << 8);
+	data |= (0x1 << 11);
+	msm_dw_ss_write_phycreg(phy->base, 0x1006, data);
+
+	/*
+	 * Set EQ and TX launch amplitudes as follows
+	 * LANE0.TX_OVRD_DRV_LO.PREEMPH set to 22
+	 * LANE0.TX_OVRD_DRV_LO.AMPLITUDE set to 127
+	 * LANE0.TX_OVRD_DRV_LO.EN set to 1.
+	 */
+	data = msm_dw_ss_read_phycreg(phy->base, 0x1002);
+	data &= ~0x3f80;
+	data |= (0x16 << 7);
+	data &= ~0x7f;
+	data |= (0x7f | (1 << 14));
+	msm_dw_ss_write_phycreg(phy->base, 0x1002, data);
+
+	/*
+	 * Set the QSCRATCH PHY_PARAM_CTRL1 parameters as follows
+	 * TX_FULL_SWING [26:20] amplitude to 127
+	 * TX_DEEMPH_3_5DB [13:8] to 22
+	 * LOS_BIAS [2:0] to 0x5
+	 */
+	msm_dw_ss_write_readback(phy->base, PHY_PARAM_CTRL_1,
+				   0x07f03f07, 0x07f01605);
+	return 0;
+}
+
+static int msm_dw_ss_probe(struct platform_device *pdev)
+{
+	struct msm_dw_ss_phy	*phy;
+	struct resource		*res;
+	void __iomem		*base;
+
+	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, phy);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	phy->vddcx = devm_regulator_get(phy->dev, "vddcx");
+	if (IS_ERR(phy->vddcx)) {
+		dev_dbg(&pdev->dev, "cannot get vddcx\n");
+		return  PTR_ERR(phy->vddcx);
+	}
+
+	phy->v1p8 = devm_regulator_get(phy->dev, "v1p8");
+	if (IS_ERR(phy->v1p8)) {
+		dev_dbg(&pdev->dev, "cannot get v1p8\n");
+		return  PTR_ERR(phy->v1p8);
+	}
+
+	phy->xo_clk = devm_clk_get(&pdev->dev, "xo");
+	if (IS_ERR(phy->xo_clk)) {
+		dev_dbg(&pdev->dev, "cannot get TCXO buffer handle\n");
+		return PTR_ERR(phy->xo_clk);
+	}
+
+	phy->ref_clk = devm_clk_get(&pdev->dev, "ref");
+	if (IS_ERR(phy->ref_clk)) {
+		dev_dbg(&pdev->dev, "cannot get ref clock handle\n");
+		return PTR_ERR(phy->ref_clk);
+	}
+
+	clk_prepare_enable(phy->xo_clk);
+
+	phy->dev		= &pdev->dev;
+	phy->base		= base;
+	phy->phy.dev		= phy->dev;
+	phy->phy.label		= "msm-dw-ssphy";
+	phy->phy.init		= msm_dw_ss_phy_init;
+	phy->phy.shutdown       = msm_dw_ss_phy_shutdown;
+	phy->phy.type		= USB_PHY_TYPE_USB3;
+
+	usb_add_phy_dev(&phy->phy);
+
+	return 0;
+}
+
+static int msm_dw_ss_remove(struct platform_device *pdev)
+{
+	struct msm_dw_ss_phy *phy = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(phy->xo_clk);
+	usb_remove_phy(&phy->phy);
+	return 0;
+}
+
+static const struct of_device_id msm_dw_ss_id_table[] = {
+	{ .compatible = "qcom,dw-ssphy" },
+	{ /* Sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, msm_dw_ss_id_table);
+
+static struct platform_driver msm_dw_ss_driver = {
+	.probe		= msm_dw_ss_probe,
+	.remove		= msm_dw_ss_remove,
+	.driver		= {
+		.name	= "msm-dw-ssphy",
+		.owner	= THIS_MODULE,
+		.of_match_table = msm_dw_ss_id_table,
+	},
+};
+
+module_platform_driver(msm_dw_ss_driver);
+
+MODULE_ALIAS("platform:msm_dw_ssphy");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("DesignWare USB3 MSM SS-PHY driver");
-- 
1.7.9.5

