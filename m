Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab3FCRxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:53:52 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:42302 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3FCRxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:53:45 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 2/3] clk: dt: binding for basic multiplexor clock
Date: Mon,  3 Jun 2013 10:53:09 -0700
Message-Id: <1370281990-15090-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device Tree binding for the basic clock multiplexor, plus the setup
function to register the clock.  Based on the existing fixed-clock
binding.

Also relocate declaration of of_fixed_factor_clk_setup to keep things
tidy.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 .../devicetree/bindings/clock/mux-clock.txt        | 75 ++++++++++++++++++++++
 drivers/clk/clk-mux.c                              | 65 ++++++++++++++++++-
 include/linux/clk-provider.h                       |  5 +-
 3 files changed, 143 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/mux-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/mux-clock.txt b/Documentation/devicetree/bindings/clock/mux-clock.txt
new file mode 100644
index 0000000..eda5ba3
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mux-clock.txt
@@ -0,0 +1,75 @@
+Binding for simple mux clock.
+
+This binding uses the common clock binding[1].  It assumes a
+register-mapped multiplexor with multiple input clock signals or
+parents, one of which can be selected as output.  This clock does not
+gate or adjust the parent rate via a divider or multiplier.
+
+By default the "clocks" property lists the parents in the same order
+as they are programmed into the regster.  E.g:
+
+	clocks = <&foo_clock>, <&bar_clock>, <&baz_clock>;
+
+results in programming the register as follows:
+
+register value		selected parent clock
+0			foo_clock
+1			bar_clock
+2			baz_clock
+
+Some clock controller IPs do not allow a value of zero to be programmed
+into the register, instead indexing begins at 1.  The optional property
+"index_one" modified the scheme as follows:
+
+register value		selected clock parent
+1			foo_clock
+2			bar_clock
+3			baz_clock
+
+Additionally an optional table of bit and parent pairs may be supplied
+like so:
+
+	table = <&foo_clock 0x0>, <&bar_clock, 0x2>, <&baz_clock, 0x4>;
+
+where the first value in the pair is the parent clock and the second
+value is the bitfield to be programmed into the register.
+
+The binding must provide the register to control the mux and the mask
+for the corresponding control bits.  Optionally the number of bits to
+shift that mask if necessary.  If the shift value is missing it is the
+same as supplying a zero shift.
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be "mux-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : link phandles of parent clocks
+- reg : base address for register controlling adjustable mux
+- mask : arbitrary bitmask for programming the adjustable mux
+
+Optional properties:
+- clock-output-names : From common clock binding.
+- table : array of integer pairs defining parents & bitfield values
+- shift : number of bits to shift the mask, defaults to 0 if not present
+- index_one : valid input select programming starts at 1, not zero
+
+Examples:
+	clock: clock@4a008100 {
+		compatible = "mux-clock";
+		#clock-cells = <0>;
+		clocks = <&clock_foo>, <&clock_bar>, <&clock_baz>;
+		reg = <0x4a008100 0x4>
+		mask = <0x3>;
+		index_one;
+	};
+
+	clock: clock@4a008100 {
+		#clock-cells = <0>;
+		compatible = "mux-clock";
+		clocks = <&clock_foo>, <&clock_bar>, <&clock_baz>;
+		reg = <0x4a008100 0x4>;
+		mask = <0x3>;
+		shift = <0>;
+		table = <&clock_foo 1>, <&clock_bar 2>, <&clock_baz 3>;
+	};
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 25b1734..8bcbc7c 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
  * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
- * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
+ * Copyright (C) 2011-2013 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -16,6 +16,8 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 
 /*
  * DOC: basic adjustable multiplexer clock that cannot gate
@@ -153,3 +155,64 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 				      flags, reg, shift, mask, clk_mux_flags,
 				      NULL, lock);
 }
+
+#ifdef CONFIG_OF
+/**
+ * of_mux_clk_setup() - Setup function for simple mux rate clock
+ */
+void of_mux_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	int num_parents;
+	const char **parent_names;
+	int i;
+	u8 clk_mux_flags = 0;
+	u32 mask = 0;
+	u32 shift = 0;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+	pr_err("%s: clk_name is %s\n", __func__, clk_name);
+
+	num_parents = of_clk_get_parent_count(node);
+	if (num_parents < 1) {
+		pr_err("%s: mux-clock %s must have parent(s)\n",
+				__func__, node->name);
+		return;
+	}
+	pr_err("%s: num_parents is %d\n", __func__, num_parents);
+
+	parent_names = kzalloc((sizeof(char*) * num_parents),
+			GFP_KERNEL);
+
+	for (i = 0; i < num_parents; i++) {
+		parent_names[i] = of_clk_get_parent_name(node, i);
+		pr_err("%s: parent_names[%d] is %s\n", __func__, i, parent_names[i]);
+	}
+
+	reg = of_iomap(node, 0);
+	pr_err("%s: reg is 0x%p\n", __func__, reg);
+
+	if (of_property_read_u32(node, "mask", &mask)) {
+		pr_err("%s: missing mask property for %s\n", __func__, node->name);
+		return;
+	}
+
+	if (of_property_read_u32(node, "shift", &shift))
+		pr_debug("%s: missing shift property defaults to zero for %s\n",
+				__func__, node->name);
+
+	if (of_property_read_bool(node, "index_one"))
+		clk_mux_flags |= CLK_MUX_INDEX_ONE;
+
+	clk = clk_register_mux_table(NULL, clk_name, parent_names, num_parents,
+			0, reg, 0, mask, clk_mux_flags,
+			NULL, NULL);
+
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+EXPORT_SYMBOL_GPL(of_mux_clk_setup);
+CLK_OF_DECLARE(mux_clk, "mux-clock", of_mux_clk_setup);
+#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index f8d38f2..9c404c2 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -325,7 +325,7 @@ struct clk *clk_register_mux_table(struct device *dev, const char *name,
 		void __iomem *reg, u8 shift, u32 mask,
 		u8 clk_mux_flags, u32 *table, spinlock_t *lock);
 
-void of_fixed_factor_clk_setup(struct device_node *node);
+void of_mux_clk_setup(struct device_node *node);
 
 /**
  * struct clk_fixed_factor - fixed multiplier and divider clock
@@ -346,10 +346,13 @@ struct clk_fixed_factor {
 };
 
 extern struct clk_ops clk_fixed_factor_ops;
+
 struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned int mult, unsigned int div);
 
+void of_fixed_factor_clk_setup(struct device_node *node);
+
 /***
  * struct clk_composite - aggregate clock of mux, divider and gate clocks
  *
-- 
1.8.1.2

