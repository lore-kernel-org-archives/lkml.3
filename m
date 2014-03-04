Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbaCDLbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:31:37 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11067 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbaCDLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:30:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 04 Mar 2014 03:26:46 -0800
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 2/3] hwmon: lm90: expose to thermal fw via DT nodes
Date: Tue, 4 Mar 2014 19:31:03 +0800
Message-ID: <1393932664-13319-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393932664-13319-1-git-send-email-wni@nvidia.com>
References: <1393932664-13319-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to lm90 temperature sensor the possibility
to expose itself as thermal zone device, registered on the
thermal framework.

The thermal zone is built only if a device tree node
describing a thermal zone for this sensor is present
inside the lm90 DT node. Otherwise, the driver behavior
will be the same.

Change-Id: Ie263e8973ec45d057fddadd3042c7d3fefdf4acc
Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/hwmon/lm90.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index cb33dcf..2a385c5 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -96,6 +96,8 @@
 #include <linux/sysfs.h>
 #include <linux/interrupt.h>
 #include <linux/regulator/consumer.h>
+#include <linux/of.h>
+#include <linux/thermal.h>
 
 /*
  * Addresses to scan
@@ -119,6 +121,13 @@ static const unsigned short normal_i2c[] = {
 enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 	max6646, w83l771, max6696, sa56004, g781, tmp451 };
 
+enum sensor_id {
+	LOCAL = 0,
+	REMOTE,
+	REMOTE2,
+	SENSOR_ID_END,
+};
+
 /*
  * The LM90 registers
  */
@@ -368,6 +377,7 @@ struct lm90_data {
 	struct i2c_client *client;
 	struct device *hwmon_dev;
 	const struct attribute_group *groups[6];
+	struct thermal_zone_device *tz[SENSOR_ID_END];
 	struct mutex update_lock;
 	struct regulator *regulator;
 	char valid; /* zero until following fields are valid */
@@ -874,6 +884,24 @@ static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
 	return sprintf(buf, "%d\n", read_temp11(dev, attr->index));
 }
 
+static int lm90_read_local_temp(void *dev, long *temp)
+{
+	*temp = read_temp11(dev, LOCAL_TEMP);
+	return 0;
+}
+
+static int lm90_read_remote_temp(void *dev, long *temp)
+{
+	*temp = read_temp11(dev, REMOTE_TEMP);
+	return 0;
+}
+
+static int lm90_read_remote2_temp(void *dev, long *temp)
+{
+	*temp = read_temp11(dev, REMOTE2_TEMP);
+	return 0;
+}
+
 static int write_temp11(struct device *dev, int nr, int index, long val)
 {
 	struct {
@@ -1653,6 +1681,33 @@ static int lm90_probe(struct i2c_client *client,
 		}
 	}
 
+	data->tz[LOCAL] = thermal_zone_of_sensor_register(&client->dev,
+							LOCAL,
+							&client->dev,
+							lm90_read_local_temp,
+							NULL);
+	if (IS_ERR(data->tz[LOCAL]))
+		data->tz[LOCAL] = NULL;
+
+	data->tz[REMOTE] = thermal_zone_of_sensor_register(&client->dev,
+							REMOTE,
+							&client->dev,
+							lm90_read_remote_temp,
+							NULL);
+	if (IS_ERR(data->tz[REMOTE]))
+		data->tz[REMOTE] = NULL;
+
+	if (data->flags & LM90_HAVE_TEMP3) {
+		data->tz[REMOTE2] = thermal_zone_of_sensor_register(
+							&client->dev,
+							REMOTE2,
+							&client->dev,
+							lm90_read_remote2_temp,
+							NULL);
+		if (IS_ERR(data->tz[REMOTE2]))
+			data->tz[REMOTE2] = NULL;
+	}
+
 	return 0;
 
 exit_unregister:
@@ -1668,8 +1723,11 @@ exit_restore:
 
 static int lm90_remove(struct i2c_client *client)
 {
+	int i;
 	struct lm90_data *data = i2c_get_clientdata(client);
 
+	for (i = 0; i < SENSOR_ID_END; i++)
+		thermal_zone_of_sensor_unregister(&client->dev, data->tz[i]);
 	hwmon_device_unregister(data->hwmon_dev);
 	device_remove_file(&client->dev, &dev_attr_pec);
 	lm90_restore_conf(client, data);
-- 
1.7.9.5

