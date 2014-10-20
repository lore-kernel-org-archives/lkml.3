Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaJTJzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:55:19 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:41796 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaJTJyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:54:16 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <e0f5c187325af90b44a170856b95fa35>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com
Cc: zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, dbasehore@chromium.org,
        huangtao@rock-chips.com, cjf@rock-chips.com, zhengsq@rock-chips.com,
        vladimir_zapolskiy@mentor.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v12 1/5] thermal: rockchip: add driver for thermal
Date: Mon, 20 Oct 2014 17:53:46 +0800
Message-Id: <1413798830-23435-2-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413798830-23435-1-git-send-email-caesar.wang@rock-chips.com>
References: <1413798830-23435-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thermal is TS-ADC Controller module supports
user-defined mode and automatic mode.

User-defined mode refers,TSADC all the control signals entirely by
software writing to register for direct control.

Automaic mode refers to the module automatically poll TSADC output,
and the results were checked.If you find that the temperature High
in a period of time,an interrupt is generated to the processor
down-measures taken;If the temperature over a period of time High,
the resulting TSHUT gave CRU module,let it reset the entire chip,
or via GPIO give PMIC.

Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 drivers/thermal/Kconfig            |   9 +
 drivers/thermal/Makefile           |   1 +
 drivers/thermal/rockchip_thermal.c | 725 +++++++++++++++++++++++++++++++++++++
 3 files changed, 735 insertions(+)
 create mode 100644 drivers/thermal/rockchip_thermal.c

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index ef5587f..5efcf73 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -133,6 +133,15 @@ config SPEAR_THERMAL
 	  Enable this to plug the SPEAr thermal sensor driver into the Linux
 	  thermal framework.
 
+config ROCKCHIP_THERMAL
+	tristate "Rockchip thermal driver"
+	depends on ARCH_ROCKCHIP
+	help
+	  Rockchip thermal driver provides support for Temperature sensor
+	  ADC (TS-ADC) found on Rockchip SoCs. It supports one critical
+	  trip point. Cpufreq is used as the cooling device and will throttle
+	  CPUs when the Temperature crosses the passive trip point.
+
 config RCAR_THERMAL
 	tristate "Renesas R-Car thermal driver"
 	depends on ARCH_SHMOBILE || COMPILE_TEST
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 31e232f..21da0a8 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -19,6 +19,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
 
 # platform thermal drivers
 obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
+obj-$(CONFIG_ROCKCHIP_THERMAL)	+= rockchip_thermal.o
 obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
 obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
 obj-y				+= samsung/
diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
new file mode 100644
index 0000000..a8de52f
--- /dev/null
+++ b/drivers/thermal/rockchip_thermal.c
@@ -0,0 +1,725 @@
+/*
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/cpu_cooling.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/thermal.h>
+
+/**
+ * If the temperature over a period of time High,
+ * the resulting TSHUT gave CRU module,let it reset the entire chip,
+ * or via GPIO give PMIC.
+ */
+enum reset_mode {
+	RESET_MODE_CRU = 0,
+	RESET_MODE_GPIO,
+};
+
+/**
+ * The system has three Temperature Sensors.  channel 0 is reserved,
+ * channel 1 is for CPU, and channel 2 is for GPU.
+ */
+enum sensor_id {
+	SENSOR_CPU = 1,
+	SENSOR_GPU,
+};
+
+struct rockchip_tsadc_chip {
+	long hw_shut_temp;
+	long hw_int_temp;
+	enum reset_mode reset_mode;
+
+	/* Chip-wide methods */
+	void (*initialize)(void __iomem *reg);
+	void (*irq_ack)(void __iomem *reg);
+
+	/* Per-sensor methods */
+	void (*control)(int chn, void __iomem *reg, bool on);
+	int (*get_temp)(int chn, void __iomem *reg, long *temp);
+	void (*set_alarm_temp)(int chn, void __iomem *reg, long temp);
+	void (*set_shutdown_temp)(int chn, void __iomem *reg, long temp);
+	void (*set_reset_mode)(int chn, void __iomem *reg, enum reset_mode m);
+};
+
+struct rockchip_thermal_sensor {
+	struct rockchip_thermal_data *thermal;
+	struct thermal_zone_device *tzd;
+	enum sensor_id id;
+};
+
+#define NUM_SENSORS	2 /* Ignore unused sensor 0 */
+
+struct rockchip_thermal_data {
+	const struct rockchip_tsadc_chip *chip;
+	struct platform_device *pdev;
+
+	struct rockchip_thermal_sensor sensors[NUM_SENSORS];
+
+	struct thermal_cooling_device *cdev;
+
+	struct clk *clk;
+	struct clk *pclk;
+
+	void __iomem *regs;
+
+	long hw_shut_temp;
+	long hw_int_temp;
+	enum reset_mode reset_mode;
+};
+
+/* TSADC V2 Sensor info define: */
+#define TSADCV2_AUTO_CON			0x04
+#define TSADCV2_INT_EN				0x08
+#define TSADCV2_INT_PD				0x0c
+#define TSADCV2_DATA(chn)			(0x20 + (chn) * 0x04)
+#define TSADCV2_COMP_INT(chn)		        (0x30 + (chn) * 0x04)
+#define TSADCV2_COMP_SHUT(chn)		        (0x40 + (chn) * 0x04)
+#define TSADCV2_HIGHT_INT_DEBOUNCE		0x60
+#define TSADCV2_HIGHT_TSHUT_DEBOUNCE		0x64
+#define TSADCV2_AUTO_PERIOD			0x68
+#define TSADCV2_AUTO_PERIOD_HT			0x6c
+
+#define TSADCV2_AUTO_EN				BIT(0)
+#define TSADCV2_AUTO_DISABLE			~BIT(0)
+#define TSADCV2_AUTO_SRC_EN			(0x3ff << 4)
+#define TSADCV2_AUTO_TSHUT_POLARITY_HIGH	BIT(8)
+#define TSADCV2_AUTO_TSHUT_POLARITY_LOW		~BIT(8)
+
+#define TSADCV2_INT_SRC_EN(chn)			BIT(chn)
+#define TSADCV2_SHUT_2GPIO_SRC_EN(chn)		(0xf << (4 + chn))
+#define TSADCV2_SHUT_2CRU_SRC_EN(chn)		(0xf << (8 + chn))
+
+#define TSADCV2_INT_PD_CLEAR			~BIT(8)
+
+#define TSADCV2_DATA_MASK			0xfff
+#define TSADCV2_HIGHT_INT_DEBOUNCE_TIME		0x0a
+#define TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME	0x0a
+#define TSADCV2_AUTO_PERIOD_TIME		0x03e8
+#define TSADCV2_AUTO_PERIOD_HT_TIME		0x64
+
+struct tsadc_table {
+	unsigned long code;
+	long temp;
+};
+
+static const struct tsadc_table v2_code_table[] = {
+	{TSADCV2_DATA_MASK, -40000},
+	{3800, -40000},
+	{3792, -35000},
+	{3783, -30000},
+	{3774, -25000},
+	{3765, -20000},
+	{3756, -15000},
+	{3747, -10000},
+	{3737, -5000},
+	{3728, 0},
+	{3718, 5000},
+	{3708, 10000},
+	{3698, 15000},
+	{3688, 20000},
+	{3678, 25000},
+	{3667, 30000},
+	{3656, 35000},
+	{3645, 40000},
+	{3634, 45000},
+	{3623, 50000},
+	{3611, 55000},
+	{3600, 60000},
+	{3588, 65000},
+	{3575, 70000},
+	{3563, 75000},
+	{3550, 80000},
+	{3537, 85000},
+	{3524, 90000},
+	{3510, 95000},
+	{3496, 100000},
+	{3482, 105000},
+	{3467, 110000},
+	{3452, 115000},
+	{3437, 120000},
+	{3421, 125000},
+	{0, 125000},
+};
+
+static u32 rk_tsadcv2_temp_to_code(long temp)
+{
+	int high, low, mid;
+
+	low = 0;
+	high = ARRAY_SIZE(v2_code_table) - 1;
+	mid = (high + low) / 2;
+
+	if (temp < v2_code_table[low].temp || temp > v2_code_table[high].temp)
+		return 0;
+
+	while (low <= high) {
+		if (temp == v2_code_table[mid].temp)
+			return v2_code_table[mid].code;
+		else if (temp < v2_code_table[mid].temp)
+			high = mid - 1;
+		else
+			low = mid + 1;
+		mid = (low + high) / 2;
+	}
+
+	return 0;
+}
+
+static long rk_tsadcv2_code_to_temp(u32 code)
+{
+	int high, low, mid;
+
+	low = 0;
+	high = ARRAY_SIZE(v2_code_table) - 1;
+	mid = (high + low) / 2;
+
+	if (code > v2_code_table[low].code || code < v2_code_table[high].code)
+		return 125000; /* No code available, return max temperature */
+
+	while (low <= high) {
+		if (code >= v2_code_table[mid].code && code <
+		    v2_code_table[mid - 1].code)
+			return v2_code_table[mid].temp;
+		else if (code < v2_code_table[mid].code)
+			low = mid + 1;
+		else
+			high = mid - 1;
+		mid = (low + high) / 2;
+	}
+
+	return 125000;
+}
+
+/**
+ * rk_tsadcv2_get_tshut_polarity_high - get the tshut polarity high
+ * the bit 8 is tshut polarity.
+ * 0: low active, 1: high active
+ */
+static bool rk_tsadcv2_get_tshut_polarity_high(void __iomem *regs)
+{
+	u32 val;
+	bool tshut_polarity;
+
+	val = readl_relaxed(regs + TSADCV2_AUTO_CON);
+	tshut_polarity = (val & TSADCV2_AUTO_TSHUT_POLARITY_HIGH) ? true :
+			  false;
+
+	return tshut_polarity;
+}
+
+/**
+ * rk_tsadcv2_initialize - initialize TASDC Controller
+ * (1) Set TSADCV2_AUTO_PERIOD, configure the interleave between
+ * every two accessing of TSADC in normal operation.
+ * (2) Set TSADCV2_AUTO_PERIOD_HT, configure the interleave between
+ * every  two accessing of TSADC after the temperature is higher
+ * than COM_SHUT or COM_INT.
+ * (3) Set TSADCV2_HIGH_INT_DEBOUNCE and TSADC_HIGHT_TSHUT_DEBOUNCE,
+ * if the temperature is higher than COMP_INT or COMP_SHUT for
+ * "debounce" times, TSADC controller will generate interrupt or TSHUT.
+ * (4) Set TSADCV2_AUTO_CON, enable the TSADC controller.
+ */
+static void rk_tsadcv2_initialize(void __iomem *regs)
+{
+	bool tshut_polarity;
+
+	tshut_polarity = rk_tsadcv2_get_tshut_polarity_high(regs);
+	if (tshut_polarity)
+		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_HIGH),
+			       regs + TSADCV2_AUTO_CON);
+	else
+		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_LOW),
+			       regs + TSADCV2_AUTO_CON);
+
+	writel_relaxed(TSADCV2_AUTO_PERIOD_TIME,
+		       regs + TSADCV2_AUTO_PERIOD);
+	writel_relaxed(TSADCV2_AUTO_PERIOD_HT_TIME,
+		       regs + TSADCV2_AUTO_PERIOD_HT);
+
+	writel_relaxed(TSADCV2_HIGHT_INT_DEBOUNCE_TIME,
+		       regs + TSADCV2_HIGHT_INT_DEBOUNCE);
+	writel_relaxed(TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME,
+		       regs + TSADCV2_HIGHT_TSHUT_DEBOUNCE);
+
+	writel_relaxed(TSADCV2_AUTO_SRC_EN | TSADCV2_AUTO_EN,
+		       regs + TSADCV2_AUTO_CON);
+}
+
+static void rk_tsadcv2_irq_ack(void __iomem *regs)
+{
+	u32 val;
+
+	val = readl_relaxed(regs + TSADCV2_INT_PD);
+	writel_relaxed(val & TSADCV2_INT_PD_CLEAR, regs + TSADCV2_INT_PD);
+}
+
+static void rk_tsadcv2_control(int chn, void __iomem *regs, bool on)
+{
+	u32 val;
+
+	if (on) {
+		val = readl_relaxed(regs + TSADCV2_AUTO_CON);
+		writel_relaxed(val | TSADCV2_AUTO_EN, regs + TSADCV2_AUTO_CON);
+	} else {
+		val = readl_relaxed(regs + TSADCV2_AUTO_CON);
+		writel_relaxed(val & TSADCV2_AUTO_DISABLE,
+			       regs + TSADCV2_AUTO_CON);
+	}
+}
+
+static int rk_tsadcv2_get_temp(int chn, void __iomem *regs, long *temp)
+{
+	u32 val;
+
+	/* the A/D value of the channel last conversion need some time */
+	val = readl_relaxed(regs + TSADCV2_DATA(chn));
+	if (val == 0)
+		return -EAGAIN;
+
+	*temp = rk_tsadcv2_code_to_temp(val);
+
+	return 0;
+}
+
+static void rk_tsadcv2_alarm_temp(int chn, void __iomem *regs, long temp)
+{
+	u32 alarm_value;
+
+	alarm_value = rk_tsadcv2_temp_to_code(temp);
+	writel_relaxed(alarm_value & TSADCV2_DATA_MASK,
+		       regs + TSADCV2_COMP_INT(chn));
+}
+
+static void rk_tsadcv2_shutdown_temp(int chn, void __iomem *regs, long temp)
+{
+	u32 shutdown_value;
+
+	shutdown_value = rk_tsadcv2_temp_to_code(temp);
+	writel_relaxed(shutdown_value, regs + TSADCV2_COMP_SHUT(chn));
+}
+
+static void rk_tsadcv2_reset_mode(int chn, void __iomem *regs,
+				  enum reset_mode mode)
+{
+	if (mode == RESET_MODE_GPIO)
+		writel_relaxed(TSADCV2_SHUT_2GPIO_SRC_EN(chn) |
+					TSADCV2_INT_SRC_EN(chn),
+			       regs + TSADCV2_INT_EN);
+	else
+		writel_relaxed(TSADCV2_SHUT_2CRU_SRC_EN(chn) |
+					TSADCV2_INT_SRC_EN(chn),
+			       regs + TSADCV2_INT_EN);
+}
+
+static const struct rockchip_tsadc_chip rk3288_tsadc_data = {
+	.reset_mode = RESET_MODE_GPIO, /* default TSHUT via GPIO give PMIC */
+	.hw_shut_temp = 120000,
+	.hw_int_temp = 80000,
+
+	.initialize = rk_tsadcv2_initialize,
+	.irq_ack = rk_tsadcv2_irq_ack,
+	.control = rk_tsadcv2_control,
+	.get_temp = rk_tsadcv2_get_temp,
+	.set_alarm_temp = rk_tsadcv2_alarm_temp,
+	.set_shutdown_temp = rk_tsadcv2_shutdown_temp,
+	.set_reset_mode = rk_tsadcv2_reset_mode,
+};
+
+static const struct of_device_id of_rockchip_thermal_match[] = {
+	{
+		.compatible = "rockchip,rk3288-tsadc",
+		.data = (void *)&rk3288_tsadc_data,
+	},
+	{ /* end */ },
+};
+MODULE_DEVICE_TABLE(of, of_rockchip_thermal_match);
+
+static void
+rockchip_thermal_toggle_sensor(struct rockchip_thermal_sensor *sensor, bool on)
+{
+	struct rockchip_thermal_data *thermal = sensor->thermal;
+	struct thermal_zone_device *tzd = sensor->tzd;
+	const struct rockchip_tsadc_chip *tsadc = thermal->chip;
+
+	tsadc->control(sensor->id, thermal->regs, on);
+	tzd->ops->set_mode(tzd,
+		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
+}
+
+static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
+{
+	struct rockchip_thermal_data *thermal = dev;
+	int i;
+
+	dev_dbg(&thermal->pdev->dev, "thermal alarm\n");
+
+	thermal->chip->irq_ack(thermal->regs);
+
+	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++)
+		thermal_zone_device_update(thermal->sensors[i].tzd);
+
+	return IRQ_HANDLED;
+}
+
+static int rockchip_thermal_set_trips(void *_sensor, long low, long high)
+{
+	struct rockchip_thermal_sensor *sensor = _sensor;
+	struct rockchip_thermal_data *thermal = sensor->thermal;
+	const struct rockchip_tsadc_chip *tsadc = thermal->chip;
+	int retval;
+	long current_temp;
+
+	retval = tsadc->get_temp(sensor->id, thermal->regs, &current_temp);
+
+	/* In general, when the temperature arrive trip point,
+	 * the system will cross the next trip point. but fixed it here.
+	 * cross the next trip point when the tempperature
+	 * is higher than COMP_INT "debounce" times.
+	 */
+	if (high >= thermal->hw_int_temp && current_temp > high)
+		high = thermal->hw_shut_temp;
+	else if (high >= thermal->hw_int_temp && current_temp <= high)
+		high = tsadc->hw_int_temp;
+
+	dev_dbg(&thermal->pdev->dev, "sensor %d: low: %ld, high %ld, retval:%d\n",
+		sensor->id, low, high, retval);
+
+	tsadc->set_alarm_temp(sensor->id, thermal->regs, high);
+
+	return retval;
+}
+
+static int rockchip_thermal_get_temp(void *_sensor, long *out_temp)
+{
+	struct rockchip_thermal_sensor *sensor = _sensor;
+	struct rockchip_thermal_data *thermal = sensor->thermal;
+	const struct rockchip_tsadc_chip *tsadc = sensor->thermal->chip;
+	int retval;
+
+	retval = tsadc->get_temp(sensor->id, thermal->regs, out_temp);
+	dev_dbg(&thermal->pdev->dev, "sensor %d - temp: %ld, retval: %d\n",
+		sensor->id, *out_temp, retval);
+
+	return retval;
+}
+
+static int rockchip_configure_from_dt(struct device *dev,
+				      struct device_node *np,
+				      struct rockchip_thermal_data *thermal)
+{
+	u32 int_temp, shut_temp, reset_mode;
+
+	if (of_property_read_u32(np, "hw-int-temp", &int_temp)) {
+		dev_warn(dev,
+			 "Missing int temp property, using default %ld\n",
+			 thermal->chip->hw_int_temp);
+		thermal->hw_int_temp = thermal->chip->hw_int_temp;
+	} else {
+		thermal->hw_int_temp = int_temp;
+	}
+
+	if (of_property_read_u32(np, "hw-shut-temp", &shut_temp)) {
+		dev_warn(dev,
+			 "Missing shutdown temp property, using default %ld\n",
+			 thermal->chip->hw_shut_temp);
+		thermal->hw_shut_temp = thermal->chip->hw_shut_temp;
+	} else {
+		thermal->hw_shut_temp = shut_temp;
+	}
+
+	if (thermal->hw_shut_temp > INT_MAX) {
+		dev_err(dev, "Invalid shutdown temperature specified: %ld\n",
+			thermal->hw_shut_temp);
+		return -ERANGE;
+	}
+
+	if (of_property_read_u32(np, "tsadc-ht-reset-mode", &reset_mode)) {
+		dev_warn(dev,
+			 "Missing reset mode propertyi, using default (%s)\n",
+			 thermal->chip->reset_mode == RESET_MODE_GPIO ?
+				"gpio" : "cru");
+		thermal->reset_mode = thermal->chip->reset_mode;
+	} else {
+		thermal->reset_mode = reset_mode;
+	}
+
+	if (thermal->reset_mode > 1) {
+		dev_err(dev, "Invalid reset mode specified: %d\n",
+			thermal->reset_mode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+rockchip_thermal_register_sensor(struct platform_device *pdev,
+				 struct rockchip_thermal_data *thermal,
+				 struct rockchip_thermal_sensor *sensor,
+				 enum sensor_id id)
+{
+	const struct rockchip_tsadc_chip *tsadc = thermal->chip;
+	int error;
+
+	sensor->thermal = thermal;
+	sensor->id = id;
+	sensor->tzd = thermal_zone_of_sensor_register(&pdev->dev, id, sensor,
+						rockchip_thermal_get_temp,
+						NULL,
+						rockchip_thermal_set_trips);
+	if (IS_ERR(sensor->tzd)) {
+		error = PTR_ERR(sensor->tzd);
+		dev_err(&pdev->dev, "failed to register sensor %d: %d\n",
+			id, error);
+		return error;
+	}
+
+	tsadc->set_reset_mode(id, thermal->regs, thermal->chip->reset_mode);
+	tsadc->set_shutdown_temp(id, thermal->regs, thermal->hw_shut_temp);
+	tsadc->set_alarm_temp(id, thermal->regs, thermal->hw_int_temp);
+
+	rockchip_thermal_toggle_sensor(sensor, true);
+
+	return 0;
+}
+
+static int rockchip_thermal_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct rockchip_thermal_data *thermal;
+	const struct of_device_id *match;
+	struct cpumask clip_cpus;
+	struct resource *res;
+	int irq;
+	int error;
+
+	match = of_match_node(of_rockchip_thermal_match, np);
+	if (!match)
+		return -ENXIO;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no irq resource?\n");
+		return -EINVAL;
+	}
+
+	thermal = devm_kzalloc(&pdev->dev, sizeof(struct rockchip_thermal_data),
+			       GFP_KERNEL);
+	if (!thermal)
+		return -ENOMEM;
+
+	thermal->pdev = pdev;
+
+	thermal->chip = (const struct rockchip_tsadc_chip *)match->data;
+	if (!thermal->chip)
+		return -EINVAL;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	thermal->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(thermal->regs))
+		return PTR_ERR(thermal->regs);
+
+	thermal->clk = devm_clk_get(&pdev->dev, "tsadc");
+	if (IS_ERR(thermal->clk)) {
+		error = PTR_ERR(thermal->clk);
+		dev_err(&pdev->dev, "failed to get tsadc clock: %d\n", error);
+		return error;
+	}
+
+	thermal->pclk = devm_clk_get(&pdev->dev, "apb_pclk");
+	if (IS_ERR(thermal->pclk)) {
+		error = PTR_ERR(thermal->clk);
+		dev_err(&pdev->dev, "failed to get apb_pclk clock: %d\n",
+			error);
+		return error;
+	}
+
+	/**
+	 * Use a default of 10KHz for the converter clock.
+	 * This may become user-configurable in the future.
+	 * Need to judge the thermal->clk is Divided by xin32k.
+	 * Need to retry it if the pmic hasn't output the xin32k.
+	 */
+	if (clk_get_rate(thermal->clk) == 0)
+		return -EPROBE_DEFER;
+
+	error = clk_set_rate(thermal->clk, 10000);
+	if (error) {
+		dev_err(&pdev->dev, "failed to set tsadc clk rate: %d\n",
+			error);
+		return error;
+	}
+
+	error = clk_prepare_enable(thermal->clk);
+	if (error) {
+		dev_err(&pdev->dev, "failed to enable converter clock: %d\n",
+			error);
+		return error;
+	}
+
+	error = clk_prepare_enable(thermal->pclk);
+	if (error) {
+		dev_err(&pdev->dev, "failed to enable pclk: %d\n", error);
+		goto err_disable_clk;
+	}
+
+	cpumask_set_cpu(0, &clip_cpus);
+	thermal->cdev = of_cpufreq_cooling_register(np, &clip_cpus);
+	if (IS_ERR(thermal->cdev)) {
+		error = PTR_ERR(thermal->cdev);
+		dev_err(&pdev->dev,
+			"failed to register cpufreq cooling device: %d\n",
+			error);
+		goto err_disable_pclk;
+	}
+
+	error = rockchip_configure_from_dt(&pdev->dev, np, thermal);
+	if (error) {
+		dev_err(&pdev->dev, "failed to parse device tree data: %d\n",
+			error);
+		goto err_unregister_cooling_device;
+	}
+
+	thermal->chip->initialize(thermal->regs);
+
+	error = rockchip_thermal_register_sensor(pdev, thermal,
+						 &thermal->sensors[0],
+						 SENSOR_CPU);
+	if (error) {
+		dev_err(&pdev->dev,
+			"failed to register CPU thermal sensor: %d\n", error);
+		goto err_unregister_cooling_device;
+	}
+
+	error = rockchip_thermal_register_sensor(pdev, thermal,
+						 &thermal->sensors[1],
+						 SENSOR_GPU);
+	if (error) {
+		dev_err(&pdev->dev,
+			"failed to register GPU thermal sensor: %d\n", error);
+		goto err_unregister_cpu_sensor;
+	}
+
+	error = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					  &rockchip_thermal_alarm_irq_thread,
+					  IRQF_ONESHOT,
+					  "rockchip_thermal", thermal);
+	if (error) {
+		dev_err(&pdev->dev,
+			"failed to request tsadc irq: %d\n", error);
+		goto err_unregister_gpu_sensor;
+	}
+
+	platform_set_drvdata(pdev, thermal);
+
+	return 0;
+
+err_unregister_gpu_sensor:
+	thermal_zone_of_sensor_unregister(&pdev->dev, thermal->sensors[1].tzd);
+err_unregister_cpu_sensor:
+	thermal_zone_of_sensor_unregister(&pdev->dev, thermal->sensors[0].tzd);
+err_unregister_cooling_device:
+	cpufreq_cooling_unregister(thermal->cdev);
+err_disable_pclk:
+	clk_disable_unprepare(thermal->pclk);
+err_disable_clk:
+	clk_disable_unprepare(thermal->clk);
+
+	return error;
+}
+
+static int rockchip_thermal_remove(struct platform_device *pdev)
+{
+	struct rockchip_thermal_data *thermal = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++) {
+		struct rockchip_thermal_sensor *sensor = &thermal->sensors[i];
+
+		rockchip_thermal_toggle_sensor(sensor, false);
+		thermal_zone_of_sensor_unregister(&pdev->dev, sensor->tzd);
+	}
+
+	cpufreq_cooling_unregister(thermal->cdev);
+
+	clk_disable_unprepare(thermal->clk);
+	clk_disable_unprepare(thermal->pclk);
+
+	return 0;
+}
+
+static int __maybe_unused rockchip_thermal_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rockchip_thermal_data *thermal = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++)
+		rockchip_thermal_toggle_sensor(&thermal->sensors[i], false);
+
+	clk_disable(thermal->clk);
+	clk_disable(thermal->pclk);
+
+	return 0;
+}
+
+static int __maybe_unused rockchip_thermal_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rockchip_thermal_data *thermal = platform_get_drvdata(pdev);
+	int i;
+	int error;
+
+	error = clk_enable(thermal->pclk);
+	if (error)
+		return error;
+
+	error = clk_enable(thermal->clk);
+	if (error)
+		return error;
+
+	thermal->chip->initialize(thermal->regs);
+
+	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++)
+		rockchip_thermal_toggle_sensor(&thermal->sensors[i], true);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(rockchip_thermal_pm_ops,
+			 rockchip_thermal_suspend, rockchip_thermal_resume);
+
+static struct platform_driver rockchip_thermal_driver = {
+	.driver = {
+		.name = "rockchip-thermal",
+		.owner = THIS_MODULE,
+		.pm = &rockchip_thermal_pm_ops,
+		.of_match_table = of_rockchip_thermal_match,
+	},
+	.probe = rockchip_thermal_probe,
+	.remove = rockchip_thermal_remove,
+};
+
+module_platform_driver(rockchip_thermal_driver);
+
+MODULE_DESCRIPTION("ROCKCHIP THERMAL Driver");
+MODULE_AUTHOR("Rockchip, Inc.");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:rockchip-thermal");
-- 
1.9.1


