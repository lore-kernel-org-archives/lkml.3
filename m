Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3AYIzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:55:53 -0500
Received: from mail.df.lth.se ([194.47.250.12]:3997 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3AYIzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:55:51 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] gpio: pca953x: use managed resources
Date: Fri, 25 Jan 2013 09:47:04 +0100
Message-Id: <1359103624-16380-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the devm_* managed resources the pca driver can be simplified
and cut down on boilerplate code.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-pca953x.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 51e7f15..2b04a8f 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -573,7 +573,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 #endif
 		}
 
-		ret = request_threaded_irq(client->irq,
+		ret = devm_request_threaded_irq(&client->dev,
+					client->irq,
 					NULL,
 					pca953x_irq_handler,
 					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
@@ -590,12 +591,6 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 	return 0;
 }
 
-static void pca953x_irq_teardown(struct pca953x_chip *chip)
-{
-	if (chip->irq_base != -1) {
-		free_irq(chip->client->irq, chip);
-	}
-}
 #else /* CONFIG_GPIO_PCA953X_IRQ */
 static int pca953x_irq_setup(struct pca953x_chip *chip,
 			     const struct i2c_device_id *id,
@@ -608,10 +603,6 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 
 	return 0;
 }
-
-static void pca953x_irq_teardown(struct pca953x_chip *chip)
-{
-}
 #endif
 
 /*
@@ -730,7 +721,8 @@ static int pca953x_probe(struct i2c_client *client,
 	int ret;
 	u32 invert = 0;
 
-	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev,
+			sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 
@@ -765,15 +757,15 @@ static int pca953x_probe(struct i2c_client *client,
 	else
 		ret = device_pca957x_init(chip, invert);
 	if (ret)
-		goto out_failed;
+		return ret;
 
 	ret = pca953x_irq_setup(chip, id, irq_base);
 	if (ret)
-		goto out_failed;
+		return ret;
 
 	ret = gpiochip_add(&chip->gpio_chip);
 	if (ret)
-		goto out_failed_irq;
+		return ret;
 
 	if (pdata && pdata->setup) {
 		ret = pdata->setup(client, chip->gpio_chip.base,
@@ -784,12 +776,6 @@ static int pca953x_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, chip);
 	return 0;
-
-out_failed_irq:
-	pca953x_irq_teardown(chip);
-out_failed:
-	kfree(chip);
-	return ret;
 }
 
 static int pca953x_remove(struct i2c_client *client)
@@ -815,8 +801,6 @@ static int pca953x_remove(struct i2c_client *client)
 		return ret;
 	}
 
-	pca953x_irq_teardown(chip);
-	kfree(chip);
 	return 0;
 }
 
-- 
1.8.1

