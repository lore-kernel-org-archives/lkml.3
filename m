Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3HVFx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:53:56 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59177 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3HVFxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:53:30 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Matt Sealey <neko@bakuhatsu.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 4/5] clk: dt: binding for basic divider clock
Date: Wed, 21 Aug 2013 22:53:12 -0700
Message-Id: <1377150793-27864-5-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devicetree binding for the basic clock divider, plus the setup function
to register the clock.  Based on the existing fixed-clock binding.

Tero Kristo contributed helpful bug fixes to this patch.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
---
Changes since v3:
* replaced underscores with dashes in DT property names
* bail from of clock setup function early if of_iomap fails
* removed unecessary explict cast

 .../devicetree/bindings/clock/divider-clock.txt    | 90 ++++++++++++++++++++
 drivers/clk/clk-divider.c                          | 97 +++++++++++++++++++++-
 include/linux/clk-provider.h                       |  2 +
 3 files changed, 188 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/divider-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/divider-clock.txt b/Documentation/devicetree/bindings/clock/divider-clock.txt
new file mode 100644
index 0000000..ac80724
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/divider-clock.txt
@@ -0,0 +1,90 @@
+Binding for simple divider clock.
+
+This binding uses the common clock binding[1].  It assumes a
+register-mapped adjustable clock rate divider that does not gate and has
+only one input clock or parent.  By default the value programmed into
+the register is one less than the actual divisor value.  E.g:
+
+register value		actual divisor value
+0			1
+1			2
+2			3
+
+This assumption may be modified by the following optional properties:
+
+index-starts-at-one - valid divisor values start at 1, not the default
+of 0.  E.g:
+register value		actual divisor value
+1			1
+2			2
+3			3
+
+index-power-of-two - valid divisor values are powers of two.  E.g:
+register value		actual divisor value
+0			1
+1			2
+2			4
+
+index-allow-zero - same as index_one, but zero is divide-by-1.  E.g:
+register value		actual divisor value
+0			1
+1			1
+2			2
+
+Additionally a table of valid dividers may be supplied like so:
+
+	table = <4 0>, <8, 1>;
+
+where the first value in the pair is the divider and the second value is
+the programmed register bitfield.
+
+The binding must also provide the register to control the divider and
+the mask for the corresponding control bits.  Optionally the number of
+bits to shift that mask, if necessary.  If the shift value is missing it
+is the same as supplying a zero shift.
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be "divider-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : link to phandle of parent clock
+- reg : base address for register controlling adjustable divider
+- bit-mask : arbitrary bitmask for programming the adjustable divider
+
+Optional properties:
+- clock-output-names : from common clock binding.
+- table : array of integer pairs defining divisors & bitfield values
+- bit-shift : number of bits to shift the bit-mask, defaults to
+  (ffs(mask) - 1) if not present
+- minimum-divider : min divisor for dividing the input clock rate, only
+  needed if the first divisor is offset from the default value
+- maximum-divider : max divisor for dividing the input clock rate, only
+  needed if the max divisor is less than (mask + 1).
+- index-starts-at-one : valid divisor programming starts at 1, not zero
+- index-power-of-two : valid divisor programming must be a power of two
+- index-allow-zero : implies index-one, and programming zero results in
+  divide-by-one
+- hiword-mask : lower half of the register programs the divider, upper
+  half of the register indicates bits that were updated in the lower
+  half
+
+Examples:
+	clock_foo: clock_foo@4a008100 {
+		compatible = "divider-clock";
+		#clock-cells = <0>;
+		clocks = <&clock_baz>;
+		reg = <0x4a008100 0x4>
+		mask = <0x3>
+		maximum-divider = <3>
+	};
+
+	clock_bar: clock_bar@4a008108 {
+		#clock-cells = <0>;
+		compatible = "divider-clock";
+		clocks = <&clock_foo>;
+		reg = <0x4a008108 0x4>;
+		mask = <0x1>;
+		shift = <0>;
+		table = < 4 0 >, < 8 1 >;
+	};
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 2791a2b..f95abc8 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
  * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
- * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ * Copyright (C) 2011-2013 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -17,6 +17,8 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/log2.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 
 /*
  * DOC: basic adjustable divider clock that cannot gate
@@ -342,3 +344,96 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 			((1 << width) - 1), clk_divider_flags, table, lock);
 }
 EXPORT_SYMBOL_GPL(clk_register_divider_table);
+
+#ifdef CONFIG_OF
+struct clk_div_table *of_clk_get_div_table(struct device_node *node)
+{
+	int i;
+	u32 table_size;
+	struct clk_div_table *table;
+	const __be32 *tablespec;
+	u32 val;
+
+	tablespec = of_get_property(node, "table", &table_size);
+
+	if (!tablespec)
+		return NULL;
+
+	table_size /= sizeof(struct clk_div_table);
+
+	table = kzalloc(sizeof(struct clk_div_table) * table_size, GFP_KERNEL);
+	if (!table) {
+		pr_err("%s: unable to allocate memory for %s table\n", __func__, node->name);
+		return NULL;
+	}
+
+	for (i = 0; i < table_size; i++) {
+		of_property_read_u32_index(node, "table", i * 2, &val);
+		table[i].div = val;
+		of_property_read_u32_index(node, "table", i * 2 + 1, &val);
+		table[i].val = val;
+	}
+
+	return table;
+}
+
+/**
+ * of_divider_clk_setup() - Setup function for simple div rate clock
+ */
+void of_divider_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	const char *parent_name;
+	u8 clk_divider_flags = 0;
+	u32 mask = 0;
+	u32 shift = 0;
+	struct clk_div_table *table;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	parent_name = of_clk_get_parent_name(node, 0);
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("%s: no memory mapped for property reg\n", __func__);
+		return;
+	}
+
+	if (of_property_read_u32(node, "bit-mask", &mask)) {
+		pr_err("%s: missing bit-mask property for %s\n", __func__, node->name);
+		return;
+	}
+
+	if (of_property_read_u32(node, "bit-shift", &shift)) {
+		shift = __ffs(mask);
+		pr_debug("%s: bit-shift property defaults to 0x%x for %s\n",
+				__func__, shift, node->name);
+	}
+
+	if (of_property_read_bool(node, "index-starts-at-one"))
+		clk_divider_flags |= CLK_DIVIDER_ONE_BASED;
+
+	if (of_property_read_bool(node, "index-power-of-two"))
+		clk_divider_flags |= CLK_DIVIDER_POWER_OF_TWO;
+
+	if (of_property_read_bool(node, "index-allow-zero"))
+		clk_divider_flags |= CLK_DIVIDER_ALLOW_ZERO;
+
+	if (of_property_read_bool(node, "hiword-mask"))
+		clk_divider_flags |= CLK_DIVIDER_HIWORD_MASK;
+
+	table = of_clk_get_div_table(node);
+	if (IS_ERR(table))
+		return;
+
+	clk = _register_divider(NULL, clk_name, parent_name, 0, reg, shift,
+			mask, clk_divider_flags, table, NULL);
+
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+EXPORT_SYMBOL_GPL(of_divider_clk_setup);
+CLK_OF_DECLARE(divider_clk, "divider-clock", of_divider_clk_setup);
+#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index e019212..218d923 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -301,6 +301,8 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock);
 
+void of_divider_clk_setup(struct device_node *node);
+
 /**
  * struct clk_mux - multiplexer clock
  *
-- 
1.8.1.2

