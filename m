Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3ILLXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:23:45 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11577 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3ILLXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:23:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Sep 2013 04:23:43 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <broonie@kernel.org>,
        <swarren@wwwdotorg.org>
CC: <lm-sensors@lm-sensors.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v4 1/3] hwmon: (lm90) Add power control
Date: Thu, 12 Sep 2013 19:24:19 +0800
Message-ID: <1378985061-28547-2-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378985061-28547-1-git-send-email-wni@nvidia.com>
References: <1378985061-28547-1-git-send-email-wni@nvidia.com>
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
 drivers/hwmon/lm90.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index cdff742..f3f66d5 100644
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
@@ -1397,8 +1400,20 @@ static int lm90_probe(struct i2c_client *client,
 	struct device *dev = &client->dev;
 	struct i2c_adapter *adapter = to_i2c_adapter(dev->parent);
 	struct lm90_data *data;
+	struct regulator *reg;
 	int err;
 
+	reg = devm_regulator_get(dev, "vcc");
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
+	err = regulator_enable(reg);
+	if (err < 0) {
+		dev_err(&client->dev,
+			"Failed to enable regulator: %d\n", err);
+		return err;
+	}
+
 	data = devm_kzalloc(&client->dev, sizeof(struct lm90_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -1406,6 +1421,8 @@ static int lm90_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->update_lock);
 
+	data->lm90_reg = reg;
+
 	/* Set the device type */
 	data->kind = id->driver_data;
 	if (data->kind == adm1032) {
@@ -1473,6 +1490,8 @@ exit_remove_files:
 	lm90_remove_files(client, data);
 exit_restore:
 	lm90_restore_conf(client, data);
+	regulator_disable(data->lm90_reg);
+
 	return err;
 }
 
@@ -1483,6 +1502,7 @@ static int lm90_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	lm90_remove_files(client, data);
 	lm90_restore_conf(client, data);
+	regulator_disable(data->lm90_reg);
 
 	return 0;
 }
-- 
1.7.9.5

