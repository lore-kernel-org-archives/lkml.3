Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161771Ab3BOM5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:57:42 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56646 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161750Ab3BOM5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:39 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/35] mfd: ab8500-core: Add ADC support for ab8540
Date: Fri, 15 Feb 2013 12:56:40 +0000
Message-Id: <1360933026-30325-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c  |   74 +++++++++++++++++++++++++++++++++++---------
 drivers/mfd/ab8500-gpadc.c |   67 ++++++++++++++++++++++-----------------
 2 files changed, 98 insertions(+), 43 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 678afd0..ecf570f 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -604,6 +604,15 @@ static struct resource ab8500_gpadc_resources[] = {
 	},
 };
 
+static struct resource ab8540_gpadc_resources[] = {
+	{
+		.name	= "SW_CONV_END",
+		.start	= AB8500_INT_GP_SW_ADC_CONV_END,
+		.end	= AB8500_INT_GP_SW_ADC_CONV_END,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
 static struct resource ab8500_rtc_resources[] = {
 	{
 		.name	= "60S",
@@ -954,12 +963,6 @@ static struct mfd_cell abx500_common_devs[] = {
 		.of_compatible = "stericsson,abx500-clk",
 	},
 	{
-		.name = "ab8500-gpadc",
-		.of_compatible = "stericsson,ab8500-gpadc",
-		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
-		.resources = ab8500_gpadc_resources,
-	},
-	{
 		.name = "ab8500-rtc",
 		.of_compatible = "stericsson,ab8500-rtc",
 		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
@@ -1066,6 +1069,12 @@ static struct mfd_cell ab8500_devs[] = {
 		.name = "ab8500-codec",
 		.of_compatible = "stericsson,ab8500-codec",
 	},
+	{
+		.name = "ab8500-gpadc",
+		.of_compatible = "stericsson,ab8500-gpadc",
+		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
+		.resources = ab8500_gpadc_resources,
+	},
 };
 
 static struct mfd_cell ab9540_devs[] = {
@@ -1080,10 +1089,44 @@ static struct mfd_cell ab9540_devs[] = {
 	{
 		.name = "ab9540-codec",
 	},
+	{
+		.name = "ab8500-gpadc",
+		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
+		.resources = ab8500_gpadc_resources,
+	},
+	{
+		.name = "ab-iddet",
+		.num_resources = ARRAY_SIZE(ab8505_iddet_resources),
+		.resources = ab8505_iddet_resources,
+	},
 };
 
-/* Device list common to ab9540 and ab8505 */
-static struct mfd_cell ab9540_ab8505_devs[] = {
+/* Device list for ab8505  */
+static struct mfd_cell ab8505_devs[] = {
+	{
+		.name = "ab-iddet",
+		.num_resources = ARRAY_SIZE(ab8505_iddet_resources),
+		.resources = ab8505_iddet_resources,
+	},
+};
+
+static struct mfd_cell ab8540_devs[] = {
+	{
+		.name = "ab8500-gpio",
+	},
+	{
+		.name = "ab8540-usb",
+		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
+		.resources = ab8500_usb_resources,
+	},
+	{
+		.name = "ab8540-codec",
+	},
+	{
+		.name = "ab8500-gpadc",
+		.num_resources = ARRAY_SIZE(ab8540_gpadc_resources),
+		.resources = ab8540_gpadc_resources,
+	},
 	{
 		.name = "ab-iddet",
 		.num_resources = ARRAY_SIZE(ab8505_iddet_resources),
@@ -1416,6 +1459,14 @@ static int ab8500_probe(struct platform_device *pdev)
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
 				ARRAY_SIZE(ab9540_devs), NULL,
 				ab8500->irq_base, ab8500->domain);
+	else if (is_ab8540(ab8500))
+		ret = mfd_add_devices(ab8500->dev, 0, ab8540_devs,
+			      ARRAY_SIZE(ab8540_devs), NULL,
+			      ab8500->irq_base, ab8500->domain);
+	else if (is_ab8505(ab8500))
+		ret = mfd_add_devices(ab8500->dev, 0, ab8505_devs,
+			      ARRAY_SIZE(ab8505_devs), NULL,
+			      ab8500->irq_base, ab8500->domain);
 	else
 		ret = mfd_add_devices(ab8500->dev, 0, ab8500_devs,
 				ARRAY_SIZE(ab8500_devs), NULL,
@@ -1423,13 +1474,6 @@ static int ab8500_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	if (is_ab9540(ab8500) || is_ab8505(ab8500))
-		ret = mfd_add_devices(ab8500->dev, 0, ab9540_ab8505_devs,
-				ARRAY_SIZE(ab9540_ab8505_devs), NULL,
-				ab8500->irq_base, ab8500->domain);
-	if (ret)
-		return ret;
-
 	if (!no_bm) {
 		/* Add battery management devices */
 		ret = mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 5942f2f..6b18975 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -314,6 +314,12 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
 	if (!gpadc)
 		return -ENODEV;
 
+	/* check if convertion is supported */
+	if ((gpadc->irq_sw < 0) && (conv_type == ADC_SW))
+		return -ENOTSUPP;
+	if ((gpadc->irq_hw < 0) && (conv_type == ADC_HW))
+		return -ENOTSUPP;
+
 	mutex_lock(&gpadc->ab8500_gpadc_lock);
 	/* Enable VTVout LDO this is required for GPADC */
 	pm_runtime_get_sync(gpadc->dev);
@@ -766,20 +772,12 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 	}
 
 	gpadc->irq_sw = platform_get_irq_byname(pdev, "SW_CONV_END");
-	if (gpadc->irq_sw < 0) {
-		dev_err(gpadc->dev, "failed to get platform irq-%d\n",
-			gpadc->irq_sw);
-		ret = gpadc->irq_sw;
-		goto fail;
-	}
+	if (gpadc->irq_sw < 0)
+		dev_err(gpadc->dev, "failed to get platform sw_conv_end irq\n");
 
 	gpadc->irq_hw = platform_get_irq_byname(pdev, "HW_CONV_END");
-	if (gpadc->irq_hw < 0) {
-		dev_err(gpadc->dev, "failed to get platform irq-%d\n",
-			gpadc->irq_hw);
-		ret = gpadc->irq_hw;
-		goto fail;
-	}
+	if (gpadc->irq_hw < 0)
+		dev_err(gpadc->dev, "failed to get platform hw_conv_end irq\n");
 
 	gpadc->dev = &pdev->dev;
 	gpadc->parent = dev_get_drvdata(pdev->dev.parent);
@@ -789,21 +787,30 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 	init_completion(&gpadc->ab8500_gpadc_complete);
 
 	/* Register interrupts */
-	ret = request_threaded_irq(gpadc->irq_sw, NULL,
-		ab8500_bm_gpadcconvend_handler,
-		IRQF_NO_SUSPEND | IRQF_SHARED, "ab8500-gpadc-sw", gpadc);
-	if (ret < 0) {
-		dev_err(gpadc->dev, "Failed to register interrupt, irq: %d\n",
-			gpadc->irq_sw);
-		goto fail;
+	if (gpadc->irq_sw >= 0) {
+		ret = request_threaded_irq(gpadc->irq_sw, NULL,
+			ab8500_bm_gpadcconvend_handler,
+			IRQF_NO_SUSPEND | IRQF_SHARED, "ab8500-gpadc-sw",
+			gpadc);
+		if (ret < 0) {
+			dev_err(gpadc->dev,
+				"Failed to register interrupt irq: %d\n",
+				gpadc->irq_sw);
+			goto fail;
+		}
 	}
-	ret = request_threaded_irq(gpadc->irq_hw, NULL,
-		ab8500_bm_gpadcconvend_handler,
-		IRQF_NO_SUSPEND | IRQF_SHARED, "ab8500-gpadc-hw", gpadc);
-	if (ret < 0) {
-		dev_err(gpadc->dev, "Failed to register interrupt, irq: %d\n",
-			gpadc->irq_hw);
-		goto fail;
+
+	if (gpadc->irq_hw >= 0) {
+		ret = request_threaded_irq(gpadc->irq_hw, NULL,
+			ab8500_bm_gpadcconvend_handler,
+			IRQF_NO_SUSPEND | IRQF_SHARED, "ab8500-gpadc-hw",
+			gpadc);
+		if (ret < 0) {
+			dev_err(gpadc->dev,
+				"Failed to register interrupt irq: %d\n",
+				gpadc->irq_hw);
+			goto fail_irq;
+		}
 	}
 
 	/* VTVout LDO used to power up ab8500-GPADC */
@@ -825,7 +832,9 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 	ab8500_gpadc_read_calibration_data(gpadc);
 	list_add_tail(&gpadc->node, &ab8500_gpadc_list);
 	dev_dbg(gpadc->dev, "probe success\n");
+
 	return 0;
+
 fail_irq:
 	free_irq(gpadc->irq_sw, gpadc);
 	free_irq(gpadc->irq_hw, gpadc);
@@ -842,8 +851,10 @@ static int ab8500_gpadc_remove(struct platform_device *pdev)
 	/* remove this gpadc entry from the list */
 	list_del(&gpadc->node);
 	/* remove interrupt  - completion of Sw ADC conversion */
-	free_irq(gpadc->irq_sw, gpadc);
-	free_irq(gpadc->irq_hw, gpadc);
+	if (gpadc->irq_sw >= 0)
+		free_irq(gpadc->irq_sw, gpadc);
+	if (gpadc->irq_hw >= 0)
+		free_irq(gpadc->irq_hw, gpadc);
 
 	pm_runtime_get_sync(gpadc->dev);
 	pm_runtime_disable(gpadc->dev);
-- 
1.7.10.4

