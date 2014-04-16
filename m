Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaDPJON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:14:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58340 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbaDPJJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:09:47 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH 2/6] regulator: arizona-ldo1: Move setup processing from arizona-core
Date: Wed, 16 Apr 2014 10:01:38 +0100
Message-Id: <1397638902-7576-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 drivers/regulator/arizona-ldo1.c |   27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 37b5e14..07e6e27 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -533,7 +533,6 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 	int ret, i;
 
 	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
-	pdata->ldoena = arizona_of_get_named_gpio(arizona, "wlf,ldoena", true);
 
 	ret = of_property_read_u32_array(arizona->dev->of_node,
 					 "wlf,gpio-defaults",
@@ -665,6 +664,9 @@ int arizona_dev_init(struct arizona *arizona)
 		return -EINVAL;
 	}
 
+	/* Mark DCVDD as external, LDO1 driver will clear if internal */
+	arizona->external_dcvdd = true;
+
 	ret = mfd_add_devices(arizona->dev, -1, early_devs,
 			      ARRAY_SIZE(early_devs), NULL, 0, NULL);
 	if (ret != 0) {
@@ -864,14 +866,6 @@ int arizona_dev_init(struct arizona *arizona)
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
index b1033d3..2248733 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -178,6 +178,15 @@ static const struct regulator_init_data arizona_ldo1_default = {
 	.num_consumer_supplies = 1,
 };
 
+static int arizona_ldo1_of_get_pdata(struct arizona *arizona)
+{
+	struct arizona_pdata *pdata = &arizona->pdata;
+
+	pdata->ldoena = arizona_of_get_named_gpio(arizona, "wlf,ldoena", true);
+
+	return 0;
+}
+
 static int arizona_ldo1_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
@@ -186,6 +195,8 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	struct arizona_ldo1 *ldo1;
 	int ret;
 
+	arizona->external_dcvdd = false;
+
 	ldo1 = devm_kzalloc(&pdev->dev, sizeof(*ldo1), GFP_KERNEL);
 	if (!ldo1)
 		return -ENOMEM;
@@ -216,6 +227,15 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	config.dev = arizona->dev;
 	config.driver_data = ldo1;
 	config.regmap = arizona->regmap;
+
+	if (IS_ENABLED(CONFIG_OF)) {
+		if (!dev_get_platdata(arizona->dev)) {
+			ret = arizona_ldo1_of_get_pdata(arizona);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
 	config.ena_gpio = arizona->pdata.ldoena;
 
 	if (arizona->pdata.ldo1)
@@ -223,6 +243,13 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
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

