Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbaIZOfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:35:22 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:59422 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbaIZOek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:34:40 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <ffd68177042a6070b429e7e5c898ccfd>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com
Cc: dmitry.torokhov@gmail.com, arnd@arndb.de, zyf@rock-chips.com,
        dianders@chromium.org, cjf@rock-chips.com, zhengsq@rock-chips.com,
        linux-rockchip@list.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v6 1/3] thermal: rockchip: add driver for Thermal
Date: Fri, 26 Sep 2014 22:33:10 +0800
Message-Id: <1411741992-18890-2-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411741992-18890-1-git-send-email-caesar.wang@rock-chips.com>
References: <1411741992-18890-1-git-send-email-caesar.wang@rock-chips.com>
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
 drivers/thermal/Kconfig            |  10 +
 drivers/thermal/Makefile           |   1 +
 drivers/thermal/rockchip_thermal.c | 605 +++++++++++++++++++++++++++++++++++++
 3 files changed, 616 insertions(+)
 create mode 100644 drivers/thermal/rockchip_thermal.c

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index f9a1386..302c3c8 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -133,6 +133,16 @@ config SPEAR_THERMAL
 	  Enable this to plug the SPEAr thermal sensor driver into the Linux
 	  thermal framework.
 
+config ROCKCHIP_THERMAL
+	tristate "Rockchip thermal driver"
+	depends on ARCH_ROCKCHIP
+	help
+	  Rockchip thermal driver provides support for Temperature sensor
+          ADC (TS-ADC) found on Rockchip SoCs. It supports one critical
+          trip point and one passive trip point. Cpufreq is used as the
+          cooling device and will throttle CPUs when the Temperature
+          crosses the passive trip point.
+
 config RCAR_THERMAL
 	tristate "Renesas R-Car thermal driver"
 	depends on ARCH_SHMOBILE || COMPILE_TEST
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index de0636a..930554f 100644
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
index 0000000..8f076d4
--- /dev/null
+++ b/drivers/thermal/rockchip_thermal.c
@@ -0,0 +1,605 @@
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
+*/
+
+#include <linux/clk.h>
+#include <linux/gpio/consumer.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/cpu_cooling.h>
+#include <linux/thermal.h>
+
+struct rockchip_thermal_data {
+	const struct rockchip_tsadc_platform_data *pdata;
+	struct thermal_zone_device *tz;
+	struct thermal_cooling_device *cdev;
+	void __iomem *regs;
+
+	unsigned long temp_passive;
+	unsigned long temp_critical;
+	unsigned long hw_shut_temp;
+	unsigned long alarm_temp;
+	unsigned long last_temp;
+	bool irq_enabled;
+	int irq;
+
+	struct clk *clk;
+	struct clk *pclk;
+	struct gpio_desc *reset_gpio;
+};
+
+struct rockchip_tsadc_platform_data {
+	u8 irq_en;
+	unsigned long hw_shut_temp;
+
+	int (*irq_handle)(void __iomem *reg);
+	int (*initialize)(void __iomem *reg, unsigned long hw_shut_temp);
+	int (*control)(void __iomem *reg, bool on);
+	int (*code_to_temp)(u32 code);
+	u32 (*temp_to_code)(int temp);
+	void (*set_alarm_temp)(void __iomem *regs, unsigned long alarm_temp);
+};
+
+/* TSADC V2 Sensor info define: */
+#define TSADCV2_AUTO_CON			0x04
+#define TSADCV2_INT_EN				0x08
+#define TSADCV2_INT_PD				0x0c
+#define TSADCV2_DATA1				0x24
+#define TSADCV2_COMP1_INT			0x34
+#define TSADCV2_COMP1_SHUT			0x44
+#define TSADCV2_AUTO_PERIOD			0x68
+#define TSADCV2_AUTO_PERIOD_HT			0x6c
+
+#define TSADCV2_AUTO_SRC1_EN			BIT(5)
+#define TSADCV2_AUTO_EN				BIT(0)
+#define TSADCV2_AUTO_DISABLE			~BIT(0)
+#define TSADCV2_AUTO_STAS_BUSY			BIT(16)
+#define TSADCV2_AUTO_STAS_BUSY_MASK		BIT(16)
+#define TSADCV2_SHUT_2GPIO_SRC1_EN		BIT(5)
+#define TSADCV2_INT_SRC1_EN			BIT(1)
+#define TSADCV2_SHUT_SRC1_STATUS		BIT(5)
+#define TSADCV2_INT_SRC1_STATUS			BIT(1)
+#define TSADCV2_INT_PD_CLEAR			~BIT(8)
+
+#define TSADCV2_DATA_MASK			0xfff
+#define TSADCV2_HIGHT_INT_DEBOUNCE		0x60
+#define TSADCV2_HIGHT_TSHUT_DEBOUNCE		0x64
+#define TSADCV2_HIGHT_INT_DEBOUNCE_TIME		0x0a
+#define TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME	0x0a
+#define TSADCV2_AUTO_PERIOD_TIME		0x03e8
+#define TSADCV2_AUTO_PERIOD_HT_TIME		0x64
+
+struct tsadc_table {
+	unsigned long code;
+	int temp;
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
+static int rk_tsadcv2_irq_handle(void __iomem *regs)
+{
+	u32 val;
+
+	val = readl_relaxed(regs + TSADCV2_INT_PD);
+	writel_relaxed(val & TSADCV2_INT_PD_CLEAR, regs + TSADCV2_INT_PD);
+
+	return 0;
+}
+
+static u32 rk_tsadcv2_temp_to_code(int temp)
+{
+	int high, low, mid, ret = 0;
+
+	low = 0;
+	high = ARRAY_SIZE(v2_code_table) - 1;
+	mid = (high + low) / 2;
+
+	if (temp < v2_code_table[low].temp || temp > v2_code_table[high].temp) {
+		ret = -ERANGE;
+		goto exit;
+	}
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
+
+exit:
+	return ret;
+}
+
+static int rk_tsadcv2_code_to_temp(u32 code)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(v2_code_table) - 1; i++) {
+		if (code >= v2_code_table[i].code)
+			return v2_code_table[i].temp;
+	}
+
+	/* no code available,return max temperture */
+	return 125000;
+}
+
+static int rk_tsadcv2_initialize(void __iomem *regs,
+				 unsigned long hw_shut_temp)
+{
+	u32 shutdown_value;
+
+	shutdown_value = rk_tsadcv2_temp_to_code(hw_shut_temp);
+
+	/* Enable measurements at ~ 10 Hz */
+	writel_relaxed(0, regs + TSADCV2_AUTO_CON);
+	writel_relaxed(TSADCV2_AUTO_PERIOD_TIME, regs + TSADCV2_AUTO_PERIOD);
+	writel_relaxed(TSADCV2_AUTO_PERIOD_HT_TIME, regs +
+		       TSADCV2_AUTO_PERIOD_HT);
+	writel_relaxed(shutdown_value, regs + TSADCV2_COMP1_SHUT);
+	writel_relaxed(TSADCV2_HIGHT_INT_DEBOUNCE_TIME, regs +
+		       TSADCV2_HIGHT_INT_DEBOUNCE);
+	writel_relaxed(TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME, regs +
+		       TSADCV2_HIGHT_TSHUT_DEBOUNCE);
+	writel_relaxed(TSADCV2_SHUT_2GPIO_SRC1_EN | TSADCV2_INT_SRC1_EN, regs +
+		       TSADCV2_INT_EN);
+	writel_relaxed(TSADCV2_AUTO_SRC1_EN | TSADCV2_AUTO_EN, regs +
+		       TSADCV2_AUTO_CON);
+
+	return 0;
+}
+
+static int rk_tsadcv2_control(void __iomem *regs, bool on)
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
+
+	return 0;
+}
+
+static void rk_tsadcv2_alarm_temp(void __iomem *regs, unsigned long alarm_temp)
+{
+	u32 alarm_value;
+
+	alarm_value = rk_tsadcv2_temp_to_code(alarm_temp);
+
+	writel_relaxed(alarm_value, regs + TSADCV2_COMP1_INT);
+}
+
+static const struct rockchip_tsadc_platform_data rk3288_tsadc_data = {
+	.irq_en = 1,
+	.hw_shut_temp = 115000,
+	.irq_handle = rk_tsadcv2_irq_handle,
+	.initialize = rk_tsadcv2_initialize,
+	.control = rk_tsadcv2_control,
+	.code_to_temp = rk_tsadcv2_code_to_temp,
+	.temp_to_code = rk_tsadcv2_temp_to_code,
+	.set_alarm_temp = rk_tsadcv2_alarm_temp,
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
+static void rockchip_set_alarm_temp(struct rockchip_thermal_data *data,
+				    int alarm_temp)
+{
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+
+	data->alarm_temp = alarm_temp;
+	if (p_tsadc_data->set_alarm_temp)
+		p_tsadc_data->set_alarm_temp(data->regs, alarm_temp);
+}
+
+static int rockchip_thermal_initialize(struct rockchip_thermal_data *data)
+{
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+
+	if (p_tsadc_data->initialize)
+		p_tsadc_data->initialize(data->regs, data->hw_shut_temp);
+	rockchip_set_alarm_temp(data, data->temp_passive);
+
+	return 0;
+}
+
+static void rockchip_thermal_control(struct rockchip_thermal_data *data,
+				     bool on)
+{
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+
+	if (p_tsadc_data->control)
+		p_tsadc_data->control(data->regs, on);
+
+	if (on) {
+		data->irq_enabled = true;
+		data->tz->ops->set_mode(data->tz, THERMAL_DEVICE_ENABLED);
+	} else {
+		data->irq_enabled = false;
+		data->tz->ops->set_mode(data->tz, THERMAL_DEVICE_DISABLED);
+	}
+}
+
+static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
+{
+	struct rockchip_thermal_data *data = dev;
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+
+	unsigned long current_temp;
+	int err;
+
+	dev_info(&data->tz->device, "THERMAL ALARM: T > %lu\n",
+		 data->alarm_temp / 1000);
+
+	if (p_tsadc_data->irq_en && p_tsadc_data->irq_handle)
+		p_tsadc_data->irq_handle(data->regs);
+
+	thermal_zone_device_update(data->tz);
+
+	/**
+	* ensure the gic irq is generated by hardware,
+	* and the current will be over shutdown temp.
+	*/
+	err = data->tz->ops->get_temp(data->tz, &current_temp);
+	if (err)
+		return err;
+	if (current_temp >= data->hw_shut_temp)
+			gpiod_direction_output(data->reset_gpio, 1);
+
+	return IRQ_HANDLED;
+}
+
+static int rockchip_thermal_get_temp(void *zone, long *out_temp)
+{
+	struct rockchip_thermal_data *data = zone;
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+	u32 val;
+
+	val = readl_relaxed(data->regs + TSADCV2_DATA1);
+	*out_temp = p_tsadc_data->code_to_temp(val);
+
+	/* I hope *out_temp=0 if the adc value hasn't getten */
+	if (*out_temp > data->hw_shut_temp)
+		*out_temp = 0;
+
+	/* Update alarm value to next higher trip point */
+	if (data->alarm_temp == data->temp_passive && *out_temp >=
+		data->temp_passive)
+		rockchip_set_alarm_temp(data, data->hw_shut_temp);
+
+	if (data->alarm_temp == data->temp_passive && *out_temp <
+		data->temp_passive) {
+		rockchip_set_alarm_temp(data, data->temp_passive);
+		dev_dbg(&data->tz->device, "thermal alarm off: T < %lu\n",
+			data->alarm_temp / 1000);
+	}
+
+	if (*out_temp != data->last_temp) {
+		dev_dbg(&data->tz->device, "millicelsius: %ld\n", *out_temp);
+		data->last_temp = *out_temp;
+	}
+
+	/* Reenable alarm IRQ if temperature below alarm temperature */
+	if (!data->irq_enabled && *out_temp < data->alarm_temp) {
+		data->irq_enabled = true;
+		enable_irq(data->irq);
+	}
+
+	return 0;
+}
+
+static int rockchip_configure_from_dt(struct device *dev,
+				      struct device_node *np,
+				      struct rockchip_thermal_data *data)
+{
+	int shut_temp, err, count;
+	unsigned long trip_temp;
+	enum thermal_trip_type tmp_str;
+
+	if (of_property_read_u32(np, "hw-shut-temp", &shut_temp)) {
+		dev_warn(dev, "Missing default shutdown temp property\n");
+		data->hw_shut_temp = data->pdata->hw_shut_temp;
+	} else {
+		data->hw_shut_temp = shut_temp;
+	}
+
+	data->reset_gpio = devm_gpiod_get(dev, "reset");
+	if (IS_ERR(data->reset_gpio)) {
+		err = PTR_ERR(data->reset_gpio);
+		if (err != -ENOENT) {
+			dev_err(dev, "failed to get reset_gpio: %d\n", err);
+			return err;
+		}
+		data->reset_gpio = NULL;
+	} else {
+		err = gpiod_direction_output(data->reset_gpio, 0);
+		if (err < 0) {
+			dev_err(dev, "failed to setup reset_gpio: %d\n", err);
+			return err;
+		}
+	}
+
+	for (count = 0; count < data->tz->trips; count++) {
+		err = data->tz->ops->get_trip_type(data->tz, count, &tmp_str);
+		if (err)
+			return err;
+		err = data->tz->ops->get_trip_temp(data->tz, count, &trip_temp);
+		if (err)
+			return err;
+
+		if (tmp_str == THERMAL_TRIP_PASSIVE)
+			data->temp_passive = trip_temp;
+		else if (tmp_str == THERMAL_TRIP_CRITICAL)
+			data->temp_critical = trip_temp;
+		else
+			dev_err(dev, "failed to get tripstemp.\n");
+			return err;
+	}
+
+	return 0;
+}
+
+static int rockchip_thermal_probe(struct platform_device *pdev)
+{
+	struct rockchip_thermal_data *data;
+	const struct rockchip_tsadc_platform_data *p_tsadc_data;
+	const struct of_device_id *match;
+
+	struct cpumask clip_cpus;
+	struct resource *res;
+	struct device_node *np = pdev->dev.of_node;
+
+	int ret, err;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(struct rockchip_thermal_data),
+			    GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	data->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(data->regs)) {
+		dev_err(&pdev->dev, "Could not get tsadc source, %p\n",
+			data->regs);
+		return PTR_ERR(data->regs);
+	}
+
+	match = of_match_node(of_rockchip_thermal_match, np);
+	if (!match)
+		return -ENXIO;
+	data->pdata = (const struct rockchip_tsadc_platform_data *)match->data;
+	if (!data->pdata)
+		return -EINVAL;
+	p_tsadc_data = data->pdata;
+
+	data->clk = devm_clk_get(&pdev->dev, "tsadc");
+	if (IS_ERR(data->clk)) {
+		dev_err(&pdev->dev, "failed to get tsadc clock\n");
+		return PTR_ERR(data->clk);
+	}
+
+	data->pclk = devm_clk_get(&pdev->dev, "apb_pclk");
+	if (IS_ERR(data->pclk)) {
+		dev_err(&pdev->dev, "failed to get tsadc pclk\n");
+		return PTR_ERR(data->pclk);
+	}
+
+	/**
+	 * Use a default of 10KHz for the converter clock.
+	 * This may become user-configurable in the future.
+	 */
+	ret = clk_set_rate(data->clk, 10000);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to set tsadc clk rate, %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(data->clk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to enable converter clock\n");
+		goto err_clk;
+	}
+
+	ret = clk_prepare_enable(data->pclk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to enable pclk\n");
+		goto err_pclk;
+	}
+
+	cpumask_set_cpu(0, &clip_cpus);
+	data->cdev = of_cpufreq_cooling_register(np, &clip_cpus);
+	if (IS_ERR(data->cdev)) {
+		dev_err(&pdev->dev, "failed to register cpufreq cooling device\n");
+	goto disable_clk;
+	}
+
+	data->tz = thermal_zone_of_sensor_register(
+						&pdev->dev, 0,
+						data, rockchip_thermal_get_temp,
+						NULL,
+						NULL);
+	if (IS_ERR(data->tz)) {
+		err = PTR_ERR(data->tz);
+		dev_err(&pdev->dev, "failed to register sensor: %d\n", err);
+		goto unregister_tzs;
+	}
+
+	ret = rockchip_configure_from_dt(&pdev->dev, np, data);
+	if (ret)
+		dev_err(&pdev->dev, "Parsing device tree data error.\n");
+
+	if (p_tsadc_data->irq_en) {
+		data->irq = platform_get_irq(pdev, 0);
+		if (data->irq < 0) {
+			dev_err(&pdev->dev, "no irq resource?\n");
+			goto disable_clk;
+		}
+
+		ret = devm_request_threaded_irq(&pdev->dev, data->irq,
+				NULL, &rockchip_thermal_alarm_irq_thread,
+				IRQF_ONESHOT, "rockchip_thermal",
+				data);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"failed to request tsadc irq: %d\n", ret);
+			goto unregister_tzs;
+		}
+	}
+	platform_set_drvdata(pdev, data);
+
+	rockchip_thermal_initialize(data);
+	rockchip_thermal_control(data, true);
+
+	return 0;
+
+unregister_tzs:
+	thermal_zone_of_sensor_unregister(&pdev->dev, data->tz);
+	cpufreq_cooling_unregister(data->cdev);
+
+disable_clk:
+err_pclk:
+	clk_disable_unprepare(data->pclk);
+err_clk:
+	clk_disable_unprepare(data->clk);
+
+	return ret;
+}
+
+static int rockchip_thermal_remove(struct platform_device *pdev)
+{
+	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
+
+	rockchip_thermal_control(data, false);
+
+	thermal_zone_device_unregister(data->tz);
+	cpufreq_cooling_unregister(data->cdev);
+
+	clk_disable_unprepare(data->clk);
+	clk_disable_unprepare(data->pclk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int rockchip_thermal_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
+
+	rockchip_thermal_control(data, false);
+
+	clk_disable_unprepare(data->clk);
+	clk_disable_unprepare(data->pclk);
+
+	return 0;
+}
+
+static int rockchip_thermal_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = clk_prepare_enable(data->pclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(data->clk);
+	if (ret)
+		return ret;
+
+	rockchip_thermal_initialize(data);
+	rockchip_thermal_control(data, true);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(rockchip_thermal_pm_ops,
+			 rockchip_thermal_suspend, rockchip_thermal_resume);
+
+static struct platform_driver rockchip_thermal_driver = {
+	.driver = {
+		   .name = "rockchip-thermal",
+		   .owner = THIS_MODULE,
+		   .pm = &rockchip_thermal_pm_ops,
+		   .of_match_table = of_rockchip_thermal_match,
+		   },
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


