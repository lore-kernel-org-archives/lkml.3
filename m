Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaGBKHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:07:46 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:40939 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751563AbaGBKHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:07:44 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: lgirdwood@gmail.com, broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk, heiko@sntech.de,
        rob.jones@codethink.co.uk
Subject: [PATCH V2 3/3] regulator: use managed resources for gpio_regulator_probe().
Date: Wed,  2 Jul 2014 11:05:51 +0100
Message-Id: <1404295551-13470-4-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404295551-13470-1-git-send-email-rob.jones@codethink.co.uk>
References: <1404295551-13470-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use managed resource functions for all resource allocations in
gpio_regulator_probe().

Remove gpio_regulator_remove() as it is now redundant.

Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 drivers/regulator/gpio-regulator.c |   70 ++++++++++++------------------------
 1 file changed, 23 insertions(+), 47 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 989b23b..6edde12 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -254,30 +254,31 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 	if (drvdata == NULL)
 		return -ENOMEM;
 
-	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
+	drvdata->desc.name = devm_kstrdup(&pdev->dev,
+					  config->supply_name,
+					  GFP_KERNEL);
 	if (drvdata->desc.name == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate supply name\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
-	drvdata->gpios = kmemdup(config->gpios,
-				 config->nr_gpios * sizeof(struct gpio),
-				 GFP_KERNEL);
+	drvdata->gpios = devm_kmemdup(&pdev->dev,
+				      config->gpios,
+				      config->nr_gpios * sizeof(struct gpio),
+				      GFP_KERNEL);
 	if (drvdata->gpios == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate gpio data\n");
-		ret = -ENOMEM;
-		goto err_name;
+		return -ENOMEM;
 	}
 
-	drvdata->states = kmemdup(config->states,
-				  config->nr_states *
+	drvdata->states = devm_kmemdup(&pdev->dev,
+				       config->states,
+				       config->nr_states *
 					 sizeof(struct gpio_regulator_state),
-				  GFP_KERNEL);
+				       GFP_KERNEL);
 	if (drvdata->states == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate state data\n");
-		ret = -ENOMEM;
-		goto err_memgpio;
+		return -ENOMEM;
 	}
 	drvdata->nr_states = config->nr_states;
 
@@ -297,16 +298,17 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(&pdev->dev, "No regulator type set\n");
-		ret = -EINVAL;
-		goto err_memgpio;
+		return -EINVAL;
 	}
 
 	drvdata->nr_gpios = config->nr_gpios;
-	ret = gpio_request_array(drvdata->gpios, drvdata->nr_gpios);
+	ret = devm_gpio_request_array(&pdev->dev,
+				      drvdata->gpios,
+				      drvdata->nr_gpios);
 	if (ret) {
 		dev_err(&pdev->dev,
 		   "Could not obtain regulator setting GPIOs: %d\n", ret);
-		goto err_memstate;
+		return ret;
 	}
 
 	/* build initial state from gpio init data. */
@@ -337,43 +339,18 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 	}
 
-	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
+	drvdata->dev = devm_regulator_register(&pdev->dev,
+					       &drvdata->desc,
+					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
-		goto err_stategpio;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, drvdata);
 
 	return 0;
-
-err_stategpio:
-	gpio_free_array(drvdata->gpios, drvdata->nr_gpios);
-err_memstate:
-	kfree(drvdata->states);
-err_memgpio:
-	kfree(drvdata->gpios);
-err_name:
-	kfree(drvdata->desc.name);
-err:
-	return ret;
-}
-
-static int gpio_regulator_remove(struct platform_device *pdev)
-{
-	struct gpio_regulator_data *drvdata = platform_get_drvdata(pdev);
-
-	regulator_unregister(drvdata->dev);
-
-	gpio_free_array(drvdata->gpios, drvdata->nr_gpios);
-
-	kfree(drvdata->states);
-	kfree(drvdata->gpios);
-
-	kfree(drvdata->desc.name);
-
-	return 0;
 }
 
 #if defined(CONFIG_OF)
@@ -385,7 +362,6 @@ static const struct of_device_id regulator_gpio_of_match[] = {
 
 static struct platform_driver gpio_regulator_driver = {
 	.probe		= gpio_regulator_probe,
-	.remove		= gpio_regulator_remove,
 	.driver		= {
 		.name		= "gpio-regulator",
 		.owner		= THIS_MODULE,
-- 
1.7.10.4

