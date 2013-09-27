Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3I0DQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:16:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42104 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab3I0DQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:16:36 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>
CC: <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCHv4 07/18] hwmon: lm75: expose to thermal fw via DT nodes
Date: Thu, 26 Sep 2013 23:13:14 -0400
Message-ID: <1380251605-3804-8-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to lm75 temperature sensor the possibility
to expose itself as thermal zone device, registered on the
thermal framework.

The thermal zone is built only if a device tree node
describing a thermal zone for this sensor is present
inside the lm75 DT node. Otherwise, the driver behavior
will be the same.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/hwmon/lm75.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index c03b490..1d3600a 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -27,6 +27,8 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/thermal.h>
 #include "lm75.h"
 
 
@@ -70,6 +72,7 @@ static const u8 LM75_REG_TEMP[3] = {
 /* Each client has this additional data */
 struct lm75_data {
 	struct device		*hwmon_dev;
+	struct thermal_zone_device	*tz;
 	struct mutex		update_lock;
 	u8			orig_conf;
 	u8			resolution;	/* In bits, between 9 and 12 */
@@ -90,22 +93,36 @@ static struct lm75_data *lm75_update_device(struct device *dev);
 
 /*-----------------------------------------------------------------------*/
 
+static inline long lm75_reg_to_mc(s16 temp, u8 resolution)
+{
+	return ((temp >> (16 - resolution)) * 1000) >> (resolution - 8);
+}
+
 /* sysfs attributes for hwmon */
 
+static int lm75_read_temp(void *dev, long *temp)
+{
+	struct lm75_data *data = lm75_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	*temp = lm75_reg_to_mc(data->temp[0], data->resolution);
+
+	return 0;
+}
+
 static ssize_t show_temp(struct device *dev, struct device_attribute *da,
 			 char *buf)
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
 	struct lm75_data *data = lm75_update_device(dev);
-	long temp;
 
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	temp = ((data->temp[attr->index] >> (16 - data->resolution)) * 1000)
-	       >> (data->resolution - 8);
-
-	return sprintf(buf, "%ld\n", temp);
+	return sprintf(buf, "%ld\n", lm75_reg_to_mc(data->temp[attr->index],
+						    data->resolution));
 }
 
 static ssize_t set_temp(struct device *dev, struct device_attribute *da,
@@ -271,6 +288,13 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		goto exit_remove;
 	}
 
+	data->tz = thermal_zone_of_sensor_register(&client->dev,
+						   0,
+						   &client->dev,
+						   lm75_read_temp, NULL);
+	if (IS_ERR(data->tz))
+		data->tz = NULL;
+
 	dev_info(&client->dev, "%s: sensor '%s'\n",
 		 dev_name(data->hwmon_dev), client->name);
 
@@ -285,6 +309,7 @@ static int lm75_remove(struct i2c_client *client)
 {
 	struct lm75_data *data = i2c_get_clientdata(client);
 
+	thermal_zone_of_sensor_unregister(&client->dev, data->tz);
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm75_group);
 	lm75_write_value(client, LM75_REG_CONF, data->orig_conf);
-- 
1.8.2.1.342.gfa7285d

