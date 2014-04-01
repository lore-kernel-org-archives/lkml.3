Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaDAIgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:36:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51382 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbaDAIgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:36:18 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] regulator: arizona-ldo1: Move setup processing from arizona-core
Date: Tue,  1 Apr 2014 09:27:21 +0100
Message-Id: <1396340845-24060-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1396340845-24060-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1396340845-24060-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more idiomatic to process things relating to the regulator in its
driver. This patch moves both processing of device tree relating to the
regulator and checking if the regulator is external from arizona-core
into the regulator driver.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c       |   12 +++---------
 drivers/regulator/arizona-ldo1.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 8ad4373..0096261 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -539,7 +539,6 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 	int ret, i;
 
 	arizona_of_get_named_gpio(arizona, "wlf,reset", true, &pdata->reset);
-	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
 
 	ret = of_property_read_u32_array(arizona->dev->of_node,
 					 "wlf,gpio-defaults",
@@ -671,6 +670,9 @@ int arizona_dev_init(struct arizona *arizona)
 		return -EINVAL;
 	}
 
+	/* Mark DCVDD as external, LDO1 driver will clear if internal */
+	arizona->external_dcvdd = true;
+
 	ret = mfd_add_devices(arizona->dev, -1, early_devs,
 			      ARRAY_SIZE(early_devs), NULL, 0, NULL);
 	if (ret != 0) {
@@ -870,14 +872,6 @@ int arizona_dev_init(struct arizona *arizona)
 			     arizona->pdata.gpio_defaults[i]);
 	}
 
-	/*
-	 * LDO1 can only be used to supply DCVDD so if it has no
-	 * consumers then DCVDD is supplied externally.
-	 */
-	if (arizona->pdata.ldo1 &&
-	    arizona->pdata.ldo1->num_consumer_supplies == 0)
-		arizona->external_dcvdd = true;
-
 	pm_runtime_set_autosuspend_delay(arizona->dev, 100);
 	pm_runtime_use_autosuspend(arizona->dev);
 	pm_runtime_enable(arizona->dev);
diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index b1033d3..211af83 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -178,6 +178,22 @@ static const struct regulator_init_data arizona_ldo1_default = {
 	.num_consumer_supplies = 1,
 };
 
+#ifdef CONFIG_OF
+static int arizona_ldo1_of_get_pdata(struct arizona *arizona)
+{
+	struct arizona_pdata *pdata = &arizona->pdata;
+
+	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
+
+	return 0;
+}
+#else
+static inline int arizona_ldo1_of_get_pdata(struct arizona *arizona)
+{
+	return 0;
+}
+#endif
+
 static int arizona_ldo1_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
@@ -186,6 +202,8 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	struct arizona_ldo1 *ldo1;
 	int ret;
 
+	arizona->external_dcvdd = false;
+
 	ldo1 = devm_kzalloc(&pdev->dev, sizeof(*ldo1), GFP_KERNEL);
 	if (!ldo1)
 		return -ENOMEM;
@@ -216,6 +234,13 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	config.dev = arizona->dev;
 	config.driver_data = ldo1;
 	config.regmap = arizona->regmap;
+
+	if (!dev_get_platdata(arizona->dev)) {
+		ret = arizona_ldo1_of_get_pdata(arizona);
+		if (ret < 0)
+			return ret;
+	}
+
 	config.ena_gpio = arizona->pdata.ldoena;
 
 	if (arizona->pdata.ldo1)
@@ -223,6 +248,13 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	else
 		config.init_data = &ldo1->init_data;
 
+	/*
+	 * LDO1 can only be used to supply DCVDD so if it has no
+	 * consumers then DCVDD is supplied externally.
+	 */
+	if (config.init_data->num_consumer_supplies == 0)
+		arizona->external_dcvdd = true;
+
 	ldo1->regulator = devm_regulator_register(&pdev->dev, desc, &config);
 	if (IS_ERR(ldo1->regulator)) {
 		ret = PTR_ERR(ldo1->regulator);
-- 
1.7.2.5

