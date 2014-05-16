Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbaEPNEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:04:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51864 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbaEPND2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:03:28 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/11] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Fri, 16 May 2014 18:33:02 +0530
Message-ID: <1400245387-14445-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400245387-14445-1-git-send-email-kishon@ti.com>
References: <1400245387-14445-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Gautam <gautam.vivek@samsung.com>

Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
The new driver uses the generic PHY framework and will interact
with DWC3 controller present on Exynos5 series of SoCs.

Also, created a new header file in linux/mfd/syscon/ for
Exynos5 SoCs and put the required PMU offset definitions
for the basic available PHYs.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig                    |   11 +
 drivers/phy/Makefile                   |    1 +
 drivers/phy/phy-exynos5-usbdrd.c       |  644 ++++++++++++++++++++++++++++++++
 include/linux/mfd/syscon/exynos5-pmu.h |   44 +++
 4 files changed, 700 insertions(+)
 create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
 create mode 100644 include/linux/mfd/syscon/exynos5-pmu.h

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 071b763..16a2f06 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -160,6 +160,17 @@ config PHY_EXYNOS5250_USB2
 	  particular SoC is compiled in the driver. In case of Exynos 5250 four
 	  phys are available - device, host, HSIC0 and HSIC.
 
+config PHY_EXYNOS5_USBDRD
+	tristate "Exynos5 SoC series USB DRD PHY driver"
+	depends on ARCH_EXYNOS5 && OF
+	depends on HAS_IOMEM
+	select GENERIC_PHY
+	select MFD_SYSCON
+	help
+	  Enable USB DRD PHY support for Exynos 5 SoC series.
+	  This driver provides PHY interface for USB 3.0 DRD controller
+	  present on Exynos5 SoC series.
+
 config PHY_XGENE
 	tristate "APM X-Gene 15Gbps PHY support"
 	depends on HAS_IOMEM && OF && (ARM64 || COMPILE_TEST)
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 7728518..b4f1d57 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -18,4 +18,5 @@ phy-exynos-usb2-y			+= phy-samsung-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
+obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
new file mode 100644
index 0000000..8fcdd94
--- /dev/null
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -0,0 +1,644 @@
+/*
+ * Samsung EXYNOS5 SoC series USB DRD PHY driver
+ *
+ * Phy provider for USB 3.0 DRD controller on Exynos5 SoC series
+ *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Author: Vivek Gautam <gautam.vivek@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mfd/syscon/exynos5-pmu.h>
+#include <linux/regmap.h>
+
+/* Exynos USB PHY registers */
+#define EXYNOS5_FSEL_9MHZ6		0x0
+#define EXYNOS5_FSEL_10MHZ		0x1
+#define EXYNOS5_FSEL_12MHZ		0x2
+#define EXYNOS5_FSEL_19MHZ2		0x3
+#define EXYNOS5_FSEL_20MHZ		0x4
+#define EXYNOS5_FSEL_24MHZ		0x5
+#define EXYNOS5_FSEL_50MHZ		0x7
+
+/* EXYNOS5: USB 3.0 DRD PHY registers */
+#define EXYNOS5_DRD_LINKSYSTEM			0x04
+
+#define LINKSYSTEM_FLADJ_MASK			(0x3f << 1)
+#define LINKSYSTEM_FLADJ(_x)			((_x) << 1)
+#define LINKSYSTEM_XHCI_VERSION_CONTROL		BIT(27)
+
+#define EXYNOS5_DRD_PHYUTMI			0x08
+
+#define PHYUTMI_OTGDISABLE			BIT(6)
+#define PHYUTMI_FORCESUSPEND			BIT(1)
+#define PHYUTMI_FORCESLEEP			BIT(0)
+
+#define EXYNOS5_DRD_PHYPIPE			0x0c
+
+#define EXYNOS5_DRD_PHYCLKRST			0x10
+
+#define PHYCLKRST_EN_UTMISUSPEND		BIT(31)
+
+#define PHYCLKRST_SSC_REFCLKSEL_MASK		(0xff << 23)
+#define PHYCLKRST_SSC_REFCLKSEL(_x)		((_x) << 23)
+
+#define PHYCLKRST_SSC_RANGE_MASK		(0x03 << 21)
+#define PHYCLKRST_SSC_RANGE(_x)			((_x) << 21)
+
+#define PHYCLKRST_SSC_EN			BIT(20)
+#define PHYCLKRST_REF_SSP_EN			BIT(19)
+#define PHYCLKRST_REF_CLKDIV2			BIT(18)
+
+#define PHYCLKRST_MPLL_MULTIPLIER_MASK		(0x7f << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF	(0x19 << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_50M_REF	(0x32 << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF	(0x68 << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF	(0x7d << 11)
+#define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF	(0x02 << 11)
+
+#define PHYCLKRST_FSEL_UTMI_MASK		(0x7 << 5)
+#define PHYCLKRST_FSEL_PIPE_MASK		(0x7 << 8)
+#define PHYCLKRST_FSEL(_x)			((_x) << 5)
+#define PHYCLKRST_FSEL_PAD_100MHZ		(0x27 << 5)
+#define PHYCLKRST_FSEL_PAD_24MHZ		(0x2a << 5)
+#define PHYCLKRST_FSEL_PAD_20MHZ		(0x31 << 5)
+#define PHYCLKRST_FSEL_PAD_19_2MHZ		(0x38 << 5)
+
+#define PHYCLKRST_RETENABLEN			BIT(4)
+
+#define PHYCLKRST_REFCLKSEL_MASK		(0x03 << 2)
+#define PHYCLKRST_REFCLKSEL_PAD_REFCLK		(0x2 << 2)
+#define PHYCLKRST_REFCLKSEL_EXT_REFCLK		(0x3 << 2)
+
+#define PHYCLKRST_PORTRESET			BIT(1)
+#define PHYCLKRST_COMMONONN			BIT(0)
+
+#define EXYNOS5_DRD_PHYREG0			0x14
+#define EXYNOS5_DRD_PHYREG1			0x18
+
+#define EXYNOS5_DRD_PHYPARAM0			0x1c
+
+#define PHYPARAM0_REF_USE_PAD			BIT(31)
+#define PHYPARAM0_REF_LOSLEVEL_MASK		(0x1f << 26)
+#define PHYPARAM0_REF_LOSLEVEL			(0x9 << 26)
+
+#define EXYNOS5_DRD_PHYPARAM1			0x20
+
+#define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x1f << 0)
+#define PHYPARAM1_PCS_TXDEEMPH			(0x1c)
+
+#define EXYNOS5_DRD_PHYTERM			0x24
+
+#define EXYNOS5_DRD_PHYTEST			0x28
+
+#define PHYTEST_POWERDOWN_SSP			BIT(3)
+#define PHYTEST_POWERDOWN_HSP			BIT(2)
+
+#define EXYNOS5_DRD_PHYADP			0x2c
+
+#define EXYNOS5_DRD_PHYUTMICLKSEL		0x30
+
+#define PHYUTMICLKSEL_UTMI_CLKSEL		BIT(2)
+
+#define EXYNOS5_DRD_PHYRESUME			0x34
+#define EXYNOS5_DRD_LINKPORT			0x44
+
+#define KHZ	1000
+#define MHZ	(KHZ * KHZ)
+
+enum exynos5_usbdrd_phy_id {
+	EXYNOS5_DRDPHY_UTMI,
+	EXYNOS5_DRDPHY_PIPE3,
+	EXYNOS5_DRDPHYS_NUM,
+};
+
+struct phy_usb_instance;
+struct exynos5_usbdrd_phy;
+
+struct exynos5_usbdrd_phy_config {
+	u32 id;
+	void (*phy_isol)(struct phy_usb_instance *inst, u32 on);
+	void (*phy_init)(struct exynos5_usbdrd_phy *phy_drd);
+	unsigned int (*set_refclk)(struct phy_usb_instance *inst);
+};
+
+struct exynos5_usbdrd_phy_drvdata {
+	const struct exynos5_usbdrd_phy_config *phy_cfg;
+	u32 pmu_offset_usbdrd0_phy;
+	u32 pmu_offset_usbdrd1_phy;
+};
+
+/**
+ * struct exynos5_usbdrd_phy - driver data for USB 3.0 PHY
+ * @dev: pointer to device instance of this platform device
+ * @reg_phy: usb phy controller register memory base
+ * @clk: phy clock for register access
+ * @drv_data: pointer to SoC level driver data structure
+ * @phys[]: array for 'EXYNOS5_DRDPHYS_NUM' number of PHY
+ *	    instances each with its 'phy' and 'phy_cfg'.
+ * @extrefclk: frequency select settings when using 'separate
+ *	       reference clocks' for SS and HS operations
+ * @ref_clk: reference clock to PHY block from which PHY's
+ *	     operational clocks are derived
+ * @ref_rate: rate of above reference clock
+ */
+struct exynos5_usbdrd_phy {
+	struct device *dev;
+	void __iomem *reg_phy;
+	struct clk *clk;
+	const struct exynos5_usbdrd_phy_drvdata *drv_data;
+	struct phy_usb_instance {
+		struct phy *phy;
+		u32 index;
+		struct regmap *reg_pmu;
+		u32 pmu_offset;
+		const struct exynos5_usbdrd_phy_config *phy_cfg;
+	} phys[EXYNOS5_DRDPHYS_NUM];
+	u32 extrefclk;
+	struct clk *ref_clk;
+};
+
+static inline
+struct exynos5_usbdrd_phy *to_usbdrd_phy(struct phy_usb_instance *inst)
+{
+	return container_of((inst), struct exynos5_usbdrd_phy,
+			    phys[(inst)->index]);
+}
+
+/*
+ * exynos5_rate_to_clk() converts the supplied clock rate to the value that
+ * can be written to the phy register.
+ */
+static unsigned int exynos5_rate_to_clk(unsigned long rate, u32 *reg)
+{
+	/* EXYNOS5_FSEL_MASK */
+
+	switch (rate) {
+	case 9600 * KHZ:
+		*reg = EXYNOS5_FSEL_9MHZ6;
+		break;
+	case 10 * MHZ:
+		*reg = EXYNOS5_FSEL_10MHZ;
+		break;
+	case 12 * MHZ:
+		*reg = EXYNOS5_FSEL_12MHZ;
+		break;
+	case 19200 * KHZ:
+		*reg = EXYNOS5_FSEL_19MHZ2;
+		break;
+	case 20 * MHZ:
+		*reg = EXYNOS5_FSEL_20MHZ;
+		break;
+	case 24 * MHZ:
+		*reg = EXYNOS5_FSEL_24MHZ;
+		break;
+	case 50 * MHZ:
+		*reg = EXYNOS5_FSEL_50MHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void exynos5_usbdrd_phy_isol(struct phy_usb_instance *inst,
+						unsigned int on)
+{
+	unsigned int val;
+
+	if (!inst->reg_pmu)
+		return;
+
+	val = on ? 0 : EXYNOS5_PHY_ENABLE;
+
+	regmap_update_bits(inst->reg_pmu, inst->pmu_offset,
+			   EXYNOS5_PHY_ENABLE, val);
+}
+
+/*
+ * Sets the pipe3 phy's clk as EXTREFCLK (XXTI) which is internal clock
+ * from clock core. Further sets multiplier values and spread spectrum
+ * clock settings for SuperSpeed operations.
+ */
+static unsigned int
+exynos5_usbdrd_pipe3_set_refclk(struct phy_usb_instance *inst)
+{
+	static u32 reg;
+	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
+
+	/* restore any previous reference clock settings */
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+
+	/* Use EXTREFCLK as ref clock */
+	reg &= ~PHYCLKRST_REFCLKSEL_MASK;
+	reg |=	PHYCLKRST_REFCLKSEL_EXT_REFCLK;
+
+	/* FSEL settings corresponding to reference clock */
+	reg &= ~PHYCLKRST_FSEL_PIPE_MASK |
+		PHYCLKRST_MPLL_MULTIPLIER_MASK |
+		PHYCLKRST_SSC_REFCLKSEL_MASK;
+	switch (phy_drd->extrefclk) {
+	case EXYNOS5_FSEL_50MHZ:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x00));
+		break;
+	case EXYNOS5_FSEL_24MHZ:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x88));
+		break;
+	case EXYNOS5_FSEL_20MHZ:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x00));
+		break;
+	case EXYNOS5_FSEL_19MHZ2:
+		reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
+			PHYCLKRST_SSC_REFCLKSEL(0x88));
+		break;
+	default:
+		dev_dbg(phy_drd->dev, "unsupported ref clk\n");
+		break;
+	}
+
+	return reg;
+}
+
+/*
+ * Sets the utmi phy's clk as EXTREFCLK (XXTI) which is internal clock
+ * from clock core. Further sets the FSEL values for HighSpeed operations.
+ */
+static unsigned int
+exynos5_usbdrd_utmi_set_refclk(struct phy_usb_instance *inst)
+{
+	static u32 reg;
+	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
+
+	/* restore any previous reference clock settings */
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+
+	reg &= ~PHYCLKRST_REFCLKSEL_MASK;
+	reg |=	PHYCLKRST_REFCLKSEL_EXT_REFCLK;
+
+	reg &= ~PHYCLKRST_FSEL_UTMI_MASK |
+		PHYCLKRST_MPLL_MULTIPLIER_MASK |
+		PHYCLKRST_SSC_REFCLKSEL_MASK;
+	reg |= PHYCLKRST_FSEL(phy_drd->extrefclk);
+
+	return reg;
+}
+
+static void exynos5_usbdrd_pipe3_init(struct exynos5_usbdrd_phy *phy_drd)
+{
+	u32 reg;
+
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYPARAM1);
+	/* Set Tx De-Emphasis level */
+	reg &= ~PHYPARAM1_PCS_TXDEEMPH_MASK;
+	reg |=	PHYPARAM1_PCS_TXDEEMPH;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYPARAM1);
+
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
+	reg &= ~PHYTEST_POWERDOWN_SSP;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
+}
+
+static void exynos5_usbdrd_utmi_init(struct exynos5_usbdrd_phy *phy_drd)
+{
+	u32 reg;
+
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYPARAM0);
+	/* Set Loss-of-Signal Detector sensitivity */
+	reg &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
+	reg |=	PHYPARAM0_REF_LOSLEVEL;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYPARAM0);
+
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYPARAM1);
+	/* Set Tx De-Emphasis level */
+	reg &= ~PHYPARAM1_PCS_TXDEEMPH_MASK;
+	reg |=	PHYPARAM1_PCS_TXDEEMPH;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYPARAM1);
+
+	/* UTMI Power Control */
+	writel(PHYUTMI_OTGDISABLE, phy_drd->reg_phy + EXYNOS5_DRD_PHYUTMI);
+
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
+	reg &= ~PHYTEST_POWERDOWN_HSP;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
+}
+
+static int exynos5_usbdrd_phy_init(struct phy *phy)
+{
+	int ret;
+	u32 reg;
+	struct phy_usb_instance *inst = phy_get_drvdata(phy);
+	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
+
+	ret = clk_prepare_enable(phy_drd->clk);
+	if (ret)
+		return ret;
+
+	/* Reset USB 3.0 PHY */
+	writel(0x0, phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
+	writel(0x0, phy_drd->reg_phy + EXYNOS5_DRD_PHYRESUME);
+
+	/*
+	 * Setting the Frame length Adj value[6:1] to default 0x20
+	 * See xHCI 1.0 spec, 5.2.4
+	 */
+	reg =	LINKSYSTEM_XHCI_VERSION_CONTROL |
+		LINKSYSTEM_FLADJ(0x20);
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_LINKSYSTEM);
+
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYPARAM0);
+	/* Select PHY CLK source */
+	reg &= ~PHYPARAM0_REF_USE_PAD;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYPARAM0);
+
+	/* This bit must be set for both HS and SS operations */
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYUTMICLKSEL);
+	reg |= PHYUTMICLKSEL_UTMI_CLKSEL;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYUTMICLKSEL);
+
+	/* UTMI or PIPE3 specific init */
+	inst->phy_cfg->phy_init(phy_drd);
+
+	/* reference clock settings */
+	reg = inst->phy_cfg->set_refclk(inst);
+
+		/* Digital power supply in normal operating mode */
+	reg |=	PHYCLKRST_RETENABLEN |
+		/* Enable ref clock for SS function */
+		PHYCLKRST_REF_SSP_EN |
+		/* Enable spread spectrum */
+		PHYCLKRST_SSC_EN |
+		/* Power down HS Bias and PLL blocks in suspend mode */
+		PHYCLKRST_COMMONONN |
+		/* Reset the port */
+		PHYCLKRST_PORTRESET;
+
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+
+	udelay(10);
+
+	reg &= ~PHYCLKRST_PORTRESET;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+
+	clk_disable_unprepare(phy_drd->clk);
+
+	return 0;
+}
+
+static int exynos5_usbdrd_phy_exit(struct phy *phy)
+{
+	int ret;
+	u32 reg;
+	struct phy_usb_instance *inst = phy_get_drvdata(phy);
+	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
+
+	ret = clk_prepare_enable(phy_drd->clk);
+	if (ret)
+		return ret;
+
+	reg =	PHYUTMI_OTGDISABLE |
+		PHYUTMI_FORCESUSPEND |
+		PHYUTMI_FORCESLEEP;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYUTMI);
+
+	/* Resetting the PHYCLKRST enable bits to reduce leakage current */
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+	reg &= ~(PHYCLKRST_REF_SSP_EN |
+		 PHYCLKRST_SSC_EN |
+		 PHYCLKRST_COMMONONN);
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYCLKRST);
+
+	/* Control PHYTEST to remove leakage current */
+	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
+	reg |=	PHYTEST_POWERDOWN_SSP |
+		PHYTEST_POWERDOWN_HSP;
+	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
+
+	clk_disable_unprepare(phy_drd->clk);
+
+	return 0;
+}
+
+static int exynos5_usbdrd_phy_power_on(struct phy *phy)
+{
+	struct phy_usb_instance *inst = phy_get_drvdata(phy);
+	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
+
+	dev_dbg(phy_drd->dev, "Request to power_on usbdrd_phy phy\n");
+
+	clk_prepare_enable(phy_drd->ref_clk);
+
+	/* Power-on PHY*/
+	inst->phy_cfg->phy_isol(inst, 0);
+
+	return 0;
+}
+
+static int exynos5_usbdrd_phy_power_off(struct phy *phy)
+{
+	struct phy_usb_instance *inst = phy_get_drvdata(phy);
+	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
+
+	dev_dbg(phy_drd->dev, "Request to power_off usbdrd_phy phy\n");
+
+	/* Power-off the PHY */
+	inst->phy_cfg->phy_isol(inst, 1);
+
+	clk_disable_unprepare(phy_drd->ref_clk);
+
+	return 0;
+}
+
+static struct phy *exynos5_usbdrd_phy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct exynos5_usbdrd_phy *phy_drd = dev_get_drvdata(dev);
+
+	if (WARN_ON(args->args[0] > EXYNOS5_DRDPHYS_NUM))
+		return ERR_PTR(-ENODEV);
+
+	return phy_drd->phys[args->args[0]].phy;
+}
+
+static struct phy_ops exynos5_usbdrd_phy_ops = {
+	.init		= exynos5_usbdrd_phy_init,
+	.exit		= exynos5_usbdrd_phy_exit,
+	.power_on	= exynos5_usbdrd_phy_power_on,
+	.power_off	= exynos5_usbdrd_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
+	{
+		.id		= EXYNOS5_DRDPHY_UTMI,
+		.phy_isol	= exynos5_usbdrd_phy_isol,
+		.phy_init	= exynos5_usbdrd_utmi_init,
+		.set_refclk	= exynos5_usbdrd_utmi_set_refclk,
+	},
+	{
+		.id		= EXYNOS5_DRDPHY_PIPE3,
+		.phy_isol	= exynos5_usbdrd_phy_isol,
+		.phy_init	= exynos5_usbdrd_pipe3_init,
+		.set_refclk	= exynos5_usbdrd_pipe3_set_refclk,
+	},
+};
+
+const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
+	.phy_cfg		= phy_cfg_exynos5,
+	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
+	.pmu_offset_usbdrd1_phy	= EXYNOS5420_USBDRD1_PHY_CONTROL,
+};
+
+const struct exynos5_usbdrd_phy_drvdata exynos5250_usbdrd_phy = {
+	.phy_cfg		= phy_cfg_exynos5,
+	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
+};
+
+static const struct of_device_id exynos5_usbdrd_phy_of_match[] = {
+	{
+		.compatible = "samsung,exynos5250-usbdrd-phy",
+		.data = &exynos5250_usbdrd_phy
+	}, {
+		.compatible = "samsung,exynos5420-usbdrd-phy",
+		.data = &exynos5420_usbdrd_phy
+	},
+	{ },
+};
+
+static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct exynos5_usbdrd_phy *phy_drd;
+	struct phy_provider *phy_provider;
+	struct resource *res;
+	const struct of_device_id *match;
+	const struct exynos5_usbdrd_phy_drvdata *drv_data;
+	struct regmap *reg_pmu;
+	u32 pmu_offset;
+	unsigned long ref_rate;
+	int i, ret;
+	int channel;
+
+	phy_drd = devm_kzalloc(dev, sizeof(*phy_drd), GFP_KERNEL);
+	if (!phy_drd)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, phy_drd);
+	phy_drd->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	phy_drd->reg_phy = devm_ioremap_resource(dev, res);
+	if (IS_ERR(phy_drd->reg_phy))
+		return PTR_ERR(phy_drd->reg_phy);
+
+	match = of_match_node(exynos5_usbdrd_phy_of_match, pdev->dev.of_node);
+
+	drv_data = match->data;
+	phy_drd->drv_data = drv_data;
+
+	phy_drd->clk = devm_clk_get(dev, "phy");
+	if (IS_ERR(phy_drd->clk)) {
+		dev_err(dev, "Failed to get clock of phy controller\n");
+		return PTR_ERR(phy_drd->clk);
+	}
+
+	phy_drd->ref_clk = devm_clk_get(dev, "ref");
+	if (IS_ERR(phy_drd->ref_clk)) {
+		dev_err(dev, "Failed to get reference clock of usbdrd phy\n");
+		return PTR_ERR(phy_drd->ref_clk);
+	}
+	ref_rate = clk_get_rate(phy_drd->ref_clk);
+
+	ret = exynos5_rate_to_clk(ref_rate, &phy_drd->extrefclk);
+	if (ret) {
+		dev_err(phy_drd->dev, "Clock rate (%ld) not supported\n",
+			ref_rate);
+		return ret;
+	}
+
+	reg_pmu = syscon_regmap_lookup_by_phandle(dev->of_node,
+						   "samsung,pmu-syscon");
+	if (IS_ERR(reg_pmu)) {
+		dev_err(dev, "Failed to lookup PMU regmap\n");
+		return PTR_ERR(reg_pmu);
+	}
+
+	/*
+	 * Exynos5420 SoC has multiple channels for USB 3.0 PHY, with
+	 * each having separate power control registers.
+	 * 'channel' facilitates to set such registers.
+	 */
+	channel = of_alias_get_id(node, "usbdrdphy");
+	if (channel < 0)
+		dev_dbg(dev, "Not a multi-controller usbdrd phy\n");
+
+	switch (channel) {
+	case 1:
+		pmu_offset = phy_drd->drv_data->pmu_offset_usbdrd1_phy;
+		break;
+	case 0:
+	default:
+		pmu_offset = phy_drd->drv_data->pmu_offset_usbdrd0_phy;
+		break;
+	}
+
+	dev_vdbg(dev, "Creating usbdrd_phy phy\n");
+
+	for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
+		struct phy *phy = devm_phy_create(dev, &exynos5_usbdrd_phy_ops,
+						  NULL);
+		if (IS_ERR(phy)) {
+			dev_err(dev, "Failed to create usbdrd_phy phy\n");
+			return PTR_ERR(phy);
+		}
+
+		phy_drd->phys[i].phy = phy;
+		phy_drd->phys[i].index = i;
+		phy_drd->phys[i].reg_pmu = reg_pmu;
+		phy_drd->phys[i].pmu_offset = pmu_offset;
+		phy_drd->phys[i].phy_cfg = &drv_data->phy_cfg[i];
+		phy_set_drvdata(phy, &phy_drd->phys[i]);
+	}
+
+	phy_provider = devm_of_phy_provider_register(dev,
+						     exynos5_usbdrd_phy_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(phy_drd->dev, "Failed to register phy provider\n");
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static struct platform_driver exynos5_usb3drd_phy = {
+	.probe	= exynos5_usbdrd_phy_probe,
+	.driver = {
+		.of_match_table	= exynos5_usbdrd_phy_of_match,
+		.name		= "exynos5_usb3drd_phy",
+		.owner		= THIS_MODULE,
+	}
+};
+
+module_platform_driver(exynos5_usb3drd_phy);
+MODULE_DESCRIPTION("Samsung EXYNOS5 SoCs USB 3.0 DRD controller PHY driver");
+MODULE_AUTHOR("Vivek Gautam <gautam.vivek@samsung.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:exynos5_usb3drd_phy");
diff --git a/include/linux/mfd/syscon/exynos5-pmu.h b/include/linux/mfd/syscon/exynos5-pmu.h
new file mode 100644
index 0000000..00ef24b
--- /dev/null
+++ b/include/linux/mfd/syscon/exynos5-pmu.h
@@ -0,0 +1,44 @@
+/*
+ * Exynos5 SoC series Power Management Unit (PMU) register offsets
+ * and bit definitions.
+ *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_MFD_SYSCON_PMU_EXYNOS5_H_
+#define _LINUX_MFD_SYSCON_PMU_EXYNOS5_H_
+
+/* Exynos5 PMU register definitions */
+#define EXYNOS5_HDMI_PHY_CONTROL		(0x700)
+#define EXYNOS5_USBDRD_PHY_CONTROL		(0x704)
+
+/* Exynos5250 specific register definitions */
+#define EXYNOS5_USBHOST_PHY_CONTROL		(0x708)
+#define EXYNOS5_EFNAND_PHY_CONTROL		(0x70c)
+#define EXYNOS5_MIPI_PHY0_CONTROL		(0x710)
+#define EXYNOS5_MIPI_PHY1_CONTROL		(0x714)
+#define EXYNOS5_ADC_PHY_CONTROL			(0x718)
+#define EXYNOS5_MTCADC_PHY_CONTROL		(0x71c)
+#define EXYNOS5_DPTX_PHY_CONTROL		(0x720)
+#define EXYNOS5_SATA_PHY_CONTROL		(0x724)
+
+/* Exynos5420 specific register definitions */
+#define EXYNOS5420_USBDRD1_PHY_CONTROL		(0x708)
+#define EXYNOS5420_USBHOST_PHY_CONTROL		(0x70c)
+#define EXYNOS5420_MIPI_PHY0_CONTROL		(0x714)
+#define EXYNOS5420_MIPI_PHY1_CONTROL		(0x718)
+#define EXYNOS5420_MIPI_PHY2_CONTROL		(0x71c)
+#define EXYNOS5420_ADC_PHY_CONTROL		(0x720)
+#define EXYNOS5420_MTCADC_PHY_CONTROL		(0x724)
+#define EXYNOS5420_DPTX_PHY_CONTROL		(0x728)
+
+#define EXYNOS5_PHY_ENABLE			BIT(0)
+
+#define EXYNOS5_MIPI_PHY_S_RESETN		BIT(1)
+#define EXYNOS5_MIPI_PHY_M_RESETN		BIT(2)
+
+#endif /* _LINUX_MFD_SYSCON_PMU_EXYNOS5_H_ */
-- 
1.7.9.5

