Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab3FCRyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:54:07 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44879 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab3FCRxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:53:47 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 3/3] clk: dt: binding for basic divider clock
Date: Mon,  3 Jun 2013 10:53:10 -0700
Message-Id: <1370281990-15090-4-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devicetree binding for the basic clock divider, plus the setup function
to register the clock.  Based on the existing fixed-clock binding.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 .../devicetree/bindings/clock/divider-clock.txt    | 80 ++++++++++++++++++++
 drivers/clk/clk-divider.c                          | 88 +++++++++++++++++++++-
 include/linux/clk-provider.h                       |  2 +
 3 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/divider-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/divider-clock.txt b/Documentation/devicetree/bindings/clock/divider-clock.txt
new file mode 100644
index 0000000..31e9273
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/divider-clock.txt
@@ -0,0 +1,80 @@
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
+index_one - valid divisor values start at 1, not the default of 0.  E.g:
+register value		actual divisor value
+1			1
+2			2
+3			3
+
+index_power_of_two - valid divisor values are powers of two.  E.g:
+register value		actual divisor value
+0			1
+1			2
+2			4
+
+allow_zero - same as index_one, but zero is divide-by-1.  E.g:
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
+- mask : arbitrary bitmask for programming the adjustable divider
+
+Optional properties:
+- clock-output-names : From common clock binding.
+- table : array of integer pairs defining divisors & bitfield values
+- shift : number of bits to shift the mask, defaults to 0 if not present
+- index_one : valid divisor programming starts at 1, not zero
+- index_power_of_two : valid divisor programming must be a power of two
+- allow_zero : implies index_one, and programming zero results in
+  divide-by-one
+
+Examples:
+	clock_foo: clock_foo@4a008100 {
+		compatible = "divider-clock";
+		#clock-cells = <0>;
+		clocks = <&clock_baz>;
+		reg = <0x4a008100 0x4>
+		mask = <0x3>
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
index 6d96741..3b76591 100644
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
@@ -320,3 +322,87 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 	return _register_divider(dev, name, parent_name, flags, reg, shift,
 			width, clk_divider_flags, table, lock);
 }
+
+#ifdef CONFIG_OF
+struct clk_div_table *of_clk_get_div_table(struct device_node *node)
+{
+	int i;
+	int table_size = 0;
+	struct clk_div_table *table;
+	u32 pair[2];
+
+	table_size = of_count_phandle_with_args(node, "table", "#clock-cells");
+
+	if (table_size < 1)
+		return NULL;
+
+	table = kzalloc(sizeof(struct clk_div_table) * table_size, GFP_KERNEL);
+	if (!table) {
+		pr_err("%s: unable to allocate memory for %s table\n", __func__, node->name);
+		return NULL;
+	}
+
+	for (i = 0; i < table_size; i++) {
+		if (!of_property_read_u32_array(node, "table", pair, ARRAY_SIZE(pair))) {
+			table[i].val = pair[0];
+			table[i].div = pair[1];
+		}
+	}
+
+	return table;
+}
+
+/**
+ * of_div_clk_setup() - Setup function for simple div rate clock
+ */
+void of_divider_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	const char *parent_name;
+	u8 clk_divider_flags = 0;
+	u8 mask = 0;
+	u8 shift = 0;
+	struct clk_div_table *table;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	parent_name = of_clk_get_parent_name(node, 0);
+
+	reg = of_iomap(node, 0);
+
+	if (of_property_read_u8(node, "mask", &mask)) {
+		pr_err("%s: missing mask property for %s\n", __func__, node->name);
+		return;
+	}
+
+	if (of_property_read_u8(node, "shift", &shift))
+		pr_debug("%s: missing shift property defaults to zero for %s\n",
+				__func__, node->name);
+
+	if (of_property_read_bool(node, "index_one"))
+		clk_divider_flags |= CLK_DIVIDER_ONE_BASED;
+
+	if (of_property_read_bool(node, "index_power_of_two"))
+		clk_divider_flags |= CLK_DIVIDER_POWER_OF_TWO;
+
+	if (of_property_read_bool(node, "index_allow_zero"))
+		clk_divider_flags |= CLK_DIVIDER_ALLOW_ZERO;
+
+	table = of_clk_get_div_table(node);
+	if (IS_ERR(table))
+		return;
+
+	clk = clk_register_divider_table(NULL, clk_name,
+			parent_name, 0,
+			reg, shift, mask,
+			clk_divider_flags, table,
+			NULL);
+
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+EXPORT_SYMBOL_GPL(of_divider_clk_setup);
+CLK_OF_DECLARE(divider_clk, "divider-clock", of_divider_clk_setup);
+#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 9c404c2..63521e7 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -283,6 +283,8 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock);
 
+void of_divider_clk_setup(struct device_node *node);
+
 /**
  * struct clk_mux - multiplexer clock
  *
-- 
1.8.1.2

