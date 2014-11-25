Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035AbaKYPrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:47:14 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37357 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaKYPrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:47:13 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case of configuration errors
Date: Tue, 25 Nov 2014 16:46:59 +0100
Message-Id: <1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of i2c_smbus_write_word_swapped() isn't checked in
ina2xx_probe(). This leads to devices being registered even if they can not
be physically detected (e.g. device is not powered-up at boot-time).

Even after restoring power to such device, it is left unconfigured as the
configuration has never been actually written to the register.

Error out in case of write errors in probe and notify the user.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/ina2xx.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index bfd3f3e..660f8ca 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -110,6 +110,40 @@ static const struct ina2xx_config ina2xx_config[] = {
 	},
 };
 
+static int ina2xx_write_register(const struct i2c_client *client,
+						u8 reg, u16 value)
+{
+	return i2c_smbus_write_word_swapped(client, reg, value);
+}
+
+static int ina2xx_configure(const struct i2c_client *client, u16 value)
+{
+	int status;
+
+	status = ina2xx_write_register(client, INA2XX_CONFIG, value);
+	if (status < 0) {
+		dev_err(&client->dev,
+			"error writing to configuration register: %d\n",
+			status);
+	}
+
+	return status;
+}
+
+static int ina2xx_calibrate(const struct i2c_client *client, u16 value)
+{
+	int status;
+
+	status = ina2xx_write_register(client, INA2XX_CALIBRATION, value);
+	if (status < 0) {
+		dev_err(&client->dev,
+			"error writing to calibration register: %d\n",
+			status);
+	}
+
+	return status;
+}
+
 static struct ina2xx_data *ina2xx_update_device(struct device *dev)
 {
 	struct ina2xx_data *data = dev_get_drvdata(dev);
@@ -247,12 +281,15 @@ static int ina2xx_probe(struct i2c_client *client,
 	data->config = &ina2xx_config[data->kind];
 
 	/* device configuration */
-	i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
-				     data->config->config_default);
-	/* set current LSB to 1mA, shunt is in uOhms */
-	/* (equation 13 in datasheet) */
-	i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
-				     data->config->calibration_factor / shunt);
+	if (ina2xx_configure(client, data->config->config_default) < 0)
+		return -ENODEV;
+
+	/* Set current LSB to 1mA, shunt is in uOhms
+	 * (equation 13 in datasheet).
+	 */
+	if (ina2xx_calibrate(client,
+			data->config->calibration_factor / shunt) < 0)
+		return -ENODEV;
 
 	data->client = client;
 	mutex_init(&data->update_lock);
-- 
2.1.3

