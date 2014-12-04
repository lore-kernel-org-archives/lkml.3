Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaLDJ6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:58:10 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61662 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaLDJ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:58:00 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 2/2] hwmon: tmp401: bail-out from tmp401_probe() in case of write errors
Date: Thu,  4 Dec 2014 10:57:28 +0100
Message-Id: <1417687048-21455-3-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417687048-21455-1-git-send-email-bgolaszewski@baylibre.com>
References: <1417687048-21455-1-git-send-email-bgolaszewski@baylibre.com>
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
 drivers/hwmon/tmp401.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index 5a72d7f..75b3210 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -618,8 +618,8 @@ static const struct attribute_group tmp432_group = {
  * Begin non sysfs callback code (aka Real code)
  */
 
-static void tmp401_init_client(struct tmp401_data *data,
-			       struct i2c_client *client)
+static int tmp401_init_client(struct tmp401_data *data,
+			      struct i2c_client *client)
 {
 	int config, config_orig;
 
@@ -630,8 +630,8 @@ static void tmp401_init_client(struct tmp401_data *data,
 	/* Start conversions (disable shutdown if necessary) */
 	config = i2c_smbus_read_byte_data(client, TMP401_CONFIG_READ);
 	if (config < 0) {
-		dev_warn(&client->dev, "Initialization failed!\n");
-		return;
+		dev_err(&client->dev, "Initialization failed!");
+		return config;
 	}
 
 	config_orig = config;
@@ -639,6 +639,8 @@ static void tmp401_init_client(struct tmp401_data *data,
 
 	if (config != config_orig)
 		i2c_smbus_write_byte_data(client, TMP401_CONFIG_WRITE, config);
+
+	return 0;
 }
 
 static int tmp401_detect(struct i2c_client *client,
@@ -721,7 +723,7 @@ static int tmp401_probe(struct i2c_client *client,
 	struct device *dev = &client->dev;
 	struct device *hwmon_dev;
 	struct tmp401_data *data;
-	int groups = 0;
+	int groups = 0, status;
 
 	data = devm_kzalloc(dev, sizeof(struct tmp401_data), GFP_KERNEL);
 	if (!data)
@@ -732,7 +734,9 @@ static int tmp401_probe(struct i2c_client *client,
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

