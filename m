Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaHZXmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:42:52 -0400
Received: from regular1.263xmail.com ([211.150.99.138]:46376 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaHZXm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:42:26 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <1478d92d0951add5d5c478c9a677ebd8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        grant.likely@linaro.org
Cc: robh+dt@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, Caesar Wang <caesar.wang@rock-chips.com>,
        zhaoyifeng <zyf@rock-chips.com>
Subject: [PATCH v2 1/2] thermal: rockchip: add driver for thermal
Date: Wed, 27 Aug 2014 07:41:42 +0800
Message-Id: <1409096503-7081-2-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409096503-7081-1-git-send-email-caesar.wang@rock-chips.com>
References: <1409096503-7081-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thermal is TS-ADC Controller module supports user-defined mode and automatic mode.

User-defined mode refers,TSADC all the control signals entirely by software
writing to register for direct control.

Automaic mode refers to the module automatically poll TSADC output,and the results
Were checked.

If you find that the temperature High in a period of time, an interrupt is generated
to the processor down-measures taken;if the temperature over a period of time High,
the resulting TSHUT gave CRU module,let it reset the entire chip, or via GPIO give PMIC.

Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
Change-Id: I00e7df78c497704657aff16e602aa56b4c14c6f5
---
 drivers/thermal/Kconfig            |    9 +
 drivers/thermal/Makefile           |    1 +
 drivers/thermal/rockchip_thermal.c |  644 ++++++++++++++++++++++++++++++++++++
 3 files changed, 654 insertions(+)
 create mode 100644 drivers/thermal/rockchip_thermal.c

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 74226dc..43d2400 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -141,6 +141,15 @@ config SPEAR_THERMAL
 	  Enable this to plug the SPEAr thermal sensor driver into the Linux
 	  thermal framework.
 
+config ROCKCHIP_THERMAL
+	tristate "Rockchip thermal driver"
+	depends on ARCH_ROCKCHIP
+	help
+	  Support for Temperature Sensor ADC (TS-ADC) found on Rockchip SoCs.
+	  It supports one critical trip point and one passive trip point.  The
+	  cpufreq is used as the cooling device to throttle CPUs when the
+	  passive trip is crossed.
+
 config RCAR_THERMAL
 	tristate "Renesas R-Car thermal driver"
 	depends on ARCH_SHMOBILE || COMPILE_TEST
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 419c3cd..009a457 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -20,6 +20,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
 
 # platform thermal drivers
 obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
+obj-$(CONFIG_ROCKCHIP_THERMAL) 	+= rockchip_thermal.o
 obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
 obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
 obj-y				+= samsung/
diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
new file mode 100644
index 0000000..dea4dc3
--- /dev/null
+++ b/drivers/thermal/rockchip_thermal.c
@@ -0,0 +1,644 @@
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
+ *
+*/
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/cpu_cooling.h>
+#include "thermal_core.h"
+
+enum rockchip_thermal_trip {
+	ROCKCHIP_TRIP_PASSIVE,
+	ROCKCHIP_TRIP_CRITICAL,
+	ROCKCHIP_TRIP_NUM,
+};
+
+struct rockchip_thermal_data {
+	const struct rockchip_tsadc_platform_data *pdata;
+	struct thermal_zone_device *tz;
+	struct thermal_cooling_device *cdev;
+	enum thermal_device_mode mode;
+	void __iomem *regs;
+
+	signed long temp_passive;
+	signed long temp_critical;
+	signed long temp_force_shut;
+	signed long alarm_temp;
+	signed long last_temp;
+	bool irq_enabled;
+	int irq;
+	struct clk *tsadc_clk;
+	struct clk *tsadc_pclk;
+};
+
+struct rockchip_tsadc_platform_data {
+	u8 irq_en;
+	signed long temp_passive;
+	signed long temp_critical;
+	signed long temp_force_shut;
+	int passive_delay;
+	int polling_delay;
+
+	int (*irq_handle)(void __iomem *reg);
+	int (*initialize)(void __iomem *reg, signed long temp_force_shut);
+	int (*control)(void __iomem *reg, bool on);
+	u32 (*code_to_temp)(int temp);
+	u32 (*temp_to_code)(int temp);
+	void (*set_alarm_temp)(void __iomem *regs, signed long temp);
+};
+
+/*TSADC V2 Sensor info define:*/
+#define TSADCV2_AUTO_CON			0x04
+#define TSADCV2_INT_EN				0x08
+#define TSADCV2_INT_PD				0x0c
+#define TSADCV2_DATA1				0x24
+#define TSADCV2_COMP1_INT			0x34
+#define TSADCV2_COMP1_SHUT			0x44
+#define TSADCV2_AUTO_PERIOD			0x68
+#define TSADCV2_AUTO_PERIOD_HT			0x6c
+
+#define TSADCV2_AUTO_SRC1_EN			(1 << 5)
+#define TSADCV2_AUTO_EN				(1 << 0)
+#define TSADCV2_AUTO_DISABLE			~(1 << 0)
+#define TSADCV2_AUTO_STAS_BUSY			(1 << 16)
+#define TSADCV2_AUTO_STAS_BUSY_MASK		(1 << 16)
+#define TSADCV2_SHUT_2GPIO_SRC1_EN		(1 << 5)
+#define TSADCV2_INT_SRC1_EN			(1 << 1)
+#define TSADCV2_SHUT_SRC1_STATUS		(1 << 5)
+#define TSADCV2_INT_SRC1_STATUS			(1 << 1)
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
+	int code;
+	int temp;
+};
+
+static const struct tsadc_table v2_code_table[] = {
+	{TSADCV2_DATA_MASK, -40},
+	{3800, -40},
+	{3792, -35},
+	{3783, -30},
+	{3774, -25},
+	{3765, -20},
+	{3756, -15},
+	{3747, -10},
+	{3737, -5},
+	{3728, 0},
+	{3718, 5},
+	{3708, 10},
+	{3698, 15},
+	{3688, 20},
+	{3678, 25},
+	{3667, 30},
+	{3656, 35},
+	{3645, 40},
+	{3634, 45},
+	{3623, 50},
+	{3611, 55},
+	{3600, 60},
+	{3588, 65},
+	{3575, 70},
+	{3563, 75},
+	{3550, 80},
+	{3537, 85},
+	{3524, 90},
+	{3510, 95},
+	{3496, 100},
+	{3482, 105},
+	{3467, 110},
+	{3452, 115},
+	{3437, 120},
+	{3421, 125},
+	{0, 125},
+};
+
+static int rk_tsadcv2_irq_handle(void __iomem *regs)
+{
+	u32 val;
+
+	val = readl_relaxed(regs + TSADCV2_INT_PD);
+	writel_relaxed(val & ~(1 << 8), regs + TSADCV2_INT_PD);
+
+	return 0;
+}
+
+static u32 rk_tsadcv2_temp_to_code(int temp)
+{
+	u32 code = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(v2_code_table) - 1; i++) {
+		if (temp <= v2_code_table[i].temp && temp >
+		    v2_code_table[i - 1].temp)
+			code = v2_code_table[i].code;
+	}
+	return code;
+}
+
+static u32 rk_tsadcv2_code_to_temp(int code)
+{
+	u32 temp = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(v2_code_table) - 1; i++) {
+		if (code <= v2_code_table[i].code && code >
+		    v2_code_table[i + 1].code)
+			temp = v2_code_table[i].temp;
+	}
+	return temp;
+}
+
+static int rk_tsadcv2_initialize(void __iomem *regs,
+				 signed long temp_force_shut)
+{
+	int shutdown_value;
+
+	shutdown_value = rk_tsadcv2_temp_to_code(temp_force_shut);
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
+	return 0;
+}
+
+static void rk_tsadcv2_alarm_temp(void __iomem *regs, signed long alarm_temp)
+{
+	int alarm_value;
+
+	alarm_value = rk_tsadcv2_temp_to_code(alarm_temp);
+	writel_relaxed(alarm_value, regs + TSADCV2_COMP1_INT);
+}
+
+struct rockchip_tsadc_platform_data const rk3288_tsadc_data = {
+	.irq_en = 1,
+	.temp_passive = 85000,
+	.temp_critical = 100000,
+	.temp_force_shut = 120000,
+	.passive_delay = 2000,
+	.polling_delay = 1000,
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
+				    signed long alarm_temp)
+{
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+
+	data->alarm_temp = alarm_temp;
+	if (p_tsadc_data->set_alarm_temp)
+		p_tsadc_data->set_alarm_temp(data->regs, alarm_temp);
+}
+
+static int rockchip_get_temp(struct thermal_zone_device *tz,
+			     unsigned long *temp)
+{
+	struct rockchip_thermal_data *data = tz->devdata;
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+	u32 val;
+
+	val = readl_relaxed(data->regs + TSADCV2_DATA1);
+	*temp = p_tsadc_data->code_to_temp(val);
+
+	/* Update alarm value to next higher trip point */
+	if (data->alarm_temp == data->temp_passive && *temp >=
+	    data->temp_passive)
+		rockchip_set_alarm_temp(data, data->temp_critical);
+
+	if (data->alarm_temp == data->temp_critical && *temp <
+	    data->temp_passive) {
+		rockchip_set_alarm_temp(data, data->temp_passive);
+		dev_dbg(&tz->device, "thermal alarm off: T < %lu\n",
+			data->alarm_temp / 1000);
+	}
+
+	if (*temp != data->last_temp) {
+		dev_dbg(&tz->device, "millicelsius: %ld\n", *temp);
+		data->last_temp = *temp;
+	}
+
+	/* Reenable alarm IRQ if temperature below alarm temperature */
+	if (!data->irq_enabled && *temp < data->alarm_temp) {
+		data->irq_enabled = true;
+		enable_irq(data->irq);
+	}
+	return 0;
+}
+
+static int rockchip_thermal_initialize(struct rockchip_thermal_data *data)
+{
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+
+	if (p_tsadc_data->initialize)
+		p_tsadc_data->initialize(data->regs, data->temp_force_shut);
+	rockchip_set_alarm_temp(data, data->temp_passive);
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
+		data->mode = THERMAL_DEVICE_ENABLED;
+	} else {
+		data->irq_enabled = false;
+		data->mode = THERMAL_DEVICE_DISABLED;
+	}
+}
+
+static int rockchip_get_mode(struct thermal_zone_device *tz,
+			     enum thermal_device_mode *mode)
+{
+	struct rockchip_thermal_data *data = tz->devdata;
+
+	*mode = data->mode;
+	return 0;
+}
+
+static int rockchip_set_mode(struct thermal_zone_device *tz,
+			     enum thermal_device_mode mode)
+{
+	struct rockchip_thermal_data *data = tz->devdata;
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+
+	if (mode == THERMAL_DEVICE_ENABLED) {
+		tz->polling_delay = p_tsadc_data->polling_delay;
+		tz->passive_delay = p_tsadc_data->passive_delay;
+		rockchip_thermal_control(data, true);
+		if (!data->irq_enabled) {
+			data->irq_enabled = true;
+			enable_irq(data->irq);
+		}
+	} else {
+		rockchip_thermal_control(data, false);
+		tz->polling_delay = 0;
+		tz->passive_delay = 0;
+		if (data->irq_enabled) {
+			disable_irq(data->irq);
+			data->irq_enabled = false;
+		}
+	}
+
+	data->mode = mode;
+	thermal_zone_device_update(tz);
+	return 0;
+}
+
+static int rockchip_get_trip_type(struct thermal_zone_device *tz, int trip,
+				  enum thermal_trip_type *type)
+{
+	*type = (trip == ROCKCHIP_TRIP_PASSIVE) ? THERMAL_TRIP_PASSIVE :
+		 THERMAL_TRIP_CRITICAL;
+	return 0;
+}
+
+static int rockchip_get_crit_temp(struct thermal_zone_device *tz,
+				  unsigned long *temp)
+{
+	struct rockchip_thermal_data *data = tz->devdata;
+
+	*temp = data->temp_critical;
+	return 0;
+}
+
+static int rockchip_get_trip_temp(struct thermal_zone_device *tz, int trip,
+				  unsigned long *temp)
+{
+	struct rockchip_thermal_data *data = tz->devdata;
+
+	*temp = (trip == ROCKCHIP_TRIP_PASSIVE) ? data->temp_passive :
+		 data->temp_critical;
+	return 0;
+}
+
+static int rockchip_set_trip_temp(struct thermal_zone_device *tz, int trip,
+				  unsigned long temp)
+{
+	struct rockchip_thermal_data *data = tz->devdata;
+
+	if (trip == ROCKCHIP_TRIP_CRITICAL)
+		return -EPERM;
+
+	data->temp_passive = temp;
+	rockchip_set_alarm_temp(data, temp);
+	return 0;
+}
+
+static int rockchip_bind(struct thermal_zone_device *tz,
+			 struct thermal_cooling_device *cdev)
+{
+	int ret;
+
+	ret = thermal_zone_bind_cooling_device(tz, ROCKCHIP_TRIP_PASSIVE, cdev,
+					       THERMAL_NO_LIMIT,
+					       THERMAL_NO_LIMIT);
+	if (ret) {
+		dev_err(&tz->device, "binding zone %s with cdev %s failed:%d\n",
+			tz->type, cdev->type, ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int rockchip_unbind(struct thermal_zone_device *tz,
+			   struct thermal_cooling_device *cdev)
+{
+	int ret;
+
+	ret = thermal_zone_unbind_cooling_device(tz,
+						 ROCKCHIP_TRIP_PASSIVE, cdev);
+	if (ret) {
+		dev_err(&tz->device,
+			"unbinding zone %s with cdev %s failed:%d\n", tz->type,
+			cdev->type, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct thermal_zone_device_ops rockchip_tz_ops = {
+	.bind = rockchip_bind,
+	.unbind = rockchip_unbind,
+	.get_temp = rockchip_get_temp,
+	.get_mode = rockchip_get_mode,
+	.set_mode = rockchip_set_mode,
+	.get_trip_type = rockchip_get_trip_type,
+	.get_trip_temp = rockchip_get_trip_temp,
+	.get_crit_temp = rockchip_get_crit_temp,
+	.set_trip_temp = rockchip_set_trip_temp,
+};
+
+static irqreturn_t rockchip_thermal_alarm_irq(int irq, void *dev)
+{
+	struct rockchip_thermal_data *data = dev;
+
+	disable_irq_nosync(irq);
+	data->irq_enabled = false;
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
+{
+	struct rockchip_thermal_data *data = data;
+	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
+
+	dev_dbg(&data->tz->device, "THERMAL ALARM: T > %lu\n",
+		data->alarm_temp / 1000);
+
+	if (p_tsadc_data->irq_en && p_tsadc_data->irq_handle)
+		p_tsadc_data->irq_handle(data->regs);
+
+	thermal_zone_device_update(data->tz);
+
+	return IRQ_HANDLED;
+}
+
+static int rockchip_thermal_probe(struct platform_device *pdev)
+{
+	struct rockchip_thermal_data *data;
+	const struct rockchip_tsadc_platform_data *p_tsadc_data;
+	struct cpumask clip_cpus;
+	struct resource *res;
+	const struct of_device_id *match;
+	int ret, temp;
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
+	match = of_match_node(of_rockchip_thermal_match, pdev->dev.of_node);
+	if (!match)
+		return -ENXIO;
+	data->pdata = (const struct rockchip_tsadc_platform_data *)match->data;
+	if (!data->pdata)
+		return -EINVAL;
+	p_tsadc_data = data->pdata;
+
+	data->tsadc_clk = devm_clk_get(&pdev->dev, "tsadc_clk");
+	if (IS_ERR(data->tsadc_clk)) {
+		dev_err(&pdev->dev, "failed to get tsadc clock\n");
+		return PTR_ERR(data->tsadc_clk);
+	}
+	ret = clk_prepare_enable(data->tsadc_clk);
+	if (ret)
+		return ret;
+
+	data->tsadc_pclk = devm_clk_get(&pdev->dev, "tsadc_pclk");
+	if (IS_ERR(data->tsadc_pclk)) {
+		dev_err(&pdev->dev, "failed to get tsadc pclk\n");
+		return PTR_ERR(data->tsadc_pclk);
+	}
+	ret = clk_prepare_enable(data->tsadc_pclk);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, data);
+
+	if (of_property_read_u32(pdev->dev.of_node, "passive-temp", &temp)) {
+		dev_warn(&pdev->dev,
+			 "Missing default passive temp property in the DT.\n");
+		data->temp_passive = p_tsadc_data->temp_passive;
+	} else {
+		data->temp_passive = temp;
+	}
+
+	if (of_property_read_u32(pdev->dev.of_node, "critical-temp", &temp)) {
+		dev_warn(&pdev->dev,
+			 "Missing default critical temp property in the DT.\n");
+		data->temp_critical = p_tsadc_data->temp_critical;
+	} else {
+		data->temp_critical = temp;
+	}
+
+	if (of_property_read_u32(pdev->dev.of_node, "force-shut-temp", &temp)) {
+		dev_warn(&pdev->dev,
+			 "Missing default force shut down temp property in the DT.\n");
+		data->temp_force_shut = p_tsadc_data->temp_force_shut;
+	} else {
+		data->temp_force_shut = temp;
+	}
+
+	cpumask_set_cpu(0, &clip_cpus);
+	data->cdev = of_cpufreq_cooling_register(pdev->dev.of_node, &clip_cpus);
+	if (IS_ERR(data->cdev)) {
+		ret = PTR_ERR(data->cdev);
+		dev_err(&pdev->dev,
+			"failed to register cpufreq cooling device: %d\n", ret);
+		return ret;
+	}
+
+	data->tz = thermal_zone_device_register("rockchip_thermal",
+						ROCKCHIP_TRIP_NUM,
+						0, data,
+						&rockchip_tz_ops, NULL,
+						p_tsadc_data->passive_delay,
+						p_tsadc_data->polling_delay);
+
+	if (IS_ERR(data->tz)) {
+		ret = PTR_ERR(data->tz);
+		dev_err(&pdev->dev,
+			"failed to register thermal zone device %d\n", ret);
+		cpufreq_cooling_unregister(data->cdev);
+		return ret;
+	}
+
+	if (p_tsadc_data->irq_en) {
+		data->irq = platform_get_irq(pdev, 0);
+		if (data->irq < 0)
+			return data->irq;
+
+		ret = devm_request_threaded_irq(&pdev->dev, data->irq,
+						rockchip_thermal_alarm_irq,
+					rockchip_thermal_alarm_irq_thread,
+						0, "rockchip_thermal", data);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"failed to request tsadc irq: %d\n", ret);
+			return ret;
+		}
+	}
+
+	rockchip_thermal_initialize(data);
+	rockchip_thermal_control(data, true);
+	return 0;
+}
+
+static int rockchip_thermal_remove(struct platform_device *pdev)
+{
+	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
+
+	rockchip_thermal_control(data, false);
+
+	thermal_zone_device_unregister(data->tz);
+
+	if (!IS_ERR(data->tsadc_clk))
+		clk_disable_unprepare(data->tsadc_clk);
+
+	if (!IS_ERR(data->tsadc_pclk))
+		clk_disable_unprepare(data->tsadc_pclk);
+
+	cpufreq_cooling_unregister(data->cdev);
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
+	return 0;
+}
+
+static int rockchip_thermal_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
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
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rockchip-thermal");
-- 
1.7.9.5


