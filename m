Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3AYIzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:55:55 -0500
Received: from mail.df.lth.se ([194.47.250.12]:3995 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3AYIzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:55:51 -0500
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 03:55:51 EST
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] gpio: pca953x: use simple irqdomain
Date: Fri, 25 Jan 2013 09:46:45 +0100
Message-Id: <1359103605-16333-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the legacy irqdomain to the simple one, which will
auto-allocate descriptors, and also make sure that we use
irq_create_mapping() in the to_irq function.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-pca953x.c | 35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 3a68aed..51e7f15 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -89,7 +89,6 @@ struct pca953x_chip {
 	u8 irq_stat[MAX_BANK];
 	u8 irq_trig_raise[MAX_BANK];
 	u8 irq_trig_fall[MAX_BANK];
-	int	 irq_base;
 	struct irq_domain *domain;
 #endif
 
@@ -372,7 +371,7 @@ static int pca953x_gpio_to_irq(struct gpio_chip *gc, unsigned off)
 	struct pca953x_chip *chip;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
-	return chip->irq_base + off;
+	return irq_create_mapping(chip->domain, off);
 }
 
 static void pca953x_irq_mask(struct irq_data *d)
@@ -552,20 +551,13 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 			chip->irq_stat[i] &= chip->reg_direction[i];
 		mutex_init(&chip->irq_lock);
 
-		chip->irq_base = irq_alloc_descs(-1, irq_base, chip->gpio_chip.ngpio, -1);
-		if (chip->irq_base < 0)
-			goto out_failed;
-
-		chip->domain = irq_domain_add_legacy(client->dev.of_node,
+		chip->domain = irq_domain_add_simple(client->dev.of_node,
 						chip->gpio_chip.ngpio,
-						chip->irq_base,
-						0,
+						irq_base,
 						&irq_domain_simple_ops,
 						NULL);
-		if (!chip->domain) {
-			ret = -ENODEV;
-			goto out_irqdesc_free;
-		}
+		if (!chip->domain)
+			return -ENODEV;
 
 		for (lvl = 0; lvl < chip->gpio_chip.ngpio; lvl++) {
 			int irq = lvl + chip->irq_base;
@@ -582,32 +574,25 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 		}
 
 		ret = request_threaded_irq(client->irq,
-					   NULL,
-					   pca953x_irq_handler,
-					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-					   dev_name(&client->dev), chip);
+					NULL,
+					pca953x_irq_handler,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					dev_name(&client->dev), chip);
 		if (ret) {
 			dev_err(&client->dev, "failed to request irq %d\n",
 				client->irq);
-			goto out_irqdesc_free;
+			return ret;
 		}
 
 		chip->gpio_chip.to_irq = pca953x_gpio_to_irq;
 	}
 
 	return 0;
-
-out_irqdesc_free:
-	irq_free_descs(chip->irq_base, chip->gpio_chip.ngpio);
-out_failed:
-	chip->irq_base = -1;
-	return ret;
 }
 
 static void pca953x_irq_teardown(struct pca953x_chip *chip)
 {
 	if (chip->irq_base != -1) {
-		irq_free_descs(chip->irq_base, chip->gpio_chip.ngpio);
 		free_irq(chip->client->irq, chip);
 	}
 }
-- 
1.8.1

