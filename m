Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaLDQqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:46:04 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56647 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643AbaLDQqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:46:02 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 3/3] hwmon: tmp401: bail-out from tmp401_probe() in case of write errors
Date: Thu,  4 Dec 2014 17:45:53 +0100
Message-Id: <1417711553-21311-4-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417711553-21311-1-git-send-email-bgolaszewski@baylibre.com>
References: <1417711553-21311-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of i2c_smbus_read_byte_data() is checked in
tmp401_init_client(), but only a warning is printed and the device is
registered anyway. This leads to devices being registered even if they
cannot be physically detected.

Bail-out from probe in case of write errors and notify the user.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/tmp401.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index ccd9938..f2182ee 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -615,10 +615,10 @@ static const struct attribute_group tmp432_group = {
  * Begin non sysfs callback code (aka Real code)
  */
 
-static void tmp401_init_client(struct tmp401_data *data,
-			       struct i2c_client *client)
+static int tmp401_init_client(struct tmp401_data *data,
+			      struct i2c_client *client)
 {
-	int config, config_orig;
+	int config, config_orig, status = 0;
 
 	/* Set the conversion rate to 2 Hz */
 	i2c_smbus_write_byte_data(client, TMP401_CONVERSION_RATE_WRITE, 5);
@@ -626,16 +626,18 @@ static void tmp401_init_client(struct tmp401_data *data,
 
 	/* Start conversions (disable shutdown if necessary) */
 	config = i2c_smbus_read_byte_data(client, TMP401_CONFIG_READ);
-	if (config < 0) {
-		dev_warn(&client->dev, "Initialization failed!\n");
-		return;
-	}
+	if (config < 0)
+		return config;
 
 	config_orig = config;
 	config &= ~TMP401_CONFIG_SHUTDOWN;
 
 	if (config != config_orig)
-		i2c_smbus_write_byte_data(client, TMP401_CONFIG_WRITE, config);
+		status = i2c_smbus_write_byte_data(client,
+						   TMP401_CONFIG_WRITE,
+						   config);
+
+	return status;
 }
 
 static int tmp401_detect(struct i2c_client *client,
@@ -718,7 +720,7 @@ static int tmp401_probe(struct i2c_client *client,
 	struct device *dev = &client->dev;
 	struct device *hwmon_dev;
 	struct tmp401_data *data;
-	int groups = 0;
+	int groups = 0, status;
 
 	data = devm_kzalloc(dev, sizeof(struct tmp401_data), GFP_KERNEL);
 	if (!data)
@@ -729,7 +731,9 @@ static int tmp401_probe(struct i2c_client *client,
 	data->kind = id->driver_data;
 
 	/* Initialize the TMP401 chip */
-	tmp401_init_client(data, client);
+	status = tmp401_init_client(data, client);
+	if (status < 0)
+		return status;
 
 	/* Register sysfs hooks */
 	data->groups[groups++] = &tmp401_group;
-- 
2.1.3

