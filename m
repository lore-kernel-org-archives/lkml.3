Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918AbaFZSQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:16:41 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33328 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778AbaFZSQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:16:38 -0400
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
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v5 06/14] clk: max77686: Convert to the generic max clock driver
Date: Thu, 26 Jun 2014 20:15:38 +0200
Message-Id: <1403806546-31122-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clocks drivers for Maxim PMIC are very similar so they can
be converted to use the generic Maxim clock driver.

Also, while being there use module_platform_driver() helper
macro to eliminate more boilerplate code.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---

Changes since v4: None

Changes since v3: None

 drivers/clk/Kconfig        |   1 +
 drivers/clk/clk-max-gen.c  |   5 +-
 drivers/clk/clk-max77686.c | 176 +++------------------------------------------
 3 files changed, 13 insertions(+), 169 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 73f78e8..3fd4270 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -38,6 +38,7 @@ config COMMON_CLK_MAX_GEN
 config COMMON_CLK_MAX77686
 	tristate "Clock driver for Maxim 77686 MFD"
 	depends on MFD_MAX77686
+	select COMMON_CLK_MAX_GEN
 	---help---
 	  This driver supports Maxim 77686 crystal oscillator clock. 
 
diff --git a/drivers/clk/clk-max-gen.c b/drivers/clk/clk-max-gen.c
index 3e9fa7e..3b0d2c1 100644
--- a/drivers/clk/clk-max-gen.c
+++ b/drivers/clk/clk-max-gen.c
@@ -75,7 +75,10 @@ static int max_gen_clk_is_prepared(struct clk_hw *hw)
 static unsigned long max_gen_recalc_rate(struct clk_hw *hw,
 					 unsigned long parent_rate)
 {
-	return 32768;
+	if (__clk_is_enabled(hw->clk))
+		return 32768;
+	else
+		return 0;
 }
 
 struct clk_ops max_gen_clk_ops = {
diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
index 185b611..ed0beb4 100644
--- a/drivers/clk/clk-max77686.c
+++ b/drivers/clk/clk-max77686.c
@@ -31,187 +31,37 @@
 #include <linux/clkdev.h>
 
 #include <dt-bindings/clock/maxim,max77686.h>
-
-struct max77686_clk {
-	struct max77686_dev *iodev;
-	u32 mask;
-	struct clk_hw hw;
-	struct clk_lookup *lookup;
-};
-
-static struct max77686_clk *to_max77686_clk(struct clk_hw *hw)
-{
-	return container_of(hw, struct max77686_clk, hw);
-}
-
-static int max77686_clk_prepare(struct clk_hw *hw)
-{
-	struct max77686_clk *max77686 = to_max77686_clk(hw);
-
-	return regmap_update_bits(max77686->iodev->regmap,
-				  MAX77686_REG_32KHZ, max77686->mask,
-				  max77686->mask);
-}
-
-static void max77686_clk_unprepare(struct clk_hw *hw)
-{
-	struct max77686_clk *max77686 = to_max77686_clk(hw);
-
-	regmap_update_bits(max77686->iodev->regmap,
-		MAX77686_REG_32KHZ, max77686->mask, ~max77686->mask);
-}
-
-static int max77686_clk_is_prepared(struct clk_hw *hw)
-{
-	struct max77686_clk *max77686 = to_max77686_clk(hw);
-	int ret;
-	u32 val;
-
-	ret = regmap_read(max77686->iodev->regmap,
-				MAX77686_REG_32KHZ, &val);
-
-	if (ret < 0)
-		return -EINVAL;
-
-	return val & max77686->mask;
-}
-
-static unsigned long max77686_recalc_rate(struct clk_hw *hw,
-					  unsigned long parent_rate)
-{
-	return 32768;
-}
-
-static struct clk_ops max77686_clk_ops = {
-	.prepare	= max77686_clk_prepare,
-	.unprepare	= max77686_clk_unprepare,
-	.is_prepared	= max77686_clk_is_prepared,
-	.recalc_rate	= max77686_recalc_rate,
-};
+#include "clk-max-gen.h"
 
 static struct clk_init_data max77686_clks_init[MAX77686_CLKS_NUM] = {
 	[MAX77686_CLK_AP] = {
 		.name = "32khz_ap",
-		.ops = &max77686_clk_ops,
+		.ops = &max_gen_clk_ops,
 		.flags = CLK_IS_ROOT,
 	},
 	[MAX77686_CLK_CP] = {
 		.name = "32khz_cp",
-		.ops = &max77686_clk_ops,
+		.ops = &max_gen_clk_ops,
 		.flags = CLK_IS_ROOT,
 	},
 	[MAX77686_CLK_PMIC] = {
 		.name = "32khz_pmic",
-		.ops = &max77686_clk_ops,
+		.ops = &max_gen_clk_ops,
 		.flags = CLK_IS_ROOT,
 	},
 };
 
-static struct clk *max77686_clk_register(struct device *dev,
-				struct max77686_clk *max77686)
-{
-	struct clk *clk;
-	struct clk_hw *hw = &max77686->hw;
-
-	clk = clk_register(dev, hw);
-	if (IS_ERR(clk))
-		return clk;
-
-	max77686->lookup = kzalloc(sizeof(struct clk_lookup), GFP_KERNEL);
-	if (!max77686->lookup)
-		return ERR_PTR(-ENOMEM);
-
-	max77686->lookup->con_id = hw->init->name;
-	max77686->lookup->clk = clk;
-
-	clkdev_add(max77686->lookup);
-
-	return clk;
-}
-
 static int max77686_clk_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max77686_clk *max77686_clks[MAX77686_CLKS_NUM];
-	struct clk **clocks;
-	int i, ret;
-
-	clocks = devm_kzalloc(&pdev->dev, sizeof(struct clk *)
-					* MAX77686_CLKS_NUM, GFP_KERNEL);
-	if (!clocks)
-		return -ENOMEM;
-
-	for (i = 0; i < MAX77686_CLKS_NUM; i++) {
-		max77686_clks[i] = devm_kzalloc(&pdev->dev,
-					sizeof(struct max77686_clk), GFP_KERNEL);
-		if (!max77686_clks[i])
-			return -ENOMEM;
-	}
-
-	for (i = 0; i < MAX77686_CLKS_NUM; i++) {
-		max77686_clks[i]->iodev = iodev;
-		max77686_clks[i]->mask = 1 << i;
-		max77686_clks[i]->hw.init = &max77686_clks_init[i];
-
-		clocks[i] = max77686_clk_register(&pdev->dev, max77686_clks[i]);
-		if (IS_ERR(clocks[i])) {
-			ret = PTR_ERR(clocks[i]);
-			dev_err(&pdev->dev, "failed to register %s\n",
-				max77686_clks[i]->hw.init->name);
-			goto err_clocks;
-		}
-	}
-
-	platform_set_drvdata(pdev, clocks);
-
-	if (iodev->dev->of_node) {
-		struct clk_onecell_data *of_data;
-
-		of_data = devm_kzalloc(&pdev->dev,
-					sizeof(*of_data), GFP_KERNEL);
-		if (!of_data) {
-			ret = -ENOMEM;
-			goto err_clocks;
-		}
 
-		of_data->clks = clocks;
-		of_data->clk_num = MAX77686_CLKS_NUM;
-		ret = of_clk_add_provider(iodev->dev->of_node,
-					of_clk_src_onecell_get, of_data);
-		if (ret) {
-			dev_err(&pdev->dev, "failed to register OF clock provider\n");
-			goto err_clocks;
-		}
-	}
-
-	return 0;
-
-err_clocks:
-	for (--i; i >= 0; --i) {
-		clkdev_drop(max77686_clks[i]->lookup);
-		clk_unregister(max77686_clks[i]->hw.clk);
-	}
-
-	return ret;
+	return max_gen_clk_probe(pdev, iodev->regmap, MAX77686_REG_32KHZ,
+				 max77686_clks_init, MAX77686_CLKS_NUM);
 }
 
 static int max77686_clk_remove(struct platform_device *pdev)
 {
-	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct clk **clocks = platform_get_drvdata(pdev);
-	int i;
-
-	if (iodev->dev->of_node)
-		of_clk_del_provider(iodev->dev->of_node);
-
-	for (i = 0; i < MAX77686_CLKS_NUM; i++) {
-		struct clk_hw *hw = __clk_get_hw(clocks[i]);
-		struct max77686_clk *max77686 = to_max77686_clk(hw);
-
-		clkdev_drop(max77686->lookup);
-		clk_unregister(clocks[i]);
-	}
-	return 0;
+	return max_gen_clk_remove(pdev, MAX77686_CLKS_NUM);
 }
 
 static const struct platform_device_id max77686_clk_id[] = {
@@ -230,17 +80,7 @@ static struct platform_driver max77686_clk_driver = {
 	.id_table = max77686_clk_id,
 };
 
-static int __init max77686_clk_init(void)
-{
-	return platform_driver_register(&max77686_clk_driver);
-}
-subsys_initcall(max77686_clk_init);
-
-static void __init max77686_clk_cleanup(void)
-{
-	platform_driver_unregister(&max77686_clk_driver);
-}
-module_exit(max77686_clk_cleanup);
+module_platform_driver(max77686_clk_driver);
 
 MODULE_DESCRIPTION("MAXIM 77686 Clock Driver");
 MODULE_AUTHOR("Jonghwa Lee <jonghwa3.lee@samsung.com>");
-- 
2.0.0.rc2

