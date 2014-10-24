Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbaJXRRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:17:34 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:41772 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbaJXRRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:17:32 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Mike Turquette <mturquette@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] clk: TI CDCE706 clock synthesizer driver
Date: Fri, 24 Oct 2014 21:17:00 +0400
Message-Id: <1414171020-15706-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver allows using CDCE706 in its default configuration recorded in
EEPROM and adjusting of synthesized clocks by consumers.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 .../devicetree/bindings/clock/ti,cdce706.txt       |  16 +
 MAINTAINERS                                        |   5 +
 drivers/clk/Kconfig                                |   8 +
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-cdce706.c                          | 700 +++++++++++++++++++++
 5 files changed, 730 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/ti,cdce706.txt
 create mode 100644 drivers/clk/clk-cdce706.c

diff --git a/Documentation/devicetree/bindings/clock/ti,cdce706.txt b/Documentation/devicetree/bindings/clock/ti,cdce706.txt
new file mode 100644
index 0000000..a1d73d1
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/ti,cdce706.txt
@@ -0,0 +1,16 @@
+Bindings for Texas Instruments CDCE706 programmable 3-PLL clock
+synthesizer/multiplier/divider.
+
+Reference: http://www.ti.com/lit/ds/symlink/cdce706.pdf
+
+I2C device node required properties:
+- compatible: shall be "ti,cdce706".
+- reg: i2c device address, shall be in range [0x68...0x6b].
+- #clock-cells: from common clock binding; shall be set to 1.
+- clocks: from common clock binding; list of parent clock
+  handles, shall be reference clock(s) connected to CLK_IN0
+  and CLK_IN1 pins.
+- clock-names: shall be clk_in0 and/or clk_in1. Use clk_in0
+  in case of crystal oscillator or differential signal input
+  configuration. Use clk_in0 and clk_in1 in case of independent
+  single-ended LVCMOS inputs configuration.
diff --git a/MAINTAINERS b/MAINTAINERS
index f10ed39..acb4523 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9138,6 +9138,11 @@ L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	drivers/thermal/ti-soc-thermal/
 
+TI CDCE706 CLOCK DRIVER
+M:	Max Filippov <jcmvbkbc@gmail.com>
+S:	Maintained
+F:	drivers/clk/clk-cdce706.c
+
 TI CLOCK DRIVER
 M:	Tero Kristo <t-kristo@ti.com>
 L:	linux-omap@vger.kernel.org
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index cfd3af7..468fe43 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -109,6 +109,14 @@ config COMMON_CLK_PALMAS
 	  This driver supports TI Palmas devices 32KHz output KG and KG_AUDIO
 	  using common clock framework.
 
+config COMMON_CLK_CDCE706
+	tristate "Clock driver for TI CDCE706 clock synthesizer"
+	depends on I2C
+	select REGMAP_I2C
+	select RATIONAL
+	---help---
+	  This driver supports TI CDCE706 programmable 3-PLL clock synthesizer.
+
 source "drivers/clk/qcom/Kconfig"
 
 endmenu
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index f537a0b..4393edd 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -18,6 +18,7 @@ endif
 obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN)	+= clk-axi-clkgen.o
 obj-$(CONFIG_ARCH_AXXIA)		+= clk-axm5516.o
 obj-$(CONFIG_ARCH_BCM2835)		+= clk-bcm2835.o
+obj-$(CONFIG_COMMON_CLK_CDCE706)	+= clk-cdce706.o
 obj-$(CONFIG_ARCH_CLPS711X)		+= clk-clps711x.o
 obj-$(CONFIG_ARCH_EFM32)		+= clk-efm32gg.o
 obj-$(CONFIG_ARCH_HIGHBANK)		+= clk-highbank.o
diff --git a/drivers/clk/clk-cdce706.c b/drivers/clk/clk-cdce706.c
new file mode 100644
index 0000000..c386ad2
--- /dev/null
+++ b/drivers/clk/clk-cdce706.c
@@ -0,0 +1,700 @@
+/*
+ * TI CDCE706 programmable 3-PLL clock synthesizer driver
+ *
+ * Copyright (c) 2014 Cadence Design Systems Inc.
+ *
+ * Reference: http://www.ti.com/lit/ds/symlink/cdce706.pdf
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/rational.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+#define CDCE706_CLKIN_CLOCK		10
+#define CDCE706_CLKIN_SOURCE		11
+#define CDCE706_PLL_M_LOW(pll)		(1 + 3 * (pll))
+#define CDCE706_PLL_N_LOW(pll)		(2 + 3 * (pll))
+#define CDCE706_PLL_HI(pll)		(3 + 3 * (pll))
+#define CDCE706_PLL_MUX			3
+#define CDCE706_PLL_FVCO		6
+#define CDCE706_DIVIDER(div)		(13 + (div))
+#define CDCE706_CLKOUT(out)		(19 + (out))
+
+#define CDCE706_CLKIN_CLOCK_MASK	0x10
+#define CDCE706_CLKIN_SOURCE_SHIFT	6
+#define CDCE706_CLKIN_SOURCE_MASK	0xc0
+#define CDCE706_CLKIN_SOURCE_LVCMOS	0x40
+
+#define CDCE706_PLL_MUX_MASK(pll)	(0x80 >> (pll))
+#define CDCE706_PLL_LOW_M_MASK		0xff
+#define CDCE706_PLL_LOW_N_MASK		0xff
+#define CDCE706_PLL_HI_M_MASK		0x1
+#define CDCE706_PLL_HI_N_MASK		0x1e
+#define CDCE706_PLL_HI_N_SHIFT		1
+#define CDCE706_PLL_M_MAX		0x1ff
+#define CDCE706_PLL_N_MAX		0xfff
+#define CDCE706_PLL_FVCO_MASK(pll)	(0x80 >> (pll))
+#define CDCE706_PLL_FREQ_MIN		 80000000
+#define CDCE706_PLL_FREQ_MAX		300000000
+#define CDCE706_PLL_FREQ_HI		180000000
+
+#define CDCE706_DIVIDER_PLL(div)	(9 + (div) - ((div) > 2) - ((div) > 4))
+#define CDCE706_DIVIDER_PLL_SHIFT(div)	((div) < 2 ? 5 : 3 * ((div) & 1))
+#define CDCE706_DIVIDER_PLL_MASK(div)	(0x7 << CDCE706_DIVIDER_PLL_SHIFT(div))
+#define CDCE706_DIVIDER_DIVIDER_MASK	0x7f
+#define CDCE706_DIVIDER_DIVIDER_MAX	0x7f
+
+#define CDCE706_CLKOUT_DIVIDER_MASK	0x7
+#define CDCE706_CLKOUT_ENABLE_MASK	0x8
+
+static struct regmap_config cdce706_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.val_format_endian = REGMAP_ENDIAN_NATIVE,
+};
+
+#define to_hw_data(phw) (container_of((phw), struct cdce706_hw_data, hw))
+
+struct cdce706_hw_data {
+	struct cdce706_dev_data *dev_data;
+	unsigned idx;
+	unsigned parent;
+	struct clk *clk;
+	struct clk_hw hw;
+	unsigned div;
+	unsigned mul;
+	unsigned mux;
+};
+
+struct cdce706_dev_data {
+	struct i2c_client *client;
+	struct regmap *regmap;
+	struct clk_onecell_data onecell;
+	struct clk *clks[6];
+	struct clk *clkin_clk[2];
+	const char *clkin_name[2];
+	struct cdce706_hw_data clkin[1];
+	struct cdce706_hw_data pll[3];
+	struct cdce706_hw_data divider[6];
+	struct cdce706_hw_data clkout[6];
+};
+
+static const char * const cdce706_source_name[] = {
+	"clk_in0", "clk_in1",
+};
+
+static const char *cdce706_clkin_name[] = {
+	"clk_in",
+};
+
+static const char * const cdce706_pll_name[] = {
+	"pll1", "pll2", "pll3",
+};
+
+static const char *cdce706_divider_parent_name[] = {
+	"clk_in", "pll1", "pll2", "pll2", "pll3",
+};
+
+static const char *cdce706_divider_name[] = {
+	"p0", "p1", "p2", "p3", "p4", "p5",
+};
+
+static const char * const cdce706_clkout_name[] = {
+	"clk_out0", "clk_out1", "clk_out2", "clk_out3", "clk_out4", "clk_out5",
+};
+
+static int cdce706_reg_read(struct cdce706_dev_data *dev_data, unsigned reg,
+			    unsigned *val)
+{
+	int rc = regmap_read(dev_data->regmap, reg | 0x80, val);
+
+	if (rc < 0)
+		dev_err(&dev_data->client->dev, "error reading reg %u", reg);
+	return rc;
+}
+
+static int cdce706_reg_write(struct cdce706_dev_data *dev_data, unsigned reg,
+			     unsigned val)
+{
+	int rc = regmap_write(dev_data->regmap, reg | 0x80, val);
+
+	if (rc < 0)
+		dev_err(&dev_data->client->dev, "error writing reg %u", reg);
+	return rc;
+}
+
+static int cdce706_reg_update(struct cdce706_dev_data *dev_data, unsigned reg,
+			      unsigned mask, unsigned val)
+{
+	int rc = regmap_update_bits(dev_data->regmap, reg | 0x80, mask, val);
+
+	if (rc < 0)
+		dev_err(&dev_data->client->dev, "error updating reg %u", reg);
+	return rc;
+}
+
+static int cdce706_clkin_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	hwd->parent = index;
+	return 0;
+}
+
+static u8 cdce706_clkin_get_parent(struct clk_hw *hw)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	return hwd->parent;
+}
+
+static const struct clk_ops cdce706_clkin_ops = {
+	.set_parent = cdce706_clkin_set_parent,
+	.get_parent = cdce706_clkin_get_parent,
+};
+
+static unsigned long cdce706_pll_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	dev_dbg(&hwd->dev_data->client->dev,
+		"%s, pll: %d, mux: %d, mul: %u, div: %u\n",
+		__func__, hwd->idx, hwd->mux, hwd->mul, hwd->div);
+
+	if (!hwd->mux) {
+		if (hwd->div && hwd->mul) {
+			u64 res = (u64)parent_rate * hwd->mul;
+
+			do_div(res, hwd->div);
+			return res;
+		}
+	} else {
+		if (hwd->div)
+			return parent_rate / hwd->div;
+	}
+	return 0;
+}
+
+static long cdce706_pll_round_rate(struct clk_hw *hw, unsigned long rate,
+				   unsigned long *parent_rate)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+	unsigned long mul, div;
+	u64 res;
+
+	dev_dbg(&hwd->dev_data->client->dev,
+		"%s, rate: %lu, parent_rate: %lu\n",
+		__func__, rate, *parent_rate);
+
+	rational_best_approximation(rate, *parent_rate,
+				    CDCE706_PLL_N_MAX, CDCE706_PLL_M_MAX,
+				    &mul, &div);
+	hwd->mul = mul;
+	hwd->div = div;
+
+	dev_dbg(&hwd->dev_data->client->dev,
+		"%s, pll: %d, mul: %lu, div: %lu\n",
+		__func__, hwd->idx, mul, div);
+
+	res = (u64)*parent_rate * hwd->mul;
+	do_div(res, hwd->div);
+	return res;
+}
+
+static int cdce706_pll_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+	unsigned long mul = hwd->mul, div = hwd->div;
+	int err;
+
+	dev_dbg(&hwd->dev_data->client->dev,
+		"%s, pll: %d, mul: %lu, div: %lu\n",
+		__func__, hwd->idx, mul, div);
+
+	err = cdce706_reg_update(hwd->dev_data,
+				 CDCE706_PLL_HI(hwd->idx),
+				 CDCE706_PLL_HI_M_MASK | CDCE706_PLL_HI_N_MASK,
+				 ((div >> 8) & CDCE706_PLL_HI_M_MASK) |
+				 ((mul >> (8 - CDCE706_PLL_HI_N_SHIFT)) &
+				  CDCE706_PLL_HI_N_MASK));
+	if (err < 0)
+		return err;
+
+	err = cdce706_reg_write(hwd->dev_data,
+				CDCE706_PLL_M_LOW(hwd->idx),
+				div & CDCE706_PLL_LOW_M_MASK);
+	if (err < 0)
+		return err;
+
+	err = cdce706_reg_write(hwd->dev_data,
+				CDCE706_PLL_N_LOW(hwd->idx),
+				mul & CDCE706_PLL_LOW_N_MASK);
+	if (err < 0)
+		return err;
+
+	err = cdce706_reg_update(hwd->dev_data,
+				 CDCE706_PLL_FVCO,
+				 CDCE706_PLL_FVCO_MASK(hwd->idx),
+				 rate > CDCE706_PLL_FREQ_HI ?
+				 CDCE706_PLL_FVCO_MASK(hwd->idx) : 0);
+	return err;
+}
+
+static const struct clk_ops cdce706_pll_ops = {
+	.recalc_rate = cdce706_pll_recalc_rate,
+	.round_rate = cdce706_pll_round_rate,
+	.set_rate = cdce706_pll_set_rate,
+};
+
+static int cdce706_divider_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	if (hwd->parent == index)
+		return 0;
+	hwd->parent = index;
+	return cdce706_reg_update(hwd->dev_data,
+				  CDCE706_DIVIDER_PLL(hwd->idx),
+				  CDCE706_DIVIDER_PLL_MASK(hwd->idx),
+				  index << CDCE706_DIVIDER_PLL_SHIFT(hwd->idx));
+}
+
+static u8 cdce706_divider_get_parent(struct clk_hw *hw)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	return hwd->parent;
+}
+
+static unsigned long cdce706_divider_recalc_rate(struct clk_hw *hw,
+						 unsigned long parent_rate)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	dev_dbg(&hwd->dev_data->client->dev,
+		"%s, divider: %d, div: %u\n",
+		__func__, hwd->idx, hwd->div);
+	if (hwd->div)
+		return parent_rate / hwd->div;
+	return 0;
+}
+
+static long cdce706_divider_round_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long *parent_rate)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+	struct cdce706_dev_data *cdce = hwd->dev_data;
+	unsigned long mul, div;
+
+	dev_dbg(&hwd->dev_data->client->dev,
+		"%s, rate: %lu, parent_rate: %lu\n",
+		__func__, rate, *parent_rate);
+
+	rational_best_approximation(rate, *parent_rate,
+				    1, CDCE706_DIVIDER_DIVIDER_MAX,
+				    &mul, &div);
+	if (!mul)
+		div = CDCE706_DIVIDER_DIVIDER_MAX;
+
+	if (__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT) {
+		unsigned long best_diff = rate;
+		unsigned long best_div = 0;
+		struct clk *gp_clk = cdce->clkin_clk[cdce->clkin[0].parent];
+		unsigned long gp_rate = gp_clk ? clk_get_rate(gp_clk) : 0;
+
+		for (div = CDCE706_PLL_FREQ_MIN / rate; best_diff &&
+		     div <= CDCE706_PLL_FREQ_MAX / rate; ++div) {
+			unsigned long n, m;
+			unsigned long diff;
+			unsigned long div_rate;
+			u64 div_rate64;
+
+			if (rate * div < CDCE706_PLL_FREQ_MIN)
+				continue;
+
+			rational_best_approximation(rate * div, gp_rate,
+						    CDCE706_PLL_N_MAX,
+						    CDCE706_PLL_M_MAX,
+						    &n, &m);
+			div_rate64 = (u64)gp_rate * n;
+			do_div(div_rate64, m);
+			do_div(div_rate64, div);
+			div_rate = div_rate64;
+			diff = max(div_rate, rate) - min(div_rate, rate);
+
+			if (diff < best_diff) {
+				best_diff = diff;
+				best_div = div;
+				dev_dbg(&hwd->dev_data->client->dev,
+					"%s, %lu * %lu / %lu / %lu = %lu\n",
+					__func__, gp_rate, n, m, div, div_rate);
+			}
+		}
+
+		div = best_div;
+
+		dev_dbg(&hwd->dev_data->client->dev,
+			"%s, altering parent rate: %lu -> %lu\n",
+			__func__, *parent_rate, rate * div);
+		*parent_rate = rate * div;
+	}
+	hwd->div = div;
+
+	dev_dbg(&hwd->dev_data->client->dev,
+		"%s, divider: %d, div: %lu\n",
+		__func__, hwd->idx, div);
+
+	return *parent_rate / div;
+}
+
+static int cdce706_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+				    unsigned long parent_rate)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	dev_dbg(&hwd->dev_data->client->dev,
+		"%s, divider: %d, div: %u\n",
+		__func__, hwd->idx, hwd->div);
+
+	return cdce706_reg_update(hwd->dev_data,
+				  CDCE706_DIVIDER(hwd->idx),
+				  CDCE706_DIVIDER_DIVIDER_MASK,
+				  hwd->div);
+}
+
+static const struct clk_ops cdce706_divider_ops = {
+	.set_parent = cdce706_divider_set_parent,
+	.get_parent = cdce706_divider_get_parent,
+	.recalc_rate = cdce706_divider_recalc_rate,
+	.round_rate = cdce706_divider_round_rate,
+	.set_rate = cdce706_divider_set_rate,
+};
+
+static int cdce706_clkout_prepare(struct clk_hw *hw)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	return cdce706_reg_update(hwd->dev_data, CDCE706_CLKOUT(hwd->idx),
+				  CDCE706_CLKOUT_ENABLE_MASK,
+				  CDCE706_CLKOUT_ENABLE_MASK);
+}
+
+static void cdce706_clkout_unprepare(struct clk_hw *hw)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	cdce706_reg_update(hwd->dev_data, CDCE706_CLKOUT(hwd->idx),
+			   CDCE706_CLKOUT_ENABLE_MASK, 0);
+}
+
+static int cdce706_clkout_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	if (hwd->parent == index)
+		return 0;
+	hwd->parent = index;
+	return cdce706_reg_update(hwd->dev_data,
+				  CDCE706_CLKOUT(hwd->idx),
+				  CDCE706_CLKOUT_ENABLE_MASK, index);
+}
+
+static u8 cdce706_clkout_get_parent(struct clk_hw *hw)
+{
+	struct cdce706_hw_data *hwd = to_hw_data(hw);
+
+	return hwd->parent;
+}
+
+static unsigned long cdce706_clkout_recalc_rate(struct clk_hw *hw,
+						unsigned long parent_rate)
+{
+	return parent_rate;
+}
+
+static long cdce706_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *parent_rate)
+{
+	*parent_rate = rate;
+	return rate;
+}
+
+static int cdce706_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
+				   unsigned long parent_rate)
+{
+	return 0;
+}
+
+static const struct clk_ops cdce706_clkout_ops = {
+	.prepare = cdce706_clkout_prepare,
+	.unprepare = cdce706_clkout_unprepare,
+	.set_parent = cdce706_clkout_set_parent,
+	.get_parent = cdce706_clkout_get_parent,
+	.recalc_rate = cdce706_clkout_recalc_rate,
+	.round_rate = cdce706_clkout_round_rate,
+	.set_rate = cdce706_clkout_set_rate,
+};
+
+static int cdce706_register_hw(struct cdce706_dev_data *cdce,
+			       struct cdce706_hw_data *hw, unsigned num_hw,
+			       const char * const *clk_names,
+			       struct clk_init_data *init)
+{
+	unsigned i;
+
+	for (i = 0; i < num_hw; ++i, ++hw) {
+		init->name = clk_names[i];
+		hw->dev_data = cdce;
+		hw->idx = i;
+		hw->hw.init = init;
+		hw->clk = devm_clk_register(&cdce->client->dev,
+					    &hw->hw);
+		if (IS_ERR(hw->clk)) {
+			dev_err(&cdce->client->dev, "Failed to register %s\n",
+				clk_names[i]);
+			return PTR_ERR(hw->clk);
+		}
+	}
+	return 0;
+}
+
+static int cdce706_register_clkin(struct cdce706_dev_data *cdce)
+{
+	struct clk_init_data init = {
+		.ops = &cdce706_clkin_ops,
+		.parent_names = cdce->clkin_name,
+		.num_parents = ARRAY_SIZE(cdce->clkin_name),
+	};
+	unsigned i;
+	int ret;
+	unsigned clock, source;
+
+	for (i = 0; i < ARRAY_SIZE(cdce->clkin_name); ++i) {
+		struct clk *parent = devm_clk_get(&cdce->client->dev,
+						  cdce706_source_name[i]);
+
+		if (IS_ERR(parent)) {
+			cdce->clkin_name[i] = cdce706_source_name[i];
+		} else {
+			cdce->clkin_name[i] = __clk_get_name(parent);
+			cdce->clkin_clk[i] = parent;
+		}
+	}
+
+	ret = cdce706_reg_read(cdce, CDCE706_CLKIN_SOURCE, &source);
+	if (ret < 0)
+		return ret;
+	if ((source & CDCE706_CLKIN_SOURCE_MASK) ==
+	    CDCE706_CLKIN_SOURCE_LVCMOS) {
+		ret = cdce706_reg_read(cdce, CDCE706_CLKIN_CLOCK, &clock);
+		if (ret < 0)
+			return ret;
+		cdce->clkin[0].parent = !!(clock & CDCE706_CLKIN_CLOCK_MASK);
+	}
+
+	ret = cdce706_register_hw(cdce, cdce->clkin,
+				  ARRAY_SIZE(cdce->clkin),
+				  cdce706_clkin_name, &init);
+	return ret;
+}
+
+static int cdce706_register_plls(struct cdce706_dev_data *cdce)
+{
+	struct clk_init_data init = {
+		.ops = &cdce706_pll_ops,
+		.parent_names = cdce706_clkin_name,
+		.num_parents = ARRAY_SIZE(cdce706_clkin_name),
+	};
+	unsigned i;
+	int ret;
+	unsigned mux;
+
+	ret = cdce706_reg_read(cdce, CDCE706_PLL_MUX, &mux);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(cdce->pll); ++i) {
+		unsigned m, n, v;
+
+		ret = cdce706_reg_read(cdce, CDCE706_PLL_M_LOW(i), &m);
+		if (ret < 0)
+			return ret;
+		ret = cdce706_reg_read(cdce, CDCE706_PLL_N_LOW(i), &n);
+		if (ret < 0)
+			return ret;
+		ret = cdce706_reg_read(cdce, CDCE706_PLL_HI(i), &v);
+		if (ret < 0)
+			return ret;
+		cdce->pll[i].div = m | ((v & CDCE706_PLL_HI_M_MASK) << 8);
+		cdce->pll[i].mul = n | ((v & CDCE706_PLL_HI_N_MASK) <<
+					(8 - CDCE706_PLL_HI_N_SHIFT));
+		cdce->pll[i].mux = mux & CDCE706_PLL_MUX_MASK(i);
+		dev_dbg(&cdce->client->dev,
+			"%s: i: %u, div: %u, mul: %u, mux: %d\n", __func__, i,
+			cdce->pll[i].div, cdce->pll[i].mul, cdce->pll[i].mux);
+	}
+
+	ret = cdce706_register_hw(cdce, cdce->pll,
+				  ARRAY_SIZE(cdce->pll),
+				  cdce706_pll_name, &init);
+	return ret;
+}
+
+static int cdce706_register_dividers(struct cdce706_dev_data *cdce)
+{
+	struct clk_init_data init = {
+		.ops = &cdce706_divider_ops,
+		.parent_names = cdce706_divider_parent_name,
+		.num_parents = ARRAY_SIZE(cdce706_divider_parent_name),
+		.flags = CLK_SET_RATE_PARENT,
+	};
+	unsigned i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(cdce->divider); ++i) {
+		unsigned val;
+
+		ret = cdce706_reg_read(cdce, CDCE706_DIVIDER_PLL(i), &val);
+		if (ret < 0)
+			return ret;
+		cdce->divider[i].parent =
+			(val & CDCE706_DIVIDER_PLL_MASK(i)) >>
+			CDCE706_DIVIDER_PLL_SHIFT(i);
+
+		ret = cdce706_reg_read(cdce, CDCE706_DIVIDER(i), &val);
+		if (ret < 0)
+			return ret;
+		cdce->divider[i].div = val & CDCE706_DIVIDER_DIVIDER_MASK;
+		dev_dbg(&cdce->client->dev,
+			"%s: i: %u, parent: %u, div: %u\n", __func__, i,
+			cdce->divider[i].parent, cdce->divider[i].div);
+	}
+
+	ret = cdce706_register_hw(cdce, cdce->divider,
+				  ARRAY_SIZE(cdce->divider),
+				  cdce706_divider_name, &init);
+	return ret;
+}
+
+static int cdce706_register_clkouts(struct cdce706_dev_data *cdce)
+{
+	struct clk_init_data init = {
+		.ops = &cdce706_clkout_ops,
+		.parent_names = cdce706_divider_name,
+		.num_parents = ARRAY_SIZE(cdce706_divider_name),
+		.flags = CLK_SET_RATE_PARENT,
+	};
+	unsigned i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(cdce->clkout); ++i) {
+		unsigned val;
+
+		ret = cdce706_reg_read(cdce, CDCE706_CLKOUT(i), &val);
+		if (ret < 0)
+			return ret;
+		cdce->clkout[i].parent = val & CDCE706_CLKOUT_DIVIDER_MASK;
+		dev_dbg(&cdce->client->dev,
+			"%s: i: %u, parent: %u\n", __func__, i,
+			cdce->clkout[i].parent);
+	}
+
+	ret = cdce706_register_hw(cdce, cdce->clkout,
+				  ARRAY_SIZE(cdce->clkout),
+				  cdce706_clkout_name, &init);
+	for (i = 0; i < ARRAY_SIZE(cdce->clkout); ++i)
+		cdce->clks[i] = cdce->clkout[i].clk;
+
+	return ret;
+}
+
+static int cdce706_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct cdce706_dev_data *cdce;
+	int ret;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	cdce = devm_kzalloc(&client->dev, sizeof(*cdce), GFP_KERNEL);
+	if (!cdce)
+		return -ENOMEM;
+
+	cdce->client = client;
+	cdce->regmap = devm_regmap_init_i2c(client, &cdce706_regmap_config);
+	if (IS_ERR(cdce->regmap)) {
+		dev_err(&client->dev, "Failed to initialize regmap\n");
+		return -EINVAL;
+	}
+
+	i2c_set_clientdata(client, cdce);
+
+	ret = cdce706_register_clkin(cdce);
+	if (ret < 0)
+		return ret;
+	ret = cdce706_register_plls(cdce);
+	if (ret < 0)
+		return ret;
+	ret = cdce706_register_dividers(cdce);
+	if (ret < 0)
+		return ret;
+	ret = cdce706_register_clkouts(cdce);
+	if (ret < 0)
+		return ret;
+	cdce->onecell.clks = cdce->clks;
+	cdce->onecell.clk_num = ARRAY_SIZE(cdce->clks);
+	ret = of_clk_add_provider(client->dev.of_node, of_clk_src_onecell_get,
+				  &cdce->onecell);
+
+	return ret;
+}
+
+static int cdce706_remove(struct i2c_client *client)
+{
+	return 0;
+}
+
+
+#ifdef CONFIG_OF
+static const struct of_device_id cdce706_dt_match[] = {
+	{ .compatible = "ti,cdce706" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, cdce706_dt_match);
+#endif
+
+static const struct i2c_device_id cdce706_id[] = {
+	{ "cdce706", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, cdce706_id);
+
+static struct i2c_driver cdce706_i2c_driver = {
+	.driver	= {
+		.name	= "cdce706",
+		.of_match_table = of_match_ptr(cdce706_dt_match),
+	},
+	.probe		= cdce706_probe,
+	.remove		= cdce706_remove,
+	.id_table	= cdce706_id,
+};
+module_i2c_driver(cdce706_i2c_driver);
+
+MODULE_AUTHOR("Max Filippov <jcmvbkbc@gmail.com>");
+MODULE_DESCRIPTION("TI CDCE 706 clock synthesizer driver");
+MODULE_LICENSE("GPL");
-- 
1.8.1.4

