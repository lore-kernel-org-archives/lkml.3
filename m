Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935395Ab3BOFqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:46:34 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1309 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935380Ab3BOFq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:46:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 14 Feb 2013 21:46:28 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/4] gpiolib: check descriptors validity before use
Date: Fri, 15 Feb 2013 14:46:14 +0900
Message-ID: <1360907177-6468-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions dereferenced their GPIO descriptor argument without
checking its validity first, potentially leading to an oops when given
an invalid argument.

This patch also makes gpio_get_value() more resilient when given an
invalid GPIO, returning 0 instead of silently crashing.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ryan Mallon <rmallon@gmail.com>
---
 drivers/gpio/gpiolib.c | 112 ++++++++++++++++++++++++++++---------------------
 1 file changed, 65 insertions(+), 47 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index fff9786..1a8a7a8 100644
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
@@ -654,6 +654,11 @@ static ssize_t export_store(struct class *class,
 		goto done;
 
 	desc = gpio_to_desc(gpio);
+	/* reject invalid GPIOs */
+	if (!desc) {
+		pr_warn("%s: invalid GPIO %ld\n", __func__, gpio);
+		return -EINVAL;
+	}
 
 	/* No extra locking here; FLAG_SYSFS just signifies that the
 	 * request and export were done by on behalf of userspace, so
@@ -690,12 +695,14 @@ static ssize_t unexport_store(struct class *class,
 	if (status < 0)
 		goto done;
 
-	status = -EINVAL;
-
 	desc = gpio_to_desc(gpio);
 	/* reject bogus commands (gpio_unexport ignores them) */
-	if (!desc)
-		goto done;
+	if (!desc) {
+		pr_warn("%s: invalid GPIO %ld\n", __func__, gpio);
+		return -EINVAL;
+	}
+
+	status = -EINVAL;
 
 	/* No extra locking here; FLAG_SYSFS just signifies that the
 	 * request and export were done by on behalf of userspace, so
@@ -846,8 +853,10 @@ static int gpiod_export_link(struct device *dev, const char *name,
 {
 	int			status = -EINVAL;
 
-	if (!desc)
-		goto done;
+	if (!desc) {
+		pr_warn("%s: invalid GPIO\n", __func__);
+		return -EINVAL;
+	}
 
 	mutex_lock(&sysfs_lock);
 
@@ -865,7 +874,6 @@ static int gpiod_export_link(struct device *dev, const char *name,
 
 	mutex_unlock(&sysfs_lock);
 
-done:
 	if (status)
 		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
 			 status);
@@ -896,8 +904,10 @@ static int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
 	struct device		*dev = NULL;
 	int			status = -EINVAL;
 
-	if (!desc)
-		goto done;
+	if (!desc) {
+		pr_warn("%s: invalid GPIO\n", __func__);
+		return -EINVAL;
+	}
 
 	mutex_lock(&sysfs_lock);
 
@@ -914,7 +924,6 @@ static int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
 unlock:
 	mutex_unlock(&sysfs_lock);
 
-done:
 	if (status)
 		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
 			 status);
@@ -940,8 +949,8 @@ static void gpiod_unexport(struct gpio_desc *desc)
 	struct device		*dev = NULL;
 
 	if (!desc) {
-		status = -EINVAL;
-		goto done;
+		pr_warn("%s: invalid GPIO\n", __func__);
+		return;
 	}
 
 	mutex_lock(&sysfs_lock);
@@ -962,7 +971,7 @@ static void gpiod_unexport(struct gpio_desc *desc)
 		device_unregister(dev);
 		put_device(dev);
 	}
-done:
+
 	if (status)
 		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
 			 status);
@@ -1384,12 +1393,13 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 	int			status = -EPROBE_DEFER;
 	unsigned long		flags;
 
-	spin_lock_irqsave(&gpio_lock, flags);
-
 	if (!desc) {
-		status = -EINVAL;
-		goto done;
+		pr_warn("%s: invalid GPIO\n", __func__);
+		return -EINVAL;
 	}
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
 	chip = desc->chip;
 	if (chip == NULL)
 		goto done;
@@ -1432,8 +1442,7 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 done:
 	if (status)
 		pr_debug("_gpio_request: gpio-%d (%s) status %d\n",
-			 desc ? desc_to_gpio(desc) : -1,
-			 label ? : "?", status);
+			 desc_to_gpio(desc), label ? : "?", status);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
@@ -1616,10 +1625,13 @@ static int gpiod_direction_input(struct gpio_desc *desc)
 	int			status = -EINVAL;
 	int			offset;
 
+	if (!desc) {
+		pr_warn("%s: invalid GPIO\n", __func__);
+		return -EINVAL;
+	}
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!desc)
-		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->get || !chip->direction_input)
 		goto fail;
@@ -1655,13 +1667,9 @@ lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status) {
-		int gpio = -1;
-		if (desc)
-			gpio = desc_to_gpio(desc);
-		pr_debug("%s: gpio-%d status %d\n",
-			__func__, gpio, status);
-	}
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n", __func__,
+			 desc_to_gpio(desc), status);
 	return status;
 }
 
@@ -1678,6 +1686,11 @@ static int gpiod_direction_output(struct gpio_desc *desc, int value)
 	int			status = -EINVAL;
 	int offset;
 
+	if (!desc) {
+		pr_warn("%s: invalid GPIO\n", __func__);
+		return -EINVAL;
+	}
+
 	/* Open drain pin should not be driven to 1 */
 	if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
 		return gpiod_direction_input(desc);
@@ -1688,8 +1701,6 @@ static int gpiod_direction_output(struct gpio_desc *desc, int value)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!desc)
-		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->direction_output)
 		goto fail;
@@ -1725,13 +1736,9 @@ lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status) {
-		int gpio = -1;
-		if (desc)
-			gpio = desc_to_gpio(desc);
-		pr_debug("%s: gpio-%d status %d\n",
-			__func__, gpio, status);
-	}
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n", __func__,
+			 desc_to_gpio(desc), status);
 	return status;
 }
 
@@ -1753,10 +1760,13 @@ static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 	int			status = -EINVAL;
 	int			offset;
 
+	if (!desc) {
+		pr_warn("%s: invalid GPIO\n", __func__);
+		return -EINVAL;
+	}
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!desc)
-		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->set_debounce)
 		goto fail;
@@ -1776,13 +1786,9 @@ static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status) {
-		int gpio = -1;
-		if (desc)
-			gpio = desc_to_gpio(desc);
-		pr_debug("%s: gpio-%d status %d\n",
-			__func__, gpio, status);
-	}
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n", __func__,
+			 desc_to_gpio(desc), status);
 
 	return status;
 }
@@ -1830,6 +1836,8 @@ static int gpiod_get_value(struct gpio_desc *desc)
 	int value;
 	int offset;
 
+	if (!desc)
+		return 0;
 	chip = desc->chip;
 	offset = gpio_chip_hwgpio(desc);
 	/* Should be using gpio_get_value_cansleep() */
@@ -1912,6 +1920,8 @@ static void gpiod_set_value(struct gpio_desc *desc, int value)
 {
 	struct gpio_chip	*chip;
 
+	if (!desc)
+		return;
 	chip = desc->chip;
 	/* Should be using gpio_set_value_cansleep() */
 	WARN_ON(chip->can_sleep);
@@ -1940,6 +1950,8 @@ EXPORT_SYMBOL_GPL(__gpio_set_value);
  */
 static int gpiod_cansleep(struct gpio_desc *desc)
 {
+	if (!desc)
+		return 0;
 	/* only call this on GPIOs that are valid! */
 	return desc->chip->can_sleep;
 }
@@ -1964,6 +1976,8 @@ static int gpiod_to_irq(struct gpio_desc *desc)
 	struct gpio_chip	*chip;
 	int			offset;
 
+	if (!desc)
+		return -EINVAL;
 	chip = desc->chip;
 	offset = gpio_chip_hwgpio(desc);
 	return chip->to_irq ? chip->to_irq(chip, offset) : -ENXIO;
@@ -1987,6 +2001,8 @@ static int gpiod_get_value_cansleep(struct gpio_desc *desc)
 	int offset;
 
 	might_sleep_if(extra_checks);
+	if (!desc)
+		return 0;
 	chip = desc->chip;
 	offset = gpio_chip_hwgpio(desc);
 	value = chip->get ? chip->get(chip, offset) : 0;
@@ -2005,6 +2021,8 @@ static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 	struct gpio_chip	*chip;
 
 	might_sleep_if(extra_checks);
+	if (!desc)
+		return;
 	chip = desc->chip;
 	trace_gpio_value(desc_to_gpio(desc), 0, value);
 	if (test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
-- 
1.8.1.3

