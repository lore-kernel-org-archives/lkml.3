Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbaKSXS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:18:26 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33394 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbaKSXQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:17 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 10/15] clk: tz1090: add deleter clock driver
Date: Wed, 19 Nov 2014 23:15:38 +0000
Message-Id: <1416438943-11429-11-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for TZ1090 clock deleter, which deletes up to 1023 out of
every 1024 clock pulses. Two of these exist, one for the Meta core and
the other for the system clock.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
 drivers/clk/tz1090/Makefile             |   1 +
 drivers/clk/tz1090/clk-tz1090-deleter.c | 188 ++++++++++++++++++++++++++++++++
 2 files changed, 189 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-deleter.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index ee6a6fe..d17e48c 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -1,4 +1,5 @@
 # Makefile for TZ1090-specific clocks
+obj-y		+= clk-tz1090-deleter.o
 obj-y		+= clk-tz1090-gate-bank.o
 obj-y		+= clk-tz1090-mux-bank.o
 obj-y		+= clk-tz1090-pll.o
diff --git a/drivers/clk/tz1090/clk-tz1090-deleter.c b/drivers/clk/tz1090/clk-tz1090-deleter.c
new file mode 100644
index 0000000..b814430
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-deleter.c
@@ -0,0 +1,188 @@
+/*
+ * Copyright (C) 2012 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Clock deleter in TZ1090
+ */
+
+#include <linux/bitops.h>
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+/**
+ * struct clk_tz1090_deleter - Clock deleter
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @reg:	delete register
+ * @period:	cycle period
+ * @mask:	bit mask of delete field
+ * @shift:	start bit of delete field
+ *
+ * Deleter in TZ1090.  Implements .recalc_rate, .set_rate and .round_rate
+ */
+struct clk_tz1090_deleter {
+	struct clk_hw	hw;
+	void __iomem	*reg;
+	u32		period;
+	u32		mask;
+	u8		shift;
+};
+
+/*
+ * DOC: TZ1090 adjustable deleter clock that cannot gate
+ *
+ * Traits of this clock:
+ * prepare - clk_prepare only ensures that parents are prepared
+ * enable - clk_enable only ensures that parents are enabled
+ * rate - rate is adjustable in hardware but set_rate unimplemented.
+ *		clk->rate = (parent->rate * (period - delete)) / period
+ * parent - fixed parent. No clk_set_parent support
+ */
+
+#define to_clk_tz1090_deleter(_hw) \
+	container_of(_hw, struct clk_tz1090_deleter, hw)
+
+static unsigned long clk_tz1090_deleter_recalc_rate(struct clk_hw *hw,
+						    unsigned long parent_rate)
+{
+	struct clk_tz1090_deleter *deleter = to_clk_tz1090_deleter(hw);
+	u32 delete;
+	u64 rate;
+
+	delete = (readl(deleter->reg) & deleter->mask) >> deleter->shift;
+	rate = (u64)parent_rate * (deleter->period - delete);
+	do_div(rate, deleter->period);
+	return rate;
+}
+
+static const struct clk_ops clk_tz1090_deleter_ops = {
+	.recalc_rate = clk_tz1090_deleter_recalc_rate,
+};
+
+/**
+ * clk_register_tz1090_deleter_setup - register a clock deleter clock
+ * @dev:		device registering this clock
+ * @name:		name of this clock
+ * @parent_name:	name of clock's parent
+ * @flags:		framework-specific flags
+ * @reg:		register address to adjust deleter
+ * @period:		delete cycle period
+ * @mask:		mask of delete field
+ * @shift:		start bit of delete field
+ *
+ * Register a TZ1090 clock deleter with the clock framework.
+ */
+static struct clk *__init clk_register_tz1090_deleter(struct device *dev,
+						      const char *name,
+						      const char *parent_name,
+						      unsigned long flags,
+						      void __iomem *reg,
+						      u32 period,
+						      u32 mask,
+						      u8 shift)
+{
+	struct clk_tz1090_deleter *deleter;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the divider */
+	deleter = kzalloc(sizeof(struct clk_tz1090_deleter), GFP_KERNEL);
+	if (!deleter)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_tz1090_deleter_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_tz1090_deleter assignments */
+	deleter->reg = reg;
+	deleter->period = period;
+	deleter->mask = mask;
+	deleter->shift = shift;
+	deleter->hw.init = &init;
+
+	/* register the clock */
+	clk = clk_register(dev, &deleter->hw);
+
+	if (IS_ERR(clk))
+		kfree(deleter);
+
+	return clk;
+}
+
+#ifdef CONFIG_OF
+/**
+ * of_tz1090_deleter_setup() - Setup function for clock deleter
+ */
+static void __init of_tz1090_deleter_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	void __iomem *reg;
+	u32 mask, shift, period;
+	const char *parent_name;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	if (of_property_read_u32(node, "bit-mask", &mask)) {
+		pr_err("%s(%s): could not read bit-mask property\n",
+		       __func__, clk_name);
+		return;
+	}
+
+	if (of_property_read_u32(node, "bit-shift", &shift)) {
+		shift = ffs(mask) - 1;
+		pr_debug("%s(%s): bit-shift property defaults to %u\n",
+			 __func__, clk_name, shift);
+	}
+
+	if (of_property_read_u32(node, "cycle-period", &period)) {
+		period = fls(mask);
+		if (shift > period) {
+			pr_err("%s(%s): bit-shift %u beyond top of bit-mask %#x\n",
+			       __func__, clk_name, shift, mask);
+			return;
+		}
+		period = 1 << (period - shift);
+		pr_debug("%s(%s): cycle-period property defaults to %u\n",
+			 __func__, clk_name, period);
+	}
+
+	parent_name = of_clk_get_parent_name(node, 0);
+	if (!parent_name) {
+		pr_err("%s(%s): could not read parent clock\n",
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
+	clk = clk_register_tz1090_deleter(NULL, clk_name, parent_name, 0, reg,
+					  period, mask, shift);
+	if (IS_ERR(clk))
+		goto err_iounmap;
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+
+	return;
+
+err_iounmap:
+	iounmap(reg);
+}
+CLK_OF_DECLARE(tz1090_deleter_clk, "img,tz1090-deleter",
+	       of_tz1090_deleter_setup);
+#endif /* CONFIG_OF */
-- 
2.0.4

