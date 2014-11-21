Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaKUSeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:34:44 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:30030 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaKUSel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:34:41 -0500
From: Alban Bedel <albeu@free.fr>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Alban Bedel <albeu@free.fr>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 4/4] clk: add a generic MMIO clock controller
Date: Fri, 21 Nov 2014 19:34:03 +0100
Message-Id: <1416594843-12352-4-git-send-email-albeu@free.fr>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1416594843-12352-1-git-send-email-albeu@free.fr>
References: <1416594843-12352-1-git-send-email-albeu@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver allow defining simple MMIO clock controllers using only DT
nodes. The clock controller driver map the configured MMIO range and
allow creating simple clock trees using dividers, gates and muxers.

Signed-off-by: Alban Bedel <albeu@free.fr>
---
 drivers/clk/Kconfig               |   9 ++
 drivers/clk/Makefile              |   1 +
 drivers/clk/clk-mmio-controller.c | 208 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 218 insertions(+)
 create mode 100644 drivers/clk/clk-mmio-controller.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 455fd17..ca6b896 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -23,6 +23,15 @@ config COMMON_CLK
 menu "Common Clock Framework"
 	depends on COMMON_CLK
 
+config COMMON_CLK_MMIO_CONTROLLER
+	tristate "Generic driver for simple MMIO clock controller"
+	depends on OF
+	---help---
+	  This driver allow supporting simple MMIO clock controllers that
+	  only consist of dividers, muxes and gates. The clock tree and
+	  register mapping can be fully configured from the devicetree
+	  removing the need for a device specific driver.
+
 config COMMON_CLK_WM831X
 	tristate "Clock driver for WM831x/2x PMICs"
 	depends on MFD_WM831X
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index d5fba5b..0d9c8e4 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_MACH_LOONGSON1)		+= clk-ls1x.o
 obj-$(CONFIG_COMMON_CLK_MAX_GEN)	+= clk-max-gen.o
 obj-$(CONFIG_COMMON_CLK_MAX77686)	+= clk-max77686.o
 obj-$(CONFIG_COMMON_CLK_MAX77802)	+= clk-max77802.o
+obj-$(CONFIG_COMMON_CLK_MMIO_CONTROLLER)+= clk-mmio-controller.o
 obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
diff --git a/drivers/clk/clk-mmio-controller.c b/drivers/clk/clk-mmio-controller.c
new file mode 100644
index 0000000..0e5fb50
--- /dev/null
+++ b/drivers/clk/clk-mmio-controller.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (C) 2014 Alban Bedel
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/of_address.h>
+
+#define of_printk(node, lvl, fmt, ...) \
+	printk(lvl "%s: " fmt, node->full_name, ##__VA_ARGS__)
+
+#define of_err(node, ...) of_printk(node, KERN_ERR, __VA_ARGS__)
+#define of_warn(node, ...) of_printk(node, KERN_WARNING, __VA_ARGS__)
+
+typedef struct clk *(*mmio_clock_probe_t)(
+	struct device_node *np, void __iomem *reg, spinlock_t *lock);
+
+static struct clk *mux_clock_probe(
+	struct device_node *np, void __iomem *reg, spinlock_t *lock)
+{
+	const char *parents[32] = {};
+	unsigned int num_parents = 0;
+	const char *clk_name;
+	u8 clk_mux_flags = 0;
+	u32 width, shift;
+
+	clk_name = np->name;
+	of_property_read_string(np, "clock-output-names", &clk_name);
+
+	/* Read the parents */
+	while (num_parents < ARRAY_SIZE(parents)) {
+		parents[num_parents] = of_clk_get_parent_name(np, num_parents);
+		if (parents[num_parents])
+			num_parents++;
+		else
+			break;
+	}
+
+	if (of_property_read_u32(np, "clock-mux-width", &width) || width > 31 ||
+	    of_property_read_u32(np, "clock-mux-shift", &shift) || shift > 31)
+		return ERR_PTR(-EINVAL);
+
+	if (of_property_read_bool(np, "index-plus-one"))
+		clk_mux_flags |= CLK_MUX_INDEX_ONE;
+	if (of_property_read_bool(np, "index-bitmask"))
+		clk_mux_flags |= CLK_MUX_INDEX_BIT;
+	if (of_property_read_bool(np, "high-word-mask"))
+		clk_mux_flags |= CLK_MUX_HIWORD_MASK;
+	if (of_property_read_bool(np, "read-only"))
+		clk_mux_flags |= CLK_MUX_READ_ONLY;
+
+	return clk_register_mux_table(
+		NULL, clk_name, parents, num_parents, 0, reg,
+		shift, width, clk_mux_flags, NULL, lock);
+}
+
+static struct clk *gate_clock_probe(
+	struct device_node *np, void __iomem *reg, spinlock_t *lock)
+{
+	u8 clk_gate_flags = 0;
+	const char *clk_name;
+	u32 bit = 0;
+
+	clk_name = np->name;
+	of_property_read_string(np, "clock-output-names", &clk_name);
+
+	if (of_property_read_u32(np, "clock-gate-bit", &bit) || bit > 31)
+		return ERR_PTR(-EINVAL);
+
+	if (of_property_read_bool(np, "high-word-mask"))
+		clk_gate_flags |= CLK_GATE_HIWORD_MASK;
+
+	return clk_register_gate(
+		NULL, clk_name, of_clk_get_parent_name(np, 0), 0, reg,
+		bit, clk_gate_flags, lock);
+}
+
+static struct clk *divider_clock_probe(
+	struct device_node *np, void __iomem *reg, spinlock_t *lock)
+{
+	u8 clk_divider_flags = 0;
+	const char *clk_name;
+	u32 div_shift = 0, div_width = 0;
+	u32 mul_shift = 0, mul_width = 0;
+
+	clk_name = np->name;
+	of_property_read_string(np, "clock-output-names", &clk_name);
+
+	of_property_read_u32(np, "clock-div-shift", &div_shift);
+	of_property_read_u32(np, "clock-div-width", &div_width);
+	of_property_read_u32(np, "clock-mult-shift", &mul_shift);
+	of_property_read_u32(np, "clock-mult-width", &mul_width);
+
+	if (div_shift > 31 || div_width > 31 ||
+	    mul_shift > 31 || mul_width > 31)
+		return ERR_PTR(-EINVAL);
+
+	if (mul_width && div_width) {
+		if (of_property_read_bool(np, "read-only"))
+			clk_divider_flags |= CLK_FRACTIONAL_DIVIDER_READ_ONLY;
+		if (of_property_read_bool(np, "divider-plus-one"))
+			clk_divider_flags |=
+				CLK_FRACTIONAL_DIVIDER_DIVISOR_PLUS_ONE;
+
+		return clk_register_fractional_divider(
+			NULL, clk_name, of_clk_get_parent_name(np, 0), 0, reg,
+			mul_shift, mul_width, div_shift, div_width,
+			clk_divider_flags, lock);
+	} else if (div_width) {
+		if (of_property_read_bool(np, "read-only"))
+			clk_divider_flags |= CLK_DIVIDER_READ_ONLY;
+		if (!of_property_read_bool(np, "divider-plus-one"))
+			clk_divider_flags |= CLK_DIVIDER_ONE_BASED;
+		if (of_property_read_bool(np, "divider-power-of-two"))
+			clk_divider_flags |= CLK_DIVIDER_POWER_OF_TWO;
+		if (of_property_read_bool(np, "divider-allow-zero"))
+			clk_divider_flags |= CLK_DIVIDER_ALLOW_ZERO;
+		if (of_property_read_bool(np, "high-word-mask"))
+			clk_divider_flags |= CLK_DIVIDER_HIWORD_MASK;
+		if (of_property_read_bool(np, "divider-roud-closest"))
+			clk_divider_flags |= CLK_DIVIDER_ROUND_CLOSEST;
+
+		return clk_register_divider(
+			NULL, clk_name, of_clk_get_parent_name(np, 0), 0, reg,
+			div_shift, div_width, clk_divider_flags, lock);
+	} else {
+		of_err(np, "Unsupported mode\n");
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+const struct of_device_id clk_mmio_controller_matches[] = {
+	{
+		.compatible = "mux-clock",
+		.data = mux_clock_probe,
+	},
+	{
+		.compatible = "gate-clock",
+		.data = gate_clock_probe,
+	},
+	{
+		.compatible = "divider-clock",
+		.data = divider_clock_probe,
+	},
+	{ }
+};
+
+static void __init mmio_clock_controller_register(struct device_node *np)
+{
+	const struct of_device_id *match;
+	struct device_node *child;
+	mmio_clock_probe_t probe;
+	unsigned int count = 0;
+	void __iomem *base;
+	spinlock_t *lock;
+	struct clk *clk;
+	u32 reg;
+	int err;
+
+	lock = kzalloc(sizeof(*lock), GFP_KERNEL);
+	if (!lock)
+		return;
+	spin_lock_init(lock);
+
+	base = of_iomap(np, 0);
+	if (!base) {
+		of_err(np, "failed to get IO memory\n");
+		kfree(lock);
+		return;
+	}
+
+	for_each_available_child_of_node(np, child) {
+		match = of_match_node(clk_mmio_controller_matches, child);
+		if (!match)
+			continue;
+
+		if (of_property_read_u32(child, "reg", &reg)) {
+			of_warn(child, "the reg property is missing!\n");
+			continue;
+		}
+
+		probe = match->data;
+		clk = probe(child, base + reg, lock);
+		if (IS_ERR(clk)) {
+			of_err(child, "failed to register clock\n");
+			continue;
+		}
+
+		err = of_clk_add_provider(child, of_clk_src_simple_get, clk);
+		if (err) {
+			clk_unregister(clk);
+			of_err(child, "failed to add clock provider\n");
+		}
+		count += 1;
+	}
+
+	if (count == 0) {
+		iounmap(base);
+		kfree(lock);
+	}
+}
+CLK_OF_DECLARE(clk_generic, "mmio-clock-controller",
+		mmio_clock_controller_register);
-- 
2.0.0

