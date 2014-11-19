Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbaKSXRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:17:36 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35711 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254AbaKSXQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:21 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 12/15] clk: tz1090: add PDC clock driver
Date: Wed, 19 Nov 2014 23:15:40 +0000
Message-Id: <1416438943-11429-13-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TZ1090 PDC (PowerDown Controller) clock should be at 32.768KHz, and
is generated either directly from the XTAL3 clock or by dividing the
XTAL1 clock. Both the divide and the mux are in a single register which
also contains GPIO output data, and may need to be used by other
non-Linux cores and threads, so create a special clock type for this
clock.

Two subclocks are created, a divider and a mux. The divider wraps the
generic divider but takes the Meta exclusive lock when setting the rate.
The mux uses the existing mux wrapper in clk-tz1090-mux-bank.c which
also takes the Meta exclusive lock when changing the parent.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
 drivers/clk/tz1090/Makefile         |   1 +
 drivers/clk/tz1090/clk-tz1090-pdc.c | 185 ++++++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-pdc.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index d17e48c..92e38a8 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -2,4 +2,5 @@
 obj-y		+= clk-tz1090-deleter.o
 obj-y		+= clk-tz1090-gate-bank.o
 obj-y		+= clk-tz1090-mux-bank.o
+obj-y		+= clk-tz1090-pdc.o
 obj-y		+= clk-tz1090-pll.o
diff --git a/drivers/clk/tz1090/clk-tz1090-pdc.c b/drivers/clk/tz1090/clk-tz1090-pdc.c
new file mode 100644
index 0000000..e4ac145
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-pdc.c
@@ -0,0 +1,185 @@
+/*
+ * Copyright (C) 2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 PDC Clock (divider + mux)
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
+/* The TZ1090 PDC clock makes use of the TZ1090 mux wrapper (from mux bank) */
+struct clk *__init
+clk_register_tz1090_mux(const char *name, const char **parent_names,
+			unsigned long flags, void __iomem *reg, u8 shift,
+			u8 clk_mux_flags);
+
+/**
+ * struct clk_tz1090_div - tz1090 divider clock
+ *
+ * @div:	the parent class
+ * @ops:	pointer to clk_ops of parent class
+ *
+ * Divider clock whose field shares a register with other fields which may be
+ * used by multiple threads/cores and other drivers.
+ */
+struct clk_tz1090_div {
+	struct clk_divider	div;
+	const struct clk_ops	*ops;
+};
+
+static inline struct clk_tz1090_div *to_clk_tz1090_div(struct clk_hw *hw)
+{
+	struct clk_divider *div = container_of(hw, struct clk_divider, hw);
+
+	return container_of(div, struct clk_tz1090_div, div);
+}
+
+static unsigned long clk_tz1090_divider_recalc_rate(struct clk_hw *hw,
+						    unsigned long parent_rate)
+{
+	struct clk_tz1090_div *div = to_clk_tz1090_div(hw);
+
+	return div->ops->recalc_rate(&div->div.hw, parent_rate);
+}
+
+static long clk_tz1090_divider_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *prate)
+{
+	struct clk_tz1090_div *div = to_clk_tz1090_div(hw);
+
+	return div->ops->round_rate(&div->div.hw, rate, prate);
+}
+
+/* Acquire exclusive lock since other cores may access the same register */
+static int clk_tz1090_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long parent_rate)
+{
+	struct clk_tz1090_div *div = to_clk_tz1090_div(hw);
+	int ret;
+	unsigned long flags;
+
+	__global_lock2(flags);
+	ret = div->ops->set_rate(&div->div.hw, rate, parent_rate);
+	__global_unlock2(flags);
+
+	return ret;
+}
+
+static const struct clk_ops clk_tz1090_div_ops = {
+	.recalc_rate = clk_tz1090_divider_recalc_rate,
+	.round_rate = clk_tz1090_divider_round_rate,
+	.set_rate = clk_tz1090_divider_set_rate,
+};
+
+static struct clk *__init
+clk_register_tz1090_divider(const char *name, const char *parent_name,
+			    unsigned long flags, void __iomem *reg, u8 shift,
+			    u32 mask, u8 clk_divider_flags)
+{
+	struct clk_tz1090_div *div;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the divider */
+	div = kzalloc(sizeof(struct clk_tz1090_div), GFP_KERNEL);
+	if (!div)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_tz1090_div_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_divider assignments */
+	div->div.reg = reg;
+	div->div.shift = shift;
+	div->div.mask = mask;
+	div->div.flags = clk_divider_flags;
+	div->div.hw.init = &init;
+
+	/* struct clk_tz1090_div assignments */
+	div->ops = &clk_divider_ops;
+
+	/* register the clock */
+	clk = clk_register(NULL, &div->div.hw);
+
+	if (IS_ERR(clk))
+		kfree(div);
+
+	return clk;
+}
+
+/**
+ * of_tz1090_pdc_clk_setup() - Setup function for PDC 32.768KHz clock in TZ1090
+ */
+static void __init of_tz1090_pdc_clk_setup(struct device_node *node)
+{
+	void __iomem *reg;
+	const char *clk_names[2];
+	const char *parent_names[2];
+	unsigned int i;
+	struct clk_onecell_data *provider_data;
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("%s(%s): of_iomap failed\n",
+		       __func__, node->name);
+		return;
+	}
+
+	for (i = 0; i < 2; ++i) {
+		/* input clocks */
+		parent_names[i] = of_clk_get_parent_name(node, i);
+		if (!parent_names[i]) {
+			pr_err("%s(%s): failed to get parent %u\n",
+			       __func__, node->name, i);
+			return;
+		}
+
+		/* output clocks */
+		if (of_property_read_string_index(node, "clock-output-names", i,
+						  &clk_names[i])) {
+			pr_err("%s(%s): failed to get clock %u name\n",
+			       __func__, node->name, i);
+			return;
+		}
+	}
+
+	provider_data = kzalloc(sizeof(*provider_data), GFP_KERNEL);
+	if (!provider_data)
+		return;
+	provider_data->clk_num = 2;
+	provider_data->clks = kzalloc(sizeof(provider_data->clks[0])*2,
+				      GFP_KERNEL);
+	if (!provider_data->clks) {
+		kfree(provider_data);
+		return;
+	}
+
+	/* divide 1st parent clock (XTAL1) */
+	provider_data->clks[0] = clk_register_tz1090_divider(clk_names[0],
+					parent_names[0], 0, reg,
+					16,		/* shift */
+					BIT(11) - 1,	/* mask */
+					0);
+	parent_names[0] = clk_names[0];
+	/* mux divided 1st parent clock (XTAL1) and 2nd parent clock (XTAL3) */
+	provider_data->clks[1] = clk_register_tz1090_mux(clk_names[1],
+					parent_names, CLK_SET_RATE_PARENT, reg,
+					30,		/* bit */
+					0);
+
+	of_clk_add_provider(node, of_clk_src_onecell_get, provider_data);
+}
+CLK_OF_DECLARE(tz1090_pdc_clk, "img,tz1090-pdc-clock", of_tz1090_pdc_clk_setup);
-- 
2.0.4

