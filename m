Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3LWQ00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:26:26 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39623 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab3LWQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:09 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [RFC 13/18] clk: versatile: Use regmap instead of custom interface
Date: Mon, 23 Dec 2013 16:23:45 +0000
Message-Id: <1387815830-8794-14-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:07.0103 (UTC) FILETIME=[670BE4F0:01CEFFFB]
X-MC-Unique: 113122316240710501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGQWAi026625

This patch makes the Versatile Express clock generators
driver use regmap interface, instead of custom vexpress
config one. This required it to become a standard platform
driver (although registered very early, at core_initcall
level), which better fits the reality (dependencies on
other devices, mainly config infrastructure bridges).

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Cc: Mike Turquette <mturquette@linaro.org> 
---
 drivers/clk/versatile/Kconfig            |  2 +-
 drivers/clk/versatile/clk-vexpress-osc.c | 70 ++++++++++++++++++--------------
 include/linux/vexpress.h                 |  3 --
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/drivers/clk/versatile/Kconfig b/drivers/clk/versatile/Kconfig
index 1530c93..3c694f0 100644
--- a/drivers/clk/versatile/Kconfig
+++ b/drivers/clk/versatile/Kconfig
@@ -18,7 +18,7 @@ config CLK_SP810
 config CLK_VEXPRESS_OSC
 	bool "Clock driver for Versatile Express OSC clock generators"
 	depends on COMMON_CLK_VERSATILE
-	depends on VEXPRESS_CONFIG
+	depends on REGMAP
 	default y if ARCH_VEXPRESS
 	---help---
 	  Simple regmap-based driver driving clock generators on Versatile
diff --git a/drivers/clk/versatile/clk-vexpress-osc.c b/drivers/clk/versatile/clk-vexpress-osc.c
index 2dc8b41..e668cb2 100644
--- a/drivers/clk/versatile/clk-vexpress-osc.c
+++ b/drivers/clk/versatile/clk-vexpress-osc.c
@@ -11,18 +11,17 @@
  * Copyright (C) 2012 ARM Limited
  */
 
-#define pr_fmt(fmt) "vexpress-osc: " fmt
 
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
-#include <linux/vexpress.h>
 
 struct vexpress_osc {
-	struct vexpress_config_func *func;
+	struct regmap *reg;
 	struct clk_hw hw;
 	unsigned long rate_min;
 	unsigned long rate_max;
@@ -36,7 +35,7 @@ static unsigned long vexpress_osc_recalc_rate(struct clk_hw *hw,
 	struct vexpress_osc *osc = to_vexpress_osc(hw);
 	u32 rate;
 
-	vexpress_config_read(osc->func, 0, &rate);
+	regmap_read(osc->reg, 0, &rate);
 
 	return rate;
 }
@@ -60,7 +59,7 @@ static int vexpress_osc_set_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct vexpress_osc *osc = to_vexpress_osc(hw);
 
-	return vexpress_config_write(osc->func, 0, rate);
+	return regmap_write(osc->reg, 0, rate);
 }
 
 static struct clk_ops vexpress_osc_ops = {
@@ -78,8 +77,8 @@ struct clk * __init vexpress_osc_setup(struct device *dev)
 	if (!osc)
 		return NULL;
 
-	osc->func = vexpress_config_func_get_by_dev(dev);
-	if (!osc->func) {
+	osc->reg = dev_get_regmap(dev, NULL);
+	if (!osc->reg) {
 		kfree(osc);
 		return NULL;
 	}
@@ -93,33 +92,31 @@ struct clk * __init vexpress_osc_setup(struct device *dev)
 	return clk_register(NULL, &osc->hw);
 }
 
-void __init vexpress_osc_of_setup(struct device_node *node)
+static int vexpress_osc_probe(struct platform_device *pdev)
 {
 	struct clk_init_data init;
 	struct vexpress_osc *osc;
 	struct clk *clk;
 	u32 range[2];
 
-	osc = kzalloc(sizeof(*osc), GFP_KERNEL);
+	osc = devm_kzalloc(&pdev->dev, sizeof(*osc), GFP_KERNEL);
 	if (!osc)
-		goto error;
+		return -ENOMEM;
 
-	osc->func = vexpress_config_func_get_by_node(node);
-	if (!osc->func) {
-		pr_err("Failed to obtain config func for node '%s'!\n",
-				node->full_name);
-		goto error;
-	}
+	osc->reg = dev_get_regmap(&pdev->dev, NULL);
+	if (!osc->reg)
+		return -ENXIO;
 
-	if (of_property_read_u32_array(node, "freq-range", range,
+	if (of_property_read_u32_array(pdev->dev.of_node, "freq-range", range,
 			ARRAY_SIZE(range)) == 0) {
 		osc->rate_min = range[0];
 		osc->rate_max = range[1];
 	}
 
-	of_property_read_string(node, "clock-output-names", &init.name);
+	of_property_read_string(pdev->dev.of_node, "clock-output-names",
+			&init.name);
 	if (!init.name)
-		init.name = node->full_name;
+		init.name = dev_name(&pdev->dev);
 
 	init.ops = &vexpress_osc_ops;
 	init.flags = CLK_IS_ROOT;
@@ -128,20 +125,31 @@ void __init vexpress_osc_of_setup(struct device_node *node)
 	osc->hw.init = &init;
 
 	clk = clk_register(NULL, &osc->hw);
-	if (IS_ERR(clk)) {
-		pr_err("Failed to register clock '%s'!\n", init.name);
-		goto error;
-	}
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get, clk);
+
+	dev_dbg(&pdev->dev, "Registered clock '%s'\n", init.name);
 
-	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	return 0;
+}
 
-	pr_debug("Registered clock '%s'\n", init.name);
+static struct of_device_id vexpress_osc_of_match[] = {
+	{ .compatible = "arm,vexpress-osc", },
+	{}
+};
 
-	return;
+static struct platform_driver vexpress_osc_driver = {
+	.driver	= {
+		.name = "vexpress-osc",
+		.of_match_table = vexpress_osc_of_match,
+	},
+	.probe = vexpress_osc_probe,
+};
 
-error:
-	if (osc->func)
-		vexpress_config_func_put(osc->func);
-	kfree(osc);
+static int __init vexpress_osc_init(void)
+{
+	return platform_driver_register(&vexpress_osc_driver);
 }
-CLK_OF_DECLARE(vexpress_soc, "arm,vexpress-osc", vexpress_osc_of_setup);
+core_initcall(vexpress_osc_init);
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index 617c01b..45037f1 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -119,9 +119,6 @@ void vexpress_sysreg_of_early_init(void);
 /* Clocks */
 
 struct clk *vexpress_osc_setup(struct device *dev);
-void vexpress_osc_of_setup(struct device_node *node);
-
 void vexpress_clk_init(void __iomem *sp810_base);
-void vexpress_clk_of_init(void);
 
 #endif
-- 
1.8.3.2


