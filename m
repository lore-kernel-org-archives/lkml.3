Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaFEPHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:07:45 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44368 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaFEPHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:07:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, ajitpal.singh@st.com,
        edubezval@gmail.com, rui.zhang@intel.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com
Subject: [PATCH 2/6] thermal: sti: Introduce ST Thermal core code
Date: Thu,  5 Jun 2014 16:06:55 +0100
Message-Id: <1401980819-19962-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
References: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This core is shared by both ST's 'memory mapped' and
'system configuration register' based Thermal controllers.

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/thermal/Kconfig         |   5 +
 drivers/thermal/Makefile        |   1 +
 drivers/thermal/st/Kconfig      |   4 +
 drivers/thermal/st/Makefile     |   1 +
 drivers/thermal/st/st_thermal.c | 313 ++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/st/st_thermal.h | 104 +++++++++++++
 6 files changed, 428 insertions(+)
 create mode 100644 drivers/thermal/st/Kconfig
 create mode 100644 drivers/thermal/st/Makefile
 create mode 100644 drivers/thermal/st/st_thermal.c
 create mode 100644 drivers/thermal/st/st_thermal.h

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 2d51912..6f88de1 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -231,4 +231,9 @@ depends on PLAT_SAMSUNG
 source "drivers/thermal/samsung/Kconfig"
 endmenu
 
+menu "STMicroelectronics thermal drivers"
+depends on ARCH_STI && OF
+source "drivers/thermal/st/Kconfig"
+endmenu
+
 endif
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 54e4ec9..ea36799 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_INTEL_POWERCLAMP)	+= intel_powerclamp.o
 obj-$(CONFIG_X86_PKG_TEMP_THERMAL)	+= x86_pkg_temp_thermal.o
 obj-$(CONFIG_TI_SOC_THERMAL)	+= ti-soc-thermal/
 obj-$(CONFIG_ACPI_INT3403_THERMAL)	+= int3403_thermal.o
+obj-$(CONFIG_ST_THERMAL)	+= st/
diff --git a/drivers/thermal/st/Kconfig b/drivers/thermal/st/Kconfig
new file mode 100644
index 0000000..1ba6760
--- /dev/null
+++ b/drivers/thermal/st/Kconfig
@@ -0,0 +1,4 @@
+config ST_THERMAL
+       tristate "Thermal sensors on STMicroelectronics STi series of SoCs"
+       help
+         Support for thermal sensors on STMicroelectronics STi series of SoCs.
diff --git a/drivers/thermal/st/Makefile b/drivers/thermal/st/Makefile
new file mode 100644
index 0000000..10f4bf6
--- /dev/null
+++ b/drivers/thermal/st/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ST_THERMAL)		:= st_thermal.o
diff --git a/drivers/thermal/st/st_thermal.c b/drivers/thermal/st/st_thermal.c
new file mode 100644
index 0000000..90163b3
--- /dev/null
+++ b/drivers/thermal/st/st_thermal.c
@@ -0,0 +1,313 @@
+/*
+ * ST Thermal Sensor Driver core routines
+ * Author: Ajit Pal Singh <ajitpal.singh@st.com>
+ *
+ * Copyright (C) 2003-2014 STMicroelectronics (R&D) Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+
+#include "st_thermal.h"
+
+/* The Thermal Framework expects millidegrees */
+#define mcelsius(temp)			((temp) * 1000)
+
+/*
+ * Function to allocate regfields which are common
+ * between syscfg and memory mapped based sensors
+ */
+int st_thermal_alloc_regfields(struct st_thermal_sensor *sensor)
+{
+	struct device *dev = sensor->dev;
+	struct regmap *regmap = sensor->regmap;
+	const struct reg_field *reg_fields = sensor->cdata->reg_fields;
+
+	sensor->dcorrect = devm_regmap_field_alloc(dev, regmap,
+						   reg_fields[DCORRECT]);
+
+	sensor->overflow = devm_regmap_field_alloc(dev, regmap,
+						   reg_fields[OVERFLOW]);
+
+	sensor->temp_data = devm_regmap_field_alloc(dev, regmap,
+						    reg_fields[DATA]);
+
+	if (IS_ERR(sensor->dcorrect) ||
+	    IS_ERR(sensor->overflow) ||
+	    IS_ERR(sensor->temp_data)) {
+		dev_err(dev, "failed to allocate common regfields\n");
+		return -EINVAL;
+	}
+
+	return sensor->ops->alloc_regfields(sensor);
+}
+
+static int st_thermal_sensor_on(struct st_thermal_sensor *sensor)
+{
+	int ret;
+	struct device *dev = sensor->dev;
+
+	ret = clk_prepare_enable(sensor->clk);
+	if (ret) {
+		dev_err(dev, "failed to enable clk\n");
+		return ret;
+	}
+
+	ret = sensor->ops->power_ctrl(sensor, POWER_ON);
+	if (ret) {
+		dev_err(dev, "failed to power on sensor\n");
+		clk_disable_unprepare(sensor->clk);
+	}
+
+	return ret;
+}
+
+static int st_thermal_sensor_off(struct st_thermal_sensor *sensor)
+{
+	int ret;
+
+	ret = sensor->ops->power_ctrl(sensor, POWER_OFF);
+	if (ret)
+		return ret;
+
+	clk_disable_unprepare(sensor->clk);
+
+	return 0;
+}
+
+static int st_thermal_calibration(struct st_thermal_sensor *sensor)
+{
+	int ret;
+	unsigned int val;
+	struct device *dev = sensor->dev;
+
+	/* Check if sensor calibration data is already written */
+	ret = regmap_field_read(sensor->dcorrect, &val);
+	if (ret) {
+		dev_err(dev, "failed to read calibration data\n");
+		return ret;
+	}
+
+	if (!val) {
+		/*
+		 * Sensor calibration value not set by bootloader,
+		 * default calibration data to be used
+		 */
+		ret = regmap_field_write(sensor->dcorrect,
+					 sensor->cdata->calibration_val);
+		if (ret)
+			dev_err(dev, "failed to set calibration data\n");
+	}
+
+	return ret;
+}
+
+/* Callback to get temperature from HW*/
+static int st_thermal_get_temp(struct thermal_zone_device *th,
+		unsigned long *temperature)
+{
+	struct st_thermal_sensor *sensor = th->devdata;
+	struct device *dev = sensor->dev;
+	unsigned int temp;
+	unsigned int overflow;
+	int ret;
+
+	ret = regmap_field_read(sensor->overflow, &overflow);
+	if (ret)
+		return ret;
+	if (overflow)
+		return -EIO;
+
+	ret = regmap_field_read(sensor->temp_data, &temp);
+	if (ret)
+		return ret;
+
+	temp += sensor->cdata->temp_adjust_val;
+	temp = mcelsius(temp);
+
+	dev_dbg(dev, "temperature: %d\n", temp);
+
+	*temperature = temp;
+
+	return 0;
+}
+
+static int st_thermal_get_trip_type(struct thermal_zone_device *th,
+				int trip, enum thermal_trip_type *type)
+{
+	struct st_thermal_sensor *sensor = th->devdata;
+	struct device *dev = sensor->dev;
+
+	switch (trip) {
+	case 0:
+		*type = THERMAL_TRIP_CRITICAL;
+		break;
+	default:
+		dev_err(dev, "invalid trip point\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int st_thermal_get_trip_temp(struct thermal_zone_device *th,
+				    int trip, unsigned long *temp)
+{
+	struct st_thermal_sensor *sensor = th->devdata;
+	struct device *dev = sensor->dev;
+
+	switch (trip) {
+	case 0:
+		*temp = mcelsius(sensor->cdata->crit_temp);
+		break;
+	default:
+		dev_err(dev, "Invalid trip point\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct thermal_zone_device_ops st_tz_ops = {
+	.get_temp	= st_thermal_get_temp,
+	.get_trip_type	= st_thermal_get_trip_type,
+	.get_trip_temp	= st_thermal_get_trip_temp,
+};
+
+int st_thermal_register(struct platform_device *pdev,
+			const struct of_device_id *st_thermal_of_match)
+{
+	struct st_thermal_sensor *sensor;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	const struct of_device_id *match;
+
+	int polling_delay;
+	int ret;
+
+	if (!np) {
+		dev_err(dev, "device tree node not found\n");
+		return -EINVAL;
+	}
+
+	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
+	if (!sensor)
+		return -ENOMEM;
+
+	sensor->dev = dev;
+
+	match = of_match_device(st_thermal_of_match, dev);
+	if (!(match && match->data))
+		return -EINVAL;
+
+	sensor->cdata = match->data;
+	if (!sensor->cdata->ops)
+		return -EINVAL;
+
+	sensor->ops = sensor->cdata->ops;
+
+	ret = sensor->ops->regmap_init(sensor);
+	if (ret)
+		return ret;
+
+	ret = st_thermal_alloc_regfields(sensor);
+	if (ret)
+		return ret;
+
+	sensor->clk = devm_clk_get(dev, "thermal");
+	if (IS_ERR(sensor->clk)) {
+		dev_err(dev, "failed to fetch clock\n");
+		return PTR_ERR(sensor->clk);
+	}
+
+	if (sensor->ops->register_enable_irq) {
+		ret = sensor->ops->register_enable_irq(sensor);
+		if (ret)
+			return ret;
+	}
+
+	ret = st_thermal_sensor_on(sensor);
+	if (ret)
+		return ret;
+
+	ret = st_thermal_calibration(sensor);
+	if (ret)
+		goto sensor_off;
+
+	polling_delay = sensor->ops->register_enable_irq ? 0 : 1000;
+
+	sensor->thermal_dev =
+		thermal_zone_device_register(dev_name(dev), 1, 0, sensor,
+					     &st_tz_ops, NULL, 0, polling_delay);
+	if (IS_ERR(sensor->thermal_dev)) {
+		dev_err(dev, "failed to register thermal zone device\n");
+		ret = PTR_ERR(sensor->thermal_dev);
+		goto sensor_off;
+	}
+
+	platform_set_drvdata(pdev, sensor);
+
+	return 0;
+
+sensor_off:
+	st_thermal_sensor_off(sensor);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(st_thermal_register);
+
+int st_thermal_unregister(struct platform_device *pdev)
+{
+	struct st_thermal_sensor *sensor = platform_get_drvdata(pdev);
+
+	st_thermal_sensor_off(sensor);
+	thermal_zone_device_unregister(sensor->thermal_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(st_thermal_unregister);
+
+static int st_thermal_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct st_thermal_sensor *sensor = platform_get_drvdata(pdev);
+
+	return st_thermal_sensor_off(sensor);
+}
+
+static int st_thermal_resume(struct device *dev)
+{
+	int ret;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct st_thermal_sensor *sensor = platform_get_drvdata(pdev);
+
+	ret = st_thermal_sensor_on(sensor);
+	if (ret)
+		return ret;
+
+	ret = st_thermal_calibration(sensor);
+	if (ret)
+		return ret;
+
+	if (sensor->ops->enable_irq) {
+		ret = sensor->ops->enable_irq(sensor);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+SIMPLE_DEV_PM_OPS(st_thermal_pm_ops, st_thermal_suspend, st_thermal_resume);
+EXPORT_SYMBOL_GPL(st_thermal_pm_ops);
+
+MODULE_AUTHOR("STMicroelectronics (R&D) Limited <ajitpal.singh@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics STi SoC Thermal Sensor Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/thermal/st/st_thermal.h b/drivers/thermal/st/st_thermal.h
new file mode 100644
index 0000000..fecafbe
--- /dev/null
+++ b/drivers/thermal/st/st_thermal.h
@@ -0,0 +1,104 @@
+/*
+ * ST Thermal Sensor Driver for STi series of SoCs
+ * Author: Ajit Pal Singh <ajitpal.singh@st.com>
+ *
+ * Copyright (C) 2003-2014 STMicroelectronics (R&D) Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __STI_THERMAL_SYSCFG_H
+#define __STI_THERMAL_SYSCFG_H
+
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/thermal.h>
+
+enum st_thermal_regfield_ids {
+	INT_THRESH_HI = 0, /* Top two regfield IDs are mutually exclusive */
+	TEMP_PWR = 0,
+	DCORRECT,
+	OVERFLOW,
+	DATA,
+	INT_ENABLE,
+
+	MAX_REGFIELDS
+};
+
+/* Thermal sensor power states */
+enum st_thermal_power_state {
+	POWER_OFF = 0,
+	POWER_ON
+};
+
+struct st_thermal_sensor;
+
+/**
+ * Description of private thermal sensor ops.
+ *
+ * @power_ctrl:		Function for powering on/off a sensor. Clock to the
+ *			sensor is also controlled from this function.
+ * @alloc_regfields: 	Allocate regmap register fields, specific to a sensor.
+ * @do_memmap_regmap: 	Memory map the thermal register space and init regmap
+ *			instance or find regmap instance.
+ * @register_irq: 	Register an interrupt handler for a sensor.
+ */
+struct st_thermal_sensor_ops {
+	int (*power_ctrl)(struct st_thermal_sensor *, enum st_thermal_power_state);
+	int (*alloc_regfields)(struct st_thermal_sensor *);
+	int (*regmap_init)(struct st_thermal_sensor *);
+	int (*register_enable_irq)(struct st_thermal_sensor *);
+	int (*enable_irq)(struct st_thermal_sensor *);
+};
+
+/**
+ * Description of thermal driver compatible data.
+ *
+ * @reg_fields:		Pointer to the regfields array for a sensor.
+ * @sys_compat:		Pointer to the syscon node compatible string.
+ * @ops: 		Pointer to private thermal ops for a sensor.
+ * @calibration_val: 	Default calibration value to be written to the DCORRECT
+ *			register field for a sensor.
+ * @temp_adjust_val: 	Value to be added/subtracted from the data read from
+ *			the sensor. If value needs to be added please provide a
+ *			positive value and if it is to be subtracted please
+ * 			provide a negative value.
+ * @crit_temp: 		The temperature beyond which the SoC should be shutdown
+ * 			to prevent damage.
+ */
+struct st_thermal_compat_data {
+	char *sys_compat;
+	const struct reg_field *reg_fields;
+	const struct st_thermal_sensor_ops *ops;
+	unsigned int calibration_val;
+	int temp_adjust_val;
+	int crit_temp;
+};
+
+struct st_thermal_sensor {
+	struct device *dev;
+	struct thermal_zone_device *thermal_dev;
+	const struct st_thermal_sensor_ops *ops;
+	const struct st_thermal_compat_data *cdata;
+	struct clk *clk;
+	struct regmap *regmap;
+	struct regmap_field *pwr;
+	struct regmap_field *dcorrect;
+	struct regmap_field *overflow;
+	struct regmap_field *temp_data;
+	struct regmap_field *int_thresh_hi;
+	struct regmap_field *int_enable;
+	int irq;
+	void __iomem *mmio_base;
+};
+
+extern int st_thermal_register(struct platform_device *pdev,
+			       const struct of_device_id *st_thermal_of_match);
+extern int st_thermal_unregister(struct platform_device *pdev);
+extern const struct dev_pm_ops st_thermal_pm_ops;
+
+#endif /* __STI_RESET_SYSCFG_H */
-- 
1.8.3.2

