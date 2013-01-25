Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3AYQ74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:59:56 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:49008 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab3AYQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:59:46 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 2/2] gpio: pca953x: use managed resources
Date: Fri, 25 Jan 2013 17:59:28 +0100
Message-Id: <1359133168-14879-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com>
References: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Using the devm_* managed resources the pca driver can be simplified
and cut down on boilerplate code.

[gcl: fixed a inccorect reference to a removed label, "goto fail_out"
became "return ret"]

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/gpio/gpio-pca953x.c |   32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 1dc9906..2405946 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -560,7 +560,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 		}
 		ret = pca953x_read_regs(chip, offset, chip->irq_stat);
 		if (ret)
-			goto out_failed;
+			return ret;
 
 		/*
 		 * There is no way to know which GPIO line generated the
@@ -579,7 +579,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 		if (!chip->domain)
 			return -ENODEV;
 
-		ret = request_threaded_irq(client->irq,
+		ret = devm_request_threaded_irq(&client->dev,
+					client->irq,
 					   NULL,
 					   pca953x_irq_handler,
 					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
@@ -596,12 +597,6 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
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
@@ -614,10 +609,6 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 
 	return 0;
 }
-
-static void pca953x_irq_teardown(struct pca953x_chip *chip)
-{
-}
 #endif
 
 /*
@@ -736,7 +727,8 @@ static int pca953x_probe(struct i2c_client *client,
 	int ret;
 	u32 invert = 0;
 
-	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev,
+			sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 
@@ -771,15 +763,15 @@ static int pca953x_probe(struct i2c_client *client,
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
@@ -790,12 +782,6 @@ static int pca953x_probe(struct i2c_client *client,
 
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
@@ -821,8 +807,6 @@ static int pca953x_remove(struct i2c_client *client)
 		return ret;
 	}
 
-	pca953x_irq_teardown(chip);
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.9.5

