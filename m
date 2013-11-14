Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3KNVrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:47:35 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50192 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3KNVrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:47:05 -0500
From: Marek Belisko <marek@goldelico.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: neilb@suse.de, hns@goldelico.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 1/3] misc: bmp085: Clean up and enable use of interrupt for completion.
Date: Thu, 14 Nov 2013 22:46:47 +0100
Message-Id: <1384465609-26485-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384465609-26485-1-git-send-email-marek@goldelico.com>
References: <1384465609-26485-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- pass GPIO or IRQ to driver and have it initialize the GPIO and
  the IRQ
- finish waiting early if interrupt fires
- clean up GPIO and IRQ on exit.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/misc/bmp085.c      | 68 +++++++++++++++++++++++++++++++++++++++++-----
 include/linux/i2c/bmp085.h | 17 ++++++++++++
 2 files changed, 78 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/i2c/bmp085.h

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 2704d88..1510a7b 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -49,9 +49,12 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/delay.h>
 #include <linux/of.h>
 #include "bmp085.h"
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+#include <linux/gpio.h>
+#include <linux/i2c/bmp085.h>
 
 #define BMP085_CHIP_ID			0x55
 #define BMP085_CALIBRATION_DATA_START	0xAA
@@ -84,8 +87,20 @@ struct bmp085_data {
 	unsigned long last_temp_measurement;
 	u8	chip_id;
 	s32	b6; /* calculated temperature correction coefficient */
+	int	irq;
+	int	gpio;
+	struct	completion done;
 };
 
+static irqreturn_t bmp085_eoc_isr(int irq, void *devid)
+{
+	struct bmp085_data *data = devid;
+
+	complete(&data->done);
+
+	return IRQ_HANDLED;
+}
+
 static s32 bmp085_read_calibration_data(struct bmp085_data *data)
 {
 	u16 tmp[BMP085_CALIBRATION_DATA_LENGTH];
@@ -116,6 +131,9 @@ static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 	s32 status;
 
 	mutex_lock(&data->lock);
+
+	init_completion(&data->done);
+
 	status = regmap_write(data->regmap, BMP085_CTRL_REG,
 			      BMP085_TEMP_MEASUREMENT);
 	if (status < 0) {
@@ -123,7 +141,8 @@ static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 			"Error while requesting temperature measurement.\n");
 		goto exit;
 	}
-	msleep(BMP085_TEMP_CONVERSION_TIME);
+	wait_for_completion_timeout(&data->done, 1 + msecs_to_jiffies(
+					    BMP085_TEMP_CONVERSION_TIME));
 
 	status = regmap_bulk_read(data->regmap, BMP085_CONVERSION_REGISTER_MSB,
 				 &tmp, sizeof(tmp));
@@ -147,6 +166,9 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 	s32 status;
 
 	mutex_lock(&data->lock);
+
+	init_completion(&data->done);
+
 	status = regmap_write(data->regmap, BMP085_CTRL_REG,
 			BMP085_PRESSURE_MEASUREMENT +
 			(data->oversampling_setting << 6));
@@ -157,8 +179,8 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 	}
 
 	/* wait for the end of conversion */
-	msleep(2+(3 << data->oversampling_setting));
-
+	wait_for_completion_timeout(&data->done, 1 + msecs_to_jiffies(
+					2+(3 << data->oversampling_setting)));
 	/* copy data into a u32 (4 bytes), but skip the first byte. */
 	status = regmap_bulk_read(data->regmap, BMP085_CONVERSION_REGISTER_MSB,
 				 ((u8 *)&tmp)+1, 3);
@@ -423,6 +445,7 @@ EXPORT_SYMBOL_GPL(bmp085_regmap_config);
 int bmp085_probe(struct device *dev, struct regmap *regmap)
 {
 	struct bmp085_data *data;
+	struct bmp085_platform_data *pdata = dev->platform_data;
 	int err = 0;
 
 	data = kzalloc(sizeof(struct bmp085_data), GFP_KERNEL);
@@ -435,26 +458,54 @@ int bmp085_probe(struct device *dev, struct regmap *regmap)
 	data->dev = dev;
 	data->regmap = regmap;
 
+	if (pdata && gpio_is_valid(pdata->gpio)) {
+		err = devm_gpio_request(dev, pdata->gpio, "bmp085_eoc_irq");
+		if (err)
+			goto exit_free;
+		err = gpio_direction_input(pdata->gpio);
+		if (err)
+			goto exit_free;
+		data->irq = gpio_to_irq(pdata->gpio);
+		data->gpio = pdata->gpio;
+	} else {
+		if (pdata)
+			data->irq = pdata->irq;
+		else
+			data->irq = 0;
+		data->gpio = -EINVAL;
+	}
+	if (data->irq > 0) {
+		err = request_any_context_irq(data->irq, bmp085_eoc_isr,
+					      IRQF_TRIGGER_RISING, "bmp085",
+					      data);
+		if (err < 0)
+			goto exit_free;
+	} else
+		data->irq = 0;
+
 	/* Initialize the BMP085 chip */
 	err = bmp085_init_client(data);
 	if (err < 0)
-		goto exit_free;
+		goto exit_free_irq;
 
 	err = bmp085_detect(dev);
 	if (err < 0) {
 		dev_err(dev, "%s: chip_id failed!\n", BMP085_NAME);
-		goto exit_free;
+		goto exit_free_irq;
 	}
 
 	/* Register sysfs hooks */
 	err = sysfs_create_group(&dev->kobj, &bmp085_attr_group);
 	if (err)
-		goto exit_free;
+		goto exit_free_irq;
 
 	dev_info(dev, "Successfully initialized %s!\n", BMP085_NAME);
 
 	return 0;
 
+exit_free_irq:
+	if (data->irq)
+		free_irq(data->irq, data);
 exit_free:
 	kfree(data);
 exit:
@@ -466,6 +517,9 @@ int bmp085_remove(struct device *dev)
 {
 	struct bmp085_data *data = dev_get_drvdata(dev);
 
+	if (data->irq)
+		free_irq(data->irq, data);
+
 	sysfs_remove_group(&data->dev->kobj, &bmp085_attr_group);
 	kfree(data);
 
diff --git a/include/linux/i2c/bmp085.h b/include/linux/i2c/bmp085.h
new file mode 100644
index 0000000..b66cb98
--- /dev/null
+++ b/include/linux/i2c/bmp085.h
@@ -0,0 +1,17 @@
+#ifndef __LINUX_I2C_BMP085_H
+#define __LINUX_I2C_BMP085_H
+
+/* linux/i2c/bmp085.h */
+
+/*
+ * bmp085 platform data
+ * @gpio: if is set it is the End Of Conversion line which is high when
+ * conversion is finished
+ * @irq: if gpio < 0 and irq > 0, then it is an interrupt with no gpio
+ */
+struct bmp085_platform_data {
+	int	gpio;
+	int	irq;
+};
+
+#endif
-- 
1.8.1.2

