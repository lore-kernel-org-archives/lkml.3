Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3FAKou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:44:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39527 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3FAKom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:44:42 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH v2] pps-gpio: add device-tree binding and support
Date: Sat,  1 Jun 2013 12:44:09 +0200
Message-Id: <1370083449-11986-1-git-send-email-jlu@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
In-Reply-To: <1588516.WvWWFWzAui@wuerfel>
References: <1588516.WvWWFWzAui@wuerfel>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of allocating a struct pps_gpio_platform_data in the DT case, store
the necessary information in struct pps_gpio_device_data itself. This avoids
an additional allocation and the ifdef. It also gets rid of some indirection.

Also use dev_err instead of pr_err in the changed code.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>

---
    This patch depends on my two recent pps-gpio patches, which are currently
    in Andrew Morton's mmotm. So it should probably also go via Andrew if it
    is acceptable.
    
    Changes since v1:
      - Do not allocate a pdata struct, store info in pps_gpio_device_data.
        Also fold the two calls from pps_gpio_setup into the probe function.
        (suggested by Arnd Bergmann)

 Documentation/devicetree/bindings/pps/pps-gpio.txt |   20 +++
 drivers/pps/clients/pps-gpio.c                     |  128 +++++++++++---------
 2 files changed, 93 insertions(+), 55 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pps/pps-gpio.txt

diff --git a/Documentation/devicetree/bindings/pps/pps-gpio.txt b/Documentation/devicetree/bindings/pps/pps-gpio.txt
new file mode 100644
index 0000000..40bf9c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/pps/pps-gpio.txt
@@ -0,0 +1,20 @@
+Device-Tree Bindings for a PPS Signal on GPIO
+
+These properties describe a PPS (pulse-per-second) signal connected to
+a GPIO pin.
+
+Required properties:
+- compatible: should be "pps-gpio"
+- gpios: one PPS GPIO in the format described by ../gpio/gpio.txt
+
+Optional properties:
+- assert-falling-edge: when present, assert is indicated by a falling edge
+                       (instead of by a rising edge)
+
+Example:
+	pps {
+		compatible = "pps-gpio";
+		gpios = <&gpio2 6 0>;
+
+		assert-falling-edge;
+	};
diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 6768f95..eae0eda 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -33,13 +33,17 @@
 #include <linux/pps-gpio.h>
 #include <linux/gpio.h>
 #include <linux/list.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
 
 /* Info for each registered platform device */
 struct pps_gpio_device_data {
 	int irq;			/* IRQ used as PPS source */
 	struct pps_device *pps;		/* PPS source device */
 	struct pps_source_info info;	/* PPS source information */
-	const struct pps_gpio_platform_data *pdata;
+	bool assert_falling_edge;
+	bool capture_clear;
+	unsigned int gpio_pin;
 };
 
 /*
@@ -57,45 +61,25 @@ static irqreturn_t pps_gpio_irq_handler(int irq, void *data)
 
 	info = data;
 
-	rising_edge = gpio_get_value(info->pdata->gpio_pin);
-	if ((rising_edge && !info->pdata->assert_falling_edge) ||
-			(!rising_edge && info->pdata->assert_falling_edge))
+	rising_edge = gpio_get_value(info->gpio_pin);
+	if ((rising_edge && !info->assert_falling_edge) ||
+			(!rising_edge && info->assert_falling_edge))
 		pps_event(info->pps, &ts, PPS_CAPTUREASSERT, NULL);
-	else if (info->pdata->capture_clear &&
-			((rising_edge && info->pdata->assert_falling_edge) ||
-			 (!rising_edge && !info->pdata->assert_falling_edge)))
+	else if (info->capture_clear &&
+			((rising_edge && info->assert_falling_edge) ||
+			 (!rising_edge && !info->assert_falling_edge)))
 		pps_event(info->pps, &ts, PPS_CAPTURECLEAR, NULL);
 
 	return IRQ_HANDLED;
 }
 
-static int pps_gpio_setup(struct platform_device *pdev)
-{
-	int ret;
-	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
-
-	ret = devm_gpio_request(&pdev->dev, pdata->gpio_pin, pdata->gpio_label);
-	if (ret) {
-		pr_warning("failed to request GPIO %u\n", pdata->gpio_pin);
-		return -EINVAL;
-	}
-
-	ret = gpio_direction_input(pdata->gpio_pin);
-	if (ret) {
-		pr_warning("failed to set pin direction\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static unsigned long
-get_irqf_trigger_flags(const struct pps_gpio_platform_data *pdata)
+get_irqf_trigger_flags(const struct pps_gpio_device_data *data)
 {
-	unsigned long flags = pdata->assert_falling_edge ?
+	unsigned long flags = data->assert_falling_edge ?
 		IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
 
-	if (pdata->capture_clear) {
+	if (data->capture_clear) {
 		flags |= ((flags & IRQF_TRIGGER_RISING) ?
 				IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING);
 	}
@@ -106,35 +90,63 @@ get_irqf_trigger_flags(const struct pps_gpio_platform_data *pdata)
 static int pps_gpio_probe(struct platform_device *pdev)
 {
 	struct pps_gpio_device_data *data;
-	int irq;
+	const char *gpio_label;
 	int ret;
 	int pps_default_params;
 	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 
+	/* allocate space for device info */
+	data = devm_kzalloc(&pdev->dev, sizeof(struct pps_gpio_device_data),
+			GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (pdata) {
+		data->gpio_pin = pdata->gpio_pin;
+		gpio_label = pdata->gpio_label;
+
+		data->assert_falling_edge = pdata->assert_falling_edge;
+		data->capture_clear = pdata->capture_clear;
+	} else {
+		ret = of_get_gpio(np, 0);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to get GPIO from device tree\n");
+			return ret;
+		}
+		data->gpio_pin = ret;
+		gpio_label = PPS_GPIO_NAME;
+
+		if (of_get_property(np, "assert-falling-edge", NULL))
+			data->assert_falling_edge = true;
+	}
 
 	/* GPIO setup */
-	ret = pps_gpio_setup(pdev);
-	if (ret)
-		return -EINVAL;
+	ret = devm_gpio_request(&pdev->dev, data->gpio_pin, gpio_label);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request GPIO %u\n",
+			data->gpio_pin);
+		return ret;
+	}
 
-	/* IRQ setup */
-	irq = gpio_to_irq(pdata->gpio_pin);
-	if (irq < 0) {
-		pr_err("failed to map GPIO to IRQ: %d\n", irq);
+	ret = gpio_direction_input(data->gpio_pin);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to set pin direction\n");
 		return -EINVAL;
 	}
 
-	/* allocate space for device info */
-	data = devm_kzalloc(&pdev->dev, sizeof(struct pps_gpio_device_data),
-			GFP_KERNEL);
-	if (data == NULL) {
-		return -ENOMEM;
+	/* IRQ setup */
+	ret = gpio_to_irq(data->gpio_pin);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to map GPIO to IRQ: %d\n", ret);
+		return -EINVAL;
 	}
+	data->irq = ret;
 
 	/* initialize PPS specific parts of the bookkeeping data structure. */
 	data->info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
 		PPS_ECHOASSERT | PPS_CANWAIT | PPS_TSFMT_TSPEC;
-	if (pdata->capture_clear)
+	if (data->capture_clear)
 		data->info.mode |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR |
 			PPS_ECHOCLEAR;
 	data->info.owner = THIS_MODULE;
@@ -143,28 +155,27 @@ static int pps_gpio_probe(struct platform_device *pdev)
 
 	/* register PPS source */
 	pps_default_params = PPS_CAPTUREASSERT | PPS_OFFSETASSERT;
-	if (pdata->capture_clear)
+	if (data->capture_clear)
 		pps_default_params |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR;
 	data->pps = pps_register_source(&data->info, pps_default_params);
 	if (data->pps == NULL) {
-		pr_err("failed to register IRQ %d as PPS source\n", irq);
+		dev_err(&pdev->dev, "failed to register IRQ %d as PPS source\n",
+			data->irq);
 		return -EINVAL;
 	}
 
-	data->irq = irq;
-	data->pdata = pdata;
-
 	/* register IRQ interrupt handler */
-	ret = devm_request_irq(&pdev->dev, irq, pps_gpio_irq_handler,
-			get_irqf_trigger_flags(pdata), data->info.name, data);
+	ret = devm_request_irq(&pdev->dev, data->irq, pps_gpio_irq_handler,
+			get_irqf_trigger_flags(data), data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
-		pr_err("failed to acquire IRQ %d\n", irq);
+		dev_err(&pdev->dev, "failed to acquire IRQ %d\n", data->irq);
 		return -EINVAL;
 	}
 
 	platform_set_drvdata(pdev, data);
-	dev_info(data->pps->dev, "Registered IRQ %d as PPS source\n", irq);
+	dev_info(data->pps->dev, "Registered IRQ %d as PPS source\n",
+		 data->irq);
 
 	return 0;
 }
@@ -175,16 +186,23 @@ static int pps_gpio_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 	pps_unregister_source(data->pps);
-	pr_info("removed IRQ %d as PPS source\n", data->irq);
+	dev_info(&pdev->dev, "removed IRQ %d as PPS source\n", data->irq);
 	return 0;
 }
 
+static const struct of_device_id pps_gpio_dt_ids[] = {
+	{ .compatible = "pps-gpio", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, pps_gpio_dt_ids);
+
 static struct platform_driver pps_gpio_driver = {
 	.probe		= pps_gpio_probe,
 	.remove		= pps_gpio_remove,
 	.driver		= {
 		.name	= PPS_GPIO_NAME,
-		.owner	= THIS_MODULE
+		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(pps_gpio_dt_ids),
 	},
 };
 
-- 
1.7.10.4

