Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaF3NC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:02:27 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63647 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaF3NCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:02:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Cc: lee.jones@linaro.org, kernel@stlinux.com,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH 3/5] phy: miphy365x: Provide support for the MiPHY356x Generic PHY
Date: Mon, 30 Jun 2014 14:01:55 +0100
Message-Id: <1404133317-25953-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
References: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
devices. It has 2 ports which it can use for either; both SATA, both
PCIe or one of each in any configuration.

Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/phy/Kconfig         |  10 +
 drivers/phy/Makefile        |   1 +
 drivers/phy/phy-miphy365x.c | 630 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 641 insertions(+)
 create mode 100644 drivers/phy/phy-miphy365x.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 16a2f06..5d54dcf 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -31,6 +31,16 @@ config PHY_MVEBU_SATA
 	depends on OF
 	select GENERIC_PHY
 
+config PHY_MIPHY365X
+	tristate "STMicroelectronics MIPHY365X PHY driver for STiH41x series"
+	depends on ARCH_STI
+	depends on GENERIC_PHY
+	depends on HAS_IOMEM
+	depends on OF
+	help
+	  Enable this to support the miphy transceiver (for SATA/PCIE)
+	  that is part of STMicroelectronics STiH41x SoC series.
+
 config OMAP_CONTROL_PHY
 	tristate "OMAP CONTROL PHY Driver"
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index b4f1d57..4602f67 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
+obj-$(CONFIG_PHY_MIPHY365X)		+= phy-miphy365x.o
 obj-$(CONFIG_OMAP_CONTROL_PHY)		+= phy-omap-control.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TI_PIPE3)			+= phy-ti-pipe3.o
diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
new file mode 100644
index 0000000..1109f42
--- /dev/null
+++ b/drivers/phy/phy-miphy365x.c
@@ -0,0 +1,630 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics
+ *
+ * STMicroelectronics PHY driver MiPHY365 (for SoC STiH416).
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
+#include <linux/clk.h>
+#include <linux/phy/phy.h>
+#include <linux/delay.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+
+#include <dt-bindings/phy/phy-miphy365x.h>
+
+#define HFC_TIMEOUT		50
+
+#define SYSCFG_2521		0x824
+#define SYSCFG_2522		0x828
+#define SYSCFG_PCIE_SATA_MASK	BIT(1)
+#define SYSCFG_PCIE_SATA_POS	1
+
+/* MiPHY365x register definitiona */
+#define RESET_REG		0x00
+#define RST_PLL			BIT(1)
+#define RST_PLL_CAL		BIT(2)
+#define RST_RX			BIT(4)
+#define RST_MACRO		BIT(7)
+
+#define STATUS_REG		0x01
+#define IDLL_RDY		BIT(0)
+#define PLL_RDY			BIT(1)
+#define DES_BIT_LOCK		BIT(2)
+#define DES_SYMBOL_LOCK		BIT(3)
+
+#define CTRL_REG		0x02
+#define TERM_EN			BIT(0)
+#define PCI_EN			BIT(2)
+#define DES_BIT_LOCK_EN		BIT(3)
+#define TX_POL			BIT(5)
+
+#define INT_CTRL_REG		0x03
+
+#define BOUNDARY1_REG		0x10
+#define SPDSEL_SEL		BIT(0)
+
+#define BOUNDARY3_REG		0x12
+#define TX_SPDSEL_GEN1_VAL	0
+#define TX_SPDSEL_GEN2_VAL	0x01
+#define TX_SPDSEL_GEN3_VAL	0x02
+#define RX_SPDSEL_GEN1_VAL	0
+#define RX_SPDSEL_GEN2_VAL	(0x01 << 3)
+#define RX_SPDSEL_GEN3_VAL	(0x02 << 3)
+
+#define PCIE_REG		0x16
+
+#define BUF_SEL_REG		0x20
+#define CONF_GEN_SEL_GEN3	0x02
+#define CONF_GEN_SEL_GEN2	0x01
+#define PD_VDDTFILTER		BIT(4)
+
+#define TXBUF1_REG		0x21
+#define SWING_VAL		0x04
+#define SWING_VAL_GEN1		0x03
+#define PREEMPH_VAL		(0x3 << 5)
+
+#define TXBUF2_REG		0x22
+#define TXSLEW_VAL		0x2
+#define TXSLEW_VAL_GEN1		0x4
+
+#define RXBUF_OFFSET_CTRL_REG	0x23
+
+#define RXBUF_REG		0x25
+#define SDTHRES_VAL		0x01
+#define EQ_ON3			(0x03 << 4)
+#define EQ_ON1			(0x01 << 4)
+
+#define COMP_CTRL1_REG		0x40
+#define START_COMSR		BIT(0)
+#define START_COMZC		BIT(1)
+#define COMSR_DONE		BIT(2)
+#define COMZC_DONE		BIT(3)
+#define COMP_AUTO_LOAD		BIT(4)
+
+#define COMP_CTRL2_REG		0x41
+#define COMP_2MHZ_RAT_GEN1	0x1e
+#define COMP_2MHZ_RAT		0xf
+
+#define COMP_CTRL3_REG		0x42
+#define COMSR_COMP_REF		0x33
+
+#define COMP_IDLL_REG		0x47
+#define COMZC_IDLL		0x2a
+
+#define PLL_CTRL1_REG		0x50
+#define PLL_START_CAL		BIT(0)
+#define BUF_EN			BIT(2)
+#define SYNCHRO_TX		BIT(3)
+#define SSC_EN			BIT(6)
+#define CONFIG_PLL		BIT(7)
+
+#define PLL_CTRL2_REG		0x51
+#define BYPASS_PLL_CAL		BIT(1)
+
+#define PLL_RAT_REG		0x52
+
+#define PLL_SSC_STEP_MSB_REG	0x56
+#define PLL_SSC_STEP_MSB_VAL	0x03
+
+#define PLL_SSC_STEP_LSB_REG	0x57
+#define PLL_SSC_STEP_LSB_VAL	0x63
+
+#define PLL_SSC_PER_MSB_REG	0x58
+#define PLL_SSC_PER_MSB_VAL	0
+
+#define PLL_SSC_PER_LSB_REG	0x59
+#define PLL_SSC_PER_LSB_VAL	0xf1
+
+#define IDLL_TEST_REG		0x72
+#define START_CLK_HF		BIT(6)
+
+#define DES_BITLOCK_REG		0x86
+#define BIT_LOCK_LEVEL		0x01
+#define BIT_LOCK_CNT_512	(0x03 << 5)
+
+static u8 ports[] = { MIPHY_PORT_0, MIPHY_PORT_1 };
+
+struct miphy365x {
+	struct phy *phy;
+	void __iomem *base;
+	void __iomem *sata;
+	void __iomem *pcie;
+	u8 type;
+	u8 port;
+};
+
+struct miphy365x_dev {
+	struct device *dev;
+	struct mutex miphy_mutex;
+	struct miphy365x phys[ARRAY_SIZE(ports)];
+	bool pcie_tx_pol_inv;
+	bool sata_tx_pol_inv;
+	u32 sata_gen;
+	struct regmap *regmap;
+};
+
+/*
+ * These values are represented in Device tree. They are considered to be ABI
+ * and although they can be extended any existing values must not change.
+ */
+enum miphy_sata_gen {
+	SATA_GEN1 = 1,
+	SATA_GEN2,
+	SATA_GEN3
+};
+
+static u8 rx_tx_spd[] = {
+	TX_SPDSEL_GEN1_VAL | RX_SPDSEL_GEN1_VAL,
+	TX_SPDSEL_GEN2_VAL | RX_SPDSEL_GEN2_VAL,
+	TX_SPDSEL_GEN3_VAL | RX_SPDSEL_GEN3_VAL
+};
+
+#define miphy365x_phy_to_dev(inst) \
+	container_of((inst), struct miphy365x_dev, phys[(inst)->port]);
+
+/*
+ * This function selects the system configuration,
+ * either two SATA, one SATA and one PCIe, or two PCIe lanes.
+ */
+static int miphy365x_set_path(struct miphy365x *miphy_phy,
+			      struct miphy365x_dev *miphy_dev)
+{
+	u8 config = miphy_phy->type | miphy_phy->port;
+	u32 mask  = SYSCFG_PCIE_SATA_MASK;
+	u32 reg;
+	bool sata;
+
+	switch (config) {
+	case MIPHY_SATA_PORT0:
+		reg = SYSCFG_2521;
+		sata = true;
+		break;
+	case MIPHY_PCIE_PORT1:
+		reg = SYSCFG_2522;
+		sata = false;
+		break;
+	default:
+		dev_err(miphy_dev->dev, "Configuration not supported\n");
+		return -EINVAL;
+	}
+
+	return regmap_update_bits(miphy_dev->regmap, reg, mask,
+				  sata << SYSCFG_PCIE_SATA_POS);
+}
+
+static void miphy365x_init_pcie_port(struct miphy365x *miphy_phy,
+				     struct miphy365x_dev *miphy_dev)
+{
+	u8 val;
+
+	if (!miphy_dev->pcie_tx_pol_inv)
+		return;
+
+	/* Invert Tx polarity and clear pci_txdetect_pol bit */
+	val = TERM_EN | PCI_EN | DES_BIT_LOCK_EN | TX_POL;
+	writeb_relaxed(val, miphy_phy->base + CTRL_REG);
+	writeb_relaxed(0x00, miphy_phy->base + PCIE_REG);
+}
+
+static inline int miphy365x_hfc_not_rdy(struct miphy365x *miphy_phy,
+					struct miphy365x_dev *miphy_dev)
+{
+	int timeout = HFC_TIMEOUT;
+	u8 mask = IDLL_RDY | PLL_RDY;
+	u8 regval;
+
+	do {
+		regval = readb_relaxed(miphy_phy->base + STATUS_REG);
+		usleep_range(2000, 2500);
+	} while (timeout-- && (regval & mask));
+
+	if (timeout < 0) {
+		dev_err(miphy_dev->dev, "HFC ready timeout!\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static inline int miphy365x_rdy(struct miphy365x *miphy_phy,
+				struct miphy365x_dev *miphy_dev)
+{
+	int timeout = HFC_TIMEOUT;
+	u8 mask = IDLL_RDY | PLL_RDY;
+	u8 regval;
+
+	do {
+		regval = readb_relaxed(miphy_phy->base + STATUS_REG);
+		usleep_range(2000, 2500);
+	} while (timeout-- && ((regval & mask) != mask));
+
+	if (timeout < 0) {
+		dev_err(miphy_dev->dev, "PHY not ready timeout!\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static inline void miphy365x_set_comp(struct miphy365x *miphy_phy,
+				      struct miphy365x_dev *miphy_dev)
+{
+	u8 val, mask;
+
+	if (miphy_dev->sata_gen == SATA_GEN1)
+		writeb_relaxed(COMP_2MHZ_RAT_GEN1,
+			       miphy_phy->base + COMP_CTRL2_REG);
+	else
+		writeb_relaxed(COMP_2MHZ_RAT,
+			       miphy_phy->base + COMP_CTRL2_REG);
+
+	if (miphy_dev->sata_gen != SATA_GEN3) {
+		writeb_relaxed(COMSR_COMP_REF,
+			       miphy_phy->base + COMP_CTRL3_REG);
+		/*
+		 * Force VCO current to value defined by address 0x5A
+		 * and disable PCIe100Mref bit
+		 * Enable auto load compensation for pll_i_bias
+		 */
+		writeb_relaxed(BYPASS_PLL_CAL, miphy_phy->base + PLL_CTRL2_REG);
+		writeb_relaxed(COMZC_IDLL, miphy_phy->base + COMP_IDLL_REG);
+	}
+
+	/*
+	 * Force restart compensation and enable auto load
+	 * for Comzc_Tx, Comzc_Rx and Comsr on macro
+	 */
+	val = START_COMSR | START_COMZC | COMP_AUTO_LOAD;
+	writeb_relaxed(val, miphy_phy->base + COMP_CTRL1_REG);
+
+	mask = COMSR_DONE | COMZC_DONE;
+	while ((readb_relaxed(miphy_phy->base + COMP_CTRL1_REG) & mask)	!= mask)
+		cpu_relax();
+}
+
+static inline void miphy365x_set_ssc(struct miphy365x *miphy_phy,
+				     struct miphy365x_dev *miphy_dev)
+{
+	u8 val;
+
+	/*
+	 * SSC Settings. SSC will be enabled through Link
+	 * SSC Ampl. = 0.4%
+	 * SSC Freq = 31KHz
+	 */
+	writeb_relaxed(PLL_SSC_STEP_MSB_VAL,
+		       miphy_phy->base + PLL_SSC_STEP_MSB_REG);
+	writeb_relaxed(PLL_SSC_STEP_LSB_VAL,
+		       miphy_phy->base + PLL_SSC_STEP_LSB_REG);
+	writeb_relaxed(PLL_SSC_PER_MSB_VAL,
+		       miphy_phy->base + PLL_SSC_PER_MSB_REG);
+	writeb_relaxed(PLL_SSC_PER_LSB_VAL,
+		       miphy_phy->base + PLL_SSC_PER_LSB_REG);
+
+	/* SSC Settings complete */
+	if (miphy_dev->sata_gen == SATA_GEN1) {
+		val = PLL_START_CAL | BUF_EN | SYNCHRO_TX | CONFIG_PLL;
+		writeb_relaxed(val, miphy_phy->base + PLL_CTRL1_REG);
+	} else {
+		val = SSC_EN | PLL_START_CAL | BUF_EN | SYNCHRO_TX | CONFIG_PLL;
+		writeb_relaxed(val, miphy_phy->base + PLL_CTRL1_REG);
+	}
+}
+
+static int miphy365x_init_sata_port(struct miphy365x *miphy_phy,
+				    struct miphy365x_dev *miphy_dev)
+{
+	int ret;
+	u8 val;
+
+	/*
+	 * Force PHY macro reset, PLL calibration reset, PLL reset
+	 * and assert Deserializer Reset
+	 */
+	val = RST_PLL | RST_PLL_CAL | RST_RX | RST_MACRO;
+	writeb_relaxed(val, miphy_phy->base + RESET_REG);
+
+	if (miphy_dev->sata_tx_pol_inv)
+		writeb_relaxed(TX_POL, miphy_phy->base + CTRL_REG);
+
+	/*
+	 * Force macro1 to use rx_lspd, tx_lspd
+	 * Force Rx_Clock on first I-DLL phase
+	 * Force Des in HP mode on macro, rx_lspd, tx_lspd for Gen2/3
+	 */
+	writeb_relaxed(SPDSEL_SEL, miphy_phy->base + BOUNDARY1_REG);
+	writeb_relaxed(START_CLK_HF, miphy_phy->base + IDLL_TEST_REG);
+	val = rx_tx_spd[miphy_dev->sata_gen];
+	writeb_relaxed(val, miphy_phy->base + BOUNDARY3_REG);
+
+	/* Wait for HFC_READY = 0 */
+	ret = miphy365x_hfc_not_rdy(miphy_phy, miphy_dev);
+	if (ret)
+		return ret;
+
+	/* Compensation Recalibration */
+	miphy365x_set_comp(miphy_phy, miphy_dev);
+
+	switch (miphy_dev->sata_gen) {
+	case SATA_GEN3:
+		/*
+		 * TX Swing target 550-600mv peak to peak diff
+		 * Tx Slew target 90-110ps rising/falling time
+		 * Rx Eq ON3, Sigdet threshold SDTH1
+		 */
+		val = PD_VDDTFILTER | CONF_GEN_SEL_GEN3;
+		writeb_relaxed(val, miphy_phy->base + BUF_SEL_REG);
+		val = SWING_VAL | PREEMPH_VAL;
+		writeb_relaxed(val, miphy_phy->base + TXBUF1_REG);
+		writeb_relaxed(TXSLEW_VAL, miphy_phy->base + TXBUF2_REG);
+		writeb_relaxed(0x00, miphy_phy->base + RXBUF_OFFSET_CTRL_REG);
+		val = SDTHRES_VAL | EQ_ON3;
+		writeb_relaxed(val, miphy_phy->base + RXBUF_REG);
+		break;
+	case SATA_GEN2:
+		/*
+		 * conf gen sel=0x1 to program Gen2 banked registers
+		 * VDDT filter ON
+		 * Tx Swing target 550-600mV peak-to-peak diff
+		 * Tx Slew target 90-110 ps rising/falling time
+		 * RX Equalization ON1, Sigdet threshold SDTH1
+		 */
+		writeb_relaxed(CONF_GEN_SEL_GEN2,
+			       miphy_phy->base + BUF_SEL_REG);
+		writeb_relaxed(SWING_VAL, miphy_phy->base + TXBUF1_REG);
+		writeb_relaxed(TXSLEW_VAL, miphy_phy->base + TXBUF2_REG);
+		val = SDTHRES_VAL | EQ_ON1;
+		writeb_relaxed(val, miphy_phy->base + RXBUF_REG);
+		break;
+	case SATA_GEN1:
+		/*
+		 * conf gen sel = 00b to program Gen1 banked registers
+		 * VDDT filter ON
+		 * Tx Swing target 500-550mV peak-to-peak diff
+		 * Tx Slew target120-140 ps rising/falling time
+		 */
+		writeb_relaxed(PD_VDDTFILTER, miphy_phy->base + BUF_SEL_REG);
+		writeb_relaxed(SWING_VAL_GEN1, miphy_phy->base + TXBUF1_REG);
+		writeb_relaxed(TXSLEW_VAL_GEN1,	miphy_phy->base + TXBUF2_REG);
+		break;
+	default:
+		break;
+	}
+
+	/* Force Macro1 in partial mode & release pll cal reset */
+	writeb_relaxed(RST_RX, miphy_phy->base + RESET_REG);
+	usleep_range(100, 150);
+
+	miphy365x_set_ssc(miphy_phy, miphy_dev);
+
+	/* Wait for phy_ready */
+	ret = miphy365x_rdy(miphy_phy, miphy_dev);
+	if (ret)
+		return ret;
+
+	/*
+	 * Enable macro1 to use rx_lspd & tx_lspd
+	 * Release Rx_Clock on first I-DLL phase on macro1
+	 * Assert deserializer reset
+	 * des_bit_lock_en is set
+	 * bit lock detection strength
+	 * Deassert deserializer reset
+	 */
+	writeb_relaxed(0x00, miphy_phy->base + BOUNDARY1_REG);
+	writeb_relaxed(0x00, miphy_phy->base + IDLL_TEST_REG);
+	writeb_relaxed(RST_RX, miphy_phy->base + RESET_REG);
+	val = miphy_dev->sata_tx_pol_inv ?
+		(TX_POL | DES_BIT_LOCK_EN) : DES_BIT_LOCK_EN;
+	writeb_relaxed(val, miphy_phy->base + CTRL_REG);
+
+	val = BIT_LOCK_CNT_512 | BIT_LOCK_LEVEL;
+	writeb_relaxed(val, miphy_phy->base + DES_BITLOCK_REG);
+	writeb_relaxed(0x00, miphy_phy->base + RESET_REG);
+
+	return 0;
+}
+
+static int miphy365x_init(struct phy *phy)
+{
+	int ret = 0;
+	struct miphy365x *miphy_phy = phy_get_drvdata(phy);
+	struct miphy365x_dev *miphy_dev = miphy365x_phy_to_dev(miphy_phy);
+
+	mutex_lock(&miphy_dev->miphy_mutex);
+
+	ret = miphy365x_set_path(miphy_phy, miphy_dev);
+	if (ret) {
+		mutex_unlock(&miphy_dev->miphy_mutex);
+		return ret;
+	}
+
+	/* Initialise Miphy for PCIe or SATA */
+	if (miphy_phy->type == MIPHY_TYPE_PCIE)
+		miphy365x_init_pcie_port(miphy_phy, miphy_dev);
+	else
+		ret = miphy365x_init_sata_port(miphy_phy, miphy_dev);
+
+	mutex_unlock(&miphy_dev->miphy_mutex);
+
+	return ret;
+}
+
+static struct phy *miphy365x_xlate(struct device *dev,
+				   struct of_phandle_args *args)
+{
+	struct miphy365x_dev *state = dev_get_drvdata(dev);
+	u8 port, type;
+
+	if (args->count != 2) {
+		dev_err(dev, "Invalid number of cells in 'phy' property\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (args->args[0] & 0xFFFFFF00 || args->args[1] & 0xFFFFFF00) {
+		dev_err(dev, "Unsupported flags set in 'phy' property\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	port = args->args[0];
+	type = args->args[1];
+
+	if (WARN_ON(port >= ARRAY_SIZE(ports)))
+		return ERR_PTR(-EINVAL);
+
+	if (type == MIPHY_TYPE_SATA)
+		state->phys[port].base = state->phys[port].sata;
+	else if (type == MIPHY_TYPE_PCIE)
+		state->phys[port].base = state->phys[port].pcie;
+	else {
+		WARN(1, "Invalid type specified in DT");
+		return ERR_PTR(-EINVAL);
+	}
+
+	state->phys[port].type = type;
+
+	return state->phys[port].phy;
+}
+
+static struct phy_ops miphy365x_ops = {
+	.init		= miphy365x_init,
+	.owner		= THIS_MODULE,
+};
+
+static int miphy365x_get_base_addr(struct platform_device *pdev,
+				    struct miphy365x_phy *phy, u8 port)
+{
+	struct resource *res;
+	char type[6];
+
+	sprintf(type, "sata%d", port);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, type);
+	if (!res)
+		return -ENODEV;
+
+	phy->sata = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!phy->sata)
+		return -ENOMEM;
+
+	sprintf(type, "pcie%d", port);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, type);
+	if (!res)
+		return -ENODEV;
+
+	phy->pcie = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!phy->pcie)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int miphy365x_of_probe(struct device_node *np,
+			      struct miphy365x_dev *phy_dev)
+{
+	phy_dev->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
+	if (IS_ERR(phy_dev->regmap)) {
+		dev_err(phy_dev->dev, "No syscfg phandle specified\n");
+		return PTR_ERR(phy_dev->regmap);
+	}
+
+	of_property_read_u32(np, "st,sata-gen", &phy_dev->sata_gen);
+	if (!phy_dev->sata_gen)
+		phy_dev->sata_gen = SATA_GEN1;
+
+	phy_dev->pcie_tx_pol_inv =
+		of_property_read_bool(np, "st,pcie-tx-pol-inv");
+
+	phy_dev->sata_tx_pol_inv =
+		of_property_read_bool(np, "st,sata-tx-pol-inv");
+
+	return 0;
+}
+
+static int miphy365x_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct miphy365x_dev *phy_dev;
+	struct device *dev = &pdev->dev;
+	struct phy_provider *provider;
+	u8 port;
+	int ret;
+
+	if (!np) {
+		dev_err(dev, "No DT node found\n");
+		return -EINVAL;
+	}
+
+	phy_dev = devm_kzalloc(dev, sizeof(*phy_dev), GFP_KERNEL);
+	if (!phy_dev)
+		return -ENOMEM;
+
+	ret = miphy365x_of_probe(np, phy_dev);
+	if (ret)
+		return ret;
+
+	phy_dev->dev = dev;
+
+	dev_set_drvdata(dev, phy_dev);
+
+	mutex_init(&phy_dev->miphy_mutex);
+
+	for (port = 0; port < ARRAY_SIZE(ports); port++) {
+		struct phy *phy;
+
+		phy = devm_phy_create(dev, &miphy365x_ops, NULL);
+		if (IS_ERR(phy)) {
+			dev_err(dev, "failed to create PHY on port %d\n", port);
+			return PTR_ERR(phy);
+		}
+
+		phy_dev->phys[port].phy  = phy;
+		phy_dev->phys[port].port = port;
+
+		ret = miphy365x_get_base_addr(pdev,
+					&phy_dev->phys[port], port);
+		if (ret)
+			return ret;
+
+		phy_set_drvdata(phy, &phy_dev->phys[port]);
+	}
+
+	provider = devm_of_phy_provider_register(dev, miphy365x_xlate);
+	if (IS_ERR(provider))
+		return PTR_ERR(provider);
+
+	return 0;
+}
+
+static const struct of_device_id miphy365x_of_match[] = {
+	{ .compatible = "st,miphy365x-phy", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, miphy365x_of_match);
+
+static struct platform_driver miphy365x_driver = {
+	.probe	= miphy365x_probe,
+	.driver = {
+		.name	= "miphy365x-phy",
+		.owner	= THIS_MODULE,
+		.of_match_table	= miphy365x_of_match,
+	}
+};
+module_platform_driver(miphy365x_driver);
+
+MODULE_AUTHOR("Alexandre Torgue <alexandre.torgue@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics miphy365x driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

