Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaKCQeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:34:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58712 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbaKCQdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:33:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>, George Cherian <george.cherian@ti.com>,
        <devicetree@vger.kernel.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/4] extcon: gpio: Add dt support for the driver.
Date: Mon, 3 Nov 2014 10:32:28 -0600
Message-ID: <1415032350-8459-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
In-Reply-To: <1415032350-8459-1-git-send-email-balbi@ti.com>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Cherian <george.cherian@ti.com>

Add device tree support to extcon-gpio driver.
Add devicetree binding documentation

Cc: devicetree@vger.kernel.org
Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 .../devicetree/bindings/extcon/extcon-gpio.txt     | 21 ++++++
 drivers/extcon/extcon-gpio.c                       | 75 +++++++++++++++-------
 2 files changed, 73 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt

diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
new file mode 100644
index 0000000..5fe6846
--- /dev/null
+++ b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
@@ -0,0 +1,21 @@
+GPIO based EXTCON
+
+EXTCON GPIO
+-----------
+
+Required Properties:
+ - compatible: should be:
+   * "linux,extcon-gpio"
+ - gpios: specifies the gpio pin used.
+
+Optional Properties:
+ - debounce: Debounce time for GPIO IRQ in ms
+
+
+Eg:
+
+	extcon1: am43_usbid_extcon1 {
+		compatible = "linux,extcon-gpio";
+		gpios = <&gpio3 12 GPIO_ACTIVE_HIGH>;
+		debounce = <20>;
+	};
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 70e3fc7..9571e1f 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -25,8 +25,10 @@
 #include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
@@ -80,16 +82,12 @@ static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
 
 static int gpio_extcon_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct gpio_extcon_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct gpio_extcon_data *extcon_data;
 	int ret;
-
-	if (!pdata)
-		return -EBUSY;
-	if (!pdata->irq_flags) {
-		dev_err(&pdev->dev, "IRQ flag is not specified.\n");
-		return -EINVAL;
-	}
+	unsigned int irq_flags;
+	unsigned int debounce = 0;
 
 	extcon_data = devm_kzalloc(&pdev->dev, sizeof(struct gpio_extcon_data),
 				   GFP_KERNEL);
@@ -101,26 +99,51 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to allocate extcon device\n");
 		return -ENOMEM;
 	}
-	extcon_data->edev->name = pdata->name;
-
-	extcon_data->gpiod = gpio_to_desc(pdata->gpio);
-	extcon_data->state_on = pdata->state_on;
-	extcon_data->state_off = pdata->state_off;
-	extcon_data->check_on_resume = pdata->check_on_resume;
-	if (pdata->state_on && pdata->state_off)
-		extcon_data->edev->print_state = extcon_gpio_print_state;
 
-	ret = devm_gpio_request_one(&pdev->dev, pdata->gpio, GPIOF_DIR_IN,
-				    pdev->name);
-	if (ret < 0)
-		return ret;
+	if (np) {
+		int irq;
+
+		extcon_data->gpiod = devm_gpiod_get(&pdev->dev, NULL);
+		if (IS_ERR(extcon_data->gpiod))
+			return PTR_ERR(extcon_data->gpiod);
+
+		extcon_data->edev->name = np->name;
+		extcon_data->edev->dev.parent = &pdev->dev;
+		of_property_read_u32(np, "debounce", &debounce);
+		irq = gpiod_to_irq(extcon_data->gpiod);
+		irq_flags = irq_get_trigger_type(irq);
+	} else {
+		if (!pdata)
+			return -EBUSY;
+
+		if (!pdata->irq_flags) {
+			dev_err(&pdev->dev, "IRQ flag is not specified.\n");
+			return -EINVAL;
+		}
+
+		extcon_data->edev->name = pdata->name;
+
+		extcon_data->gpiod = gpio_to_desc(pdata->gpio);
+		extcon_data->state_on = pdata->state_on;
+		extcon_data->state_off = pdata->state_off;
+		extcon_data->check_on_resume = pdata->check_on_resume;
+		if (pdata->state_on && pdata->state_off)
+			extcon_data->edev->print_state = extcon_gpio_print_state;
+
+		ret = devm_gpio_request_one(&pdev->dev, pdata->gpio, GPIOF_DIR_IN,
+				pdev->name);
+		if (ret < 0)
+			return ret;
+		irq_flags = pdata->irq_flags;
+		debounce = pdata->debounce;
+	}
 
-	if (pdata->debounce) {
+	if (debounce) {
 		ret = gpiod_set_debounce(extcon_data->gpiod,
-					pdata->debounce * 1000);
+					 debounce * 1000);
 		if (ret < 0)
 			extcon_data->debounce_jiffies =
-				msecs_to_jiffies(pdata->debounce);
+				msecs_to_jiffies(debounce);
 	}
 
 	ret = devm_extcon_dev_register(&pdev->dev, extcon_data->edev);
@@ -134,7 +157,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 		return extcon_data->irq;
 
 	ret = request_any_context_irq(extcon_data->irq, gpio_irq_handler,
-				      pdata->irq_flags, pdev->name,
+				      irq_flags, pdev->name,
 				      extcon_data);
 	if (ret < 0)
 		return ret;
@@ -172,6 +195,11 @@ static int gpio_extcon_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(gpio_extcon_pm_ops, NULL, gpio_extcon_resume);
 
+static struct of_device_id of_extcon_gpio_match_tbl[] = {
+	{ .compatible = "linux,extcon-gpio", },
+	{ /* end */ }
+};
+
 static struct platform_driver gpio_extcon_driver = {
 	.probe		= gpio_extcon_probe,
 	.remove		= gpio_extcon_remove,
@@ -179,6 +207,7 @@ static struct platform_driver gpio_extcon_driver = {
 		.name	= "extcon-gpio",
 		.owner	= THIS_MODULE,
 		.pm	= &gpio_extcon_pm_ops,
+		.of_match_table = of_extcon_gpio_match_tbl,
 	},
 };
 
-- 
2.1.0.GIT

