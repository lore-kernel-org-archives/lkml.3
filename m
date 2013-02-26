Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab3BZS0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:26:19 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55147 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759815Ab3BZSXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:23:55 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 26 Feb 2013 12:23:52 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v5 05/12] hwmon: (nct6775) Add support for fanX_pulses sysfs attribute
Date: Tue, 26 Feb 2013 10:23:33 -0800
Message-Id: <1361903020-18526-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
References: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/nct6775.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index ce4a59d..828ed47 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -205,6 +205,7 @@ static const u8 NCT6775_CR_CASEOPEN_CLR_MASK[] = { 0x20, 0x01 };
 
 static const u16 NCT6775_REG_FAN[] = { 0x630, 0x632, 0x634, 0x636, 0x638 };
 static const u16 NCT6775_REG_FAN_MIN[] = { 0x3b, 0x3c, 0x3d };
+static const u16 NCT6775_REG_FAN_PULSES[] = { 0x641, 0x642, 0x643, 0x644, 0 };
 
 static const u16 NCT6775_REG_TEMP[] = {
 	0x27, 0x150, 0x250, 0x62b, 0x62c, 0x62d };
@@ -264,6 +265,7 @@ static const s8 NCT6776_ALARM_BITS[] = {
 	12, 9 };			/* intrusion0, intrusion1 */
 
 static const u16 NCT6776_REG_FAN_MIN[] = { 0x63a, 0x63c, 0x63e, 0x640, 0x642 };
+static const u16 NCT6776_REG_FAN_PULSES[] = { 0x644, 0x645, 0x646, 0, 0 };
 
 static const u16 NCT6776_REG_TEMP_CONFIG[11] = {
 	0x18, 0x152, 0x252, 0x628, 0x629, 0x62A };
@@ -319,6 +321,8 @@ static const s8 NCT6779_ALARM_BITS[] = {
 	12, 9 };			/* intrusion0, intrusion1 */
 
 static const u16 NCT6779_REG_FAN[] = { 0x4b0, 0x4b2, 0x4b4, 0x4b6, 0x4b8 };
+static const u16 NCT6779_REG_FAN_PULSES[] = {
+	0x644, 0x645, 0x646, 0x647, 0x648 };
 
 static const u16 NCT6779_REG_TEMP[] = { 0x27, 0x150 };
 static const u16 NCT6779_REG_TEMP_HYST[] = { 0x3a, 0x153, 0, 0, 0, 0 };
@@ -459,6 +463,7 @@ struct nct6775_data {
 
 	const u16 *REG_FAN;
 	const u16 *REG_FAN_MIN;
+	const u16 *REG_FAN_PULSES;
 
 	const u16 *REG_TEMP_SOURCE;	/* temp register sources */
 	const u16 *REG_TEMP_OFFSET;
@@ -478,6 +483,7 @@ struct nct6775_data {
 	u8 in[15][3];		/* [0]=in, [1]=in_max, [2]=in_min */
 	unsigned int rpm[5];
 	u16 fan_min[5];
+	u8 fan_pulses[5];
 	u8 fan_div[5];
 	u8 has_fan;		/* some fan inputs can be disabled */
 	u8 has_fan_min;		/* some fans don't have min register */
@@ -799,6 +805,8 @@ static struct nct6775_data *nct6775_update_device(struct device *dev)
 			if (data->has_fan_min & (1 << i))
 				data->fan_min[i] = nct6775_read_value(data,
 					   data->REG_FAN_MIN[i]);
+			data->fan_pulses[i] =
+			  nct6775_read_value(data, data->REG_FAN_PULSES[i]);
 
 			nct6775_select_fan_div(dev, data, i, reg);
 		}
@@ -1222,6 +1230,41 @@ write_min:
 	return count;
 }
 
+static ssize_t
+show_fan_pulses(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct nct6775_data *data = nct6775_update_device(dev);
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
+	int p = data->fan_pulses[sattr->index];
+
+	return sprintf(buf, "%d\n", p ? : 4);
+}
+
+static ssize_t
+store_fan_pulses(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
+{
+	struct nct6775_data *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
+	int nr = sattr->index;
+	unsigned long val;
+	int err;
+
+	err = kstrtoul(buf, 10, &val);
+	if (err < 0)
+		return err;
+
+	if (val > 4)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+	data->fan_pulses[nr] = val & 3;
+	nct6775_write_value(data, data->REG_FAN_PULSES[nr], val & 3);
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
 static struct sensor_device_attribute sda_fan_input[] = {
 	SENSOR_ATTR(fan1_input, S_IRUGO, show_fan, NULL, 0),
 	SENSOR_ATTR(fan2_input, S_IRUGO, show_fan, NULL, 1),
@@ -1251,6 +1294,19 @@ static struct sensor_device_attribute sda_fan_min[] = {
 		    store_fan_min, 4),
 };
 
+static struct sensor_device_attribute sda_fan_pulses[] = {
+	SENSOR_ATTR(fan1_pulses, S_IWUSR | S_IRUGO, show_fan_pulses,
+		    store_fan_pulses, 0),
+	SENSOR_ATTR(fan2_pulses, S_IWUSR | S_IRUGO, show_fan_pulses,
+		    store_fan_pulses, 1),
+	SENSOR_ATTR(fan3_pulses, S_IWUSR | S_IRUGO, show_fan_pulses,
+		    store_fan_pulses, 2),
+	SENSOR_ATTR(fan4_pulses, S_IWUSR | S_IRUGO, show_fan_pulses,
+		    store_fan_pulses, 3),
+	SENSOR_ATTR(fan5_pulses, S_IWUSR | S_IRUGO, show_fan_pulses,
+		    store_fan_pulses, 4),
+};
+
 static struct sensor_device_attribute sda_fan_div[] = {
 	SENSOR_ATTR(fan1_div, S_IRUGO, show_fan_div, NULL, 0),
 	SENSOR_ATTR(fan2_div, S_IRUGO, show_fan_div, NULL, 1),
@@ -1618,6 +1674,7 @@ static void nct6775_device_remove_files(struct device *dev)
 		device_remove_file(dev, &sda_fan_alarm[i].dev_attr);
 		device_remove_file(dev, &sda_fan_div[i].dev_attr);
 		device_remove_file(dev, &sda_fan_min[i].dev_attr);
+		device_remove_file(dev, &sda_fan_pulses[i].dev_attr);
 	}
 	for (i = 0; i < NUM_TEMP; i++) {
 		if (!(data->have_temp & (1 << i)))
@@ -1806,6 +1863,7 @@ static int nct6775_probe(struct platform_device *pdev)
 		data->REG_IN_MINMAX[1] = NCT6775_REG_IN_MAX;
 		data->REG_FAN = NCT6775_REG_FAN;
 		data->REG_FAN_MIN = NCT6775_REG_FAN_MIN;
+		data->REG_FAN_PULSES = NCT6775_REG_FAN_PULSES;
 		data->REG_TEMP_OFFSET = NCT6775_REG_TEMP_OFFSET;
 		data->REG_TEMP_SOURCE = NCT6775_REG_TEMP_SOURCE;
 		data->REG_ALARM = NCT6775_REG_ALARM;
@@ -1840,6 +1898,7 @@ static int nct6775_probe(struct platform_device *pdev)
 		data->REG_IN_MINMAX[1] = NCT6775_REG_IN_MAX;
 		data->REG_FAN = NCT6775_REG_FAN;
 		data->REG_FAN_MIN = NCT6776_REG_FAN_MIN;
+		data->REG_FAN_PULSES = NCT6776_REG_FAN_PULSES;
 		data->REG_TEMP_OFFSET = NCT6775_REG_TEMP_OFFSET;
 		data->REG_TEMP_SOURCE = NCT6775_REG_TEMP_SOURCE;
 		data->REG_ALARM = NCT6775_REG_ALARM;
@@ -1874,6 +1933,7 @@ static int nct6775_probe(struct platform_device *pdev)
 		data->REG_IN_MINMAX[1] = NCT6775_REG_IN_MAX;
 		data->REG_FAN = NCT6779_REG_FAN;
 		data->REG_FAN_MIN = NCT6776_REG_FAN_MIN;
+		data->REG_FAN_PULSES = NCT6779_REG_FAN_PULSES;
 		data->REG_TEMP_OFFSET = NCT6779_REG_TEMP_OFFSET;
 		data->REG_TEMP_SOURCE = NCT6775_REG_TEMP_SOURCE;
 		data->REG_ALARM = NCT6779_REG_ALARM;
@@ -2091,6 +2151,10 @@ static int nct6775_probe(struct platform_device *pdev)
 				if (err)
 					goto exit_remove;
 			}
+			err = device_create_file(dev,
+						 &sda_fan_pulses[i].dev_attr);
+			if (err)
+				goto exit_remove;
 		}
 	}
 
-- 
1.7.9.7

