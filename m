Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbaJUVVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:21:53 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53456 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933714AbaJUVRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:17:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Subject: [PATCH v6 08/12] input: gpio_keys_polled: Add support for GPIO descriptors
Date: Tue, 21 Oct 2014 23:22:24 +0200
Message-ID: <2435915.kKZ6aEQ0cG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <13750506.S2yVlRRDa2@vostro.rjw.lan>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

GPIO descriptors are the preferred way over legacy GPIO numbers
nowadays. Convert the driver to use GPIO descriptors internally but
still allow passing legacy GPIO numbers from platform data to support
existing platforms.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/input/keyboard/gpio_keys_polled.c | 39 +++++++++++++++++++++----------
 include/linux/gpio_keys.h                 |  3 +++
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 432d363..b7a514c 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -23,6 +23,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio_keys.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -51,15 +52,14 @@ static void gpio_keys_polled_check_state(struct input_dev *input,
 	int state;
 
 	if (bdata->can_sleep)
-		state = !!gpio_get_value_cansleep(button->gpio);
+		state = !!gpiod_get_value_cansleep(button->gpiod);
 	else
-		state = !!gpio_get_value(button->gpio);
+		state = !!gpiod_get_value(button->gpiod);
 
 	if (state != bdata->last_state) {
 		unsigned int type = button->type ?: EV_KEY;
 
-		input_event(input, type, button->code,
-			    !!(state ^ button->active_low));
+		input_event(input, type, button->code, state);
 		input_sync(input);
 		bdata->count = 0;
 		bdata->last_state = state;
@@ -259,7 +259,6 @@ static int gpio_keys_polled_probe(struct platform_device *pdev)
 	for (i = 0; i < pdata->nbuttons; i++) {
 		struct gpio_keys_button *button = &pdata->buttons[i];
 		struct gpio_keys_button_data *bdata = &bdev->data[i];
-		unsigned int gpio = button->gpio;
 		unsigned int type = button->type ?: EV_KEY;
 
 		if (button->wakeup) {
@@ -267,15 +266,31 @@ static int gpio_keys_polled_probe(struct platform_device *pdev)
 			return -EINVAL;
 		}
 
-		error = devm_gpio_request_one(&pdev->dev, gpio, GPIOF_IN,
-					      button->desc ? : DRV_NAME);
-		if (error) {
-			dev_err(dev, "unable to claim gpio %u, err=%d\n",
-				gpio, error);
-			return error;
+		/*
+		 * Legacy GPIO number so request the GPIO here and
+		 * convert it to descriptor.
+		 */
+		if (!button->gpiod && gpio_is_valid(button->gpio)) {
+			unsigned flags = 0;
+
+			if (button->active_low)
+				flags |= GPIOF_ACTIVE_LOW;
+
+			error = devm_gpio_request_one(&pdev->dev, button->gpio,
+					flags, button->desc ? : DRV_NAME);
+			if (error) {
+				dev_err(dev, "unable to claim gpio %u, err=%d\n",
+					button->gpio, error);
+				return error;
+			}
+
+			button->gpiod = gpio_to_desc(button->gpio);
 		}
 
-		bdata->can_sleep = gpio_cansleep(gpio);
+		if (IS_ERR(button->gpiod))
+			return PTR_ERR(button->gpiod);
+
+		bdata->can_sleep = gpiod_cansleep(button->gpiod);
 		bdata->last_state = -1;
 		bdata->threshold = DIV_ROUND_UP(button->debounce_interval,
 						pdata->poll_interval);
diff --git a/include/linux/gpio_keys.h b/include/linux/gpio_keys.h
index 8b62246..ee2d8c6 100644
--- a/include/linux/gpio_keys.h
+++ b/include/linux/gpio_keys.h
@@ -2,6 +2,7 @@
 #define _GPIO_KEYS_H
 
 struct device;
+struct gpio_desc;
 
 /**
  * struct gpio_keys_button - configuration parameters
@@ -17,6 +18,7 @@ struct device;
  *			disable button via sysfs
  * @value:		axis value for %EV_ABS
  * @irq:		Irq number in case of interrupt keys
+ * @gpiod:		GPIO descriptor
  */
 struct gpio_keys_button {
 	unsigned int code;
@@ -29,6 +31,7 @@ struct gpio_keys_button {
 	bool can_disable;
 	int value;
 	unsigned int irq;
+	struct gpio_desc *gpiod;
 };
 
 /**
-- 
1.9.3


