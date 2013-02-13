Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3BMHCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:02:13 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40625 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3BMHCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:02:10 -0500
From: Alexandre Courbot <gnurou@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/4] gpiolib: use const parameters when possible
Date: Wed, 13 Feb 2013 16:03:00 +0900
Message-Id: <1360738983-22436-3-git-send-email-gnurou@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Courbot <acourbot@nvidia.com>

Constify descriptor parameter of gpiod_* functions for those that
should obviously not modify it. This includes value or direction get,
cansleep, and IRQ number query.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8a2cf9c..ad6df6b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -88,13 +88,14 @@ static int gpiod_request(struct gpio_desc *desc, const char *label);
 static void gpiod_free(struct gpio_desc *desc);
 static int gpiod_direction_input(struct gpio_desc *desc);
 static int gpiod_direction_output(struct gpio_desc *desc, int value);
+static int gpiod_get_direction(const struct gpio_desc *desc);
 static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
-static int gpiod_get_value_cansleep(struct gpio_desc *desc);
+static int gpiod_get_value_cansleep(const struct gpio_desc *desc);
 static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
-static int gpiod_get_value(struct gpio_desc *desc);
+static int gpiod_get_value(const struct gpio_desc *desc);
 static void gpiod_set_value(struct gpio_desc *desc, int value);
-static int gpiod_cansleep(struct gpio_desc *desc);
-static int gpiod_to_irq(struct gpio_desc *desc);
+static int gpiod_cansleep(const struct gpio_desc *desc);
+static int gpiod_to_irq(const struct gpio_desc *desc);
 static int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
 static int gpiod_export_link(struct device *dev, const char *name,
 			     struct gpio_desc *desc);
@@ -172,7 +173,7 @@ static int gpio_ensure_requested(struct gpio_desc *desc)
 }
 
 /* caller holds gpio_lock *OR* gpio is marked as requested */
-static struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc)
+static struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc)
 {
 	return desc ? desc->chip : NULL;
 }
@@ -207,7 +208,7 @@ static int gpiochip_find_base(int ngpio)
 }
 
 /* caller ensures gpio is valid and requested, chip->get_direction may sleep  */
-static int gpiod_get_direction(struct gpio_desc *desc)
+static int gpiod_get_direction(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	unsigned		offset;
@@ -223,11 +224,13 @@ static int gpiod_get_direction(struct gpio_desc *desc)
 	if (status > 0) {
 		/* GPIOF_DIR_IN, or other positive */
 		status = 1;
-		clear_bit(FLAG_IS_OUT, &desc->flags);
+		/* FLAG_IS_OUT is just a cache of the result of get_direction(),
+		 * so it does not affect constness per se */
+		clear_bit(FLAG_IS_OUT, &((struct gpio_desc *)desc)->flags);
 	}
 	if (status == 0) {
 		/* GPIOF_DIR_OUT */
-		set_bit(FLAG_IS_OUT, &desc->flags);
+		set_bit(FLAG_IS_OUT, &((struct gpio_desc *)desc)->flags);
 	}
 	return status;
 }
@@ -263,7 +266,7 @@ static DEFINE_MUTEX(sysfs_lock);
 static ssize_t gpio_direction_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -1818,7 +1821,7 @@ EXPORT_SYMBOL_GPL(gpio_set_debounce);
  * It returns the zero or nonzero value provided by the associated
  * gpio_chip.get() method; or zero if no such method is provided.
  */
-static int gpiod_get_value(struct gpio_desc *desc)
+static int gpiod_get_value(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
@@ -1936,7 +1939,7 @@ EXPORT_SYMBOL_GPL(__gpio_set_value);
  * This is used directly or indirectly to implement gpio_cansleep().  It
  * returns nonzero if access reading or writing the GPIO value can sleep.
  */
-static int gpiod_cansleep(struct gpio_desc *desc)
+static int gpiod_cansleep(const struct gpio_desc *desc)
 {
 	if (!desc)
 		return 0;
@@ -1959,7 +1962,7 @@ EXPORT_SYMBOL_GPL(__gpio_cansleep);
  * It returns the number of the IRQ signaled by this (input) GPIO,
  * or a negative errno.
  */
-static int gpiod_to_irq(struct gpio_desc *desc)
+static int gpiod_to_irq(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int			offset;
@@ -1982,7 +1985,7 @@ EXPORT_SYMBOL_GPL(__gpio_to_irq);
  * Common examples include ones connected to I2C or SPI chips.
  */
 
-static int gpiod_get_value_cansleep(struct gpio_desc *desc)
+static int gpiod_get_value_cansleep(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
-- 
1.8.1.3

