Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab3IIK3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:29:15 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8108 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab3IIK2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:28:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Sep 2013 03:25:51 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>
CC: <broonie@kernel.org>, <swarren@wwwdotorg.org>, <lm-sensors@lm-sensors.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>
Subject: [PATCH v3 1/2] hwmon: (lm90) Add power control
Date: Mon, 9 Sep 2013 18:29:11 +0800
Message-ID: <1378722552-10357-2-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378722552-10357-1-git-send-email-wni@nvidia.com>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device lm90 can be controlled by the vcc rail.
Adding the regulator support to power on/off the vcc rail.
Enable the "vcc" regulator before accessing the device.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/hwmon/lm90.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index cdff742..bd313f4 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -89,6 +89,8 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/regulator/consumer.h>
+#include <linux/delay.h>
 
 /*
  * Addresses to scan
@@ -302,6 +304,7 @@ static const struct lm90_params lm90_params[] = {
 struct lm90_data {
 	struct device *hwmon_dev;
 	struct mutex update_lock;
+	struct regulator *lm90_reg;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
 	int kind;
@@ -1397,8 +1400,23 @@ static int lm90_probe(struct i2c_client *client,
 	struct device *dev = &client->dev;
 	struct i2c_adapter *adapter = to_i2c_adapter(dev->parent);
 	struct lm90_data *data;
+	struct regulator *reg;
 	int err;
 
+	reg = devm_regulator_get_optional(dev, "vcc");
+	if (!IS_ERR(reg)) {
+		err = regulator_enable(reg);
+		if (err < 0) {
+			dev_err(&client->dev,
+				"Failed to enable regulator: %d\n", err);
+			return err;
+		}
+		msleep(25);
+	} else {
+		if (PTR_ERR(reg) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+	}
+
 	data = devm_kzalloc(&client->dev, sizeof(struct lm90_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -1406,6 +1424,8 @@ static int lm90_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->update_lock);
 
+	data->lm90_reg = reg;
+
 	/* Set the device type */
 	data->kind = id->driver_data;
 	if (data->kind == adm1032) {
@@ -1473,6 +1493,9 @@ exit_remove_files:
 	lm90_remove_files(client, data);
 exit_restore:
 	lm90_restore_conf(client, data);
+	if (!IS_ERR(data->lm90_reg))
+		regulator_disable(data->lm90_reg);
+
 	return err;
 }
 
@@ -1483,6 +1506,8 @@ static int lm90_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	lm90_remove_files(client, data);
 	lm90_restore_conf(client, data);
+	if (!IS_ERR(data->lm90_reg))
+		regulator_disable(data->lm90_reg);
 
 	return 0;
 }
-- 
1.7.9.5

