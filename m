Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaFEPHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:07:48 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:39163 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaFEPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:07:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, ajitpal.singh@st.com,
        edubezval@gmail.com, rui.zhang@intel.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com
Subject: [PATCH 3/6] thermal: sti: Add support for ST's System Config Register based Thermal controller
Date: Thu,  5 Jun 2014 16:06:56 +0100
Message-Id: <1401980819-19962-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
References: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply controller specific information to the ST Thermal Core.

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/thermal/st/Kconfig             |   4 +
 drivers/thermal/st/Makefile            |   1 +
 drivers/thermal/st/st_thermal_syscfg.c | 179 +++++++++++++++++++++++++++++++++
 3 files changed, 184 insertions(+)
 create mode 100644 drivers/thermal/st/st_thermal_syscfg.c

diff --git a/drivers/thermal/st/Kconfig b/drivers/thermal/st/Kconfig
index 1ba6760..d7b6e03 100644
--- a/drivers/thermal/st/Kconfig
+++ b/drivers/thermal/st/Kconfig
@@ -2,3 +2,7 @@ config ST_THERMAL
        tristate "Thermal sensors on STMicroelectronics STi series of SoCs"
        help
          Support for thermal sensors on STMicroelectronics STi series of SoCs.
+
+config ST_THERMAL_SYSCFG
+	select ST_THERMAL
+	tristate "STi series syscfg register access based thermal sensors"
diff --git a/drivers/thermal/st/Makefile b/drivers/thermal/st/Makefile
index 10f4bf6..e5058c6 100644
--- a/drivers/thermal/st/Makefile
+++ b/drivers/thermal/st/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_ST_THERMAL)		:= st_thermal.o
+obj-$(CONFIG_ST_THERMAL_SYSCFG)		+= st_thermal_syscfg.o
diff --git a/drivers/thermal/st/st_thermal_syscfg.c b/drivers/thermal/st/st_thermal_syscfg.c
new file mode 100644
index 0000000..888b58e
--- /dev/null
+++ b/drivers/thermal/st/st_thermal_syscfg.c
@@ -0,0 +1,179 @@
+/*
+ * ST Thermal Sensor Driver for syscfg based sensors.
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
+#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/mfd/syscon.h>
+
+#include "st_thermal.h"
+
+/* STiH415 */
+#define STIH415_SYSCFG_FRONT(num)		((num - 100) * 4)
+#define STIH415_SAS_THSENS_CONF			STIH415_SYSCFG_FRONT(178)
+#define STIH415_SAS_THSENS_STATUS		STIH415_SYSCFG_FRONT(198)
+#define STIH415_SYSCFG_MPE(num)			((num - 600) * 4)
+#define STIH415_MPE_THSENS_CONF			STIH415_SYSCFG_MPE(607)
+#define STIH415_MPE_THSENS_STATUS		STIH415_SYSCFG_MPE(667)
+
+/* STiH416 */
+#define STIH416_SYSCFG_FRONT(num)		((num - 1000) * 4)
+#define STIH416_SAS_THSENS_CONF			STIH416_SYSCFG_FRONT(1552)
+#define STIH416_SAS_THSENS_STATUS1		STIH416_SYSCFG_FRONT(1554)
+#define STIH416_SAS_THSENS_STATUS2		STIH416_SYSCFG_FRONT(1594)
+
+/* STiD127 */
+#define STID127_SYSCFG_CPU(num)			((num - 700) * 4)
+#define STID127_THSENS_CONF			STID127_SYSCFG_CPU(743)
+#define STID127_THSENS_STATUS			STID127_SYSCFG_CPU(767)
+
+static const struct reg_field st_415sas_regfields[MAX_REGFIELDS] = {
+	[TEMP_PWR] = REG_FIELD(STIH415_SAS_THSENS_CONF,   9,  9),
+	[DCORRECT] = REG_FIELD(STIH415_SAS_THSENS_CONF,   4,  8),
+	[OVERFLOW] = REG_FIELD(STIH415_SAS_THSENS_STATUS, 8,  8),
+	[DATA] 	   = REG_FIELD(STIH415_SAS_THSENS_STATUS, 10, 16),
+};
+
+static const struct reg_field st_415mpe_regfields[MAX_REGFIELDS] = {
+	[TEMP_PWR] = REG_FIELD(STIH415_MPE_THSENS_CONF,   8,  8),
+	[DCORRECT] = REG_FIELD(STIH415_MPE_THSENS_CONF,   3,  7),
+	[OVERFLOW] = REG_FIELD(STIH415_MPE_THSENS_STATUS, 9,  9),
+	[DATA]     = REG_FIELD(STIH415_MPE_THSENS_STATUS, 11, 18),
+};
+
+static const struct reg_field st_416sas_regfields[MAX_REGFIELDS] = {
+	[TEMP_PWR] = REG_FIELD(STIH416_SAS_THSENS_CONF,    9,  9),
+	[DCORRECT] = REG_FIELD(STIH416_SAS_THSENS_CONF,    4,  8),
+	[OVERFLOW] = REG_FIELD(STIH416_SAS_THSENS_STATUS1, 8,  8),
+	[DATA]     = REG_FIELD(STIH416_SAS_THSENS_STATUS2, 10, 16),
+};
+
+static const struct reg_field st_127_regfields[MAX_REGFIELDS] = {
+	[TEMP_PWR] = REG_FIELD(STID127_THSENS_CONF,   7,  7),
+	[DCORRECT] = REG_FIELD(STID127_THSENS_CONF,   2,  6),
+	[OVERFLOW] = REG_FIELD(STID127_THSENS_STATUS, 9,  9),
+	[DATA]     = REG_FIELD(STID127_THSENS_STATUS, 11, 18),
+};
+
+/* Private OPs for System Configuration Register based thermal sensors */
+static int st_syscfg_power_ctrl(struct st_thermal_sensor *sensor,
+				enum st_thermal_power_state power_state)
+{
+	return regmap_field_write(sensor->pwr, power_state);
+}
+
+static int st_syscfg_alloc_regfields(struct st_thermal_sensor *sensor)
+{
+	struct device *dev = sensor->dev;
+
+	sensor->pwr = devm_regmap_field_alloc(dev, sensor->regmap,
+					sensor->cdata->reg_fields[TEMP_PWR]);
+
+	if (IS_ERR(sensor->pwr)) {
+		dev_err(dev, "failed to alloc syscfg regfields\n");
+		return PTR_ERR(sensor->pwr);
+	}
+
+	return 0;
+}
+
+static int st_syscfg_regmap_init(struct st_thermal_sensor *sensor)
+{
+	sensor->regmap =
+		syscon_regmap_lookup_by_compatible(sensor->cdata->sys_compat);
+	if (IS_ERR(sensor->regmap)) {
+		dev_err(sensor->dev, "failed to find syscfg regmap\n");
+		return PTR_ERR(sensor->regmap);
+	}
+
+	return 0;
+}
+
+static const struct st_thermal_sensor_ops st_syscfg_sensor_ops = {
+	.power_ctrl		= st_syscfg_power_ctrl,
+	.alloc_regfields	= st_syscfg_alloc_regfields,
+	.regmap_init		= st_syscfg_regmap_init,
+};
+
+/* Compatible device data for stih415 sas thermal sensor */
+const struct st_thermal_compat_data st_415sas_cdata = {
+	.sys_compat		= "st,stih415-front-syscfg",
+	.reg_fields		= st_415sas_regfields,
+	.ops			= &st_syscfg_sensor_ops,
+	.calibration_val	= 16,
+	.temp_adjust_val	= 20,
+	.crit_temp		= 120,
+};
+
+/* Compatible device data for stih415 mpe thermal sensor */
+const struct st_thermal_compat_data st_415mpe_cdata = {
+	.sys_compat		= "st,stih415-system-syscfg",
+	.reg_fields		= st_415mpe_regfields,
+	.ops			= &st_syscfg_sensor_ops,
+	.calibration_val	= 16,
+	.temp_adjust_val	= -103,
+	.crit_temp		= 120,
+};
+
+/* Compatible device data for stih416 sas thermal sensor */
+const struct st_thermal_compat_data st_416sas_cdata = {
+	.sys_compat		= "st,stih416-front-syscfg",
+	.reg_fields		= st_416sas_regfields,
+	.ops			= &st_syscfg_sensor_ops,
+	.calibration_val	= 16,
+	.temp_adjust_val	= 20,
+	.crit_temp		= 120,
+};
+
+/* Compatible device data for stid127 thermal sensor */
+const struct st_thermal_compat_data st_127_cdata = {
+	.sys_compat		= "st,stid127-cpu-syscfg",
+	.reg_fields		= st_127_regfields,
+	.ops			= &st_syscfg_sensor_ops,
+	.calibration_val	= 8,
+	.temp_adjust_val	= -103,
+	.crit_temp		= 120,
+};
+
+static struct of_device_id st_syscfg_thermal_of_match[] = {
+	{ .compatible = "st,stih415-sas-thermal", .data = &st_415sas_cdata },
+	{ .compatible = "st,stih415-mpe-thermal", .data = &st_415mpe_cdata },
+	{ .compatible = "st,stih416-sas-thermal", .data = &st_416sas_cdata },
+	{ .compatible = "st,stid127-thermal",     .data = &st_127_cdata },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, st_syscfg_thermal_of_match);
+
+int st_syscfg_probe(struct platform_device *pdev)
+{
+	return st_thermal_register(pdev, st_syscfg_thermal_of_match);
+}
+
+int st_syscfg_remove(struct platform_device *pdev)
+{
+	return st_thermal_unregister(pdev);
+}
+
+static struct platform_driver st_syscfg_thermal_driver = {
+	.driver = {
+		.name	= "st_syscfg_thermal",
+		.owner  = THIS_MODULE,
+		.pm     = &st_thermal_pm_ops,
+		.of_match_table =  st_syscfg_thermal_of_match,
+	},
+	.probe		= st_syscfg_probe,
+	.remove		= st_syscfg_remove,
+};
+module_platform_driver(st_syscfg_thermal_driver);
+
+MODULE_AUTHOR("STMicroelectronics (R&D) Limited <ajitpal.singh@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics STi SoC Thermal Sensor Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

