Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3IACtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 22:49:46 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43562 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab3IACtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 22:49:25 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 6/9] hwmon: (nct6775) Convert to use hwmon_device_register_with_groups
Date: Sat, 31 Aug 2013 19:48:59 -0700
Message-Id: <1378003742-18685-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/nct6775.c |  122 ++++++++++++++---------------------------------
 1 file changed, 36 insertions(+), 86 deletions(-)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index 6eb03ce..bf0c35f 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -725,10 +725,9 @@ struct nct6775_data {
 	const char *name;
 
 	struct device *hwmon_dev;
-	struct attribute_group *group_in;
-	struct attribute_group *group_fan;
-	struct attribute_group *group_temp;
-	struct attribute_group *group_pwm;
+
+	int num_attr_groups;
+	const struct attribute_group *groups[6];
 
 	u16 reg_temp[5][NUM_TEMP]; /* 0=temp, 1=temp_over, 2=temp_hyst,
 				    * 3=temp_crit, 4=temp_lcrit
@@ -942,7 +941,7 @@ nct6775_create_attr_group(struct device *dev, struct sensor_template_group *tg,
 	struct sensor_device_attribute_2 *a2;
 	struct attribute **attrs;
 	struct sensor_device_template **t;
-	int err, i, j, count;
+	int i, j, count;
 
 	if (repeat <= 0)
 		return ERR_PTR(-EINVAL);
@@ -1002,10 +1001,6 @@ nct6775_create_attr_group(struct device *dev, struct sensor_template_group *tg,
 		}
 	}
 
-	err = sysfs_create_group(&dev->kobj, group);
-	if (err)
-		return ERR_PTR(-ENOMEM);
-
 	return group;
 }
 
@@ -2726,16 +2721,6 @@ store_fan_time(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
-show_name(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct nct6775_data *data = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%s\n", data->name);
-}
-
-static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
-
-static ssize_t
 show_auto_pwm(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct nct6775_data *data = nct6775_update_device(dev);
@@ -3061,16 +3046,16 @@ static umode_t nct6775_other_is_visible(struct kobject *kobj,
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct nct6775_data *data = dev_get_drvdata(dev);
 
-	if (index == 1 && !data->have_vid)
+	if (index == 0 && !data->have_vid)
 		return 0;
 
-	if (index == 2 || index == 3) {
-		if (data->ALARM_BITS[INTRUSION_ALARM_BASE + index - 2] < 0)
+	if (index == 1 || index == 2) {
+		if (data->ALARM_BITS[INTRUSION_ALARM_BASE + index - 1] < 0)
 			return 0;
 	}
 
-	if (index == 4 || index == 5) {
-		if (data->BEEP_BITS[INTRUSION_ALARM_BASE + index - 4] < 0)
+	if (index == 3 || index == 4) {
+		if (data->BEEP_BITS[INTRUSION_ALARM_BASE + index - 3] < 0)
 			return 0;
 	}
 
@@ -3083,13 +3068,12 @@ static umode_t nct6775_other_is_visible(struct kobject *kobj,
  * Any change in order or content must be matched.
  */
 static struct attribute *nct6775_attributes_other[] = {
-	&dev_attr_name.attr,
-	&dev_attr_cpu0_vid.attr,				/* 1 */
-	&sensor_dev_attr_intrusion0_alarm.dev_attr.attr,	/* 2 */
-	&sensor_dev_attr_intrusion1_alarm.dev_attr.attr,	/* 3 */
-	&sensor_dev_attr_intrusion0_beep.dev_attr.attr,		/* 4 */
-	&sensor_dev_attr_intrusion1_beep.dev_attr.attr,		/* 5 */
-	&sensor_dev_attr_beep_enable.dev_attr.attr,		/* 6 */
+	&dev_attr_cpu0_vid.attr,				/* 0 */
+	&sensor_dev_attr_intrusion0_alarm.dev_attr.attr,	/* 1 */
+	&sensor_dev_attr_intrusion1_alarm.dev_attr.attr,	/* 2 */
+	&sensor_dev_attr_intrusion0_beep.dev_attr.attr,		/* 3 */
+	&sensor_dev_attr_intrusion1_beep.dev_attr.attr,		/* 4 */
+	&sensor_dev_attr_beep_enable.dev_attr.attr,		/* 5 */
 
 	NULL
 };
@@ -3099,27 +3083,6 @@ static const struct attribute_group nct6775_group_other = {
 	.is_visible = nct6775_other_is_visible,
 };
 
-/*
- * Driver and device management
- */
-
-static void nct6775_device_remove_files(struct device *dev)
-{
-	struct nct6775_data *data = dev_get_drvdata(dev);
-
-	if (data->group_pwm)
-		sysfs_remove_group(&dev->kobj, data->group_pwm);
-	if (data->group_in)
-		sysfs_remove_group(&dev->kobj, data->group_in);
-	if (data->group_fan)
-		sysfs_remove_group(&dev->kobj, data->group_fan);
-	if (data->group_temp)
-		sysfs_remove_group(&dev->kobj, data->group_temp);
-
-	sysfs_remove_group(&dev->kobj, &nct6775_group_other);
-}
-
-/* Get the monitoring functions started */
 static inline void nct6775_init_device(struct nct6775_data *data)
 {
 	int i;
@@ -3870,51 +3833,39 @@ static int nct6775_probe(struct platform_device *pdev)
 	/* Register sysfs hooks */
 	group = nct6775_create_attr_group(dev, &nct6775_pwm_template_group,
 					  data->pwm_num);
-	if (IS_ERR(group)) {
-		err = PTR_ERR(group);
-		goto exit_remove;
-	}
-	data->group_pwm = group;
+	if (IS_ERR(group))
+		return PTR_ERR(group);
+
+	data->groups[data->num_attr_groups++] = group;
 
 	group = nct6775_create_attr_group(dev, &nct6775_in_template_group,
 					  fls(data->have_in));
-	if (IS_ERR(group)) {
-		err = PTR_ERR(group);
-		goto exit_remove;
-	}
-	data->group_in = group;
+	if (IS_ERR(group))
+		return PTR_ERR(group);
+
+	data->groups[data->num_attr_groups++] = group;
 
 	group = nct6775_create_attr_group(dev, &nct6775_fan_template_group,
 					  fls(data->has_fan));
-	if (IS_ERR(group)) {
-		err = PTR_ERR(group);
-		goto exit_remove;
-	}
-	data->group_fan = group;
+	if (IS_ERR(group))
+		return PTR_ERR(group);
+
+	data->groups[data->num_attr_groups++] = group;
 
 	group = nct6775_create_attr_group(dev, &nct6775_temp_template_group,
 					  fls(data->have_temp));
-	if (IS_ERR(group)) {
-		err = PTR_ERR(group);
-		goto exit_remove;
-	}
-	data->group_temp = group;
+	if (IS_ERR(group))
+		return PTR_ERR(group);
 
-	err = sysfs_create_group(&dev->kobj, &nct6775_group_other);
-	if (err)
-		goto exit_remove;
+	data->groups[data->num_attr_groups++] = group;
+	data->groups[data->num_attr_groups++] = &nct6775_group_other;
 
-	data->hwmon_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		goto exit_remove;
-	}
+	data->hwmon_dev = hwmon_device_register_with_groups(dev, data->name,
+							    data, data->groups);
+	if (IS_ERR(data->hwmon_dev))
+		return PTR_ERR(data->hwmon_dev);
 
 	return 0;
-
-exit_remove:
-	nct6775_device_remove_files(dev);
-	return err;
 }
 
 static int nct6775_remove(struct platform_device *pdev)
@@ -3922,7 +3873,6 @@ static int nct6775_remove(struct platform_device *pdev)
 	struct nct6775_data *data = platform_get_drvdata(pdev);
 
 	hwmon_device_unregister(data->hwmon_dev);
-	nct6775_device_remove_files(&pdev->dev);
 
 	return 0;
 }
@@ -4101,7 +4051,7 @@ static int __init nct6775_find(int sioaddr, struct nct6775_sio_data *sio_data)
 /*
  * when Super-I/O functions move to a separate file, the Super-I/O
  * bus will manage the lifetime of the device and this module will only keep
- * track of the nct6775 driver. But since we platform_device_alloc(), we
+ * track of the nct6775 driver. But since we use platform_device_alloc(), we
  * must keep track of the device
  */
 static struct platform_device *pdev[2];
-- 
1.7.9.7

