Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab3HTLN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:13:59 -0400
Received: from mail1.ams.com ([212.166.112.31]:48398 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3HTLNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:13:40 -0400
X-IronPort-AV: E=Sophos;i="4.89,919,1367964000"; 
   d="scan'208";a="4240258"
From: Florian Lobmaier <florian.lobmaier@ams.com>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: [PATCH 2/4] mfd: as3722: introduce core driver file
Date: Tue, 20 Aug 2013 13:13:28 +0200
Message-Id: <1376997210-32631-3-git-send-email-florian.lobmaier@ams.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
---
 drivers/mfd/as3722-core.c |  747 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 747 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/as3722-core.c

diff --git a/drivers/mfd/as3722-core.c b/drivers/mfd/as3722-core.c
new file mode 100644
index 0000000..ddb39c7
--- /dev/null
+++ b/drivers/mfd/as3722-core.c
@@ -0,0 +1,747 @@
+/*
+ * as3722-core.c - core driver for AS3722 PMICs
+ *
+ * Copyright (C) 2013 ams AG
+ *
+ * Author: Florian Lobmaier <florian.lobmaier@ams.com>
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/regmap.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/as3722-reg.h>
+#include <linux/mfd/as3722-plat.h>
+
+enum as3722_ids {
+	AS3722_GPIO_ID,
+	AS3722_REGULATOR_ID,
+	AS3722_RTC_ID,
+	AS3722_WATCHDOG_ID,
+	AS3722_PWM_ID,
+};
+
+static const struct resource as3722_rtc_resource[] = {
+	{
+		.name = "as3722-rtc-alarm",
+		.start = AS3722_IRQ_RTC_ALARM,
+		.end = AS3722_IRQ_RTC_ALARM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static const struct resource as3722_wdt_resource[] = {
+	{
+		.name = "as3722-watchdog-ping",
+		.start = AS3722_IRQ_WATCHDOG,
+		.end = AS3722_IRQ_WATCHDOG,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell as3722_devs[] = {
+	{
+		.name = "as3722-gpio",
+		.id = AS3722_GPIO_ID,
+	},
+	{
+		.name = "as3722-regulator",
+		.id = AS3722_REGULATOR_ID,
+	},
+	{
+		.name = "as3722-rtc",
+		.num_resources = ARRAY_SIZE(as3722_rtc_resource),
+		.resources = as3722_rtc_resource,
+		.id = AS3722_RTC_ID,
+	},
+	{
+		.name = "as3722-wdt",
+		.num_resources = ARRAY_SIZE(as3722_wdt_resource),
+		.resources = as3722_wdt_resource,
+		.id = AS3722_WATCHDOG_ID,
+	},
+	{
+		.name = "as3722-pwm",
+		.id = AS3722_PWM_ID,
+	},
+};
+
+static const struct regmap_irq as3722_irqs[] = {
+	/* INT1 IRQs */
+	[AS3722_IRQ_LID] = {
+		.mask = AS3722_IRQ_MASK_LID,
+	},
+	[AS3722_IRQ_ACOK] = {
+		.mask = AS3722_IRQ_MASK_ACOK,
+	},
+	[AS3722_IRQ_ENABLE1] = {
+		.mask = AS3722_IRQ_MASK_ENABLE1,
+	},
+	[AS3722_IRQ_SD0] = {
+		.mask = AS3722_IRQ_MASK_SD0,
+	},
+	[AS3722_IRQ_ONKEY_LONG] = {
+		.mask = AS3722_IRQ_MASK_ONKEY_LONG,
+	},
+	[AS3722_IRQ_ONKEY] = {
+		.mask = AS3722_IRQ_MASK_ONKEY,
+	},
+	[AS3722_IRQ_OVTMP] = {
+		.mask = AS3722_IRQ_MASK_OVTMP,
+	},
+	[AS3722_IRQ_LOWBAT] = {
+		.mask = AS3722_IRQ_MASK_LOWBAT,
+	},
+	[AS3722_IRQ_RTC_REP] = {
+		.mask = AS3722_IRQ_MASK_RTC_REP,
+		.reg_offset = 1,
+	},
+	[AS3722_IRQ_RTC_ALARM] = {
+		.mask = AS3722_IRQ_MASK_RTC_ALARM,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_WATCHDOG] = {
+		.mask = AS3722_IRQ_MASK_WATCHDOG,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_ADC] = {
+		.mask = AS3722_IRQ_MASK_ADC,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_GPIO1] = {
+		.mask = AS3722_IRQ_MASK_GPIO1,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_GPIO2] = {
+		.mask = AS3722_IRQ_MASK_GPIO2,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_GPIO3] = {
+		.mask = AS3722_IRQ_MASK_GPIO3,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_GPIO4] = {
+		.mask = AS3722_IRQ_MASK_GPIO4,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_GPIO5] = {
+		.mask = AS3722_IRQ_MASK_GPIO5,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_TEMP_SD0_SHUTDOWN] = {
+		.mask = AS3722_IRQ_MASK_TEMP_SD0_SHUTDOWN,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD1_SHUTDOWN] = {
+		.mask = AS3722_IRQ_MASK_TEMP_SD1_SHUTDOWN,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD6_SHUTDOWN] = {
+		.mask = AS3722_IRQ_MASK_TEMP_SD6_SHUTDOWN,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD0_ALARM] = {
+		.mask = AS3722_IRQ_MASK_TEMP_SD0_ALARM,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD1_ALARM] = {
+		.mask = AS3722_IRQ_MASK_TEMP_SD1_ALARM,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD6_ALARM] = {
+		.mask = AS3722_IRQ_MASK_TEMP_SD6_ALARM,
+		.reg_offset = 3,
+	},
+};
+
+static struct regmap_irq_chip as3722_irq_chip = {
+	.name = "as3722",
+	.irqs = as3722_irqs,
+	.num_irqs = ARRAY_SIZE(as3722_irqs),
+	.num_regs = 4,
+	.status_base = AS3722_INTERRUPTSTATUS1_REG,
+	.mask_base = AS3722_INTERRUPTMASK1_REG,
+	.wake_base = 1,
+};
+
+static void as3722_reg_init(struct as3722 *as3722,
+		struct as3722_reg_init *reg_data)
+{
+	int ret;
+
+	while (reg_data->reg != AS3722_REG_INIT_TERMINATE) {
+		ret = as3722_reg_write(as3722, reg_data->reg, reg_data->val);
+		if (ret) {
+			dev_err(as3722->dev,
+					"reg setup failed: %d\n", ret);
+			return;
+		}
+		reg_data++;
+	}
+}
+
+int as3722_read_adc(struct as3722 *as3722,
+		enum as3722_adc_channel channel,
+		enum as3722_adc_source source,
+		enum as3722_adc_voltange_range voltage_range)
+{
+	int result = 0;
+	unsigned int try_counter = 0;
+	u32 val;
+
+	mutex_lock(&as3722->adc_mutex);
+	/* select source */
+	as3722_set_bits(as3722,
+			AS3722_ADC0_CONTROL_REG + channel,
+			AS3722_ADC_MASK_SOURCE_SELECT,
+			source);
+	/* select voltage range */
+	as3722_set_bits(as3722,
+			AS3722_ADC0_CONTROL_REG + channel,
+			AS3722_ADC_MASK_VOLTAGE_RANGE,
+			voltage_range << AS3722_ADC_SHIFT_VOLTAGE_RANGE);
+	/* start conversion */
+	as3722_set_bits(as3722,
+			AS3722_ADC0_CONTROL_REG + channel,
+			AS3722_ADC_MASK_CONV_START,
+			AS3722_ADC_BIT_CONV_START);
+
+	/*
+	 * check if result ready
+	 * as no HW interrupt is available we have to poll
+	 * the status bit. The result is available on the next I2C read
+	 * at 400kHz I2C speed, so no threaded polling required.
+	 */
+	try_counter = 0;
+	do {
+		/* 2*channel for correct channel nr.1 read offset */
+		as3722_reg_read(as3722,
+				AS3722_ADC0_MSB_RESULT_REG + 2*channel,
+				&val);
+		/* check if conversion is ready */
+		if ((val & AS3722_ADC_MASK_CONV_NOTREADY)
+		     != AS3722_ADC_BIT_CONV_NOTREADY
+		   )
+			break;	/* conversion ready */
+		/*
+		 * if not, we try  max. 10 times which ensures
+		 * that it works up to 4MHz I2C speed and that
+		 * we stop if something goes wrong
+		 */
+		try_counter++;
+	} while (try_counter < 10);
+
+	/* read result, MSB byte already available from last read */
+	result = ((val & AS3722_ADC_MASK_MSB_VAL) << 8);
+	as3722_reg_read(as3722,
+			AS3722_ADC0_LSB_RESULT_REG + 2*channel,
+			&val);
+	result += (val & AS3722_ADC_MASK_LSB_VAL);
+
+	mutex_unlock(&as3722->adc_mutex);
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(as3722_read_adc);
+
+static irqreturn_t as3722_onkey_press_irq(int irq, void *irq_data)
+{
+	struct as3722 *as3722 = irq_data;
+
+	dev_dbg(as3722->dev, "AS3722 ONKEY pressed\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_onkey_lpress_irq(int irq, void *irq_data)
+{
+	struct as3722 *as3722 = irq_data;
+
+	dev_dbg(as3722->dev, "AS3722 ONKEY long pressed\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd0_shutdown_irq(int irq, void *irq_data)
+{
+	struct as3722 *as3722 = irq_data;
+
+	dev_dbg(as3722->dev, "AS3722 temp SD0 shutdown triggered\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd1_shutdown_irq(int irq, void *irq_data)
+{
+	struct as3722 *as3722 = irq_data;
+
+	dev_dbg(as3722->dev, "AS3722 temp SD1 shutdown triggered\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd6_shutdown_irq(int irq, void *irq_data)
+{
+	struct as3722 *as3722 = irq_data;
+
+	dev_dbg(as3722->dev, "AS3722 temp SD6 shutdown triggered\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd0_alarm_irq(int irq, void *irq_data)
+{
+	struct as3722 *as3722 = irq_data;
+
+	dev_dbg(as3722->dev, "AS3722 temp SD0 alarm triggered\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd1_alarm_irq(int irq, void *irq_data)
+{
+	struct as3722 *as3722 = irq_data;
+
+	dev_dbg(as3722->dev, "AS3722 temp SD1 alarm triggered\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd6_alarm_irq(int irq, void *irq_data)
+{
+	struct as3722 *as3722 = irq_data;
+
+	dev_dbg(as3722->dev, "AS3722 temp SD6 alarm triggered\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_ovtmp_alarm_irq(int irq, void *irq_data)
+{
+	struct as3722 *as3722 = irq_data;
+
+	dev_dbg(as3722->dev, "AS3722 ovtmp alarm triggered\n");
+	return IRQ_HANDLED;
+}
+
+static int as3722_init(struct as3722 *as3722,
+		struct as3722_platform_data *pdata, int irq)
+{
+	u32 reg;
+	int ret;
+	int irq_onkey, irq_onkeylong;
+	int irq_temp_sd0_shutdown, irq_temp_sd1_shutdown, irq_temp_sd6_shutdown;
+	int irq_temp_sd0_alarm, irq_temp_sd1_alarm, irq_temp_sd6_alarm;
+	int irq_ovtmp_alarm;
+
+	/* Check that this is actually a AS3722 */
+	ret = regmap_read(as3722->regmap, AS3722_ADDR_ASIC_ID1, &reg);
+	if (ret != 0) {
+		dev_err(as3722->dev,
+			"Chip ID register read failed\n");
+		return ret;
+	}
+	if (reg != AS3722_DEVICE_ID) {
+		dev_err(as3722->dev,
+			"Device is not an AS3722, ID is 0x%x\n",
+			reg);
+		return -ENODEV;
+	}
+
+	ret = regmap_read(as3722->regmap, AS3722_ADDR_ASIC_ID2, &reg);
+	if (ret != 0) {
+		dev_err(as3722->dev,
+			"ID2 register read failed: %d\n",
+			ret);
+		return ret;
+	}
+	dev_info(as3722->dev, "AS3722 with revision %x found\n", reg);
+
+	/* init adc mutex */
+	mutex_init(&as3722->adc_mutex);
+
+	/* request irqs for onkey and over temperature */
+	if (as3722->irq_data) {
+		irq_onkey = regmap_irq_get_virq(as3722->irq_data,
+						AS3722_IRQ_ONKEY);
+		ret = request_threaded_irq(irq_onkey,
+					   NULL,
+					   as3722_onkey_press_irq,
+					   pdata->irq_type,
+					   "onkey-press",
+					   as3722);
+		if (ret < 0)
+			dev_warn(as3722->dev,
+				 "Failed to request ONKEY IRQ: %d\n",
+				 ret);
+
+		irq_onkeylong = regmap_irq_get_virq(as3722->irq_data,
+						    AS3722_IRQ_ONKEY_LONG);
+		ret = request_threaded_irq(irq_onkeylong,
+					   NULL,
+					   as3722_onkey_lpress_irq,
+					   pdata->irq_type,
+					   "onkey-lpress",
+					   as3722);
+		if (ret < 0)
+			dev_warn(as3722->dev,
+				 "Failed to request ONKEY_LONG IRQ: %d\n",
+				 ret);
+
+		irq_temp_sd0_shutdown =
+			regmap_irq_get_virq(as3722->irq_data,
+					    AS3722_IRQ_TEMP_SD0_SHUTDOWN);
+		ret = request_threaded_irq(irq_temp_sd0_shutdown,
+					   NULL,
+					   as3722_temp_sd0_shutdown_irq,
+					   pdata->irq_type,
+					   "temp sd0 shutdown",
+					   as3722);
+		if (ret < 0)
+			dev_warn(as3722->dev,
+				 "Failed to request temp sd0 shutdown IRQ:"
+				 " %d\n",
+				 ret);
+		irq_temp_sd1_shutdown =
+			regmap_irq_get_virq(as3722->irq_data,
+					    AS3722_IRQ_TEMP_SD1_SHUTDOWN);
+		ret = request_threaded_irq(irq_temp_sd1_shutdown,
+					   NULL,
+					   as3722_temp_sd1_shutdown_irq,
+					   pdata->irq_type,
+					   "temp sd1 shutdown",
+					   as3722);
+		if (ret < 0)
+			dev_warn(as3722->dev,
+				 "Failed to request temp sd1 shutdown IRQ:"
+				 " %d\n",
+				 ret);
+		irq_temp_sd6_shutdown =
+			regmap_irq_get_virq(as3722->irq_data,
+					    AS3722_IRQ_TEMP_SD6_SHUTDOWN);
+		ret = request_threaded_irq(irq_temp_sd6_shutdown,
+					   NULL,
+					   as3722_temp_sd6_shutdown_irq,
+					   pdata->irq_type,
+					   "temp sd6 shutdown",
+					   as3722);
+		if (ret < 0)
+			dev_warn(as3722->dev,
+				 "Failed to request temp sd6 shutdown IRQ:"
+				 " %d\n",
+				 ret);
+		irq_temp_sd0_alarm =
+			regmap_irq_get_virq(as3722->irq_data,
+					    AS3722_IRQ_TEMP_SD0_ALARM);
+		ret = request_threaded_irq(irq_temp_sd0_alarm,
+					   NULL,
+					   as3722_temp_sd0_alarm_irq,
+					   pdata->irq_type,
+					   "temp sd0 alarm",
+					   as3722);
+		if (ret < 0)
+			dev_warn(as3722->dev,
+				 "Failed to request temp sd0 alarm IRQ:"
+				 " %d\n",
+				 ret);
+
+		irq_temp_sd1_alarm =
+			regmap_irq_get_virq(as3722->irq_data,
+					    AS3722_IRQ_TEMP_SD1_ALARM);
+		ret = request_threaded_irq(irq_temp_sd1_alarm,
+					   NULL,
+					   as3722_temp_sd1_alarm_irq,
+					   pdata->irq_type,
+					   "temp sd1 alarm",
+					   as3722);
+		if (ret < 0)
+			dev_warn(as3722->dev,
+				 "Failed to request temp sd1 alarm IRQ:"
+				 " %d\n",
+				 ret);
+		irq_temp_sd6_alarm =
+			regmap_irq_get_virq(as3722->irq_data,
+					    AS3722_IRQ_TEMP_SD6_ALARM);
+		ret = request_threaded_irq(irq_temp_sd6_alarm,
+					   NULL,
+					   as3722_temp_sd6_alarm_irq,
+					   pdata->irq_type,
+					   "temp sd6 alarm",
+					   as3722);
+		if (ret < 0)
+			dev_warn(as3722->dev,
+				 "Failed to request temp sd6 alarm IRQ:"
+				 " %d\n",
+				 ret);
+
+		irq_ovtmp_alarm =
+			regmap_irq_get_virq(as3722->irq_data,
+					    AS3722_IRQ_OVTMP);
+		ret = request_threaded_irq(irq_ovtmp_alarm,
+					   NULL,
+					   as3722_ovtmp_alarm_irq,
+					   pdata->irq_type,
+					   "ovtmp alarm",
+					   as3722);
+		if (ret < 0)
+			dev_warn(as3722->dev,
+				 "Failed to request ovtmp alarm IRQ:"
+				 " %d\n",
+				 ret);
+	}
+
+	/* do some initial platform register setup */
+	if (pdata->core_init_data)
+		as3722_reg_init(as3722, pdata->core_init_data);
+
+	/* initialise stby reg count variable, used in regulator */
+	as3722->reg_stby_counter = 0;
+
+	/* enable pullups if required */
+	if (pdata->use_internal_int_pullup == 1)
+		as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
+				AS3722_INT_PULLUP_MASK,
+				AS3722_INT_PULLUP_ON);
+	else
+		as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
+				AS3722_INT_PULLUP_MASK,
+				AS3722_INT_PULLUP_OFF);
+
+	if (pdata->use_internal_i2c_pullup)
+		as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
+				AS3722_I2C_PULLUP_MASK,
+				AS3722_I2C_PULLUP_ON);
+	else
+		as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
+				AS3722_I2C_PULLUP_MASK,
+				AS3722_I2C_PULLUP_OFF);
+
+	/* enable1 pin standby configuration */
+	if (pdata->enable1_deepsleep)
+		as3722_set_bits(as3722, AS3722_CTRL1_REG,
+				AS3722_ENABLE1_DEEPSLEEP_MASK,
+				AS3722_ENABLE1_DEEPSLEEP_ON);
+	else
+		as3722_set_bits(as3722, AS3722_CTRL1_REG,
+				AS3722_ENABLE1_DEEPSLEEP_MASK,
+				AS3722_ENABLE1_DEEPSLEEP_OFF);
+
+	if (pdata->enable1_invert)
+		as3722_set_bits(as3722, AS3722_CTRL1_REG,
+				AS3722_ENABLE1_INVERT_MASK,
+				AS3722_ENABLE1_INVERT_ON);
+	else
+		as3722_set_bits(as3722, AS3722_CTRL1_REG,
+				AS3722_ENABLE1_INVERT_MASK,
+				AS3722_ENABLE1_INVERT_OFF);
+
+	as3722_set_bits(as3722, AS3722_RESETTIMER_REG,
+			AS3722_OFF_DELAY_MASK,
+			pdata->off_delay << AS3722_OFF_DELAY_SHIFT);
+
+	/* thermal shutdown control */
+	as3722_set_bits(as3722, AS3722_OVERTEMPERATURE_CONTROL_REG,
+			AS3722_OVTMP_MASK,
+			pdata->mask_ovtemp << AS3722_OVTMP_SHIFT);
+
+	/* overcurrent/powergood configuration */
+	reg = (pdata->pg_sd6_vmask_time << AS3722_PG_SD6_VMASK_TIME_SHIFT)
+			& AS3722_PG_SD6_VMASK_TIME_MASK;
+	reg |= (pdata->sd6_lv_deb_time << AS3722_SD6_LV_DEB_SHIFT)
+			& AS3722_SD6_LV_DEB_MASK;
+	reg |= (pdata->sd1_lv_deb_time << AS3722_SD1_LV_DEB_SHIFT)
+			& AS3722_SD1_LV_DEB_MASK;
+	reg |= (pdata->sd0_lv_deb_time << AS3722_SD0_LV_DEB_SHIFT)
+			& AS3722_SD0_LV_DEB_MASK;
+	as3722_reg_write(as3722, AS3722_SD_LV_DEB_REG, reg);
+
+	reg = (pdata->pg_vresfall_mask << 7)
+			& AS3722_PG_VRESFALL_MASK_MASK;
+	reg |= (pdata->pg_ovcurr_sd0_mask << 6)
+			& AS3722_PG_OVCURR_SD0_MASK_MASK;
+	reg |= (pdata->pg_pwrgood_sd0_mask << 5)
+			& AS3722_PG_PWRGOOD_SD0_MASK_MASK;
+	reg |= (pdata->pg_gpio5_mask << 4)
+			& AS3722_PG_GPIO5_MASK_MASK;
+	reg |= (pdata->pg_gpio4_mask << 3)
+			& AS3722_PG_GPIO4_MASK_MASK;
+	reg |= (pdata->pg_gpio3_mask << 2)
+			& AS3722_PG_GPIO3_MASK_MASK;
+	reg |= (pdata->pg_ac_ok_mask << 1)
+			& AS3722_PG_AC_OK_MASK_MASK;
+	reg |= (pdata->pg_ac_ok_inv)
+			& AS3722_PG_AC_OK_INV_MASK;
+	as3722_reg_write(as3722, AS3722_OC_PG_CONTROL_REG, reg);
+
+	reg = (pdata->pg_ovcurr_sd6_mask << 7)
+			& AS3722_PG_OVCURR_SD6_MASK_MASK;
+	reg |= (pdata->pg_pwrgood_sd6_mask << 6)
+			& AS3722_PG_PWRGOOD_SD6_MASK_MASK;
+	reg |= (pdata->pg_sd6_ovc_alarm << 3)
+			& AS3722_PG_SD6_OVC_ALARM_MASK;
+	reg |= (pdata->pg_sd0_vmask_time << 1)
+			& AS3722_PG_SD0_VMASK_TIME_MASK;
+	reg |= (pdata->oc_pg_inv)
+			& AS3722_OC_PG_INV_MASK;
+	as3722_reg_write(as3722, AS3722_OC_PG_CONTROL2_REG, reg);
+
+	/* enable 32kHz clock output if required */
+	if (pdata->enable_clk32out_pin)
+		as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
+				AS3722_CLK32OUT_ENABLE_MASK,
+				AS3722_CLK32OUT_ENABLE_ON);
+	else
+		as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
+				AS3722_CLK32OUT_ENABLE_MASK,
+				AS3722_CLK32OUT_ENABLE_OFF);
+	return 0;
+}
+
+static int as3722_i2c_probe(struct i2c_client *i2c,
+		const struct i2c_device_id *id)
+{
+	struct as3722 *as3722;
+	struct as3722_platform_data *pdata;
+	int irq_flags;
+	int ret;
+
+	pdata = dev_get_platdata(&i2c->dev);
+	if (!pdata) {
+		dev_err(&i2c->dev, "as3722 requires platform data\n");
+		return -EINVAL;
+	}
+
+	as3722 = devm_kzalloc(&i2c->dev, sizeof(struct as3722), GFP_KERNEL);
+	if (!as3722)
+		return -ENOMEM;
+
+	as3722->dev = &i2c->dev;
+	as3722->chip_irq = i2c->irq;
+	i2c_set_clientdata(i2c, as3722);
+
+	as3722->regmap = devm_regmap_init_i2c(i2c, &as3722_regmap_config);
+	if (IS_ERR(as3722->regmap)) {
+		ret = PTR_ERR(as3722->regmap);
+		dev_err(&i2c->dev, "regmap_init failed with err: %d\n", ret);
+		return ret;
+	}
+
+	irq_flags = pdata->irq_type;
+	irq_flags |= IRQF_ONESHOT;
+	ret = regmap_add_irq_chip(as3722->regmap, as3722->chip_irq,
+			irq_flags, pdata->irq_base, &as3722_irq_chip,
+			&as3722->irq_data);
+	if (ret < 0) {
+		dev_err(as3722->dev,
+			"irq allocation failed for as3722 failed\n");
+		return ret;
+	}
+
+	ret = as3722_init(as3722, pdata, i2c->irq);
+	if (ret < 0)
+		return ret;
+
+	ret = mfd_add_devices(&i2c->dev,
+			      -1,
+			      as3722_devs,
+			      ARRAY_SIZE(as3722_devs),
+			      NULL,
+			      pdata->irq_base,
+			      regmap_irq_get_domain(as3722->irq_data));
+	if (ret) {
+		dev_err(as3722->dev,
+			"add mfd devices failed with err: %d\n",
+			ret);
+		return ret;
+	}
+
+	dev_info(as3722->dev,
+		 "AS3722 core driver initialized successfully\n");
+
+	return 0;
+}
+
+static int as3722_i2c_remove(struct i2c_client *i2c)
+{
+	struct as3722 *as3722 = i2c_get_clientdata(i2c);
+	int irq_onkeylong, irq_onkey;
+	int irq_temp_sd0_shutdown, irq_temp_sd1_shutdown, irq_temp_sd6_shutdown;
+	int irq_temp_sd0_alarm, irq_temp_sd1_alarm, irq_temp_sd6_alarm;
+	int irq_ovtmp_alarm;
+
+	irq_onkeylong = regmap_irq_get_virq(as3722->irq_data,
+					    AS3722_IRQ_ONKEY_LONG);
+	irq_onkey = regmap_irq_get_virq(as3722->irq_data, AS3722_IRQ_ONKEY);
+	irq_temp_sd0_shutdown =
+		regmap_irq_get_virq(as3722->irq_data,
+				    AS3722_IRQ_TEMP_SD0_SHUTDOWN);
+	irq_temp_sd1_shutdown =
+		regmap_irq_get_virq(as3722->irq_data,
+				    AS3722_IRQ_TEMP_SD1_SHUTDOWN);
+	irq_temp_sd6_shutdown =
+		regmap_irq_get_virq(as3722->irq_data,
+				    AS3722_IRQ_TEMP_SD6_SHUTDOWN);
+	irq_temp_sd0_alarm =
+		regmap_irq_get_virq(as3722->irq_data,
+				    AS3722_IRQ_TEMP_SD0_ALARM);
+	irq_temp_sd1_alarm =
+		regmap_irq_get_virq(as3722->irq_data,
+				    AS3722_IRQ_TEMP_SD1_ALARM);
+	irq_temp_sd6_alarm =
+		regmap_irq_get_virq(as3722->irq_data,
+				    AS3722_IRQ_TEMP_SD6_ALARM);
+	irq_ovtmp_alarm =
+		regmap_irq_get_virq(as3722->irq_data,
+				    AS3722_IRQ_OVTMP);
+
+	free_irq(irq_onkeylong, as3722);
+	free_irq(irq_onkey, as3722);
+	free_irq(irq_temp_sd0_shutdown, as3722);
+	free_irq(irq_temp_sd1_shutdown, as3722);
+	free_irq(irq_temp_sd6_shutdown, as3722);
+	free_irq(irq_temp_sd0_alarm, as3722);
+	free_irq(irq_temp_sd1_alarm, as3722);
+	free_irq(irq_temp_sd6_alarm, as3722);
+	free_irq(irq_ovtmp_alarm, as3722);
+	mfd_remove_devices(as3722->dev);
+	regmap_del_irq_chip(as3722->chip_irq, as3722->irq_data);
+
+	return 0;
+}
+
+static const struct i2c_device_id as3722_i2c_id[] = {
+	{ "as3722", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, as3722_i2c_id);
+
+static struct i2c_driver as3722_i2c_driver = {
+	.driver = {
+		.name = "as3722",
+		.owner = THIS_MODULE,
+	},
+	.probe = as3722_i2c_probe,
+	.remove = as3722_i2c_remove,
+	.id_table = as3722_i2c_id,
+};
+
+module_i2c_driver(as3722_i2c_driver);
+
+MODULE_DESCRIPTION("I2C, IRQ and ADC support for AS3722 PMICs");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Florian Lobmaier <florian.lobmaier@ams.com>");
-- 
1.7.2.5

