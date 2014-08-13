Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaHMPg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:36:27 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:45565 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbaHMPgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:36:24 -0400
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
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        alexandre torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 3/5] phy: miphy28lp: Provide support for the MiPHY28lp Generic PHY
Date: Wed, 13 Aug 2014 17:34:33 +0200
Message-Id: <1407944075-8093-4-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407944075-8093-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1407944075-8093-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-13_05:2014-08-13,2014-08-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY28lp is a Generic PHY which can serve various SATA or PCIe
or USB3 devices.

Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 drivers/phy/Kconfig         |   8 +
 drivers/phy/Makefile        |   1 +
 drivers/phy/phy-miphy28lp.c | 736 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 745 insertions(+)
 create mode 100644 drivers/phy/phy-miphy28lp.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 0dd7427..2053f72 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -230,4 +230,12 @@ config PHY_XGENE
 	help
 	  This option enables support for APM X-Gene SoC multi-purpose PHY.
 
+config PHY_MIPHY28LP
+	tristate "STMicroelectronics MIPHY28LP PHY driver for STiH407"
+	depends on ARCH_STI
+	depends on GENERIC_PHY
+	help
+	  Enable this to support the miphy transceiver (for SATA/PCIE/USB3)
+	  that is part of STMicroelectronics STiH407 SoC.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 95c69ed..f7e7c59 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
+obj-$(CONFIG_PHY_MIPHY28LP) 		+= phy-miphy28lp.o
 obj-$(CONFIG_PHY_MIPHY365X)		+= phy-miphy365x.o
 obj-$(CONFIG_OMAP_CONTROL_PHY)		+= phy-omap-control.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
new file mode 100644
index 0000000..767614c
--- /dev/null
+++ b/drivers/phy/phy-miphy28lp.c
@@ -0,0 +1,736 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics
+ *
+ * STMicroelectronics PHY driver MiPHY28lp (for SoC STiH407).
+ *
+ * Author: Alexandre Torgue <alexandre.torgue@st.com>
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
+#include <linux/of_address.h>
+#include <linux/clk.h>
+#include <linux/phy/phy.h>
+#include <linux/delay.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+
+#include <dt-bindings/phy/phy-miphy28lp.h>
+
+/* MiPHY registers */
+#define MIPHY_STATUS_1		0x02
+#define MIPHY_PHY_RDY		0x01
+#define MIPHY_PLL_HFC_RDY	0x06
+#define MIPHY_COMP_FSM_6	0x3f
+#define MIPHY_COMP_DONE		0x80
+
+#define MIPHY_CTRL_REG		0x04
+#define MIPHY_PX_RX_POL		BIT(5)
+
+/*
+ * On STiH407 the glue logic can be different among MiPHY devices; for example:
+ * MiPHY0: OSC_FORCE_EXT means:
+ *  0: 30MHz crystal clk - 1: 100MHz ext clk routed through MiPHY1
+ * MiPHY1: OSC_FORCE_EXT means:
+ *  1: 30MHz crystal clk - 0: 100MHz ext clk routed through MiPHY1
+ * Some devices have not the possibility to check if the osc is ready.
+ */
+#define MIPHY_OSC_FORCE_EXT	BIT(3)
+#define MIPHY_OSC_RDY		BIT(5)
+
+#define MIPHY_CTRL_MASK		0xf
+#define MIPHY_CTRL_DEFAULT	0
+#define MIPHY_CTRL_SYNC_D_EN	BIT(2)
+
+/* SATA / PCIe defines */
+#define SATA_CTRL_MASK		0x7
+#define PCIE_CTRL_MASK		0xff
+#define SATA_CTRL_SELECT_SATA	1
+#define SATA_CTRL_SELECT_PCIE	0
+#define SYSCFG_PCIE_PCIE_VAL	0x80
+#define SATA_SPDMODE		1
+
+struct miphy28lp_phy {
+	struct phy *phy;
+	struct miphy28lp_dev *phydev;
+	void __iomem *base;
+	void __iomem *pipebase;
+
+	bool osc_force_ext;
+	bool osc_rdy;
+	bool px_rx_pol_inv;
+
+	struct reset_control *miphy_rst;
+
+	u32 sata_gen;
+
+	/* Sysconfig registers offsets needed to configure the device */
+	u32 syscfg_miphy_ctrl;
+	u32 syscfg_miphy_status;
+	u32 syscfg_pci;
+	u32 syscfg_sata;
+	u8 type;
+};
+
+struct miphy28lp_dev {
+	struct device *dev;
+	struct regmap *regmap;
+	struct mutex miphy_mutex;
+	struct miphy28lp_phy **phys;
+};
+
+struct miphy_initval {
+	u16 reg;
+	u16 val;
+};
+
+enum miphy_sata_gen { SATA_GEN1, SATA_GEN2, SATA_GEN3 };
+
+static char *miphy_type_name[] = { "sata-up", "pcie-up", "usb3-up" };
+
+static const struct miphy_initval miphylp28_initvals_sata[] = {
+	/* Putting Macro in reset */
+	{0x00, 0x01}, {0x00, 0x03},
+	/* Wait for a while */
+	{0x00, 0x01}, {0x04, 0x1c},
+	/* PLL calibration */
+	{0xeb, 0x1d}, {0x0d, 0x1e}, {0x0f, 0x00},
+	/* Writing The PLL Ratio */
+	{0xd4, 0xc8}, {0xd5, 0x00}, {0xd6, 0x00}, {0xd7, 0x00},
+	{0xd3, 0x00}, {0x0f, 0x02}, {0x0e, 0x0a}, {0x0f, 0x01},
+	{0x0e, 0x0a}, {0x0f, 0x00}, {0x0e, 0x0a}, {0x4e, 0xd1},
+	{0x4e, 0xd1},
+	/* Rx Calibration */
+	{0x99, 0x1f}, {0x0a, 0x41}, {0x7a, 0x0d}, {0x7f, 0x7d},
+	{0x80, 0x56}, {0x81, 0x00}, {0x7b, 0x00}, {0xc1, 0x01},
+	{0xc2, 0x01}, {0x97, 0xf3}, {0xc9, 0x02}, {0xca, 0x02},
+	{0xcb, 0x02}, {0xcc, 0x0a}, {0x9d, 0xe5}, {0x0f, 0x00},
+	{0x0e, 0x02}, {0x0e, 0x00}, {0x63, 0x00}, {0x64, 0xaf},
+	{0x0f, 0x00}, {0x49, 0x07}, {0x0f, 0x01}, {0x49, 0x07},
+	{0x0f, 0x02}, {0x49, 0x07}, {0x0f, 0x03}, {0x49, 0x07},
+	{0x0f, 0x00}, {0x4a, 0x50}, {0x4a, 0x53}, {0x4b, 0x00},
+	{0x4b, 0x00}, {0x0f, 0x01}, {0x0e, 0x04}, {0x0e, 0x05},
+	{0x63, 0x00}, {0x64, 0xae}, {0x0f, 0x00}, {0x49, 0x07},
+	{0x0f, 0x01}, {0x49, 0x07}, {0x0f, 0x02}, {0x49, 0x07},
+	{0x0f, 0x03}, {0x49, 0x07}, {0x0f, 0x01}, {0x4a, 0x73},
+	{0x4a, 0x72}, {0x4b, 0x20}, {0x4b, 0x20}, {0x0f, 0x02},
+	{0x0e, 0x09}, {0x0e, 0x0a}, {0x63, 0x00}, {0x64, 0xae},
+	{0x0f, 0x00}, {0x49, 0x07}, {0x0f, 0x01}, {0x49, 0x07},
+	{0x0f, 0x02}, {0x49, 0x07}, {0x0f, 0x03}, {0x49, 0x07},
+	{0x0f, 0x02}, {0x4a, 0xc2}, {0x4a, 0xc0}, {0x4b, 0x20},
+	{0x4b, 0x20}, {0xcd, 0x21}, {0xcd, 0x21}, {0x00, 0x00},
+	{0x00, 0x01}, {0x00, 0x00}, {0x01, 0x04}, {0x01, 0x05},
+	{0xe9, 0x00}, {0x0d, 0x1e}, {0x3a, 0x40}, {0x01, 0x01},
+	{0x01, 0x00}, {0xe9, 0x40}, {0x0a, 0x41}, {0x0f, 0X00},
+	{0x0b, 0x00}, {0x0b, 0x00}, {0x62, 0x00}, {0x0f, 0x00},
+	{0xe3, 0x02}, {0xe3, 0x02}, {0x26, 0x27}, {0x26, 0x00},
+	{0x26, 0x62}, {0x26, 0x00}, {0x0f, 0x00}, {0x0f, 0x01},
+	{0x0f, 0x02}, {0x0f, 0x00},
+};
+
+static const struct miphy_initval miphylp28_initvals0_pcie[] = {
+	/* Putting Macro in reset */
+	{0x00, 0x01}, {0x00, 0x03},
+	/* Wait for a while */
+	{0x00, 0x01}, {0x04, 0x14}, {0xeb, 0x1d}, {0x0d, 0x1e},
+	{0xd4, 0xa6}, {0xd5, 0xaa}, {0xd6, 0xaa}, {0xd7, 0x00},
+	{0xd3, 0x00}, {0x0a, 0x40}, {0x4e, 0xd1}, {0x99, 0x5f},
+	{0x0f, 0x00}, {0x0e, 0x05}, {0x63, 0x00}, {0x64, 0xa5},
+	{0x49, 0x07}, {0x4a, 0x71}, {0x4b, 0x60}, {0x78, 0x98},
+	{0x7a, 0x0d}, {0x7b, 0x00}, {0x7f, 0x79}, {0x80, 0x53},
+	{0x0f, 0x01}, {0x0e, 0x0a}, {0x63, 0x00}, {0x64, 0xa5},
+	{0x49, 0x07}, {0x4a, 0x70}, {0x4b, 0x60}, {0x78, 0x9c},
+	{0x7a, 0x0d}, {0x7b, 0x00}, {0x7f, 0x79}, {0x80, 0x6a},
+	{0xcd, 0x21}, {0x00, 0x00}, {0x01, 0x05}, {0xe9, 0x00},
+	{0x0d, 0x1e}, {0x3a, 0x40},
+};
+
+static const struct miphy_initval miphylp28_initvals1_pcie[] = {
+	{0x01, 0x01}, {0x01, 0x00},
+	{0xe9, 0x40}, {0xe3, 0x02},
+};
+
+static const struct miphy_initval miphylp28_initvals_usb3[] = {
+	/* Putting Macro in reset */
+	{0x00, 0x01}, {0x00, 0x03},
+	/* Wait for a while */
+	{0x00, 0x01}, {0x04, 0x1c},
+	/* PLL calibration */
+	{0xeb, 0x1d}, {0x0d, 0x1e}, {0x0f, 0x00}, {0xc4, 0x70},
+	{0xc9, 0x02}, {0xca, 0x02}, {0xcb, 0x02}, {0xcc, 0x0a},
+	/* Writing The PLL Ratio */
+	{0xd4, 0xa6}, {0xd5, 0xaa}, {0xd6, 0xaa}, {0xd7, 0x04},
+	{0xd3, 0x00},
+	/* Writing The Speed Rate */
+	{0x0f, 0x00}, {0x0e, 0x0a},
+	/* RX Channel compensation and calibration */
+	{0xc2, 0x1c}, {0x97, 0x51}, {0x98, 0x70}, {0x99, 0x5f},
+	{0x9a, 0x22}, {0x9f, 0x0e},
+
+	{0x7a, 0x05}, {0x7f, 0x78}, {0x30, 0x1b},
+	/* Enable GENSEL_SEL and SSC */
+	/* TX_SEL=0 swing preemp forced by pipe registres */
+	{0x0a, 0x11},
+	/* MIPHY Bias boost */
+	{0x63, 0x00}, {0x64, 0xa7},
+	/* TX compensation offset to re-center TX impedance */
+	{0x42, 0x02},
+	/* SSC modulation */
+	{0x0C, 0x04},
+	/* MIPHY TX control */
+	{0x0f, 0x00}, {0xe5, 0x5a}, {0xe6, 0xA0}, {0xe4, 0x3c},
+	{0xe6, 0xa1}, {0xe3, 0x00}, {0xe3, 0x02}, {0xe3, 0x00},
+	/* Rx PI controller settings */
+	{0x78, 0xca},
+	/* MIPHY RX input bridge control */
+	/* INPUT_BRIDGE_EN_SW=1, manual input bridge control[0]=1 */
+	{0xcd, 0x21}, {0xcd, 0x29}, {0xce, 0x1a},
+	/* MIPHY Reset */
+	{0x00, 0x01}, {0x00, 0x00}, {0x01, 0x04}, {0x01, 0x05},
+	{0xe9, 0x00}, {0x0d, 0x1e}, {0x3a, 0x40}, {0x01, 0x01},
+	{0x01, 0x00}, {0xe9, 0x40}, {0x0f, 0x00}, {0x0b, 0x00},
+	{0x62, 0x00}, {0x0f, 0x00}, {0xe3, 0x02}, {0x26, 0xa5},
+	{0x0f, 0x00},
+};
+
+static void miphy_write_initvals(struct miphy28lp_phy *miphy_phy,
+				 const struct miphy_initval *initvals,
+				 int count)
+{
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		dev_dbg(miphy_dev->dev, "MiPHY28LP reg: 0x%x=0x%x\n",
+			initvals[i].reg, initvals[i].val);
+		if (i == 2)
+			usleep_range(10, 20); /* extra delay after resetting */
+		writeb_relaxed(initvals[i].val,
+			       miphy_phy->base + initvals[i].reg);
+	}
+}
+
+static inline int miphy_is_ready(struct miphy28lp_phy *miphy_phy)
+{
+	unsigned long finish = jiffies + 5 * HZ;
+	u8 mask = MIPHY_PLL_HFC_RDY;
+	u8 val;
+
+	/*
+	 * For PCIe and USB3 check only that PLL and HFC are ready
+	 * For SATA check also that phy is ready!
+	 */
+	if (miphy_phy->type == MIPHY_TYPE_SATA)
+		mask |= MIPHY_PHY_RDY;
+
+	do {
+		val = readb_relaxed(miphy_phy->base + MIPHY_STATUS_1);
+		if ((val & mask) != mask)
+			cpu_relax();
+		else
+			return 0;
+	} while (!time_after_eq(jiffies, finish));
+
+	return -EBUSY;
+}
+
+static int miphy_osc_is_ready(struct miphy28lp_phy *miphy_phy)
+{
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+	unsigned long finish = jiffies + 5 * HZ;
+	u32 val;
+
+	if (!miphy_phy->osc_rdy)
+		return 0;
+
+	if (!miphy_phy->syscfg_miphy_status)
+		return -EINVAL;
+
+	do {
+		regmap_read(miphy_dev->regmap, miphy_phy->syscfg_miphy_status,
+			    &val);
+
+		if ((val & MIPHY_OSC_RDY) != MIPHY_OSC_RDY)
+			cpu_relax();
+		else
+			return 0;
+	} while (!time_after_eq(jiffies, finish));
+
+	return -EBUSY;
+}
+
+static int miphy28lp_get_ressource_byname(struct device_node *child,
+					  char *name, struct resource *res)
+{
+	int index, ret = 0, count = 0;
+	int reg_tuple_size;
+	const __be32 *p;
+
+	reg_tuple_size = (of_n_addr_cells(child) +
+			of_n_size_cells(child)) * sizeof(u32);
+
+	p = of_get_property(child, "reg", &count);
+	if (count % reg_tuple_size != 0)
+		ret = -EINVAL;
+
+	count /= reg_tuple_size;
+
+	for (index = 0; index < count; index++) {
+		const char *rname = NULL;
+
+		ret = of_property_read_string_index(child, "reg-names",
+						    index, &rname);
+		if (!strcmp(name, rname))
+			return of_address_to_resource(child, index, res);
+	}
+
+	return 1;
+}
+
+static int miphy28lp_get_one_addr(struct device *dev,
+				  struct device_node *child, char *rname,
+				  void __iomem **base)
+{
+	struct resource res;
+	int ret;
+
+	ret = miphy28lp_get_ressource_byname(child, rname, &res);
+	if (!ret) {
+		*base = devm_ioremap(dev, res.start, resource_size(&res));
+		if (!*base) {
+			dev_err(dev, "failed to ioremap %s address region\n"
+					, rname);
+			return -ENOENT;
+		}
+	}
+
+	return 0;
+}
+
+/* MiPHY reset and sysconf setup */
+static int miphy28lp_setup(struct miphy28lp_phy *miphy_phy, u32 miphy_val)
+{
+	int err;
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+
+	if (!miphy_phy->syscfg_miphy_ctrl)
+		return -EINVAL;
+
+	err = reset_control_assert(miphy_phy->miphy_rst);
+	if (err) {
+		dev_err(miphy_dev->dev, "unable to bring out of miphy reset\n");
+		return err;
+	}
+
+	if (miphy_phy->osc_force_ext)
+		miphy_val |= MIPHY_OSC_FORCE_EXT;
+
+	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_miphy_ctrl,
+			   MIPHY_CTRL_MASK, miphy_val);
+
+	err = reset_control_deassert(miphy_phy->miphy_rst);
+	if (err) {
+		dev_err(miphy_dev->dev, "unable to bring out of miphy reset\n");
+		return err;
+	}
+
+	return miphy_osc_is_ready(miphy_phy);
+}
+
+static int miphy28lp_init_sata(struct miphy28lp_phy *miphy_phy)
+{
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+	int count, err, sata_conf = SATA_CTRL_SELECT_SATA;
+	u8 val;
+
+	if ((!miphy_phy->syscfg_sata) || (!miphy_phy->syscfg_pci)
+		|| (!miphy_phy->base))
+		return -EINVAL;
+
+	dev_info(miphy_dev->dev, "sata-up mode, addr 0x%p\n", miphy_phy->base);
+
+	/* Configure the glue-logic */
+	sata_conf |= ((miphy_phy->sata_gen - SATA_GEN1) << SATA_SPDMODE);
+
+	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_sata,
+			   SATA_CTRL_MASK, sata_conf);
+
+	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_pci,
+			   PCIE_CTRL_MASK, SATA_CTRL_SELECT_PCIE);
+
+	/* MiPHY path and clocking init */
+	err = miphy28lp_setup(miphy_phy, MIPHY_CTRL_DEFAULT);
+
+	if (err) {
+		dev_err(miphy_dev->dev, "SATA phy setup failed\n");
+		return err;
+	}
+
+	/* initialize miphy */
+	count = ARRAY_SIZE(miphylp28_initvals_sata);
+	miphy_write_initvals(miphy_phy, miphylp28_initvals_sata, count);
+
+	if (miphy_phy->px_rx_pol_inv) {
+		/* Invert Rx polarity */
+		val = readb_relaxed(miphy_phy->base + MIPHY_CTRL_REG);
+		val |= MIPHY_PX_RX_POL;
+		writeb_relaxed(val, miphy_phy->base + MIPHY_CTRL_REG);
+	}
+
+	return miphy_is_ready(miphy_phy);
+}
+
+static int miphy28lp_init_pcie(struct miphy28lp_phy *miphy_phy)
+{
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+	unsigned long finish = jiffies + 5 * HZ;
+	int count, err;
+	u8 val;
+
+	if ((!miphy_phy->syscfg_sata) || (!miphy_phy->syscfg_pci)
+		|| (!miphy_phy->base) || (!miphy_phy->pipebase))
+		return -EINVAL;
+
+	dev_info(miphy_dev->dev, "pcie-up mode, addr 0x%p\n", miphy_phy->base);
+
+	/* Configure the glue-logic */
+	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_sata,
+			   SATA_CTRL_MASK, SATA_CTRL_SELECT_PCIE);
+
+	regmap_update_bits(miphy_dev->regmap, miphy_phy->syscfg_pci,
+			   PCIE_CTRL_MASK, SYSCFG_PCIE_PCIE_VAL);
+
+	/* MiPHY path and clocking init */
+	err = miphy28lp_setup(miphy_phy, MIPHY_CTRL_DEFAULT);
+
+	if (err) {
+		dev_err(miphy_dev->dev, "PCIe phy setup failed\n");
+		return err;
+	}
+
+	count = ARRAY_SIZE(miphylp28_initvals0_pcie);
+	miphy_write_initvals(miphy_phy, miphylp28_initvals0_pcie, count);
+
+	/* extra delay to wait pll lock */
+	usleep_range(100, 120);
+
+	count = ARRAY_SIZE(miphylp28_initvals1_pcie);
+	miphy_write_initvals(miphy_phy, miphylp28_initvals1_pcie, count);
+
+	/* Waiting for Compensation to complete */
+	do {
+		val = readb_relaxed(miphy_phy->base + MIPHY_COMP_FSM_6);
+		if (time_after_eq(jiffies, finish))
+			return -EBUSY;
+		cpu_relax();
+	} while (!(val & MIPHY_COMP_DONE));
+
+	/* PIPE Wrapper Configuration */
+	writeb_relaxed(0x68, miphy_phy->pipebase + 0x104); /* Rise_0 */
+	writeb_relaxed(0x61, miphy_phy->pipebase + 0x105); /* Rise_1 */
+	writeb_relaxed(0x68, miphy_phy->pipebase + 0x108); /* Fall_0 */
+	writeb_relaxed(0x61, miphy_phy->pipebase + 0x109); /* Fall-1 */
+	writeb_relaxed(0x68, miphy_phy->pipebase + 0x10c); /* Threshhold_0 */
+	writeb_relaxed(0x60, miphy_phy->pipebase + 0x10d); /* Threshold_1 */
+
+	/* Wait for phy_ready */
+	return miphy_is_ready(miphy_phy);
+}
+
+static int miphy28lp_init_usb3(struct miphy28lp_phy *miphy_phy)
+{
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+	int count, err;
+
+	if ((!miphy_phy->base) || (!miphy_phy->pipebase))
+		return -EINVAL;
+
+	dev_info(miphy_dev->dev, "usb3-up mode, addr 0x%p\n", miphy_phy->base);
+
+	/* MiPHY path and clocking init */
+	err = miphy28lp_setup(miphy_phy, MIPHY_CTRL_SYNC_D_EN);
+
+	if (err) {
+		dev_err(miphy_dev->dev, "USB3 phy setup failed\n");
+		return err;
+	}
+
+	count = ARRAY_SIZE(miphylp28_initvals_usb3);
+	miphy_write_initvals(miphy_phy, miphylp28_initvals_usb3, count);
+
+	/* PIPE Wrapper Configuration */
+	writeb_relaxed(0x68, miphy_phy->pipebase + 0x23);
+	writeb_relaxed(0x61, miphy_phy->pipebase + 0x24);
+	writeb_relaxed(0x68, miphy_phy->pipebase + 0x26);
+	writeb_relaxed(0x61, miphy_phy->pipebase + 0x27);
+	writeb_relaxed(0x18, miphy_phy->pipebase + 0x29);
+	writeb_relaxed(0x60, miphy_phy->pipebase + 0x2a);
+
+	/* pipe Wrapper usb3 TX swing de-emph margin PREEMPH[7:4], SWING[3:0] */
+	writeb_relaxed(0X67, miphy_phy->pipebase + 0x68);
+	writeb_relaxed(0x0d, miphy_phy->pipebase + 0x69);
+	writeb_relaxed(0X67, miphy_phy->pipebase + 0x6a);
+	writeb_relaxed(0X0d, miphy_phy->pipebase + 0x6b);
+	writeb_relaxed(0X67, miphy_phy->pipebase + 0x6c);
+	writeb_relaxed(0X0d, miphy_phy->pipebase + 0x6d);
+	writeb_relaxed(0X67, miphy_phy->pipebase + 0x6e);
+	writeb_relaxed(0X0d, miphy_phy->pipebase + 0x6f);
+
+	return miphy_is_ready(miphy_phy);
+}
+
+static int miphy28lp_init(struct phy *phy)
+{
+	struct miphy28lp_phy *miphy_phy = phy_get_drvdata(phy);
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+	int ret;
+
+	mutex_lock(&miphy_dev->miphy_mutex);
+
+	switch (miphy_phy->type) {
+
+	case MIPHY_TYPE_SATA:
+		ret = miphy28lp_init_sata(miphy_phy);
+		break;
+	case MIPHY_TYPE_PCIE:
+		ret = miphy28lp_init_pcie(miphy_phy);
+		break;
+	case MIPHY_TYPE_USB:
+		ret = miphy28lp_init_usb3(miphy_phy);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	mutex_unlock(&miphy_dev->miphy_mutex);
+
+	return ret;
+}
+
+
+static int miphy28lp_get_addr(struct miphy28lp_phy *miphy_phy)
+{
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+	struct device_node *phynode = miphy_phy->phy->dev.of_node;
+	int err;
+
+	if (!miphy_phy->type || (miphy_phy->type > MIPHY_TYPE_USB))
+		return -EINVAL;
+
+	err = miphy28lp_get_one_addr(miphy_dev->dev, phynode,
+			miphy_type_name[miphy_phy->type - MIPHY_TYPE_SATA],
+			&miphy_phy->base);
+	if (err)
+		return err;
+
+	if ((miphy_phy->type == MIPHY_TYPE_PCIE) ||
+	    (miphy_phy->type == MIPHY_TYPE_USB)) {
+		err = miphy28lp_get_one_addr(miphy_dev->dev, phynode, "pipew",
+					     &miphy_phy->pipebase);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static struct phy *miphy28lp_xlate(struct device *dev,
+				   struct of_phandle_args *args)
+{
+	struct miphy28lp_dev *miphy_dev = dev_get_drvdata(dev);
+	struct miphy28lp_phy *miphy_phy = NULL;
+	struct device_node *phynode = args->np;
+	int ret, index = 0;
+
+	if (!of_device_is_available(phynode)) {
+		dev_warn(dev, "Requested PHY is disabled\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	if (args->args_count != 1) {
+		dev_err(dev, "Invalid number of cells in 'phy' property\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	for (index = 0; index < of_get_child_count(dev->of_node); index++)
+		if (phynode == miphy_dev->phys[index]->phy->dev.of_node) {
+			miphy_phy = miphy_dev->phys[index];
+			break;
+		}
+
+	if (!miphy_phy) {
+		dev_err(dev, "Failed to find appropriate phy\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	miphy_phy->type = args->args[0];
+
+	ret = miphy28lp_get_addr(miphy_phy);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	return miphy_phy->phy;
+}
+
+static struct phy_ops miphy28lp_ops = {
+	.init = miphy28lp_init,
+	.owner = THIS_MODULE,
+};
+
+static int miphy28lp_probe_resets(struct device_node *node,
+				  struct miphy28lp_phy *miphy_phy)
+{
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+	int err;
+
+	miphy_phy->miphy_rst = of_reset_control_get(node, "miphy-sw-rst");
+
+	if (IS_ERR(miphy_phy->miphy_rst)) {
+		dev_err(miphy_dev->dev,
+				"miphy soft reset control not defined\n");
+		return PTR_ERR(miphy_phy->miphy_rst);
+	}
+
+	err = reset_control_deassert(miphy_phy->miphy_rst);
+	if (err) {
+		dev_err(miphy_dev->dev, "unable to bring out of miphy reset\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static int miphy28lp_of_probe(struct device_node *np,
+			      struct miphy28lp_phy *miphy_phy)
+{
+	struct resource res;
+
+	miphy_phy->osc_force_ext =
+		of_property_read_bool(np, "st,osc-force-ext");
+
+	miphy_phy->osc_rdy = of_property_read_bool(np, "st,osc-rdy");
+
+	miphy_phy->px_rx_pol_inv =
+		of_property_read_bool(np, "st,px_rx_pol_inv");
+
+	of_property_read_u32(np, "st,sata-gen", &miphy_phy->sata_gen);
+	if (!miphy_phy->sata_gen)
+		miphy_phy->sata_gen = SATA_GEN1;
+
+	if (!miphy28lp_get_ressource_byname(np, "miphy-ctrl-glue", &res))
+		miphy_phy->syscfg_miphy_ctrl = res.start;
+
+	if (!miphy28lp_get_ressource_byname(np, "miphy-status-glue", &res))
+		miphy_phy->syscfg_miphy_status = res.start;
+
+	if (!miphy28lp_get_ressource_byname(np, "pcie-glue", &res))
+		miphy_phy->syscfg_pci = res.start;
+
+	if (!miphy28lp_get_ressource_byname(np, "sata-glue", &res))
+		miphy_phy->syscfg_sata = res.start;
+
+
+	return 0;
+}
+
+static int miphy28lp_probe(struct platform_device *pdev)
+{
+	struct device_node *child, *np = pdev->dev.of_node;
+	struct miphy28lp_dev *miphy_dev;
+	struct phy_provider *provider;
+	struct phy *phy;
+	int chancount, port = 0;
+	int ret;
+
+	miphy_dev = devm_kzalloc(&pdev->dev, sizeof(*miphy_dev), GFP_KERNEL);
+	if (!miphy_dev)
+		return -ENOMEM;
+
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
+
+	mutex_init(&miphy_dev->miphy_mutex);
+
+	for_each_child_of_node(np, child) {
+		struct miphy28lp_phy *miphy_phy;
+
+		miphy_phy = devm_kzalloc(&pdev->dev, sizeof(*miphy_phy),
+					 GFP_KERNEL);
+		if (!miphy_phy)
+			return -ENOMEM;
+
+		miphy_dev->phys[port] = miphy_phy;
+
+		phy = devm_phy_create(&pdev->dev, child, &miphy28lp_ops, NULL);
+		if (IS_ERR(phy)) {
+			dev_err(&pdev->dev, "failed to create PHY\n");
+			return PTR_ERR(phy);
+		}
+
+		miphy_dev->phys[port]->phy = phy;
+		miphy_dev->phys[port]->phydev = miphy_dev;
+
+		ret = miphy28lp_of_probe(child, miphy_phy);
+		if (ret)
+			return ret;
+
+		ret = miphy28lp_probe_resets(child, miphy_dev->phys[port]);
+		if (ret)
+			return ret;
+
+		phy_set_drvdata(phy, miphy_dev->phys[port]);
+		port++;
+
+	}
+
+	provider = devm_of_phy_provider_register(&pdev->dev, miphy28lp_xlate);
+	if (IS_ERR(provider))
+		return PTR_ERR(provider);
+
+	return 0;
+}
+
+static const struct of_device_id miphy28lp_of_match[] = {
+	{.compatible = "st,miphy28lp-phy", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, miphy28lp_of_match);
+
+static struct platform_driver miphy28lp_driver = {
+	.probe = miphy28lp_probe,
+	.driver = {
+		.name = "miphy28lp-phy",
+		.owner = THIS_MODULE,
+		.of_match_table = miphy28lp_of_match,
+	}
+};
+
+module_platform_driver(miphy28lp_driver);
+
+MODULE_AUTHOR("Alexandre Torgue <alexandre.torgue@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics miphy28lp driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

