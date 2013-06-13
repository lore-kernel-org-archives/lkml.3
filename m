Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3FMBvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:51:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41176 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab3FMBtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:49:16 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [RFC/PATCH 08/13] clk: msm: Add MSM clock driver
Date: Wed, 12 Jun 2013 18:49:04 -0700
Message-Id: <1371088149-22562-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
In-Reply-To: <1371088149-22562-1-git-send-email-sboyd@codeaurora.org>
References: <1371088149-22562-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock driver that registers clocks from a DT node's
'clocks' child. Each new SoC will add a file describing the
software interface and frequency plan to drivers/clk/msm/ and
then hook that into the msm_cc_match_table by means of a
compatible string and an msm_clk_match table.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/msm/Makefile   |   2 +
 drivers/clk/msm/core.c     | 265 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/msm/internal.h |  24 ++++
 3 files changed, 291 insertions(+)
 create mode 100644 drivers/clk/msm/core.c
 create mode 100644 drivers/clk/msm/internal.h

diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
index e1cee29..9cfd0d7 100644
--- a/drivers/clk/msm/Makefile
+++ b/drivers/clk/msm/Makefile
@@ -4,3 +4,5 @@ clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-pll.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg2.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
+
+clk-msm-$(CONFIG_COMMON_CLK_MSM) += core.o
diff --git a/drivers/clk/msm/core.c b/drivers/clk/msm/core.c
new file mode 100644
index 0000000..b1904c0
--- /dev/null
+++ b/drivers/clk/msm/core.c
@@ -0,0 +1,265 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/clk-provider.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/spinlock.h>
+
+#include "internal.h"
+#include "clk-pll.h"
+#include "clk-rcg.h"
+#include "clk-branch.h"
+
+struct cc_data {
+	void __iomem *base;
+	spinlock_t lock;
+};
+
+static struct clk *
+dispatch_fixed_clk(struct of_clk_match *m, struct device *dev,
+		struct cc_data *cc)
+{
+	u32 rate;
+	const char *name = m->init_data->name;
+
+	if (of_property_read_u32(m->of_node, "clock-frequency", &rate))
+		return ERR_PTR(-EINVAL);
+
+	return clk_register_fixed_rate(dev, name, NULL, CLK_IS_ROOT, rate);
+}
+
+static struct clk *
+dispatch_pll_clk(struct of_clk_match *m, struct device *dev,
+		struct cc_data *cc)
+{
+	struct pll_desc *desc = m->driver_data;
+
+	desc->base = cc->base;
+
+	return pll_clk_register(dev, desc, m->init_data);
+}
+
+static struct clk *
+dispatch_pll_vote_clk(struct of_clk_match *m, struct device *dev,
+		struct cc_data *cc)
+{
+	struct pll_vote_desc *desc = m->driver_data;
+
+	desc->base = cc->base;
+
+	return pll_vote_clk_register(dev, desc, m->init_data);
+}
+
+static struct clk *
+dispatch_rcg_p2mn16_clk(struct of_clk_match *m, struct device *dev,
+		struct cc_data *cc)
+{
+	struct rcg_desc *desc = m->driver_data;
+
+	desc->base = cc->base;
+
+	return rcg_p2mn16_clk_register(dev, desc, &cc->lock, m->init_data);
+}
+
+static struct clk *
+dispatch_rcg_p2mn8_clk(struct of_clk_match *m, struct device *dev,
+		struct cc_data *cc)
+{
+	struct rcg_desc *desc = m->driver_data;
+
+	desc->base = cc->base;
+
+	return rcg_p2mn8_clk_register(dev, desc, &cc->lock, m->init_data);
+}
+
+static struct clk *
+dispatch_rcg_mn8_dyn_clk(struct of_clk_match *match, struct device *dev,
+		struct cc_data *cc)
+{
+	struct rcg_dyn_desc *desc = match->driver_data;
+
+	desc->base = cc->base;
+
+	return rcg_mn8_dyn_clk_register(dev, desc, &cc->lock,
+			match->init_data);
+}
+
+static struct clk *
+dispatch_rcg_p4_dyn_clk(struct of_clk_match *match, struct device *dev,
+		struct cc_data *cc)
+{
+	struct rcg_dyn_desc *desc = match->driver_data;
+
+	desc->base = cc->base;
+
+	return rcg_p4_dyn_clk_register(dev, desc, &cc->lock,
+			match->init_data);
+}
+
+static struct clk *
+dispatch_rcg_h5mn8_clk(struct of_clk_match *match, struct device *dev,
+		struct cc_data *cc)
+{
+	struct rcg2_desc *desc = match->driver_data;
+
+	desc->base = cc->base;
+
+	return rcg_h5mn8_clk_register(dev, desc, &cc->lock, match->init_data);
+}
+
+static struct clk *
+dispatch_rcg_h5mn16_clk(struct of_clk_match *match, struct device *dev,
+		struct cc_data *cc)
+{
+	struct rcg2_desc *desc = match->driver_data;
+
+	desc->base = cc->base;
+
+	return rcg_h5mn16_clk_register(dev, desc, &cc->lock, match->init_data);
+}
+
+static struct clk *
+dispatch_branch_clk(struct of_clk_match *m, struct device *dev,
+		struct cc_data *cc)
+{
+	struct branch_desc *desc = m->driver_data;
+
+	desc->base = cc->base;
+
+	return branch_clk_register(dev, desc, &cc->lock, m->init_data);
+}
+
+static struct clk *
+dispatch_branch_hg_clk(struct of_clk_match *m, struct device *dev,
+		struct cc_data *cc)
+{
+	struct branch_desc *desc = m->driver_data;
+
+	desc->base = cc->base;
+
+	return branch_hg_clk_register(dev, desc, &cc->lock, m->init_data);
+}
+
+static const struct of_device_id dispatch_table[] = {
+	{ .compatible = "fixed-clock", .data = dispatch_fixed_clk },
+	{ .compatible = "qcom,pll", .data = dispatch_pll_clk },
+	{ .compatible = "qcom,pll-vote", .data = dispatch_pll_vote_clk },
+	{ .compatible = "qcom,p2-mn8-clock", .data = dispatch_rcg_p2mn8_clk },
+	{ .compatible = "qcom,p2-mn16-clock", .data = dispatch_rcg_p2mn16_clk },
+	{ .compatible = "qcom,mn8-dyn-clock", .data = dispatch_rcg_mn8_dyn_clk },
+	{ .compatible = "qcom,p4-dyn-clock", .data = dispatch_rcg_p4_dyn_clk },
+	{ .compatible = "qcom,h5-mn8-clock", .data = dispatch_rcg_h5mn8_clk },
+	{ .compatible = "qcom,h5-mn16-clock", .data = dispatch_rcg_h5mn16_clk },
+	{ .compatible = "qcom,cxc-clock", .data = dispatch_branch_clk },
+	{ .compatible = "qcom,cxc-hg-clock", .data = dispatch_branch_hg_clk },
+};
+
+typedef struct clk *
+(*clk_dispatch_fn)(struct of_clk_match *m, struct device *dev,
+		struct cc_data *cc);
+
+static const struct of_device_id msm_cc_match_table[] = {
+	{ }
+};
+MODULE_DEVICE_TABLE(of, msm_cc_match_table);
+
+static int msm_cc_probe(struct platform_device *pdev)
+{
+	struct cc_data *cc;
+	void __iomem *base;
+	struct resource *res;
+	int count, i;
+	const struct of_device_id *id_entry;
+	const struct msm_clk_match *m;
+	struct of_clk_match *matches;
+	size_t size;
+
+	id_entry = of_match_device(msm_cc_match_table, &pdev->dev);
+	m = id_entry->data;
+	matches = m->matches;
+	size = m->size;
+
+	cc = devm_kzalloc(&pdev->dev, sizeof(*cc), GFP_KERNEL);
+	if (!cc)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	cc->base = base;
+	spin_lock_init(&cc->lock);
+
+	count = of_clk_match(&pdev->dev, matches, size);
+	if (count < 0)
+		return count;
+
+	for (i = 0; i < size; i++) {
+		struct of_clk_match *match;
+		const struct of_device_id *id;
+		struct device_node *np;
+		clk_dispatch_fn fn;
+		struct clk *clk;
+		int err;
+
+		match = &matches[i];
+		np = match->of_node;
+		if (!np)
+			continue;
+
+		id = of_match_node(dispatch_table, match->of_node);
+		if (!id)
+			continue;
+
+		fn = id->data;
+		clk = fn(match, &pdev->dev, cc);
+		if (IS_ERR(clk))
+			return PTR_ERR(clk);
+
+		err = of_clk_add_provider(np, of_clk_src_simple_get, clk);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static struct platform_driver msm_cc_driver = {
+	.probe		= msm_cc_probe,
+	.driver		= {
+		.name	= "msm-clock",
+		.owner	= THIS_MODULE,
+		.of_match_table = msm_cc_match_table,
+	},
+};
+
+static int __init msm_cc_init(void)
+{
+	return platform_driver_register(&msm_cc_driver);
+}
+core_initcall(msm_cc_init);
+
+static void __exit msm_cc_exit(void)
+{
+	platform_driver_unregister(&msm_cc_driver);
+}
+module_exit(msm_cc_exit);
+
+MODULE_DESCRIPTION("MSM Clock Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:msm-cc");
diff --git a/drivers/clk/msm/internal.h b/drivers/clk/msm/internal.h
new file mode 100644
index 0000000..177bd3b
--- /dev/null
+++ b/drivers/clk/msm/internal.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MSM_CLK_INTERNAL_H__
+#define __MSM_CLK_INTERNAL_H__
+
+struct of_clk_match;
+
+struct msm_clk_match {
+	struct of_clk_match *matches;
+	size_t size;
+};
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

