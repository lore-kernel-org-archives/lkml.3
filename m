Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3CGNS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:18:29 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:60812 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739Ab3CGNSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:18:24 -0500
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, linus.walleij@linaro.org,
        cooloney@gmail.com, rpurdie@rpsys.net, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Subject: [PATCH v8 04/12] regulator: palmas correct dt parsing
Date: Thu,  7 Mar 2013 13:17:48 +0000
Message-Id: <1362662276-20792-4-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

Fix the DT parsing to agree with the bindings document. Some small changes
to the value names and also fix the handling of boolean values. They were
previously using prop = 1/0, now just use of_property_read_bool calls.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/regulator/palmas-regulator.c |   36 ++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 8a716a9..b2b1baa 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -1,7 +1,7 @@
 /*
  * Driver for Regulator part of Palmas PMIC Chips
  *
- * Copyright 2011-2012 Texas Instruments Inc.
+ * Copyright 2011-2013 Texas Instruments Inc.
  *
  * Author: Graeme Gregory <gg@slimlogic.co.uk>
  * Author: Ian Lartey <ian@slimlogic.co.uk>
@@ -553,15 +553,13 @@ static void palmas_dt_to_pdata(struct device *dev,
 		pdata->reg_init[idx] = devm_kzalloc(dev,
 				sizeof(struct palmas_reg_init), GFP_KERNEL);
 
-		ret = of_property_read_u32(palmas_matches[idx].of_node,
-				"ti,warm-reset", &prop);
-		if (!ret)
-			pdata->reg_init[idx]->warm_reset = prop;
+		pdata->reg_init[idx]->warm_reset =
+			of_property_read_u32(palmas_matches[idx].of_node,
+					     "ti,warm-reset", &prop);
 
-		ret = of_property_read_u32(palmas_matches[idx].of_node,
-				"ti,roof-floor", &prop);
-		if (!ret)
-			pdata->reg_init[idx]->roof_floor = prop;
+		pdata->reg_init[idx]->roof_floor =
+			of_property_read_bool(palmas_matches[idx].of_node,
+					      "ti,roof-floor");
 
 		ret = of_property_read_u32(palmas_matches[idx].of_node,
 				"ti,mode-sleep", &prop);
@@ -573,15 +571,14 @@ static void palmas_dt_to_pdata(struct device *dev,
 		if (!ret)
 			pdata->reg_init[idx]->tstep = prop;
 
-		ret = of_property_read_u32(palmas_matches[idx].of_node,
-				"ti,vsel", &prop);
-		if (!ret)
-			pdata->reg_init[idx]->vsel = prop;
+		ret = of_property_read_bool(palmas_matches[idx].of_node,
+					    "ti,smps-range");
+		if (ret)
+			pdata->reg_init[idx]->vsel =
+				PALMAS_SMPS12_VOLTAGE_RANGE;
 	}
 
-	ret = of_property_read_u32(node, "ti,ldo6-vibrator", &prop);
-	if (!ret)
-		pdata->ldo6_vibrator = prop;
+	pdata->ldo6_vibrator = of_property_read_bool(node, "ti,ldo6-vibrator");
 }
 
 
@@ -806,6 +803,13 @@ static int palmas_remove(struct platform_device *pdev)
 
 static struct of_device_id of_palmas_match_tbl[] = {
 	{ .compatible = "ti,palmas-pmic", },
+	{ .compatible = "ti,palmas-charger-pmic", },
+	{ .compatible = "ti,twl6035-pmic", },
+	{ .compatible = "ti,twl6036-pmic", },
+	{ .compatible = "ti,twl6037-pmic", },
+	{ .compatible = "ti,tps65913-pmic", },
+	{ .compatible = "ti,tps65914-pmic", },
+	{ .compatible = "ti,tps80036-pmic", },
 	{ /* end */ }
 };
 
-- 
1.7.0.4

