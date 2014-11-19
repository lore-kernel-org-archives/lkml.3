Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbaKSXQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:16:20 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41187 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144AbaKSXQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:14 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 08/15] clk: tz1090: add mux bank clock driver
Date: Wed, 19 Nov 2014 23:15:36 +0000
Message-Id: <1416438943-11429-9-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock driver for banks of clock muxes in the TZ1090 SoC. A single
32 bit register controls up to 32 separate clock muxes. The driver
instantiates separate generic clock muxes. The clock operations are
wrapped in order to acquire and release the Meta global exclusive lock
(__global_lock2) to ensure atomicity with other non-Linux cores and
threads which may need to control some of the clocks.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
 drivers/clk/tz1090/Makefile              |   1 +
 drivers/clk/tz1090/clk-tz1090-mux-bank.c | 191 +++++++++++++++++++++++++++++++
 2 files changed, 192 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-mux-bank.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index ce36250..ee6a6fe 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -1,3 +1,4 @@
 # Makefile for TZ1090-specific clocks
 obj-y		+= clk-tz1090-gate-bank.o
+obj-y		+= clk-tz1090-mux-bank.o
 obj-y		+= clk-tz1090-pll.o
diff --git a/drivers/clk/tz1090/clk-tz1090-mux-bank.c b/drivers/clk/tz1090/clk-tz1090-mux-bank.c
new file mode 100644
index 0000000..d9a2345
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-mux-bank.c
@@ -0,0 +1,191 @@
+/*
+ * Copyright (C) 2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 Clock mux bank
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
+ * struct clk_tz1090_mux - tz1090 multiplexer clock
+ *
+ * @mux:	the parent class
+ * @ops:	pointer to clk_ops of parent class
+ *
+ * Clock with multiple selectable parents. Extends basic mux by using a global
+ * exclusive lock when read-modify-writing the mux field so that multiple
+ * threads/cores can use different fields in the same register.
+ */
+struct clk_tz1090_mux {
+	struct clk_mux		mux;
+	const struct clk_ops	*ops;
+};
+
+static inline struct clk_tz1090_mux *to_clk_tz1090_mux(struct clk_hw *hw)
+{
+	struct clk_mux *mux = container_of(hw, struct clk_mux, hw);
+
+	return container_of(mux, struct clk_tz1090_mux, mux);
+}
+
+static u8 clk_tz1090_mux_get_parent(struct clk_hw *hw)
+{
+	struct clk_tz1090_mux *mux = to_clk_tz1090_mux(hw);
+
+	return mux->ops->get_parent(&mux->mux.hw);
+}
+
+/* Acquire exclusive lock since other cores may access the same register */
+static int clk_tz1090_mux_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_tz1090_mux *mux = to_clk_tz1090_mux(hw);
+	int ret;
+	unsigned long flags;
+
+	__global_lock2(flags);
+	ret = mux->ops->set_parent(&mux->mux.hw, index);
+	__global_unlock2(flags);
+
+	return ret;
+}
+
+static long clk_tz1090_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
+				     unsigned long *prate,
+				     struct clk **best_parent)
+{
+	struct clk_tz1090_mux *mux = to_clk_tz1090_mux(hw);
+
+	return mux->ops->determine_rate(&mux->mux.hw, rate, prate, best_parent);
+}
+
+static const struct clk_ops clk_tz1090_mux_ops = {
+	.get_parent = clk_tz1090_mux_get_parent,
+	.set_parent = clk_tz1090_mux_set_parent,
+	.determine_rate = clk_tz1090_mux_determine_rate,
+};
+
+struct clk *__init
+clk_register_tz1090_mux(const char *name, const char **parent_names,
+			unsigned long flags, void __iomem *reg, u8 shift,
+			u8 clk_mux_flags)
+{
+	struct clk_tz1090_mux *mux;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the mux */
+	mux = kzalloc(sizeof(struct clk_tz1090_mux), GFP_KERNEL);
+	if (!mux)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_tz1090_mux_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = parent_names;
+	init.num_parents = 2;
+
+	/* struct clk_mux assignments */
+	mux->mux.reg = reg;
+	mux->mux.shift = shift;
+	mux->mux.mask = 0x1;
+	mux->mux.flags = clk_mux_flags;
+	mux->mux.hw.init = &init;
+
+	/* struct clk_tz1090_mux assignments */
+	mux->ops = &clk_mux_ops;
+
+	clk = clk_register(NULL, &mux->mux.hw);
+
+	if (IS_ERR(clk))
+		kfree(mux);
+
+	return clk;
+}
+
+/**
+ * of_tz1090_mux_bank_setup() - Setup function for mux bank in TZ1090
+ */
+static void __init of_tz1090_mux_bank_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	const char *parent_name[2];
+	u32 mask;
+	unsigned int shift, i, j;
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
+		for (j = 0; j < 2; ++j) {
+			parent_name[j] = of_clk_get_parent_name(node, i*2 + j);
+			if (!parent_name[j])
+				goto done;
+		}
+
+		++provider_data->clk_num;
+		clk = clk_register_tz1090_mux(clk_name, parent_name,
+					      CLK_SET_RATE_PARENT, reg, shift,
+					      0);
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
+CLK_OF_DECLARE(tz1090_mux_bank_clk, "img,tz1090-mux-bank",
+	       of_tz1090_mux_bank_setup);
-- 
2.0.4

