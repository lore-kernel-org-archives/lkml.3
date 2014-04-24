Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaDXKwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:52:41 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:4301
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755807AbaDXKqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:46:12 -0400
From: Anders Berg <anders.berg@lsi.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH v2 2/6] clk: Add clock driver for AXM55xx SoC
Date: Thu, 24 Apr 2014 12:44:05 +0200
Message-ID: <e75e546cd948eab07e55dce89ca934bc25d5f2a6.1398335771.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1398335771.git.anders.berg@lsi.com>
References: <cover.1398335771.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA040.namprd07.prod.outlook.com (10.141.251.15) To
 CO1PR07MB377.namprd07.prod.outlook.com (10.141.74.156)
X-Forefront-PRVS: 01917B1794
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(189002)(199002)(80976001)(83322001)(19580405001)(50226001)(53416003)(31966008)(74662001)(19580395003)(99396002)(85852003)(77982001)(89996001)(47776003)(46102001)(83072002)(42186004)(79102001)(76482001)(20776003)(80022001)(66066001)(4396001)(74502001)(86362001)(93916002)(87286001)(88136002)(36756003)(50466002)(33646001)(87976001)(76176999)(77156001)(50986999)(81542001)(81342001)(62966002)(48376002)(92726001)(92566001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB377;H:swsaberg01.lsi.com;FPR:F2796C54.20E096E1.36F29D8F.CC24331A.20577;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clk driver to support clock blocks found on the AXM55xx devices. The driver
provides clock implementations for three different types of clock devices on
the AXM55xx device: PLL clock, a clock divider and a clock mux.

Signed-off-by: Anders Berg <anders.berg@lsi.com>
---
 .../devicetree/bindings/clock/clk-axxia.txt        |  88 +++++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-axxia.c                            | 281 +++++++++++++++++++++
 3 files changed, 370 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-axxia.txt
 create mode 100644 drivers/clk/clk-axxia.c

diff --git a/Documentation/devicetree/bindings/clock/clk-axxia.txt b/Documentation/devicetree/bindings/clock/clk-axxia.txt
new file mode 100644
index 0000000..94eb840
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clk-axxia.txt
@@ -0,0 +1,88 @@
+* Axxia clock driver bindings
+
+This document contains bindings for the Axxia PLL, clock divider and mux. The
+binding uses the common clock binding found in:
+
+	Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+* Axxia PLL
+
+Required properties:
+- #clock-cells : shall be set to 0.
+- compatible : shall be "lsi,axxia-pll-clock"
+- clocks : parent clock phandle
+- reg - specifies PLL control registers
+
+Optional properties:
+- clock-output-names : From common clock binding.
+
+Example:
+
+	clk_ref0: clk_ref0 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <125000000>;
+	};
+
+	clk_cpu_pll: clk_cpu_pll@2010022000 {
+		compatible = "lsi,axxia-pll-clock";
+		#clock-cells = <0>;
+		clocks = <&clk_ref0>;
+		clock-output-names = "clk_cpu_pll";
+		reg = <0x20 0x10022000 0 0x2c>;
+	};
+
+
+* Axxia clock divider
+
+Required properties:
+- #clock-cells : shall be set to 0.
+- compatible : shall be "lsi,axxia-div-clock"
+- clocks : parent clock phandle
+- reg - clock divider control register
+- lsi,bit-shift : bit position of the divider control field.
+- lsi,bit-mask : width of the divider control field.
+
+Optional properties:
+- clock-output-names : From common clock binding.
+
+Example:
+
+	clk_cpu_div: cpu {
+		compatible = "lsi,axxia-div-clock";
+		#clock-cells = <0>;
+		clocks = <&clk_cpu_pll>;
+		clock-output-names = "clk_cpu_div";
+		reg = <0x20 0x10030008 0 0x4>;
+		lsi,bit-shift = <0>;
+		lsi,bit-width = <4>;
+	};
+
+
+* Axxia clock mux
+
+Required properties:
+- #clock-cells : shall be set to 0.
+- compatible : shall be "lsi,axxia-mux-clock"
+- clocks : phandle of parent clocks (max 4)
+- reg - clock divider control register
+- lsi,bit-shift : bit position of the divider control field.
+- lsi,bit-mask : width of the divider control field.
+
+Optional properties:
+- clock-output-names : From common clock binding.
+
+Example:
+
+	clk_cpu: clk_cpu0@2010030000 {
+		compatible = "lsi,axxia-mux-clock";
+		#clock-cells = <0>;
+		clocks = <&clk_ref0>,
+			 <&clk_cpu_pll>,
+			 <&clk_cpu_div>,
+			 <&clk_cpu_div>;
+		clock-output-names = "clk_cpu";
+		reg = <0x20 0x10030000 0 0x4>;
+		lsi,bit-shift = <0>;
+		lsi,bit-width = <2>;
+	};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 88af4a3..a9d0626 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
 # hardware specific clock types
 # please keep this section sorted lexicographically by file/directory path name
 obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN)	+= clk-axi-clkgen.o
+obj-$(CONFIG_ARCH_AXXIA)		+= clk-axxia.o
 obj-$(CONFIG_ARCH_BCM2835)		+= clk-bcm2835.o
 obj-$(CONFIG_ARCH_EFM32)		+= clk-efm32gg.o
 obj-$(CONFIG_ARCH_HIGHBANK)		+= clk-highbank.o
diff --git a/drivers/clk/clk-axxia.c b/drivers/clk/clk-axxia.c
new file mode 100644
index 0000000..996b8f2
--- /dev/null
+++ b/drivers/clk/clk-axxia.c
@@ -0,0 +1,281 @@
+/*
+ * arch/arm/mach-axxia/clock.c
+ *
+ * Provides clock implementations for three different types of clock devices on
+ * the Axxia device: PLL clock, a clock divider and a clock mux.
+ *
+ * Copyright (C) 2012 LSI
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/clk-provider.h>
+
+
+static void __iomem *
+parse_and_map_reg(struct device_node *node, u32 *shift, u32 *width)
+{
+	void __iomem *reg;
+
+	if (of_property_read_u32(node, "lsi,bit-shift", shift)) {
+		pr_err("%s: no 'lsi,bit-shift' property\n", node->name);
+		return NULL;
+	}
+
+	if (of_property_read_u32(node, "lsi,bit-width", width)) {
+		pr_err("%s: no 'lsi,bit-width' property\n", node->name);
+		return NULL;
+	}
+
+	reg = of_iomap(node, 0);
+	if (!reg)
+		pr_err("%s: failed to map register\n", node->name);
+
+	return reg;
+}
+
+/**
+ * struct axxia_pllclk - Axxia PLL generated clock.
+ * @hw: clk_hw for the PLL
+ * @regs: Pointer to control registers
+ */
+struct axxia_pllclk {
+	struct clk_hw hw;
+	void __iomem *regs;
+};
+
+#define to_axxia_pll(_hw) container_of(_hw, struct axxia_pllclk, hw)
+
+static unsigned long
+axxia_pllclk_recalc(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct axxia_pllclk *pll = to_axxia_pll(hw);
+	unsigned long rate, fbdiv, refdiv, postdiv;
+	u32 control;
+
+	control = readl(pll->regs);
+	postdiv = ((control >> 0) & 0xf) + 1;
+	fbdiv   = ((control >> 4) & 0xfff) + 3;
+	refdiv  = ((control >> 16) & 0x1f) + 1;
+	rate = (parent_rate / (refdiv * postdiv)) * fbdiv;
+
+	return rate;
+}
+
+static const struct clk_ops clk_pll_ops = {
+	.recalc_rate = axxia_pllclk_recalc,
+};
+
+static struct clk *
+register_axxia_pllclk(struct device *dev, const char *name,
+		      const char *parent_name, void __iomem *regs)
+{
+	struct clk_init_data init;
+	struct axxia_pllclk *pll;
+	struct clk *clk;
+
+	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
+	if (!pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_pll_ops;
+	init.flags = 0;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	pll->regs = regs;
+	pll->hw.init = &init;
+
+	clk = clk_register(NULL, &pll->hw);
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
+
+
+/**
+ * struct axxia_divclk - Axxia clock divider
+ * @hw: clk_hw for the divider
+ * @regs: Pointer to control registers
+ */
+struct axxia_divclk {
+	struct clk_hw hw;
+	void __iomem *regs;
+	int shift;
+	int width;
+};
+
+#define to_axxia_divclk(_hw) container_of(_hw, struct axxia_divclk, hw)
+
+static unsigned long
+axxia_divclk_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct axxia_divclk *divclk = to_axxia_divclk(hw);
+	u32 ctrl, div;
+
+	ctrl = readl(divclk->regs);
+	div = 1 + ((ctrl >> divclk->shift) & GENMASK(divclk->width-1, 0));
+
+	return parent_rate / div;
+}
+
+const struct clk_ops axxia_divclk_ops = {
+	.recalc_rate = axxia_divclk_recalc_rate,
+};
+
+static struct clk *
+register_axxia_divclk(struct device *dev, const char *name,
+		      const char *parent_name, void __iomem *regs,
+		      int shift, int width)
+{
+	struct axxia_divclk *div;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	div = kzalloc(sizeof(struct axxia_divclk), GFP_KERNEL);
+	if (!div)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &axxia_divclk_ops;
+	init.flags = CLK_IS_BASIC;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	div->regs = regs;
+	div->shift = shift;
+	div->width = width;
+	div->hw.init = &init;
+
+	/* register the clock */
+	clk = clk_register(dev, &div->hw);
+	if (IS_ERR(clk))
+		kfree(div);
+
+	return clk;
+}
+
+/**
+ * axxia_pll_clk_init - Axxia PLL clock setup function
+ * @node: pointer to device tree node
+ */
+static void __init
+axxia_pll_clk_init(struct device_node *node)
+{
+	struct clk *clk;
+	const char *parent_name;
+	void __iomem *regs;
+	const char *clk_name = node->name;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	parent_name = of_clk_get_parent_name(node, 0);
+	if (!parent_name) {
+		pr_err("%s: no parent clock\n", node->name);
+		return;
+	}
+
+	regs = of_iomap(node, 0);
+	if (!regs) {
+		pr_err("%s: failed to map register\n", node->name);
+		return;
+	}
+
+	clk = register_axxia_pllclk(NULL, clk_name, parent_name, regs);
+	if (IS_ERR(clk)) {
+		pr_err("%s: register failed (%ld)\n", clk_name, PTR_ERR(clk));
+		iounmap(regs);
+		return;
+	}
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(axxia_pll_clk, "lsi,axxia-pll-clock", axxia_pll_clk_init);
+
+
+/**
+ * axxia_div_clk_init - Axxia clock divider setup function
+ * @node: device tree node for this clock
+ */
+static void __init
+axxia_div_clk_init(struct device_node *node)
+{
+	const char *parent_name;
+	void __iomem *reg;
+	u32 shift, width;
+	struct clk *clk;
+	const char *clk_name = node->name;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	parent_name = of_clk_get_parent_name(node, 0);
+	if (!parent_name) {
+		pr_err("%s: no parent clock\n", node->name);
+		return;
+	}
+
+	reg = parse_and_map_reg(node, &shift, &width);
+	if (!reg)
+		return;
+
+	clk = register_axxia_divclk(NULL, clk_name, parent_name, reg,
+				    shift, width);
+	if (IS_ERR(clk)) {
+		pr_err("%s: register failed (%ld)\n", clk_name, PTR_ERR(clk));
+		iounmap(reg);
+		return;
+	}
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(axxia_div_clk, "lsi,axxia-div-clock", axxia_div_clk_init);
+
+
+/**
+ * axxia_mux_clk_init - Clock mux setup function
+ * @node: device tree node for this clock
+ */
+static void __init
+axxia_mux_clk_init(struct device_node *node)
+{
+	void __iomem *reg;
+	struct clk *clk;
+	const char *parents[4];
+	int num_parents;
+	const char *clk_name = node->name;
+	u32 shift, width;
+	int i;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	for (i = 0; i < ARRAY_SIZE(parents); ++i) {
+		parents[i] = of_clk_get_parent_name(node, i);
+		if (!parents[i])
+			break;
+	}
+	num_parents = i;
+
+	reg = parse_and_map_reg(node, &shift, &width);
+	if (!reg)
+		return;
+
+	clk = clk_register_mux(NULL, clk_name, parents,
+			       num_parents, 0, reg, shift, width,
+			       CLK_MUX_READ_ONLY, NULL);
+	if (IS_ERR(clk)) {
+		pr_err("%s: register failed (%ld)\n", clk_name, PTR_ERR(clk));
+		iounmap(reg);
+		return;
+	}
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(pll_mux_clock, "lsi,axxia-mux-clock", axxia_mux_clk_init);
-- 
1.8.3.2

