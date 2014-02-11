Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaBKRK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:10:57 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25628 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752279AbaBKRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:10:55 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org
Subject: [PATCH 09/12] hwmon: vexpress: Use devm helper for hwmon device registration
Date: Tue, 11 Feb 2014 17:10:33 +0000
Message-Id: <1392138636-29240-10-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_hwmon_device_register_with_groups instead of
the old-style manual attributes and hwmon device registration.

Cc: Jean Delvare <jdelvare@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net> 
Cc: lm-sensors@lm-sensors.org
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/hwmon/vexpress.c | 100 ++++++++++++-----------------------------------
 1 file changed, 26 insertions(+), 74 deletions(-)

diff --git a/drivers/hwmon/vexpress.c b/drivers/hwmon/vexpress.c
index d8a6113..7c3a973 100644
--- a/drivers/hwmon/vexpress.c
+++ b/drivers/hwmon/vexpress.c
@@ -29,15 +29,6 @@ struct vexpress_hwmon_data {
 	struct regmap *reg;
 };
 
-static ssize_t vexpress_hwmon_name_show(struct device *dev,
-		struct device_attribute *dev_attr, char *buffer)
-{
-	const char *compatible = of_get_property(dev->of_node, "compatible",
-			NULL);
-
-	return sprintf(buffer, "%s\n", compatible);
-}
-
 static ssize_t vexpress_hwmon_label_show(struct device *dev,
 		struct device_attribute *dev_attr, char *buffer)
 {
@@ -84,77 +75,60 @@ static ssize_t vexpress_hwmon_u64_show(struct device *dev,
 			to_sensor_dev_attr(dev_attr)->index));
 }
 
-static DEVICE_ATTR(name, S_IRUGO, vexpress_hwmon_name_show, NULL);
-
-#define VEXPRESS_HWMON_ATTRS(_name, _label_attr, _input_attr)	\
-struct attribute *vexpress_hwmon_attrs_##_name[] = {		\
-	&dev_attr_name.attr,					\
-	&dev_attr_##_label_attr.attr,				\
-	&sensor_dev_attr_##_input_attr.dev_attr.attr,		\
-	NULL							\
-}
+#define VEXPRESS_HWMON_ATTR_GROUPS(_name, _label_attr, _input_attr)	\
+static struct attribute *vexpress_hwmon_##_name##_attrs[] = {		\
+	&dev_attr_##_label_attr.attr,					\
+	&sensor_dev_attr_##_input_attr.dev_attr.attr,			\
+	NULL								\
+};									\
+ATTRIBUTE_GROUPS(vexpress_hwmon_##_name)
 
 #if !defined(CONFIG_REGULATOR_VEXPRESS)
 static DEVICE_ATTR(in1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
 static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, vexpress_hwmon_u32_show,
 		NULL, 1000);
-static VEXPRESS_HWMON_ATTRS(volt, in1_label, in1_input);
-static struct attribute_group vexpress_hwmon_group_volt = {
-	.attrs = vexpress_hwmon_attrs_volt,
-};
+VEXPRESS_HWMON_ATTR_GROUPS(volt, in1_label, in1_input);
 #endif
 
 static DEVICE_ATTR(curr1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
 static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, vexpress_hwmon_u32_show,
 		NULL, 1000);
-static VEXPRESS_HWMON_ATTRS(amp, curr1_label, curr1_input);
-static struct attribute_group vexpress_hwmon_group_amp = {
-	.attrs = vexpress_hwmon_attrs_amp,
-};
+VEXPRESS_HWMON_ATTR_GROUPS(amp, curr1_label, curr1_input);
 
 static DEVICE_ATTR(temp1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, vexpress_hwmon_u32_show,
 		NULL, 1000);
-static VEXPRESS_HWMON_ATTRS(temp, temp1_label, temp1_input);
-static struct attribute_group vexpress_hwmon_group_temp = {
-	.attrs = vexpress_hwmon_attrs_temp,
-};
+VEXPRESS_HWMON_ATTR_GROUPS(temp, temp1_label, temp1_input);
 
 static DEVICE_ATTR(power1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
 static SENSOR_DEVICE_ATTR(power1_input, S_IRUGO, vexpress_hwmon_u32_show,
 		NULL, 1);
-static VEXPRESS_HWMON_ATTRS(power, power1_label, power1_input);
-static struct attribute_group vexpress_hwmon_group_power = {
-	.attrs = vexpress_hwmon_attrs_power,
-};
+VEXPRESS_HWMON_ATTR_GROUPS(power, power1_label, power1_input);
 
 static DEVICE_ATTR(energy1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
 static SENSOR_DEVICE_ATTR(energy1_input, S_IRUGO, vexpress_hwmon_u64_show,
 		NULL, 1);
-static VEXPRESS_HWMON_ATTRS(energy, energy1_label, energy1_input);
-static struct attribute_group vexpress_hwmon_group_energy = {
-	.attrs = vexpress_hwmon_attrs_energy,
-};
+VEXPRESS_HWMON_ATTR_GROUPS(energy, energy1_label, energy1_input);
 
 static struct of_device_id vexpress_hwmon_of_match[] = {
 #if !defined(CONFIG_REGULATOR_VEXPRESS)
 	{
 		.compatible = "arm,vexpress-volt",
-		.data = &vexpress_hwmon_group_volt,
+		.data = vexpress_hwmon_volt_groups,
 	},
 #endif
 	{
 		.compatible = "arm,vexpress-amp",
-		.data = &vexpress_hwmon_group_amp,
+		.data = vexpress_hwmon_amp_groups,
 	}, {
 		.compatible = "arm,vexpress-temp",
-		.data = &vexpress_hwmon_group_temp,
+		.data = vexpress_hwmon_temp_groups,
 	}, {
 		.compatible = "arm,vexpress-power",
-		.data = &vexpress_hwmon_group_power,
+		.data = vexpress_hwmon_power_groups,
 	}, {
 		.compatible = "arm,vexpress-energy",
-		.data = &vexpress_hwmon_group_energy,
+		.data = vexpress_hwmon_energy_groups,
 	},
 	{}
 };
@@ -162,9 +136,10 @@ MODULE_DEVICE_TABLE(of, vexpress_hwmon_of_match);
 
 static int vexpress_hwmon_probe(struct platform_device *pdev)
 {
-	int err;
 	const struct of_device_id *match;
 	struct vexpress_hwmon_data *data;
+	const char *name;
+	const struct attribute_group **groups;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -176,42 +151,19 @@ static int vexpress_hwmon_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	data->reg = devm_regmap_init_vexpress_config(&pdev->dev);
-	if (!data->reg)
-		return -ENODEV;
-
-	err = sysfs_create_group(&pdev->dev.kobj, match->data);
-	if (err)
-		goto error;
-
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		goto error;
-	}
-
-	return 0;
-
-error:
-	sysfs_remove_group(&pdev->dev.kobj, match->data);
-	return err;
-}
-
-static int vexpress_hwmon_remove(struct platform_device *pdev)
-{
-	struct vexpress_hwmon_data *data = platform_get_drvdata(pdev);
-	const struct of_device_id *match;
-
-	hwmon_device_unregister(data->hwmon_dev);
+	if (IS_ERR(data->reg))
+		return PTR_ERR(data->reg);
 
-	match = of_match_device(vexpress_hwmon_of_match, &pdev->dev);
-	sysfs_remove_group(&pdev->dev.kobj, match->data);
+	name = of_get_property(pdev->dev.of_node, "compatible", NULL);
+	groups = (const struct attribute_group **)match->data;
+	data->hwmon_dev = devm_hwmon_device_register_with_groups(&pdev->dev,
+			name, data, groups);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(data->hwmon_dev);
 }
 
 static struct platform_driver vexpress_hwmon_driver = {
 	.probe = vexpress_hwmon_probe,
-	.remove = vexpress_hwmon_remove,
 	.driver	= {
 		.name = DRVNAME,
 		.owner = THIS_MODULE,
-- 
1.8.3.2

