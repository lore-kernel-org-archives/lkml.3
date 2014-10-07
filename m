Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaJGAAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:00:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53106 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752472AbaJFX7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 19:59:48 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 08/13] leds: leds-gpio: Add support for GPIO descriptors
Date: Tue, 07 Oct 2014 02:16:14 +0200
Message-ID: <3782316.XCobsi8jq3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2660541.BycO7TFnA2@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

GPIO descriptors are the preferred way over legacy GPIO numbers
nowadays. Convert the driver to use GPIO descriptors internally but
still allow passing legacy GPIO numbers from platform data to support
existing platforms.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/leds/leds-gpio.c | 80 +++++++++++++++++++++++++++---------------------
 include/linux/leds.h     |  1 +
 2 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 57ff20f..c84e913 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/leds.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -24,11 +25,10 @@
 
 struct gpio_led_data {
 	struct led_classdev cdev;
-	unsigned gpio;
+	struct gpio_desc *gpiod;
 	struct work_struct work;
 	u8 new_level;
 	u8 can_sleep;
-	u8 active_low;
 	u8 blinking;
 	int (*platform_gpio_blink_set)(unsigned gpio, int state,
 			unsigned long *delay_on, unsigned long *delay_off);
@@ -40,12 +40,16 @@ static void gpio_led_work(struct work_struct *work)
 		container_of(work, struct gpio_led_data, work);
 
 	if (led_dat->blinking) {
-		led_dat->platform_gpio_blink_set(led_dat->gpio,
-						 led_dat->new_level,
-						 NULL, NULL);
+		int gpio = desc_to_gpio(led_dat->gpiod);
+		int level = led_dat->new_level;
+
+		if (gpiod_is_active_low(led_dat->gpiod))
+			level = !level;
+
+		led_dat->platform_gpio_blink_set(gpio, level, NULL, NULL);
 		led_dat->blinking = 0;
 	} else
-		gpio_set_value_cansleep(led_dat->gpio, led_dat->new_level);
+		gpiod_set_value_cansleep(led_dat->gpiod, led_dat->new_level);
 }
 
 static void gpio_led_set(struct led_classdev *led_cdev,
@@ -60,9 +64,6 @@ static void gpio_led_set(struct led_classdev *led_cdev,
 	else
 		level = 1;
 
-	if (led_dat->active_low)
-		level = !level;
-
 	/* Setting GPIOs with I2C/etc requires a task context, and we don't
 	 * seem to have a reliable way to know if we're already in one; so
 	 * let's just assume the worst.
@@ -72,11 +73,16 @@ static void gpio_led_set(struct led_classdev *led_cdev,
 		schedule_work(&led_dat->work);
 	} else {
 		if (led_dat->blinking) {
-			led_dat->platform_gpio_blink_set(led_dat->gpio, level,
-							 NULL, NULL);
+			int gpio = desc_to_gpio(led_dat->gpiod);
+
+			if (gpiod_is_active_low(led_dat->gpiod))
+				level = !level;
+
+			led_dat->platform_gpio_blink_set(gpio, level, NULL,
+							 NULL);
 			led_dat->blinking = 0;
 		} else
-			gpio_set_value(led_dat->gpio, level);
+			gpiod_set_value(led_dat->gpiod, level);
 	}
 }
 
@@ -85,9 +91,10 @@ static int gpio_blink_set(struct led_classdev *led_cdev,
 {
 	struct gpio_led_data *led_dat =
 		container_of(led_cdev, struct gpio_led_data, cdev);
+	int gpio = desc_to_gpio(led_dat->gpiod);
 
 	led_dat->blinking = 1;
-	return led_dat->platform_gpio_blink_set(led_dat->gpio, GPIO_LED_BLINK,
+	return led_dat->platform_gpio_blink_set(gpio, GPIO_LED_BLINK,
 						delay_on, delay_off);
 }
 
@@ -97,24 +104,33 @@ static int create_gpio_led(const struct gpio_led *template,
 {
 	int ret, state;
 
-	led_dat->gpio = -1;
+	if (!template->gpiod) {
+		unsigned long flags = 0;
 
-	/* skip leds that aren't available */
-	if (!gpio_is_valid(template->gpio)) {
-		dev_info(parent, "Skipping unavailable LED gpio %d (%s)\n",
-				template->gpio, template->name);
-		return 0;
-	}
+		/* skip leds that aren't available */
+		if (!gpio_is_valid(template->gpio)) {
+			dev_info(parent, "Skipping unavailable LED gpio %d (%s)\n",
+					template->gpio, template->name);
+			return 0;
+		}
 
-	ret = devm_gpio_request(parent, template->gpio, template->name);
-	if (ret < 0)
-		return ret;
+		if (template->active_low)
+			flags |= GPIOF_ACTIVE_LOW;
+
+		ret = devm_gpio_request_one(parent, template->gpio, flags,
+					    template->name);
+		if (ret < 0)
+			return ret;
+
+		led_dat->gpiod = gpio_to_desc(template->gpio);
+		if (IS_ERR(led_dat->gpiod))
+			return PTR_ERR(led_dat->gpiod);
+	}
 
 	led_dat->cdev.name = template->name;
 	led_dat->cdev.default_trigger = template->default_trigger;
-	led_dat->gpio = template->gpio;
-	led_dat->can_sleep = gpio_cansleep(template->gpio);
-	led_dat->active_low = template->active_low;
+	led_dat->gpiod = template->gpiod;
+	led_dat->can_sleep = gpiod_cansleep(template->gpiod);
 	led_dat->blinking = 0;
 	if (blink_set) {
 		led_dat->platform_gpio_blink_set = blink_set;
@@ -122,30 +138,24 @@ static int create_gpio_led(const struct gpio_led *template,
 	}
 	led_dat->cdev.brightness_set = gpio_led_set;
 	if (template->default_state == LEDS_GPIO_DEFSTATE_KEEP)
-		state = !!gpio_get_value_cansleep(led_dat->gpio) ^ led_dat->active_low;
+		state = !!gpiod_get_value_cansleep(led_dat->gpiod);
 	else
 		state = (template->default_state == LEDS_GPIO_DEFSTATE_ON);
 	led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;
 	if (!template->retain_state_suspended)
 		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
-	ret = gpio_direction_output(led_dat->gpio, led_dat->active_low ^ state);
+	ret = gpiod_direction_output(led_dat->gpiod, state);
 	if (ret < 0)
 		return ret;
 
 	INIT_WORK(&led_dat->work, gpio_led_work);
 
-	ret = led_classdev_register(parent, &led_dat->cdev);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return led_classdev_register(parent, &led_dat->cdev);
 }
 
 static void delete_gpio_led(struct gpio_led_data *led)
 {
-	if (!gpio_is_valid(led->gpio))
-		return;
 	led_classdev_unregister(&led->cdev);
 	cancel_work_sync(&led->work);
 }
diff --git a/include/linux/leds.h b/include/linux/leds.h
index e436864..879a113 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -246,6 +246,7 @@ struct led_platform_data {
 struct gpio_led {
 	const char *name;
 	const char *default_trigger;
+	struct gpio_desc *gpiod;
 	unsigned 	gpio;
 	unsigned	active_low : 1;
 	unsigned	retain_state_suspended : 1;
-- 
1.9.3


