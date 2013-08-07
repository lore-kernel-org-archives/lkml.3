Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3HGGTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:19:19 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17562 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3HGGSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:18:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 06 Aug 2013 23:18:31 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>
CC: <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>
Subject: [PATCH v4 3/3] hwmon: (lm90) use enums for the indexes of temp8 and temp11
Date: Wed, 7 Aug 2013 14:18:26 +0800
Message-ID: <1375856306-14415-4-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375856306-14415-1-git-send-email-wni@nvidia.com>
References: <1375856306-14415-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using enums for the indexes and nrs of temp8 and temp11.
This make the code much more readable.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/hwmon/lm90.c |  154 +++++++++++++++++++++++++++++---------------------
 1 file changed, 90 insertions(+), 64 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 2e68773..6cc3eef 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -309,6 +309,38 @@ static const struct lm90_params lm90_params[] = {
 };
 
 /*
+ * TEMP8 register index
+ */
+enum lm90_temp8_reg_index {
+	LOCAL_LOW = 0,
+	LOCAL_HIGH,
+	LOCAL_CRIT,
+	REMOTE_CRIT,
+	LOCAL_EMERG,	/* max6659 and max6695/96 */
+	REMOTE_EMERG,	/* max6659 and max6695/96 */
+	REMOTE2_CRIT,	/* max6695/96 only */
+	REMOTE2_EMERG,	/* max6695/96 only */
+	TEMP8_REG_NUM
+};
+
+/*
+ * TEMP11 register index
+ */
+enum lm90_temp11_reg_index {
+	REMOTE_TEMP = 0,
+	REMOTE_LOW,
+	REMOTE_HIGH,
+	REMOTE_OFFSET,	/* except max6646, max6657/58/59,
+			 *  and max6695/96
+			 */
+	LOCAL_TEMP,
+	REMOTE2_TEMP,	/* max6695/96 only */
+	REMOTE2_LOW,	/* max6695/96 only */
+	REMOTE2_HIGH,	/* max6695/96 only */
+	TEMP11_REG_NUM
+};
+
+/*
  * Client data (each client gets its own)
  */
 
@@ -330,25 +362,8 @@ struct lm90_data {
 	u8 reg_local_ext;	/* local extension register offset */
 
 	/* registers values */
-	s8 temp8[8];	/* 0: local low limit
-			 * 1: local high limit
-			 * 2: local critical limit
-			 * 3: remote critical limit
-			 * 4: local emergency limit (max6659 and max6695/96)
-			 * 5: remote emergency limit (max6659 and max6695/96)
-			 * 6: remote 2 critical limit (max6695/96 only)
-			 * 7: remote 2 emergency limit (max6695/96 only)
-			 */
-	s16 temp11[8];	/* 0: remote input
-			 * 1: remote low limit
-			 * 2: remote high limit
-			 * 3: remote offset (except max6646, max6657/58/59,
-			 *		     and max6695/96)
-			 * 4: local input
-			 * 5: remote 2 input (max6695/96 only)
-			 * 6: remote 2 low limit (max6695/96 only)
-			 * 7: remote 2 high limit (max6695/96 only)
-			 */
+	s8 temp8[TEMP8_REG_NUM];
+	s16 temp11[TEMP11_REG_NUM];
 	u8 temp_hyst;
 	u16 alarms; /* bitvector (upper 8 bits for max6695/96) */
 };
@@ -490,37 +505,42 @@ static struct lm90_data *lm90_update_device(struct device *dev)
 		u8 alarms;
 
 		dev_dbg(&client->dev, "Updating lm90 data.\n");
-		lm90_read_reg(client, LM90_REG_R_LOCAL_LOW, &data->temp8[0]);
-		lm90_read_reg(client, LM90_REG_R_LOCAL_HIGH, &data->temp8[1]);
-		lm90_read_reg(client, LM90_REG_R_LOCAL_CRIT, &data->temp8[2]);
-		lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT, &data->temp8[3]);
+		lm90_read_reg(client, LM90_REG_R_LOCAL_LOW,
+			      &data->temp8[LOCAL_LOW]);
+		lm90_read_reg(client, LM90_REG_R_LOCAL_HIGH,
+			      &data->temp8[LOCAL_HIGH]);
+		lm90_read_reg(client, LM90_REG_R_LOCAL_CRIT,
+			      &data->temp8[LOCAL_CRIT]);
+		lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT,
+			      &data->temp8[REMOTE_CRIT]);
 		lm90_read_reg(client, LM90_REG_R_TCRIT_HYST, &data->temp_hyst);
 
 		if (data->reg_local_ext) {
 			lm90_read16(client, LM90_REG_R_LOCAL_TEMP,
 				    data->reg_local_ext,
-				    &data->temp11[4]);
+				    &data->temp11[LOCAL_TEMP]);
 		} else {
 			if (lm90_read_reg(client, LM90_REG_R_LOCAL_TEMP,
 					  &h) == 0)
-				data->temp11[4] = h << 8;
+				data->temp11[LOCAL_TEMP] = h << 8;
 		}
 		lm90_read16(client, LM90_REG_R_REMOTE_TEMPH,
-			    LM90_REG_R_REMOTE_TEMPL, &data->temp11[0]);
+			    LM90_REG_R_REMOTE_TEMPL,
+			    &data->temp11[REMOTE_TEMP]);
 
 		if (lm90_read_reg(client, LM90_REG_R_REMOTE_LOWH, &h) == 0) {
-			data->temp11[1] = h << 8;
+			data->temp11[REMOTE_LOW] = h << 8;
 			if ((data->flags & LM90_HAVE_REM_LIMIT_EXT)
 			 && lm90_read_reg(client, LM90_REG_R_REMOTE_LOWL,
 					  &l) == 0)
-				data->temp11[1] |= l;
+				data->temp11[REMOTE_LOW] |= l;
 		}
 		if (lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHH, &h) == 0) {
-			data->temp11[2] = h << 8;
+			data->temp11[REMOTE_HIGH] = h << 8;
 			if ((data->flags & LM90_HAVE_REM_LIMIT_EXT)
 			 && lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHL,
 					  &l) == 0)
-				data->temp11[2] |= l;
+				data->temp11[REMOTE_HIGH] |= l;
 		}
 
 		if (data->flags & LM90_HAVE_OFFSET) {
@@ -528,13 +548,13 @@ static struct lm90_data *lm90_update_device(struct device *dev)
 					  &h) == 0
 			 && lm90_read_reg(client, LM90_REG_R_REMOTE_OFFSL,
 					  &l) == 0)
-				data->temp11[3] = (h << 8) | l;
+				data->temp11[REMOTE_OFFSET] = (h << 8) | l;
 		}
 		if (data->flags & LM90_HAVE_EMERGENCY) {
 			lm90_read_reg(client, MAX6659_REG_R_LOCAL_EMERG,
-				      &data->temp8[4]);
+				      &data->temp8[LOCAL_EMERG]);
 			lm90_read_reg(client, MAX6659_REG_R_REMOTE_EMERG,
-				      &data->temp8[5]);
+				      &data->temp8[REMOTE_EMERG]);
 		}
 		lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
 		data->alarms = alarms;	/* save as 16 bit value */
@@ -542,15 +562,16 @@ static struct lm90_data *lm90_update_device(struct device *dev)
 		if (data->kind == max6696) {
 			lm90_select_remote_channel(client, data, 1);
 			lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT,
-				      &data->temp8[6]);
+				      &data->temp8[REMOTE2_CRIT]);
 			lm90_read_reg(client, MAX6659_REG_R_REMOTE_EMERG,
-				      &data->temp8[7]);
+				      &data->temp8[REMOTE2_EMERG]);
 			lm90_read16(client, LM90_REG_R_REMOTE_TEMPH,
-				    LM90_REG_R_REMOTE_TEMPL, &data->temp11[5]);
+				    LM90_REG_R_REMOTE_TEMPL,
+				    &data->temp11[REMOTE2_TEMP]);
 			if (!lm90_read_reg(client, LM90_REG_R_REMOTE_LOWH, &h))
-				data->temp11[6] = h << 8;
+				data->temp11[REMOTE2_LOW] = h << 8;
 			if (!lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHH, &h))
-				data->temp11[7] = h << 8;
+				data->temp11[REMOTE2_HIGH] = h << 8;
 			lm90_select_remote_channel(client, data, 0);
 
 			if (!lm90_read_reg(client, MAX6696_REG_R_STATUS2,
@@ -739,7 +760,7 @@ static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
 static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
 			 const char *buf, size_t count)
 {
-	static const u8 reg[8] = {
+	static const u8 reg[TEMP8_REG_NUM] = {
 		LM90_REG_W_LOCAL_LOW,
 		LM90_REG_W_LOCAL_HIGH,
 		LM90_REG_W_LOCAL_CRIT,
@@ -892,11 +913,11 @@ static ssize_t set_temphyst(struct device *dev, struct device_attribute *dummy,
 
 	mutex_lock(&data->update_lock);
 	if (data->kind == adt7461)
-		temp = temp_from_u8_adt7461(data, data->temp8[2]);
+		temp = temp_from_u8_adt7461(data, data->temp8[LOCAL_CRIT]);
 	else if (data->kind == max6646)
-		temp = temp_from_u8(data->temp8[2]);
+		temp = temp_from_u8(data->temp8[LOCAL_CRIT]);
 	else
-		temp = temp_from_s8(data->temp8[2]);
+		temp = temp_from_s8(data->temp8[LOCAL_CRIT]);
 
 	data->temp_hyst = hyst_to_reg(temp - val);
 	i2c_smbus_write_byte_data(client, LM90_REG_W_TCRIT_HYST,
@@ -950,25 +971,28 @@ static ssize_t set_update_interval(struct device *dev,
 	return count;
 }
 
-static SENSOR_DEVICE_ATTR_2(temp1_input, S_IRUGO, show_temp11, NULL, 0, 4);
-static SENSOR_DEVICE_ATTR_2(temp2_input, S_IRUGO, show_temp11, NULL, 0, 0);
+static SENSOR_DEVICE_ATTR_2(temp1_input, S_IRUGO, show_temp11, NULL,
+	0, LOCAL_TEMP);
+static SENSOR_DEVICE_ATTR_2(temp2_input, S_IRUGO, show_temp11, NULL,
+	0, REMOTE_TEMP);
 static SENSOR_DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_temp8,
-	set_temp8, 0);
+	set_temp8, LOCAL_LOW);
 static SENSOR_DEVICE_ATTR_2(temp2_min, S_IWUSR | S_IRUGO, show_temp11,
-	set_temp11, 0, 1);
+	set_temp11, 0, REMOTE_LOW);
 static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp8,
-	set_temp8, 1);
+	set_temp8, LOCAL_HIGH);
 static SENSOR_DEVICE_ATTR_2(temp2_max, S_IWUSR | S_IRUGO, show_temp11,
-	set_temp11, 1, 2);
+	set_temp11, 1, REMOTE_HIGH);
 static SENSOR_DEVICE_ATTR(temp1_crit, S_IWUSR | S_IRUGO, show_temp8,
-	set_temp8, 2);
+	set_temp8, LOCAL_CRIT);
 static SENSOR_DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_temp8,
-	set_temp8, 3);
+	set_temp8, REMOTE_CRIT);
 static SENSOR_DEVICE_ATTR(temp1_crit_hyst, S_IWUSR | S_IRUGO, show_temphyst,
-	set_temphyst, 2);
-static SENSOR_DEVICE_ATTR(temp2_crit_hyst, S_IRUGO, show_temphyst, NULL, 3);
+	set_temphyst, LOCAL_CRIT);
+static SENSOR_DEVICE_ATTR(temp2_crit_hyst, S_IRUGO, show_temphyst, NULL,
+	REMOTE_CRIT);
 static SENSOR_DEVICE_ATTR_2(temp2_offset, S_IWUSR | S_IRUGO, show_temp11,
-	set_temp11, 2, 3);
+	set_temp11, 2, REMOTE_OFFSET);
 
 /* Individual alarm files */
 static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL, 0);
@@ -1016,13 +1040,13 @@ static const struct attribute_group lm90_group = {
  * Additional attributes for devices with emergency sensors
  */
 static SENSOR_DEVICE_ATTR(temp1_emergency, S_IWUSR | S_IRUGO, show_temp8,
-	set_temp8, 4);
+	set_temp8, LOCAL_EMERG);
 static SENSOR_DEVICE_ATTR(temp2_emergency, S_IWUSR | S_IRUGO, show_temp8,
-	set_temp8, 5);
+	set_temp8, REMOTE_EMERG);
 static SENSOR_DEVICE_ATTR(temp1_emergency_hyst, S_IRUGO, show_temphyst,
-			  NULL, 4);
+			  NULL, LOCAL_EMERG);
 static SENSOR_DEVICE_ATTR(temp2_emergency_hyst, S_IRUGO, show_temphyst,
-			  NULL, 5);
+			  NULL, REMOTE_EMERG);
 
 static struct attribute *lm90_emergency_attributes[] = {
 	&sensor_dev_attr_temp1_emergency.dev_attr.attr,
@@ -1052,18 +1076,20 @@ static const struct attribute_group lm90_emergency_alarm_group = {
 /*
  * Additional attributes for devices with 3 temperature sensors
  */
-static SENSOR_DEVICE_ATTR_2(temp3_input, S_IRUGO, show_temp11, NULL, 0, 5);
+static SENSOR_DEVICE_ATTR_2(temp3_input, S_IRUGO, show_temp11, NULL,
+	0, REMOTE2_TEMP);
 static SENSOR_DEVICE_ATTR_2(temp3_min, S_IWUSR | S_IRUGO, show_temp11,
-	set_temp11, 3, 6);
+	set_temp11, 3, REMOTE2_LOW);
 static SENSOR_DEVICE_ATTR_2(temp3_max, S_IWUSR | S_IRUGO, show_temp11,
-	set_temp11, 4, 7);
+	set_temp11, 4, REMOTE2_HIGH);
 static SENSOR_DEVICE_ATTR(temp3_crit, S_IWUSR | S_IRUGO, show_temp8,
-	set_temp8, 6);
-static SENSOR_DEVICE_ATTR(temp3_crit_hyst, S_IRUGO, show_temphyst, NULL, 6);
+	set_temp8, REMOTE2_CRIT);
+static SENSOR_DEVICE_ATTR(temp3_crit_hyst, S_IRUGO, show_temphyst, NULL,
+	REMOTE2_CRIT);
 static SENSOR_DEVICE_ATTR(temp3_emergency, S_IWUSR | S_IRUGO, show_temp8,
-	set_temp8, 7);
+	set_temp8, REMOTE2_EMERG);
 static SENSOR_DEVICE_ATTR(temp3_emergency_hyst, S_IRUGO, show_temphyst,
-			  NULL, 7);
+			  NULL, REMOTE2_EMERG);
 
 static SENSOR_DEVICE_ATTR(temp3_crit_alarm, S_IRUGO, show_alarm, NULL, 9);
 static SENSOR_DEVICE_ATTR(temp3_fault, S_IRUGO, show_alarm, NULL, 10);
-- 
1.7.9.5

