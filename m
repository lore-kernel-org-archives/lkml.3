Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaB1Xfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:35:42 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50775 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaB1XfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:35:25 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Gerhard Sittig <gsi@denx.de>
Cc: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 3/3] clk: Add driver for TI CDCE913
Date: Fri, 28 Feb 2014 15:34:55 -0800
Message-Id: <1393630495-29689-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TI CDCE913 is a clock synthesizer programmalbe via I2C. It features
one PLL and threy clock outputs that pass through various dividers and
muxes.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 .../devicetree/bindings/clock/ti,cdce913.txt       |  32 +
 drivers/clk/Kconfig                                |   8 +
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-cdce913.c                          | 841 +++++++++++++++++++++
 4 files changed, 882 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/ti,cdce913.txt
 create mode 100644 drivers/clk/clk-cdce913.c

diff --git a/Documentation/devicetree/bindings/clock/ti,cdce913.txt b/Documentation/devicetree/bindings/clock/ti,cdce913.txt
new file mode 100644
index 000000000000..c50a3bd638cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/ti,cdce913.txt
@@ -0,0 +1,32 @@
+Binding for Texas Instruments CDCE(L)913 programmable I2C clock generators.
+
+Reference
+This binding uses the common clock binding[1]. Details about the devices can be
+found in the data sheet[2].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+[2] CDCE(L)913 Data Sheet: http://www.ti.com/lit/ds/symlink/cdce913.pdf
+
+Required properties:
+ - compatible: One of "ti,cdce913", "ti,cdcel913"
+ - reg: I2C device address.
+ - #clock-cells: From common clock bindings: Shall be 1.
+
+Optional properties:
+ - clock-output-names: From common clock bindings.
+ - clock-frequency: Tuple of requested output frequencies <Y1, Y2, Y3>
+ - ti,s0: State of the S0 config pin. Shall be 0 or 1.
+ - ti,crystal-load-capacity: Value for the internal capacitor. Valid values
+   range from 0 to 20 (inclusive).
+ - ti,input-clock-type: Type of input clock. One of 'xtal, 'VCXO', 'LVCMOS'
+
+Example:
+	cdce913@65 {
+	        #clock-cells = <1>;
+	        clocks = <&xtal>;
+		clock-frequency = <25000000>, <50000000>, <100000000>;
+	        compatible = "ti,cdce913";
+	        reg = <0x65>;
+	        ti,s0 = <1>;
+	        ti,input-clock-type = "xtal";
+	};
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index ffad93ff2c9f..cd24d83d0801 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -71,6 +71,14 @@ config COMMON_CLK_SI570
 	  This driver supports Silicon Labs 570/571/598/599 programmable
 	  clock generators.
 
+config COMMON_CLK_CDCE913
+	tristate "Clock driver for TI CDCE913"
+	depends on I2C
+	select REGMAP_I2C
+	select RATIONAL
+	---help---
+	  This driver supports TI CDCE 913 programmable clock generators.
+
 config COMMON_CLK_S2MPS11
 	tristate "Clock driver for S2MPS11 MFD"
 	depends on MFD_SEC_CORE
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index c4fb243dd51a..41bae1ab7dfa 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_COMMON_CLK_I2C)	+= clk-i2c-divider.o
 # please keep this section sorted lexicographically by file/directory path name
 obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN)	+= clk-axi-clkgen.o
 obj-$(CONFIG_ARCH_BCM2835)		+= clk-bcm2835.o
+obj-$(CONFIG_COMMON_CLK_CDCE913)	+= clk-cdce913.o
 obj-$(CONFIG_ARCH_EFM32)		+= clk-efm32gg.o
 obj-$(CONFIG_ARCH_HIGHBANK)		+= clk-highbank.o
 obj-$(CONFIG_MACH_LOONGSON1)		+= clk-ls1x.o
diff --git a/drivers/clk/clk-cdce913.c b/drivers/clk/clk-cdce913.c
new file mode 100644
index 000000000000..5f0f42cc6abd
--- /dev/null
+++ b/drivers/clk/clk-cdce913.c
@@ -0,0 +1,841 @@
+/*
+ * Driver for TI CDCE(L) 913 Programmable VCXO Clock Synthesizer
+ *
+ * Copyright (C) 2013 Sören Brinkmann <soren.brinkmann@xilinx.com>, Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/clk-provider.h>
+#include <linux/delay.h>
+#include <linux/gcd.h>
+#include <linux/i2c.h>
+#include <linux/lcm.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+#define CDCE913_NUM_OUTPUTS	3
+
+/* CDCE913 registers */
+#define CDCE913_GENERIC_CFG_0	0x80
+#define CDCE913_GENERIC_CFG_1	0x81
+#define CDCE913_GENERIC_CFG_2	0x82
+#define CDCE913_GENERIC_CFG_3	0x83
+#define CDCE913_GENERIC_CFG_4	0x84
+#define CDCE913_GENERIC_CFG_5	0x85
+#define CDCE913_GENERIC_CFG_6	0x86
+
+#define CDCE913_PLL_CFG_0	0x90
+#define CDCE913_PLL_CFG_1	0x91
+#define CDCE913_PLL_CFG_2	0x92
+#define CDCE913_PLL_CFG_3	0x93
+#define CDCE913_PLL_CFG_4	0x94
+#define CDCE913_PLL_CFG_5	0x95
+#define CDCE913_PLL_CFG_6	0x96
+#define CDCE913_PLL_CFG_7	0x97
+#define CDCE913_PLL_CFG_8	0x98
+#define CDCE913_PLL_CFG_9	0x99
+#define CDCE913_PLL_CFG_10	0x9a
+#define CDCE913_PLL_CFG_11	0x9b
+#define CDCE913_PLL_CFG_12	0x9c
+#define CDCE913_PLL_CFG_13	0x9d
+#define CDCE913_PLL_CFG_14	0x9e
+#define CDCE913_PLL_CFG_15	0x9f
+
+/* bitfields */
+#define GENERIC_CFG0_DEVID_SHIFT	7
+#define GENERIC_CFG0_DEVID_MASK		(1 << GENERIC_CFG0_DEVID_SHIFT)
+#define GENERIC_CFG0_REVID_SHIFT	4
+#define GENERIC_CFG0_REVID_MASK		(7 << GENERIC_CFG0_REVID_SHIFT)
+#define GENERIC_CFG0_VENDORID_SHIFT	0
+#define GENERIC_CFG0_VENDORID_MASK	(0xf << GENERIC_CFG0_VENDORID_SHIFT)
+
+#define PLLCFG_N_UPPER_SHIFT	4
+#define PLLCFG_N_LOWER_SHIFT	4
+#define PLLCFG_N_LOWER_MASK	(0xf << PLLCFG_N_LOWER_SHIFT)
+#define PLLCFG_N_MAX		4095
+#define PLLCFG_N_MIN		1
+
+#define PLLCFG_M_MAX		511
+#define PLLCFG_M_MIN		1
+
+#define PLLCFG_R_UPPER_MASK	0xf
+#define PLLCFG_R_LOWER_SHIFT	3
+#define PLLCFG_R_LOWER_MASK	(0x1f << PLLCFG_R_LOWER_SHIFT)
+
+#define PLLCFG_Q_UPPER_MASK	7
+#define PLLCFG_Q_LOWER_SHIFT	5
+#define PLLCFG_Q_LOWER_MASK	(7 << PLLCFG_Q_LOWER_SHIFT)
+
+#define PLLCFG_P_SHIFT		2
+#define PLLCFG_P_MASK		(7 << PLLCFG_P_SHIFT)
+
+#define PDIV1_UPPER_MASK	3
+
+#define XTAL_LOAD_CAP_SHIFT	3
+#define XTAL_LOAD_CAP_MASK	(0x1f << XTAL_LOAD_CAP_SHIFT)
+
+#define CLK_IN_TYPE_SHIFT	2
+#define CLK_IN_TYPE_MASK	(3 << CLK_IN_TYPE_SHIFT)
+
+#define F_VCO_MIN		80000000
+#define F_VCO_MAX		230000000
+
+/**
+ * struct clk_cdce913:
+ * @regmap:	Device's regmap
+ * @i2c_client:	I2C client pointer
+ * @clk_out:	Handles to output clocks
+ * @clk_data:	Onecell data struct
+ * @s0:		State of config pin S0
+ * @fsbit:	State of FS bit
+ */
+struct clk_cdce913 {
+	struct regmap		*regmap;
+	struct i2c_client	*i2c_client;
+	struct clk		*clk_out[CDCE913_NUM_OUTPUTS];
+	struct clk_onecell_data	clk_data;
+	int			s0;
+	int			fsbit;
+};
+
+/**
+ * struct clk_cdce913_pll:
+ * @hw:		Clock handle
+ * @frequency:	PLL frequency
+ * @cdce913:	Pointer to driver struct
+ */
+struct clk_cdce913_pll {
+	struct clk_hw		hw;
+	unsigned long		frequency;
+	struct clk_cdce913	*cdce913;
+};
+#define to_clk_cdce913_pll(_hw)	container_of(_hw, struct clk_cdce913_pll, hw)
+
+/* CDCE913 PLL */
+static int cdce913_read_pll_cfg(struct clk_cdce913 *cdce913, unsigned int *N,
+		unsigned int *R, unsigned int *Q, unsigned int *P)
+{
+	int err, i;
+	unsigned int addr;
+	unsigned int regs[4];
+
+	if (cdce913->fsbit)
+		addr = CDCE913_PLL_CFG_12;
+	else
+		addr = CDCE913_PLL_CFG_8;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		err = regmap_read(cdce913->regmap, addr + i, &regs[i]);
+		if (err)
+			return err;
+	}
+
+	*N = (regs[0] << 4) |
+		((regs[1] & PLLCFG_N_LOWER_MASK) >> PLLCFG_N_LOWER_SHIFT);
+	*R = ((regs[1] & PLLCFG_R_UPPER_MASK) << 5) |
+		((regs[2] & PLLCFG_R_LOWER_MASK) >> PLLCFG_R_LOWER_SHIFT);
+	*Q = ((regs[2] & PLLCFG_Q_UPPER_MASK) << 3) |
+		((regs[3] & PLLCFG_Q_LOWER_MASK) >> PLLCFG_Q_LOWER_SHIFT);
+	*P = (regs[3] & PLLCFG_P_MASK) >> PLLCFG_P_SHIFT;
+
+	/* TODO make dev_dbg */
+	dev_info(&cdce913->i2c_client->dev, "%s: N=%u, R=%u, Q=%u, P=%u\n",
+			__func__, *N, *R, *Q, *P);
+
+	return 0;
+}
+
+static unsigned long cdce913_pll_recalc_rate(struct clk_hw *hw,
+		unsigned long parent_rate)
+{
+	int err;
+	u64 rate;
+	unsigned int N, R, Q, P;
+	struct clk_cdce913_pll *pll = to_clk_cdce913_pll(hw);
+	struct clk_cdce913 *cdce913 = pll->cdce913;
+
+	err = cdce913_read_pll_cfg(cdce913, &N, &R, &Q, &P);
+	if (err)
+		return pll->frequency;
+
+	rate = (N * Q) * (u64)parent_rate;
+	rate = div_u64(rate, N * (1 << P) - R);
+
+	pll->frequency = rate;
+
+	return pll->frequency;
+}
+
+static int cdce913_pll_calc_divs(unsigned long rate, unsigned long parent_rate,
+		unsigned int *N, int *R, unsigned int *Q, int *P)
+{
+	unsigned int NN, M, div;
+
+	div = gcd(rate, parent_rate);
+
+	*N = rate / div;
+	M = parent_rate / div;
+
+	if (*N > PLLCFG_N_MAX) {
+		div = DIV_ROUND_UP(*N, PLLCFG_N_MAX);
+		*N /= div;
+		M /= div;
+	}
+
+	if (M > PLLCFG_M_MAX) {
+		div = DIV_ROUND_UP(M, PLLCFG_M_MAX);
+		*N /= div;
+		M /= div;
+	}
+
+	if (!*N)
+		*N = PLLCFG_N_MIN;
+	if (!M)
+		M = PLLCFG_M_MIN;
+
+	if (*N < M)
+		return -EINVAL;
+
+	*P = 4 - ilog2(*N / M);
+	if (*P < 0)
+		*P = 0;
+
+	if (*P > 7)
+		return -EINVAL;
+
+	NN = *N * (1 << *P);
+
+	*Q = NN / M;
+	if (*Q < 16 || *Q > 63)
+		return -EINVAL;
+
+	*R = NN - M * *Q;
+	if (*R < 0 || *R > 511)
+		return -EINVAL;
+
+	return 0;
+}
+
+static long cdce913_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long *parent_rate)
+{
+	u64 rrate;
+	int err, P, R;
+	unsigned int N, Q;
+	struct clk_cdce913_pll *pll = to_clk_cdce913_pll(hw);
+
+	if (rate > F_VCO_MAX)
+		rate = F_VCO_MAX;
+	if (rate < F_VCO_MIN)
+		rate = F_VCO_MIN;
+
+	err = cdce913_pll_calc_divs(rate, *parent_rate, &N, &R, &Q, &P);
+	if (err)
+		return pll->frequency;
+
+	rrate = (N * Q) * (u64)*parent_rate;
+	rrate = div_u64(rrate, N * (1 << P) - R);
+
+	return rrate;
+}
+
+static int cdce913_rate2range(unsigned long fvco)
+{
+	if (fvco < 125000000)
+		return 0;
+
+	if (fvco < 150000000)
+		return 1;
+
+	if (fvco < 175000000)
+		return 2;
+
+	return 3;
+}
+
+static int cdce913_write_pll_cfg(struct clk_cdce913 *cdce913, unsigned int N,
+		unsigned int R, unsigned int Q, unsigned int P,
+		unsigned int range)
+{
+	int err, i;
+	unsigned int addr;
+	unsigned int regs[4];
+
+	if (cdce913->fsbit)
+		addr = CDCE913_PLL_CFG_12;
+	else
+		addr = CDCE913_PLL_CFG_8;
+
+	regs[0] = N >> PLLCFG_N_UPPER_SHIFT;
+
+	regs[1] = (N << PLLCFG_N_LOWER_SHIFT) & PLLCFG_N_LOWER_MASK;
+	regs[1] |= R >> 5;
+
+	regs[2] = (R << PLLCFG_R_LOWER_SHIFT) & PLLCFG_R_LOWER_MASK;
+	regs[2] |= Q >> 3;
+
+	regs[3] = (Q << PLLCFG_Q_LOWER_SHIFT) & PLLCFG_Q_LOWER_MASK;
+	regs[3] |= P << PLLCFG_P_SHIFT;
+	regs[3] |= range;
+
+	/* TODO remove dbg stuff */
+	dev_info(&cdce913->i2c_client->dev, "%s: N=%u, R=%u, Q=%u, P=%u\n",
+			__func__, N, R, Q, P);
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		err = regmap_write(cdce913->regmap, addr + i, regs[i]);
+		if (err)
+			return err;
+	}
+
+	/* TODO remove dbg stuff */
+	cdce913_read_pll_cfg(cdce913, &N, &R, &Q, &P);
+
+	return err;
+}
+
+static int cdce913_pll_set_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long parent_rate)
+{
+	int err, P, R;
+	unsigned int N, Q;
+	struct clk_cdce913_pll *pll = to_clk_cdce913_pll(hw);
+	struct clk_cdce913 *cdce913 = pll->cdce913;
+
+	if (rate > F_VCO_MAX || rate < F_VCO_MIN)
+		return -EINVAL;
+
+	err = cdce913_pll_calc_divs(rate, parent_rate, &N, &R, &Q, &P);
+	if (err)
+		return err;
+
+	/* write to HW */
+	return cdce913_write_pll_cfg(cdce913, N, R, Q, P,
+			cdce913_rate2range(rate));
+}
+
+static struct clk_ops cdce913_pll_ops = {
+	.recalc_rate = cdce913_pll_recalc_rate,
+	.round_rate = cdce913_pll_round_rate,
+	.set_rate = cdce913_pll_set_rate,
+};
+
+static struct clk *clk_register_cdce913_pll(struct clk_cdce913 *cdce913,
+		const char *name, const char *parent)
+{
+	struct clk *clk;
+	const char *pll_name;
+	struct clk_init_data init;
+	struct clk_cdce913_pll *data;
+	const char *parents[] = {parent};
+
+	data = devm_kzalloc(&cdce913->i2c_client->dev, sizeof(*data),
+			GFP_KERNEL);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
+
+	pll_name = kasprintf(GFP_KERNEL, "%s_pll", name);
+	if (!pll_name)
+		return ERR_PTR(-ENOMEM);
+
+	init.ops = &cdce913_pll_ops;
+	init.name = pll_name;
+	init.num_parents = 1;
+	init.parent_names = parents;
+	data->hw.init = &init;
+	data->cdce913 = cdce913;
+
+	clk = devm_clk_register(&cdce913->i2c_client->dev, &data->hw);
+
+	kfree(pll_name);
+
+	return clk;
+}
+
+/* PDIV1 accessors */
+static unsigned int pdiv1_get_div(struct clk_i2c_divider *divider)
+{
+	int err, i;
+	unsigned int regs[2];
+	unsigned int div;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		err = regmap_read(divider->regmap, divider->reg + i, &regs[i]);
+		if (err)
+			break;
+	}
+	if (err) {
+		pr_err("%s: reading from device failed\n", __func__);
+		return 1;
+	}
+
+	div = (regs[0] & PDIV1_UPPER_MASK) << 8;
+	div |= regs[1];
+
+	return div;
+}
+
+static int pdiv1_set_div(unsigned int div, struct clk_i2c_divider *divider)
+{
+	int err, i;
+	unsigned int regs[2];
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		err = regmap_read(divider->regmap, divider->reg + i, &regs[i]);
+		if (err)
+			return err;
+	}
+
+	regs[1] = div & 0xff;
+
+	regs[0] &= ~PDIV1_UPPER_MASK;
+	div >>= 8;
+	div &= PDIV1_UPPER_MASK;
+	regs[0] |= div;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		err = regmap_write(divider->regmap, divider->reg + i, regs[i]);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/* regmap functions */
+static bool cdce913_regmap_is_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case CDCE913_GENERIC_CFG_1:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool cdce913_regmap_is_writeable(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case CDCE913_GENERIC_CFG_1 ... CDCE913_GENERIC_CFG_6:
+		return true;
+	case CDCE913_PLL_CFG_0 ... CDCE913_PLL_CFG_15:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static struct regmap_config cdce913_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.cache_type = REGCACHE_RBTREE,
+	.max_register = CDCE913_PLL_CFG_15,
+	.writeable_reg = cdce913_regmap_is_writeable,
+	.volatile_reg = cdce913_regmap_is_volatile,
+};
+
+/**
+ * cdce913_get_part_id() - Read part identification
+ * @cdce913:	Driver data structure
+ * @dev:	Part ID (output)
+ * @rev:	Part revision (output)
+ * @ven:	Vendor ID (output)
+ * Returns 0 on success, or passes on regmap_read() error.
+ */
+static int cdce913_get_part_id(struct clk_cdce913 *cdce913, unsigned int *dev,
+		unsigned int *rev, unsigned int *ven)
+{
+	int err;
+	unsigned int reg;
+
+	err = regmap_read(cdce913->regmap, CDCE913_GENERIC_CFG_0, &reg);
+	if (err)
+		return err;
+
+	*rev = (reg & GENERIC_CFG0_REVID_MASK) >> GENERIC_CFG0_DEVID_SHIFT;
+	*ven = (reg & GENERIC_CFG0_VENDORID_MASK) >> GENERIC_CFG0_VENDORID_SHIFT;
+	*dev = (reg & GENERIC_CFG0_DEVID_MASK) >> GENERIC_CFG0_DEVID_SHIFT;
+
+	return 0;
+}
+
+/**
+ * cdce913_set_clk_in_type() - Set input clock type
+ * @cdce913:		Driver data structure
+ * @clk_in_type:	String describing input clock type
+ *
+ * Set the input clock type according to the provided DT property. Valid types
+ * are 'xtal', 'VCXO', 'LVCMOS'.
+ */
+static void cdce913_set_clk_in_type(struct clk_cdce913 *cdce913,
+		const char *clk_in_type)
+{
+	int err;
+	unsigned int type, reg;
+	/*
+	 * Valid types are xtal, VCXO, LVCMOS, let's do a lazy compare of the
+	 * first letter only and save us all the strcmp overhead
+	 */
+	switch (clk_in_type[0]) {
+	case 'V':
+		type = 1;
+		break;
+	case 'L':
+		type = 2;
+		break;
+	default:
+		type = 0;
+		break;
+	}
+
+	err = regmap_read(cdce913->regmap, CDCE913_GENERIC_CFG_1, &reg);
+	if (err) {
+		dev_err(&cdce913->i2c_client->dev, "read from device failed\n");
+		return;
+	}
+
+	reg &= ~CLK_IN_TYPE_MASK;
+	reg |= type << CLK_IN_TYPE_SHIFT;
+
+	err = regmap_write(cdce913->regmap, CDCE913_GENERIC_CFG_1, reg);
+	if (err) {
+		dev_err(&cdce913->i2c_client->dev, "write to device failed\n");
+		return;
+	}
+}
+
+static void cdce913_init_frequencies(struct device_node *np,
+		struct clk_cdce913 *data, struct clk *pll)
+{
+	int err, i;
+	u32 fout[3];
+	unsigned long fvco;
+	struct device *dev = &data->i2c_client->dev;
+
+	err = of_property_read_u32_array(np, "clock-frequency", fout,
+			ARRAY_SIZE(fout));
+	if (err)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(fout); i++) {
+		if (fout[i] > F_VCO_MAX) {
+			dev_warn(dev, "requested output frequency '%u' exceeds maximum (%u)\n",
+					fout[i], F_VCO_MAX);
+			fout[i] = F_VCO_MAX;
+		}
+	}
+
+	fvco = lcm(fout[0] / 1000000, fout[1] / 1000000);
+	fvco = lcm(fvco, fout[2] / 1000000);
+	fvco *= 1000000;
+
+	if (fvco > F_VCO_MAX) {
+		dev_warn(dev, "requested VCO frequency '%lu' exceeds maximum (%u)\n",
+				fvco, F_VCO_MAX);
+		fvco = F_VCO_MAX;
+	}
+
+	if (fvco < F_VCO_MIN) {
+		dev_warn(dev, "requested VCO frequency '%lu' below minimum (%u)\n",
+				fvco, F_VCO_MIN);
+		fvco = F_VCO_MIN;
+	}
+
+	err = clk_set_rate(pll, fvco);
+	if (err)
+		return;
+
+	/* TODO dev_dbg */
+	dev_info(dev, "VCO frequency: %lu Hz\n", clk_get_rate(pll));
+
+	for (i = 0; i < ARRAY_SIZE(fout); i++) {
+		if (fout[i])
+			clk_set_rate(data->clk_out[i], fout[i]);
+	}
+}
+
+static int cdce913_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	int err;
+	unsigned int part, revision, vendor, cap;
+	struct clk_cdce913 *data;
+	struct clk *pll, *pll_mux, *y1_mux, *y2_mux, *y3_mux;
+	struct clk *pdiv1, *pdiv2, *pdiv3;
+	const char *pname, *pll_mux_name, *clk_in_type;
+	const char *y1_mux_name, *y2_mux_name, *y3_mux_name;
+	const char *pdiv1_name, *pdiv2_name, *pdiv3_name;
+	const char *pll_mux_parents[2];
+	const char *y1_mux_parents[2], *y2_mux_parents[2], *y3_mux_parents[3];
+	struct device_node *np = client->dev.of_node;
+
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->i2c_client = client;
+
+	data->regmap = devm_regmap_init_i2c(client, &cdce913_regmap_config);
+	if (IS_ERR(data->regmap)) {
+		dev_err(&client->dev, "failed to allocate register map\n");
+		return PTR_ERR(data->regmap);
+	}
+
+	err = of_property_read_u32(np, "ti,s0", &data->s0);
+	if (err) {
+		dev_warn(&client->dev, "S0 not specified, assuming 1\n");
+		data->s0 = 1;
+	}
+
+	err = regmap_read(data->regmap, CDCE913_PLL_CFG_3, &data->fsbit);
+	if (err) {
+		dev_warn(&client->dev, "unable to read from device\n");
+		return err;
+	}
+	data->fsbit = !!(data->fsbit & (1 << data->s0));
+
+	i2c_set_clientdata(client, data);
+
+	err = cdce913_get_part_id(data, &part, &revision, &vendor);
+	if (err)
+		return err;
+
+	pname = of_clk_get_parent_name(np, 0);
+	if (!pname) {
+		dev_err(&client->dev, "no input clock specified\n");
+		return -ENODEV;
+	}
+
+	/* PLL */
+	pll = clk_register_cdce913_pll(data, np->name, pname);
+	if (IS_ERR(pll)) {
+		dev_err(&client->dev, "clock registration failed\n");
+		return PTR_ERR(pll);
+	}
+
+	/* PLL mux */
+	pll_mux_name = kasprintf(GFP_KERNEL, "%s_pll_mux", np->name);
+	if (!pll_mux_name)
+		return -ENOMEM;
+
+	pll_mux_parents[0] = __clk_get_name(pll);
+	pll_mux_parents[1] = pname;
+	pll_mux = clk_i2c_register_mux(&client->dev, pll_mux_name,
+			pll_mux_parents, 2, CLK_SET_RATE_PARENT, data->regmap,
+			CDCE913_PLL_CFG_4, 7, 1, 0);
+	if (IS_ERR(pll_mux)) {
+		dev_err(&client->dev, "clock registration failed\n");
+		err = PTR_ERR(pll_mux);
+		goto err_pll_mux;
+	}
+
+	/* use PLL */
+	err = clk_set_parent(pll_mux, pll);
+	if (err)
+		dev_warn(&client->dev, "PLL in bypass\n");
+
+	/* Y1 mux */
+	y1_mux_name = kasprintf(GFP_KERNEL, "%s_y1_mux", np->name);
+	if (!y1_mux_name) {
+		err = -ENOMEM;
+		goto err_pll_mux;
+	}
+
+	y1_mux_parents[0] = pname;
+	y1_mux_parents[1] = pll_mux_name;
+	y1_mux = clk_i2c_register_mux(&client->dev, y1_mux_name,
+			y1_mux_parents, 2,
+			CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
+			data->regmap, CDCE913_GENERIC_CFG_2, 7, 1, 0);
+	if (IS_ERR(y1_mux)) {
+		dev_err(&client->dev, "clock registration failed\n");
+		err = PTR_ERR(y1_mux);
+		goto err_y1_mux;
+	}
+
+	/* pdiv1 */
+	pdiv1_name = kasprintf(GFP_KERNEL, "%s_pdiv1", np->name);
+	if (!pdiv1_name) {
+		err = -ENOMEM;
+		goto err_y1_mux;
+	}
+
+	pdiv1 = clk_i2c_register_divider(&client->dev, pdiv1_name, y1_mux_name,
+			CLK_SET_RATE_PARENT, data->regmap, CDCE913_GENERIC_CFG_2, 0, 10,
+			CLK_DIVIDER_ONE_BASED, pdiv1_get_div, pdiv1_set_div);
+	if (IS_ERR(pdiv1)) {
+		dev_err(&client->dev, "clock registration failed\n");
+		err = PTR_ERR(pdiv1);
+		goto err_pdiv1;
+	}
+
+	/* pdiv2 */
+	pdiv2_name = kasprintf(GFP_KERNEL, "%s_pdiv2", np->name);
+	if (!pdiv2_name) {
+		err = -ENOMEM;
+		goto err_pdiv1;
+	}
+
+	pdiv2 = clk_i2c_register_divider(&client->dev, pdiv2_name,
+			pll_mux_name, CLK_SET_RATE_PARENT, data->regmap,
+			CDCE913_PLL_CFG_6, 0, 7, CLK_DIVIDER_ONE_BASED, NULL,
+			NULL);
+	if (IS_ERR(pdiv2)) {
+		dev_err(&client->dev, "clock registration failed\n");
+		err = PTR_ERR(pdiv2);
+		goto err_pdiv2;
+	}
+
+	/* pdiv3 */
+	pdiv3_name = kasprintf(GFP_KERNEL, "%s_pdiv3", np->name);
+	if (!pdiv3_name) {
+		err = -ENOMEM;
+		goto err_pdiv2;
+	}
+
+	pdiv3 = clk_i2c_register_divider(&client->dev, pdiv3_name,
+			pll_mux_name, CLK_SET_RATE_PARENT, data->regmap,
+			CDCE913_PLL_CFG_7, 0, 7, CLK_DIVIDER_ONE_BASED, NULL,
+			NULL);
+	if (IS_ERR(pdiv3)) {
+		dev_err(&client->dev, "clock registration failed\n");
+		err = PTR_ERR(pdiv3);
+		goto err_pdiv3;
+	}
+
+	/* Y2 mux */
+	y2_mux_name = kasprintf(GFP_KERNEL, "%s_y2_mux", np->name);
+	if (!y2_mux_name) {
+		err = -ENOMEM;
+		goto err_pdiv3;
+	}
+
+	y2_mux_parents[0] = pdiv1_name;
+	y2_mux_parents[1] = pdiv2_name;
+	y2_mux = clk_i2c_register_mux(&client->dev, y2_mux_name,
+			y2_mux_parents, 2,
+			CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
+			data->regmap, CDCE913_PLL_CFG_4, 6, 1, 0);
+	if (IS_ERR(y2_mux)) {
+		dev_err(&client->dev, "clock registration failed\n");
+		err = PTR_ERR(y2_mux);
+		goto err_y2_mux;
+	}
+
+	/* Y3 mux */
+	y3_mux_name = kasprintf(GFP_KERNEL, "%s_y3_mux", np->name);
+	if (!y3_mux_name) {
+		err = -ENOMEM;
+		goto err_y2_mux;
+	}
+
+	y3_mux_parents[0] = pdiv1_name;
+	y3_mux_parents[1] = pdiv2_name;
+	y3_mux_parents[2] = pdiv3_name;
+	y3_mux = clk_i2c_register_mux(&client->dev, y3_mux_name,
+			y3_mux_parents, 3,
+			CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
+			data->regmap, CDCE913_PLL_CFG_4, 4, 2, 0);
+	if (IS_ERR(y3_mux)) {
+		dev_err(&client->dev, "clock registration failed\n");
+		err = PTR_ERR(y3_mux);
+		goto err_y3_mux;
+	}
+
+	err = of_property_read_u32(np, "ti,crystal-load-capacity", &cap);
+	if (!err) {
+		if (cap > 20)
+			cap = 20;
+		cap <<= XTAL_LOAD_CAP_SHIFT;
+		err = regmap_write(data->regmap, CDCE913_GENERIC_CFG_5, cap);
+		if (err)
+			dev_warn(&client->dev, "unable to write to device\n");
+	}
+
+	err = of_property_read_string(np, "ti,input-clock-type", &clk_in_type);
+	if (!err)
+		cdce913_set_clk_in_type(data, clk_in_type);
+
+err_y3_mux:
+	kfree(y3_mux_name);
+err_y2_mux:
+	kfree(y2_mux_name);
+err_pdiv3:
+	kfree(pdiv3_name);
+err_pdiv2:
+	kfree(pdiv2_name);
+err_pdiv1:
+	kfree(pdiv1_name);
+err_y1_mux:
+	kfree(y1_mux_name);
+err_pll_mux:
+	kfree(pll_mux_name);
+
+	if (err)
+		return err;
+
+	data->clk_out[0] = pdiv1;
+	data->clk_out[1] = y2_mux;
+	data->clk_out[2] = y3_mux;
+
+	data->clk_data.clks = data->clk_out;
+	data->clk_data.clk_num = ARRAY_SIZE(data->clk_out);
+	err = of_clk_add_provider(np, of_clk_src_onecell_get, &data->clk_data);
+	if (err)
+		goto err_clk_provider;
+
+	cdce913_init_frequencies(np, data, pll);
+
+	dev_info(&client->dev, "%s %u/%u: current frequencies: %lu, %lu, %lu\n",
+			part ? "CDCE913" : "CDCEL913", vendor, revision,
+			clk_get_rate(data->clk_out[0]),
+			clk_get_rate(data->clk_out[1]),
+			clk_get_rate(data->clk_out[2]));
+
+err_clk_provider:
+	return err;
+}
+
+static int cdce913_remove(struct i2c_client *client)
+{
+	of_clk_del_provider(client->dev.of_node);
+	return 0;
+}
+
+static const struct i2c_device_id cdce913_id[] = {
+	{ "cdce913" },
+	{ "cdcel913" },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, cdce_id);
+
+static const struct of_device_id clk_cdce913_of_match[] = {
+	{ .compatible = "ti,cdce913" },
+	{ .compatible = "ti,cdcel913" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, clk_cdce913_of_match);
+
+static struct i2c_driver cdce913_driver = {
+	.driver = {
+		.name = "cdce913",
+		.of_match_table = of_match_ptr(clk_cdce913_of_match),
+	},
+	.probe		= cdce913_probe,
+	.remove		= cdce913_remove,
+	.id_table	= cdce913_id,
+};
+module_i2c_driver(cdce913_driver);
+
+MODULE_AUTHOR("Soeren Brinkmann <soren.brinkmann@xilinx.com");
+MODULE_DESCRIPTION("CDCE913 driver");
+MODULE_LICENSE("GPL");
-- 
1.9.0.1.g4196000

