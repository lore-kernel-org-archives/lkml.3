Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbaJUVRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:17:53 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63210 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933708AbaJUVRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:17:47 -0400
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
Subject: [PATCH v6 11/12] leds: leds-gpio: Make use of device property API
Date: Tue, 21 Oct 2014 23:35:19 +0200
Message-ID: <1594102.O17O2sudrH@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <13750506.S2yVlRRDa2@vostro.rjw.lan>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make use of device property API in this driver so that both OF and ACPI
based system can use the same driver.

This change contains material from Max Eliaser and Mika Westerberg.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Changes from v5:
- Use devm_get_gpiod_from_child() with 2 arguments (dev, child).

---
 drivers/leds/leds-gpio.c |   62 ++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

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
@@ -171,40 +169,37 @@ static inline int sizeof_gpio_leds_priv(
 		(sizeof(struct gpio_led_data) * num_leds);
 }
 
-/* Code to create from OpenFirmware platform devices */
-#ifdef CONFIG_OF_GPIO
-static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
+static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node, *child;
+	struct device *dev = &pdev->dev;
+	struct fwnode_handle *child;
 	struct gpio_leds_priv *priv;
 	int count, ret;
 
-	/* count LEDs in this device, so we know how much to allocate */
-	count = of_get_available_child_count(np);
+	count = device_get_child_node_count(dev);
 	if (!count)
 		return ERR_PTR(-ENODEV);
 
-	for_each_available_child_of_node(np, child)
-		if (of_get_gpio(child, 0) == -EPROBE_DEFER)
-			return ERR_PTR(-EPROBE_DEFER);
-
-	priv = devm_kzalloc(&pdev->dev, sizeof_gpio_leds_priv(count),
-			GFP_KERNEL);
+	priv = devm_kzalloc(dev, sizeof_gpio_leds_priv(count), GFP_KERNEL);
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
 
-	for_each_available_child_of_node(np, child) {
+	device_for_each_child_node(dev, child) {
 		struct gpio_led led = {};
-		enum of_gpio_flags flags;
-		const char *state;
+		const char *state = NULL;
+
+		led.gpiod = devm_get_gpiod_from_child(dev, child);
+		if (IS_ERR(led.gpiod)) {
+			fwnode_handle_put(child);
+			goto err;
+		}
+
+		fwnode_property_read_string(child, "label", &led.name);
+		fwnode_property_read_string(child, "linux,default-trigger",
+					    &led.default_trigger);
 
-		led.gpio = of_get_gpio_flags(child, 0, &flags);
-		led.active_low = flags & OF_GPIO_ACTIVE_LOW;
-		led.name = of_get_property(child, "label", NULL) ? : child->name;
-		led.default_trigger =
-			of_get_property(child, "linux,default-trigger", NULL);
-		state = of_get_property(child, "default-state", NULL);
-		if (state) {
+		if (!fwnode_property_read_string(child, "linux,default_state",
+						 &state)) {
 			if (!strcmp(state, "keep"))
 				led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
 			else if (!strcmp(state, "on"))
@@ -213,13 +208,13 @@ static struct gpio_leds_priv *gpio_leds_
 				led.default_state = LEDS_GPIO_DEFSTATE_OFF;
 		}
 
-		if (of_get_property(child, "retain-state-suspended", NULL))
+		if (fwnode_property_present(child, "retain-state-suspended"))
 			led.retain_state_suspended = 1;
 
 		ret = create_gpio_led(&led, &priv->leds[priv->num_leds++],
-				      &pdev->dev, NULL);
+				      dev, NULL);
 		if (ret < 0) {
-			of_node_put(child);
+			fwnode_handle_put(child);
 			goto err;
 		}
 	}
@@ -238,13 +233,6 @@ static const struct of_device_id of_gpio
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
@@ -273,7 +261,7 @@ static int gpio_led_probe(struct platfor
 			}
 		}
 	} else {
-		priv = gpio_leds_create_of(pdev);
+		priv = gpio_leds_create(pdev);
 		if (IS_ERR(priv))
 			return PTR_ERR(priv);
 	}
@@ -300,7 +288,7 @@ static struct platform_driver gpio_led_d
 	.driver		= {
 		.name	= "leds-gpio",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(of_gpio_leds_match),
+		.of_match_table = of_gpio_leds_match,
 	},
 };
 

