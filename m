Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaJACGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:06:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49942 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750972AbaJACDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:03:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: linux-kernel@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH v3 09/15] leds: leds-gpio: Make use of device property API
Date: Wed, 01 Oct 2014 04:16:25 +0200
Message-ID: <83082601.pjR7TmeO0m@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1852462.V1jlbi8OPt@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Eliaser <max@meliaserlow.dyndns.tv>

Make use of device property API in this driver so that both OF and ACPI
based system can use the same driver.

Signed-off-by: Max Eliaser <max.eliaser@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/leds/leds-gpio.c |   99 +++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 57 deletions(-)

Index: linux-pm/drivers/leds/leds-gpio.c
===================================================================
--- linux-pm.orig/drivers/leds/leds-gpio.c
+++ linux-pm/drivers/leds/leds-gpio.c
@@ -15,13 +15,11 @@
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/leds.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/of_gpio.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/property.h>
 
 struct gpio_led_data {
 	struct led_classdev cdev;
@@ -171,65 +169,59 @@ static inline int sizeof_gpio_leds_priv(
 		(sizeof(struct gpio_led_data) * num_leds);
 }
 
-/* Code to create from OpenFirmware platform devices */
-#ifdef CONFIG_OF_GPIO
-static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
+static int gpio_leds_create_led(struct device *dev, void *child, void *data)
+{
+	struct gpio_leds_priv *priv = data;
+	struct gpio_led led = {};
+	const char *state = NULL;
+
+	led.gpiod = devm_get_named_gpiod_from_child(dev, child, "gpios", 0);
+	if (IS_ERR(led.gpiod))
+		return PTR_ERR(led.gpiod);
+
+	device_child_property_read_string(dev, child, "label", &led.name);
+	device_child_property_read_string(dev, child, "linux,default-trigger",
+					  &led.default_trigger);
+
+	device_child_property_read_string(dev, child, "linux,default_state",
+					  &state);
+	if (state) {
+		if (!strcmp(state, "keep"))
+			led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
+		else if (!strcmp(state, "on"))
+			led.default_state = LEDS_GPIO_DEFSTATE_ON;
+		else
+			led.default_state = LEDS_GPIO_DEFSTATE_OFF;
+	}
+
+	if (!device_get_child_property(dev, child, "retain-state-suspended", NULL))
+		led.retain_state_suspended = 1;
+
+	return create_gpio_led(&led, &priv->leds[priv->num_leds++], dev, NULL);
+}
+
+static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node, *child;
 	struct gpio_leds_priv *priv;
-	int count, ret;
+	int ret, count;
 
-	/* count LEDs in this device, so we know how much to allocate */
-	count = of_get_available_child_count(np);
+	count = device_get_child_node_count(&pdev->dev);
 	if (!count)
 		return ERR_PTR(-ENODEV);
 
-	for_each_available_child_of_node(np, child)
-		if (of_get_gpio(child, 0) == -EPROBE_DEFER)
-			return ERR_PTR(-EPROBE_DEFER);
-
 	priv = devm_kzalloc(&pdev->dev, sizeof_gpio_leds_priv(count),
 			GFP_KERNEL);
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
 
-	for_each_available_child_of_node(np, child) {
-		struct gpio_led led = {};
-		enum of_gpio_flags flags;
-		const char *state;
-
-		led.gpio = of_get_gpio_flags(child, 0, &flags);
-		led.active_low = flags & OF_GPIO_ACTIVE_LOW;
-		led.name = of_get_property(child, "label", NULL) ? : child->name;
-		led.default_trigger =
-			of_get_property(child, "linux,default-trigger", NULL);
-		state = of_get_property(child, "default-state", NULL);
-		if (state) {
-			if (!strcmp(state, "keep"))
-				led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
-			else if (!strcmp(state, "on"))
-				led.default_state = LEDS_GPIO_DEFSTATE_ON;
-			else
-				led.default_state = LEDS_GPIO_DEFSTATE_OFF;
-		}
-
-		if (of_get_property(child, "retain-state-suspended", NULL))
-			led.retain_state_suspended = 1;
-
-		ret = create_gpio_led(&led, &priv->leds[priv->num_leds++],
-				      &pdev->dev, NULL);
-		if (ret < 0) {
-			of_node_put(child);
-			goto err;
-		}
+	ret = device_for_each_child_node(&pdev->dev, gpio_leds_create_led, priv);
+	if (ret) {
+		for (count = priv->num_leds - 2; count >= 0; count--)
+			delete_gpio_led(&priv->leds[count]);
+		return ERR_PTR(ret);
 	}
 
 	return priv;
-
-err:
-	for (count = priv->num_leds - 2; count >= 0; count--)
-		delete_gpio_led(&priv->leds[count]);
-	return ERR_PTR(-ENODEV);
 }
 
 static const struct of_device_id of_gpio_leds_match[] = {
@@ -238,13 +230,6 @@ static const struct of_device_id of_gpio
 };
 
 MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
-#else /* CONFIG_OF_GPIO */
-static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
-{
-	return ERR_PTR(-ENODEV);
-}
-#endif /* CONFIG_OF_GPIO */
-
 
 static int gpio_led_probe(struct platform_device *pdev)
 {
@@ -273,7 +258,7 @@ static int gpio_led_probe(struct platfor
 			}
 		}
 	} else {
-		priv = gpio_leds_create_of(pdev);
+		priv = gpio_leds_create(pdev);
 		if (IS_ERR(priv))
 			return PTR_ERR(priv);
 	}
@@ -300,7 +285,7 @@ static struct platform_driver gpio_led_d
 	.driver		= {
 		.name	= "leds-gpio",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(of_gpio_leds_match),
+		.of_match_table = of_gpio_leds_match,
 	},
 };
 

