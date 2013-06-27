Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3F0OEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:04:33 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:62271 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3F0OEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:04:32 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, mturquette@linaro.org,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] clk: add MOXA ART SoCs clock driver
Date: Thu, 27 Jun 2013 16:03:54 +0200
Message-Id: <1372341834-6557-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MOXA ART SoCs clock driver support.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20130619

 drivers/clk/Makefile     |   1 +
 drivers/clk/clk-moxart.c | 141 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+)
 create mode 100644 drivers/clk/clk-moxart.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index f41e3e3..92e4532 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
 obj-$(CONFIG_ARCH_ZYNQ)		+= zynq/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
+obj-$(CONFIG_ARCH_MOXART)	+= clk-moxart.o
 
 obj-$(CONFIG_X86)		+= x86/
 
diff --git a/drivers/clk/clk-moxart.c b/drivers/clk/clk-moxart.c
new file mode 100644
index 0000000..893a63b
--- /dev/null
+++ b/drivers/clk/clk-moxart.c
@@ -0,0 +1,141 @@
+/*
+ * MOXA ART SoCs clock driver.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/clkdev.h>
+
+static DEFINE_SPINLOCK(_lock);
+
+struct clk_device {
+	struct clk_hw	hw;
+	void __iomem	*reg_pmu;
+	spinlock_t		*lock;
+};
+
+static unsigned long moxart_recalc_rate(struct clk_hw *c_hw,
+	unsigned long parent_rate)
+{
+	unsigned int mul, val, div;
+	unsigned long ret;
+	struct clk_device *dev_clk = container_of(c_hw, struct clk_device, hw);
+
+	mul = (readl(dev_clk->reg_pmu + 0x30) >> 3) & 0x1ff;
+	val = (readl(dev_clk->reg_pmu + 0x0c) >> 4) & 0x7;
+
+	switch (val) {
+	case 0:
+		div = 2;
+		break;
+	case 1:
+		div = 3;
+		break;
+	case 2:
+		div = 4;
+		break;
+	case 3:
+		div = 6;
+		break;
+	case 4:
+		div = 8;
+		break;
+	default:
+		div = 2;
+		break;
+	}
+
+	ret = (mul * 1200000 / div);
+
+	/* UC-7112-LX: ret=48000000 mul=80 div=2 val=0 */
+	pr_debug("%s: ret=%lu mul=%d div=%d val=%d\n",
+		__func__, ret, mul, div, val);
+	return ret;
+}
+
+static const struct clk_ops moxart_clk_ops = {
+	.recalc_rate = moxart_recalc_rate,
+};
+
+static const struct of_device_id moxart_pmu_match[] = {
+	{ .compatible = "moxa,moxart-pmu" },
+	{ },
+};
+
+static const struct of_device_id moxart_sysclk_match[] = {
+	{ .compatible = "moxa,moxart-sysclk" },
+	{ }
+};
+
+void __init moxart_of_clk_init(void)
+{
+	struct device_node *node, *clk_node;
+	struct clk *clk;
+	struct clk_device *dev_clk;
+	struct clk_init_data init;
+	int err;
+	const char *clk_name;
+
+	dev_clk = kzalloc(sizeof(*dev_clk), GFP_KERNEL);
+	if (WARN_ON(!dev_clk))
+		return;
+
+	dev_clk->lock = &_lock;
+
+	node = of_find_matching_node(NULL, moxart_pmu_match);
+	if (!node) {
+		pr_err("%s: can't find PMU DT node\n", __func__);
+		return;
+	}
+
+	dev_clk->reg_pmu = of_iomap(node, 0);
+	if (IS_ERR(dev_clk->reg_pmu)) {
+		pr_err("%s: of_iomap failed\n", __func__);
+		return;
+	}
+
+	clk_node = of_find_matching_node(NULL, moxart_sysclk_match);
+	if (!clk_node) {
+		pr_err("%s: can't find sys_clk DT node\n", __func__);
+		return;
+	}
+
+	clk_name = clk_node->name;
+
+	of_property_read_string(clk_node, "clock-output-names",
+		&clk_name);
+
+	init.name = clk_name;
+	init.ops = &moxart_clk_ops;
+	init.flags = CLK_IS_ROOT;
+	init.num_parents = 0;
+
+	dev_clk->hw.init = &init;
+
+	clk = clk_register(NULL, &dev_clk->hw);
+
+	if (WARN_ON(IS_ERR(clk))) {
+		kfree(dev_clk);
+		return;
+	}
+
+	clk_register_clkdev(clk, NULL, clk_name);
+
+	err = of_clk_add_provider(clk_node, of_clk_src_simple_get, clk);
+
+	pr_info("%s: %s finished\n", node->full_name, __func__);
+}
-- 
1.8.2.1

