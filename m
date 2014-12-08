Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaLHHTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:19:37 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49178 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaLHHTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:19:35 -0500
Date: Sun, 7 Dec 2014 23:19:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Laxman Dewangan <ldewangan@nvidia.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 1/2] Input: gpio_keys - allow separating gpio and irq in
 device tree
Message-ID: <20141208071930.GA20802@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change allows specify interrupt for buttons separately form gpio,
potentially allowing to form several "clusters" of buttons on
different interrupts.

Button defined without both gpio and irq in device tree is a hared error
instead of a warning now.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 .../devicetree/bindings/input/gpio-keys.txt        | 10 +++--
 drivers/input/keyboard/gpio_keys.c                 | 50 ++++++++++++----------
 2 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/gpio-keys.txt b/Documentation/devicetree/bindings/input/gpio-keys.txt
index a4a38fc..44b7057 100644
--- a/Documentation/devicetree/bindings/input/gpio-keys.txt
+++ b/Documentation/devicetree/bindings/input/gpio-keys.txt
@@ -10,12 +10,13 @@ Optional properties:
 Each button (key) is represented as a sub-node of "gpio-keys":
 Subnode properties:
 
+	- gpios: OF device-tree gpio specification.
+	- interrupts: the interrupt line for that input.
 	- label: Descriptive name of the key.
 	- linux,code: Keycode to emit.
 
-Required mutual exclusive subnode-properties:
-	- gpios: OF device-tree gpio specification.
-	- interrupts: the interrupt line for that input
+Note that either "interrupts" or "gpios" properties can be omitted, but not
+both at the same time. Specifying both properties is allowed.
 
 Optional subnode-properties:
 	- linux,input-type: Specify event type this button/key generates.
@@ -23,6 +24,9 @@ Optional subnode-properties:
 	- debounce-interval: Debouncing interval time in milliseconds.
 	  If not specified defaults to 5.
 	- gpio-key,wakeup: Boolean, button can wake-up the system.
+	- linux,can-disable: Boolean, indicates that button is connected
+	  to dedicated (not shared) interrupt which can be disabled to
+	  suppress events from the button.
 
 Example nodes:
 
diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index b8b4876..a5ece3f 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -470,15 +470,19 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 						button->debounce_interval;
 		}
 
-		irq = gpio_to_irq(button->gpio);
-		if (irq < 0) {
-			error = irq;
-			dev_err(dev,
-				"Unable to get irq number for GPIO %d, error %d\n",
-				button->gpio, error);
-			return error;
+		if (button->irq) {
+			bdata->irq = button->irq;
+		} else {
+			irq = gpio_to_irq(button->gpio);
+			if (irq < 0) {
+				error = irq;
+				dev_err(dev,
+					"Unable to get irq number for GPIO %d, error %d\n",
+					button->gpio, error);
+				return error;
+			}
+			bdata->irq = irq;
 		}
-		bdata->irq = irq;
 
 		INIT_WORK(&bdata->work, gpio_keys_gpio_work_func);
 		setup_timer(&bdata->timer,
@@ -618,32 +622,30 @@ gpio_keys_get_devtree_pdata(struct device *dev)
 
 	i = 0;
 	for_each_child_of_node(node, pp) {
-		int gpio = -1;
 		enum of_gpio_flags flags;
 
-		if (!of_find_property(pp, "gpios", NULL)) {
-			button->irq = irq_of_parse_and_map(pp, 0);
-			if (button->irq == 0) {
-				pdata->nbuttons--;
-				dev_warn(dev, "Found button without gpios or irqs\n");
-				continue;
-			}
-		} else {
-			gpio = of_get_gpio_flags(pp, 0, &flags);
-			if (gpio < 0) {
-				error = gpio;
+		button = &pdata->buttons[i++];
+
+		button->gpio = of_get_gpio_flags(pp, 0, &flags);
+		if (button->gpio < 0) {
+			error = button->gpio;
+			if (error != -ENOENT) {
 				if (error != -EPROBE_DEFER)
 					dev_err(dev,
 						"Failed to get gpio flags, error: %d\n",
 						error);
 				return ERR_PTR(error);
 			}
+		} else {
+			button->active_low = flags & OF_GPIO_ACTIVE_LOW;
 		}
 
-		button = &pdata->buttons[i++];
+		button->irq = irq_of_parse_and_map(pp, 0);
 
-		button->gpio = gpio;
-		button->active_low = flags & OF_GPIO_ACTIVE_LOW;
+		if (!gpio_is_valid(button->gpio) && !button->irq) {
+			dev_err(dev, "Found button without gpios or irqs\n");
+			return ERR_PTR(-EINVAL);
+		}
 
 		if (of_property_read_u32(pp, "linux,code", &button->code)) {
 			dev_err(dev, "Button without keycode: 0x%x\n",
@@ -658,6 +660,8 @@ gpio_keys_get_devtree_pdata(struct device *dev)
 
 		button->wakeup = !!of_get_property(pp, "gpio-key,wakeup", NULL);
 
+		button->can_disable = !!of_get_property(pp, "linux,can-disable", NULL);
+
 		if (of_property_read_u32(pp, "debounce-interval",
 					 &button->debounce_interval))
 			button->debounce_interval = 5;
-- 
2.2.0.rc0.207.ga3a616c


-- 
Dmitry
