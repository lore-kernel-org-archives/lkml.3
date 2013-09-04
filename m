Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762439Ab3IDLag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 07:30:36 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19849 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762387Ab3IDLa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 07:30:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Sep 2013 04:30:28 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 1/5] gpiolib: factorize gpiod_get/set functions
Date: Wed, 4 Sep 2013 20:29:25 +0900
Message-ID: <1378294169-22661-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiod_get/set functions share common code between their regular and
cansleep variants. The exporting of the gpiod interface will make
the situation worse. This patch factorizes the common code to avoid code
redundancy.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 72 +++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index ff0fd65..6608bb8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1826,6 +1826,19 @@ EXPORT_SYMBOL_GPL(gpio_set_debounce);
  * that the GPIO was actually requested.
  */
 
+static int _gpiod_get_value(const struct gpio_desc *desc)
+{
+	struct gpio_chip	*chip;
+	int value;
+	int offset;
+
+	chip = desc->chip;
+	offset = gpio_chip_hwgpio(desc);
+	value = chip->get ? chip->get(chip, offset) : 0;
+	trace_gpio_value(desc_to_gpio(desc), 1, value);
+	return value;
+}
+
 /**
  * __gpio_get_value() - return a gpio's value
  * @gpio: gpio whose value will be returned
@@ -1837,19 +1850,11 @@ EXPORT_SYMBOL_GPL(gpio_set_debounce);
  */
 static int gpiod_get_value(const struct gpio_desc *desc)
 {
-	struct gpio_chip	*chip;
-	int value;
-	int offset;
-
 	if (!desc)
 		return 0;
-	chip = desc->chip;
-	offset = gpio_chip_hwgpio(desc);
 	/* Should be using gpio_get_value_cansleep() */
-	WARN_ON(chip->can_sleep);
-	value = chip->get ? chip->get(chip, offset) : 0;
-	trace_gpio_value(desc_to_gpio(desc), 1, value);
-	return value;
+	WARN_ON(desc->chip->can_sleep);
+	return _gpiod_get_value(desc);
 }
 
 int __gpio_get_value(unsigned gpio)
@@ -1912,6 +1917,20 @@ static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
 					__func__, desc_to_gpio(desc), err);
 }
 
+static void _gpiod_set_value(struct gpio_desc *desc, int value)
+{
+	struct gpio_chip	*chip;
+
+	chip = desc->chip;
+	trace_gpio_value(desc_to_gpio(desc), 0, value);
+	if (test_bit(FLAG_OPEN_DRAIN, &desc->flags))
+		_gpio_set_open_drain_value(desc, value);
+	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags))
+		_gpio_set_open_source_value(desc, value);
+	else
+		chip->set(chip, gpio_chip_hwgpio(desc), value);
+}
+
 /**
  * __gpio_set_value() - assign a gpio's value
  * @gpio: gpio whose value will be assigned
@@ -1923,20 +1942,12 @@ static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
  */
 static void gpiod_set_value(struct gpio_desc *desc, int value)
 {
-	struct gpio_chip	*chip;
 
 	if (!desc)
 		return;
-	chip = desc->chip;
 	/* Should be using gpio_set_value_cansleep() */
-	WARN_ON(chip->can_sleep);
-	trace_gpio_value(desc_to_gpio(desc), 0, value);
-	if (test_bit(FLAG_OPEN_DRAIN, &desc->flags))
-		_gpio_set_open_drain_value(desc, value);
-	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags))
-		_gpio_set_open_source_value(desc, value);
-	else
-		chip->set(chip, gpio_chip_hwgpio(desc), value);
+	WARN_ON(desc->chip->can_sleep);
+	_gpiod_set_value(desc, value);
 }
 
 void __gpio_set_value(unsigned gpio, int value)
@@ -2001,18 +2012,10 @@ EXPORT_SYMBOL_GPL(__gpio_to_irq);
 
 static int gpiod_get_value_cansleep(const struct gpio_desc *desc)
 {
-	struct gpio_chip	*chip;
-	int value;
-	int offset;
-
 	might_sleep_if(extra_checks);
 	if (!desc)
 		return 0;
-	chip = desc->chip;
-	offset = gpio_chip_hwgpio(desc);
-	value = chip->get ? chip->get(chip, offset) : 0;
-	trace_gpio_value(desc_to_gpio(desc), 1, value);
-	return value;
+	return _gpiod_get_value(desc);
 }
 
 int gpio_get_value_cansleep(unsigned gpio)
@@ -2023,19 +2026,10 @@ EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
 
 static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 {
-	struct gpio_chip	*chip;
-
 	might_sleep_if(extra_checks);
 	if (!desc)
 		return;
-	chip = desc->chip;
-	trace_gpio_value(desc_to_gpio(desc), 0, value);
-	if (test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
-		_gpio_set_open_drain_value(desc, value);
-	else if (test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
-		_gpio_set_open_source_value(desc, value);
-	else
-		chip->set(chip, gpio_chip_hwgpio(desc), value);
+	_gpiod_set_value(desc, value);
 }
 
 void gpio_set_value_cansleep(unsigned gpio, int value)
-- 
1.8.4

