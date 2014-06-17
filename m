Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaFQEBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 00:01:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51084 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098AbaFQEBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 00:01:08 -0400
From: George Cherian <george.cherian@ti.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>,
        <grant.likely@linaro.org>, <rdunlap@infradead.org>,
        <galak@codeaurora.org>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <george.cherian@ti.com>
Subject: [PATCH 2/2] extcon: gpio: Add dt support for the driver.
Date: Tue, 17 Jun 2014 09:28:20 +0530
Message-ID: <1402977500-19987-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402977500-19987-1-git-send-email-george.cherian@ti.com>
References: <1402977500-19987-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support to extcon-gpio driver.
Add devicetree binding documentation

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 .../devicetree/bindings/extcon/extcon-gpio.txt     | 34 ++++++++++++++++++++++
 drivers/extcon/extcon-gpio.c                       | 29 ++++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt

diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
new file mode 100644
index 0000000..80b791b
--- /dev/null
+++ b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
@@ -0,0 +1,34 @@
+GPIO based EXTCON
+
+EXTCON GPIO
+-----------
+
+Required Properties:
+ - compatible: should be:
+   * "ti,extcon-gpio"
+ - gpios: specifies the gpio pin used.
+ - debounce: Debounce time for GPIO IRQ in ms
+ - irq-flags: IRQ flag to be used ( eg: IRQ_TYPE_EDGE_FALLING)
+
+Optional Properties:
+ - gpio-active-low: Property describing whether gpio active state is 1 or 0
+		    If defined , low state of gpio means active.
+ - check-on-resume: Property describing whether to check the gpio state
+		    while resuming from SLEEP.
+ - state-on: print_state is overriden with state_on string if provided.
+	     If NULL, default method of extcon class is used.
+ - state_off: print_state is overriden with state_off string  if provided.
+	      If NUll, default method of extcon class is used.
+
+Eg:
+
+        extcon1: am43_usbid_extcon1 {
+                compatible = "ti,extcon-gpio";
+                gpios = <&gpio3 12 GPIO_ACTIVE_HIGH>;
+                gpio-active-low;
+                debounce = <20>;
+                irq-flags = <IRQ_TYPE_EDGE_FALLING>;
+                state-on = "USB ID FLOAT";
+                state-off = "USB ID GND";
+
+        };
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 6c268b4..14d999d 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
@@ -83,12 +84,34 @@ static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
 
 static int gpio_extcon_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct gpio_extcon_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct gpio_extcon_data *extcon_data;
 	int ret;
 
+	if (np) {
+		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+
+		pdata->gpio = of_get_gpio(np, 0);
+		if (!gpio_is_valid(pdata->gpio))
+			return -EPROBE_DEFER;
+
+		pdata->name = np->name;
+		pdata->gpio_active_low = of_property_read_bool(np,
+						"gpio-active-low");
+		pdata->check_on_resume = of_property_read_bool(np,
+						"check-on-resume");
+		of_property_read_u32(np, "debounce", (u32 *)&pdata->debounce);
+		of_property_read_u32(np, "irq-flags", (u32 *)&pdata->irq_flags);
+		of_property_read_string(np, "state-on", &pdata->state_on);
+		of_property_read_string(np, "state-off", &pdata->state_off);
+	}
+
 	if (!pdata)
 		return -EBUSY;
+
 	if (!pdata->irq_flags) {
 		dev_err(&pdev->dev, "IRQ flag is not specified.\n");
 		return -EINVAL;
@@ -177,6 +200,11 @@ static int gpio_extcon_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(gpio_extcon_pm_ops, NULL, gpio_extcon_resume);
 
+static struct of_device_id of_extcon_gpio_match_tbl[] = {
+	{ .compatible = "ti,extcon-gpio", },
+	{ /* end */ }
+};
+
 static struct platform_driver gpio_extcon_driver = {
 	.probe		= gpio_extcon_probe,
 	.remove		= gpio_extcon_remove,
@@ -184,6 +212,7 @@ static struct platform_driver gpio_extcon_driver = {
 		.name	= "extcon-gpio",
 		.owner	= THIS_MODULE,
 		.pm	= &gpio_extcon_pm_ops,
+		.of_match_table = of_extcon_gpio_match_tbl,
 	},
 };
 
-- 
1.8.3.1

