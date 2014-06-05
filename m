Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaFEPHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:07:52 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33182 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaFEPHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:07:48 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, ajitpal.singh@st.com,
        edubezval@gmail.com, rui.zhang@intel.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com
Subject: [PATCH 4/6] thermal: sti: Add support for ST's Memory Mapped based Thermal controller
Date: Thu,  5 Jun 2014 16:06:57 +0100
Message-Id: <1401980819-19962-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
References: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the traditional way of obtaining a device driver's register
address space.  The aim of this driver is to supply controller specific
information to the ST Thermal Core.

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/thermal/st/Kconfig             |   4 +
 drivers/thermal/st/Makefile            |   1 +
 drivers/thermal/st/st_thermal_memmap.c | 209 +++++++++++++++++++++++++++++++++
 3 files changed, 214 insertions(+)
 create mode 100644 drivers/thermal/st/st_thermal_memmap.c

diff --git a/drivers/thermal/st/Kconfig b/drivers/thermal/st/Kconfig
index d7b6e03..490fdbe 100644
--- a/drivers/thermal/st/Kconfig
+++ b/drivers/thermal/st/Kconfig
@@ -6,3 +6,7 @@ config ST_THERMAL
 config ST_THERMAL_SYSCFG
 	select ST_THERMAL
 	tristate "STi series syscfg register access based thermal sensors"
+
+config ST_THERMAL_MEMMAP
+	select ST_THERMAL
+	tristate "STi series memory mapped access based thermal sensors"
diff --git a/drivers/thermal/st/Makefile b/drivers/thermal/st/Makefile
index e5058c6..b388789 100644
--- a/drivers/thermal/st/Makefile
+++ b/drivers/thermal/st/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_ST_THERMAL)		:= st_thermal.o
 obj-$(CONFIG_ST_THERMAL_SYSCFG)		+= st_thermal_syscfg.o
+obj-$(CONFIG_ST_THERMAL_MEMMAP)		+= st_thermal_memmap.o
diff --git a/drivers/thermal/st/st_thermal_memmap.c b/drivers/thermal/st/st_thermal_memmap.c
new file mode 100644
index 0000000..39896ce
--- /dev/null
+++ b/drivers/thermal/st/st_thermal_memmap.c
@@ -0,0 +1,209 @@
+/*
+ * ST Thermal Sensor Driver for memory mapped sensors.
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
+
+#include "st_thermal.h"
+
+#define STIH416_MPE_CONF			0x0
+#define STIH416_MPE_STATUS			0x4
+#define STIH416_MPE_INT_THRESH			0x8
+#define STIH416_MPE_INT_EN			0xC
+
+/* Power control bits for the memory mapped thermal sensor */
+#define THERMAL_PDN				BIT(4)
+#define THERMAL_SRSTN				BIT(10)
+
+static const struct reg_field st_mmap_thermal_regfields[MAX_REGFIELDS] = {
+	/*
+	 * According to the STIH416 MPE temp sensor data sheet -
+	 * the PDN (Power Down Bit) and SRSTN (Soft Reset Bit) need to be
+	 * written simultaneously for powering on and off the temperature
+	 * sensor. regmap_update_bits() will be used to update the register.
+	 */
+	[INT_THRESH_HI]	= REG_FIELD(STIH416_MPE_INT_THRESH, 	0,  7),
+	[DCORRECT]	= REG_FIELD(STIH416_MPE_CONF,		5,  9),
+	[OVERFLOW]	= REG_FIELD(STIH416_MPE_STATUS,		9,  9),
+	[DATA]		= REG_FIELD(STIH416_MPE_STATUS,		11, 18),
+	[INT_ENABLE]	= REG_FIELD(STIH416_MPE_INT_EN,		0,  0),
+};
+
+static irqreturn_t st_mmap_thermal_trip_handler(int irq, void *sdata)
+{
+	struct st_thermal_sensor *sensor = sdata;
+
+	thermal_zone_device_update(sensor->thermal_dev);
+
+	return IRQ_HANDLED;
+}
+
+/* Private ops for the Memory Mapped based thermal sensors */
+static int st_mmap_power_ctrl(struct st_thermal_sensor *sensor,
+			      enum st_thermal_power_state power_state)
+{
+	const unsigned int mask = (THERMAL_PDN | THERMAL_SRSTN);
+	const unsigned int val = power_state ? mask : 0;
+
+	return regmap_update_bits(sensor->regmap, STIH416_MPE_CONF, mask, val);
+}
+
+static int st_mmap_alloc_regfields(struct st_thermal_sensor *sensor)
+{
+	struct device *dev = sensor->dev;
+	struct regmap *regmap = sensor->regmap;
+	const struct reg_field *reg_fields = sensor->cdata->reg_fields;
+
+	sensor->int_thresh_hi = devm_regmap_field_alloc(dev, regmap,
+						reg_fields[INT_THRESH_HI]);
+	sensor->int_enable = devm_regmap_field_alloc(dev, regmap,
+						reg_fields[INT_ENABLE]);
+
+	if (IS_ERR(sensor->int_thresh_hi) || IS_ERR(sensor->int_enable)) {
+		dev_err(dev, "failed to alloc mmap regfields\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int st_mmap_enable_irq(struct st_thermal_sensor *sensor)
+{
+	int ret;
+
+	/* Set upper critical threshold */
+	ret = regmap_field_write(sensor->int_thresh_hi,
+				 sensor->cdata->crit_temp -
+				 sensor->cdata->temp_adjust_val);
+	if (ret)
+		return ret;
+
+	return regmap_field_write(sensor->int_enable, 1);
+}
+
+static int st_mmap_register_enable_irq(struct st_thermal_sensor *sensor)
+{
+	struct device *dev = sensor->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	int ret;
+
+	sensor->irq = platform_get_irq(pdev, 0);
+	if (sensor->irq < 0) {
+		dev_err(dev, "failed to register IRQ\n");
+		return sensor->irq;
+	}
+
+	ret = devm_request_threaded_irq(dev, sensor->irq,
+					NULL, st_mmap_thermal_trip_handler,
+					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					dev->driver->name, sensor);
+	if (ret) {
+		dev_err(dev, "failed to register IRQ %d\n", sensor->irq);
+		return ret;
+	}
+
+	return st_mmap_enable_irq(sensor);
+}
+
+static const struct regmap_config st_416mpe_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
+static int st_mmap_regmap_init(struct st_thermal_sensor *sensor)
+{
+	struct device *dev = sensor->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "no memory resources defined\n");
+		return -ENODEV;
+	}
+
+	sensor->mmio_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(sensor->mmio_base)) {
+		dev_err(dev, "failed to remap IO\n");
+		return PTR_ERR(sensor->mmio_base);
+	}
+
+	sensor->regmap = devm_regmap_init_mmio(dev, sensor->mmio_base,
+				&st_416mpe_regmap_config);
+	if (IS_ERR(sensor->regmap)) {
+		dev_err(dev, "failed to initialise regmap\n");
+		return PTR_ERR(sensor->regmap);
+	}
+
+	return 0;
+}
+
+static const struct st_thermal_sensor_ops st_mmap_sensor_ops = {
+	.power_ctrl		= st_mmap_power_ctrl,
+	.alloc_regfields	= st_mmap_alloc_regfields,
+	.regmap_init		= st_mmap_regmap_init,
+	.register_enable_irq	= st_mmap_register_enable_irq,
+	.enable_irq		= st_mmap_enable_irq,
+};
+
+/* Compatible device data stih416 mpe thermal sensor */
+const struct st_thermal_compat_data st_416mpe_cdata = {
+	.reg_fields		= st_mmap_thermal_regfields,
+	.ops			= &st_mmap_sensor_ops,
+	.calibration_val	= 14,
+	.temp_adjust_val	= -95,
+	.crit_temp		= 120,
+};
+
+/* Compatible device data stih407 thermal sensor */
+const struct st_thermal_compat_data st_407_cdata = {
+	.reg_fields		= st_mmap_thermal_regfields,
+	.ops			= &st_mmap_sensor_ops,
+	.calibration_val	= 16,
+	.temp_adjust_val	= -95,
+	.crit_temp		= 120,
+};
+
+static struct of_device_id st_mmap_thermal_of_match[] = {
+	{ .compatible = "st,stih416-mpe-thermal", .data = &st_416mpe_cdata },
+	{ .compatible = "st,stih407-thermal",     .data = &st_407_cdata },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, st_mmap_thermal_of_match);
+
+int st_mmap_probe(struct platform_device *pdev)
+{
+	return st_thermal_register(pdev,  st_mmap_thermal_of_match);
+}
+
+int st_mmap_remove(struct platform_device *pdev)
+{
+	return st_thermal_unregister(pdev);
+}
+
+static struct platform_driver st_mmap_thermal_driver = {
+	.driver = {
+		.name	= "st_thermal_mmap",
+		.owner  = THIS_MODULE,
+		.pm     = &st_thermal_pm_ops,
+		.of_match_table = st_mmap_thermal_of_match,
+	},
+	.probe		= st_mmap_probe,
+	.remove		= st_mmap_remove,
+};
+
+module_platform_driver(st_mmap_thermal_driver);
+
+MODULE_AUTHOR("STMicroelectronics (R&D) Limited <ajitpal.singh@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics STi SoC Thermal Sensor Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

