Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936132Ab3DJHNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:13:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54494 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab3DJHNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:13:20 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: Rodolfo Giometti <giometti@enneenne.com>,
        James Nuss <jamesnuss@nanometrics.ca>
Cc: linux-kernel@vger.kernel.org, Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH 1/2] pps-gpio: convert to devm_* helpers
Date: Wed, 10 Apr 2013 09:12:37 +0200
Message-Id: <1365577958-13295-1-git-send-email-jlu@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
 drivers/pps/clients/pps-gpio.c |   31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 2bf0c1b..221858d 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -74,7 +74,7 @@ static int pps_gpio_setup(struct platform_device *pdev)
 	int ret;
 	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
 
-	ret = gpio_request(pdata->gpio_pin, pdata->gpio_label);
+	ret = devm_gpio_request(&pdev->dev, pdata->gpio_pin, pdata->gpio_label);
 	if (ret) {
 		pr_warning("failed to request GPIO %u\n", pdata->gpio_pin);
 		return -EINVAL;
@@ -83,7 +83,6 @@ static int pps_gpio_setup(struct platform_device *pdev)
 	ret = gpio_direction_input(pdata->gpio_pin);
 	if (ret) {
 		pr_warning("failed to set pin direction\n");
-		gpio_free(pdata->gpio_pin);
 		return -EINVAL;
 	}
 
@@ -109,7 +108,6 @@ static int pps_gpio_probe(struct platform_device *pdev)
 	struct pps_gpio_device_data *data;
 	int irq;
 	int ret;
-	int err;
 	int pps_default_params;
 	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
 
@@ -123,15 +121,14 @@ static int pps_gpio_probe(struct platform_device *pdev)
 	irq = gpio_to_irq(pdata->gpio_pin);
 	if (irq < 0) {
 		pr_err("failed to map GPIO to IRQ: %d\n", irq);
-		err = -EINVAL;
-		goto return_error;
+		return -EINVAL;
 	}
 
 	/* allocate space for device info */
-	data = kzalloc(sizeof(struct pps_gpio_device_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct pps_gpio_device_data),
+			GFP_KERNEL);
 	if (data == NULL) {
-		err = -ENOMEM;
-		goto return_error;
+		return -ENOMEM;
 	}
 
 	/* initialize PPS specific parts of the bookkeeping data structure. */
@@ -150,47 +147,35 @@ static int pps_gpio_probe(struct platform_device *pdev)
 		pps_default_params |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR;
 	data->pps = pps_register_source(&data->info, pps_default_params);
 	if (data->pps == NULL) {
-		kfree(data);
 		pr_err("failed to register IRQ %d as PPS source\n", irq);
-		err = -EINVAL;
-		goto return_error;
+		return -EINVAL;
 	}
 
 	data->irq = irq;
 	data->pdata = pdata;
 
 	/* register IRQ interrupt handler */
-	ret = request_irq(irq, pps_gpio_irq_handler,
+	ret = devm_request_irq(&pdev->dev, irq, pps_gpio_irq_handler,
 			get_irqf_trigger_flags(pdata), data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
-		kfree(data);
 		pr_err("failed to acquire IRQ %d\n", irq);
-		err = -EINVAL;
-		goto return_error;
+		return -EINVAL;
 	}
 
 	platform_set_drvdata(pdev, data);
 	dev_info(data->pps->dev, "Registered IRQ %d as PPS source\n", irq);
 
 	return 0;
-
-return_error:
-	gpio_free(pdata->gpio_pin);
-	return err;
 }
 
 static int pps_gpio_remove(struct platform_device *pdev)
 {
 	struct pps_gpio_device_data *data = platform_get_drvdata(pdev);
-	const struct pps_gpio_platform_data *pdata = data->pdata;
 
 	platform_set_drvdata(pdev, NULL);
-	free_irq(data->irq, data);
-	gpio_free(pdata->gpio_pin);
 	pps_unregister_source(data->pps);
 	pr_info("removed IRQ %d as PPS source\n", data->irq);
-	kfree(data);
 	return 0;
 }
 
-- 
1.7.10.4

