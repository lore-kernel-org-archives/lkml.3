Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab3HNOzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:55:33 -0400
Received: from mail1.ams.com ([212.166.112.31]:33408 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613Ab3HNOzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:55:25 -0400
X-IronPort-AV: E=Sophos;i="4.89,877,1367964000"; 
   d="scan'208";a="4151236"
From: Florian Lobmaier <florian.lobmaier@ams.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: [PATCH 3/4] added AS3722 platform include file
Date: Wed, 14 Aug 2013 16:54:57 +0200
Message-Id: <1376492098-15672-3-git-send-email-florian.lobmaier@ams.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376492098-15672-1-git-send-email-florian.lobmaier@ams.com>
References: <1376492098-15672-1-git-send-email-florian.lobmaier@ams.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
---
 include/linux/mfd/as3722-plat.h |  238 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 238 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mfd/as3722-plat.h

diff --git a/include/linux/mfd/as3722-plat.h b/include/linux/mfd/as3722-plat.h
new file mode 100644
index 0000000..0fc3fb7
--- /dev/null
+++ b/include/linux/mfd/as3722-plat.h
@@ -0,0 +1,238 @@
+/*
+ * as3722.h definitions
+ *
+ * Copyright (C) 2013 ams
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
+#ifndef __LINUX_MFD_AS3722_PLAT_H
+#define __LINUX_MFD_AS3722_PLAT_H
+
+#include <linux/mutex.h>
+#include <linux/completion.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/power_supply.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/regmap.h>
+#include <linux/regulator/machine.h>
+#include <linux/pwm.h>
+#include <linux/mfd/as3722-reg.h>
+
+struct as3722_reg_init {
+	u32 reg;
+	u32 val;
+};
+
+extern const struct regmap_config as3722_regmap_config;
+
+struct as3722_rtc {
+	struct rtc_device *rtc;
+	int alarm_enabled;      /* used for suspend/resume */
+};
+
+struct as3722 {
+	struct device *dev;
+	struct regmap *regmap;
+	struct regmap_irq_chip_data *irq_data;
+	struct regulator_dev *rdevs[AS3722_NUM_REGULATORS];
+	struct as3722_rtc rtc;
+	struct pwm_chip as3722_pwm;
+
+	struct mutex adc_mutex;
+
+	int chip_irq;
+	int reg_stby_counter;
+};
+
+enum {
+	AS3722_GPIO_CFG_NO_INVERT = 0,
+	AS3722_GPIO_CFG_INVERT = 1,
+};
+
+enum {
+	AS3722_GPIO_CFG_OUTPUT_DISABLED = 0,
+	AS3722_GPIO_CFG_OUTPUT_ENABLED = 1,
+};
+
+struct as3722_gpio_config {
+	int gpio;
+	int mode;
+	int invert;
+	int iosf;
+	int output_state;
+};
+
+enum as3722_off_delay {
+	AS3722_OFF_DELAY_NONE = 0,
+	AS3722_OFF_DELAY_8ms = 1,
+	AS3722_OFF_DELAY_16ms = 2,
+	AS3722_OFF_DELAY_32ms = 3,
+};
+
+enum as3722_bit {
+	AS3722_BIT_OFF = 0,
+	AS3722_BIT_ON = 1,
+};
+
+enum as3722_vmask_time {
+	AS3722_NO_MASKING = 0,
+	AS3722_VMASK_4us = 1,
+	AS3722_VMASK_8us = 2,
+};
+
+enum as3722_lv_deb_time {
+	AS3722_NO_DEBOUNCING = 0,
+	AS3722_DEB_1us = 1,
+	AS3722_DEB_4us = 2,
+	AS3722_DEB_20us = 3,
+};
+
+enum as3722_ovc_alarm {
+	AS3722_OVC_ALARM_DISABLED = 0,
+	AS3722_OVC_ALARM_1_6A = 1,
+	AS3722_OVC_ALARM_1_8A = 2,
+	AS3722_OVC_ALARM_2_0A = 3,
+	AS3722_OVC_ALARM_2_2A = 4,
+	AS3722_OVC_ALARM_2_4A = 5,
+	AS3722_OVC_ALARM_2_6A = 6,
+	AS3722_OVC_ALARM_2_8A = 7,
+};
+
+struct as3722_platform_data {
+	struct regulator_init_data *reg_init[AS3722_NUM_REGULATORS];
+
+	/* register initialisation */
+	struct as3722_reg_init *core_init_data;
+	int gpio_base;
+	int irq_base;
+	int irq_type;
+
+	int use_internal_int_pullup;
+	int use_internal_i2c_pullup;
+	int enable_clk32out_pin;
+
+	int num_gpio_cfgs;
+	struct as3722_gpio_config *gpio_cfgs;
+
+	/* enable1 pin standby control */
+	enum as3722_off_delay off_delay;
+	int enable1_deepsleep;
+	int enable1_invert;
+
+	/* thermal shutdown control */
+	enum as3722_bit mask_ovtemp;
+
+	/* overcurrent / powergood settings */
+	enum as3722_vmask_time pg_sd6_vmask_time;
+	enum as3722_lv_deb_time sd6_lv_deb_time;
+	enum as3722_lv_deb_time sd1_lv_deb_time;
+	enum as3722_lv_deb_time sd0_lv_deb_time;
+	enum as3722_bit pg_vresfall_mask;
+	enum as3722_bit pg_ovcurr_sd0_mask;
+	enum as3722_bit pg_pwrgood_sd0_mask;
+	enum as3722_bit pg_gpio5_mask;
+	enum as3722_bit pg_gpio4_mask;
+	enum as3722_bit pg_gpio3_mask;
+	enum as3722_bit pg_ac_ok_mask;
+	enum as3722_bit pg_ac_ok_inv;
+	enum as3722_bit pg_ovcurr_sd6_mask;
+	enum as3722_bit pg_pwrgood_sd6_mask;
+	enum as3722_ovc_alarm pg_sd6_ovc_alarm;
+	enum as3722_vmask_time pg_sd0_vmask_time;
+	enum as3722_bit oc_pg_inv;
+};
+
+static inline int as3722_reg_read(struct as3722 *as3722, u32 reg, u32 *dest)
+{
+	return regmap_read(as3722->regmap, reg, dest);
+}
+
+static inline int as3722_reg_write(struct as3722 *as3722, u32 reg, u32 value)
+{
+	return regmap_write(as3722->regmap, reg, value);
+}
+
+static inline int as3722_block_read(struct as3722 *as3722, u32 reg,
+		int count, u8 *buf)
+{
+	return regmap_bulk_read(as3722->regmap, reg, buf, count);
+}
+
+static inline int as3722_block_write(struct as3722 *as3722, u32 reg,
+		int count, u8 *data)
+{
+	return regmap_bulk_write(as3722->regmap, reg, data, count);
+}
+
+static inline int as3722_set_bits(struct as3722 *as3722, u32 reg,
+		u32 mask, u8 val)
+{
+	return regmap_update_bits(as3722->regmap, reg, mask, val);
+}
+
+/* ADC */
+enum as3722_adc_source {
+	AS3722_ADC_SD0 = 0,
+	AS3722_ADC_SD1 = 1,
+	AS3722_ADC_SD6 = 2,
+	AS3722_ADC_TEMP_SENSOR = 3,
+	AS3722_ADC_VSUP = 4,
+	AS3722_ADC_GPIO1 = 5,
+	AS3722_ADC_GPIO2 = 6,
+	AS3722_ADC_GPIO3 = 7,
+	AS3722_ADC_GPIO4 = 8,
+	AS3722_ADC_GPIO6 = 9,
+	AS3722_ADC_GPIO7 = 10,
+	AS3722_ADC_VBAT = 11,
+	AS3722_ADC_PWM_CLK2 = 12,
+	AS3722_ADC_PWM_DAT2 = 13,
+	AS3722_ADC_TEMP1_SD0 = 16,
+	AS3722_ADC_TEMP2_SD0 = 17,
+	AS3722_ADC_TEMP3_SD0 = 18,
+	AS3722_ADC_TEMP4_SD0 = 19,
+	AS3722_ADC_TEMP_SD1 = 20,
+	AS3722_ADC_TEMP1_SD6 = 21,
+	AS3722_ADC_TEMP2_SD6 = 22,
+};
+
+enum as3722_adc_channel {
+	AS3722_ADC0 = 0,
+	AS3722_ADC1 = 1,
+};
+
+enum as3722_adc_voltange_range {
+	AS3722_ADC_HIGH_VOLTAGE_RANGE = 0,
+	AS3722_ADC_LOW_VOLTAGE_RANGE = 1,
+};
+
+int as3722_adc_read(struct as3722 *as3722,
+			enum as3722_adc_channel channel,
+			enum as3722_adc_source source,
+			enum as3722_adc_voltange_range voltage_range);
+
+#endif
+
+
+
+
+
+
-- 
1.7.2.5

