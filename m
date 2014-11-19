Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaKSOOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:14:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43848 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753824AbaKSOOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:14:41 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH] regulator: gpio: fix parsing of gpio list
Date: Wed, 19 Nov 2014 14:13:06 +0000
Message-Id: <1416406386-22923-1-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list of gpios is defined as optional but the code was
failing to properly handle the case of no gpios, and also
failing to check for errors reading the entry from the
devicetree.

This patch fixes the handling of optional gpios - this is a
useful feature enabling the gpio-regulator to be used as a
dummy variable voltage regulator without having to assign any
real GPIO lines.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 drivers/regulator/gpio-regulator.c |   93 ++++++++++++++++++++----------------
 1 files changed, 51 insertions(+), 42 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 86546c1..b42c7ec 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -162,34 +162,41 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 
 	config->enable_gpio = of_get_named_gpio(np, "enable-gpio", 0);
 
-	/* Fetch GPIOs. */
-	config->nr_gpios = of_gpio_count(np);
-
-	config->gpios = devm_kzalloc(dev,
-				sizeof(struct gpio) * config->nr_gpios,
-				GFP_KERNEL);
-	if (!config->gpios)
-		return ERR_PTR(-ENOMEM);
-
-	proplen = of_property_count_u32_elems(np, "gpios-states");
-	/* optional property */
-	if (proplen < 0)
-		proplen = 0;
-
-	if (proplen > 0 && proplen != config->nr_gpios) {
-		dev_warn(dev, "gpios <-> gpios-states mismatch\n");
-		proplen = 0;
-	}
+	/* Fetch GPIOs. - optional property*/
+	ret = of_gpio_count(np);
+	if ((ret < 0) && (ret != -ENOENT))
+		return ERR_PTR(ret);
+
+	if (ret > 0) {
+		config->nr_gpios = ret;
+		config->gpios = devm_kzalloc(dev,
+					sizeof(struct gpio) * config->nr_gpios,
+					GFP_KERNEL);
+		if (!config->gpios)
+			return ERR_PTR(-ENOMEM);
+
+		proplen = of_property_count_u32_elems(np, "gpios-states");
+		/* optional property */
+		if (proplen < 0)
+			proplen = 0;
+
+		if (proplen > 0 && proplen != config->nr_gpios) {
+			dev_warn(dev, "gpios <-> gpios-states mismatch\n");
+			proplen = 0;
+		}
 
-	for (i = 0; i < config->nr_gpios; i++) {
-		gpio = of_get_named_gpio(np, "gpios", i);
-		if (gpio < 0)
-			break;
-		config->gpios[i].gpio = gpio;
-		if (proplen > 0) {
-			of_property_read_u32_index(np, "gpios-states", i, &ret);
-			if (ret)
-				config->gpios[i].flags = GPIOF_OUT_INIT_HIGH;
+		for (i = 0; i < config->nr_gpios; i++) {
+			gpio = of_get_named_gpio(np, "gpios", i);
+			if (gpio < 0)
+				break;
+			config->gpios[i].gpio = gpio;
+			if (proplen > 0) {
+				of_property_read_u32_index(np, "gpios-states",
+							   i, &ret);
+				if (ret)
+					config->gpios[i].flags =
+							   GPIOF_OUT_INIT_HIGH;
+			}
 		}
 	}
 
@@ -261,13 +268,23 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	drvdata->gpios = kmemdup(config->gpios,
-				 config->nr_gpios * sizeof(struct gpio),
-				 GFP_KERNEL);
-	if (drvdata->gpios == NULL) {
-		dev_err(&pdev->dev, "Failed to allocate gpio data\n");
-		ret = -ENOMEM;
-		goto err_name;
+	if (config->nr_gpios != 0) {
+		drvdata->gpios = kmemdup(config->gpios,
+					 config->nr_gpios * sizeof(struct gpio),
+					 GFP_KERNEL);
+		if (drvdata->gpios == NULL) {
+			dev_err(&pdev->dev, "Failed to allocate gpio data\n");
+			ret = -ENOMEM;
+			goto err_name;
+		}
+
+		drvdata->nr_gpios = config->nr_gpios;
+		ret = gpio_request_array(drvdata->gpios, drvdata->nr_gpios);
+		if (ret) {
+			dev_err(&pdev->dev,
+			"Could not obtain regulator setting GPIOs: %d\n", ret);
+			goto err_memstate;
+		}
 	}
 
 	drvdata->states = kmemdup(config->states,
@@ -301,14 +318,6 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 		goto err_memgpio;
 	}
 
-	drvdata->nr_gpios = config->nr_gpios;
-	ret = gpio_request_array(drvdata->gpios, drvdata->nr_gpios);
-	if (ret) {
-		dev_err(&pdev->dev,
-		   "Could not obtain regulator setting GPIOs: %d\n", ret);
-		goto err_memstate;
-	}
-
 	/* build initial state from gpio init data. */
 	state = 0;
 	for (ptr = 0; ptr < drvdata->nr_gpios; ptr++) {
-- 
1.7.2.5

