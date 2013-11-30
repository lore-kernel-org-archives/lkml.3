Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3K3P0y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:26:54 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:38495 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3K3P0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:26:21 -0500
From: Marek Belisko <marek@goldelico.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 1/2] misc: bmp085: Clean up and enable use of interrupt for completion.
Date: Sat, 30 Nov 2013 16:26:00 +0100
Message-Id: <1385825161-5194-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385825161-5194-1-git-send-email-marek@goldelico.com>
References: <1385825161-5194-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- pass IRQ to driver and have it initialize
- finish waiting early if interrupt fires

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/misc/bmp085-i2c.c |  2 +-
 drivers/misc/bmp085-spi.c |  2 +-
 drivers/misc/bmp085.c     | 39 ++++++++++++++++++++++++++++++++++-----
 drivers/misc/bmp085.h     |  2 +-
 4 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/bmp085-i2c.c b/drivers/misc/bmp085-i2c.c
index 3abfcec..a7c1629 100644
--- a/drivers/misc/bmp085-i2c.c
+++ b/drivers/misc/bmp085-i2c.c
@@ -49,7 +49,7 @@ static int bmp085_i2c_probe(struct i2c_client *client,
 		return err;
 	}
 
-	return bmp085_probe(&client->dev, regmap);
+	return bmp085_probe(&client->dev, regmap, client->irq);
 }
 
 static int bmp085_i2c_remove(struct i2c_client *client)
diff --git a/drivers/misc/bmp085-spi.c b/drivers/misc/bmp085-spi.c
index d6a5265..864ecac 100644
--- a/drivers/misc/bmp085-spi.c
+++ b/drivers/misc/bmp085-spi.c
@@ -41,7 +41,7 @@ static int bmp085_spi_probe(struct spi_device *client)
 		return err;
 	}
 
-	return bmp085_probe(&client->dev, regmap);
+	return bmp085_probe(&client->dev, regmap, client->irq);
 }
 
 static int bmp085_spi_remove(struct spi_device *client)
diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 2704d88..820e53d 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -49,9 +49,11 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/delay.h>
 #include <linux/of.h>
 #include "bmp085.h"
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+#include <linux/gpio.h>
 
 #define BMP085_CHIP_ID			0x55
 #define BMP085_CALIBRATION_DATA_START	0xAA
@@ -84,8 +86,19 @@ struct bmp085_data {
 	unsigned long last_temp_measurement;
 	u8	chip_id;
 	s32	b6; /* calculated temperature correction coefficient */
+	int	irq;
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
@@ -116,6 +129,9 @@ static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 	s32 status;
 
 	mutex_lock(&data->lock);
+
+	init_completion(&data->done);
+
 	status = regmap_write(data->regmap, BMP085_CTRL_REG,
 			      BMP085_TEMP_MEASUREMENT);
 	if (status < 0) {
@@ -123,7 +139,8 @@ static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 			"Error while requesting temperature measurement.\n");
 		goto exit;
 	}
-	msleep(BMP085_TEMP_CONVERSION_TIME);
+	wait_for_completion_timeout(&data->done, 1 + msecs_to_jiffies(
+					    BMP085_TEMP_CONVERSION_TIME));
 
 	status = regmap_bulk_read(data->regmap, BMP085_CONVERSION_REGISTER_MSB,
 				 &tmp, sizeof(tmp));
@@ -147,6 +164,9 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 	s32 status;
 
 	mutex_lock(&data->lock);
+
+	init_completion(&data->done);
+
 	status = regmap_write(data->regmap, BMP085_CTRL_REG,
 			BMP085_PRESSURE_MEASUREMENT +
 			(data->oversampling_setting << 6));
@@ -157,8 +177,8 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 	}
 
 	/* wait for the end of conversion */
-	msleep(2+(3 << data->oversampling_setting));
-
+	wait_for_completion_timeout(&data->done, 1 + msecs_to_jiffies(
+					2+(3 << data->oversampling_setting)));
 	/* copy data into a u32 (4 bytes), but skip the first byte. */
 	status = regmap_bulk_read(data->regmap, BMP085_CONVERSION_REGISTER_MSB,
 				 ((u8 *)&tmp)+1, 3);
@@ -420,7 +440,7 @@ struct regmap_config bmp085_regmap_config = {
 };
 EXPORT_SYMBOL_GPL(bmp085_regmap_config);
 
-int bmp085_probe(struct device *dev, struct regmap *regmap)
+int bmp085_probe(struct device *dev, struct regmap *regmap, int irq)
 {
 	struct bmp085_data *data;
 	int err = 0;
@@ -434,6 +454,15 @@ int bmp085_probe(struct device *dev, struct regmap *regmap)
 	dev_set_drvdata(dev, data);
 	data->dev = dev;
 	data->regmap = regmap;
+	data->irq = irq;
+
+	if (data->irq > 0) {
+		err = devm_request_irq(dev, data->irq, bmp085_eoc_isr,
+					      IRQF_TRIGGER_RISING, "bmp085",
+					      data);
+		if (err < 0)
+			goto exit_free;
+	}
 
 	/* Initialize the BMP085 chip */
 	err = bmp085_init_client(data);
diff --git a/drivers/misc/bmp085.h b/drivers/misc/bmp085.h
index 2b8f615..8b8e3b1 100644
--- a/drivers/misc/bmp085.h
+++ b/drivers/misc/bmp085.h
@@ -26,7 +26,7 @@
 
 extern struct regmap_config bmp085_regmap_config;
 
-int bmp085_probe(struct device *dev, struct regmap *regmap);
+int bmp085_probe(struct device *dev, struct regmap *regmap, int irq);
 int bmp085_remove(struct device *dev);
 int bmp085_detect(struct device *dev);
 
-- 
1.8.3.2

