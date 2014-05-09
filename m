Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaEILNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:13:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44795 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756156AbaEILME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:12:04 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 5/7] clk: sunxi: add PRCM (Power/Reset/Clock Management) clks support
Date: Fri,  9 May 2014 13:11:49 +0200
Message-Id: <1399633911-7094-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PRCM (Power/Reset/Clock Management) unit provides several clock
devices:
- AR100 clk: used to clock the Power Management co-processor
- AHB0 clk: used to clock the AHB0 bus
- APB0 clk and gates: used to clk peripherals connected to the APB0 bus

Add support for these clks in a separate driver so that they can be probed
as platform devices instead of registered during early init.
This is needed to be able to probe PRCM MFD subdevices.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/Makefile         |   2 +
 drivers/clk/sunxi/clk-sun6i-prcm.c | 343 +++++++++++++++++++++++++++++++++++++
 2 files changed, 345 insertions(+)
 create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm.c

diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
index b5bac91..ef8cdc9 100644
--- a/drivers/clk/sunxi/Makefile
+++ b/drivers/clk/sunxi/Makefile
@@ -3,3 +3,5 @@
 #
 
 obj-y += clk-sunxi.o clk-factors.o
+
+obj-$(CONFIG_MFD_SUN6I_PRCM) += clk-sun6i-prcm.o
diff --git a/drivers/clk/sunxi/clk-sun6i-prcm.c b/drivers/clk/sunxi/clk-sun6i-prcm.c
new file mode 100644
index 0000000..3efaf8f
--- /dev/null
+++ b/drivers/clk/sunxi/clk-sun6i-prcm.c
@@ -0,0 +1,343 @@
+/*
+ * Copyright (C) 2014 Free Electrons
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * Allwinner PRCM (Power/Reset/Clock Management) driver
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#define SUN6I_APB0_GATES_MAX_SIZE	32
+#define SUN6I_AR100_MAX_PARENTS		4
+#define SUN6I_AR100_SHIFT_MASK		0x3
+#define SUN6I_AR100_SHIFT_MAX		SUN6I_AR100_SHIFT_MASK
+#define SUN6I_AR100_SHIFT_SHIFT		4
+#define SUN6I_AR100_DIV_MASK		0x1f
+#define SUN6I_AR100_DIV_MAX		(SUN6I_AR100_DIV_MASK + 1)
+#define SUN6I_AR100_DIV_SHIFT		8
+#define SUN6I_AR100_MUX_MASK		0x3
+#define SUN6I_AR100_MUX_SHIFT		16
+
+struct ar100_clk {
+	struct clk_hw hw;
+	void __iomem *reg;
+};
+
+static inline struct ar100_clk *to_ar100_clk(struct clk_hw *hw)
+{
+	return container_of(hw, struct ar100_clk, hw);
+}
+
+static unsigned long ar100_recalc_rate(struct clk_hw *hw,
+				       unsigned long parent_rate)
+{
+	struct ar100_clk *clk = to_ar100_clk(hw);
+	u32 val = readl(clk->reg);
+	int shift = (val >> SUN6I_AR100_SHIFT_SHIFT) & SUN6I_AR100_SHIFT_MASK;
+	int div = (val >> SUN6I_AR100_DIV_SHIFT) & SUN6I_AR100_DIV_MASK;
+
+	return (parent_rate >> shift) / (div + 1);
+}
+
+static long ar100_determine_rate(struct clk_hw *hw, unsigned long rate,
+				 unsigned long *best_parent_rate,
+				 struct clk **best_parent_clk)
+{
+	int nparents = __clk_get_num_parents(hw->clk);
+	long best_rate = -EINVAL;
+	int i;
+
+	*best_parent_clk = NULL;
+
+	for (i = 0; i < nparents; i++) {
+		unsigned long parent_rate;
+		unsigned long tmp_rate;
+		struct clk *parent;
+		unsigned long div;
+		int shift;
+
+		parent = clk_get_parent_by_index(hw->clk, i);
+		parent_rate = __clk_get_rate(parent);
+		div = DIV_ROUND_UP(parent_rate, rate);
+
+		shift = ffs(div) - 1;
+		if (shift > SUN6I_AR100_SHIFT_MAX)
+			shift = SUN6I_AR100_SHIFT_MAX;
+
+		div >>= shift;
+
+		while (div > SUN6I_AR100_DIV_MAX) {
+			shift++;
+			div >>= 1;
+			if (shift > SUN6I_AR100_SHIFT_MAX)
+				break;
+		}
+
+		if (shift > SUN6I_AR100_SHIFT_MAX)
+			continue;
+
+		tmp_rate = (parent_rate >> shift) / div;
+		if (!*best_parent_clk || tmp_rate > best_rate) {
+			*best_parent_clk = parent;
+			*best_parent_rate = parent_rate;
+			best_rate = tmp_rate;
+		}
+	}
+
+	return best_rate;
+}
+
+static int ar100_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct ar100_clk *clk = to_ar100_clk(hw);
+	u32 val = readl(clk->reg);
+
+	if (index >= SUN6I_AR100_MAX_PARENTS)
+		return -EINVAL;
+
+	val &= ~(SUN6I_AR100_MUX_MASK << SUN6I_AR100_MUX_SHIFT);
+	val |= (index << SUN6I_AR100_MUX_SHIFT);
+	writel(val, clk->reg);
+
+	return 0;
+}
+
+static u8 ar100_get_parent(struct clk_hw *hw)
+{
+	struct ar100_clk *clk = to_ar100_clk(hw);
+	return (readl(clk->reg) >> SUN6I_AR100_MUX_SHIFT) &
+	       SUN6I_AR100_MUX_MASK;
+}
+
+static int ar100_set_rate(struct clk_hw *hw, unsigned long rate,
+			  unsigned long parent_rate)
+{
+	unsigned long div = parent_rate / rate;
+	struct ar100_clk *clk = to_ar100_clk(hw);
+	u32 val = readl(clk->reg);
+	int shift;
+
+	if (parent_rate % rate)
+		return -EINVAL;
+
+	shift = ffs(div) - 1;
+	if (shift > SUN6I_AR100_SHIFT_MAX)
+		shift = SUN6I_AR100_SHIFT_MAX;
+
+	div >>= shift;
+
+	if (div > SUN6I_AR100_DIV_MAX)
+		return -EINVAL;
+
+	val &= ~((SUN6I_AR100_SHIFT_MASK << SUN6I_AR100_SHIFT_SHIFT) |
+		 (SUN6I_AR100_DIV_MASK << SUN6I_AR100_DIV_SHIFT));
+	val |= (shift << SUN6I_AR100_SHIFT_SHIFT) |
+	       (div << SUN6I_AR100_DIV_SHIFT);
+	writel(val, clk->reg);
+
+	return 0;
+}
+
+struct clk_ops ar100_ops = {
+	.recalc_rate = ar100_recalc_rate,
+	.determine_rate = ar100_determine_rate,
+	.set_parent = ar100_set_parent,
+	.get_parent = ar100_get_parent,
+	.set_rate = ar100_set_rate,
+};
+
+static int sun6i_a31_ar100_clk_register(struct platform_device *pdev)
+{
+	const char *parents[SUN6I_AR100_MAX_PARENTS];
+	struct device_node *np = pdev->dev.of_node;
+	const char *clk_name = np->name;
+	struct clk_init_data init;
+	struct ar100_clk *ar100;
+	struct resource *r;
+	struct clk *clk;
+	int nparents;
+	int i;
+
+	ar100 = devm_kzalloc(&pdev->dev, sizeof(*ar100), GFP_KERNEL);
+	if (!ar100)
+		return -ENOMEM;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ar100->reg = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(ar100->reg))
+		return PTR_ERR(ar100->reg);
+
+	nparents = of_clk_get_parent_count(np);
+	if (nparents > SUN6I_AR100_MAX_PARENTS)
+		nparents = SUN6I_AR100_MAX_PARENTS;
+
+	for (i = 0; i < nparents; i++)
+		parents[i] = of_clk_get_parent_name(np, i);
+
+	of_property_read_string(np, "clock-output-names", &clk_name);
+
+	init.name = clk_name;
+	init.ops = &ar100_ops;
+	init.parent_names = parents;
+	init.num_parents = nparents;
+	init.flags = 0;
+
+	ar100->hw.init = &init;
+
+	clk = clk_register(&pdev->dev, &ar100->hw);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	return of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+static const struct clk_div_table sun6i_a31_apb0_divs[] = {
+	{ .val = 0, .div = 2, },
+	{ .val = 1, .div = 2, },
+	{ .val = 2, .div = 4, },
+	{ .val = 3, .div = 8, },
+	{ /* sentinel */ },
+};
+
+static int sun6i_a31_apb0_clk_register(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const char *clk_name = np->name;
+	const char *clk_parent;
+	struct resource *r;
+	void __iomem *reg;
+	struct clk *clk;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	reg = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
+		clk_parent = of_clk_get_parent_name(np, 0);
+	if (!clk_parent)
+		return -EINVAL;
+
+	of_property_read_string(np, "clock-output-names", &clk_name);
+
+	clk = clk_register_divider_table(&pdev->dev, clk_name, clk_parent,
+					 0, reg, 0, 2, 0, sun6i_a31_apb0_divs,
+					 NULL);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	return of_clk_add_provider(np, of_clk_src_simple_get, clk);
+}
+
+static int sun6i_a31_apb0_gates_clk_register(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct clk_onecell_data *clk_data;
+	const char *clk_parent;
+	const char *clk_name;
+	struct resource *r;
+	void __iomem *reg;
+	int gate_id;
+	int ngates;
+	int i;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	reg = devm_ioremap_resource(&pdev->dev, r);
+	if (!reg)
+		return PTR_ERR(reg);
+
+	clk_parent = of_clk_get_parent_name(np, 0);
+	if (!clk_parent)
+		return -EINVAL;
+
+	ngates = of_property_count_strings(np, "clock-output-names");
+	if (ngates < 0)
+		return ngates;
+
+	if (!ngates || ngates > SUN6I_APB0_GATES_MAX_SIZE)
+		return -EINVAL;
+
+	clk_data = devm_kzalloc(&pdev->dev, sizeof(struct clk_onecell_data),
+				GFP_KERNEL);
+	if (!clk_data)
+		return -ENOMEM;
+
+	clk_data->clks = devm_kzalloc(&pdev->dev,
+				      SUN6I_APB0_GATES_MAX_SIZE *
+				      sizeof(struct clk *),
+				      GFP_KERNEL);
+	if (!clk_data->clks)
+		return -ENOMEM;
+
+	for (i = 0; i < ngates; i++) {
+		of_property_read_string_index(np, "clock-output-names",
+					      i, &clk_name);
+
+		gate_id = i;
+		of_property_read_u32_index(np, "clock-indices", i, &gate_id);
+
+		WARN_ON(gate_id >= SUN6I_APB0_GATES_MAX_SIZE);
+		if (gate_id >= SUN6I_APB0_GATES_MAX_SIZE)
+			continue;
+
+		clk_data->clks[gate_id] = clk_register_gate(&pdev->dev,
+							    clk_name,
+							    clk_parent, 0,
+							    reg, gate_id,
+							    0, NULL);
+		WARN_ON(IS_ERR(clk_data->clks[gate_id]));
+	}
+
+	clk_data->clk_num = ngates;
+
+	return of_clk_add_provider(np, of_clk_src_onecell_get, clk_data);
+}
+
+const struct of_device_id sun6i_a31_prcm_clk_dt_ids[] = {
+	{
+		.compatible = "allwinner,sun6i-a31-ar100-clk",
+		.data = sun6i_a31_ar100_clk_register,
+	},
+	{
+		.compatible = "allwinner,sun6i-a31-apb0-clk",
+		.data = sun6i_a31_apb0_clk_register,
+	},
+	{
+		.compatible = "allwinner,sun6i-a31-apb0-gates-clk",
+		.data = sun6i_a31_apb0_gates_clk_register,
+	},
+	{ /* sentinel */ }
+};
+
+static int sun6i_a31_prcm_clk_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	int (*register_func)(struct platform_device *pdev);
+	const struct of_device_id *match;
+
+	match = of_match_node(sun6i_a31_prcm_clk_dt_ids, np);
+	if (!match)
+		return -EINVAL;
+
+	register_func = match->data;
+	return register_func(pdev);
+}
+
+static struct platform_driver sun6i_a31_prcm_clk_driver = {
+	.driver = {
+		.name = "sun6i-a31-prcm-clk",
+		.owner = THIS_MODULE,
+		.of_match_table = sun6i_a31_prcm_clk_dt_ids,
+	},
+	.probe = sun6i_a31_prcm_clk_probe,
+};
+module_platform_driver(sun6i_a31_prcm_clk_driver);
+
+MODULE_AUTHOR("Boris BREZILLON <boris.brezillon@free-electrons.com>");
+MODULE_DESCRIPTION("Allwinner PRCM clock Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

