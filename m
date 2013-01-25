Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3AYQ7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:59:47 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:48998 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab3AYQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:59:45 -0500
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
Subject: [PATCH 1/2] gpio: pca953x: use simple irqdomain
Date: Fri, 25 Jan 2013 17:59:27 +0100
Message-Id: <1359133168-14879-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com>
References: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the legacy irqdomain to the simple one, which will
auto-allocate descriptors, and also make sure that we use
irq_create_mapping() in the to_irq function. Also use the map function
of irq_domain_ops to setup the irq configuration on demand and no more
statically during the initialization of the driver.

Based on a initial patch from Linus Walleij <linus.walleij@linaro.org>

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/gpio/gpio-pca953x.c |   65 +++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 3a68aed..1dc9906 100644
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
@@ -520,6 +519,27 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 	return IRQ_HANDLED;
 }
 
+static int pca953x_gpio_irq_map(struct irq_domain *d, unsigned int irq,
+		       irq_hw_number_t hwirq)
+{
+	irq_clear_status_flags(irq, IRQ_NOREQUEST);
+	irq_set_chip_data(irq, d->host_data);
+	irq_set_chip(irq, &pca953x_irq_chip);
+	irq_set_nested_thread(irq, true);
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
+
+	return 0;
+}
+
+static const struct irq_domain_ops pca953x_irq_simple_ops = {
+	.map = pca953x_gpio_irq_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
 static int pca953x_irq_setup(struct pca953x_chip *chip,
 			     const struct i2c_device_id *id,
 			     int irq_base)
@@ -529,7 +549,6 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 
 	if (irq_base != -1
 			&& (id->driver_data & PCA_INT)) {
-		int lvl;
 
 		switch (chip->chip_type) {
 		case PCA953X_TYPE:
@@ -552,34 +571,13 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
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
-						&irq_domain_simple_ops,
+						irq_base,
+						&pca953x_irq_simple_ops,
 						NULL);
-		if (!chip->domain) {
-			ret = -ENODEV;
-			goto out_irqdesc_free;
-		}
-
-		for (lvl = 0; lvl < chip->gpio_chip.ngpio; lvl++) {
-			int irq = lvl + chip->irq_base;
-
-			irq_clear_status_flags(irq, IRQ_NOREQUEST);
-			irq_set_chip_data(irq, chip);
-			irq_set_chip(irq, &pca953x_irq_chip);
-			irq_set_nested_thread(irq, true);
-#ifdef CONFIG_ARM
-			set_irq_flags(irq, IRQF_VALID);
-#else
-			irq_set_noprobe(irq);
-#endif
-		}
+		if (!chip->domain)
+			return -ENODEV;
 
 		ret = request_threaded_irq(client->irq,
 					   NULL,
@@ -589,25 +587,18 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
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
1.7.9.5

