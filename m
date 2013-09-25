Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3IYL2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:28:31 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:47387 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab3IYL22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:28:28 -0400
X-Greylist: delayed 1557 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2013 07:28:24 EDT
From: Ajit Pal Singh <ajitpal.singh@st.com>
To: <rui.zhang@intel.com>, <eduardo.valentin@ti.com>,
        <linux-pm@vger.kernel.org>
Cc: <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rob@landley.net>, Ajit Pal Singh <ajitpal.singh@st.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v2] thermal: st: Add support for STiH41x thermal sensors
Date: Wed, 25 Sep 2013 16:31:51 +0530
Message-ID: <1380106911-4998-1-git-send-email-ajitpal.singh@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <ajitpal.singh@st.com>
References: <ajitpal.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for thermal sensors on STiH41x series SOCs.
Single trip point 'THERMAL_TRIP_CRITICAL' is supported.
STIH416 MPE sensor supports interrupt reporting when a preset
threshold temperature is crossed.
For rest of the thermal sensors a polling delay of 10000ms is
set.

CC: Stephen Gallimore <stephen.gallimore@st.com>
CC: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
---
 .../devicetree/bindings/thermal/st-thermal.txt     |   22 +
 drivers/thermal/Kconfig                            |   11 +
 drivers/thermal/Makefile                           |    1 +
 drivers/thermal/st_thermal.c                       |  632 ++++++++++++++++++++
 4 files changed, 666 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/st-thermal.txt
 create mode 100644 drivers/thermal/st_thermal.c
---
History
v2: Updated with review comments from Eduardo Valentin.

diff --git a/Documentation/devicetree/bindings/thermal/st-thermal.txt b/Documentation/devicetree/bindings/thermal/st-thermal.txt
new file mode 100644
index 0000000..f127044
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/st-thermal.txt
@@ -0,0 +1,22 @@
+Binding for Thermal sensor driver for STMicroelectronics STiH41x series of SoCs.
+
+Required parameters:
+1) compatible : st,<SoC>-<module>-thermal
+		Should be one of "st,stih415-sas-thermal", "st,stih415-mpe-thermal",
+		"st,stih416-sas-thermal" or "st,stih416-mpe-thermal" according to the
+		SoC type (stih415 or stih416) and module type (sas or mpe).
+2) st,syscfg : 	Should be a phandle of the syscfg node.
+3) clocks: 	phandle of the clock used by the thermal sensor according to the common
+		clock binding: Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Optional:
+1) interrupts:	Standard way to define interrupt number.
+		refer: Documentation/devicetree/bindings/resource-names.txt
+		Interrupt is mandatory to be defined when compatible is stih416-mpe-thermal.
+
+Example:
+temp0{
+	compatible      = "st,stih416-sas-thermal";
+	st,syscfg       = <&syscfg_front>;
+	clocks          = <&CLOCKGEN_C_VCC 14>;
+}
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index e988c81..158b4d8 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -180,6 +180,17 @@ config X86_PKG_TEMP_THERMAL
 	  two trip points which can be set by user to get notifications via thermal
 	  notification methods.
 
+config ST_THERMAL
+	tristate "Thermal sensors on STMicroelectronics STiH41x series of SoCs"
+	depends on ARCH_STI
+	depends on OF
+	default y
+	help
+	  Support for thermal sensors on STMicroelectronics STiH41x series of
+	  SoCs. STiH415 and STiH416 SoCs have 2 thermal sensors each, one on the
+	  SAS and second on the MPE module. STiH416 MPE thermal sensor supports
+	  interrupt reporting when a preset thermal threshold is crossed.
+
 menu "Texas Instruments thermal drivers"
 source "drivers/thermal/ti-soc-thermal/Kconfig"
 endmenu
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 67184a2..d0a4c86 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+= db8500_cpufreq_cooling.o
 obj-$(CONFIG_INTEL_POWERCLAMP)	+= intel_powerclamp.o
 obj-$(CONFIG_X86_PKG_TEMP_THERMAL)	+= x86_pkg_temp_thermal.o
 obj-$(CONFIG_TI_SOC_THERMAL)	+= ti-soc-thermal/
+obj-$(CONFIG_ST_THERMAL)	+= st_thermal.o
diff --git a/drivers/thermal/st_thermal.c b/drivers/thermal/st_thermal.c
new file mode 100644
index 0000000..dbb573e
--- /dev/null
+++ b/drivers/thermal/st_thermal.c
@@ -0,0 +1,632 @@
+/*
+ * st_thermal.c: ST Thermal Sensor Driver for STIH41x series of SoCs
+ * Author: Ajit Pal Singh <ajitpal.singh@st.com>
+ *
+ * Copyright (C) 2003-2013 STMicroelectronics (R&D) Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+#include <linux/thermal.h>
+
+#define DRIVER_NAME "st-thermal"
+
+/* Regfield IDs */
+enum {
+	/*
+	 * The PWR and INTerrupt threshold regfields
+	 * share the same index as they are mutually exclusive
+	 */
+	TEMP_PWR = 0, INT_THRESH_HI = 0,
+	DCORRECT	= 1,
+	OVERFLOW	= 2,
+	DATA		= 3,
+	INT_ENABLE	= 4,
+	/* keep last */
+	MAX_REGFIELDS
+};
+
+/* Thermal sensor power states */
+enum st_thermal_power_state {
+	POWER_OFF = 0,
+	POWER_ON = 1
+};
+
+struct st_thermal_sensor;
+
+struct st_thermal_sensor_ops {
+	/* Power control */
+	int (*power_ctrl)(struct st_thermal_sensor *,
+		enum st_thermal_power_state);
+	/* Adjust the temperature read from the sensor */
+	unsigned int (*adjust_temp)(struct st_thermal_sensor *,
+		unsigned int);
+	/* Allocate regfields specific for this sensor */
+	int (*alloc_regfields)(struct st_thermal_sensor *);
+	int (*register_irq)(struct st_thermal_sensor *);
+	int (*enable_irq)(struct st_thermal_sensor *);
+};
+
+struct st_thermal_compat_data {
+	const struct reg_field *reg_fields;
+	struct st_thermal_sensor_ops *ops;
+	unsigned int calibration_val;
+	int temp_adjust_val;
+	int crit_temp;
+};
+
+struct st_thermal_sensor {
+	struct platform_device *pdev;
+	struct thermal_zone_device *th_dev;
+	struct st_thermal_sensor_ops *ops;
+	const struct st_thermal_compat_data *data;
+	struct clk *clk;
+	struct regmap *regmap;
+	struct regmap_field *pwr;
+	struct regmap_field *dcorrect;
+	struct regmap_field *overflow;
+	struct regmap_field *temp_data;
+	struct regmap_field *int_thresh_hi;
+	struct regmap_field *int_enable;
+	unsigned int irq;
+};
+
+/* Helper macros */
+#define thzone_to_sensor(th)			((th)->devdata)
+#define sensor_to_dev(sensor)			(&(sensor)->pdev->dev)
+
+/* STiH415 */
+#define STIH415_SYSCFG_FRONT(num)		((num - 100)*4)
+#define STIH415_SYSCFG_MPE(num)			((num - 600)*4)
+
+#define STIH415_SAS_THSENS_CONF			STIH415_SYSCFG_FRONT(178)
+#define STIH415_SAS_THSENS_STATUS		STIH415_SYSCFG_FRONT(198)
+#define STIH415_MPE_THSENS_CONF			STIH415_SYSCFG_MPE(607)
+#define STIH415_MPE_THSENS_STATUS		STIH415_SYSCFG_MPE(667)
+
+/* STiH416 */
+#define STIH416_SYSCFG_FRONT(num)		((num - 1000)*4)
+#define STIH416_SYSCFG_THSENS(num)		(num*4)
+
+#define STIH416_SAS_THSENS_CONF			STIH416_SYSCFG_FRONT(1552)
+#define STIH416_SAS_THSENS_STATUS1		STIH416_SYSCFG_FRONT(1554)
+#define STIH416_SAS_THSENS_STATUS2		STIH416_SYSCFG_FRONT(1594)
+#define STIH416_MPE_THSENS_CONF			STIH416_SYSCFG_THSENS(0)
+#define STIH416_MPE_THSENS_STATUS		STIH416_SYSCFG_THSENS(1)
+#define STIH416_MPE_THSENS_INT_THRESH		STIH416_SYSCFG_THSENS(2)
+#define STIH416_MPE_THSENS_INT_EN		STIH416_SYSCFG_THSENS(3)
+
+/* STiH416_MPE power control bits */
+#define STIH416_MPE_PDN				BIT(4)
+#define STIH416_MPE_SRSTN			BIT(10)
+
+#define mcelsius(temp)				((temp) * 1000)
+
+static const struct reg_field st_415sas_regfields[MAX_REGFIELDS] = {
+	[TEMP_PWR] = REG_FIELD(STIH415_SAS_THSENS_CONF, 9, 9),
+	[DCORRECT] = REG_FIELD(STIH415_SAS_THSENS_CONF, 4, 8),
+	[OVERFLOW] = REG_FIELD(STIH415_SAS_THSENS_STATUS, 9, 9),
+	[DATA] = REG_FIELD(STIH415_SAS_THSENS_STATUS, 11, 18),
+};
+
+static const struct reg_field st_415mpe_regfields[MAX_REGFIELDS] = {
+	[TEMP_PWR] = REG_FIELD(STIH415_MPE_THSENS_CONF, 8, 8),
+	[DCORRECT] = REG_FIELD(STIH415_MPE_THSENS_CONF, 3, 7),
+	[OVERFLOW] = REG_FIELD(STIH415_MPE_THSENS_STATUS, 9, 9),
+	[DATA] = REG_FIELD(STIH415_MPE_THSENS_STATUS, 11, 18),
+};
+
+static const struct reg_field st_416sas_regfields[MAX_REGFIELDS] = {
+	[TEMP_PWR] = REG_FIELD(STIH416_SAS_THSENS_CONF, 9, 9),
+	[DCORRECT] = REG_FIELD(STIH416_SAS_THSENS_CONF, 4, 8),
+	[OVERFLOW] = REG_FIELD(STIH416_SAS_THSENS_STATUS1, 8, 8),
+	[DATA] = REG_FIELD(STIH416_SAS_THSENS_STATUS2, 10, 16),
+};
+
+static const struct reg_field st_416mpe_regfields[MAX_REGFIELDS] = {
+	/*
+	 * According to the STIH416 MPE temp sensor data sheet -
+	 * the PDN (Power Down Bit) and SRSTN (Soft Reset Bit) need to be
+	 * written simultaneously for powering on and off the temperature
+	 * sensor. regmap_update_bits() will be used to update the register.
+	 */
+	[INT_THRESH_HI] = REG_FIELD(STIH416_MPE_THSENS_INT_THRESH, 0, 7),
+	[DCORRECT] = REG_FIELD(STIH416_MPE_THSENS_CONF, 5, 9),
+	[OVERFLOW] = REG_FIELD(STIH416_MPE_THSENS_STATUS, 9, 9),
+	[DATA] = REG_FIELD(STIH416_MPE_THSENS_STATUS, 11, 18),
+	[INT_ENABLE] = REG_FIELD(STIH416_MPE_THSENS_INT_EN, 0, 0),
+};
+
+static irqreturn_t st_thermal_thresh_int(int irq, void *data)
+{
+	struct st_thermal_sensor *sensor = data;
+	struct device *dev = sensor_to_dev(sensor);
+
+	dev_dbg(dev, "%s,called\n", __func__);
+	thermal_zone_device_update(sensor->th_dev);
+	return IRQ_HANDLED;
+}
+
+static int st_thermal_alloc_common_regfields(struct st_thermal_sensor *sensor)
+{
+	struct device *dev = sensor_to_dev(sensor);
+	struct regmap *regmap = sensor->regmap;
+	const struct reg_field *reg_fields = sensor->data->reg_fields;
+
+	sensor->dcorrect = devm_regmap_field_alloc(dev, regmap,
+					reg_fields[DCORRECT]);
+
+	sensor->overflow = devm_regmap_field_alloc(dev, regmap,
+					reg_fields[OVERFLOW]);
+
+	sensor->temp_data = devm_regmap_field_alloc(dev, regmap,
+					reg_fields[DATA]);
+
+	if (IS_ERR(sensor->dcorrect) || IS_ERR(sensor->overflow) ||
+	    IS_ERR(sensor->temp_data)) {
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Private ops for STIH415 SAS,MPE & STIH416 SAS sensor modules */
+static int st_power_ctrl(struct st_thermal_sensor *sensor,
+			enum st_thermal_power_state power_state)
+{
+	return regmap_field_write(sensor->pwr, power_state);
+}
+
+static unsigned int st_adjust_temp(struct st_thermal_sensor *sensor,
+				unsigned int raw_temp)
+{
+	return raw_temp + sensor->data->temp_adjust_val;
+}
+
+static int st_alloc_regfields(struct st_thermal_sensor *sensor)
+{
+	struct device *dev = sensor_to_dev(sensor);
+	int ret;
+
+	ret = st_thermal_alloc_common_regfields(sensor);
+	if (ret)
+		return ret;
+
+	sensor->pwr = devm_regmap_field_alloc(dev, sensor->regmap,
+				sensor->data->reg_fields[TEMP_PWR]);
+	if (IS_ERR(sensor->pwr)) {
+		dev_err(dev, "%s,failed to alloc reg field\n", __func__);
+		return PTR_ERR(sensor->pwr);
+	}
+	return 0;
+}
+
+static struct st_thermal_sensor_ops st_sensor_ops = {
+	.power_ctrl = st_power_ctrl,
+	.adjust_temp = st_adjust_temp,
+	.alloc_regfields = st_alloc_regfields,
+};
+
+/* Private ops for the STIH416 MPE sensor module */
+static int st_416mpe_power_ctrl(struct st_thermal_sensor *sensor,
+				enum st_thermal_power_state power_state)
+{
+	const unsigned int mask = (STIH416_MPE_PDN | STIH416_MPE_SRSTN);
+	const unsigned int val = power_state ? mask : 0;
+	return regmap_update_bits(sensor->regmap, STIH416_MPE_THSENS_CONF,
+				  mask, val);
+}
+
+static unsigned int st_416mpe_adjust_temp(struct st_thermal_sensor *sensor,
+					unsigned int raw_temp)
+{
+	return raw_temp - sensor->data->temp_adjust_val;
+}
+
+static int st_416mpe_alloc_regfields(struct st_thermal_sensor *sensor)
+{
+	struct device *dev = sensor_to_dev(sensor);
+	struct regmap *regmap = sensor->regmap;
+	const struct reg_field *reg_fields = sensor->data->reg_fields;
+	int ret;
+
+	ret = st_thermal_alloc_common_regfields(sensor);
+	if (ret)
+		return ret;
+
+	sensor->int_thresh_hi = devm_regmap_field_alloc(dev, regmap,
+					reg_fields[INT_THRESH_HI]);
+	sensor->int_enable = devm_regmap_field_alloc(dev, regmap,
+					reg_fields[INT_ENABLE]);
+	if (IS_ERR(sensor->int_thresh_hi) || IS_ERR(sensor->int_enable)) {
+		dev_err(dev, "%s,failed to alloc reg field(s)\n", __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int st_416mpe_register_irq(struct st_thermal_sensor *sensor)
+{
+	struct platform_device *pdev = sensor->pdev;
+	struct device *dev = sensor_to_dev(sensor);
+	int ret;
+
+	sensor->irq = platform_get_irq(pdev, 0);
+	if (sensor->irq < 0)
+		return sensor->irq;
+
+	ret = devm_request_threaded_irq(dev, sensor->irq,
+					NULL, st_thermal_thresh_int,
+					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					DRIVER_NAME, sensor);
+	if (ret) {
+		dev_err(dev, "IRQ %d register failed\n", sensor->irq);
+		return ret;
+	}
+	return sensor->ops->enable_irq(sensor);
+}
+
+static int st_416mpe_enable_irq(struct st_thermal_sensor *sensor)
+{
+	int ret;
+
+	/* Set upper critical threshold */
+	ret = regmap_field_write(sensor->int_thresh_hi, sensor->data->crit_temp
+			 + sensor->data->temp_adjust_val);
+	if (ret)
+		return ret;
+
+	return regmap_field_write(sensor->int_enable, 1);
+}
+
+static struct st_thermal_sensor_ops st_416mpe_sensor_ops = {
+	.power_ctrl = st_416mpe_power_ctrl,
+	.adjust_temp = st_416mpe_adjust_temp,
+	.alloc_regfields = st_416mpe_alloc_regfields,
+	.register_irq = st_416mpe_register_irq,
+	.enable_irq = st_416mpe_enable_irq,
+};
+
+/* Compatible device data for stih415 sas thermal sensor */
+static struct st_thermal_compat_data st_415sas_data = {
+	.reg_fields = &st_415sas_regfields[0],
+	.ops = &st_sensor_ops,
+	.calibration_val = 16,
+	.temp_adjust_val = 20,
+	.crit_temp = 120,
+};
+
+/* Compatible device data for stih415 mpe thermal sensor */
+static struct st_thermal_compat_data st_415mpe_data = {
+	.reg_fields = &st_415mpe_regfields[0],
+	.ops = &st_sensor_ops,
+	.calibration_val = 16,
+	.temp_adjust_val = 20,
+	.crit_temp = 120,
+};
+
+/* Compatible device data for stih416 sas thermal sensor */
+static struct st_thermal_compat_data st_416sas_data = {
+	.reg_fields = &st_416sas_regfields[0],
+	.ops = &st_sensor_ops,
+	.calibration_val = 16,
+	.temp_adjust_val = 20,
+	.crit_temp = 120,
+};
+
+/* Compatible device data stih416 mpe thermal sensor */
+static struct st_thermal_compat_data st_416mpe_data = {
+	.reg_fields = &st_416mpe_regfields[0],
+	.ops = &st_416mpe_sensor_ops,
+	.calibration_val = 24,
+	.temp_adjust_val = 103,
+	.crit_temp = 120,
+};
+
+static struct of_device_id st_thermal_of_match[] = {
+	{ .compatible = "st,stih415-sas-thermal",
+		.data = &st_415sas_data },
+	{ .compatible = "st,stih415-mpe-thermal",
+		.data = &st_415mpe_data },
+	{ .compatible = "st,stih416-sas-thermal",
+		.data = &st_416sas_data },
+	{ .compatible = "st,stih416-mpe-thermal",
+		.data = &st_416mpe_data },
+	{ /* sentinel */ }
+};
+
+static int st_thermal_probe_dt(struct st_thermal_sensor *sensor)
+{
+	struct device *dev = sensor_to_dev(sensor);
+	struct device_node *np = dev->of_node;
+
+	sensor->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
+	if (IS_ERR(sensor->regmap)) {
+		dev_err(dev, "no syscfg phandle specified\n");
+		return PTR_ERR(sensor->regmap);
+	}
+
+	sensor->data = of_match_node(st_thermal_of_match, np)->data;
+	if (!sensor->data->ops)
+		return -EINVAL;
+
+	sensor->ops = sensor->data->ops;
+	return sensor->ops->alloc_regfields(sensor);
+}
+
+static int st_thermal_sensor_on(struct st_thermal_sensor *sensor)
+{
+	int ret;
+	struct device *dev = sensor_to_dev(sensor);
+
+	ret = clk_prepare_enable(sensor->clk);
+	if (ret) {
+		dev_err(dev, "unable to enable clk\n");
+		goto out;
+	}
+
+	ret = sensor->ops->power_ctrl(sensor, POWER_ON);
+	if (ret) {
+		dev_err(dev, "unable to power on sensor\n");
+		goto clk_dis;
+	}
+	return 0;
+clk_dis:
+	clk_disable_unprepare(sensor->clk);
+out:
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
+	return 0;
+}
+
+/* Callback to get temperature from HW*/
+static int st_thermal_get_temp(struct thermal_zone_device *th,
+		unsigned long *temperature)
+{
+	struct st_thermal_sensor *sensor = thzone_to_sensor(th);
+	struct device *dev = sensor_to_dev(sensor);
+	unsigned int data;
+	unsigned int overflow;
+	int ret;
+
+	ret = regmap_field_read(sensor->overflow, &overflow);
+	if (ret)
+		return ret;
+	if (overflow)
+		return -EIO;
+
+	ret = regmap_field_read(sensor->temp_data, &data);
+	if (ret)
+		return ret;
+
+	data = sensor->ops->adjust_temp(sensor, data);
+	data = mcelsius(data);
+	dev_dbg(dev, "%s:temperature:%d\n", __func__, data);
+
+	*temperature = data;
+	return 0;
+}
+
+static int st_thermal_get_trip_type(struct thermal_zone_device *th,
+				int trip, enum thermal_trip_type *type)
+{
+	struct st_thermal_sensor *sensor = thzone_to_sensor(th);
+	struct device *dev = sensor_to_dev(sensor);
+
+	switch (trip) {
+	case 0:
+		*type = THERMAL_TRIP_CRITICAL;
+		break;
+	default:
+		dev_err(dev, "invalid trip point\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int st_thermal_get_trip_temp(struct thermal_zone_device *th,
+				    int trip, unsigned long *temp)
+{
+	struct st_thermal_sensor *sensor = thzone_to_sensor(th);
+	struct device *dev = sensor_to_dev(sensor);
+
+	switch (trip) {
+	case 0:
+		*temp = mcelsius(sensor->data->crit_temp);
+		break;
+	default:
+		dev_err(dev, "Invalid trip point\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int st_thermal_notify(struct thermal_zone_device *th,
+			       int trip, enum thermal_trip_type type)
+{
+	struct st_thermal_sensor *sensor = thzone_to_sensor(th);
+	struct device *dev = sensor_to_dev(sensor);
+
+	switch (type) {
+	case THERMAL_TRIP_CRITICAL:
+		dev_err(dev, "Critical temp reached:Going for shutdown\n");
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct thermal_zone_device_ops st_tz_ops = {
+	.get_temp	= st_thermal_get_temp,
+	.get_trip_type	= st_thermal_get_trip_type,
+	.get_trip_temp	= st_thermal_get_trip_temp,
+	.notify		= st_thermal_notify,
+};
+
+static int st_thermal_probe(struct platform_device *pdev)
+{
+	struct st_thermal_sensor *sensor;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	int ret;
+	unsigned int val;
+	static char start_banner[] __initdata =
+			"STMicroelectronics thermal sensor initialised\n";
+
+	if (!np) {
+		dev_err(dev, "device node not found\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
+	if (!sensor) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	sensor->pdev = pdev;
+	ret = st_thermal_probe_dt(sensor);
+	if (ret)
+		goto out;
+
+	sensor->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(sensor->clk)) {
+		dev_err(dev, "unable to get clk\n");
+		ret = PTR_ERR(sensor->clk);
+		goto out;
+	}
+	/* Activate thermal sensor */
+	ret = st_thermal_sensor_on(sensor);
+	if (ret) {
+		dev_err(dev, "unable to power on sensor\n");
+		goto out;
+	}
+
+	/* Check if sensor calibration data is already written */
+	ret = regmap_field_read(sensor->dcorrect, &val);
+	if (ret) {
+		dev_err(dev, "unable to read calibration data\n");
+		goto turn_off_exit;
+	}
+	if (val == 0) {
+		/* Sensor calibration value not set by bootloader,
+		 * default calibration data to be used
+		 */
+		ret = regmap_field_write(sensor->dcorrect,
+				sensor->data->calibration_val);
+		if (ret) {
+			dev_err(dev, "unable to set calibration data\n");
+			goto turn_off_exit;
+		}
+	}
+
+	sensor->th_dev = thermal_zone_device_register(
+		(char *)dev_name(dev), 1,
+		0, (void *)sensor, &st_tz_ops,
+		NULL, 0, sensor->ops->register_irq ? 0 : 10000);
+
+	if (IS_ERR(sensor->th_dev)) {
+		dev_err(dev, "unable to register thermal zone device\n");
+		ret = PTR_ERR(sensor->th_dev);
+		goto turn_off_exit;
+	}
+
+	if (sensor->ops->register_irq) {
+		ret = sensor->ops->register_irq(sensor);
+		if (ret) {
+			dev_err(dev, "unable to register irq\n");
+			goto unregister_thzone;
+		}
+	}
+
+	platform_set_drvdata(pdev, sensor);
+	dev_info(dev, start_banner);
+	return 0;
+
+unregister_thzone:
+	thermal_zone_device_unregister(sensor->th_dev);
+turn_off_exit:
+	st_thermal_sensor_off(sensor);
+out:
+	return ret;
+}
+
+static int st_thermal_remove(struct platform_device *pdev)
+{
+	struct st_thermal_sensor *sensor = platform_get_drvdata(pdev);
+
+	st_thermal_sensor_off(sensor);
+	thermal_zone_device_unregister(sensor->th_dev);
+	return 0;
+}
+
+#ifdef CONFIG_PM
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
+	if (sensor->ops->enable_irq) {
+		ret = sensor->ops->enable_irq(sensor);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(st_thermal_pm_ops, st_thermal_suspend,
+		st_thermal_resume);
+
+MODULE_DEVICE_TABLE(of, st_thermal_of_match);
+static struct platform_driver st_thermal_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+		.owner  = THIS_MODULE,
+		.of_match_table = st_thermal_of_match,
+		.pm     = &st_thermal_pm_ops,
+	},
+	.probe		= st_thermal_probe,
+	.remove		= st_thermal_remove,
+};
+
+module_platform_driver(st_thermal_driver);
+MODULE_AUTHOR("STMicroelectronics (R&D) Limited");
+MODULE_DESCRIPTION("STMicroelectronics STIH41x SOC thermal sensor driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

