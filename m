Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaHQGEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 02:04:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:19491 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaHQGEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 02:04:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,878,1400050800"; 
   d="scan'208";a="469518975"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 9/9] leds: leds-gpio: Make use of device property API
Date: Sun, 17 Aug 2014 09:04:19 +0300
Message-Id: <1408255459-17625-10-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0.rc1
In-Reply-To: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Eliaser <max.eliaser@intel.com>

Make use of device property API in this driver so that both OF and ACPI
based system can use the same driver.

Signed-off-by: Max Eliaser <max@meliaserlow.dyndns.tv>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/leds/leds-gpio.c | 130 +++++++++++++++++++++++++++++------------------
 1 file changed, 80 insertions(+), 50 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 57ff20fecf57..d7334b8a21ae 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/property.h>
 
 struct gpio_led_data {
 	struct led_classdev cdev;
@@ -161,75 +162,102 @@ static inline int sizeof_gpio_leds_priv(int num_leds)
 		(sizeof(struct gpio_led_data) * num_leds);
 }
 
-/* Code to create from OpenFirmware platform devices */
-#ifdef CONFIG_OF_GPIO
-static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
+#if defined(CONFIG_OF) || defined(CONFIG_ACPI)
+
+static int gpio_leds_get_led(struct device *dev, void *data)
+{
+	struct gpio_led led = {};
+	struct gpio_leds_priv *priv = data;
+	const char *state = NULL;
+	struct gpio_desc *desc;
+	enum gpio_lookup_flags flags;
+	void *val;
+
+	if (device_property_get(dev, "gpios", NULL)) {
+		dev_warn(dev, "Found LED without gpios\n");
+		return 0;
+	}
+
+	desc = dev_get_gpiod_flags(dev, 0, &flags);
+	if (IS_ERR(desc)) {
+		int error = PTR_ERR(desc);
+
+		if (error != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get gpio flags for LED, error: %d\n",
+				error);
+		return error;
+	}
+
+	led.gpio = desc_to_gpio(desc);
+	led.active_low = flags & GPIO_ACTIVE_LOW;
+
+	if (!device_property_read(dev, "label", DEV_PROP_STRING, &val))
+		led.name = val;
+
+	if (!device_property_read(dev, "linux,default-trigger",
+				  DEV_PROP_STRING, &val))
+		led.default_trigger = val;
+
+	if (!device_property_read(dev, "linux,default-state", DEV_PROP_STRING,
+				  &val))
+		state = val;
+	if (state) {
+		if (!strcmp(state, "keep"))
+			led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
+		else if (!strcmp(state, "on"))
+			led.default_state = LEDS_GPIO_DEFSTATE_ON;
+		else
+			led.default_state = LEDS_GPIO_DEFSTATE_OFF;
+	}
+
+	if (!device_property_get(dev, "linux,retain-state-suspended", NULL))
+		led.retain_state_suspended = 1;
+
+	return create_gpio_led(&led, &priv->leds[priv->num_leds++], dev, NULL);
+}
+
+static struct gpio_leds_priv *gpio_leds_create(struct device *dev)
 {
-	struct device_node *np = pdev->dev.of_node, *child;
 	struct gpio_leds_priv *priv;
-	int count, ret;
+	int count, error;
 
 	/* count LEDs in this device, so we know how much to allocate */
-	count = of_get_available_child_count(np);
-	if (!count)
+	count = device_property_child_count(dev);
+	if (count <= 0)
 		return ERR_PTR(-ENODEV);
 
-	for_each_available_child_of_node(np, child)
-		if (of_get_gpio(child, 0) == -EPROBE_DEFER)
-			return ERR_PTR(-EPROBE_DEFER);
-
-	priv = devm_kzalloc(&pdev->dev, sizeof_gpio_leds_priv(count),
+	priv = devm_kzalloc(dev, sizeof_gpio_leds_priv(count),
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
-	}
-
-	return priv;
+	error = device_for_each_child(dev, priv, gpio_leds_get_led);
+	if (!error)
+		return priv;
 
-err:
 	for (count = priv->num_leds - 2; count >= 0; count--)
 		delete_gpio_led(&priv->leds[count]);
 	return ERR_PTR(-ENODEV);
 }
 
+#ifdef CONFIG_OF
 static const struct of_device_id of_gpio_leds_match[] = {
 	{ .compatible = "gpio-leds", },
 	{},
 };
-
 MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
-#else /* CONFIG_OF_GPIO */
-static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
+#endif
+
+#ifdef CONFIG_ACPI
+static struct acpi_device_id acpi_gpio_leds_match[] = {
+	{ "MNW0001" },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, acpi_gpio_leds_match);
+#endif
+
+#else /* CONFIG_OF || CONFIG_ACPI */
+static struct gpio_leds_priv *gpio_leds_create(struct device *dev)
 {
 	return ERR_PTR(-ENODEV);
 }
@@ -238,7 +266,8 @@ static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
 
 static int gpio_led_probe(struct platform_device *pdev)
 {
-	struct gpio_led_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct device *dev = &pdev->dev;
+	const struct gpio_led_platform_data *pdata = dev_get_platdata(dev);
 	struct gpio_leds_priv *priv;
 	int i, ret = 0;
 
@@ -263,7 +292,7 @@ static int gpio_led_probe(struct platform_device *pdev)
 			}
 		}
 	} else {
-		priv = gpio_leds_create_of(pdev);
+		priv = gpio_leds_create(dev);
 		if (IS_ERR(priv))
 			return PTR_ERR(priv);
 	}
@@ -291,6 +320,7 @@ static struct platform_driver gpio_led_driver = {
 		.name	= "leds-gpio",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(of_gpio_leds_match),
+		.acpi_match_table = ACPI_PTR(acpi_gpio_leds_match),
 	},
 };
 
-- 
2.1.0.rc1

