Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbbAGSCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:02:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46465 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbbAGSCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:02:31 -0500
From: Nishanth Menon <nm@ti.com>
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        Eduardo Valentin <edubezval@gmail.com>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] (gpio-fan): Add thermal control hooks
Date: Wed, 7 Jan 2015 12:01:14 -0600
Message-ID: <1420653674-23855-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow gpio-fan to be used as thermal cooling device for platforms that
use GPIO maps to control fans.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

Based on v3.19-rc3

 .../devicetree/bindings/gpio/gpio-fan.txt          |   14 +++
 drivers/hwmon/gpio-fan.c                           |   93 ++++++++++++++++++--
 2 files changed, 100 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-fan.txt b/Documentation/devicetree/bindings/gpio/gpio-fan.txt
index 2dd457a3469a..046f2f400dbb 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-fan.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-fan.txt
@@ -11,6 +11,9 @@ Required properties:
 Optional properties:
 - alarm-gpios: This pin going active indicates something is wrong with
   the fan, and a udev event will be fired.
+- cooling-cells: If used as a cooling device, must be <2>
+  Also see: Documentation/devicetree/bindings/thermal/thermal.txt
+  min and max states are derived from the speed-map of the fan.
 
 Examples:
 
@@ -23,3 +26,14 @@ Examples:
 				      6000 2>;
 		alarm-gpios = <&gpio1 15 1>;
 	};
+
+	gpio_fan_cool: gpio_fan {
+		compatible = "gpio-fan";
+		gpios = <&gpio2 14 1
+			 &gpio2 13 1>;
+		gpio-fan,speed-map = <0    0
+				      3000 1
+				      6000 2>;
+		alarm-gpios = <&gpio1 15 1>;
+		#cooling-cells = <2>; /* min followed by max */
+	};
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 36abf814b8c7..089914c4f574 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -34,10 +34,14 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
+#include <linux/thermal.h>
+
 
 struct gpio_fan_data {
 	struct platform_device	*pdev;
 	struct device		*hwmon_dev;
+	/* Cooling device if any */
+	struct thermal_cooling_device *cdev;
 	struct mutex		lock; /* lock GPIOs operations. */
 	int			num_ctrl;
 	unsigned		*ctrl;
@@ -387,12 +391,63 @@ static int fan_ctrl_init(struct gpio_fan_data *fan_data,
 	return 0;
 }
 
+static int gpio_fan_get_max_state(struct thermal_cooling_device *cdev,
+				  unsigned long *state)
+{
+	struct gpio_fan_data *fan_data = cdev->devdata;
+
+	if (!fan_data)
+		return -EINVAL;
+
+	*state = fan_data->num_speed - 1;
+	return 0;
+}
+
+static int gpio_fan_get_cur_state(struct thermal_cooling_device *cdev,
+				  unsigned long *state)
+{
+	struct gpio_fan_data *fan_data = cdev->devdata;
+	int r;
+
+	if (!fan_data)
+		return -EINVAL;
+
+	r = get_fan_speed_index(fan_data);
+	if (r < 0)
+		return r;
+
+	*state = r;
+	return 0;
+
+}
+
+static int gpio_fan_set_cur_state(struct thermal_cooling_device *cdev,
+				  unsigned long state)
+{
+	struct gpio_fan_data *fan_data = cdev->devdata;
+
+	if (!fan_data)
+		return -EINVAL;
+
+	set_fan_speed(fan_data, state);
+
+	return 0;
+}
+
+static const struct thermal_cooling_device_ops gpio_fan_cooling_ops = {
+	.get_max_state = gpio_fan_get_max_state,
+	.get_cur_state = gpio_fan_get_cur_state,
+	.set_cur_state = gpio_fan_set_cur_state,
+
+};
+
 #ifdef CONFIG_OF_GPIO
 /*
  * Translate OpenFirmware node properties into platform_data
  */
 static int gpio_fan_get_of_pdata(struct device *dev,
-			    struct gpio_fan_platform_data *pdata)
+			         struct gpio_fan_platform_data *pdata,
+				 struct gpio_fan_data *fan_data)
 {
 	struct device_node *node;
 	struct gpio_fan_speed *speed;
@@ -480,6 +535,12 @@ static int gpio_fan_get_of_pdata(struct device *dev,
 		pdata->alarm = alarm;
 	}
 
+	fan_data->cdev = thermal_of_cooling_device_register(node, "gpio-fan",
+							    fan_data,
+						    &gpio_fan_cooling_ops);
+	if (IS_ERR(fan_data->cdev))
+		dev_dbg(dev, "gpio-fan has no valid cooling DT property\n");
+
 	return 0;
 }
 
@@ -495,6 +556,11 @@ static int gpio_fan_probe(struct platform_device *pdev)
 	struct gpio_fan_data *fan_data;
 	struct gpio_fan_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
+	fan_data = devm_kzalloc(&pdev->dev, sizeof(struct gpio_fan_data),
+				GFP_KERNEL);
+	if (!fan_data)
+		return -ENOMEM;
+
 #ifdef CONFIG_OF_GPIO
 	if (!pdata) {
 		pdata = devm_kzalloc(&pdev->dev,
@@ -503,20 +569,19 @@ static int gpio_fan_probe(struct platform_device *pdev)
 		if (!pdata)
 			return -ENOMEM;
 
-		err = gpio_fan_get_of_pdata(&pdev->dev, pdata);
+		err = gpio_fan_get_of_pdata(&pdev->dev, pdata, fan_data);
 		if (err)
 			return err;
 	}
 #else /* CONFIG_OF_GPIO */
 	if (!pdata)
 		return -EINVAL;
+	/* Optional cooling device register for non Device tree platforms */
+	fan_data->cdev = thermal_cooling_device_register("gpio-fan",
+							 fan_data,
+							 &gpio_fan_cooling_ops);
 #endif /* CONFIG_OF_GPIO */
 
-	fan_data = devm_kzalloc(&pdev->dev, sizeof(struct gpio_fan_data),
-				GFP_KERNEL);
-	if (!fan_data)
-		return -ENOMEM;
-
 	fan_data->pdev = pdev;
 	platform_set_drvdata(pdev, fan_data);
 	mutex_init(&fan_data->lock);
@@ -550,10 +615,23 @@ static int gpio_fan_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int gpio_fan_remove(struct platform_device *pdev)
+{
+       struct gpio_fan_data *fan_data = platform_get_drvdata(pdev);
+
+	if (!IS_ERR(fan_data->cdev))
+		thermal_cooling_device_unregister(fan_data->cdev);
+
+       return 0;
+}
+
 static void gpio_fan_shutdown(struct platform_device *pdev)
 {
 	struct gpio_fan_data *fan_data = dev_get_drvdata(&pdev->dev);
 
+	if (!IS_ERR(fan_data->cdev))
+		thermal_cooling_device_unregister(fan_data->cdev);
+
 	if (fan_data->ctrl)
 		set_fan_speed(fan_data, 0);
 }
@@ -589,6 +667,7 @@ static SIMPLE_DEV_PM_OPS(gpio_fan_pm, gpio_fan_suspend, gpio_fan_resume);
 
 static struct platform_driver gpio_fan_driver = {
 	.probe		= gpio_fan_probe,
+	.remove		= gpio_fan_remove,
 	.shutdown	= gpio_fan_shutdown,
 	.driver	= {
 		.name	= "gpio-fan",
-- 
1.7.9.5

