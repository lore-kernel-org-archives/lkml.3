Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936694AbaFIJjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:39:44 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:49785 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbaFIJij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:38:39 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 3/5] clk: Add driver for Maxim 77802 PMIC clocks
Date: Mon,  9 Jun 2014 11:37:48 +0200
Message-Id: <1402306670-17041-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX77802 PMIC has two 32.768kHz Buffered Clock Outputs with
Low Jitter Mode. This patch adds support for these two clocks.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 .../devicetree/bindings/clock/maxim,max77802.txt   |  40 ++++
 drivers/clk/Kconfig                                |   6 +
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-max77802.c                         | 253 +++++++++++++++++++++
 drivers/mfd/max77802.c                             |   3 +
 include/dt-bindings/clock/maxim,max77802.h         |  22 ++
 6 files changed, 325 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/maxim,max77802.txt
 create mode 100644 drivers/clk/clk-max77802.c
 create mode 100644 include/dt-bindings/clock/maxim,max77802.h

diff --git a/Documentation/devicetree/bindings/clock/maxim,max77802.txt b/Documentation/devicetree/bindings/clock/maxim,max77802.txt
new file mode 100644
index 0000000..1d3fb64
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/maxim,max77802.txt
@@ -0,0 +1,40 @@
+Binding for Maxim MAX77802 32k clock generator block
+
+This is a part of device tree bindings of MAX77802 multi-function device.
+More information can be found in bindings/mfd/max77802.txt file.
+
+The MAX77802 contains two 32.768khz clock outputs that can be controlled
+(gated/ungated) over I2C.
+
+Following properties should be presend in main device node of the MFD chip.
+
+Required properties:
+
+- #clock-cells: from common clock binding; shall be set to 1.
+
+Each clock is assigned an identifier and client nodes can use this identifier
+to specify the clock which they consume.
+
+Clocks are defined as preprocessor macros in dt-bindings/clock/maxim,max77802.h
+header and can be used in device tree sources.
+
+Example: Node of the MFD chip
+
+	max77802: max77802@09 {
+		compatible = "maxim,max77802";
+		interrupt-parent = <&wakeup_eint>;
+		interrupts = <26 0>;
+		reg = <0x09>;
+		#clock-cells = <1>;
+
+		/* ... */
+	};
+
+Example: Clock consumer node
+
+	foo@0 {
+		compatible = "bar,foo";
+		/* ... */
+		clock-names = "32khz_ap";
+		clocks = <&max77802 MAX77802_CLK_32K_AP>;
+	};
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 9f9c5ae..74c71a4 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -38,6 +38,12 @@ config COMMON_CLK_MAX77686
 	---help---
 	  This driver supports Maxim 77686 crystal oscillator clock. 
 
+config COMMON_CLK_MAX77802
+	tristate "Clock driver for Maxim 77802 MFD"
+	depends on MFD_MAX77802
+	---help---
+	  This driver supports Maxim 77802 crystal oscillator clock.
+
 config COMMON_CLK_SI5351
 	tristate "Clock driver for SiLabs 5351A/B/C"
 	depends on I2C
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 567f102..677692f 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_ARCH_EFM32)		+= clk-efm32gg.o
 obj-$(CONFIG_ARCH_HIGHBANK)		+= clk-highbank.o
 obj-$(CONFIG_MACH_LOONGSON1)		+= clk-ls1x.o
 obj-$(CONFIG_COMMON_CLK_MAX77686)	+= clk-max77686.o
+obj-$(CONFIG_COMMON_CLK_MAX77802)	+= clk-max77802.o
 obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
diff --git a/drivers/clk/clk-max77802.c b/drivers/clk/clk-max77802.c
new file mode 100644
index 0000000..a98fc29
--- /dev/null
+++ b/drivers/clk/clk-max77802.c
@@ -0,0 +1,253 @@
+/*
+ * clk-max77802.c - Clock driver for Maxim 77802
+ *
+ * Copyright (C) 2014 Google, Inc
+ *
+ * Copyright (C) 2012 Samsung Electornics
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This driver is based on clk-max77686.c
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/max77802.h>
+#include <linux/mfd/max77802-private.h>
+#include <linux/clk-provider.h>
+#include <linux/mutex.h>
+#include <linux/clkdev.h>
+
+#include <dt-bindings/clock/maxim,max77802.h>
+
+#define MAX77802_CLOCK_OPMODE_MASK	0x1
+#define MAX77802_CLOCK_LOW_JITTER_SHIFT 0x3
+
+struct max77802_clk {
+	struct max77802_dev *iodev;
+	u32 mask;
+	struct clk_hw hw;
+	struct clk_lookup *lookup;
+};
+
+static struct max77802_clk *to_max77802_clk(struct clk_hw *hw)
+{
+	return container_of(hw, struct max77802_clk, hw);
+}
+
+static int max77802_clk_prepare(struct clk_hw *hw)
+{
+	struct max77802_clk *max77802 = to_max77802_clk(hw);
+
+	return regmap_update_bits(max77802->iodev->regmap,
+				  MAX77802_REG_32KHZ, max77802->mask,
+				  max77802->mask);
+}
+
+static void max77802_clk_unprepare(struct clk_hw *hw)
+{
+	struct max77802_clk *max77802 = to_max77802_clk(hw);
+
+	regmap_update_bits(max77802->iodev->regmap,
+		MAX77802_REG_32KHZ, max77802->mask, ~max77802->mask);
+}
+
+static int max77802_clk_is_prepared(struct clk_hw *hw)
+{
+	struct max77802_clk *max77802 = to_max77802_clk(hw);
+	int ret;
+	u32 val;
+
+	ret = regmap_read(max77802->iodev->regmap,
+				MAX77802_REG_32KHZ, &val);
+
+	if (ret < 0)
+		return -EINVAL;
+
+	return val & max77802->mask;
+}
+
+static unsigned long max77802_recalc_rate(struct clk_hw *hw,
+					  unsigned long parent_rate)
+{
+	return 32768;
+}
+
+static struct clk_ops max77802_clk_ops = {
+	.prepare	= max77802_clk_prepare,
+	.unprepare	= max77802_clk_unprepare,
+	.is_prepared	= max77802_clk_is_prepared,
+	.recalc_rate	= max77802_recalc_rate,
+};
+
+static struct clk_init_data max77802_clks_init[MAX77802_CLKS_NUM] = {
+	[MAX77802_CLK_32K_AP] = {
+		.name = "32khz_ap",
+		.ops = &max77802_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+	[MAX77802_CLK_32K_CP] = {
+		.name = "32khz_cp",
+		.ops = &max77802_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+};
+
+static struct clk *max77802_clk_register(struct device *dev,
+					struct max77802_clk *max77802)
+{
+	struct clk *clk;
+	struct clk_hw *hw = &max77802->hw;
+
+	clk = clk_register(dev, hw);
+	if (IS_ERR(clk))
+		return clk;
+
+	max77802->lookup = kzalloc(sizeof(struct clk_lookup), GFP_KERNEL);
+	if (!max77802->lookup)
+		return ERR_PTR(-ENOMEM);
+
+	max77802->lookup->con_id = hw->init->name;
+	max77802->lookup->clk = clk;
+
+	clkdev_add(max77802->lookup);
+
+	return clk;
+}
+
+static int max77802_clk_probe(struct platform_device *pdev)
+{
+	struct max77802_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max77802_clk *max77802_clks[MAX77802_CLKS_NUM];
+	struct clk **clocks;
+	int i, ret;
+
+	clocks = devm_kzalloc(&pdev->dev, sizeof(struct clk *)
+					* MAX77802_CLKS_NUM, GFP_KERNEL);
+	if (!clocks)
+		return -ENOMEM;
+
+	for (i = 0; i < MAX77802_CLKS_NUM; i++) {
+		max77802_clks[i] = devm_kzalloc(&pdev->dev,
+					sizeof(struct max77802_clk), GFP_KERNEL);
+		if (!max77802_clks[i])
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < MAX77802_CLKS_NUM; i++) {
+		max77802_clks[i]->iodev = iodev;
+		max77802_clks[i]->mask = MAX77802_CLOCK_OPMODE_MASK << i;
+		max77802_clks[i]->hw.init = &max77802_clks_init[i];
+
+		clocks[i] = max77802_clk_register(&pdev->dev, max77802_clks[i]);
+		if (IS_ERR(clocks[i])) {
+			ret = PTR_ERR(clocks[i]);
+			dev_err(&pdev->dev, "failed to register %s\n",
+				max77802_clks[i]->hw.init->name);
+			goto err_clocks;
+		}
+	}
+
+	/* Enable low-jitter mode on the 32khz clocks. */
+	ret = regmap_update_bits(iodev->regmap, MAX77802_REG_32KHZ,
+				 1 << MAX77802_CLOCK_LOW_JITTER_SHIFT,
+				 1 << MAX77802_CLOCK_LOW_JITTER_SHIFT);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to enable low-jitter mode\n");
+		goto err_clocks;
+	}
+
+	platform_set_drvdata(pdev, clocks);
+
+	if (iodev->dev->of_node) {
+		struct clk_onecell_data *of_data;
+
+		of_data = devm_kzalloc(&pdev->dev,
+					sizeof(*of_data), GFP_KERNEL);
+		if (!of_data) {
+			ret = -ENOMEM;
+			goto err_clocks;
+		}
+
+		of_data->clks = clocks;
+		of_data->clk_num = MAX77802_CLKS_NUM;
+		ret = of_clk_add_provider(iodev->dev->of_node,
+					  of_clk_src_onecell_get, of_data);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to register OF clock provider\n");
+			goto err_clocks;
+		}
+	}
+
+	return 0;
+
+err_clocks:
+	for (--i; i >= 0; --i) {
+		clkdev_drop(max77802_clks[i]->lookup);
+		clk_unregister(max77802_clks[i]->hw.clk);
+	}
+
+	return ret;
+}
+
+static int max77802_clk_remove(struct platform_device *pdev)
+{
+	struct max77802_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct clk **clocks = platform_get_drvdata(pdev);
+	int i;
+
+	if (iodev->dev->of_node)
+		of_clk_del_provider(iodev->dev->of_node);
+
+	for (i = 0; i < MAX77802_CLKS_NUM; i++) {
+		struct clk_hw *hw = __clk_get_hw(clocks[i]);
+		struct max77802_clk *max77802 = to_max77802_clk(hw);
+
+		clkdev_drop(max77802->lookup);
+		clk_unregister(clocks[i]);
+	}
+	return 0;
+}
+
+static const struct platform_device_id max77802_clk_id[] = {
+	{ "max77802-clk", 0},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, max77802_clk_id);
+
+static struct platform_driver max77802_clk_driver = {
+	.driver = {
+		.name  = "max77802-clk",
+		.owner = THIS_MODULE,
+	},
+	.probe = max77802_clk_probe,
+	.remove = max77802_clk_remove,
+	.id_table = max77802_clk_id,
+};
+
+static int __init max77802_clk_init(void)
+{
+	return platform_driver_register(&max77802_clk_driver);
+}
+subsys_initcall(max77802_clk_init);
+
+static void __init max77802_clk_cleanup(void)
+{
+	platform_driver_unregister(&max77802_clk_driver);
+}
+module_exit(max77802_clk_cleanup);
+
+MODULE_DESCRIPTION("MAXIM 77802 Clock Driver");
+MODULE_AUTHOR("Javier Martinez Canillas <javier.martinez@collabora.co.uk>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/max77802.c b/drivers/mfd/max77802.c
index 59696dd..33e8023 100644
--- a/drivers/mfd/max77802.c
+++ b/drivers/mfd/max77802.c
@@ -35,6 +35,9 @@
 
 static const struct mfd_cell max77802_devs[] = {
 	{ .name = "max77802-pmic", },
+#if defined(CONFIG_COMMON_CLK_MAX77802)
+	{ .name = "max77802-clk", },
+#endif
 };
 
 static bool max77802_pmic_is_accessible_reg(struct device *dev,
diff --git a/include/dt-bindings/clock/maxim,max77802.h b/include/dt-bindings/clock/maxim,max77802.h
new file mode 100644
index 0000000..997312e
--- /dev/null
+++ b/include/dt-bindings/clock/maxim,max77802.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Device Tree binding constants clocks for the Maxim 77802 PMIC.
+ */
+
+#ifndef _DT_BINDINGS_CLOCK_MAXIM_MAX77802_CLOCK_H
+#define _DT_BINDINGS_CLOCK_MAXIM_MAX77802_CLOCK_H
+
+/* Fixed rate clocks. */
+
+#define MAX77802_CLK_32K_AP		0
+#define MAX77802_CLK_32K_CP		1
+
+/* Total number of clocks. */
+#define MAX77802_CLKS_NUM		(MAX77802_CLK_32K_CP + 1)
+
+#endif /* _DT_BINDINGS_CLOCK_MAXIM_MAX77802_CLOCK_H */
-- 
2.0.0.rc2

