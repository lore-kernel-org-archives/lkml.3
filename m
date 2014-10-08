Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaJHF1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 01:27:51 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:18093 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbaJHF1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 01:27:45 -0400
X-IronPort-AV: E=Sophos;i="5.04,675,1406617200"; 
   d="scan'208";a="47909455"
From: Scott Branden <sbranden@broadcom.com>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
CC: JD Zheng <jdzheng@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Subject: [PATCH 2/6] clk: Clock driver support for Broadcom Cygnus SoC
Date: Tue, 7 Oct 2014 22:27:01 -0700
Message-ID: <1412746025-11998-3-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412746025-11998-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1412746025-11998-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Richardson <jonathar@broadcom.com>

The iProc clock driver controls PLLs common across iProc chips. The
cygnus driver controls cygnus specific features and variations.

Reviewed-by: Ray Jui <rjui@broadcom.com>
Tested-by: Jonathan Richardson <jonathar@broadcom.com>
Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/clk/Makefile         |    1 +
 drivers/clk/bcm/Makefile     |    2 +
 drivers/clk/bcm/clk-cygnus.c | 1186 ++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/bcm/clk-iproc.c  |  451 ++++++++++++++++
 4 files changed, 1640 insertions(+)
 create mode 100644 drivers/clk/bcm/clk-cygnus.c
 create mode 100644 drivers/clk/bcm/clk-iproc.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index f537a0b..8ac0a31 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_ARCH_VT8500)		+= clk-vt8500.o
 obj-$(CONFIG_COMMON_CLK_WM831X)		+= clk-wm831x.o
 obj-$(CONFIG_COMMON_CLK_XGENE)		+= clk-xgene.o
 obj-$(CONFIG_COMMON_CLK_AT91)		+= at91/
+obj-$(CONFIG_ARCH_BCM_IPROC)	+= bcm/
 obj-$(CONFIG_ARCH_BCM_MOBILE)		+= bcm/
 obj-$(CONFIG_ARCH_BERLIN)		+= berlin/
 obj-$(CONFIG_ARCH_HI3xxx)		+= hisilicon/
diff --git a/drivers/clk/bcm/Makefile b/drivers/clk/bcm/Makefile
index 6297d05..f803919 100644
--- a/drivers/clk/bcm/Makefile
+++ b/drivers/clk/bcm/Makefile
@@ -2,3 +2,5 @@ obj-$(CONFIG_CLK_BCM_KONA)	+= clk-kona.o
 obj-$(CONFIG_CLK_BCM_KONA)	+= clk-kona-setup.o
 obj-$(CONFIG_CLK_BCM_KONA)	+= clk-bcm281xx.o
 obj-$(CONFIG_CLK_BCM_KONA)	+= clk-bcm21664.o
+obj-$(CONFIG_ARCH_BCM_IPROC)	+= clk-iproc.o
+obj-$(CONFIG_ARCH_BCM_CYGNUS)	+= clk-cygnus.o
diff --git a/drivers/clk/bcm/clk-cygnus.c b/drivers/clk/bcm/clk-cygnus.c
new file mode 100644
index 0000000..2a4f976
--- /dev/null
+++ b/drivers/clk/bcm/clk-cygnus.c
@@ -0,0 +1,1186 @@
+/*
+ * Copyright 2014 Broadcom Corporation.  All rights reserved.
+ *
+ * Unless you and Broadcom execute a separate written software license
+ * agreement governing use of this software, this software is licensed to you
+ * under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/clkdev.h>
+#include <linux/of_address.h>
+
+/*
+ * The CRU contains two similar PLLs: LCPLL and GENPLL,
+ * both with several output channels divided from the PLL
+ * output.
+ */
+
+#define CRU_LCPLL_CONTROL1_OFFSET  0x04
+#define CRU_LCPLL_STATUS_OFFSET    0x18
+
+#define LCPLL0_PDIV_SHIFT       26
+#define LCPLL0_PDIV_MASK        0xf
+#define LCPLL0_NDIV_SHIFT       16
+#define LCPLL0_NDIV_MASK        0x3ff
+#define LCPLL_ENABLEB_CH_SHIFT  7
+#define LCPLL_ENABLEB_CH_MASK   0x3f
+#define LCPLL_MDIV_MASK         0xff
+#define LCPLL_STATUS_LOCK_SHIFT 12
+
+#define LCPLL0_CONTROL0_OFFSET  0x00
+#define LCPLL0_CONTROL1_OFFSET  0x04
+#define LCPLL0_CONTROL2_OFFSET  0x08
+#define LCPLL0_CONTROL3_OFFSET  0x0c
+
+#define GENPLL_CONTROL0_OFFSET 0x00
+#define GENPLL_CONTROL1_OFFSET 0x04
+#define GENPLL_CONTROL2_OFFSET 0x08
+#define GENPLL_CONTROL3_OFFSET 0x0c
+#define GENPLL_CONTROL4_OFFSET 0x10
+#define GENPLL_CONTROL5_OFFSET 0x14
+#define GENPLL_CONTROL6_OFFSET 0x18
+#define GENPLL_CONTROL7_OFFSET 0x1c
+#define GENPLL_CONTROL8_OFFSET 0x20
+#define GENPLL_CONTROL9_OFFSET 0x24
+#define GENPLL_STATUS_OFFSET   0x28
+
+#define GENPLL_ENABLEB_CH_SHIFT    0x6
+#define GENPLL_ENABLEB_CH_MASK     0x3f
+
+#define GENPLL_STATUS_LOCK_SHIFT           12
+#define GENPLL_STATUS_LOCK_MASK            1
+#define GENPLL_CONTROL4_NDIV_INT_SHIFT     20
+#define GENPLL_CONTROL4_NDIV_INT_MASK      0x3FF
+#define GENPLL_CONTROL4_NDIV_FRAC_SHIFT    0
+#define GENPLL_CONTROL4_NDIV_FRAC_MASK     0xFFFFF
+#define GENPLL_CONTROL5_PDIV_SHIFT         0
+#define GENPLL_CONTROL5_PDIV_MASK          0xF
+#define GENPLL_MDIV_MASK                   0xff
+
+#define MIPI_DSI_GENPLL_ENABLEB_CH_SHIFT   12
+#define NDIV_FRAC_DIVISOR                  0x100000
+
+#define ASIU_MIPI_GENPLL_PWRON_SHIFT      20
+#define ASIU_MIPI_GENPLL_PWRON_PLL_SHIFT  19
+#define ASIU_MIPI_GENPLL_PWRON_BG_SHIFT   18
+#define ASIU_MIPI_GENPLL_PWRON_LDO_SHIFT  17
+#define ASIU_MIPI_GENPLL_ISO_IN_SHIFT     16
+#define ASIU_AUDIO_GENPLL_PWRON_PLL_SHIFT 11
+#define ASIU_AUDIO_GENPLL_PWRON_BG_SHIFT  10
+#define ASIU_AUDIO_GENPLL_PWRON_LDO_SHIFT 9
+#define ASIU_AUDIO_GENPLL_ISO_IN          8
+
+#define CLK_RATE_NO_DIV                   -1
+
+/*
+ * The clock framework may call recalc even if a clock is is unused, and
+ * therefore before being prepared/enabled. State checking is done for the
+ * MIPI PLL to prevent reading from a MIPI DSI register before the PLL is
+ * powered up because it will cause corruption (imprecise external aborts)
+ * sometimer later on.
+ */
+enum clock_state {
+	CLK_ENABLED,
+	CLK_PREPARED,
+	CLK_DISABLED
+};
+
+struct cygnus_clk {
+	struct clk_hw   hw;
+	void __iomem    *regs_base;
+	void __iomem    *pll_ctrl_reg;
+	void __iomem    *clock_gate_ctrl_reg;
+	int             chan;
+	int             internal_div;
+	unsigned long   rate;
+	enum clock_state state;
+};
+
+#define to_cygnus_clk(p) container_of(p, struct cygnus_clk, hw)
+
+/* Identifies LCPLL clock channels. */
+enum cygnus_lcpll_clk_chan {
+	LCPLL_CH0_PCIE_PHY_REF_CLK      = 0,
+	LCPLL_CH1_DDR_CLK               = 1,
+	LCPLL_CH2_SDIO_CLK              = 2,
+	LCPLL_CH3_USB_PHY_REF_CLK       = 3,
+	LCPLL_CH4_ASIU_SMART_CARD_CLK   = 4,
+	LCPLL_CH5                       = 5
+};
+
+/* Identifies GENPLL clock channels. */
+enum cygnus_genpll_clk_chan {
+	GENPLL_CH0_AXI21_CLK      = 0,
+	GENPLL_CH1_25MHZ_CLK      = 1,
+	GENPLL_CH2_SYS_CLK        = 2,
+	GENPLL_CH3_ETHERNET_CLK   = 3,
+	GENPLL_CH4_ASIU_AUDIO_CLK = 4,
+	GENPLL_CH5_ASIU_CAN_CLK   = 5
+};
+
+/*
+ * Channels for Oscillator dervived clocks are values used to determine
+ * which clock to enable/disable from the top clock gating control.
+ */
+enum cygnus_osc_derived_clk_chan {
+	OSC_DERIVED_CH0_KEYPAD_CLK = 0,
+	OSC_DERIVED_CH1_ADC_CLK    = 1,
+	OSC_DERIVED_CH2_PWM_CLK    = 2,
+};
+
+enum cygnus_mipi_pll_clk_chan {
+	MIPI_PLL_CH0_MIPI_PHY_CLK    = 0,
+	MIPI_PLL_CH1_LCD_CLK         = 1,
+	MIPI_PLL_CH2_3D_GRAPHICS_CLK = 2,
+};
+
+/* Order of registers defined in DT. */
+enum cygnus_clk_dt_regs {
+	CYGNUS_CLK_BASE_REG = 0,
+	CYGNUS_CLK_GATE_CTRL_REG,
+	CYGNUS_PLL_CTRL_REG
+};
+
+enum cygnus_top_clk_gating_ctrl_offsets {
+	GFX_CLK_GATE_EN = 0,
+	AUD_CLK_GATE_EN,
+	CAM_CLK_GATE_EN,
+	MIPI_DSI_CLK_GATE_EN,
+	LCD_CLK_GATE_EN,
+	D1W_CLK_GATE_EN,
+	CAN_CLK_GATE_EN,
+	KEYPAD_CLK_GATE_EN,
+	SMARTCARD_CLK_GATE_EN,
+	ADC_CLK_GATE_EN,
+	CRYPTO_CLK_GATE_EN
+};
+
+/*
+ * Enable clocks controlled through the top clock gating control.
+ *
+ * @param enable true = enable clock, false = disable clock
+ */
+static void cygnus_clkgate_enable_disable(void __iomem *clkgate_reg,
+	enum cygnus_top_clk_gating_ctrl_offsets offset, bool enable)
+{
+	u32 val = readl(clkgate_reg);
+
+	/* Enable or disable the clock. */
+	if (enable)
+		val |= 1 << offset;
+	else
+		val &= ~(1 << offset);
+
+	writel(val, clkgate_reg);
+}
+
+/*
+ * Powers on/off the MIPI GENPLL using CRMU_PLL_AON_CTRL register.
+ *
+ * @param power_on true to power on PLL, false to power off
+ */
+static void cygnus_mipi_genpll_power_on_off(void __iomem *pll_ctrl_reg,
+	bool power_on)
+{
+	u32 val;
+	u32 pll_ldo_on = ((1 << ASIU_MIPI_GENPLL_PWRON_SHIFT) |
+		(1 << ASIU_MIPI_GENPLL_PWRON_PLL_SHIFT) |
+		(1 << ASIU_MIPI_GENPLL_PWRON_BG_SHIFT)  |
+		(1 << ASIU_MIPI_GENPLL_PWRON_LDO_SHIFT));
+
+	val = readl(pll_ctrl_reg);
+
+	/*
+	 * Set PLL on/off. Set input isolation mode to 1 when disabled, 0 when
+	 * enabled.
+	 */
+	if (power_on) {
+		val |= pll_ldo_on;
+		val &= ~(1 << ASIU_MIPI_GENPLL_ISO_IN_SHIFT);
+	} else {
+		val &= ~pll_ldo_on;
+		val |= 1 << ASIU_MIPI_GENPLL_ISO_IN_SHIFT;
+	}
+
+	writel(val, pll_ctrl_reg);
+}
+
+/*
+ * Powers on/off the audio PLL using CRMU_PLL_AON_CTRL register.
+ *
+ * @param power_on true to power on PLL, false to power off
+ */
+static void cygnus_audio_genpll_power_on_off(void __iomem *pll_ctrl_reg,
+	bool power_on)
+{
+	u32 val;
+	u32 pll_ldo_on = ((1 << ASIU_AUDIO_GENPLL_PWRON_PLL_SHIFT) |
+		(1 << ASIU_AUDIO_GENPLL_PWRON_BG_SHIFT) |
+		(1 << ASIU_AUDIO_GENPLL_PWRON_LDO_SHIFT));
+
+	val = readl(pll_ctrl_reg);
+
+	/*
+	 * Set PLL on/off. Set input isolation mode to 1 when disabled, 0 when
+	 * enabled.
+	 */
+	if (power_on) {
+		val |= pll_ldo_on;
+		val &= ~(1 << ASIU_AUDIO_GENPLL_ISO_IN);
+	} else {
+		val &= ~pll_ldo_on;
+		val |= 1 << ASIU_AUDIO_GENPLL_ISO_IN;
+	}
+
+	writel(val, pll_ctrl_reg);
+}
+
+/*
+ * Get PLL running status and calculate output frequency
+ */
+static unsigned long cygnus_lcpll_status(struct cygnus_clk *clk,
+	unsigned long parent_rate)
+{
+	u32 reg;
+	unsigned pdiv, ndiv;
+
+	/* read status register */
+	reg = readl(clk->regs_base + CRU_LCPLL_STATUS_OFFSET);
+
+	/* Must be locked for proper PLL operation. */
+	if ((reg & (1 << LCPLL_STATUS_LOCK_SHIFT)) == 0) {
+		clk->rate = 0;
+		return -EIO;
+	}
+
+	/*
+	 * Calculate PLL frequency based on LCPLL divider values:
+	 *	 pdiv = LCPLL pre-divider ratio
+	 *   ndiv = LCPLL feedback divider
+	 *
+	 * The frequency is calculated by:
+	 *   ndiv * (parent clock rate / pdiv)
+	 */
+
+	reg = readl(clk->regs_base + CRU_LCPLL_CONTROL1_OFFSET);
+
+	/* feedback divider integer and fraction parts */
+	pdiv = (reg >> LCPLL0_PDIV_SHIFT) & LCPLL0_PDIV_MASK;
+	ndiv = (reg >> LCPLL0_NDIV_SHIFT) & LCPLL0_NDIV_MASK;
+
+	if (pdiv == 0)
+		return -EIO;
+
+	clk->rate = ndiv * (parent_rate / pdiv);
+
+	return clk->rate;
+}
+
+static unsigned long cygnus_lcpll_clk_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct cygnus_clk *bcm_clk = to_cygnus_clk(hwclk);
+
+	return cygnus_lcpll_status(bcm_clk, parent_rate);
+}
+
+static const struct clk_ops cygnus_lcpll_ops = {
+	.recalc_rate = cygnus_lcpll_clk_recalc_rate,
+};
+
+static int cygnus_lcpll_chan_status(struct cygnus_clk *clk,
+	unsigned long parent_rate)
+{
+	void * __iomem base;
+	u32 reg;
+	unsigned enable;
+	unsigned mdiv;
+	int offset = 0;
+	int shift = 0;
+
+	/* Register address is only stored in PLL structure */
+	base = clk->regs_base;
+	BUG_ON(base == NULL);
+
+	/* enable bit is in enableb_ch[] inversed */
+	enable = ((readl(base + LCPLL0_CONTROL0_OFFSET) >>
+		LCPLL_ENABLEB_CH_SHIFT) & LCPLL_ENABLEB_CH_MASK) ^
+		LCPLL_ENABLEB_CH_MASK;
+
+	if ((enable & (1 << clk->chan)) == 0) {
+		clk->rate = 0;
+		return -EIO;
+	}
+
+	/* MDIV for the 6 channels is spread over two registers. */
+	switch (clk->chan) {
+	case LCPLL_CH0_PCIE_PHY_REF_CLK:
+		offset = LCPLL0_CONTROL2_OFFSET; shift = 0;
+		break;
+
+	case LCPLL_CH1_DDR_CLK:
+		offset = LCPLL0_CONTROL2_OFFSET; shift = 10;
+		break;
+
+	case LCPLL_CH2_SDIO_CLK:
+		offset = LCPLL0_CONTROL2_OFFSET; shift = 20;
+		break;
+
+	case LCPLL_CH3_USB_PHY_REF_CLK:
+		offset = LCPLL0_CONTROL3_OFFSET; shift = 0;
+		break;
+
+	case LCPLL_CH4_ASIU_SMART_CARD_CLK:
+		offset = LCPLL0_CONTROL3_OFFSET; shift = 10;
+		break;
+
+	case LCPLL_CH5:
+		offset = LCPLL0_CONTROL3_OFFSET; shift = 20;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/* Read MDIV for requested channel. */
+	reg = readl(base + offset);
+	mdiv = (reg >> shift) & LCPLL_MDIV_MASK;
+
+	/* when divisor is 0, it behaves as max+1 */
+	if (mdiv == 0)
+		mdiv = 256;
+
+	clk->rate = parent_rate / mdiv;
+
+	pr_debug("LCPLL[%d] mdiv=%u Prate=%lu rate=%lu\n",
+		clk->chan, mdiv, parent_rate, clk->rate);
+
+	return clk->rate;
+}
+
+static unsigned long cygnus_lcpll_chan_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct cygnus_clk *bcm_clk = to_cygnus_clk(hwclk);
+
+	return cygnus_lcpll_chan_status(bcm_clk, parent_rate);
+}
+
+static const struct clk_ops cygnus_lcpll_chan_ops = {
+	.recalc_rate = cygnus_lcpll_chan_recalc_rate,
+};
+
+/*
+ * Get PLL running status and calculate output frequency
+ */
+static unsigned long cygnus_genpll_status(struct cygnus_clk *clk,
+	unsigned long parent_rate)
+{
+	u32 reg;
+	unsigned pdiv;
+	unsigned ndiv_int;
+	unsigned ndiv_frac;
+
+	/* Read PLL status register. It must be locked. */
+	reg = readl(clk->regs_base + GENPLL_STATUS_OFFSET);
+	if ((reg & (1 << GENPLL_STATUS_LOCK_SHIFT)) == 0) {
+		clk->rate = 0;
+		return -EIO;
+	}
+
+	/* Calculate PLL frequency */
+
+	/* Get PLL feedback divider values. */
+	reg = readl(clk->regs_base + GENPLL_CONTROL4_OFFSET);
+
+	/* feedback divider integer and fraction parts */
+	ndiv_int = reg >> GENPLL_CONTROL4_NDIV_INT_SHIFT;
+	ndiv_frac = reg & GENPLL_CONTROL4_NDIV_INT_MASK;
+	ndiv_int += ndiv_frac / NDIV_FRAC_DIVISOR;
+
+	/* Get pdiv - first 4 bits. */
+	reg = readl(clk->regs_base + GENPLL_CONTROL5_OFFSET);
+	pdiv = reg & GENPLL_CONTROL5_PDIV_MASK;
+	if (pdiv == 0)
+		return -EIO;
+
+	clk->rate = (parent_rate / pdiv) * ndiv_int;
+
+	return clk->rate;
+}
+
+static unsigned long cygnus_genpll_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct cygnus_clk *bcm_clk = to_cygnus_clk(hwclk);
+
+	return cygnus_genpll_status(bcm_clk, parent_rate);
+}
+
+static const struct clk_ops cygnus_genpll_ops = {
+	.recalc_rate = cygnus_genpll_recalc_rate,
+};
+
+/*
+ * Calculates clock rate of the GENPLL channel requested. The clock rate is
+ * calculated as: the configured clock rate
+ *     Parent clock rate / mdiv
+ */
+static unsigned long cygnus_genpll_chan_get_rate(struct cygnus_clk *clk,
+	unsigned long parent_rate, int enableb_ch_shift)
+{
+	u32 reg;
+	unsigned enable;
+	unsigned mdiv;
+	unsigned offset = 0;
+	unsigned shift = 0;
+
+	/*
+	 * Read ENABLEB_CH to determine which channels are enabled. The enable
+	 * bits are inversed: 0 = channel enabled, 1 = channel disabled.
+	 */
+	reg = readl(clk->regs_base + GENPLL_CONTROL1_OFFSET);
+	enable = ((reg >> enableb_ch_shift) &
+		GENPLL_ENABLEB_CH_MASK) ^ GENPLL_ENABLEB_CH_MASK;
+
+	/* If channel is disabled the rate is 0. */
+	if ((enable & (1 << clk->chan)) == 0) {
+		clk->rate = 0;
+		return -EIO;
+	}
+
+	/* MDIV for the 6 channels is spread over two registers. */
+	switch (clk->chan) {
+	case 0:
+		offset = GENPLL_CONTROL8_OFFSET; shift = 0;
+		break;
+
+	case 1:
+		offset = GENPLL_CONTROL8_OFFSET; shift = 10;
+		break;
+
+	case 2:
+		offset = GENPLL_CONTROL8_OFFSET; shift = 20;
+		break;
+
+	case 3:
+		offset = GENPLL_CONTROL9_OFFSET; shift = 0;
+		break;
+
+	case 4:
+		offset = GENPLL_CONTROL9_OFFSET; shift = 10;
+		break;
+
+	case 5:
+		offset = GENPLL_CONTROL9_OFFSET; shift = 20;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/* Read MDIV (post divider ratio) for requested channel. */
+	reg = readl(clk->regs_base + offset);
+	mdiv = (reg >> shift) & GENPLL_MDIV_MASK;
+
+	/* When divisor is 0, it behaves as max+1. */
+	if (mdiv == 0)
+		mdiv = 256;
+
+	clk->rate = parent_rate / mdiv;
+
+	pr_debug("GENPLL[%d] mdiv=%u parent rate=%lu rate=%lu\n",
+		clk->chan, mdiv, parent_rate, clk->rate);
+
+	return clk->rate;
+}
+
+/*
+ * Powers on the audio PLL for the audio channel from the PLL. No other
+ * GENPLL channels require powering on.
+ */
+static int cygnus_genpll_chan_prepare(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+	struct clk *parent_clk = clk_get_parent(hwclk->clk);
+	struct cygnus_clk *cyg_parent_clk =
+		to_cygnus_clk(__clk_get_hw(parent_clk));
+
+	if (WARN_ON(!cyg_parent_clk->pll_ctrl_reg))
+		return -EIO;
+
+	if (clk->chan == GENPLL_CH4_ASIU_AUDIO_CLK) {
+		pr_debug("GENPLL[%d]: Powering on audio PLL/LDO\n", clk->chan);
+		cygnus_audio_genpll_power_on_off(
+			cyg_parent_clk->pll_ctrl_reg, true);
+	}
+
+	return 0;
+}
+
+/*
+ * Powers off the audio PLL for the audio channel from the PLL. No other
+ * GENPLL channels require powering off.
+ */
+static void cygnus_genpll_chan_unprepare(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+	struct clk *parent_clk = clk_get_parent(hwclk->clk);
+	struct cygnus_clk *cyg_parent_clk =
+		to_cygnus_clk(__clk_get_hw(parent_clk));
+
+	if (WARN_ON(!cyg_parent_clk->pll_ctrl_reg))
+		return;
+
+	if (clk->chan == GENPLL_CH4_ASIU_AUDIO_CLK) {
+		pr_debug("GENPLL[%d]: Powering down audio PLL and LDO\n",
+			clk->chan);
+		cygnus_audio_genpll_power_on_off(cyg_parent_clk->pll_ctrl_reg,
+			false);
+	}
+}
+
+static unsigned long cygnus_genpll_chan_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct cygnus_clk *bcm_clk = to_cygnus_clk(hwclk);
+
+	return cygnus_genpll_chan_get_rate(bcm_clk, parent_rate,
+		GENPLL_ENABLEB_CH_SHIFT);
+}
+
+/*
+ * Enables GENPLL channels. The only PLL channel that is controlled through
+ * the top clock gating control is the audio clock which requires enabling.
+ *
+ * Individual channels aren't enabled/disabled on the PLL because they are
+ * enabled by default and drivers don't always refer to them, meaning the
+ * clock framework would disable them. This can be added later when power
+ * saving is a concern.
+ */
+static int cygnus_genpll_chan_enable(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+	struct clk *parent_clk = clk_get_parent(hwclk->clk);
+	struct cygnus_clk *cyg_parent_clk =
+		to_cygnus_clk(__clk_get_hw(parent_clk));
+	int parent_rate;
+
+	if (WARN_ON(!cyg_parent_clk->clock_gate_ctrl_reg))
+		return -EIO;
+
+	pr_debug("Enable GENPLL chan %d\n", clk->chan);
+
+	if (clk->chan == GENPLL_CH4_ASIU_AUDIO_CLK) {
+		cygnus_clkgate_enable_disable(
+			cyg_parent_clk->clock_gate_ctrl_reg,
+			AUD_CLK_GATE_EN, true);
+
+		/* Ensure parent's clock rate is calculated. */
+		parent_rate = clk_get_rate(parent_clk);
+		if (WARN_ON(!parent_rate))
+			return -EIO;
+	}
+
+	return 0;
+}
+
+static void cygnus_genpll_chan_disable(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+	struct clk *parent_clk = clk_get_parent(hwclk->clk);
+	struct cygnus_clk *cyg_parent_clk =
+		to_cygnus_clk(__clk_get_hw(parent_clk));
+
+	if (WARN_ON(!cyg_parent_clk->clock_gate_ctrl_reg))
+		return;
+
+	pr_debug("GENPLL: disable chan %d\n", clk->chan);
+
+	/* Enable audio clock. */
+	if (clk->chan == GENPLL_CH4_ASIU_AUDIO_CLK)
+		cygnus_clkgate_enable_disable(
+			cyg_parent_clk->clock_gate_ctrl_reg,
+			AUD_CLK_GATE_EN, false);
+}
+
+static const struct clk_ops cygnus_genpll_chan_ops = {
+	.prepare = cygnus_genpll_chan_prepare,
+	.unprepare = cygnus_genpll_chan_unprepare,
+	.enable = cygnus_genpll_chan_enable,
+	.disable = cygnus_genpll_chan_disable,
+	.recalc_rate = cygnus_genpll_chan_recalc_rate,
+};
+
+static __init struct clk *cygnus_clock_init(struct device_node *node,
+	const struct clk_ops *ops)
+{
+	u32 channel = 0;
+	struct clk *clk;
+	struct cygnus_clk *cygnus_clk;
+	const char *clk_name = node->name;
+	const char *parent_name;
+	struct clk_init_data init;
+	int rc;
+
+	pr_debug("Clock name %s\n", node->name);
+
+	cygnus_clk = kzalloc(sizeof(*cygnus_clk), GFP_KERNEL);
+	if (WARN_ON(!cygnus_clk))
+		return NULL;
+
+	cygnus_clk->state = CLK_DISABLED;
+
+	/* Read base address from device tree and map to virtual address. */
+	cygnus_clk->regs_base = of_iomap(node, CYGNUS_CLK_BASE_REG);
+	if (WARN_ON(!cygnus_clk->regs_base))
+		goto err_alloc;
+
+	/* Read optional base addresses for PLL control and clock gating. */
+	cygnus_clk->clock_gate_ctrl_reg = of_iomap(node,
+		CYGNUS_CLK_GATE_CTRL_REG);
+	cygnus_clk->pll_ctrl_reg = of_iomap(node, CYGNUS_PLL_CTRL_REG);
+
+	of_property_read_u32(node, "channel", &channel);
+	cygnus_clk->chan = channel;
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	/*
+	 * Internal divider is optional and used for PLL derived clocks with
+	 * hardcoded dividers.
+	 */
+	cygnus_clk->internal_div = CLK_RATE_NO_DIV;
+	of_property_read_u32(node, "div", &cygnus_clk->internal_div);
+
+	init.name = clk_name;
+	init.ops = ops;
+	init.flags = CLK_GET_RATE_NOCACHE;
+	parent_name = of_clk_get_parent_name(node, 0);
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	cygnus_clk->hw.init = &init;
+
+	clk = clk_register(NULL, &cygnus_clk->hw);
+	if (WARN_ON(IS_ERR(clk)))
+		goto err_unmap;
+
+	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	if (WARN_ON(IS_ERR_VALUE(rc)))
+		goto err_unregister;
+
+	rc = clk_register_clkdev(clk, clk_name, NULL);
+	if (WARN_ON(IS_ERR_VALUE(rc)))
+		goto err_provider;
+
+	return clk;
+
+err_provider:
+	of_clk_del_provider(node);
+
+err_unregister:
+	clk_unregister(clk);
+
+err_unmap:
+	iounmap(cygnus_clk->regs_base);
+	iounmap(cygnus_clk->clock_gate_ctrl_reg);
+	iounmap(cygnus_clk->pll_ctrl_reg);
+
+err_alloc:
+	kfree(cygnus_clk);
+
+	return NULL;
+}
+
+static void __init cygnus_lcpll_init(struct device_node *node)
+{
+	cygnus_clock_init(node, &cygnus_lcpll_ops);
+}
+CLK_OF_DECLARE(cygnus_lcpll, "brcm,cygnus-lcpll-clk", cygnus_lcpll_init);
+
+static void __init cygnus_genpll_init(struct device_node *node)
+{
+	cygnus_clock_init(node, &cygnus_genpll_ops);
+}
+CLK_OF_DECLARE(cygnus_genpll, "brcm,cygnus-genpll-clk", cygnus_genpll_init);
+
+static void __init cygnus_lcpll_ch_init(struct device_node *node)
+{
+	cygnus_clock_init(node, &cygnus_lcpll_chan_ops);
+}
+CLK_OF_DECLARE(cygnus_lcpll_ch, "brcm,cygnus-lcpll-ch", cygnus_lcpll_ch_init);
+
+static void __init cygnus_genpll_ch_init(struct device_node *node)
+{
+	cygnus_clock_init(node, &cygnus_genpll_chan_ops);
+}
+CLK_OF_DECLARE(cygnus_genpll_ch, "brcm,cygnus-genpll-ch",
+	cygnus_genpll_ch_init);
+
+/*
+ * Some clocks on Cygnus are derived from the oscillator directly without
+ * going through either the GENPLL or LCPLL. These clocks have specific
+ * registers for their dividers. The clocks included are: keypad, ADC, PWM.
+ */
+
+#define ASIU_CLK_DIV_ENABLE_SHIFT  31
+#define ASIU_CLK_DIV_ENABLE_MASK   0x1
+#define ASIU_CLK_DIV_HIGH_SHIFT    16
+#define ASIU_CLK_DIV_HIGH_MASK     0x3ff
+#define ASIU_CLK_DIV_LOW_SHIFT     0
+#define ASIU_CLK_DIV_LOW_MASK      0x3ff
+
+/*
+ * Calculate clock frequency for clocks derived from oscillator.
+ *
+ * @return The clock rate in Hz
+ */
+static int cygnus_osc_derived_clk_get_rate(struct cygnus_clk *clk,
+	unsigned long parent_rate)
+{
+	int reg_val;
+	int enabled;
+	int clk_div_high;
+	int clk_div_low;
+	unsigned long rate = 0;
+
+	reg_val = readl(clk->regs_base);
+
+	/* Ensure clock is enabled. */
+	enabled = (reg_val >> ASIU_CLK_DIV_ENABLE_SHIFT) &
+		ASIU_CLK_DIV_ENABLE_MASK;
+	if (!enabled)
+		return rate;
+
+	clk_div_high = (reg_val >> ASIU_CLK_DIV_HIGH_SHIFT) &
+		ASIU_CLK_DIV_HIGH_MASK;
+	clk_div_high += 1;
+
+	clk_div_low = (reg_val >> ASIU_CLK_DIV_LOW_SHIFT) &
+		ASIU_CLK_DIV_LOW_MASK;
+	clk_div_low += 1;
+
+	/*
+	 * Rate calculated as:
+	 *   (oscillator rate) / ((clk high + 1) + (clk_low + 1))
+	 */
+	rate = parent_rate / (clk_div_high + clk_div_low);
+
+	pr_debug("Osc derived clk: Prate=%lu div_high=%d div_low=%d rate=%lu\n",
+		parent_rate, clk_div_high, clk_div_low, rate);
+
+	return rate;
+}
+
+static unsigned long cygnus_osc_derived_clk_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct cygnus_clk *bcm_clk = to_cygnus_clk(hwclk);
+
+	return cygnus_osc_derived_clk_get_rate(bcm_clk, parent_rate);
+}
+
+/*
+ * Enables the top clock gating control for clocks that require it.
+ */
+static int cygnus_osc_derived_clk_enable(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+	struct clk *parent_clk = clk_get_parent(hwclk->clk);
+	int parent_rate;
+	u32 val;
+
+	if (WARN_ON(!clk->clock_gate_ctrl_reg))
+		return 0;
+
+	pr_debug("OSC derived clk enable chan %d\n", clk->chan);
+
+	/* Enable top clock gating control if necessary. */
+	if (clk->chan == OSC_DERIVED_CH0_KEYPAD_CLK)
+		cygnus_clkgate_enable_disable(clk->clock_gate_ctrl_reg,
+			KEYPAD_CLK_GATE_EN, true);
+	else if (clk->chan == OSC_DERIVED_CH1_ADC_CLK)
+		cygnus_clkgate_enable_disable(clk->clock_gate_ctrl_reg,
+			ADC_CLK_GATE_EN, true);
+
+	/* Set and enable divider if specified. */
+	if (clk->internal_div != CLK_RATE_NO_DIV) {
+		val = (1 << ASIU_CLK_DIV_ENABLE_SHIFT) |
+			((clk->internal_div & ASIU_CLK_DIV_HIGH_MASK) <<
+			ASIU_CLK_DIV_HIGH_SHIFT) |
+			((clk->internal_div & ASIU_CLK_DIV_LOW_MASK) <<
+			ASIU_CLK_DIV_LOW_SHIFT);
+		writel(val, clk->regs_base);
+	}
+
+	/* Ensure parent's clock rate is calculated. */
+	parent_rate = clk_get_rate(parent_clk);
+	if (WARN_ON(!parent_rate))
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * Disables top clock gating control for clocks that were enabled.
+ */
+static void cygnus_osc_derived_clk_disable(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+
+	if (WARN_ON(!clk->clock_gate_ctrl_reg))
+		return;
+
+	pr_debug("OSC derived clk disable chan %d\n", clk->chan);
+
+	/* Disable top clock gating control if necessary. */
+	if (clk->chan == OSC_DERIVED_CH0_KEYPAD_CLK)
+		cygnus_clkgate_enable_disable(clk->clock_gate_ctrl_reg,
+			KEYPAD_CLK_GATE_EN, false);
+	else if (clk->chan == OSC_DERIVED_CH1_ADC_CLK)
+		cygnus_clkgate_enable_disable(clk->clock_gate_ctrl_reg,
+			ADC_CLK_GATE_EN, false);
+}
+
+static const struct clk_ops cygnus_osc_derived_clk_ops = {
+	.enable = cygnus_osc_derived_clk_enable,
+	.disable = cygnus_osc_derived_clk_disable,
+	.recalc_rate = cygnus_osc_derived_clk_recalc_rate,
+};
+
+static void __init cygnus_osc_derived_init(struct device_node *node)
+{
+	cygnus_clock_init(node, &cygnus_osc_derived_clk_ops);
+}
+
+CLK_OF_DECLARE(cygnus_osc_derived, "brcm,cygnus-osc-derived",
+	cygnus_osc_derived_init);
+
+/*
+ * Some clocks are derived from a PLL. The dividers are internal and can't
+ * be read from a register. If the parent clock rate changes then the derived
+ * clock rates scale accordingly.
+ */
+
+ /*
+  * Calculate clock frequency for clocks derived from oscillator.
+  * Rate calculated as:  parent rate / internal divider
+  * The internal divider must be specified in DT.
+  *
+  * @return The clock rate in Hz.
+  */
+static unsigned long cygnus_pll_derived_clk_get_rate(struct cygnus_clk *clk,
+	unsigned long parent_rate)
+{
+	unsigned long rate = parent_rate / clk->internal_div;
+
+	pr_debug("PLL derived clk: Prate=%lu rate=%lu\n", parent_rate, rate);
+
+	return rate;
+}
+
+static unsigned long cygnus_pll_derived_clk_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct cygnus_clk *bcm_clk = to_cygnus_clk(hwclk);
+
+	return cygnus_pll_derived_clk_get_rate(bcm_clk, parent_rate);
+}
+
+static const struct clk_ops cygnus_pll_derived_clk_ops = {
+	.recalc_rate = cygnus_pll_derived_clk_recalc_rate,
+};
+
+static void __init cygnus_pll_derived_init(struct device_node *node)
+{
+	cygnus_clock_init(node, &cygnus_pll_derived_clk_ops);
+}
+
+CLK_OF_DECLARE(cygnus_pll_derived, "brcm,cygnus-pll-derived",
+	cygnus_pll_derived_init);
+
+/*
+ * MIPI DSI GENPLL
+ */
+
+/*
+ * Get PLL running status and calculate output frequency.
+ */
+static unsigned long cygnus_mipipll_get_rate(struct cygnus_clk *clk,
+	unsigned long parent_rate)
+{
+	u32 reg;
+	u32 rate;
+	u32 pdiv;
+	u32 ndiv_int;
+	u32 ndiv_frac;
+	int pll_locked;
+
+	/* Read lock field from PLL status register. It must be unlocked. */
+	reg = readl(clk->regs_base + GENPLL_STATUS_OFFSET);
+
+	pll_locked = (reg >> GENPLL_STATUS_LOCK_SHIFT) &
+		GENPLL_STATUS_LOCK_MASK;
+	if (pll_locked) {
+		clk->rate = 0;
+		return -EIO;
+	}
+	/*
+	 * Calculate PLL frequency:
+	 *   PLL freq = ((crystal clock / pdiv) * ndiv ) / mdiv
+	 */
+
+	/* Get PLL feedback divider values. */
+	reg = readl(clk->regs_base + GENPLL_CONTROL4_OFFSET);
+
+	/* Feedback divider integer and fractional parts. */
+	ndiv_int = (reg >> GENPLL_CONTROL4_NDIV_INT_SHIFT) &
+		GENPLL_CONTROL4_NDIV_INT_MASK;
+	ndiv_frac = (reg >> GENPLL_CONTROL4_NDIV_FRAC_SHIFT) &
+		GENPLL_CONTROL4_NDIV_FRAC_MASK;
+	ndiv_int += ndiv_frac / NDIV_FRAC_DIVISOR;
+
+	/* Get pdiv. */
+	reg = readl(clk->regs_base + GENPLL_CONTROL5_OFFSET);
+	pdiv = (reg >> GENPLL_CONTROL5_PDIV_SHIFT) &
+		GENPLL_CONTROL5_PDIV_MASK;
+
+	/* If pdiv is 0, divide by 0.5 - doubler. */
+	if (pdiv == 0)
+		rate = parent_rate * 2;
+	else
+		rate = parent_rate / pdiv;
+
+	clk->rate = rate * ndiv_int;
+
+	pr_debug("[MIPI PLL] parent rate=%lu, ndiv int=%d, pdiv=%d, rate=%lu\n",
+	    parent_rate, ndiv_int, pdiv, clk->rate);
+
+	return clk->rate;
+}
+
+/*
+ * Powers on the necessary PLL's and LDO for MIPI GEN PLL.
+ */
+static int cygnus_mipipll_prepare(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+
+	if (WARN_ON(!clk->pll_ctrl_reg))
+		return -EIO;
+
+	pr_debug("Powering up MIPI PLL and LDO\n");
+
+	/* Power on the PLL. */
+	cygnus_mipi_genpll_power_on_off(clk->pll_ctrl_reg, true);
+
+	clk->state = CLK_PREPARED;
+
+	return 0;
+}
+
+/*
+ * Powers off the PLL's and LDO for MIPI GEN PLL.
+ */
+static void cygnus_mipipll_unprepare(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+
+	if (WARN_ON(!clk->pll_ctrl_reg))
+		return;
+
+	pr_debug("Powering down MIPI PLL and LDO\n");
+
+	/* Power off the PLL. */
+	cygnus_mipi_genpll_power_on_off(clk->pll_ctrl_reg, false);
+
+	clk->state = CLK_DISABLED;
+}
+
+static unsigned long cygnus_mipipll_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct cygnus_clk *bcm_clk = to_cygnus_clk(hwclk);
+
+	if (bcm_clk->state != CLK_ENABLED)
+		return 0;
+
+	return cygnus_mipipll_get_rate(bcm_clk, parent_rate);
+}
+
+/*
+ * Enables the MIPI DSI clock gate through the top clock gating control.
+ */
+static int cygnus_mipipll_enable(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+
+	if (WARN_ON(!clk->clock_gate_ctrl_reg))
+		return -EIO;
+
+	pr_debug("Enable MIPI PLL\n");
+
+	/* Enable MIPI DSI clock. */
+	cygnus_clkgate_enable_disable(clk->clock_gate_ctrl_reg,
+		MIPI_DSI_CLK_GATE_EN, true);
+
+	clk->state = CLK_ENABLED;
+
+	return 0;
+}
+
+/*
+ * Turns off the MIPI PLL clock.
+ */
+static void cygnus_mipipll_disable(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+
+	if (WARN_ON(!clk->clock_gate_ctrl_reg))
+		return;
+
+	pr_debug("Disabling MIPI PLL and LDO\n");
+
+	/* Disable MIPI DSI clock through top clock gating control. */
+	cygnus_clkgate_enable_disable(clk->clock_gate_ctrl_reg,
+		MIPI_DSI_CLK_GATE_EN, false);
+
+	clk->state = CLK_DISABLED;
+}
+
+static const struct clk_ops cygnus_mipipll_ops = {
+	.prepare = cygnus_mipipll_prepare,
+	.unprepare = cygnus_mipipll_unprepare,
+	.enable = cygnus_mipipll_enable,
+	.disable = cygnus_mipipll_disable,
+	.recalc_rate = cygnus_mipipll_recalc_rate,
+};
+
+static void __init cygnus_mipipll_init(struct device_node *node)
+{
+	cygnus_clock_init(node, &cygnus_mipipll_ops);
+}
+CLK_OF_DECLARE(cygnus_mipipll, "brcm,cygnus-mipipll-clk", cygnus_mipipll_init);
+
+/*
+ * MIPI PLL clock channel management.
+ */
+
+/*
+ * Enables a MIPI PLL channel.
+ */
+static void mipi_pll_enable_chan(void __iomem *base, int chan, bool state)
+{
+	u32 val;
+
+	val = readl(base + GENPLL_CONTROL1_OFFSET);
+
+	/* ENABLEB_CH bit set to 0 to enable channel, 1 to disable. */
+	if (state)
+		val &= ~(1 << (chan + MIPI_DSI_GENPLL_ENABLEB_CH_SHIFT));
+	else
+		val |= (1 << (chan + MIPI_DSI_GENPLL_ENABLEB_CH_SHIFT));
+
+	writel(val, base + GENPLL_CONTROL1_OFFSET);
+}
+
+static unsigned long cygnus_mipipll_chan_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+
+	if (WARN_ON(!clk->clock_gate_ctrl_reg))
+		return 0;
+
+	if (clk->state != CLK_ENABLED)
+		return 0;
+
+	return cygnus_genpll_chan_get_rate(clk, parent_rate,
+		MIPI_DSI_GENPLL_ENABLEB_CH_SHIFT);
+}
+
+/*
+ * Enables the PLL channel and the top clock gating control for clocks that
+ * are controlled through it.
+ */
+static int cygnus_mipipll_chan_enable(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+	struct clk *parent_clk = clk_get_parent(hwclk->clk);
+	int parent_rate;
+
+	if (WARN_ON(!clk->clock_gate_ctrl_reg))
+		return -EIO;
+
+	pr_debug("Enable MIPI PLL chan %d\n", clk->chan);
+
+	/*
+	 * Some MIPI PLL channels have to be enabled through the top clock
+	 * gating ctrl. Add support for other channels here.
+	 */
+	if (clk->chan == MIPI_PLL_CH1_LCD_CLK) {
+		cygnus_clkgate_enable_disable(clk->clock_gate_ctrl_reg,
+			LCD_CLK_GATE_EN, true);
+	}
+
+	/* Enable the PLL channel. */
+	mipi_pll_enable_chan(clk->regs_base, clk->chan, true);
+
+	clk->state = CLK_ENABLED;
+
+	/* Ensure parent's clock rate is calculated. */
+	parent_rate = clk_get_rate(parent_clk);
+	if (WARN_ON(!parent_rate))
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * Disables the PLL channel. Some channels also have to be shut down through
+ * the top clock gating control.
+ */
+static void cygnus_mipipll_chan_disable(struct clk_hw *hwclk)
+{
+	struct cygnus_clk *clk = to_cygnus_clk(hwclk);
+
+	if (WARN_ON(!clk->clock_gate_ctrl_reg))
+		return;
+
+	pr_debug("Disable MIPI PLL chan %d\n", clk->chan);
+
+	/* Disable LCD clock through top clock gating control. */
+	if (clk->chan == MIPI_PLL_CH1_LCD_CLK) {
+		cygnus_clkgate_enable_disable(clk->clock_gate_ctrl_reg,
+			LCD_CLK_GATE_EN, false);
+	}
+
+	/* Disable the PLL channel. */
+	mipi_pll_enable_chan(clk->regs_base, clk->chan, false);
+
+	clk->state = CLK_DISABLED;
+}
+
+static const struct clk_ops cygnus_mipipll_chan_ops = {
+	.enable = cygnus_mipipll_chan_enable,
+	.disable = cygnus_mipipll_chan_disable,
+	.recalc_rate = cygnus_mipipll_chan_recalc_rate,
+};
+
+static void __init cygnus_mipipll_ch_init(struct device_node *node)
+{
+	cygnus_clock_init(node, &cygnus_mipipll_chan_ops);
+}
+
+CLK_OF_DECLARE(cygnus_mipipll_ch, "brcm,cygnus-mipipll-ch",
+	cygnus_mipipll_ch_init);
diff --git a/drivers/clk/bcm/clk-iproc.c b/drivers/clk/bcm/clk-iproc.c
new file mode 100644
index 0000000..aca4851
--- /dev/null
+++ b/drivers/clk/bcm/clk-iproc.c
@@ -0,0 +1,451 @@
+/*
+ * Copyright 2014 Broadcom Corporation.  All rights reserved.
+ *
+ * Unless you and Broadcom execute a separate written software license
+ * agreement governing use of this software, this software is licensed to you
+ * under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/clkdev.h>
+#include <linux/of_address.h>
+
+#define IPROC_CLK_POLICY_FREQ_OFFSET    0x008
+#define IPROC_CLK_POLICY0_MSK_OFFSET    0x010
+#define IPROC_CLK_APB_SW_DIV_OFFSET     0xA10
+#define IPROC_CLK_PLL_ARMA_OFFSET       0xC00
+#define IPROC_CLK_PLL_ARMB_OFFSET       0xC04
+#define IPROC_CLK_PLL_ARMC_OFFSET       0xC08
+#define IPROC_CLK_PLL_ARMCTL5_OFFSET    0xC20
+#define IPROC_CLK_PLL_ARM_OFFSET_OFFSET 0xC24
+#define IPROC_CLK_ARM_DIV_OFFSET        0xE00
+#define IPROC_CLK_POLICY_DBG_OFFSET     0xEC0
+
+#define IPROC_CLK_ARM_DIV_ARM_PLL_SELECT_OVERRIDE_SHIFT        4
+#define IPROC_CLK_ARM_DIV_ARM_PLL_SELECT_MASK                  0xf
+#define IPROC_CLK_POLICY_FREQ_OFFSET_POLICY_FREQ_MASK          0xf
+#define IPROC_CLK_POLICY_FREQ_OFFSET_POLICY_FREQ_SHIFT         8
+#define IPROC_CLK_POLICY_DBG_OFFSET_ACT_FREQ_SHIFT             12
+#define IPROC_CLK_POLICY_DBG_OFFSET_ACT_FREQ_MASK              7
+#define IPROC_CLK_PLL_ARM_OFFSET_PLLARM_OFFSET_SW_CTL_SHIFT    29
+#define CLK_PLL_ARM_OFFSET_PLLARM_NDIV_INT_OFFSET              20
+#define CLK_PLL_ARM_OFFSET_PLLARM_NDIV_INT_MASK                0xff
+#define CLK_PLL_ARM_OFFSET_PLLARM_NDIV_FRAC_OFFSET             0xfffff
+#define CLK_PLL_ARMA_PLLARM_NDIV_INT_SHIFT                     8
+#define CLK_PLL_ARMA_PLLARM_NDIV_INT_MASK                      0x3ff
+#define CLK_PLL_ARMB_PLLARM_NDIV_FRAC_MASK                     0xfffff
+#define CLK_PLL_ARMC_PLLARM_MDIV_MASK                          0xff
+#define CLK_PLL_ARMCTL5_PLLARM_H_MDIV_MASK                     0xff
+#define CLK_PLL_ARMC_PLLARM_BYPCLK_EN_SHIFT                    8
+#define CLK_PLL_ARMA_PLLARM_PDIV_SHIFT                         24
+#define CLK_PLL_ARMA_PLLARM_PDIV_MASK                          0xf
+#define CLK_PLL_ARMA_PLLARM_LOCK_SHIFT                         28
+#define CLK_ARM_DIV_APB0_FREE_DIV_SHIFT                        8
+#define CLK_ARM_DIV_APB0_FREE_DIV_MASK                         0x7
+#define CLK_ARM_DIV_ARM_SWITCH_DIV_SHIFT                       8
+#define CLK_ARM_DIV_ARM_SWITCH_DIV_MASK                        0x3
+#define CLK_APB_SW_DIV_APB_CLK_DIV_MASK                        0x3
+
+struct brcm_clk {
+	struct clk_hw   hw;
+	void __iomem    *regs_base;
+	int             chan;
+	unsigned long   rate;
+};
+
+/* Identifies derived clocks from ARM PLL. */
+enum {
+	ARMPLL_APB0_FREE_CLK   = 0,
+	ARMPLL_ARM_SWITCH_CLK  = 1,
+	ARMPLL_ARM_APB_CLK     = 2,
+	ARMPLL_ARM_PERIPH_CLK  = 3
+};
+
+/* Frequency id's from policy0_freq field of POLICY_FREQ register. */
+enum a9pll_policy_freq {
+	PLL_CRYSTAL_CLK   = 0,
+	PLL_SYS_CLK       = 2,
+	PLL_CH0_SLOW_CLK  = 6,
+	PLL_CH1_FAST_CLK  = 7
+};
+
+#define to_brcm_clk(p) container_of(p, struct brcm_clk, hw)
+
+static int iproc_cru_arm_freq_id(void __iomem *regs_base)
+{
+	u32 reg_f, reg;
+	unsigned policy = 0;
+	unsigned fid;
+	unsigned active_freq;
+
+	/* Read policy frequency. */
+	reg_f = readl(regs_base + IPROC_CLK_POLICY_FREQ_OFFSET);
+
+	/* Check for PLL policy software override. */
+	reg = readl(regs_base + IPROC_CLK_ARM_DIV_OFFSET);
+	if (reg & (1 << IPROC_CLK_ARM_DIV_ARM_PLL_SELECT_OVERRIDE_SHIFT))
+		policy = reg & IPROC_CLK_ARM_DIV_ARM_PLL_SELECT_MASK;
+
+	/* Get frequency ID based on policy. */
+	fid = (reg_f >>
+		(IPROC_CLK_POLICY_FREQ_OFFSET_POLICY_FREQ_SHIFT * policy)) &
+		IPROC_CLK_POLICY_FREQ_OFFSET_POLICY_FREQ_MASK;
+
+	/* Verify freq id from debug register. */
+	reg = readl(regs_base + IPROC_CLK_POLICY_DBG_OFFSET);
+	/* Read current active frequency id. */
+	active_freq = IPROC_CLK_POLICY_DBG_OFFSET_ACT_FREQ_MASK &
+		(reg >> IPROC_CLK_POLICY_DBG_OFFSET_ACT_FREQ_SHIFT);
+
+	if (fid != active_freq) {
+		pr_debug("IPROC CRU clock frequency id override %d->%d\n",
+			fid, active_freq);
+
+		fid = active_freq;
+	}
+
+	pr_debug("Active frequency ID %d\n", fid);
+
+	return fid;
+}
+
+/*
+ * Get ndiv integer and combine with fractional part to create 64 bit
+ * value.
+ */
+static u64 a9pll_get_ndiv(struct brcm_clk *clk)
+{
+	u32 arm_offset_reg;
+	u32 pllarma_reg;
+	u32 pllarmb_reg;
+	u32 ndiv_int;
+	u32 ndiv_frac;
+	u64 ndiv;
+
+	arm_offset_reg = readl(clk->regs_base +
+		IPROC_CLK_PLL_ARM_OFFSET_OFFSET);
+
+    /*
+	 * Check if offset mode is active to determine which register to
+	 * get ndiv from.
+	 */
+	if (arm_offset_reg &
+		(1 << IPROC_CLK_PLL_ARM_OFFSET_PLLARM_OFFSET_SW_CTL_SHIFT)) {
+		/* Offset mode active. Get integer divide from offset reg. */
+		ndiv_int = (arm_offset_reg >>
+			CLK_PLL_ARM_OFFSET_PLLARM_NDIV_INT_OFFSET) &
+			CLK_PLL_ARM_OFFSET_PLLARM_NDIV_INT_MASK;
+
+		if (ndiv_int == 0)
+			ndiv_int = 256;
+
+		/* Get ndiv fractional divider. */
+		ndiv_frac = arm_offset_reg &
+			CLK_PLL_ARM_OFFSET_PLLARM_NDIV_FRAC_OFFSET;
+	} else {
+		/* Offset mode not active so read PLL ndiv from PLLARMA. */
+		pllarma_reg = readl(clk->regs_base + IPROC_CLK_PLL_ARMA_OFFSET);
+		ndiv_int = (pllarma_reg >> CLK_PLL_ARMA_PLLARM_NDIV_INT_SHIFT) &
+			CLK_PLL_ARMA_PLLARM_NDIV_INT_MASK;
+
+		if (ndiv_int == 0)
+			ndiv_int = 1024;
+
+		/* Get ndiv fractional divider. */
+		pllarmb_reg = readl(clk->regs_base + IPROC_CLK_PLL_ARMB_OFFSET);
+		ndiv_frac = pllarmb_reg & CLK_PLL_ARMB_PLLARM_NDIV_FRAC_MASK;
+	}
+
+	ndiv = ((u64) ndiv_int << 20) | ndiv_frac;
+
+	return ndiv;
+}
+
+/*
+ * Determine mdiv (post divider) based on the frequency id being used.
+ * There are 4 clocks that can be used to derive the output clock rate:
+ *    - 25 MHz crystal
+ *    - sys_clk
+ *    - channel 0 (slow clock)
+ *    - channel 1 (fast clock)
+ *
+ * If the slow clock is being used then mdiv is read from PLLARMC. If
+ * the fast clock is being used then the channel 1 mdiv is used.
+ * Otherwise there is no post divider.
+ *
+ * @return The mdiv value. -EIO if an error occurred.
+ */
+static int a9pll_get_mdiv(struct brcm_clk *clk)
+{
+	u32 mdiv;
+	u32 pllarmc_reg;
+	u32 armctl5_reg;
+	u32 freq_id;
+
+	/* Get the policy frequency. */
+	freq_id = iproc_cru_arm_freq_id(clk->regs_base);
+
+	switch (freq_id) {
+	/* There is no divider for these frequency id's. */
+	case PLL_CRYSTAL_CLK:
+	case PLL_SYS_CLK:
+		mdiv = 1;
+		break;
+
+	case PLL_CH0_SLOW_CLK: {
+	    /* Read mdiv (post-divider) from PLLARMC bits 0:7 */
+	    pllarmc_reg = readl(clk->regs_base + IPROC_CLK_PLL_ARMC_OFFSET);
+	    mdiv = pllarmc_reg & CLK_PLL_ARMC_PLLARM_MDIV_MASK;
+	    if (mdiv == 0)
+			mdiv = 256;
+		break;
+	}
+
+	case PLL_CH1_FAST_CLK: {
+		/* Post divider for channel 1 is in CTL5 (pllarm_h_mdiv). */
+		armctl5_reg = readl(clk->regs_base +
+			IPROC_CLK_PLL_ARMCTL5_OFFSET);
+	    mdiv = armctl5_reg & CLK_PLL_ARMCTL5_PLLARM_H_MDIV_MASK;
+	    if (mdiv == 0)
+			mdiv = 256;
+		break;
+	}
+
+	default:
+		return -EIO;
+	}
+
+	return mdiv;
+}
+
+/*
+ * Calculate the output frequency of the ARM PLL. The main output clock
+ * is 'arm_clk'.
+ *
+ * The frequency is calculated based on the ARM PLL divider values:
+ *	 pdiv = ARM PLL input pre-divider
+ *   ndiv = ARM PLL feedback divider
+ *   mdiv = ARM PLL post divider
+ *
+ * The frequency is calculated by:
+ *   ((ndiv * parent clock rate) / pdiv) / mdiv
+ */
+static int a9pll_status(struct brcm_clk *clk, unsigned long parent_rate)
+{
+	u32 pllarma_reg;
+	u32 pllarmc_reg;
+	u32 pdiv;
+	u32 mdiv;
+	u64 ndiv;
+	u32 arm_clk_freq;
+
+	pr_debug("a9pll_status: clk 0x%x\n", (unsigned int)clk);
+
+	BUG_ON(!clk->regs_base);
+
+	pllarma_reg = readl(clk->regs_base + IPROC_CLK_PLL_ARMA_OFFSET);
+	pllarmc_reg = readl(clk->regs_base + IPROC_CLK_PLL_ARMC_OFFSET);
+
+	/* Check if PLL is in bypass mode - input frequency to output */
+	if (pllarmc_reg & (1 << CLK_PLL_ARMC_PLLARM_BYPCLK_EN_SHIFT)) {
+		clk->rate = parent_rate;
+		return 0;
+	}
+
+	/* Check if PLL is locked. It must be unlocked. */
+	if ((pllarma_reg &
+		(1 << CLK_PLL_ARMA_PLLARM_LOCK_SHIFT)) == 0) {
+		clk->rate = 0;
+		return -EIO;
+	}
+
+	/* Read pdiv from PLLARMA. */
+	pdiv = (pllarma_reg >> CLK_PLL_ARMA_PLLARM_PDIV_SHIFT) &
+		CLK_PLL_ARMA_PLLARM_PDIV_MASK;
+	if (pdiv == 0)
+		pdiv = 16;
+
+	/* Determine ndiv. */
+	ndiv = a9pll_get_ndiv(clk);
+
+	/* Determine mdiv (post divider). */
+	mdiv = a9pll_get_mdiv(clk);
+	if (mdiv == -EIO) {
+		clk->rate = 0;
+		return -EIO;
+	}
+
+	/* Calculate clock frequency. */
+	arm_clk_freq = (ndiv * parent_rate) >> 20;
+	arm_clk_freq = (arm_clk_freq / pdiv) / mdiv;
+
+	clk->rate = arm_clk_freq;
+
+	pr_debug("ARM PLL (arm_clk) rate %lu. parent rate = %lu, ",
+		clk->rate, parent_rate);
+	pr_debug("ndiv_int = %d, pdiv = %d, mdiv = %d\n",
+		 (u32)ndiv >> 20, pdiv, mdiv);
+
+	return clk->rate;
+}
+
+static unsigned long clk_a9pll_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct brcm_clk *bcm_clk = to_brcm_clk(hwclk);
+
+	return a9pll_status(bcm_clk, parent_rate);
+}
+
+static const struct clk_ops a9pll_ops = {
+	.recalc_rate = clk_a9pll_recalc_rate,
+};
+
+/*
+ * Get status of any of the ARMPLL output channels
+ */
+static int a9pll_chan_status(struct brcm_clk *clk, unsigned long parent_rate)
+{
+	u32 reg;
+	unsigned div;
+
+	BUG_ON(!clk->regs_base);
+
+	reg = readl(clk->regs_base + IPROC_CLK_ARM_DIV_OFFSET);
+	pr_debug("Clock Div = %#x\n", reg);
+
+	switch (clk->chan) {
+	case ARMPLL_APB0_FREE_CLK:
+		/* apb0_free_div bits 10:8 */
+		div = (reg >> CLK_ARM_DIV_APB0_FREE_DIV_SHIFT) &
+			CLK_ARM_DIV_APB0_FREE_DIV_MASK;
+		div++;
+		break;
+
+	case ARMPLL_ARM_SWITCH_CLK:
+		/* arm_switch_div bits 6:5 */
+		div = (reg >> CLK_ARM_DIV_ARM_SWITCH_DIV_SHIFT) &
+			CLK_ARM_DIV_ARM_SWITCH_DIV_MASK;
+		div++;
+		break;
+
+	case ARMPLL_ARM_APB_CLK:
+		/* IPROC_CLK_APB_SW_DIV_REG apb_clk_div bits 1:0 */
+		reg = readl(clk->regs_base + IPROC_CLK_APB_SW_DIV_OFFSET);
+		div = reg & CLK_APB_SW_DIV_APB_CLK_DIV_MASK;
+		div++;
+		break;
+
+	case ARMPLL_ARM_PERIPH_CLK:      /* periph_clk */
+		div = 2;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	clk->rate = parent_rate / div;
+	pr_debug("Clock rate A9PLL chan 0x%x: %lu, div: %d\n",
+		clk->chan, clk->rate, div);
+
+	return clk->rate;
+}
+
+static unsigned long clk_a9pll_chan_recalc_rate(struct clk_hw *hwclk,
+	unsigned long parent_rate)
+{
+	struct brcm_clk *bcm_clk = to_brcm_clk(hwclk);
+
+	return a9pll_chan_status(bcm_clk, parent_rate);
+}
+
+static const struct clk_ops a9pll_chan_ops = {
+	.recalc_rate = clk_a9pll_chan_recalc_rate,
+};
+
+static __init struct clk *iproc_clock_init(struct device_node *node,
+	const struct clk_ops *ops)
+{
+	u32 channel = 0;
+	struct clk *clk;
+	struct brcm_clk *brcm_clk;
+	const char *clk_name = node->name;
+	const char *parent_name;
+	struct clk_init_data init;
+	int rc;
+
+	pr_debug("Clock name %s\n", node->name);
+
+	rc = of_property_read_u32(node, "channel", &channel);
+	brcm_clk = kzalloc(sizeof(*brcm_clk), GFP_KERNEL);
+	if (WARN_ON(!brcm_clk))
+		return NULL;
+
+	/* Read base address from device tree and map to virtual address. */
+	brcm_clk->regs_base = of_iomap(node, 0);
+	if (WARN_ON(!brcm_clk->regs_base))
+		goto err_alloc;
+
+	brcm_clk->chan = channel;
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	init.name = clk_name;
+	init.ops = ops;
+	init.flags = 0;
+	parent_name = of_clk_get_parent_name(node, 0);
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	brcm_clk->hw.init = &init;
+
+	clk = clk_register(NULL, &brcm_clk->hw);
+	if (WARN_ON(IS_ERR(clk)))
+		goto err_unmap;
+
+	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	if (WARN_ON(IS_ERR_VALUE(rc)))
+		goto err_unregister;
+
+	rc = clk_register_clkdev(clk, clk_name, NULL);
+	if (WARN_ON(IS_ERR_VALUE(rc)))
+		goto err_provider;
+
+	return clk;
+
+err_provider:
+	of_clk_del_provider(node);
+
+err_unregister:
+	clk_unregister(clk);
+
+err_unmap:
+	iounmap(brcm_clk->regs_base);
+
+err_alloc:
+	kfree(brcm_clk);
+
+	return NULL;
+}
+
+static void __init iproc_armpll_init(struct device_node *node)
+{
+	iproc_clock_init(node, &a9pll_ops);
+}
+CLK_OF_DECLARE(iproc_armpllx, "brcm,iproc-arm-a9pll", iproc_armpll_init);
+
+static void __init iproc_arm_ch_init(struct device_node *node)
+{
+	iproc_clock_init(node, &a9pll_chan_ops);
+}
+CLK_OF_DECLARE(iproc_arm_ch, "brcm,iproc-arm-ch", iproc_arm_ch_init);
-- 
1.7.9.5

