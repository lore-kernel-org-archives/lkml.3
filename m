Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3BMHCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:02:10 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43739 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3BMHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:02:08 -0500
From: Alexandre Courbot <gnurou@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/4] gpiolib: check descriptors validity before use
Date: Wed, 13 Feb 2013 16:02:59 +0900
Message-Id: <1360738983-22436-2-git-send-email-gnurou@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Courbot <acourbot@nvidia.com>

Some functions dereferenced their GPIO descriptor argument without
checking its validity first, potentially leading to an oops when given
an invalid argument.

This patch also makes gpio_get_value() more resilient when given an
invalid GPIO, returning 0 instead of oopsing.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 64 +++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index fff9786..8a2cf9c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -174,7 +174,7 @@ static int gpio_ensure_requested(struct gpio_desc *desc)
 /* caller holds gpio_lock *OR* gpio is marked as requested */
 static struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc)
 {
-	return desc->chip;
+	return desc ? desc->chip : NULL;
 }
 
 struct gpio_chip *gpio_to_chip(unsigned gpio)
@@ -653,7 +653,12 @@ static ssize_t export_store(struct class *class,
 	if (status < 0)
 		goto done;
 
+	status = -EINVAL;
+
 	desc = gpio_to_desc(gpio);
+	/* reject invalid GPIOs */
+	if (!desc)
+		goto done;
 
 	/* No extra locking here; FLAG_SYSFS just signifies that the
 	 * request and export were done by on behalf of userspace, so
@@ -867,8 +872,8 @@ static int gpiod_export_link(struct device *dev, const char *name,
 
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
-			 status);
+		pr_debug("%s: gpio%d status %d\n", __func__,
+			 desc ? desc_to_gpio(desc) : -1, status);
 
 	return status;
 }
@@ -916,8 +921,8 @@ unlock:
 
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
-			 status);
+		pr_debug("%s: gpio%d status %d\n", __func__,
+			 desc ? desc_to_gpio(desc) : -1, status);
 
 	return status;
 }
@@ -964,8 +969,8 @@ static void gpiod_unexport(struct gpio_desc *desc)
 	}
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
-			 status);
+		pr_debug("%s: gpio%d status %d\n", __func__,
+			 desc ? desc_to_gpio(desc) : -1, status);
 }
 
 void gpio_unexport(unsigned gpio)
@@ -1432,8 +1437,7 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 done:
 	if (status)
 		pr_debug("_gpio_request: gpio-%d (%s) status %d\n",
-			 desc ? desc_to_gpio(desc) : -1,
-			 label ? : "?", status);
+			 desc ? desc_to_gpio(desc) : -1, label ? : "?", status);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
@@ -1655,13 +1659,9 @@ lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status) {
-		int gpio = -1;
-		if (desc)
-			gpio = desc_to_gpio(desc);
+	if (status)
 		pr_debug("%s: gpio-%d status %d\n",
-			__func__, gpio, status);
-	}
+			__func__, desc ? desc_to_gpio(desc) : -1, status);
 	return status;
 }
 
@@ -1678,6 +1678,9 @@ static int gpiod_direction_output(struct gpio_desc *desc, int value)
 	int			status = -EINVAL;
 	int offset;
 
+	if (!desc)
+		goto fail_unlocked;
+
 	/* Open drain pin should not be driven to 1 */
 	if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
 		return gpiod_direction_input(desc);
@@ -1688,8 +1691,6 @@ static int gpiod_direction_output(struct gpio_desc *desc, int value)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!desc)
-		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->direction_output)
 		goto fail;
@@ -1725,13 +1726,10 @@ lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status) {
-		int gpio = -1;
-		if (desc)
-			gpio = desc_to_gpio(desc);
+fail_unlocked:
+	if (status)
 		pr_debug("%s: gpio-%d status %d\n",
-			__func__, gpio, status);
-	}
+			__func__, desc ? desc_to_gpio(desc) : -1, status);
 	return status;
 }
 
@@ -1776,13 +1774,9 @@ static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status) {
-		int gpio = -1;
-		if (desc)
-			gpio = desc_to_gpio(desc);
+	if (status)
 		pr_debug("%s: gpio-%d status %d\n",
-			__func__, gpio, status);
-	}
+			__func__, desc ? desc_to_gpio(desc) : -1, status);
 
 	return status;
 }
@@ -1830,6 +1824,8 @@ static int gpiod_get_value(struct gpio_desc *desc)
 	int value;
 	int offset;
 
+	if (!desc)
+		return 0;
 	chip = desc->chip;
 	offset = gpio_chip_hwgpio(desc);
 	/* Should be using gpio_get_value_cansleep() */
@@ -1912,6 +1908,8 @@ static void gpiod_set_value(struct gpio_desc *desc, int value)
 {
 	struct gpio_chip	*chip;
 
+	if (!desc)
+		return;
 	chip = desc->chip;
 	/* Should be using gpio_set_value_cansleep() */
 	WARN_ON(chip->can_sleep);
@@ -1940,6 +1938,8 @@ EXPORT_SYMBOL_GPL(__gpio_set_value);
  */
 static int gpiod_cansleep(struct gpio_desc *desc)
 {
+	if (!desc)
+		return 0;
 	/* only call this on GPIOs that are valid! */
 	return desc->chip->can_sleep;
 }
@@ -1964,6 +1964,8 @@ static int gpiod_to_irq(struct gpio_desc *desc)
 	struct gpio_chip	*chip;
 	int			offset;
 
+	if (!desc)
+		return -EINVAL;
 	chip = desc->chip;
 	offset = gpio_chip_hwgpio(desc);
 	return chip->to_irq ? chip->to_irq(chip, offset) : -ENXIO;
@@ -1987,6 +1989,8 @@ static int gpiod_get_value_cansleep(struct gpio_desc *desc)
 	int offset;
 
 	might_sleep_if(extra_checks);
+	if (!desc)
+		return 0;
 	chip = desc->chip;
 	offset = gpio_chip_hwgpio(desc);
 	value = chip->get ? chip->get(chip, offset) : 0;
@@ -2005,6 +2009,8 @@ static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 	struct gpio_chip	*chip;
 
 	might_sleep_if(extra_checks);
+	if (!desc)
+		return;
 	chip = desc->chip;
 	trace_gpio_value(desc_to_gpio(desc), 0, value);
 	if (test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
-- 
1.8.1.3

