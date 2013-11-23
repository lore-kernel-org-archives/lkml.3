Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3KWVhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 16:37:09 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:32780 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3KWVhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 16:37:07 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] Input: ads7846: Convert to devm_hwmon_device_register_with_groups
Date: Sat, 23 Nov 2013 13:37:00 -0800
Message-Id: <1385242620-21719-1-git-send-email-linux@roeck-us.net>
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
Compiled tested only.

 drivers/input/touchscreen/ads7846.c |   97 +++++++++--------------------------
 1 file changed, 24 insertions(+), 73 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index ea19536..38acc4c 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -101,11 +101,6 @@ struct ads7846 {
 	struct spi_device	*spi;
 	struct regulator	*reg;
 
-#if defined(CONFIG_HWMON) || defined(CONFIG_HWMON_MODULE)
-	struct attribute_group	*attr_group;
-	struct device		*hwmon;
-#endif
-
 	u16			model;
 	u16			vref_mv;
 	u16			vref_delay_usecs;
@@ -479,41 +474,37 @@ static inline unsigned vbatt_adjust(struct ads7846 *ts, ssize_t v)
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
 	struct device *hwmon;
-	int err;
 
 	/* hwmon sensors need a reference voltage */
 	switch (ts->model) {
@@ -535,56 +526,20 @@ static int ads784x_hwmon_register(struct spi_device *spi, struct ads7846 *ts)
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
+	hwmon = devm_hwmon_device_register_with_groups(&spi->dev, spi->modalias,
+						       ts, ads7846_attr_groups);
+	if (IS_ERR(hwmon))
 		return PTR_ERR(hwmon);
-	}
 
-	ts->hwmon = hwmon;
 	return 0;
 }
 
-static void ads784x_hwmon_unregister(struct spi_device *spi,
-				     struct ads7846 *ts)
-{
-	if (ts->hwmon) {
-		sysfs_remove_group(&spi->dev.kobj, ts->attr_group);
-		hwmon_device_unregister(ts->hwmon);
-	}
-}
-
 #else
 static inline int ads784x_hwmon_register(struct spi_device *spi,
 					 struct ads7846 *ts)
 {
 	return 0;
 }
-
-static inline void ads784x_hwmon_unregister(struct spi_device *spi,
-					    struct ads7846 *ts)
-{
-}
 #endif
 
 static ssize_t ads7846_pen_down_show(struct device *dev,
@@ -1447,7 +1402,7 @@ static int ads7846_probe(struct spi_device *spi)
 
 	err = sysfs_create_group(&spi->dev.kobj, &ads784x_attr_group);
 	if (err)
-		goto err_remove_hwmon;
+		goto err_free_irq;
 
 	err = input_register_device(input_dev);
 	if (err)
@@ -1466,8 +1421,6 @@ static int ads7846_probe(struct spi_device *spi)
 
  err_remove_attr_group:
 	sysfs_remove_group(&spi->dev.kobj, &ads784x_attr_group);
- err_remove_hwmon:
-	ads784x_hwmon_unregister(spi, ts);
  err_free_irq:
 	free_irq(spi->irq, ts);
  err_disable_regulator:
@@ -1500,8 +1453,6 @@ static int ads7846_remove(struct spi_device *spi)
 
 	input_unregister_device(ts->input);
 
-	ads784x_hwmon_unregister(spi, ts);
-
 	regulator_disable(ts->reg);
 	regulator_put(ts->reg);
 
-- 
1.7.9.7

