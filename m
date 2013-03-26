Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab3CZLe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:34:57 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:33894 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab3CZLey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:34:54 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 7/9] thermal: exynos: Add support for exynos5440 TMU sensor.
Date: Tue, 26 Mar 2013 17:04:00 +0530
Message-Id: <1364297642-2746-8-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1364297642-2746-1-git-send-email-amit.daniel@samsung.com>
References: <1364297642-2746-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sensor registers 3 instance of the tmu controller with the thermal zone
and hence reports 3 temperature output. This driver supports upto five trip
points. For critical threshold the driver uses the core driver thermal
framework for shutdown and for non-critical threshold it invokes the hw based
frequency clipping limits. Because of such differences with the existing 4210
tmu controller, exynos5440 tmu driver is added in a new file.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/Kconfig              |    9 +
 drivers/thermal/samsung/Makefile             |    1 +
 drivers/thermal/samsung/exynos5440_thermal.c |  713 ++++++++++++++++++++++++++
 3 files changed, 723 insertions(+), 0 deletions(-)
 create mode 100644 drivers/thermal/samsung/exynos5440_thermal.c

diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
index cefe693..0c7b4eb 100644
--- a/drivers/thermal/samsung/Kconfig
+++ b/drivers/thermal/samsung/Kconfig
@@ -20,4 +20,13 @@ config EXYNOS4210_THERMAL
 	  initialises the TMU controller and registers/unregisters with exynos
 	  common thermal layer.
 
+config EXYNOS5440_THERMAL
+	tristate "Temperature sensor on Samsung EXYNOS 5440 SOC"
+	depends on SOC_EXYNOS5440
+	help
+	  If you say yes here you can enable TMU (Thermal Management Unit)
+	  support on SAMSUNG EXYNOS 5440 series of SoC. This option initialises
+	  the TMU controller and registers/unregisters with exynos common
+	  thermal layer.
+
 endif
diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
index d51d0c2..53230cf 100644
--- a/drivers/thermal/samsung/Makefile
+++ b/drivers/thermal/samsung/Makefile
@@ -3,3 +3,4 @@
 #
 obj-$(CONFIG_EXYNOS_COMMON)		+= exynos_common.o
 obj-$(CONFIG_EXYNOS4210_THERMAL)	+= exynos4210_thermal.o
+obj-$(CONFIG_EXYNOS5440_THERMAL)		+= exynos5440_thermal.o
diff --git a/drivers/thermal/samsung/exynos5440_thermal.c b/drivers/thermal/samsung/exynos5440_thermal.c
new file mode 100644
index 0000000..a3c75d3
--- /dev/null
+++ b/drivers/thermal/samsung/exynos5440_thermal.c
@@ -0,0 +1,713 @@
+/*
+ * exynos5440_thermal.c - Samsung EXYNOS 5440 TMU
+ * (Thermal Management Unit)
+ *
+ *  Copyright (C) 2013 Samsung Electronics
+ *  Amit Daniel Kachhap <amit.daniel@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
+#include <linux/cpu_cooling.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/thermal.h>
+#include <linux/workqueue.h>
+#include <linux/platform_data/exynos_thermal.h>
+
+#include "exynos_common.h"
+
+
+/* Exynos5440 specific registers */
+#define TMU_S0_7_TRIM			0x0118
+#define TMU_S0_7_CTRL			0x0138
+#define TMU_S0_7_DEBUG			0x0158
+#define TMU_S0_7_STATUS			0x0178
+#define TMU_S0_7_COUNTER0		0x0198
+#define TMU_S0_7_COUNTER1		0x01b8
+#define TMU_S0_7_COUNTER2		0x01d8
+#define TMU_S0_7_COUNTER3		0x01f8
+#define TMU_S0_7_TEMP			0x0208
+#define TMU_S0_7_TH0			0x0228
+#define TMU_S0_7_TH1			0x0248
+#define TMU_S0_7_TH2			0x0268
+#define TMU_S0_7_PTEMP0			0x0288
+#define TMU_S0_7_PTEMP1			0x02a8
+#define TMU_S0_7_PTEMP2			0x02c8
+#define TMU_S0_7_PTEMP3			0x02e8
+#define TMU_S0_7_EVTEN			0x0308
+#define TMU_S0_7_IRQEN			0x0328
+#define TMU_S0_7_IRQ			0x0348
+#define TMU_IRQ_STATUS			0x0368
+#define TMU_PMIN			0x036c
+#define TMU_TEMP			0x0370
+#define TMU_MISC			0x0374
+
+/* Exynos5440 specific mask and shifts */
+#define TMU_TEMP_MASK			0xff
+
+#define TMU_TRIM_DATA_25C_SHIFT		0x0
+#define TMU_TRIM_DATA_85C_SHIFT		0x8
+
+#define TMU_BUF_VREF_SEL_MASK		0x1f
+#define TMU_BUF_VREF_SEL_SHIFT		24
+#define TMU_THERM_TRIP_MODE_MASK	0x7
+#define TMU_THERM_TRIP_MODE_SHIFT	13
+#define TMU_THERM_TRIP_EN_SHIFT		12
+#define TMU_BUF_SLOPE_SEL_MASK		0Xf
+#define TMU_BUF_SLOPE_SEL_SHIFT		8
+#define TMU_THERM_IRQ_MODE_SHIFT	7
+#define TMU_CALIB_MODE_MASK		0x3
+#define TMU_CALIB_MODE_SHIFT		4
+#define TMU_FILTER_MODE_MASK		0x7
+#define TMU_FILTER_MODE_SHIFT		1
+#define TMU_SENSOR_EN_SHIFT		0
+#define TMU_SENSOR_ENABLE		0x1
+
+#define TMU_EMU_EN_SHIFT		0
+#define TMU_TEMP_EMU_SHIFT		8
+#define TMU_EMUL_ENABLE			1
+
+#define	TMU_STATUS_IDLE_SHIFT		0
+
+#define TMU_TIME_MASK			0xffff
+#define TMU_TIME_OF_SHIFT		16
+#define TMU_TIME_ON_SHIFT		0
+
+#define TMU_CURRENT_TEMP_SHIFT		0
+#define TMU_FILTERED_TEMP_SHIFT		8
+#define TMU_RAW_TEMP_SHIFT		16
+#define TMU_TEMP_SEQNUM			24
+
+#define TMU_THRES_RISE0_SHIFT		0
+#define TMU_THRES_RISE1_SHIFT		8
+#define TMU_THRES_RISE2_SHIFT		16
+#define TMU_THRES_RISE3_SHIFT		24
+
+#define TMU_THRES_FALL0_SHIFT		0
+#define TMU_THRES_FALL1_SHIFT		8
+#define TMU_THRES_FALL2_SHIFT		16
+#define TMU_THRES_FALL3_SHIFT		24
+
+#define TMU_THRES_RISE4_SHIFT		24
+
+#define TMU_RISE_EVTEN_MASK		0xf
+#define TMU_RISE_EVTEN_SHIFT		0
+#define TMU_FALL_EVTEN_MASK		0xf
+#define TMU_FALL_EVTEN_SHIFT		4
+
+#define TMU_RISE_IRQEN_MASK		0xf
+#define TMU_RISE_IRQEN_SHIFT		0
+#define TMU_FALL_IRQEN_MASK		0xf
+#define TMU_FALL_IRQEN_SHIFT		4
+#define TMU_CLEAR_RISE_INT		TMU_RISE_IRQEN_MASK
+#define TMU_CLEAR_FALL_INT		(TMU_FALL_IRQEN_MASK << 4)
+
+#define TMU_PMIN_MASK			0x7
+#define TMU_PMIN0_SHIFT			0
+#define TMU_PMIN1_SHIFT			4
+#define TMU_PMIN2_SHIFT			8
+#define TMU_PMIN3_SHIFT			12
+#define TMU_PMIN_SHIFT(x)		(4 * x)
+#define TMU_TPMIN_SHIFT			16
+
+#define	TMU_TEMP_MAX_SHIFT		0
+#define TMU_MAX_RISE_LEVEL		4
+#define TMU_MAX_FALL_LEVEL		4
+#define TMU_MAX_SENSOR			8
+
+#define TMU_DEF_CODE_TO_TEMP_OFFSET	20
+
+struct exynos_tmu_data {
+	int irq;
+	int id;
+	unsigned int shift;
+	enum soc_type soc;
+	void __iomem *base;
+	struct clk *clk;
+	struct work_struct irq_work;
+	u8 temp_error1, temp_error2;
+	struct mutex lock;
+	struct thermal_sensor_conf *reg_conf;
+	struct exynos_tmu_platform_data *pdata;
+};
+
+struct exynos_tmu_common {
+	int level[TMU_MAX_SENSOR];
+	int sensor_count;
+};
+static struct exynos_tmu_common tmu_common;
+/*
+ * TMU treats temperature as a mapped temperature code.
+ * The temperature is converted differently depending on the calibration type.
+ */
+static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
+{
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	int temp_code;
+
+	if (pdata->cal_mode == HW_MODE)
+		return temp;
+
+	switch (pdata->cal_type) {
+	case TYPE_TWO_POINT_TRIMMING:
+		temp_code = (temp - 25) *
+		    (data->temp_error2 - data->temp_error1) /
+		    (70 - 25) + data->temp_error1;
+		break;
+	case TYPE_ONE_POINT_TRIMMING:
+		temp_code = temp + data->temp_error1 - 25;
+		break;
+	default:
+		temp_code = temp + TMU_DEF_CODE_TO_TEMP_OFFSET;
+		break;
+	}
+
+	return temp_code;
+}
+
+/*
+ * Calculate a temperature value from a temperature code.
+ * The unit of the temperature is degree Celsius.
+ */
+static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
+{
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	int temp;
+
+	if (pdata->cal_mode == HW_MODE)
+		return temp_code;
+
+	switch (pdata->cal_type) {
+	case TYPE_TWO_POINT_TRIMMING:
+		temp = (temp_code - data->temp_error1) * (70 - 25) /
+		    (data->temp_error2 - data->temp_error1) + 25;
+		break;
+	case TYPE_ONE_POINT_TRIMMING:
+		temp = temp_code - data->temp_error1 + 25;
+		break;
+	default:
+		temp = temp_code - TMU_DEF_CODE_TO_TEMP_OFFSET;
+		break;
+	}
+
+	return temp;
+}
+
+static int exynos_tmu_initialize(struct platform_device *pdev)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	unsigned int status, con, trim_info;
+	unsigned int rising_threshold = 0, falling_threshold = 0;
+	int ret = 0, threshold_code, i, trigger_levs = 0;
+
+	status = readl(data->base + data->shift + TMU_S0_7_STATUS);
+	status &= 0x1;
+	if (!status)
+		dev_err(&pdev->dev, "Sensor Initial status is busy\n");
+
+	if (pdata->cal_mode == HW_MODE)
+		goto skip_calib_data;
+
+	/* Save trimming info in order to perform calibration */
+	trim_info = readl(data->base + data->shift + TMU_S0_7_TRIM);
+	data->temp_error1 = trim_info & TMU_TEMP_MASK;
+	data->temp_error2 = ((trim_info >> 8) & TMU_TEMP_MASK);
+	if (!data->temp_error1)
+		data->temp_error1 = pdata->efuse_value & TMU_TEMP_MASK;
+	if (!data->temp_error2)
+		data->temp_error2 = (pdata->efuse_value >> 8) & TMU_TEMP_MASK;
+
+skip_calib_data:
+	/* Count trigger levels to be enabled */
+	for (i = 0; i < MAX_THRESHOLD_LEVS; i++)
+		if (pdata->trigger_levels[i])
+			trigger_levs++;
+
+	/* Write temperature code for rising and falling threshold */
+	for (i = 0; (i < trigger_levs && i < TMU_MAX_RISE_LEVEL); i++) {
+		threshold_code = temp_to_code(data,
+					pdata->trigger_levels[i]);
+		if (threshold_code < 0) {
+			ret = threshold_code;
+			dev_err(&pdev->dev, "Invalid threshold=%d level=%d\n",
+							threshold_code, i);
+			goto out;
+		}
+		rising_threshold |= threshold_code << 8 * i;
+		if (pdata->threshold_falling) {
+			threshold_code = temp_to_code(data,
+					pdata->trigger_levels[i] -
+					pdata->threshold_falling);
+			if (threshold_code > 0)
+				falling_threshold |=
+					threshold_code << 8 * i;
+		}
+	}
+	writel(rising_threshold,
+			data->base + data->shift + TMU_S0_7_TH0);
+	writel(falling_threshold,
+			data->base + data->shift + TMU_S0_7_TH1);
+
+	/* if 5th threshold limit is also present */
+	if (i == TMU_MAX_RISE_LEVEL) {
+		threshold_code = temp_to_code(data,
+					pdata->trigger_levels[i]);
+		if (threshold_code < 0) {
+			ret = threshold_code;
+			dev_err(&pdev->dev, "Invalid threshold=%d level=%d\n",
+							threshold_code, i);
+			goto out;
+		}
+		rising_threshold = threshold_code << TMU_THRES_RISE4_SHIFT;
+		writel(rising_threshold,
+			data->base + data->shift + TMU_S0_7_TH2);
+		con = readl(data->base + data->shift + TMU_S0_7_CTRL);
+		con |= (1 << TMU_THERM_TRIP_EN_SHIFT);
+		writel(con, data->base + data->shift + TMU_S0_7_CTRL);
+	}
+
+	writel(TMU_CLEAR_RISE_INT | TMU_CLEAR_FALL_INT,
+			data->base + data->shift + TMU_S0_7_IRQ);
+
+	/* clear all PMIN */
+	writel(0, data->base + TMU_PMIN);
+out:
+	return ret;
+}
+
+static void exynos_tmu_control(struct platform_device *pdev, bool on)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	unsigned int con, interrupt_en;
+
+	mutex_lock(&data->lock);
+	con = readl(data->base + data->shift + TMU_S0_7_CTRL);
+	con &= ~(TMU_BUF_VREF_SEL_MASK << TMU_BUF_VREF_SEL_SHIFT |
+		TMU_THERM_TRIP_MODE_MASK << TMU_THERM_TRIP_MODE_SHIFT |
+		TMU_BUF_SLOPE_SEL_MASK << TMU_BUF_SLOPE_SEL_SHIFT |
+		TMU_CALIB_MODE_MASK << TMU_CALIB_MODE_SHIFT |
+		TMU_FILTER_MODE_MASK << TMU_FILTER_MODE_SHIFT |
+		TMU_SENSOR_ENABLE << TMU_SENSOR_EN_SHIFT);
+
+	con |= pdata->reference_voltage << TMU_BUF_VREF_SEL_SHIFT |
+		pdata->gain << TMU_BUF_SLOPE_SEL_SHIFT;
+
+	if (pdata->cal_mode == HW_MODE)
+		con |= pdata->cal_type << TMU_CALIB_MODE_SHIFT;
+
+	con |= pdata->noise_cancel_mode << TMU_THERM_TRIP_MODE_SHIFT;
+
+	if (on) {
+		con |= TMU_SENSOR_ENABLE;
+		interrupt_en =
+			pdata->trigger_enable[3] << 3 |
+			pdata->trigger_enable[2] << 2 |
+			pdata->trigger_enable[1] << 1 |
+			pdata->trigger_enable[0] << 0;
+		if (pdata->threshold_falling)
+			interrupt_en |= interrupt_en << TMU_FALL_IRQEN_SHIFT;
+	} else {
+		interrupt_en = 0; /* Disable all interrupts */
+	}
+	writel(interrupt_en, data->base + data->shift + TMU_S0_7_IRQEN);
+	writel(interrupt_en, data->base + data->shift + TMU_S0_7_EVTEN);
+	writel(con, data->base + data->shift + TMU_S0_7_CTRL);
+
+	mutex_unlock(&data->lock);
+}
+
+static int exynos_tmu_read(struct exynos_tmu_data *data)
+{
+	u8 temp_code;
+	int temp;
+
+	mutex_lock(&data->lock);
+
+	temp_code = readl(data->base + data->shift + TMU_S0_7_TEMP);
+	temp_code >>= TMU_CURRENT_TEMP_SHIFT;
+	temp_code &= TMU_TEMP_MASK;
+	temp = code_to_temp(data, temp_code);
+
+	mutex_unlock(&data->lock);
+
+	return temp;
+}
+
+#ifdef CONFIG_THERMAL_EMULATION
+static int exynos_tmu_set_emulation(struct exynos_tmu_data *data,
+					unsigned long temp)
+{
+	unsigned int reg;
+
+	if (temp && temp < MCELSIUS)
+		goto out;
+
+	mutex_lock(&data->lock);
+	reg = readl(data->base + data->shift + TMU_S0_7_DEBUG);
+
+	if (temp) {
+		temp /= MCELSIUS;
+		reg &= ~(TMU_TEMP_MASK << TMU_TEMP_EMU_SHIFT);
+		reg |= (temp_to_code(data, temp) << TMU_TEMP_EMU_SHIFT) |
+			TMU_EMUL_ENABLE;
+	} else {
+		reg &= ~TMU_EMUL_ENABLE;
+	}
+
+	writel(reg, data->base + data->shift + TMU_S0_7_DEBUG);
+	mutex_unlock(&data->lock);
+	return 0;
+out:
+	return -EINVAL;
+}
+#endif
+
+static void exynos_tmu_set_cooling(struct exynos_tmu_data *data, int level,
+				unsigned int cur_temp)
+{
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	bool check_rise, change;
+	unsigned int thres_temp, freq = 0, val;
+	int i, index, max_level = 0;
+
+	/* Get the max level across all sensors except this */
+	for (i = 0; i < tmu_common.sensor_count; i++) {
+		if (i == data->id)
+			continue;
+		if (tmu_common.level[i] > max_level)
+			max_level = tmu_common.level[i];
+	}
+	change = false;
+	if (level < TMU_MAX_RISE_LEVEL) {
+		thres_temp = readl(data->base + data->shift + TMU_S0_7_TH0);
+		thres_temp = (thres_temp >> (level * 8) & TMU_TEMP_MASK);
+		check_rise = true;
+		tmu_common.level[data->id] = level + 1;
+		if (tmu_common.level[data->id] > max_level)
+			change = true;
+	} else {
+		level -= TMU_MAX_RISE_LEVEL;
+		thres_temp = readl(data->base + data->shift + TMU_S0_7_TH1);
+		thres_temp = (thres_temp >> (level * 8) & TMU_TEMP_MASK);
+		check_rise = false;
+		tmu_common.level[data->id] = level;
+		if (tmu_common.level[data->id] >= max_level)
+			change = true;
+	}
+
+	if (change == false)
+		return;
+
+	thres_temp = code_to_temp(data, thres_temp);
+	if (!check_rise)
+		thres_temp += pdata->threshold_falling;
+
+	change = false;
+	/* find this threshold temp in the patform table cooling data */
+	for (i = 0; i < pdata->freq_tab_count; i++) {
+		if (thres_temp != pdata->freq_tab[i].temp_level)
+			continue;
+
+		if (check_rise && cur_temp >= thres_temp) {
+			freq = pdata->freq_tab[i].freq_clip_max;
+			change = true;
+		}
+		if (!check_rise &&
+		(cur_temp <= (thres_temp - pdata->threshold_falling))) {
+			change = true;
+			freq = 0;
+		}
+	}
+
+	/* critical threshold temp */
+	if (thres_temp ==  pdata->trigger_levels[TMU_MAX_RISE_LEVEL - 1])
+		exynos_report_trigger(data->reg_conf);
+
+	if (change == false)
+		return;
+
+	index = 0;
+
+	if (freq) {
+		index = exynos_get_frequency_level(0, freq);
+		if (index < 0)
+			return;
+	}
+
+	val = readl(data->base + TMU_PMIN);
+	val &= (~(TMU_PMIN_MASK << TMU_PMIN_SHIFT(level)));
+	val |= (index << TMU_PMIN_SHIFT(level));
+	writel(val, data->base + TMU_PMIN);
+}
+
+static void exynos_tmu_work(struct work_struct *work)
+{
+	struct exynos_tmu_data *data = container_of(work,
+				struct exynos_tmu_data, irq_work);
+	int i, cur_temp;
+	unsigned int val_type, val_irq;
+
+	if (!data)
+		goto out;
+
+	val_type = readl(data->base + TMU_IRQ_STATUS);
+
+	/* Find which sensor generated this interrupt */
+	if (!((val_type >> data->id) & 0x1))
+		goto out;
+
+	cur_temp = exynos_tmu_read(data);
+	val_irq = readl(data->base + data->shift + TMU_S0_7_IRQ);
+	for (i = 0; i < (TMU_MAX_RISE_LEVEL + TMU_MAX_FALL_LEVEL); i++) {
+		if (!((val_irq >> i) & 0x1))
+			continue;
+		exynos_tmu_set_cooling(data, i, cur_temp);
+	}
+	/* clear the interrupts */
+	writel(val_irq, data->base + data->shift + TMU_S0_7_IRQ);
+out:
+	enable_irq(data->irq);
+}
+
+static irqreturn_t exynos_tmu_irq(int irq, void *id)
+{
+	struct exynos_tmu_data *data = id;
+
+	disable_irq_nosync(irq);
+	schedule_work(&data->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static const struct of_device_id exynos_tmu_match[] = {
+	{
+		.compatible = "samsung,exynos5440-tmu",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_tmu_match);
+
+int exynos_map_dt_data(struct platform_device *pdev)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct resource res;
+
+	if (!data)
+		return -ENODEV;
+
+	data->id = of_alias_get_id(pdev->dev.of_node, "tmuctrl");
+	if (data->id < 0)
+		data->id = 0;
+
+	data->shift = data->id * 4;
+
+	data->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	if (data->irq <= 0) {
+		dev_err(&pdev->dev, "failed to get IRQ\n");
+		return -ENODEV;
+	}
+
+	if (of_address_to_resource(pdev->dev.of_node, 0, &res)) {
+		dev_err(&pdev->dev, "failed to get Resource\n");
+		return -ENODEV;
+	}
+
+	/* clear the last 16 bytes */
+	res.start &= (~(0xFFFF));
+	data->base = devm_ioremap(&pdev->dev, res.start, resource_size(&res));
+	if (!data->base) {
+		dev_err(&pdev->dev, "Failed to ioremap memory\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int exynos_tmu_probe(struct platform_device *pdev)
+{
+	struct exynos_tmu_data *data;
+	struct exynos_tmu_platform_data *pdata;
+	struct thermal_sensor_conf *sensor_conf;
+	int ret, i;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(struct exynos_tmu_data),
+					GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
+		return -ENOMEM;
+	}
+
+	pdata = (struct exynos_tmu_platform_data *)
+				platform_get_device_id(pdev)->driver_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform init data supplied.\n");
+		return -ENODEV;
+	}
+
+	data->pdata = pdata;
+	platform_set_drvdata(pdev, data);
+
+	ret = exynos_map_dt_data(pdev);
+	if (ret)
+		goto unset_data;
+
+	INIT_WORK(&data->irq_work, exynos_tmu_work);
+
+	ret = devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
+		IRQF_TRIGGER_RISING|IRQF_SHARED, dev_name(&pdev->dev), data);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
+		goto unset_data;
+	}
+
+	data->clk = of_clk_get(pdev->dev.of_node, 0);
+	if (IS_ERR(data->clk)) {
+		dev_err(&pdev->dev, "Failed to get tmu clock\n");
+		ret = PTR_ERR(data->clk);
+		goto unset_data;
+	}
+	clk_enable(data->clk);
+
+	mutex_init(&data->lock);
+
+	ret = exynos_tmu_initialize(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize TMU\n");
+		goto err_clk;
+	}
+
+	exynos_tmu_control(pdev, true);
+
+	/* Allocate a structure to register with the exynos core thermal */
+	sensor_conf = devm_kzalloc(&pdev->dev,
+				sizeof(struct thermal_sensor_conf), GFP_KERNEL);
+	if (!sensor_conf) {
+		dev_err(&pdev->dev, "Failed to allocate registration struct\n");
+		ret = -ENOMEM;
+		goto err_clk;
+	}
+	data->reg_conf = sensor_conf;
+	sprintf(sensor_conf->name, "therm_zone%d", data->id);
+	sensor_conf->read_temperature = (int (*)(void *))exynos_tmu_read;
+#ifdef CONFIG_THERMAL_EMULATION
+	sensor_conf->write_emul_temp =
+		(int (*)(void *, unsigned long))exynos_tmu_set_emulation;
+#endif
+	sensor_conf->driver_data = data;
+	sensor_conf->trip_data.trip_count = pdata->trigger_enable[0] +
+			pdata->trigger_enable[1] + pdata->trigger_enable[2] +
+			pdata->trigger_enable[3];
+
+	for (i = 0; i < sensor_conf->trip_data.trip_count; i++)
+		sensor_conf->trip_data.trip_val[i] = pdata->trigger_levels[i];
+
+	sensor_conf->trip_data.trigger_falling = pdata->threshold_falling;
+
+	/* Register the sensor with thermal management interface */
+	ret = exynos_register_thermal(sensor_conf);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register thermal interface\n");
+		goto err_clk;
+	}
+	tmu_common.sensor_count++;
+	return 0;
+err_clk:
+	clk_disable(data->clk);
+	clk_put(data->clk);
+unset_data:
+	platform_set_drvdata(pdev, NULL);
+	return ret;
+}
+
+static int exynos_tmu_remove(struct platform_device *pdev)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct thermal_sensor_conf *sensor_conf = data->reg_conf;
+
+	exynos_tmu_control(pdev, false);
+	clk_disable(data->clk);
+
+	exynos_unregister_thermal(sensor_conf);
+
+	clk_put(data->clk);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int exynos_tmu_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+
+	exynos_tmu_control(pdev, false);
+	clk_disable(data->clk);
+
+	return 0;
+}
+
+static int exynos_tmu_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+
+	clk_enable(data->clk);
+	exynos_tmu_initialize(pdev);
+	exynos_tmu_control(pdev, true);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(exynos_tmu_pm,
+			 exynos_tmu_suspend, exynos_tmu_resume);
+#define EXYNOS_TMU_PM	(&exynos_tmu_pm)
+#else
+#define EXYNOS_TMU_PM	NULL
+#endif
+
+static struct platform_driver exynos_tmu_driver = {
+	.driver = {
+		.name   = "exynos5440-tmu",
+		.owner  = THIS_MODULE,
+		.pm     = EXYNOS_TMU_PM,
+		.of_match_table = exynos_tmu_match,
+	},
+	.probe = exynos_tmu_probe,
+	.remove	= exynos_tmu_remove,
+};
+
+module_platform_driver(exynos_tmu_driver);
+
+MODULE_DESCRIPTION("EXYNOS5440 TMU Driver");
+MODULE_AUTHOR("Amit Daniel<amit.daniel@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:exynos5440-tmu");
-- 
1.7.1

