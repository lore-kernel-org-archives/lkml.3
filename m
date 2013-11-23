Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab3KWFwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 00:52:36 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35746 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3KWFwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 00:52:09 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: David Airlie <airlied@linux.ie>
Cc: lm-sensors@lm-sensors.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/2] drm/nouveau/hwmon: Convert to use devm_hwmon_device_register_with_groups
Date: Fri, 22 Nov 2013 21:52:01 -0800
Message-Id: <1385185921-17220-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1385185921-17220-1-git-send-email-linux@roeck-us.net>
References: <1385185921-17220-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code and resolve race conditions seen because
attribute files are created after hwmon device registration,
and removed before hwmon device removal.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Compile tested only; unfortunately I don't have the the necessary hardware.

 drivers/gpu/drm/nouveau/nouveau_hwmon.c |  243 +++++++++++--------------------
 drivers/gpu/drm/nouveau/nouveau_hwmon.h |   11 --
 2 files changed, 84 insertions(+), 170 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_hwmon.c b/drivers/gpu/drm/nouveau/nouveau_hwmon.c
index 38a4db5..d4144b8 100644
--- a/drivers/gpu/drm/nouveau/nouveau_hwmon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_hwmon.c
@@ -42,9 +42,7 @@
 static ssize_t
 nouveau_hwmon_show_temp(struct device *d, struct device_attribute *a, char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	int temp = therm->temp_get(therm);
 
 	if (temp < 0)
@@ -68,9 +66,7 @@ static ssize_t
 nouveau_hwmon_temp1_auto_point1_temp(struct device *d,
 				     struct device_attribute *a, char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 	      therm->attr_get(therm, NOUVEAU_THERM_ATTR_THRS_FAN_BOOST) * 1000);
@@ -80,9 +76,7 @@ nouveau_hwmon_set_temp1_auto_point1_temp(struct device *d,
 					 struct device_attribute *a,
 					 const char *buf, size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 
 	if (kstrtol(buf, 10, &value) == -EINVAL)
@@ -101,9 +95,7 @@ static ssize_t
 nouveau_hwmon_temp1_auto_point1_temp_hyst(struct device *d,
 					  struct device_attribute *a, char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 	 therm->attr_get(therm, NOUVEAU_THERM_ATTR_THRS_FAN_BOOST_HYST) * 1000);
@@ -113,9 +105,7 @@ nouveau_hwmon_set_temp1_auto_point1_temp_hyst(struct device *d,
 					      struct device_attribute *a,
 					      const char *buf, size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 
 	if (kstrtol(buf, 10, &value) == -EINVAL)
@@ -133,9 +123,7 @@ static SENSOR_DEVICE_ATTR(temp1_auto_point1_temp_hyst, S_IRUGO | S_IWUSR,
 static ssize_t
 nouveau_hwmon_max_temp(struct device *d, struct device_attribute *a, char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 	       therm->attr_get(therm, NOUVEAU_THERM_ATTR_THRS_DOWN_CLK) * 1000);
@@ -144,9 +132,7 @@ static ssize_t
 nouveau_hwmon_set_max_temp(struct device *d, struct device_attribute *a,
 						const char *buf, size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 
 	if (kstrtol(buf, 10, &value) == -EINVAL)
@@ -164,9 +150,7 @@ static ssize_t
 nouveau_hwmon_max_temp_hyst(struct device *d, struct device_attribute *a,
 			    char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 	  therm->attr_get(therm, NOUVEAU_THERM_ATTR_THRS_DOWN_CLK_HYST) * 1000);
@@ -175,9 +159,7 @@ static ssize_t
 nouveau_hwmon_set_max_temp_hyst(struct device *d, struct device_attribute *a,
 						const char *buf, size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 
 	if (kstrtol(buf, 10, &value) == -EINVAL)
@@ -196,9 +178,7 @@ static ssize_t
 nouveau_hwmon_critical_temp(struct device *d, struct device_attribute *a,
 							char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 	       therm->attr_get(therm, NOUVEAU_THERM_ATTR_THRS_CRITICAL) * 1000);
@@ -208,9 +188,7 @@ nouveau_hwmon_set_critical_temp(struct device *d, struct device_attribute *a,
 							    const char *buf,
 								size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 
 	if (kstrtol(buf, 10, &value) == -EINVAL)
@@ -229,9 +207,7 @@ static ssize_t
 nouveau_hwmon_critical_temp_hyst(struct device *d, struct device_attribute *a,
 							char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 	  therm->attr_get(therm, NOUVEAU_THERM_ATTR_THRS_CRITICAL_HYST) * 1000);
@@ -242,9 +218,7 @@ nouveau_hwmon_set_critical_temp_hyst(struct device *d,
 				     const char *buf,
 				     size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 
 	if (kstrtol(buf, 10, &value) == -EINVAL)
@@ -262,9 +236,7 @@ static ssize_t
 nouveau_hwmon_emergency_temp(struct device *d, struct device_attribute *a,
 							char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 	       therm->attr_get(therm, NOUVEAU_THERM_ATTR_THRS_SHUTDOWN) * 1000);
@@ -274,9 +246,7 @@ nouveau_hwmon_set_emergency_temp(struct device *d, struct device_attribute *a,
 							    const char *buf,
 								size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 
 	if (kstrtol(buf, 10, &value) == -EINVAL)
@@ -295,9 +265,7 @@ static ssize_t
 nouveau_hwmon_emergency_temp_hyst(struct device *d, struct device_attribute *a,
 							char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 	  therm->attr_get(therm, NOUVEAU_THERM_ATTR_THRS_SHUTDOWN_HYST) * 1000);
@@ -308,9 +276,7 @@ nouveau_hwmon_set_emergency_temp_hyst(struct device *d,
 				      const char *buf,
 				      size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 
 	if (kstrtol(buf, 10, &value) == -EINVAL)
@@ -326,14 +292,6 @@ static SENSOR_DEVICE_ATTR(temp1_emergency_hyst, S_IRUGO | S_IWUSR,
 					nouveau_hwmon_set_emergency_temp_hyst,
 					0);
 
-static ssize_t nouveau_hwmon_show_name(struct device *dev,
-				      struct device_attribute *attr,
-				      char *buf)
-{
-	return sprintf(buf, "nouveau\n");
-}
-static SENSOR_DEVICE_ATTR(name, S_IRUGO, nouveau_hwmon_show_name, NULL, 0);
-
 static ssize_t nouveau_hwmon_show_update_rate(struct device *dev,
 				      struct device_attribute *attr,
 				      char *buf)
@@ -348,9 +306,7 @@ static ssize_t
 nouveau_hwmon_show_fan1_input(struct device *d, struct device_attribute *attr,
 			      char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", therm->fan_sense(therm));
 }
@@ -361,9 +317,7 @@ static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, nouveau_hwmon_show_fan1_input,
 nouveau_hwmon_get_pwm1_enable(struct device *d,
 			   struct device_attribute *a, char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	int ret;
 
 	ret = therm->attr_get(therm, NOUVEAU_THERM_ATTR_FAN_MODE);
@@ -377,9 +331,7 @@ static ssize_t
 nouveau_hwmon_set_pwm1_enable(struct device *d, struct device_attribute *a,
 			   const char *buf, size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 	int ret;
 
@@ -399,9 +351,7 @@ static SENSOR_DEVICE_ATTR(pwm1_enable, S_IRUGO | S_IWUSR,
 static ssize_t
 nouveau_hwmon_get_pwm1(struct device *d, struct device_attribute *a, char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	int ret;
 
 	ret = therm->fan_get(therm);
@@ -415,10 +365,8 @@ static ssize_t
 nouveau_hwmon_set_pwm1(struct device *d, struct device_attribute *a,
 		       const char *buf, size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
-	int ret = -ENODEV;
+	struct nouveau_therm *therm = dev_get_drvdata(d);
+	int ret;
 	long value;
 
 	if (kstrtol(buf, 10, &value) == -EINVAL)
@@ -439,9 +387,7 @@ static ssize_t
 nouveau_hwmon_get_pwm1_min(struct device *d,
 			   struct device_attribute *a, char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	int ret;
 
 	ret = therm->attr_get(therm, NOUVEAU_THERM_ATTR_FAN_MIN_DUTY);
@@ -455,9 +401,7 @@ static ssize_t
 nouveau_hwmon_set_pwm1_min(struct device *d, struct device_attribute *a,
 			   const char *buf, size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 	int ret;
 
@@ -479,9 +423,7 @@ static ssize_t
 nouveau_hwmon_get_pwm1_max(struct device *d,
 			   struct device_attribute *a, char *buf)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	int ret;
 
 	ret = therm->attr_get(therm, NOUVEAU_THERM_ATTR_FAN_MAX_DUTY);
@@ -495,9 +437,7 @@ static ssize_t
 nouveau_hwmon_set_pwm1_max(struct device *d, struct device_attribute *a,
 			   const char *buf, size_t count)
 {
-	struct drm_device *dev = dev_get_drvdata(d);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
+	struct nouveau_therm *therm = dev_get_drvdata(d);
 	long value;
 	int ret;
 
@@ -516,7 +456,6 @@ static SENSOR_DEVICE_ATTR(pwm1_max, S_IRUGO | S_IWUSR,
 			  nouveau_hwmon_set_pwm1_max, 0);
 
 static struct attribute *hwmon_default_attributes[] = {
-	&sensor_dev_attr_name.dev_attr.attr,
 	&sensor_dev_attr_update_rate.dev_attr.attr,
 	NULL
 };
@@ -545,18 +484,71 @@ static struct attribute *hwmon_pwm_fan_attributes[] = {
 	NULL
 };
 
+static umode_t hwmon_temp_is_visible(struct kobject *kobj,
+				     struct attribute *attr, int index)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct nouveau_therm *therm = dev_get_drvdata(dev);
+
+	if (therm->temp_get(therm) < 0)
+		return 0;
+
+	return attr->mode;
+}
+
+static umode_t hwmon_fan_rpm_is_visible(struct kobject *kobj,
+					struct attribute *attr, int index)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct nouveau_therm *therm = dev_get_drvdata(dev);
+
+	if (therm->fan_sense(therm) < 0)
+		return 0;
+
+	return attr->mode;
+}
+
+static umode_t hwmon_pwm_fan_is_visible(struct kobject *kobj,
+					struct attribute *attr, int index)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct nouveau_therm *therm = dev_get_drvdata(dev);
+
+	/*
+	 * XXX: incorrect, need better detection for this, some boards have
+	 *     the gpio entries for pwm fan control even when there's no
+	 *     actual fan connected to it... therm table?
+	 */
+	if (!therm->fan_get || therm->fan_get(therm) < 0)
+		return 0;
+
+	return attr->mode;
+}
+
 static const struct attribute_group hwmon_default_attrgroup = {
 	.attrs = hwmon_default_attributes,
 };
 static const struct attribute_group hwmon_temp_attrgroup = {
 	.attrs = hwmon_temp_attributes,
+	.is_visible = hwmon_temp_is_visible,
 };
 static const struct attribute_group hwmon_fan_rpm_attrgroup = {
 	.attrs = hwmon_fan_rpm_attributes,
+	.is_visible = hwmon_fan_rpm_is_visible,
 };
 static const struct attribute_group hwmon_pwm_fan_attrgroup = {
 	.attrs = hwmon_pwm_fan_attributes,
+	.is_visible = hwmon_pwm_fan_is_visible,
+};
+
+static const struct attribute_group *hwmon_attr_groups[] = {
+	&hwmon_default_attrgroup,
+	&hwmon_temp_attrgroup,
+	&hwmon_fan_rpm_attrgroup,
+	&hwmon_pwm_fan_attrgroup,
+	NULL
 };
+
 #endif
 
 int
@@ -565,92 +557,25 @@ nouveau_hwmon_init(struct drm_device *dev)
 #if defined(CONFIG_HWMON) || (defined(MODULE) && defined(CONFIG_HWMON_MODULE))
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_therm *therm = nouveau_therm(drm->device);
-	struct nouveau_hwmon *hwmon;
 	struct device *hwmon_dev;
 	int ret = 0;
 
-	hwmon = drm->hwmon = kzalloc(sizeof(*hwmon), GFP_KERNEL);
-	if (!hwmon)
-		return -ENOMEM;
-	hwmon->dev = dev;
-
 	if (!therm || !therm->temp_get || !therm->attr_get || !therm->attr_set)
 		return -ENODEV;
 
-	hwmon_dev = hwmon_device_register(&dev->pdev->dev);
+	hwmon_dev = devm_hwmon_device_register_with_groups(&dev->pdev->dev,
+							   "nouveau", therm,
+							   hwmon_attr_groups);
 	if (IS_ERR(hwmon_dev)) {
 		ret = PTR_ERR(hwmon_dev);
 		NV_ERROR(drm, "Unable to register hwmon device: %d\n", ret);
 		return ret;
 	}
-	dev_set_drvdata(hwmon_dev, dev);
-
-	/* set the default attributes */
-	ret = sysfs_create_group(&hwmon_dev->kobj, &hwmon_default_attrgroup);
-	if (ret) {
-		if (ret)
-			goto error;
-	}
-
-	/* if the card has a working thermal sensor */
-	if (therm->temp_get(therm) >= 0) {
-		ret = sysfs_create_group(&hwmon_dev->kobj, &hwmon_temp_attrgroup);
-		if (ret) {
-			if (ret)
-				goto error;
-		}
-	}
-
-	/* if the card has a pwm fan */
-	/*XXX: incorrect, need better detection for this, some boards have
-	 *     the gpio entries for pwm fan control even when there's no
-	 *     actual fan connected to it... therm table? */
-	if (therm->fan_get && therm->fan_get(therm) >= 0) {
-		ret = sysfs_create_group(&hwmon_dev->kobj,
-					 &hwmon_pwm_fan_attrgroup);
-		if (ret)
-			goto error;
-	}
-
-	/* if the card can read the fan rpm */
-	if (therm->fan_sense(therm) >= 0) {
-		ret = sysfs_create_group(&hwmon_dev->kobj,
-					 &hwmon_fan_rpm_attrgroup);
-		if (ret)
-			goto error;
-	}
-
-	hwmon->hwmon = hwmon_dev;
-
-	return 0;
-
-error:
-	NV_ERROR(drm, "Unable to create some hwmon sysfs files: %d\n", ret);
-	hwmon_device_unregister(hwmon_dev);
-	hwmon->hwmon = NULL;
-	return ret;
-#else
-	hwmon->hwmon = NULL;
-	return 0;
 #endif
+	return 0;
 }
 
 void
 nouveau_hwmon_fini(struct drm_device *dev)
 {
-#if defined(CONFIG_HWMON) || (defined(MODULE) && defined(CONFIG_HWMON_MODULE))
-	struct nouveau_hwmon *hwmon = nouveau_hwmon(dev);
-
-	if (hwmon->hwmon) {
-		sysfs_remove_group(&hwmon->hwmon->kobj, &hwmon_default_attrgroup);
-		sysfs_remove_group(&hwmon->hwmon->kobj, &hwmon_temp_attrgroup);
-		sysfs_remove_group(&hwmon->hwmon->kobj, &hwmon_pwm_fan_attrgroup);
-		sysfs_remove_group(&hwmon->hwmon->kobj, &hwmon_fan_rpm_attrgroup);
-
-		hwmon_device_unregister(hwmon->hwmon);
-	}
-
-	nouveau_drm(dev)->hwmon = NULL;
-	kfree(hwmon);
-#endif
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_hwmon.h b/drivers/gpu/drm/nouveau/nouveau_hwmon.h
index 62ccbb3..21a2d1d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_hwmon.h
+++ b/drivers/gpu/drm/nouveau/nouveau_hwmon.h
@@ -25,17 +25,6 @@
 #ifndef __NOUVEAU_PM_H__
 #define __NOUVEAU_PM_H__
 
-struct nouveau_hwmon {
-	struct drm_device *dev;
-	struct device *hwmon;
-};
-
-static inline struct nouveau_hwmon *
-nouveau_hwmon(struct drm_device *dev)
-{
-	return nouveau_drm(dev)->hwmon;
-}
-
 /* nouveau_hwmon.c */
 int  nouveau_hwmon_init(struct drm_device *dev);
 void nouveau_hwmon_fini(struct drm_device *dev);
-- 
1.7.9.7

