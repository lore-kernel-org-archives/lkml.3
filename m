Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3KFMTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:19:38 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17206 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab3KFMTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:19:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 06 Nov 2013 04:18:30 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <mturquette@linaro.org>,
        <dwmw2@infradead.org>, <anton@enomsg.org>
CC: <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 3/5] clk: as3722: add clock driver for ams AS3722
Date: Wed, 6 Nov 2013 17:48:21 +0530
Message-ID: <1383740303-10956-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
References: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device ams AS3722 supports one clock 32KHz output. Add clock driver
to control the clock through clock framework.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- None.
 drivers/clk/Kconfig      |    8 ++
 drivers/clk/Makefile     |    1 +
 drivers/clk/clk-as3722.c |  161 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 170 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-as3722.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 5c51115..03257bf 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -78,6 +78,14 @@ config CLK_TWL6040
 	  McPDM. McPDM module is using the external bit clock on the McPDM bus
 	  as functional clock.
 
+config COMMON_CLK_AS3722
+	tristate "ams AS3722 clock32K driver"
+	depends on MFD_AS3722
+	help
+	---help---
+	  Supports the clocking subsystem of the ams AS3722 PMIC from ams.
+	  This device supports one 32KHz clock.
+
 config COMMON_CLK_AXI_CLKGEN
 	tristate "AXI clkgen driver"
 	depends on ARCH_ZYNQ || MICROBLAZE
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index fe3121b..b94624d 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+= keystone/
 obj-$(CONFIG_X86)		+= x86/
 
 # Chip specific
+obj-$(CONFIG_COMMON_CLK_AS3722) += clk-as3722.o
 obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN) += clk-axi-clkgen.o
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
 obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
diff --git a/drivers/clk/clk-as3722.c b/drivers/clk/clk-as3722.c
new file mode 100644
index 0000000..0f786c3
--- /dev/null
+++ b/drivers/clk/clk-as3722.c
@@ -0,0 +1,161 @@
+/*
+ * Clock driver for ams AS3722 device.
+ *
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/mfd/as3722.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+struct as3722_clks {
+	struct device *dev;
+	struct as3722 *as3722;
+	struct clk_hw hw;
+	struct clk *clk;
+	struct clk_onecell_data clk_data;
+};
+
+static inline struct as3722_clks *to_as3722_clks(struct clk_hw *hw)
+{
+	return container_of(hw, struct as3722_clks, hw);
+}
+
+static unsigned long as3722_clks_recalc_rate(struct clk_hw *hw,
+	unsigned long parent_rate)
+{
+	return 32768;
+}
+
+static int as3722_clks_prepare(struct clk_hw *hw)
+{
+	struct as3722_clks *as3722_clks = to_as3722_clks(hw);
+	int ret;
+
+	ret = as3722_update_bits(as3722_clks->as3722, AS3722_RTC_CONTROL_REG,
+			AS3722_RTC_CLK32K_OUT_EN, AS3722_RTC_CLK32K_OUT_EN);
+	if (ret < 0)
+		dev_err(as3722_clks->dev, "RTC_CONTROL_REG update failed, %d\n",
+			ret);
+
+	return ret;
+}
+
+static void as3722_clks_unprepare(struct clk_hw *hw)
+{
+	struct as3722_clks *as3722_clks = to_as3722_clks(hw);
+	int ret;
+
+	ret = as3722_update_bits(as3722_clks->as3722, AS3722_RTC_CONTROL_REG,
+			AS3722_RTC_CLK32K_OUT_EN, 0);
+	if (ret < 0)
+		dev_err(as3722_clks->dev, "RTC_CONTROL_REG update failed, %d\n",
+			ret);
+}
+
+static int as3722_clks_is_prepared(struct clk_hw *hw)
+{
+	struct as3722_clks *as3722_clks = to_as3722_clks(hw);
+	int ret;
+	u32 val;
+
+	ret = as3722_read(as3722_clks->as3722, AS3722_RTC_CONTROL_REG, &val);
+	if (ret < 0) {
+		dev_err(as3722_clks->dev, "RTC_CONTROL_REG read failed, %d\n",
+			ret);
+		return ret;
+	}
+
+	return !!(val & AS3722_RTC_CLK32K_OUT_EN);
+}
+
+static struct clk_ops as3722_clks_ops = {
+	.prepare	= as3722_clks_prepare,
+	.unprepare	= as3722_clks_unprepare,
+	.is_prepared	= as3722_clks_is_prepared,
+	.recalc_rate	= as3722_clks_recalc_rate,
+};
+
+static struct clk_init_data as3722_clks_hw_init = {
+	.name = "clk32k",
+	.ops = &as3722_clks_ops,
+	.flags = CLK_IS_ROOT | CLK_IGNORE_UNUSED,
+};
+
+static int as3722_clks_probe(struct platform_device *pdev)
+{
+	struct as3722_clks *as3722_clks;
+	struct clk *clk;
+	int ret;
+
+	as3722_clks = devm_kzalloc(&pdev->dev, sizeof(*as3722_clks),
+				GFP_KERNEL);
+	if (!as3722_clks)
+		return -ENOMEM;
+
+	as3722_clks->clk_data.clks = devm_kzalloc(&pdev->dev,
+			sizeof(*as3722_clks->clk_data.clks), GFP_KERNEL);
+	if (!as3722_clks->clk_data.clks)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, as3722_clks);
+
+	as3722_clks->as3722 = dev_get_drvdata(pdev->dev.parent);
+	as3722_clks->dev = &pdev->dev;
+	as3722_clks->hw.init = &as3722_clks_hw_init;
+
+	clk = devm_clk_register(&pdev->dev, &as3722_clks->hw);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_err(&pdev->dev, "Fail to register clock %s, %d\n",
+			as3722_clks_hw_init.name, ret);
+		return ret;
+	}
+	as3722_clks->clk = clk;
+	as3722_clks->clk_data.clks[0] = clk;
+	as3722_clks->clk_data.clk_num = 1;
+	ret = of_clk_add_provider(pdev->dev.parent->of_node,
+			of_clk_src_simple_get, &as3722_clks->clk_data);
+	if (ret < 0)
+		dev_err(&pdev->dev, "Fail to add clock driver, %d\n", ret);
+	return ret;
+}
+
+static int as3722_clks_remove(struct platform_device *pdev)
+{
+	of_clk_del_provider(pdev->dev.parent->of_node);
+	return 0;
+}
+
+static struct platform_driver as3722_clks_driver = {
+	.driver = {
+		.name = "as3722-clk",
+		.owner = THIS_MODULE,
+	},
+	.probe = as3722_clks_probe,
+	.remove = as3722_clks_remove,
+};
+
+module_platform_driver(as3722_clks_driver);
+
+MODULE_DESCRIPTION("Clock driver for ams AS3722 PMIC Device");
+MODULE_ALIAS("platform:as3722-clk");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1.1

