Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3BWH7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 02:59:13 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33237 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab3BWH6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 02:58:47 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ville Syrjala <syrjala@sci.fi>, Daniel Mack <zonque@gmail.com>
Subject: [PATCH 5/5] W1: w1-gpio - switch to using managed resources (devm)
Date: Fri, 22 Feb 2013 23:58:40 -0800
Message-Id: <1361606320-4479-5-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies error unwinding and device teardown.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/w1/masters/w1-gpio.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index ee6b6e3..19439f8 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -116,25 +116,26 @@ static int w1_gpio_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	w1_gpio = kzalloc(sizeof(struct w1_gpio), GFP_KERNEL);
+	w1_gpio = devm_kzalloc(&pdev->dev, sizeof(struct w1_gpio), GFP_KERNEL);
 	if (!w1_gpio) {
 		dev_err(&pdev->dev, "Out of memory\n");
 		return -ENOMEM;
 	}
 
-	err = gpio_request(pdata->pin, "w1");
+	err = devm_gpio_request(&pdev->dev, pdata->pin, "w1");
 	if (err) {
 		dev_err(&pdev->dev, "gpio_request (pin) failed\n");
-		goto free_master;
+		return err;
 	}
 
 	if (gpio_is_valid(pdata->ext_pullup_enable_pin)) {
-		err = gpio_request_one(pdata->ext_pullup_enable_pin,
-				       GPIOF_INIT_LOW, "w1 pullup");
+		err = devm_gpio_request_one(&pdev->dev,
+					    pdata->ext_pullup_enable_pin,
+					    GPIOF_INIT_LOW, "w1 pullup");
 		if (err < 0) {
-			dev_err(&pdev->dev, "gpio_request_one "
-					"(ext_pullup_enable_pin) failed\n");
-			goto free_gpio;
+			dev_err(&pdev->dev,
+				"gpio_request_one (ext_pullup_enable_pin) failed\n");
+			return err;
 		}
 	}
 
@@ -154,7 +155,7 @@ static int w1_gpio_probe(struct platform_device *pdev)
 	err = w1_add_master_device(&w1_gpio->master);
 	if (err) {
 		dev_err(&pdev->dev, "w1_add_master device failed\n");
-		goto free_gpio_ext_pu;
+		return err;
 	}
 
 	if (pdata->enable_external_pullup)
@@ -166,16 +167,6 @@ static int w1_gpio_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, w1_gpio);
 
 	return 0;
-
- free_gpio_ext_pu:
-	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
-		gpio_free(pdata->ext_pullup_enable_pin);
- free_gpio:
-	gpio_free(pdata->pin);
- free_master:
-	kfree(w1_gpio);
-
-	return err;
 }
 
 static int w1_gpio_remove(struct platform_device *pdev)
@@ -190,8 +181,6 @@ static int w1_gpio_remove(struct platform_device *pdev)
 		gpio_set_value(pdata->ext_pullup_enable_pin, 0);
 
 	w1_remove_master_device(&w1_gpio->master);
-	gpio_free(pdata->pin);
-	kfree(w1_gpio);
 
 	return 0;
 }
-- 
1.7.11.7

