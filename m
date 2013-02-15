Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935424Ab3BOFqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:46:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1323 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935398Ab3BOFqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:46:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 14 Feb 2013 21:46:35 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 4/4] gpiolib: rename local offset variables to "hwgpio"
Date: Fri, 15 Feb 2013 14:46:17 +0900
Message-ID: <1360907177-6468-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Their value being obtained by gpio_chip_hwgpio(), this better reflects
their use.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 70 +++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index c2534d6..6e38dfd 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -72,7 +72,7 @@ struct gpio_desc {
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
-#define GPIO_OFFSET_VALID(chip, offset) (offset >= 0 && offset < chip->ngpio)
+#define GPIO_HWNUM_VALID(chip, hwgpio) (hwgpio >= 0 && hwgpio < chip->ngpio)
 
 static LIST_HEAD(gpio_chips);
 
@@ -211,16 +211,16 @@ static int gpiochip_find_base(int ngpio)
 static int gpiod_get_direction(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
-	unsigned		offset;
+	unsigned		hwgpio;
 	int			status = -EINVAL;
 
 	chip = gpiod_to_chip(desc);
-	offset = gpio_chip_hwgpio(desc);
+	hwgpio = gpio_chip_hwgpio(desc);
 
 	if (!chip->get_direction)
 		return status;
 
-	status = chip->get_direction(chip, offset);
+	status = chip->get_direction(chip, hwgpio);
 	if (status > 0) {
 		/* GPIOF_DIR_IN, or other positive */
 		status = 1;
@@ -756,7 +756,7 @@ static int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 	int			status;
 	const char		*ioname = NULL;
 	struct device		*dev;
-	int			offset;
+	int			hwgpio;
 
 	/* can't export until sysfs is available ... */
 	if (!gpio_class.p) {
@@ -787,9 +787,9 @@ static int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 		direction_may_change = false;
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	offset = gpio_chip_hwgpio(desc);
-	if (desc->chip->names && desc->chip->names[offset])
-		ioname = desc->chip->names[offset];
+	hwgpio = gpio_chip_hwgpio(desc);
+	if (desc->chip->names && desc->chip->names[hwgpio])
+		ioname = desc->chip->names[hwgpio];
 
 	dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
 			    desc, ioname ? ioname : "gpio%u",
@@ -1596,7 +1596,7 @@ const char *gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_desc *desc;
 
-	if (!GPIO_OFFSET_VALID(chip, offset))
+	if (!GPIO_HWNUM_VALID(chip, offset))
 		return NULL;
 
 	desc = &chip->desc[offset];
@@ -1626,7 +1626,7 @@ static int gpiod_direction_input(struct gpio_desc *desc)
 	unsigned long		flags;
 	struct gpio_chip	*chip;
 	int			status = -EINVAL;
-	int			offset;
+	int			hwgpio;
 
 	if (!desc) {
 		pr_warn("%s: invalid GPIO\n", __func__);
@@ -1648,9 +1648,9 @@ static int gpiod_direction_input(struct gpio_desc *desc)
 
 	might_sleep_if(chip->can_sleep);
 
-	offset = gpio_chip_hwgpio(desc);
+	hwgpio = gpio_chip_hwgpio(desc);
 	if (status) {
-		status = chip->request(chip, offset);
+		status = chip->request(chip, hwgpio);
 		if (status < 0) {
 			pr_debug("GPIO-%d: chip request fail, %d\n",
 				desc_to_gpio(desc), status);
@@ -1661,7 +1661,7 @@ static int gpiod_direction_input(struct gpio_desc *desc)
 		}
 	}
 
-	status = chip->direction_input(chip, offset);
+	status = chip->direction_input(chip, hwgpio);
 	if (status == 0)
 		clear_bit(FLAG_IS_OUT, &desc->flags);
 
@@ -1687,7 +1687,7 @@ static int gpiod_direction_output(struct gpio_desc *desc, int value)
 	unsigned long		flags;
 	struct gpio_chip	*chip;
 	int			status = -EINVAL;
-	int offset;
+	int			hwgpio;
 
 	if (!desc) {
 		pr_warn("%s: invalid GPIO\n", __func__);
@@ -1717,9 +1717,9 @@ static int gpiod_direction_output(struct gpio_desc *desc, int value)
 
 	might_sleep_if(chip->can_sleep);
 
-	offset = gpio_chip_hwgpio(desc);
+	hwgpio = gpio_chip_hwgpio(desc);
 	if (status) {
-		status = chip->request(chip, offset);
+		status = chip->request(chip, hwgpio);
 		if (status < 0) {
 			pr_debug("GPIO-%d: chip request fail, %d\n",
 				desc_to_gpio(desc), status);
@@ -1730,7 +1730,7 @@ static int gpiod_direction_output(struct gpio_desc *desc, int value)
 		}
 	}
 
-	status = chip->direction_output(chip, offset, value);
+	status = chip->direction_output(chip, hwgpio, value);
 	if (status == 0)
 		set_bit(FLAG_IS_OUT, &desc->flags);
 	trace_gpio_value(desc_to_gpio(desc), 0, value);
@@ -1761,7 +1761,7 @@ static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 	unsigned long		flags;
 	struct gpio_chip	*chip;
 	int			status = -EINVAL;
-	int			offset;
+	int			hwgpio;
 
 	if (!desc) {
 		pr_warn("%s: invalid GPIO\n", __func__);
@@ -1784,8 +1784,8 @@ static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 
 	might_sleep_if(chip->can_sleep);
 
-	offset = gpio_chip_hwgpio(desc);
-	return chip->set_debounce(chip, offset, debounce);
+	hwgpio = gpio_chip_hwgpio(desc);
+	return chip->set_debounce(chip, hwgpio, debounce);
 
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -1837,15 +1837,15 @@ static int gpiod_get_value(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
-	int offset;
+	int hwgpio;
 
 	if (!desc)
 		return 0;
 	chip = desc->chip;
-	offset = gpio_chip_hwgpio(desc);
+	hwgpio = gpio_chip_hwgpio(desc);
 	/* Should be using gpio_get_value_cansleep() */
 	WARN_ON(chip->can_sleep);
-	value = chip->get ? chip->get(chip, offset) : 0;
+	value = chip->get ? chip->get(chip, hwgpio) : 0;
 	trace_gpio_value(desc_to_gpio(desc), 1, value);
 	return value;
 }
@@ -1866,14 +1866,14 @@ static void _gpio_set_open_drain_value(struct gpio_desc *desc, int value)
 {
 	int err = 0;
 	struct gpio_chip *chip = desc->chip;
-	int offset = gpio_chip_hwgpio(desc);
+	int hwgpio = gpio_chip_hwgpio(desc);
 
 	if (value) {
-		err = chip->direction_input(chip, offset);
+		err = chip->direction_input(chip, hwgpio);
 		if (!err)
 			clear_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
-		err = chip->direction_output(chip, offset, 0);
+		err = chip->direction_output(chip, hwgpio, 0);
 		if (!err)
 			set_bit(FLAG_IS_OUT, &desc->flags);
 	}
@@ -1893,14 +1893,14 @@ static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
 {
 	int err = 0;
 	struct gpio_chip *chip = desc->chip;
-	int offset = gpio_chip_hwgpio(desc);
+	int hwgpio = gpio_chip_hwgpio(desc);
 
 	if (value) {
-		err = chip->direction_output(chip, offset, 1);
+		err = chip->direction_output(chip, hwgpio, 1);
 		if (!err)
 			set_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
-		err = chip->direction_input(chip, offset);
+		err = chip->direction_input(chip, hwgpio);
 		if (!err)
 			clear_bit(FLAG_IS_OUT, &desc->flags);
 	}
@@ -1977,13 +1977,13 @@ EXPORT_SYMBOL_GPL(__gpio_cansleep);
 static int gpiod_to_irq(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
-	int			offset;
+	int			hwgpio;
 
 	if (!desc)
 		return -EINVAL;
 	chip = desc->chip;
-	offset = gpio_chip_hwgpio(desc);
-	return chip->to_irq ? chip->to_irq(chip, offset) : -ENXIO;
+	hwgpio = gpio_chip_hwgpio(desc);
+	return chip->to_irq ? chip->to_irq(chip, hwgpio) : -ENXIO;
 }
 
 int __gpio_to_irq(unsigned gpio)
@@ -2001,14 +2001,14 @@ static int gpiod_get_value_cansleep(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
-	int offset;
+	int hwgpio;
 
 	might_sleep_if(extra_checks);
 	if (!desc)
 		return 0;
 	chip = desc->chip;
-	offset = gpio_chip_hwgpio(desc);
-	value = chip->get ? chip->get(chip, offset) : 0;
+	hwgpio = gpio_chip_hwgpio(desc);
+	value = chip->get ? chip->get(chip, hwgpio) : 0;
 	trace_gpio_value(desc_to_gpio(desc), 1, value);
 	return value;
 }
-- 
1.8.1.3

