Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaCRK56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:57:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42357 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbaCRK55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:57:57 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] regulator: arizona-ldo1: Move setup processing from arizona-core
Date: Tue, 18 Mar 2014 10:49:12 +0000
Message-Id: <1395139757-6907-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more idiomatic to process things relating to the regulator in its
driver. This patch moves both processing of device tree relating to the
regulator and checking if the regulator is external from arizona-core
into the regulator driver.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c       |    9 --------
 drivers/regulator/arizona-ldo1.c |   41 +++++++++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 97eafce..0bab354 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -539,7 +539,6 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 	int ret, i;
 
 	arizona_of_get_named_gpio(arizona, "wlf,reset", true, &pdata->reset);
-	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
 
 	ret = of_property_read_u32_array(arizona->dev->of_node,
 					 "wlf,gpio-defaults",
@@ -870,14 +869,6 @@ int arizona_dev_init(struct arizona *arizona)
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
index 4f6c205..6379fd3 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -180,6 +180,38 @@ static const struct regulator_init_data arizona_ldo1_default = {
 	.num_consumer_supplies = 1,
 };
 
+#ifdef CONFIG_OF
+static int arizona_ldo1_get_pdata(struct arizona *arizona,
+				  struct regulator_config *config)
+{
+	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true,
+				  &config->ena_gpio);
+
+	return 0;
+}
+#else
+static inline int arizona_ldo1_get_pdata(struct arizona *arizona,
+					 struct regulator_config *config)
+{
+	struct arizona_pdata *pdata = &arizona->pdata;
+
+	config->ena_gpio = arizona->pdata.ldoena;
+
+	if (pdata->ldo1) {
+		config->init_data = pdata->ldo1;
+
+		/*
+		 * LDO1 can only be used to supply DCVDD so if it has no
+		 * consumers then DCVDD is supplied externally.
+		 */
+		if (pdata->ldo1->num_consumer_supplies == 0)
+			arizona->external_dcvdd = true;
+	}
+
+	return 0;
+}
+#endif
+
 static int arizona_ldo1_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
@@ -219,12 +251,11 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	config.dev = arizona->dev;
 	config.driver_data = ldo1;
 	config.regmap = arizona->regmap;
-	config.ena_gpio = arizona->pdata.ldoena;
+	config.init_data = &ldo1->init_data;
 
-	if (arizona->pdata.ldo1)
-		config.init_data = arizona->pdata.ldo1;
-	else
-		config.init_data = &ldo1->init_data;
+	ret = arizona_ldo1_get_pdata(arizona, &config);
+	if (ret < 0)
+		return ret;
 
 	ldo1->regulator = devm_regulator_register(&pdev->dev, desc, &config);
 	if (IS_ERR(ldo1->regulator)) {
-- 
1.7.2.5

