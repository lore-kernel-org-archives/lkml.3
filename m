Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbaICPlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:41:00 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:39550 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756643AbaICPjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:39:01 -0400
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
Subject: [PATCH v2 3/8] phy: miphy28lp: Provide support for the MiPHY28lp Generic PHY
Date: Wed,  3 Sep 2014 17:37:12 +0200
Message-Id: <1409758637-28654-4-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-09-03_07:2014-09-03,2014-09-03,1970-01-01 signatures=0
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
 drivers/phy/phy-miphy28lp.c | 985 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 994 insertions(+)
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
index 0000000..aa36cea
--- /dev/null
+++ b/drivers/phy/phy-miphy28lp.c
@@ -0,0 +1,985 @@
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
+#include <dt-bindings/phy/phy-miphy.h>
+
+/* MiPHY mask registers */
+#define MIPHY_PHY_RDY		0x01
+#define MIPHY_PLL_HFC_RDY	0x06
+#define MIPHY_COMP_DONE		0x80
+
+#define MIPHY_PX_RX_POL		BIT(5)
+
+/* MiPHY registers */
+#define MIPHY_CONF_RESET		0x00
+#define MIPHY_RESET			0x01
+#define MIPHY_STATUS_1			0x02
+#define MIPHY_CONTROL			0x04
+#define MIPHY_BOUNDARY_SEL		0x0a
+#define MIPHY_BOUNDARY_1		0x0b
+#define MIPHY_BOUNDARY_2		0x0c
+#define MIPHY_PLL_CLKREF_FREQ		0x0d
+#define MIPHY_SPEED			0x0e
+#define MIPHY_CONF			0x0f
+#define MIPHY_CTRL_TEST_SEL		0x20
+#define MIPHY_CTRL_TEST_1		0x21
+#define MIPHY_CTRL_TEST_2		0x22
+#define MIPHY_CTRL_TEST_3		0x23
+#define MIPHY_CTRL_TEST_4		0x24
+#define MIPHY_FEEDBACK_TEST		0x25
+#define MIPHY_DEBUG_BUS			0x26
+#define MIPHY_DEBUG_STATUS_MSB		0x27
+#define MIPHY_DEBUG_STATUS_LSB		0x28
+#define MIPHY_PWR_RAIL_1		0x29
+#define MIPHY_PWR_RAIL_2		0x2a
+#define MIPHY_SYNCHAR_CONTROL		0x30
+#define MIPHY_COMP_FSM_1		0x3a
+#define MIPHY_COMP_FSM_6		0x3f
+#define MIPHY_COMP_POSTP		0x42
+#define MIPHY_TX_CTRL_1			0x49
+#define MIPHY_TX_CTRL_2			0x4a
+#define MIPHY_TX_CTRL_3			0x4b
+#define MIPHY_TX_CAL_MAN		0x4e
+#define MIPHY_TST_BIAS_BOOST_2		0x62
+#define MIPHY_BIAS_BOOST_1		0x63
+#define MIPHY_BIAS_BOOST_2		0x64
+#define MIPHY_RX_DESBUFF_FDB_2		0x67
+#define MIPHY_RX_DESBUFF_FDB_3		0x68
+#define MIPHY_SIGDET_COMPENS1		0x69
+#define MIPHY_SIGDET_COMPENS2		0x6a
+#define MIPHY_JITTER_PERIOD		0x6b
+#define MIPHY_JITTER_AMPLITUDE_1	0x6c
+#define MIPHY_JITTER_AMPLITUDE_2	0x6d
+#define MIPHY_JITTER_AMPLITUDE_3	0x6e
+#define MIPHY_RX_K_GAIN			0x78
+#define MIPHY_RX_BUFFER_CTRL		0x7a
+#define MIPHY_RX_VGA_GAIN		0x7b
+#define MIPHY_RX_EQU_GAIN_1		0x7f
+#define MIPHY_RX_EQU_GAIN_2		0x80
+#define MIPHY_RX_EQU_GAIN_3		0x81
+#define MIPHY_RX_CAL_CTRL_1		0x97
+#define MIPHY_RX_CAL_CTRL_2		0x98
+#define MIPHY_RX_CAL_OFFSET_CTRL	0x99
+#define MIPHY_RX_CAL_VGA_STEP		0x9a
+#define MIPHY_RX_CAL_EYE_MIN		0x9d
+#define MIPHY_RX_CAL_OPT_LENGTH		0x9f
+#define MIPHY_RX_LOCK_CTRL_1		0xc1
+#define MIPHY_RX_LOCK_SETTINGS_OPT	0xc2
+#define MIPHY_RX_LOCK_STEP		0xc4
+#define MIPHY_RX_SIGDET_SLEEP_OA	0xc9
+#define MIPHY_RX_SIGDET_SLEEP_SEL	0xca
+#define MIPHY_RX_SIGDET_WAIT_SEL	0xcb
+#define MIPHY_RX_SIGDET_DATA_SEL	0xcc
+#define MIPHY_RX_POWER_CTRL_1		0xcd
+#define MIPHY_RX_POWER_CTRL_2		0xce
+#define MIPHY_PLL_CALSET_CTRL		0xd3
+#define MIPHY_PLL_CALSET_1		0xd4
+#define MIPHY_PLL_CALSET_2		0xd5
+#define MIPHY_PLL_CALSET_3		0xd6
+#define MIPHY_PLL_CALSET_4		0xd7
+#define MIPHY_PLL_SBR_1			0xe3
+#define MIPHY_PLL_SBR_2			0xe4
+#define MIPHY_PLL_SBR_3			0xe5
+#define MIPHY_PLL_SBR_4			0xe6
+#define MIPHY_PLL_COMMON_MISC_2		0xe9
+#define MIPHY_PLL_SPAREIN		0xeb
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
+#define MIPHY_CTRL_MASK		0x0f
+#define MIPHY_CTRL_DEFAULT	0
+#define MIPHY_CTRL_SYNC_D_EN	BIT(2)
+
+/* SATA / PCIe defines */
+#define SATA_CTRL_MASK		0x07
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
+static inline void miphy28lp_cfg_out_of_reset(struct miphy28lp_phy *miphy_phy)
+{
+	unsigned long finish = jiffies + 5 * HZ;
+	u8 mask = MIPHY_PLL_HFC_RDY;
+	u8 val;
+
+	do {
+		val = readb_relaxed(miphy_phy->base + MIPHY_STATUS_1);
+		if ((val & mask) != mask)
+			cpu_relax();
+		else
+			break;
+	} while (!time_after_eq(jiffies, finish));
+}
+
+static inline void miphy28lp_configure_reset(struct miphy28lp_phy *miphy_phy)
+{
+	void *base = miphy_phy->base;
+
+	/* Putting Macro in reset */
+	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
+	writeb_relaxed(0x03, base + MIPHY_CONF_RESET);
+
+	/* Wait for a while */
+	usleep_range(10, 20); /* extra delay after resetting */
+}
+
+
+
+static inline void miphy28lp_configure_sata(struct miphy28lp_phy *miphy_phy)
+{
+	void __iomem *base = miphy_phy->base;
+
+	/* Putting Macro in reset */
+	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
+	writeb_relaxed(0x03, base + MIPHY_CONF_RESET);
+
+	/* Wait for a while */
+	usleep_range(10, 20); /* extra delay after resetting */
+
+	/* Bringing the MIPHY-CPU registers out of reset */
+	writeb_relaxed(0x1c, base + MIPHY_CONTROL);
+
+	/* Applying PLL Settings */
+	writeb_relaxed(0x1d, base + MIPHY_PLL_SPAREIN);
+	writeb_relaxed(0x1e, base + MIPHY_PLL_CLKREF_FREQ);
+
+	/* PLL Ratio */
+	writeb_relaxed(0xc8, base + MIPHY_PLL_CALSET_1);
+	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_2);
+	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_3);
+	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_4);
+
+	/* Number of PLL Calibrations */
+	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_CTRL);
+
+	/* Unbanked Settings */
+	writeb_relaxed(0xd1, base + MIPHY_TX_CAL_MAN);
+	writeb_relaxed(0x1f, base + MIPHY_RX_CAL_OFFSET_CTRL);
+	writeb_relaxed(0x40, base + MIPHY_BOUNDARY_SEL);
+
+	/* Banked settings */
+	/* Gen 1 */
+	writeb_relaxed(0x00, base + MIPHY_CONF);
+	writeb_relaxed(0x00, base + MIPHY_SPEED);
+	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
+	writeb_relaxed(0xae, base + MIPHY_BIAS_BOOST_2);
+
+	/* TX buffer Settings */
+	writeb_relaxed(0x53, base + MIPHY_TX_CTRL_2);
+	writeb_relaxed(0x00, base + MIPHY_TX_CTRL_3);
+
+	/* RX Buffer Settings */
+	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
+	writeb_relaxed(0x7d, base + MIPHY_RX_EQU_GAIN_1);
+	writeb_relaxed(0x56, base + MIPHY_RX_EQU_GAIN_2);
+	writeb_relaxed(0x00, base + MIPHY_RX_EQU_GAIN_3);
+	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
+
+	/* Gen 2 */
+	writeb_relaxed(0x01, base + MIPHY_CONF);
+	writeb_relaxed(0x05, base + MIPHY_SPEED);
+	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
+	writeb_relaxed(0xae, base + MIPHY_BIAS_BOOST_2);
+
+	/* TX buffer Settings */
+	writeb_relaxed(0x72, base + MIPHY_TX_CTRL_2);
+	writeb_relaxed(0x20, base + MIPHY_TX_CTRL_3);
+
+	/* RX Buffer Settings */
+	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
+	writeb_relaxed(0x7d, base + MIPHY_RX_EQU_GAIN_1);
+	writeb_relaxed(0x56, base + MIPHY_RX_EQU_GAIN_2);
+	writeb_relaxed(0x00, base + MIPHY_RX_EQU_GAIN_3);
+	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
+
+	/* Gen 3 */
+	writeb_relaxed(0x02, base + MIPHY_CONF);
+	writeb_relaxed(0x0a, base + MIPHY_SPEED);
+	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
+	writeb_relaxed(0xae, base + MIPHY_BIAS_BOOST_2);
+
+	/* TX buffer Settings */
+	writeb_relaxed(0xc0, base + MIPHY_TX_CTRL_2);
+	writeb_relaxed(0x20, base + MIPHY_TX_CTRL_3);
+
+	/* RX Buffer Settings */
+	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
+	writeb_relaxed(0x7d, base + MIPHY_RX_EQU_GAIN_1);
+	writeb_relaxed(0x56, base + MIPHY_RX_EQU_GAIN_2);
+	writeb_relaxed(0x00, base + MIPHY_RX_EQU_GAIN_3);
+	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
+
+	/* Power control */
+	writeb_relaxed(0x21, base + MIPHY_RX_POWER_CTRL_1);
+
+	/* Macro out of reset */
+	writeb_relaxed(0x00, base + MIPHY_CONF_RESET);
+
+	/* Poll for HFC ready after reset release */
+	/* Compensation measurement */
+	writeb_relaxed(0x05, base + MIPHY_RESET);
+	writeb_relaxed(0x00, base + MIPHY_PLL_COMMON_MISC_2);
+	writeb_relaxed(0x40, base + MIPHY_COMP_FSM_1);
+	writeb_relaxed(0x00, base + MIPHY_RESET);
+	writeb_relaxed(0x40, base + MIPHY_PLL_COMMON_MISC_2);
+}
+
+static inline void miphy28lp_configure_pcie(struct miphy28lp_phy *miphy_phy)
+{
+	void __iomem *base = miphy_phy->base;
+
+	/* Putting Macro in reset */
+	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
+	writeb_relaxed(0x03, base + MIPHY_CONF_RESET);
+
+	/* Wait for a while */
+	usleep_range(10, 20); /* extra delay after resetting */
+
+	/* Bringing the MIPHY-CPU registers out of reset */
+	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
+	writeb_relaxed(0x14, base + MIPHY_CONTROL);
+	writeb_relaxed(0x1d, base + MIPHY_PLL_SPAREIN);
+
+	/* Applying PLL Settings */
+	writeb_relaxed(0x1e, base + MIPHY_PLL_CLKREF_FREQ);
+
+	/* PLL Ratio */
+	writeb_relaxed(0xa6, base + MIPHY_PLL_CALSET_1);
+	writeb_relaxed(0xaa, base + MIPHY_PLL_CALSET_2);
+	writeb_relaxed(0xaa, base + MIPHY_PLL_CALSET_3);
+	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_4);
+	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_CTRL);
+
+	writeb_relaxed(0xd1, base + MIPHY_TX_CAL_MAN);
+	writeb_relaxed(0x5f, base + MIPHY_RX_CAL_OFFSET_CTRL);
+	writeb_relaxed(0x40, base + MIPHY_BOUNDARY_SEL);
+
+	/* Banked settings */
+	/* Gen 1 */
+	writeb_relaxed(0x00, base + MIPHY_CONF);
+
+	writeb_relaxed(0x05, base + MIPHY_SPEED);
+	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
+	writeb_relaxed(0xa5, base + MIPHY_BIAS_BOOST_2);
+
+	/* TX buffer Settings */
+	writeb_relaxed(0x07, base + MIPHY_TX_CTRL_1);
+	writeb_relaxed(0x71, base + MIPHY_TX_CTRL_2);
+	writeb_relaxed(0x60, base + MIPHY_TX_CTRL_3);
+	 writeb_relaxed(0x98, base + MIPHY_RX_K_GAIN);
+
+	/* RX Buffer Settings */
+	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
+	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
+	writeb_relaxed(0x79, base + MIPHY_RX_EQU_GAIN_1);
+	writeb_relaxed(0x56, base + MIPHY_RX_EQU_GAIN_2);
+
+	/* Gen 2 */
+	writeb_relaxed(0x01, base + MIPHY_CONF);
+	writeb_relaxed(0x0a, base + MIPHY_SPEED);
+	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
+	writeb_relaxed(0xa5, base + MIPHY_BIAS_BOOST_2);
+
+	/* TX buffer Settings */
+	writeb_relaxed(0x07, base + MIPHY_TX_CTRL_1);
+	writeb_relaxed(0x70, base + MIPHY_TX_CTRL_2);
+	writeb_relaxed(0x60, base + MIPHY_TX_CTRL_3);
+	writeb_relaxed(0xcc, base + MIPHY_RX_K_GAIN);
+
+	/* RX Buffer Settings */
+	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
+	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
+	writeb_relaxed(0x78, base + MIPHY_RX_EQU_GAIN_1);
+	writeb_relaxed(0x07, base + MIPHY_RX_EQU_GAIN_2);
+
+	writeb_relaxed(0x21, base + MIPHY_RX_POWER_CTRL_1);
+
+	/* Macro out of reset */
+	writeb_relaxed(0x00, base + MIPHY_CONF_RESET);
+
+	/* Poll for HFC ready after reset release */
+	/* Compensation measurement */
+	writeb_relaxed(0x05, base + MIPHY_RESET);
+	writeb_relaxed(0x00, base + MIPHY_PLL_COMMON_MISC_2);
+	writeb_relaxed(0x1e, base + MIPHY_PLL_CLKREF_FREQ);
+	writeb_relaxed(0x40, base + MIPHY_COMP_FSM_1);
+
+	/* extra delay to wait pll lock */
+	usleep_range(100, 120);
+
+	writeb_relaxed(0x01, base + MIPHY_RESET);
+	writeb_relaxed(0x00, base + MIPHY_RESET);
+	writeb_relaxed(0x40, base + MIPHY_PLL_COMMON_MISC_2);
+	writeb_relaxed(0x02, base + MIPHY_PLL_SBR_1);
+}
+
+static inline void miphy28lp_configure_usb3(struct miphy28lp_phy *miphy_phy)
+{
+	void __iomem *base = miphy_phy->base;
+
+	/* Putting Macro in reset */
+	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
+	writeb_relaxed(0x03, base + MIPHY_CONF_RESET);
+
+	/* Wait for a while */
+	usleep_range(10, 20); /* extra delay after resetting */
+
+	/* Bringing the MIPHY-CPU registers out of reset */
+	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
+	writeb_relaxed(0x1c, base + MIPHY_CONTROL);
+
+	/* PLL calibration */
+	writeb_relaxed(0x1d, base + MIPHY_PLL_SPAREIN);
+	writeb_relaxed(0x1e, base + MIPHY_PLL_CLKREF_FREQ);
+	writeb_relaxed(0x00, base + MIPHY_CONF);
+	writeb_relaxed(0x70, base + MIPHY_RX_LOCK_STEP);
+
+	writeb_relaxed(0x02, base + MIPHY_RX_SIGDET_SLEEP_OA);
+	writeb_relaxed(0x02, base + MIPHY_RX_SIGDET_SLEEP_SEL);
+	writeb_relaxed(0x02, base + MIPHY_RX_SIGDET_WAIT_SEL);
+	writeb_relaxed(0x0a, base + MIPHY_RX_SIGDET_DATA_SEL);
+
+	/* Writing The PLL Ratio */
+	writeb_relaxed(0xa6, base + MIPHY_PLL_CALSET_1);
+	writeb_relaxed(0xaa, base + MIPHY_PLL_CALSET_2);
+	writeb_relaxed(0xaa, base + MIPHY_PLL_CALSET_3);
+	writeb_relaxed(0x04, base + MIPHY_PLL_CALSET_4);
+	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_CTRL);
+
+	/* Writing The Speed Rate */
+	writeb_relaxed(0x00, base + MIPHY_CONF);
+	writeb_relaxed(0x0a, base + MIPHY_SPEED);
+
+	/* RX Channel compensation and calibration */
+	writeb_relaxed(0x1c, base + MIPHY_RX_LOCK_SETTINGS_OPT);
+	writeb_relaxed(0x51, base + MIPHY_RX_CAL_CTRL_1);
+	writeb_relaxed(0x70, base + MIPHY_RX_CAL_CTRL_2);
+	writeb_relaxed(0x5f, base + MIPHY_RX_CAL_OFFSET_CTRL);
+
+	/* Channel compensation and calibration */
+	writeb_relaxed(0x22, base + MIPHY_RX_CAL_VGA_STEP);
+	writeb_relaxed(0x0e, base + MIPHY_RX_CAL_OPT_LENGTH);
+
+	writeb_relaxed(0x05, base + MIPHY_RX_BUFFER_CTRL);
+	writeb_relaxed(0x78, base + MIPHY_RX_EQU_GAIN_1);
+	writeb_relaxed(0x1b, base + MIPHY_SYNCHAR_CONTROL);
+
+	/* Enable GENSEL_SEL and SSC */
+	/* TX_SEL=0 swing preemp forced by pipe registres */
+	writeb_relaxed(0x11, base + MIPHY_BOUNDARY_SEL);
+
+	/* MIPHY Bias boost */
+	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
+	writeb_relaxed(0xa7, base + MIPHY_BIAS_BOOST_2);
+
+	/* TX compensation offset to re-center TX impedance */
+	writeb_relaxed(0x02, base + MIPHY_COMP_POSTP);
+
+	/* SSC modulation */
+	writeb_relaxed(0x04, base + MIPHY_BOUNDARY_2);
+
+	/* MIPHY TX control */
+	writeb_relaxed(0x00, base + MIPHY_CONF);
+	writeb_relaxed(0x5a, base + MIPHY_PLL_SBR_3);
+	writeb_relaxed(0xa0, base + MIPHY_PLL_SBR_4);
+	writeb_relaxed(0x3c, base + MIPHY_PLL_SBR_2);
+	writeb_relaxed(0x00, base + MIPHY_PLL_SBR_1);
+	writeb_relaxed(0x02, base + MIPHY_PLL_SBR_1);
+	writeb_relaxed(0x00, base + MIPHY_PLL_SBR_1);
+
+	/* Rx PI controller settings */
+	writeb_relaxed(0xca, base + MIPHY_RX_K_GAIN);
+
+	/* MIPHY RX input bridge control */
+	/* INPUT_BRIDGE_EN_SW=1, manual input bridge control[0]=1 */
+	writeb_relaxed(0x21, base + MIPHY_RX_POWER_CTRL_1);
+	writeb_relaxed(0x29, base + MIPHY_RX_POWER_CTRL_1);
+	writeb_relaxed(0x1a, base + MIPHY_RX_POWER_CTRL_2);
+
+	/* MIPHY Reset */
+	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
+	writeb_relaxed(0x00, base + MIPHY_CONF_RESET);
+	writeb_relaxed(0x04, base + MIPHY_RESET);
+	writeb_relaxed(0x05, base + MIPHY_RESET);
+
+	writeb_relaxed(0x00, base + MIPHY_PLL_COMMON_MISC_2);
+	writeb_relaxed(0x1e, base + MIPHY_PLL_CLKREF_FREQ);
+	writeb_relaxed(0x40, base + MIPHY_COMP_FSM_1);
+	writeb_relaxed(0x01, base + MIPHY_RESET);
+
+	writeb_relaxed(0x00, base + MIPHY_RESET);
+	writeb_relaxed(0x40, base + MIPHY_PLL_COMMON_MISC_2);
+	writeb_relaxed(0x00, base + MIPHY_CONF);
+	writeb_relaxed(0x00, base + MIPHY_BOUNDARY_1);
+
+	writeb_relaxed(0x00, base + MIPHY_TST_BIAS_BOOST_2);
+	writeb_relaxed(0x00, base + MIPHY_CONF);
+	writeb_relaxed(0x02, base + MIPHY_PLL_SBR_1);
+	writeb_relaxed(0xa5, base + MIPHY_DEBUG_BUS);
+
+	writeb_relaxed(0x00, base + MIPHY_CONF);
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
+static int miphy28lp_get_resource_byname(struct device_node *child,
+					  char *rname, struct resource *res)
+{
+	int index;
+
+	index = of_property_match_string(child, "reg-names", rname);
+	if (index < 0)
+		return -ENODEV;
+
+	return of_address_to_resource(child, index, res);
+}
+
+static int miphy28lp_get_one_addr(struct device *dev,
+				  struct device_node *child, char *rname,
+				  void __iomem **base)
+{
+	struct resource res;
+	int ret;
+
+	ret = miphy28lp_get_resource_byname(child, rname, &res);
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
+	int err, sata_conf = SATA_CTRL_SELECT_SATA;
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
+	miphy28lp_configure_sata(miphy_phy);
+
+	if (miphy_phy->px_rx_pol_inv) {
+		/* Invert Rx polarity */
+		val = readb_relaxed(miphy_phy->base + MIPHY_CONTROL);
+		val |= MIPHY_PX_RX_POL;
+		writeb_relaxed(val, miphy_phy->base + MIPHY_CONTROL);
+	}
+
+	return miphy_is_ready(miphy_phy);
+}
+
+static int miphy28lp_init_pcie(struct miphy28lp_phy *miphy_phy)
+{
+	struct miphy28lp_dev *miphy_dev = miphy_phy->phydev;
+	unsigned long finish = jiffies + 5 * HZ;
+	int err;
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
+	/* initialize miphy */
+	miphy28lp_configure_pcie(miphy_phy);
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
+	int err;
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
+	/* initialize miphy */
+	miphy28lp_configure_usb3(miphy_phy);
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
+	if (!miphy28lp_get_resource_byname(np, "miphy-ctrl-glue", &res))
+		miphy_phy->syscfg_miphy_ctrl = res.start;
+
+	if (!miphy28lp_get_resource_byname(np, "miphy-status-glue", &res))
+		miphy_phy->syscfg_miphy_status = res.start;
+
+	if (!miphy28lp_get_resource_byname(np, "pcie-glue", &res))
+		miphy_phy->syscfg_pci = res.start;
+
+	if (!miphy28lp_get_resource_byname(np, "sata-glue", &res))
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

