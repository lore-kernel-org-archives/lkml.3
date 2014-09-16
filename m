Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaIPLxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:53:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:4928 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbaIPLxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:53:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="573795150"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC PATCH v2 13/16] input: gpio_keys_polled - Make use of device property API
Date: Tue, 16 Sep 2014 14:52:44 +0300
Message-Id: <1410868367-11056-14-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

Make use of device property API in this driver so that both OF based
system and ACPI based system can use this driver.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/input/keyboard/gpio_keys_polled.c | 125 ++++++++++++++----------------
 1 file changed, 59 insertions(+), 66 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index b7a514ced509..9afd9a6c43f4 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -25,9 +25,7 @@
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio_keys.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/of_gpio.h>
+#include <linux/property.h>
 
 #define DRV_NAME	"gpio-keys-polled"
 
@@ -45,6 +43,11 @@ struct gpio_keys_polled_dev {
 	struct gpio_keys_button_data data[0];
 };
 
+struct gpio_keys_devtree_data {
+	struct device *dev;
+	struct gpio_keys_platform_data *pdata;
+};
+
 static void gpio_keys_polled_check_state(struct input_dev *input,
 					 struct gpio_keys_button *button,
 					 struct gpio_keys_button_data *bdata)
@@ -102,21 +105,56 @@ static void gpio_keys_polled_close(struct input_polled_dev *dev)
 		pdata->disable(bdev->dev);
 }
 
-#ifdef CONFIG_OF
+static int gpio_keys_polled_get_button(struct fw_dev_node *fdn, void *data)
+{
+	struct gpio_keys_devtree_data *dtdata = data;
+	struct gpio_keys_platform_data *pdata = dtdata->pdata;
+	struct device *dev = dtdata->dev;
+	struct gpio_keys_button *button;
+	struct gpio_desc *desc;
+
+	desc = devm_node_get_named_gpiod(dev, fdn, "gpios", 0);
+	if (IS_ERR(desc)) {
+		int err = PTR_ERR(desc);
+
+		if (err != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get gpio flags, error: %d\n",
+				err);
+		return err;
+	}
+
+	button = &pdata->buttons[pdata->nbuttons++];
+	button->gpiod = desc;
+
+	if (dev_node_property_read_u32(fdn, "linux,code", &button->code)) {
+		dev_err(dev, "Button without keycode: %d\n",
+			pdata->nbuttons - 1);
+		return -EINVAL;
+	}
+
+	dev_node_property_read_string(fdn, "label", &button->desc);
+
+	if (dev_node_property_read_u32(fdn, "linux,input-type", &button->type))
+		button->type = EV_KEY;
+
+	button->wakeup = !dev_node_get_property(fdn, "gpio-key,wakeup", NULL);
+
+	if (dev_node_property_read_u32(fdn, "debounce-interval",
+				       &button->debounce_interval))
+		button->debounce_interval = 5;
+
+	return 0;
+}
+
 static struct gpio_keys_platform_data *gpio_keys_polled_get_devtree_pdata(struct device *dev)
 {
-	struct device_node *node, *pp;
+	struct gpio_keys_devtree_data dtdata;
 	struct gpio_keys_platform_data *pdata;
 	struct gpio_keys_button *button;
 	int error;
 	int nbuttons;
-	int i;
 
-	node = dev->of_node;
-	if (!node)
-		return NULL;
-
-	nbuttons = of_get_child_count(node);
+	nbuttons = device_get_child_node_count(dev);
 	if (nbuttons == 0)
 		return NULL;
 
@@ -126,54 +164,18 @@ static struct gpio_keys_platform_data *gpio_keys_polled_get_devtree_pdata(struct
 		return ERR_PTR(-ENOMEM);
 
 	pdata->buttons = (struct gpio_keys_button *)(pdata + 1);
-	pdata->nbuttons = nbuttons;
-
-	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
-	of_property_read_u32(node, "poll-interval", &pdata->poll_interval);
-
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
-
-		gpio = of_get_gpio_flags(pp, 0, &flags);
-		if (gpio < 0) {
-			error = gpio;
-			if (error != -EPROBE_DEFER)
-				dev_err(dev,
-					"Failed to get gpio flags, error: %d\n",
-					error);
-			return ERR_PTR(error);
-		}
 
-		button = &pdata->buttons[i++];
+	pdata->rep = !device_get_property(dev, "autorepeat", NULL);
+	device_property_read_u32(dev, "poll-interval", &pdata->poll_interval);
 
-		button->gpio = gpio;
-		button->active_low = flags & OF_GPIO_ACTIVE_LOW;
+	memset(&dtdata, 0, sizeof(dtdata));
+	dtdata.pdata = pdata;
+	dtdata.dev = dev;
 
-		if (of_property_read_u32(pp, "linux,code", &button->code)) {
-			dev_err(dev, "Button without keycode: 0x%x\n",
-				button->gpio);
-			return ERR_PTR(-EINVAL);
-		}
-
-		button->desc = of_get_property(pp, "label", NULL);
-
-		if (of_property_read_u32(pp, "linux,input-type", &button->type))
-			button->type = EV_KEY;
-
-		button->wakeup = !!of_get_property(pp, "gpio-key,wakeup", NULL);
-
-		if (of_property_read_u32(pp, "debounce-interval",
-					 &button->debounce_interval))
-			button->debounce_interval = 5;
-	}
+	error = device_for_each_child_node(dev, gpio_keys_polled_get_button,
+					   &dtdata);
+	if (error)
+		return ERR_PTR(error);
 
 	if (pdata->nbuttons == 0)
 		return ERR_PTR(-EINVAL);
@@ -187,15 +189,6 @@ static const struct of_device_id gpio_keys_polled_of_match[] = {
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
@@ -323,7 +316,7 @@ static struct platform_driver gpio_keys_polled_driver = {
 	.driver	= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(gpio_keys_polled_of_match),
+		.of_match_table = gpio_keys_polled_of_match,
 	},
 };
 module_platform_driver(gpio_keys_polled_driver);
-- 
2.1.0

