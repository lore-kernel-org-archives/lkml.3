Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaHYGap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:30:45 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13061 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaHYGan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:30:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 24 Aug 2014 23:20:45 -0700
From: Wei Ni <wni@nvidia.com>
To: <edubezval@gmail.com>, <khali@linux-fr.org>, <linux@roeck-us.net>,
        <swarren@wwwdotorg.org>
CC: <lm-sensors@lm-sensors.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, lightning314 <wni@nvidia.com>
Subject: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common codes
Date: Mon, 25 Aug 2014 14:29:45 +0800
Message-ID: <1408948188-4181-2-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408948188-4181-1-git-send-email-wni@nvidia.com>
References: <1408948188-4181-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: lightning314 <wni@nvidia.com>

Split set&show temp codes as common functions, so we can use it
directly when implement linux thermal framework.
And handle error return value for the lm90_select_remote_channel
and write_tempx, then set_temp8 and set_temp11 could return it
to user-space.

Signed-off-by: Wei Ni <wni@nvidia.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/hwmon/lm90.c | 164 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 109 insertions(+), 55 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index c9ff08d..cb33dcf 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -473,20 +473,23 @@ static int lm90_read16(struct i2c_client *client, u8 regh, u8 regl, u16 *value)
  * various registers have different meanings as a result of selecting a
  * non-default remote channel.
  */
-static inline void lm90_select_remote_channel(struct i2c_client *client,
-					      struct lm90_data *data,
-					      int channel)
+static inline int lm90_select_remote_channel(struct i2c_client *client,
+					     struct lm90_data *data,
+					     int channel)
 {
 	u8 config;
+	int err = 0;
 
 	if (data->kind == max6696) {
 		lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
 		config &= ~0x08;
 		if (channel)
 			config |= 0x08;
-		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
-					  config);
+		err = i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
+						config);
 	}
+
+	return err;
 }
 
 /*
@@ -759,29 +762,34 @@ static u16 temp_to_u16_adt7461(struct lm90_data *data, long val)
  * Sysfs stuff
  */
 
-static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
-			  char *buf)
+static int read_temp8(struct device *dev, int index)
 {
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct lm90_data *data = lm90_update_device(dev);
 	int temp;
 
 	if (data->kind == adt7461 || data->kind == tmp451)
-		temp = temp_from_u8_adt7461(data, data->temp8[attr->index]);
+		temp = temp_from_u8_adt7461(data, data->temp8[index]);
 	else if (data->kind == max6646)
-		temp = temp_from_u8(data->temp8[attr->index]);
+		temp = temp_from_u8(data->temp8[index]);
 	else
-		temp = temp_from_s8(data->temp8[attr->index]);
+		temp = temp_from_s8(data->temp8[index]);
 
 	/* +16 degrees offset for temp2 for the LM99 */
-	if (data->kind == lm99 && attr->index == 3)
+	if (data->kind == lm99 && index == 3)
 		temp += 16000;
 
-	return sprintf(buf, "%d\n", temp);
+	return temp;
 }
 
-static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
-			 const char *buf, size_t count)
+static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
+			  char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "%d\n", read_temp8(dev, attr->index));
+}
+
+static int write_temp8(struct device *dev, int index, long val)
 {
 	static const u8 reg[TEMP8_REG_NUM] = {
 		LM90_REG_W_LOCAL_LOW,
@@ -794,60 +802,79 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
 		MAX6659_REG_W_REMOTE_EMERG,
 	};
 
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct lm90_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
-	int nr = attr->index;
-	long val;
 	int err;
 
-	err = kstrtol(buf, 10, &val);
-	if (err < 0)
-		return err;
-
 	/* +16 degrees offset for temp2 for the LM99 */
-	if (data->kind == lm99 && attr->index == 3)
+	if (data->kind == lm99 && index == 3)
 		val -= 16000;
 
 	mutex_lock(&data->update_lock);
 	if (data->kind == adt7461 || data->kind == tmp451)
-		data->temp8[nr] = temp_to_u8_adt7461(data, val);
+		data->temp8[index] = temp_to_u8_adt7461(data, val);
 	else if (data->kind == max6646)
-		data->temp8[nr] = temp_to_u8(val);
+		data->temp8[index] = temp_to_u8(val);
 	else
-		data->temp8[nr] = temp_to_s8(val);
-
-	lm90_select_remote_channel(client, data, nr >= 6);
-	i2c_smbus_write_byte_data(client, reg[nr], data->temp8[nr]);
-	lm90_select_remote_channel(client, data, 0);
+		data->temp8[index] = temp_to_s8(val);
 
+	if ((err = lm90_select_remote_channel(client, data, index >= 6)) ||
+	    (err = i2c_smbus_write_byte_data(client, reg[index],
+					     data->temp8[index])) ||
+	    (err = lm90_select_remote_channel(client, data, 0)))
+		dev_err(dev, "write_temp8 failed, err %d\n", err);
 	mutex_unlock(&data->update_lock);
+
+	return err;
+}
+
+static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
+			 const char *buf, size_t count)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	int index = attr->index;
+	long val;
+	int err;
+
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
+		return err;
+
+	err = write_temp8(dev, index, val);
+	if (err < 0)
+		return err;
+
 	return count;
 }
 
-static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
-			   char *buf)
+static int read_temp11(struct device *dev, int index)
 {
-	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
 	struct lm90_data *data = lm90_update_device(dev);
 	int temp;
 
 	if (data->kind == adt7461 || data->kind == tmp451)
-		temp = temp_from_u16_adt7461(data, data->temp11[attr->index]);
+		temp = temp_from_u16_adt7461(data, data->temp11[index]);
 	else if (data->kind == max6646)
-		temp = temp_from_u16(data->temp11[attr->index]);
+		temp = temp_from_u16(data->temp11[index]);
 	else
-		temp = temp_from_s16(data->temp11[attr->index]);
+		temp = temp_from_s16(data->temp11[index]);
 
 	/* +16 degrees offset for temp2 for the LM99 */
-	if (data->kind == lm99 &&  attr->index <= 2)
+	if (data->kind == lm99 && index <= 2)
 		temp += 16000;
 
-	return sprintf(buf, "%d\n", temp);
+	return temp;
 }
 
-static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
-			  const char *buf, size_t count)
+static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
+			   char *buf)
+{
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+
+	return sprintf(buf, "%d\n", read_temp11(dev, attr->index));
+}
+
+static int write_temp11(struct device *dev, int nr, int index, long val)
 {
 	struct {
 		u8 high;
@@ -861,18 +888,10 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
 		{ LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL, 1 }
 	};
 
-	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
 	struct lm90_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
-	int nr = attr->nr;
-	int index = attr->index;
-	long val;
 	int err;
 
-	err = kstrtol(buf, 10, &val);
-	if (err < 0)
-		return err;
-
 	/* +16 degrees offset for temp2 for the LM99 */
 	if (data->kind == lm99 && index <= 2)
 		val -= 16000;
@@ -887,15 +906,50 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
 	else
 		data->temp11[index] = temp_to_s8(val) << 8;
 
-	lm90_select_remote_channel(client, data, reg[nr].channel);
-	i2c_smbus_write_byte_data(client, reg[nr].high,
-				  data->temp11[index] >> 8);
-	if (data->flags & LM90_HAVE_REM_LIMIT_EXT)
-		i2c_smbus_write_byte_data(client, reg[nr].low,
-					  data->temp11[index] & 0xff);
-	lm90_select_remote_channel(client, data, 0);
+	err = lm90_select_remote_channel(client, data, reg[nr].channel);
+	if (err)
+		goto error;
+
+	err = i2c_smbus_write_byte_data(client, reg[nr].high,
+					data->temp11[index] >> 8);
+	if (err)
+		goto error;
+
+	if (data->flags & LM90_HAVE_REM_LIMIT_EXT) {
+		err = i2c_smbus_write_byte_data(client, reg[nr].low,
+						data->temp11[index] & 0xff);
+		if (err)
+			goto error;
+	}
+
+	err = lm90_select_remote_channel(client, data, 0);
+
+error:
+	if (err)
+		dev_err(dev, "write_temp11 failed, err %d\n", err);
 
 	mutex_unlock(&data->update_lock);
+
+	return err;
+}
+
+static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
+			  const char *buf, size_t count)
+{
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	int nr = attr->nr;
+	int index = attr->index;
+	long val;
+	int err;
+
+	err = kstrtol(buf, 10, &val);
+	if (err < 0)
+		return err;
+
+	err = write_temp11(dev, nr, index, val);
+	if (err < 0)
+		return err;
+
 	return count;
 }
 
-- 
1.8.1.5

