Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab3BWH7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 02:59:16 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:53809 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3BWH6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 02:58:45 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ville Syrjala <syrjala@sci.fi>, Daniel Mack <zonque@gmail.com>
Subject: [PATCH 4/5] W1: w1-gpio - rework handling of platform data
Date: Fri, 22 Feb 2013 23:58:39 -0800
Message-Id: <1361606320-4479-4-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform data in the dveice structure does not belong to the driver
and so it should not be trying to alter it, but instead use a local pointer
and populate it with a local copy in case we are dealing with device tree
setup.

Also allow mixed setups where platform data coexists with device tree and
prefer kernel-supplied data (it may be easier to fiddle in kernel structure
before committing final result to device tree).

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/w1/masters/w1-gpio.c | 93 +++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index aa97a96..ee6b6e3 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -23,28 +23,33 @@
 #include "../w1.h"
 #include "../w1_int.h"
 
+struct w1_gpio {
+	struct w1_bus_master master;
+	const struct w1_gpio_platform_data *pdata;
+};
+
 static void w1_gpio_write_bit_dir(void *data, u8 bit)
 {
-	struct w1_gpio_platform_data *pdata = data;
+	struct w1_gpio *w1_gpio = data;
 
 	if (bit)
-		gpio_direction_input(pdata->pin);
+		gpio_direction_input(w1_gpio->pdata->pin);
 	else
-		gpio_direction_output(pdata->pin, 0);
+		gpio_direction_output(w1_gpio->pdata->pin, 0);
 }
 
 static void w1_gpio_write_bit_val(void *data, u8 bit)
 {
-	struct w1_gpio_platform_data *pdata = data;
+	struct w1_gpio *w1_gpio = data;
 
-	gpio_set_value(pdata->pin, bit);
+	gpio_set_value(w1_gpio->pdata->pin, bit);
 }
 
 static u8 w1_gpio_read_bit(void *data)
 {
-	struct w1_gpio_platform_data *pdata = data;
+	struct w1_gpio *w1_gpio = data;
 
-	return gpio_get_value(pdata->pin) ? 1 : 0;
+	return gpio_get_value(w1_gpio->pdata->pin) ? 1 : 0;
 }
 
 #ifdef CONFIG_OF
@@ -55,38 +60,43 @@ static struct of_device_id w1_gpio_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, w1_gpio_dt_ids);
 
-static int w1_gpio_probe_dt(struct platform_device *pdev)
+static struct w1_gpio_platform_data *
+w1_gpio_probe_dt(struct platform_device *pdev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata;
 	struct device_node *np = pdev->dev.of_node;
 
+	if (!np)
+		return ERR_PTR(-ENOENT);
+
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (of_get_property(np, "linux,open-drain", NULL))
 		pdata->is_open_drain = 1;
 
 	pdata->pin = of_get_gpio(np, 0);
 	pdata->ext_pullup_enable_pin = of_get_gpio(np, 1);
-	pdev->dev.platform_data = pdata;
 
-	return 0;
+	return pdata;
 }
 
 #else
 
-static inline int w1_gpio_probe_dt(struct platform_device *pdev)
+static inline struct w1_gpio_platform_data *
+w1_gpio_probe_dt(struct platform_device *pdev)
 {
-	return -ENOSYS;
+	return NULL;
 }
 
 #endif
 
 static int w1_gpio_probe(struct platform_device *pdev)
 {
-	struct w1_bus_master *master;
-	struct w1_gpio_platform_data *pdata;
+	const struct w1_gpio_platform_data *pdata =
+					dev_get_platdata(&pdev->dev);
+	struct w1_gpio *w1_gpio;
 	struct pinctrl *pinctrl;
 	int err;
 
@@ -94,23 +104,20 @@ static int w1_gpio_probe(struct platform_device *pdev)
 	if (IS_ERR(pinctrl))
 		dev_warn(&pdev->dev, "unable to select pin group\n");
 
-	if (of_have_populated_dt()) {
-		err = w1_gpio_probe_dt(pdev);
-		if (err < 0) {
-			dev_err(&pdev->dev, "Failed to parse DT\n");
-			return err;
-		}
-	}
-
-	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		pdata = w1_gpio_probe_dt(pdev);
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No configuration data\n");
 		return -ENXIO;
+	} else if (IS_ERR(pdata)) {
+		err = PTR_ERR(pdata);
+		dev_err(&pdev->dev, "Failed to parse DT\n");
+		return err;
 	}
 
-	master = kzalloc(sizeof(struct w1_bus_master), GFP_KERNEL);
-	if (!master) {
+	w1_gpio = kzalloc(sizeof(struct w1_gpio), GFP_KERNEL);
+	if (!w1_gpio) {
 		dev_err(&pdev->dev, "Out of memory\n");
 		return -ENOMEM;
 	}
@@ -131,18 +138,20 @@ static int w1_gpio_probe(struct platform_device *pdev)
 		}
 	}
 
-	master->data = pdata;
-	master->read_bit = w1_gpio_read_bit;
+	w1_gpio->pdata = pdata;
+
+	w1_gpio->master.data = w1_gpio;
+	w1_gpio->master.read_bit = w1_gpio_read_bit;
 
 	if (pdata->is_open_drain) {
 		gpio_direction_output(pdata->pin, 1);
-		master->write_bit = w1_gpio_write_bit_val;
+		w1_gpio->master.write_bit = w1_gpio_write_bit_val;
 	} else {
 		gpio_direction_input(pdata->pin);
-		master->write_bit = w1_gpio_write_bit_dir;
+		w1_gpio->master.write_bit = w1_gpio_write_bit_dir;
 	}
 
-	err = w1_add_master_device(master);
+	err = w1_add_master_device(&w1_gpio->master);
 	if (err) {
 		dev_err(&pdev->dev, "w1_add_master device failed\n");
 		goto free_gpio_ext_pu;
@@ -154,7 +163,7 @@ static int w1_gpio_probe(struct platform_device *pdev)
 	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
 		gpio_set_value(pdata->ext_pullup_enable_pin, 1);
 
-	platform_set_drvdata(pdev, master);
+	platform_set_drvdata(pdev, w1_gpio);
 
 	return 0;
 
@@ -164,15 +173,15 @@ static int w1_gpio_probe(struct platform_device *pdev)
  free_gpio:
 	gpio_free(pdata->pin);
  free_master:
-	kfree(master);
+	kfree(w1_gpio);
 
 	return err;
 }
 
 static int w1_gpio_remove(struct platform_device *pdev)
 {
-	struct w1_bus_master *master = platform_get_drvdata(pdev);
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio *w1_gpio = platform_get_drvdata(pdev);
+	const struct w1_gpio_platform_data *pdata = w1_gpio->pdata;
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -180,9 +189,9 @@ static int w1_gpio_remove(struct platform_device *pdev)
 	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
 		gpio_set_value(pdata->ext_pullup_enable_pin, 0);
 
-	w1_remove_master_device(master);
+	w1_remove_master_device(&w1_gpio->master);
 	gpio_free(pdata->pin);
-	kfree(master);
+	kfree(w1_gpio);
 
 	return 0;
 }
@@ -190,7 +199,9 @@ static int w1_gpio_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int w1_gpio_suspend(struct device *dev)
 {
-	const struct w1_gpio_platform_data *pdata = dev_get_platdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct w1_gpio *w1_gpio = platform_get_drvdata(pdev);
+	const struct w1_gpio_platform_data *pdata = w1_gpio->pdata;
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -200,7 +211,9 @@ static int w1_gpio_suspend(struct device *dev)
 
 static int w1_gpio_resume(struct device *dev)
 {
-	const struct w1_gpio_platform_data *pdata = dev_get_platdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct w1_gpio *w1_gpio = platform_get_drvdata(pdev);
+	const struct w1_gpio_platform_data *pdata = w1_gpio->pdata;
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
-- 
1.7.11.7

