Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3KZEjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:39:11 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33277 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3KZEjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:39:08 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2] Input: ads7846: Convert to hwmon_device_register_with_groups
Date: Mon, 25 Nov 2013 20:39:04 -0800
Message-Id: <1385440744-6607-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code and create mandatory 'name' attribute by using
new hwmon API.

Also use is_visible to determine visible attributes instead of creating
several different attribute groups.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Use hwmon_device_register_with_groups instead of
    devm_hwmon_device_register_with_groups to keep
    device removal aligned with resource removal.

 drivers/input/touchscreen/ads7846.c |   81 +++++++++++------------------------
 1 file changed, 25 insertions(+), 56 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index ea19536..932d4cf 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -102,7 +102,6 @@ struct ads7846 {
 	struct regulator	*reg;
 
 #if defined(CONFIG_HWMON) || defined(CONFIG_HWMON_MODULE)
-	struct attribute_group	*attr_group;
 	struct device		*hwmon;
 #endif
 
@@ -479,42 +478,36 @@ static inline unsigned vbatt_adjust(struct ads7846 *ts, ssize_t v)
 SHOW(in0_input, vaux, vaux_adjust)
 SHOW(in1_input, vbatt, vbatt_adjust)
 
-static struct attribute *ads7846_attributes[] = {
-	&dev_attr_temp0.attr,
-	&dev_attr_temp1.attr,
-	&dev_attr_in0_input.attr,
-	&dev_attr_in1_input.attr,
-	NULL,
-};
-
-static struct attribute_group ads7846_attr_group = {
-	.attrs = ads7846_attributes,
-};
+static umode_t ads7846_is_visible(struct kobject *kobj, struct attribute *attr,
+				  int index)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct ads7846 *ts = dev_get_drvdata(dev);
 
-static struct attribute *ads7843_attributes[] = {
-	&dev_attr_in0_input.attr,
-	&dev_attr_in1_input.attr,
-	NULL,
-};
+	if (ts->model == 7843 && index < 2)	/* in0, in1 */
+		return 0;
+	if (ts->model == 7845 && index != 2)	/* in0 */
+		return 0;
 
-static struct attribute_group ads7843_attr_group = {
-	.attrs = ads7843_attributes,
-};
+	return attr->mode;
+}
 
-static struct attribute *ads7845_attributes[] = {
-	&dev_attr_in0_input.attr,
+static struct attribute *ads7846_attributes[] = {
+	&dev_attr_temp0.attr,		/* 0 */
+	&dev_attr_temp1.attr,		/* 1 */
+	&dev_attr_in0_input.attr,	/* 2 */
+	&dev_attr_in1_input.attr,	/* 3 */
 	NULL,
 };
 
-static struct attribute_group ads7845_attr_group = {
-	.attrs = ads7845_attributes,
+static struct attribute_group ads7846_attr_group = {
+	.attrs = ads7846_attributes,
+	.is_visible = ads7846_is_visible,
 };
+__ATTRIBUTE_GROUPS(ads7846_attr);
 
 static int ads784x_hwmon_register(struct spi_device *spi, struct ads7846 *ts)
 {
-	struct device *hwmon;
-	int err;
-
 	/* hwmon sensors need a reference voltage */
 	switch (ts->model) {
 	case 7846:
@@ -535,43 +528,19 @@ static int ads784x_hwmon_register(struct spi_device *spi, struct ads7846 *ts)
 		break;
 	}
 
-	/* different chips have different sensor groups */
-	switch (ts->model) {
-	case 7846:
-		ts->attr_group = &ads7846_attr_group;
-		break;
-	case 7845:
-		ts->attr_group = &ads7845_attr_group;
-		break;
-	case 7843:
-		ts->attr_group = &ads7843_attr_group;
-		break;
-	default:
-		dev_dbg(&spi->dev, "ADS%d not recognized\n", ts->model);
-		return 0;
-	}
-
-	err = sysfs_create_group(&spi->dev.kobj, ts->attr_group);
-	if (err)
-		return err;
-
-	hwmon = hwmon_device_register(&spi->dev);
-	if (IS_ERR(hwmon)) {
-		sysfs_remove_group(&spi->dev.kobj, ts->attr_group);
-		return PTR_ERR(hwmon);
-	}
+	ts->hwmon = hwmon_device_register_with_groups(&spi->dev, spi->modalias,
+						      ts, ads7846_attr_groups);
+	if (IS_ERR(ts->hwmon))
+		return PTR_ERR(ts->hwmon);
 
-	ts->hwmon = hwmon;
 	return 0;
 }
 
 static void ads784x_hwmon_unregister(struct spi_device *spi,
 				     struct ads7846 *ts)
 {
-	if (ts->hwmon) {
-		sysfs_remove_group(&spi->dev.kobj, ts->attr_group);
+	if (ts->hwmon)
 		hwmon_device_unregister(ts->hwmon);
-	}
 }
 
 #else
-- 
1.7.9.7

