Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731AbaJUVRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:17:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62958 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933014AbaJUVRr (ORCPT
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
Subject: [PATCH v6 12/12] input: gpio_keys_polled: Make use of device property API
Date: Tue, 21 Oct 2014 23:37:13 +0200
Message-ID: <2117779.M1IjfP3CW4@vostro.rjw.lan>
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

Make use of device property API in this driver so that both OF based
system and ACPI based system can use this driver.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Changes from v5:
- Use devm_get_gpiod_from_child() with 2 arguments (dev, child).

---
 drivers/input/keyboard/gpio_keys_polled.c |   73 +++++++++---------------------
 1 file changed, 24 insertions(+), 49 deletions(-)

Index: linux-pm/drivers/input/keyboard/gpio_keys_polled.c
===================================================================
--- linux-pm.orig/drivers/input/keyboard/gpio_keys_polled.c
+++ linux-pm/drivers/input/keyboard/gpio_keys_polled.c
@@ -25,9 +25,7 @@
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio_keys.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/of_gpio.h>
+#include <linux/property.h>
 
 #define DRV_NAME	"gpio-keys-polled"
 
@@ -102,21 +100,15 @@ static void gpio_keys_polled_close(struc
 		pdata->disable(bdev->dev);
 }
 
-#ifdef CONFIG_OF
 static struct gpio_keys_platform_data *gpio_keys_polled_get_devtree_pdata(struct device *dev)
 {
-	struct device_node *node, *pp;
 	struct gpio_keys_platform_data *pdata;
 	struct gpio_keys_button *button;
+	struct fwnode_handle *child;
 	int error;
 	int nbuttons;
-	int i;
-
-	node = dev->of_node;
-	if (!node)
-		return NULL;
 
-	nbuttons = of_get_child_count(node);
+	nbuttons = device_get_child_node_count(dev);
 	if (nbuttons == 0)
 		return NULL;
 
@@ -126,52 +118,44 @@ static struct gpio_keys_platform_data *g
 		return ERR_PTR(-ENOMEM);
 
 	pdata->buttons = (struct gpio_keys_button *)(pdata + 1);
-	pdata->nbuttons = nbuttons;
 
-	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
-	of_property_read_u32(node, "poll-interval", &pdata->poll_interval);
+	pdata->rep = device_property_present(dev, "autorepeat");
+	device_property_read_u32(dev, "poll-interval", &pdata->poll_interval);
 
-	i = 0;
-	for_each_child_of_node(node, pp) {
-		int gpio;
-		enum of_gpio_flags flags;
-
-		if (!of_find_property(pp, "gpios", NULL)) {
-			pdata->nbuttons--;
-			dev_warn(dev, "Found button without gpios\n");
-			continue;
-		}
+	device_for_each_child_node(dev, child) {
+		struct gpio_desc *desc;
 
-		gpio = of_get_gpio_flags(pp, 0, &flags);
-		if (gpio < 0) {
-			error = gpio;
+		desc = devm_get_gpiod_from_child(dev, child);
+		if (IS_ERR(desc)) {
+			error = PTR_ERR(desc);
 			if (error != -EPROBE_DEFER)
 				dev_err(dev,
 					"Failed to get gpio flags, error: %d\n",
 					error);
+			fwnode_handle_put(child);
 			return ERR_PTR(error);
 		}
 
-		button = &pdata->buttons[i++];
-
-		button->gpio = gpio;
-		button->active_low = flags & OF_GPIO_ACTIVE_LOW;
+		button = &pdata->buttons[pdata->nbuttons++];
+		button->gpiod = desc;
 
-		if (of_property_read_u32(pp, "linux,code", &button->code)) {
-			dev_err(dev, "Button without keycode: 0x%x\n",
-				button->gpio);
+		if (fwnode_property_read_u32(child, "linux,code", &button->code)) {
+			dev_err(dev, "Button without keycode: %d\n",
+				pdata->nbuttons - 1);
+			fwnode_handle_put(child);
 			return ERR_PTR(-EINVAL);
 		}
 
-		button->desc = of_get_property(pp, "label", NULL);
+		fwnode_property_read_string(child, "label", &button->desc);
 
-		if (of_property_read_u32(pp, "linux,input-type", &button->type))
+		if (fwnode_property_read_u32(child, "linux,input-type",
+					     &button->type))
 			button->type = EV_KEY;
 
-		button->wakeup = !!of_get_property(pp, "gpio-key,wakeup", NULL);
+		button->wakeup = fwnode_property_present(child, "gpio-key,wakeup");
 
-		if (of_property_read_u32(pp, "debounce-interval",
-					 &button->debounce_interval))
+		if (fwnode_property_read_u32(child, "debounce-interval",
+					     &button->debounce_interval))
 			button->debounce_interval = 5;
 	}
 
@@ -187,15 +171,6 @@ static const struct of_device_id gpio_ke
 };
 MODULE_DEVICE_TABLE(of, gpio_keys_polled_of_match);
 
-#else
-
-static inline struct gpio_keys_platform_data *
-gpio_keys_polled_get_devtree_pdata(struct device *dev)
-{
-	return NULL;
-}
-#endif
-
 static int gpio_keys_polled_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -323,7 +298,7 @@ static struct platform_driver gpio_keys_
 	.driver	= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(gpio_keys_polled_of_match),
+		.of_match_table = gpio_keys_polled_of_match,
 	},
 };
 module_platform_driver(gpio_keys_polled_driver);

