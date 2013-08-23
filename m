Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3HWXSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:18:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58157 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab3HWXSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:18:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <linux@roeck-us.net>, <rui.zhang@intel.com>,
        <wni@nvidia.com>
CC: <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [RFC PATCH 04/14] hwmon: tmp102: expose to thermal fw via DT nodes
Date: Fri, 23 Aug 2013 19:15:45 -0400
Message-ID: <1377299755-5134-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to tmp102 temperature sensor the possibility
to expose itself as thermal zone device, registered on the
thermal framework.

The thermal zone is built only if a device tree node
describing a thermal zone for this sensor is present
inside the tmp102 DT node. Otherwise, the driver behavior
will be the same.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/hwmon/tmp102.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index d7b47ab..0f1e44a 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -27,6 +27,8 @@
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/jiffies.h>
+#include <linux/thermal.h>
+#include <linux/of.h>
 
 #define	DRIVER_NAME "tmp102"
 
@@ -50,6 +52,7 @@
 
 struct tmp102 {
 	struct device *hwmon_dev;
+	struct thermal_zone_device *tz;
 	struct mutex lock;
 	u16 config_orig;
 	unsigned long last_update;
@@ -93,6 +96,15 @@ static struct tmp102 *tmp102_update_device(struct i2c_client *client)
 	return tmp102;
 }
 
+static int tmp102_read_temp(void *dev, unsigned long *temp)
+{
+	struct tmp102 *tmp102 = tmp102_update_device(to_i2c_client(dev));
+
+	*temp = tmp102->temp[0];
+
+	return 0;
+}
+
 static ssize_t tmp102_show_temp(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -204,10 +216,23 @@ static int tmp102_probe(struct i2c_client *client,
 		goto fail_remove_sysfs;
 	}
 
+	if (of_find_property(client->dev.of_node, "monitored-zones", NULL)) {
+		tmp102->tz = thermal_zone_of_device_register(&client->dev, 0,
+							     false, /* -hwmon */
+							     &client->dev,
+							     tmp102_read_temp);
+		if (IS_ERR(tmp102->tz)) {
+			status = PTR_ERR(tmp102->tz);
+			goto exit_hwmon;
+		}
+	}
+
 	dev_info(&client->dev, "initialized\n");
 
 	return 0;
 
+exit_hwmon:
+	hwmon_device_unregister(tmp102->hwmon_dev);
 fail_remove_sysfs:
 	sysfs_remove_group(&client->dev.kobj, &tmp102_attr_group);
 fail_restore_config:
@@ -220,6 +245,7 @@ static int tmp102_remove(struct i2c_client *client)
 {
 	struct tmp102 *tmp102 = i2c_get_clientdata(client);
 
+	thermal_zone_device_unregister(tmp102->tz);
 	hwmon_device_unregister(tmp102->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &tmp102_attr_group);
 
-- 
1.8.2.1.342.gfa7285d

