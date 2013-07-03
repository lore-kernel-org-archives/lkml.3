Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3GCEO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 00:14:29 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57045 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3GCEO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 00:14:28 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-sh@vger.kernel.org
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, grant.likely@linaro.org,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 03 Jul 2013 13:14:32 +0900
Message-Id: <20130703041432.7351.45970.sendpatchset@w520>
Subject: [PATCH] gpio: em: Add pinctrl support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Register the GPIO pin range, and request and free GPIO pins using the
pinctrl API. The pctl_name platform data member should be used by
platform devices to point out which pinctrl device to use.

Follows same style as "dc3465a gpio-rcar: Add pinctrl support",
by Laurent Pinchart, thanks to him.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/gpio-em.c                |   25 +++++++++++++++++++++++++
 include/linux/platform_data/gpio-em.h |    1 +
 2 files changed, 26 insertions(+)

--- 0001/drivers/gpio/gpio-em.c
+++ work/drivers/gpio/gpio-em.c	2013-07-03 12:49:55.000000000 +0900
@@ -30,6 +30,7 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_data/gpio-em.h>
 
 struct em_gio_priv {
@@ -216,6 +217,21 @@ static int em_gio_to_irq(struct gpio_chi
 	return irq_create_mapping(gpio_to_priv(chip)->irq_domain, offset);
 }
 
+static int em_gio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void em_gio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+
+	/* Set the GPIO as an input to ensure that the next GPIO request won't
+	* drive the GPIO pin as an output.
+	*/
+	em_gio_direction_input(chip, offset);
+}
+
 static int em_gio_irq_domain_map(struct irq_domain *h, unsigned int virq,
 				 irq_hw_number_t hw)
 {
@@ -308,6 +324,8 @@ static int em_gio_probe(struct platform_
 	gpio_chip->direction_output = em_gio_direction_output;
 	gpio_chip->set = em_gio_set;
 	gpio_chip->to_irq = em_gio_to_irq;
+	gpio_chip->request = em_gio_request;
+	gpio_chip->free = em_gio_free;
 	gpio_chip->label = name;
 	gpio_chip->owner = THIS_MODULE;
 	gpio_chip->base = pdata->gpio_base;
@@ -351,6 +369,13 @@ static int em_gio_probe(struct platform_
 		dev_err(&pdev->dev, "failed to add GPIO controller\n");
 		goto err1;
 	}
+
+	if (pdata->pctl_name) {
+		ret = gpiochip_add_pin_range(gpio_chip, pdata->pctl_name, 0,
+					     gpio_chip->base, gpio_chip->ngpio);
+		if (ret < 0)
+			dev_warn(&pdev->dev, "failed to add pin range\n");
+	}
 	return 0;
 
 err1:
--- 0001/include/linux/platform_data/gpio-em.h
+++ work/include/linux/platform_data/gpio-em.h	2013-07-03 12:45:27.000000000 +0900
@@ -5,6 +5,7 @@ struct gpio_em_config {
 	unsigned int gpio_base;
 	unsigned int irq_base;
 	unsigned int number_of_pins;
+	const char *pctl_name;
 };
 
 #endif /* __GPIO_EM_H__ */
