Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbaA2EDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 23:03:15 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40946 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbaA2EDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 23:03:11 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, broonie@kernel.org, lgirdwood@gmail.com,
        badarkhe.manish@gmail.com
Subject: [PATCH V3 2/2] regulator: fixed: update to devm_* API
Date: Wed, 29 Jan 2014 09:33:01 +0530
Message-Id: <1390968181-31800-3-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1390968181-31800-1-git-send-email-badarkhe.manish@gmail.com>
References: <1390968181-31800-1-git-send-email-badarkhe.manish@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the code to use devm_* API so that driver core will manage
resources.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 5ea64b9... 1d42613... M	drivers/regulator/fixed.c
 drivers/regulator/fixed.c |   44 ++++++++++++++------------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 5ea64b9..1d42613 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -132,15 +132,16 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 			       GFP_KERNEL);
 	if (drvdata == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate device data\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
-	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
+	drvdata->desc.name = devm_kstrdup(&pdev->dev,
+					  config->supply_name,
+					  strlen(config->supply_name) + 1,
+					  GFP_KERNEL);
 	if (drvdata->desc.name == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate supply name\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 	drvdata->desc.type = REGULATOR_VOLTAGE;
 	drvdata->desc.owner = THIS_MODULE;
@@ -149,13 +150,14 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->desc.enable_time = config->startup_delay;
 
 	if (config->input_supply) {
-		drvdata->desc.supply_name = kstrdup(config->input_supply,
-							GFP_KERNEL);
+		drvdata->desc.supply_name = devm_kstrdup(&pdev->dev,
+					    config->input_supply,
+					    strlen(config->input_supply) + 1,
+					    GFP_KERNEL);
 		if (!drvdata->desc.supply_name) {
 			dev_err(&pdev->dev,
 				"Failed to allocate input supply\n");
-			ret = -ENOMEM;
-			goto err_name;
+			return -ENOMEM;
 		}
 	}
 
@@ -186,11 +188,12 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	cfg.driver_data = drvdata;
 	cfg.of_node = pdev->dev.of_node;
 
-	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
+	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
+					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
-		goto err_input;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, drvdata);
@@ -199,24 +202,6 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		drvdata->desc.fixed_uV);
 
 	return 0;
-
-err_input:
-	kfree(drvdata->desc.supply_name);
-err_name:
-	kfree(drvdata->desc.name);
-err:
-	return ret;
-}
-
-static int reg_fixed_voltage_remove(struct platform_device *pdev)
-{
-	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
-
-	regulator_unregister(drvdata->dev);
-	kfree(drvdata->desc.supply_name);
-	kfree(drvdata->desc.name);
-
-	return 0;
 }
 
 #if defined(CONFIG_OF)
@@ -229,7 +214,6 @@ MODULE_DEVICE_TABLE(of, fixed_of_match);
 
 static struct platform_driver regulator_fixed_voltage_driver = {
 	.probe		= reg_fixed_voltage_probe,
-	.remove		= reg_fixed_voltage_remove,
 	.driver		= {
 		.name		= "reg-fixed-voltage",
 		.owner		= THIS_MODULE,
-- 
1.7.10.4

