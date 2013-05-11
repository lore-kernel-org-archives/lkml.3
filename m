Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3EKBIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:08:25 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:44868 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab3EKBIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 21:08:21 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] clk: mvebu: add common clock functions for core clk and clk gating
Date: Sat, 11 May 2013 03:08:02 +0200
Message-Id: <1368234490-31416-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the current common functions for core clocks and clock
gating control, new common functions are joined in a single file.
Given the opportunity, names of functions and structs are unified,
and also a Kconfig entry is added.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/mvebu/Kconfig  |    3 +
 drivers/clk/mvebu/Makefile |    1 +
 drivers/clk/mvebu/common.c |  163 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mvebu/common.h |   48 +++++++++++++
 4 files changed, 215 insertions(+)
 create mode 100644 drivers/clk/mvebu/common.c
 create mode 100644 drivers/clk/mvebu/common.h

diff --git a/drivers/clk/mvebu/Kconfig b/drivers/clk/mvebu/Kconfig
index 57323fd..2c3cf95 100644
--- a/drivers/clk/mvebu/Kconfig
+++ b/drivers/clk/mvebu/Kconfig
@@ -6,3 +6,6 @@ config MVEBU_CLK_CPU
 
 config MVEBU_CLK_GATING
        bool
+
+config MVEBU_CLK_COMMON
+	bool
diff --git a/drivers/clk/mvebu/Makefile b/drivers/clk/mvebu/Makefile
index 58df3dc..2143230 100644
--- a/drivers/clk/mvebu/Makefile
+++ b/drivers/clk/mvebu/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_MVEBU_CLK_COMMON)	+= common.o
 obj-$(CONFIG_MVEBU_CLK_CORE) 	+= clk.o clk-core.o
 obj-$(CONFIG_MVEBU_CLK_CPU) 	+= clk-cpu.o
 obj-$(CONFIG_MVEBU_CLK_GATING) 	+= clk-gating-ctrl.o
diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
new file mode 100644
index 0000000..adaa4a1
--- /dev/null
+++ b/drivers/clk/mvebu/common.c
@@ -0,0 +1,163 @@
+/*
+ * Marvell EBU SoC common clock handling
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ * Andrew Lunn <andrew@lunn.ch>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include "common.h"
+
+/*
+ * Core Clocks
+ */
+
+static struct clk_onecell_data clk_data;
+
+void __init mvebu_coreclk_setup(struct device_node *np,
+				const struct coreclk_soc_desc *desc)
+{
+	const char *tclk_name = "tclk";
+	const char *cpuclk_name = "cpuclk";
+	void __iomem *base;
+	unsigned long rate;
+	int n;
+
+	base = of_iomap(np, 0);
+	if (WARN_ON(!base))
+		return;
+
+	/* Allocate struct for TCLK, cpu clk, and core ratio clocks */
+	clk_data.clk_num = 2 + desc->num_ratios;
+	clk_data.clks = kzalloc(clk_data.clk_num * sizeof(struct clk *),
+				GFP_KERNEL);
+	if (WARN_ON(!clk_data.clks))
+		return;
+
+	/* Register TCLK */
+	of_property_read_string_index(np, "clock-output-names", 0,
+				      &tclk_name);
+	rate = desc->get_tclk_freq(base);
+	clk_data.clks[0] = clk_register_fixed_rate(NULL, tclk_name, NULL,
+						   CLK_IS_ROOT, rate);
+	WARN_ON(IS_ERR(clk_data.clks[0]));
+
+	/* Register CPU clock */
+	of_property_read_string_index(np, "clock-output-names", 1,
+				      &cpuclk_name);
+	rate = desc->get_cpu_freq(base);
+	clk_data.clks[1] = clk_register_fixed_rate(NULL, cpuclk_name, NULL,
+						   CLK_IS_ROOT, rate);
+	WARN_ON(IS_ERR(clk_data.clks[1]));
+
+	/* Register fixed-factor clocks derived from CPU clock */
+	for (n = 0; n < desc->num_ratios; n++) {
+		const char *rclk_name = desc->ratios[n].name;
+		int mult, div;
+
+		of_property_read_string_index(np, "clock-output-names",
+					      2+n, &rclk_name);
+		desc->get_clk_ratio(base, desc->ratios[n].id, &mult, &div);
+		clk_data.clks[2+n] = clk_register_fixed_factor(NULL, rclk_name,
+				       cpuclk_name, 0, mult, div);
+		WARN_ON(IS_ERR(clk_data.clks[2+n]));
+	};
+
+	/* SAR register isn't needed anymore */
+	iounmap(base);
+
+	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
+}
+
+/*
+ * Clock Gating Control
+ */
+
+struct clk_gating_ctrl {
+	spinlock_t lock;
+	struct clk **gates;
+	int num_gates;
+};
+
+#define to_clk_gate(_hw) container_of(_hw, struct clk_gate, hw)
+
+static struct clk *clk_gating_get_src(
+	struct of_phandle_args *clkspec, void *data)
+{
+	struct clk_gating_ctrl *ctrl = (struct clk_gating_ctrl *)data;
+	int n;
+
+	if (clkspec->args_count < 1)
+		return ERR_PTR(-EINVAL);
+
+	for (n = 0; n < ctrl->num_gates; n++) {
+		struct clk_gate *gate =
+			to_clk_gate(__clk_get_hw(ctrl->gates[n]));
+		if (clkspec->args[0] == gate->bit_idx)
+			return ctrl->gates[n];
+	}
+	return ERR_PTR(-ENODEV);
+}
+
+void __init mvebu_clk_gating_setup(struct device_node *np,
+				   const struct clk_gating_soc_desc *desc)
+{
+	struct clk_gating_ctrl *ctrl;
+	struct clk *clk;
+	void __iomem *base;
+	const char *default_parent = NULL;
+	int n;
+
+	base = of_iomap(np, 0);
+	if (WARN_ON(!base))
+		return;
+
+	clk = of_clk_get(np, 0);
+	if (!IS_ERR(clk)) {
+		default_parent = __clk_get_name(clk);
+		clk_put(clk);
+	}
+
+	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
+	if (WARN_ON(!ctrl))
+		return;
+
+	spin_lock_init(&ctrl->lock);
+
+	/* Count, allocate, and register clock gates */
+	for (n = 0; desc[n].name;)
+		n++;
+
+	ctrl->num_gates = n;
+	ctrl->gates = kzalloc(ctrl->num_gates * sizeof(struct clk *),
+			      GFP_KERNEL);
+	if (WARN_ON(!ctrl->gates)) {
+		kfree(ctrl);
+		return;
+	}
+
+	for (n = 0; n < ctrl->num_gates; n++) {
+		const char *parent =
+			(desc[n].parent) ? desc[n].parent : default_parent;
+		ctrl->gates[n] = clk_register_gate(NULL, desc[n].name, parent,
+					desc[n].flags, base, desc[n].bit_idx,
+					0, &ctrl->lock);
+		WARN_ON(IS_ERR(ctrl->gates[n]));
+	}
+
+	of_clk_add_provider(np, clk_gating_get_src, ctrl);
+}
diff --git a/drivers/clk/mvebu/common.h b/drivers/clk/mvebu/common.h
new file mode 100644
index 0000000..f968b4d
--- /dev/null
+++ b/drivers/clk/mvebu/common.h
@@ -0,0 +1,48 @@
+/*
+ * Marvell EBU SoC common clock handling
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ * Andrew Lunn <andrew@lunn.ch>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __CLK_MVEBU_COMMON_H_
+#define __CLK_MVEBU_COMMON_H_
+
+#include <linux/kernel.h>
+
+struct device_node;
+
+struct coreclk_ratio {
+	int id;
+	const char *name;
+};
+
+struct coreclk_soc_desc {
+	u32 (*get_tclk_freq)(void __iomem *sar);
+	u32 (*get_cpu_freq)(void __iomem *sar);
+	void (*get_clk_ratio)(void __iomem *sar, int id, int *mult, int *div);
+	const struct coreclk_ratio *ratios;
+	int num_ratios;
+};
+
+struct clk_gating_soc_desc {
+	const char *name;
+	const char *parent;
+	int bit_idx;
+	unsigned long flags;
+};
+
+void __init mvebu_coreclk_setup(struct device_node *np,
+				const struct coreclk_soc_desc *desc);
+
+void __init mvebu_clk_gating_setup(struct device_node *np,
+				   const struct clk_gating_soc_desc *desc);
+
+#endif
-- 
1.7.10.4

