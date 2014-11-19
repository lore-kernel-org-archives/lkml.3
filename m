Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbaKSXQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:16:13 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38550 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbaKSXQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:10 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 06/15] clk: tz1090: add gate bank clock driver
Date: Wed, 19 Nov 2014 23:15:34 +0000
Message-Id: <1416438943-11429-7-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock driver for banks of clock gates in the TZ1090 SoC. A single
32 bit register controls up to 32 separate clock gates. The driver
instantiates separate generic clock gates. The clock operations are
wrapped in order to acquire and release the Meta global exclusive lock
(__global_lock2) to ensure atomicity with other non-Linux cores and
threads which may need to control some of the clocks.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
 drivers/clk/tz1090/Makefile               |   1 +
 drivers/clk/tz1090/clk-tz1090-gate-bank.c | 199 ++++++++++++++++++++++++++++++
 2 files changed, 200 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-gate-bank.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index 14f2d33..ce36250 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -1,2 +1,3 @@
 # Makefile for TZ1090-specific clocks
+obj-y		+= clk-tz1090-gate-bank.o
 obj-y		+= clk-tz1090-pll.o
diff --git a/drivers/clk/tz1090/clk-tz1090-gate-bank.c b/drivers/clk/tz1090/clk-tz1090-gate-bank.c
new file mode 100644
index 0000000..a8c396c
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-gate-bank.c
@@ -0,0 +1,199 @@
+/*
+ * Copyright (C) 2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 Clock gate bank
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+#include <asm/global_lock.h>
+
+/**
+ * struct clk_tz1090_gate - tz1090 gating clock
+ *
+ * @mux:	the parent class
+ * @ops:	pointer to clk_ops of parent class
+ *
+ * Clock which can gate its output. Extends basic mux by using a global
+ * exclusive lock when read-modify-writing the mux field so that multiple
+ * threads/cores can use different fields in the same register.
+ */
+struct clk_tz1090_gate {
+	struct clk_gate		gate;
+	const struct clk_ops	*ops;
+};
+
+static inline struct clk_tz1090_gate *to_clk_tz1090_gate(struct clk_hw *hw)
+{
+	struct clk_gate *gate = container_of(hw, struct clk_gate, hw);
+
+	return container_of(gate, struct clk_tz1090_gate, gate);
+}
+
+/* Acquire exclusive lock since other cores may access the same register */
+static int clk_tz1090_gate_enable(struct clk_hw *hw)
+{
+	struct clk_tz1090_gate *gate = to_clk_tz1090_gate(hw);
+	int ret;
+	unsigned long flags;
+
+	__global_lock2(flags);
+	ret = gate->ops->enable(&gate->gate.hw);
+	__global_unlock2(flags);
+
+	return ret;
+}
+
+/* Acquire exclusive lock since other cores may access the same register */
+static void clk_tz1090_gate_disable(struct clk_hw *hw)
+{
+	struct clk_tz1090_gate *gate = to_clk_tz1090_gate(hw);
+	unsigned long flags;
+
+	__global_lock2(flags);
+	gate->ops->disable(&gate->gate.hw);
+	__global_unlock2(flags);
+}
+
+static int clk_tz1090_gate_is_enabled(struct clk_hw *hw)
+{
+	struct clk_tz1090_gate *gate = to_clk_tz1090_gate(hw);
+
+	return gate->ops->is_enabled(&gate->gate.hw);
+}
+
+static const struct clk_ops clk_tz1090_gate_ops = {
+	.enable = clk_tz1090_gate_enable,
+	.disable = clk_tz1090_gate_disable,
+	.is_enabled = clk_tz1090_gate_is_enabled,
+};
+
+/**
+ * clk_register_tz1090_gate - register a TZ1090 gate clock with clock framework
+ * @name: name of this clock
+ * @parent_name: name of this clock's parent
+ * @flags: framework-specific flags for this clock
+ * @reg: register address to control gating of this clock
+ * @bit_idx: which bit in the register controls gating of this clock
+ * @clk_gate_flags: gate-specific flags for this clock
+ */
+static struct clk *__init clk_register_tz1090_gate(const char *name,
+				const char *parent_name, unsigned long flags,
+				void __iomem *reg, u8 bit_idx,
+				u8 clk_gate_flags)
+{
+	struct clk_tz1090_gate *gate;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the gate */
+	gate = kzalloc(sizeof(struct clk_tz1090_gate), GFP_KERNEL);
+	if (!gate)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_tz1090_gate_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_gate assignments */
+	gate->gate.reg = reg;
+	gate->gate.bit_idx = bit_idx;
+	gate->gate.flags = clk_gate_flags;
+	gate->gate.hw.init = &init;
+
+	/* struct clk_tz1090_gate assignments */
+	gate->ops = &clk_gate_ops;
+
+	clk = clk_register(NULL, &gate->gate.hw);
+
+	if (IS_ERR(clk))
+		kfree(gate);
+
+	return clk;
+}
+
+/**
+ * of_tz1090_gate_bank_setup() - Setup function for gate bank in TZ1090
+ */
+static void __init of_tz1090_gate_bank_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	const char *parent_name;
+	u32 mask;
+	unsigned int shift, i;
+	unsigned int successes = 0;
+	struct clk_onecell_data *provider_data = NULL;
+	int count;
+
+	if (of_property_read_u32(node, "bit-mask", &mask))
+		return;
+
+	count = of_property_count_strings(node, "clock-output-names");
+	if (count < 1)
+		return;
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("%s(%s): of_iomap failed\n",
+		       __func__, clk_name);
+		return;
+	}
+
+	provider_data = kzalloc(sizeof(*provider_data), GFP_KERNEL);
+	if (!provider_data)
+		goto done;
+	provider_data->clks = kcalloc(count, sizeof(provider_data->clks[0]),
+				      GFP_KERNEL);
+	if (!provider_data->clks)
+		goto done;
+
+	for (i = 0; mask && i < count; ++i) {
+		/* Find next set bit in mask */
+		shift = ffs(mask) - 1;
+		mask &= ~BIT(shift);
+
+		if (of_property_read_string_index(node, "clock-output-names", i,
+						  &clk_name))
+			goto done;
+
+
+		parent_name = of_clk_get_parent_name(node, i);
+		if (!parent_name)
+			goto done;
+
+		++provider_data->clk_num;
+		clk = clk_register_tz1090_gate(clk_name, parent_name,
+				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, reg,
+				shift, 0);
+		if (!IS_ERR(clk))
+			++successes;
+		provider_data->clks[i] = clk;
+	}
+done:
+
+	if (!successes) {
+		if (provider_data) {
+			kfree(provider_data->clks);
+			kfree(provider_data);
+		}
+		iounmap(reg);
+		return;
+	}
+
+	of_clk_add_provider(node, of_clk_src_onecell_get, provider_data);
+}
+CLK_OF_DECLARE(tz1090_gate_bank_clk, "img,tz1090-gate-bank",
+	       of_tz1090_gate_bank_setup);
-- 
2.0.4

