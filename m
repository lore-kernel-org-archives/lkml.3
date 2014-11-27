Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaK0KBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:01:25 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56186 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaK0J72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:59:28 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <jdelvare@suse.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case of configuration errors
Date: Thu, 27 Nov 2014 10:59:06 +0100
Message-Id: <1417082350-23470-2-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417082350-23470-1-git-send-email-bgolaszewski@baylibre.com>
References: <1417082350-23470-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of i2c_smbus_write_word_swapped() isn't checked in
ina2xx_probe(). This leads to devices being registered even if they cannot
be physically detected (e.g. device is not powered-up at boot-time).

Even after restoring power to such device, it is left unconfigured as the
configuration has never been actually written to the register.

Error out in case of write errors in probe and notify the user.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/ina2xx.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index bfd3f3e..0a6b60f 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -223,6 +223,7 @@ static int ina2xx_probe(struct i2c_client *client,
 	struct device *hwmon_dev;
 	long shunt = 10000; /* default shunt value 10mOhms */
 	u32 val;
+	int ret;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -ENODEV;
@@ -247,12 +248,24 @@ static int ina2xx_probe(struct i2c_client *client,
 	data->config = &ina2xx_config[data->kind];
 
 	/* device configuration */
-	i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
-				     data->config->config_default);
-	/* set current LSB to 1mA, shunt is in uOhms */
-	/* (equation 13 in datasheet) */
-	i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
-				     data->config->calibration_factor / shunt);
+	ret = i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
+					   data->config->config_default);
+	if (ret < 0) {
+		dev_err(dev,
+			"error writing to the config register: %d", ret);
+		return -ENODEV;
+	}
+
+	/* Set current LSB to 1mA, shunt is in uOhms
+	 * (equation 13 in datasheet).
+	 */
+	ret = i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
+				data->config->calibration_factor / shunt);
+	if (ret < 0) {
+		dev_err(dev,
+			"error writing to the calibration register: %d", ret);
+		return -ENODEV;
+	}
 
 	data->client = client;
 	mutex_init(&data->update_lock);
-- 
2.1.3

