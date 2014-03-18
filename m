Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaCRKr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:47:26 -0400
Received: from access.ducie-dc1.codethink.co.uk ([185.25.241.217]:50968 "EHLO
	rt.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753407AbaCRKrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:47:25 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 06:47:25 EDT
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpiolib: check if gpio_desc pointer is error or NULL
Date: Tue, 18 Mar 2014 11:41:30 +0100
Message-Id: <1395139290-4207-1-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the gpiod_ calls take a pointer to a gpio_desc as their
argument but only check to see if it is NULL to validate the
input.

Calls such as devm_gpiod_get() return an error-pointer if they
fail, so doing the following will not work:

	gpio = devm_gpiod_get(...);
	gpiod_direction_output(gpio, 0);

The sequence produces an OOPS like:

	Unable to handle kernel paging request at virtual address fffffffe

Change all calls that check for !desc to use IS_ERR_OR_NULL() to
avoid these issues.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpio/gpiolib.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 50c4922..e69ac5e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -817,7 +817,7 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 		return -ENOENT;
 	}
 
-	if (!desc) {
+	if (IS_ERR_OR_NULL(desc)) {
 		pr_debug("%s: invalid gpio descriptor\n", __func__);
 		return -EINVAL;
 	}
@@ -903,7 +903,7 @@ int gpiod_export_link(struct device *dev, const char *name,
 {
 	int			status = -EINVAL;
 
-	if (!desc) {
+	if (IS_ERR_OR_NULL(desc)) {
 		pr_warn("%s: invalid GPIO\n", __func__);
 		return -EINVAL;
 	}
@@ -986,7 +986,7 @@ void gpiod_unexport(struct gpio_desc *desc)
 	int			status = 0;
 	struct device		*dev = NULL;
 
-	if (!desc) {
+	if (IS_ERR_OR_NULL(desc)) {
 		pr_warn("%s: invalid GPIO\n", __func__);
 		return;
 	}
@@ -1463,7 +1463,7 @@ static int gpiod_request(struct gpio_desc *desc, const char *label)
 	int			status = -EPROBE_DEFER;
 	unsigned long		flags;
 
-	if (!desc) {
+	if (IS_ERR_OR_NULL(desc)) {
 		pr_warn("%s: invalid GPIO\n", __func__);
 		return -EINVAL;
 	}
@@ -1529,7 +1529,7 @@ static void gpiod_free(struct gpio_desc *desc)
 
 	might_sleep();
 
-	if (!desc) {
+	if (IS_ERR_OR_NULL(desc)) {
 		WARN_ON(extra_checks);
 		return;
 	}
@@ -1703,7 +1703,7 @@ int gpiod_direction_input(struct gpio_desc *desc)
 	int			status = -EINVAL;
 	int			offset;
 
-	if (!desc || !desc->chip) {
+	if (IS_ERR_OR_NULL(desc) || !desc->chip) {
 		pr_warn("%s: invalid GPIO\n", __func__);
 		return -EINVAL;
 	}
@@ -1773,7 +1773,7 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
 	int			status = -EINVAL;
 	int offset;
 
-	if (!desc || !desc->chip) {
+	if (IS_ERR_OR_NULL(desc) || !desc->chip) {
 		pr_warn("%s: invalid GPIO\n", __func__);
 		return -EINVAL;
 	}
@@ -1857,7 +1857,7 @@ int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 	int			status = -EINVAL;
 	int			offset;
 
-	if (!desc || !desc->chip) {
+	if (IS_ERR_OR_NULL(desc) || !desc->chip) {
 		pr_warn("%s: invalid GPIO\n", __func__);
 		return -EINVAL;
 	}
@@ -1953,7 +1953,7 @@ static int _gpiod_get_raw_value(const struct gpio_desc *desc)
  */
 int gpiod_get_raw_value(const struct gpio_desc *desc)
 {
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return 0;
 	/* Should be using gpio_get_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
@@ -1974,7 +1974,7 @@ EXPORT_SYMBOL_GPL(gpiod_get_raw_value);
 int gpiod_get_value(const struct gpio_desc *desc)
 {
 	int value;
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return 0;
 	/* Should be using gpio_get_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
@@ -2068,7 +2068,7 @@ static void _gpiod_set_raw_value(struct gpio_desc *desc, int value)
  */
 void gpiod_set_raw_value(struct gpio_desc *desc, int value)
 {
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return;
 	/* Should be using gpio_set_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
@@ -2089,7 +2089,7 @@ EXPORT_SYMBOL_GPL(gpiod_set_raw_value);
  */
 void gpiod_set_value(struct gpio_desc *desc, int value)
 {
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return;
 	/* Should be using gpio_set_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
@@ -2106,7 +2106,7 @@ EXPORT_SYMBOL_GPL(gpiod_set_value);
  */
 int gpiod_cansleep(const struct gpio_desc *desc)
 {
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return 0;
 	return desc->chip->can_sleep;
 }
@@ -2124,7 +2124,7 @@ int gpiod_to_irq(const struct gpio_desc *desc)
 	struct gpio_chip	*chip;
 	int			offset;
 
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return -EINVAL;
 	chip = desc->chip;
 	offset = gpio_chip_hwgpio(desc);
@@ -2144,7 +2144,7 @@ EXPORT_SYMBOL_GPL(gpiod_to_irq);
  */
 int gpiod_lock_as_irq(struct gpio_desc *desc)
 {
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return -EINVAL;
 
 	if (test_bit(FLAG_IS_OUT, &desc->flags)) {
@@ -2199,7 +2199,7 @@ EXPORT_SYMBOL_GPL(gpio_unlock_as_irq);
 int gpiod_get_raw_value_cansleep(const struct gpio_desc *desc)
 {
 	might_sleep_if(extra_checks);
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return 0;
 	return _gpiod_get_raw_value(desc);
 }
@@ -2219,7 +2219,7 @@ int gpiod_get_value_cansleep(const struct gpio_desc *desc)
 	int value;
 
 	might_sleep_if(extra_checks);
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return 0;
 
 	value = _gpiod_get_raw_value(desc);
@@ -2243,7 +2243,7 @@ EXPORT_SYMBOL_GPL(gpiod_get_value_cansleep);
 void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value)
 {
 	might_sleep_if(extra_checks);
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return;
 	_gpiod_set_raw_value(desc, value);
 }
@@ -2262,7 +2262,7 @@ EXPORT_SYMBOL_GPL(gpiod_set_raw_value_cansleep);
 void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 {
 	might_sleep_if(extra_checks);
-	if (!desc)
+	if (IS_ERR_OR_NULL(desc))
 		return;
 
 	if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
-- 
1.9.0

