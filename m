Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3EJMpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:45:49 -0400
Received: from multi.imgtec.com ([194.200.65.239]:48789 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab3EJMps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:45:48 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] clk: add specified-rate clock
Date: Fri, 10 May 2013 13:44:22 +0100
Message-ID: <1368189862-17119-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_10_13_45_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The frequency of some SoC's external oscillators (for example TZ1090's
XTAL1) are configured by the board using pull-ups/pull-downs of
configuration pins, the logic values of which are automatically latched
on reset and available in an SoC register. Add a generic clock component
and DT bindings to handle this.

It behaves similar to a fixed rate clock (read-only), except it needs
information about a register field (reg, shift, width), and the
clock-frequency is a mapping from register field values to clock
frequencies.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
 .../devicetree/bindings/clock/specified-clock.txt  |  39 ++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-specified-rate.c                   | 201 +++++++++++++++++++++
 include/linux/clk-provider.h                       |  37 ++++
 4 files changed, 278 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/specified-clock.txt
 create mode 100644 drivers/clk/clk-specified-rate.c

diff --git a/Documentation/devicetree/bindings/clock/specified-clock.txt b/Documentation/devicetree/bindings/clock/specified-clock.txt
new file mode 100644
index 0000000..b36ccf9
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/specified-clock.txt
@@ -0,0 +1,39 @@
+Binding for fixed-rate clock sources with readable configuration.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : Shall be "specified-clock".
+- #clock-cells       : From common clock binding; shall be set to 0.
+- reg                : Address of configuration register.
+- shift              : Shift of config value field in configuration register.
+- width              : Width of config value field in configuration register.
+- clock-frequency    : Frequency mapping of clock. Consecutive pairs of cells
+                       represent the config value to match and the clock
+                       frequency in Hz for that config value.
+
+Optional properties:
+- clock-output-names : From common clock binding.
+
+Example:
+	clock {
+		compatible = "specified-clock";
+		#clock-cells = <0>;
+		reg = <0x02004004 0x4>;	/* CR_PERIP_RESET_CFG */
+		shift = <8>;		/* FXTAL */
+		width = <4>;
+		clock-frequency =
+		/*	 FXTAL	Frequency */
+			<0	16384000>,
+			<1	19200000>,
+			<2	24000000>,
+			<3	24576000>,
+			<4	26000000>,
+			<5	36000000>,
+			<6	36864000>,
+			<7	38400000>,
+			<8	40000000>;
+		clock-output-names = "xtal1";
+	};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index e7f7fe9..1343179 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-rate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-specified-rate.o
 
 # SoCs specific
 obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
diff --git a/drivers/clk/clk-specified-rate.c b/drivers/clk/clk-specified-rate.c
new file mode 100644
index 0000000..8f78033
--- /dev/null
+++ b/drivers/clk/clk-specified-rate.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
+ * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ * Copyright (C) 2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Fixed rate clock implementation with rate specified in a register field.
+ * Based on fixed rate clock implementation.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+/*
+ * DOC: basic specified-rate clock that cannot gate
+ *
+ * Traits of this clock:
+ * prepare - clk_(un)prepare only ensures parents are prepared
+ * enable - clk_enable only ensures parents are enabled
+ * rate - rate is always a fixed value.  No clk_set_rate support
+ * parent - fixed parent.  No clk_set_parent support
+ */
+
+#define to_clk_specified_rate(_hw) \
+	container_of(_hw, struct clk_specified_rate, hw)
+
+static unsigned long clk_specified_rate_recalc_rate(struct clk_hw *hw,
+		unsigned long parent_rate)
+{
+	struct clk_specified_rate *specified = to_clk_specified_rate(hw);
+	struct clk_specified_rate_entry *entry;
+	u32 val;
+	unsigned int i;
+
+	/* read configuration field */
+	val = readl(specified->reg);
+	val >>= specified->shift;
+	val &= (1 << specified->width) - 1;
+
+	/* match the value in the mapping */
+	for (i = 0; i < specified->num_rates; ++i) {
+		entry = &specified->rates[i];
+		if (val == entry->value)
+			return entry->rate;
+	}
+
+	/* unknown rate! */
+	return 0;
+}
+
+const struct clk_ops clk_specified_rate_ops = {
+	.recalc_rate = clk_specified_rate_recalc_rate,
+};
+EXPORT_SYMBOL_GPL(clk_specified_rate_ops);
+
+/**
+ * clk_register_specified_rate - register specified-rate clock
+ * @dev:		device that is registering this clock
+ * @name:		name of this clock
+ * @parent_name:	name of clock's parent
+ * @flags:		framework-specific flags
+ * @reg:		config register
+ * @shift:		shift into config register of frequency field
+ * @width:		width of frequency field in config register
+ * @rates:		value->rate mapping entries
+ * @num_rates:		number of rates in @rates
+ */
+struct clk *clk_register_specified_rate(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 shift, u8 width,
+		struct clk_specified_rate_entry *rates,
+		unsigned long num_rates)
+{
+	struct clk_specified_rate *specified;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate specified-rate clock */
+	specified = kzalloc(sizeof(struct clk_specified_rate), GFP_KERNEL);
+	if (!specified) {
+		pr_err("%s(%s): could not allocate specified clk\n",
+		       __func__, name);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	init.name = name;
+	init.ops = &clk_specified_rate_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_specified_rate assignments */
+	specified->reg = reg;
+	specified->shift = shift;
+	specified->width = width;
+	specified->rates = rates;
+	specified->num_rates = num_rates;
+	specified->hw.init = &init;
+
+	/* register the clock */
+	clk = clk_register(dev, &specified->hw);
+
+	if (IS_ERR(clk))
+		kfree(specified);
+
+	return clk;
+}
+
+#ifdef CONFIG_OF
+/**
+ * of_specified_clk_setup() - Setup function for specified fixed rate clock
+ */
+void __init of_specified_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	u32 shift, width, rate;
+	void __iomem *reg;
+	int len, num_rates, i;
+	struct property *prop;
+	struct clk_specified_rate_entry *rates;
+	const __be32 *p;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	if (of_property_read_u32(node, "shift", &shift)) {
+		pr_err("%s(%s): could not read shift property\n",
+		       __func__, clk_name);
+		return;
+	}
+
+	if (of_property_read_u32(node, "width", &width)) {
+		pr_err("%s(%s): could not read width property\n",
+		       __func__, clk_name);
+		return;
+	}
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("%s(%s): of_iomap failed\n",
+		       __func__, clk_name);
+		return;
+	}
+
+	/* check clock-frequency exists */
+	prop = of_find_property(node, "clock-frequency", &len);
+	if (!prop) {
+		pr_err("%s(%s): could not find clock-frequency property\n",
+		       __func__, clk_name);
+		goto err_iounmap;
+	}
+
+	if (len & (sizeof(u32)*2 - 1)) {
+		pr_err("%s(%s): clock-frequency has invalid size of %d bytes\n",
+		       __func__, clk_name, len);
+		goto err_iounmap;
+	}
+	num_rates = len / (sizeof(*rates)*2);
+
+	rates = kzalloc(sizeof(*rates)*num_rates, GFP_KERNEL);
+	if (!rates) {
+		pr_err("%s(%s): could not allocate %d rate mapping entries\n",
+		       __func__, clk_name, num_rates);
+		goto err_iounmap;
+	}
+
+	/* extract rate mapping */
+	for (i = 0, p = of_prop_next_u32(prop, NULL, &rates[0].value);
+	     p;
+	     ++i, p = of_prop_next_u32(prop, p, &rates[i].value)) {
+		p = of_prop_next_u32(prop, p, &rate);
+		rates[i].rate = rate;
+		pr_debug("%s(%s): map %u -> %lu Hz\n",
+			 __func__, clk_name, rates[i].value, rates[i].rate);
+	}
+
+	clk = clk_register_specified_rate(NULL, clk_name, NULL, CLK_IS_ROOT,
+					  reg, shift, width, rates, num_rates);
+	if (IS_ERR(clk))
+		goto err_kfree;
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+
+	return;
+
+err_kfree:
+	kfree(rates);
+err_iounmap:
+	iounmap(reg);
+}
+EXPORT_SYMBOL_GPL(of_specified_clk_setup);
+CLK_OF_DECLARE(specified_clk, "specified-clock", of_specified_clk_setup);
+#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 1186098..218a406 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -196,6 +196,43 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 void of_fixed_clk_setup(struct device_node *np);
 
 /**
+ * struct clk_specified_rate_entry - a single possible specified rate
+ * @value:	value to match in config register
+ * @rate:	rate to use when config register matches @value
+ */
+struct clk_specified_rate_entry {
+	u32		value;
+	unsigned long	rate;
+};
+
+/**
+ * struct clk_specified_rate - specified-rate clock
+ * @hw:		handle between common and hardware-specific interfaces
+ * @reg:	register containing rate specifier field
+ * @shift:	shift to rate specifier field
+ * @width:	width of rate specifier field
+ * @rates:	mapping of specified frequencies
+ * @num_rates:	number of rates in array
+ */
+struct clk_specified_rate {
+	struct		clk_hw hw;
+	void __iomem	*reg;
+	u8		shift;
+	u8		width;
+	struct clk_specified_rate_entry	*rates;
+	unsigned int	num_rates;
+};
+
+extern const struct clk_ops clk_specified_rate_ops;
+struct clk *clk_register_specified_rate(struct device *dev, const char *name,
+		const char *parent_names, unsigned long flags,
+		void __iomem *reg, u8 shift, u8 width,
+		struct clk_specified_rate_entry *rates,
+		unsigned long num_rates);
+
+void of_specified_clk_setup(struct device_node *np);
+
+/**
  * struct clk_gate - gating clock
  *
  * @hw:		handle between common and hardware-specific interfaces
-- 
1.8.1.2


