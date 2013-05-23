Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab3EWMSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:18:32 -0400
Received: from mail1.ams.com ([212.166.112.31]:63221 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862Ab3EWMRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:17:04 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 08:17:02 EDT
X-IronPort-AV: E=Sophos;i="4.87,728,1363129200"; 
   d="scan'208";a="2797467"
From: Florian Lobmaier <Florian.Lobmaier@ams.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 May 2013 14:07:31 +0200
Subject: [PATCH 02/07] include/linux patch of ams AS3722 PMIC against
 linux_3.8.8
Thread-Topic: [PATCH 02/07] include/linux patch of ams AS3722 PMIC against
 linux_3.8.8
Thread-Index: Ac5XrIRqoWQMKcqHRGyG1eYNntNFeg==
Message-ID: <EB31996D403C2C48A47628A08DCCFD29018405708A@SUX2182.office.amsiag.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Lobmaier <florian.lobmaier@ams.com>

Added multi-function device driver support for ams AS3722 PMIC
Includes modules gpio, regulator, rtc, and watchdog

Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>

---
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/include//linux/mfd/as3722-plat.h ./include/linux/mfd/as3722-plat.h
--- ../kernel_3.8.8/linux-kernel/include//linux/mfd/as3722-plat.h       1970-01-01 01:00:00.000000000 +0100
+++ ./include/linux/mfd/as3722-plat.h   2013-05-23 13:12:37.000000000 +0200
@@ -0,0 +1,233 @@
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
+#include <linux/mfd/as3722-reg.h>
+
+struct as3722_reg_init {
+       u32 reg;
+       u32 val;
+};
+
+extern const struct regmap_config as3722_regmap_config;
+
+struct as3722_rtc {
+       struct rtc_device *rtc;
+       int alarm_enabled;      /* used for suspend/resume */
+};
+
+struct as3722 {
+       struct device *dev;
+       struct regmap *regmap;
+       struct regmap_irq_chip_data *irq_data;
+       struct regulator_dev *rdevs[AS3722_NUM_REGULATORS];
+       struct as3722_rtc rtc;
+
+       struct mutex adc_mutex;
+
+       int chip_irq;
+       int reg_stby_counter;
+};
+
+enum {
+       AS3722_GPIO_CFG_NO_INVERT = 0,
+       AS3722_GPIO_CFG_INVERT = 1,
+};
+
+enum {
+       AS3722_GPIO_CFG_OUTPUT_DISABLED = 0,
+       AS3722_GPIO_CFG_OUTPUT_ENABLED = 1,
+};
+
+struct as3722_gpio_config {
+       int gpio;
+       int mode;
+       int invert;
+       int iosf;
+       int output_state;
+};
+
+enum as3722_off_delay {
+       AS3722_OFF_DELAY_NONE = 0,
+       AS3722_OFF_DELAY_8ms = 1,
+       AS3722_OFF_DELAY_16ms = 2,
+       AS3722_OFF_DELAY_32ms = 3,
+};
+
+enum as3722_bit {
+       AS3722_BIT_OFF = 0,
+       AS3722_BIT_ON = 1,
+};
+
+enum as3722_vmask_time {
+       AS3722_NO_MASKING = 0,
+       AS3722_VMASK_4us = 1,
+       AS3722_VMASK_8us = 2,
+};
+
+enum as3722_lv_deb_time {
+       AS3722_NO_DEBOUNCING = 0,
+       AS3722_DEB_1us = 1,
+       AS3722_DEB_4us = 2,
+       AS3722_DEB_20us = 3,
+};
+
+enum as3722_ovc_alarm {
+       AS3722_OVC_ALARM_DISABLED = 0,
+       AS3722_OVC_ALARM_1_6A = 1,
+       AS3722_OVC_ALARM_1_8A = 2,
+       AS3722_OVC_ALARM_2_0A = 3,
+       AS3722_OVC_ALARM_2_2A = 4,
+       AS3722_OVC_ALARM_2_4A = 5,
+       AS3722_OVC_ALARM_2_6A = 6,
+       AS3722_OVC_ALARM_2_8A = 7,
+};
+
+struct as3722_platform_data {
+       struct regulator_init_data *reg_init[AS3722_NUM_REGULATORS];
+
+       /* register initialisation */
+       struct as3722_reg_init *core_init_data;
+       int gpio_base;
+       int irq_base;
+       int irq_type;
+
+       int use_internal_int_pullup;
+       int use_internal_i2c_pullup;
+       int enable_clk32out_pin;
+
+       int num_gpio_cfgs;
+       struct as3722_gpio_config *gpio_cfgs;
+
+       /* enable1 pin standby control */
+       enum as3722_off_delay off_delay;
+       int enable1_deepsleep;
+       int enable1_invert;
+
+       /* overcurrent / powergood settings */
+       enum as3722_vmask_time pg_sd6_vmask_time;
+       enum as3722_lv_deb_time sd6_lv_deb_time;
+       enum as3722_lv_deb_time sd1_lv_deb_time;
+       enum as3722_lv_deb_time sd0_lv_deb_time;
+       enum as3722_bit pg_vresfall_mask;
+       enum as3722_bit pg_ovcurr_sd0_mask;
+       enum as3722_bit pg_pwrgood_sd0_mask;
+       enum as3722_bit pg_gpio5_mask;
+       enum as3722_bit pg_gpio4_mask;
+       enum as3722_bit pg_gpio3_mask;
+       enum as3722_bit pg_ac_ok_mask;
+       enum as3722_bit pg_ac_ok_inv;
+       enum as3722_bit pg_ovcurr_sd6_mask;
+       enum as3722_bit pg_pwrgood_sd6_mask;
+       enum as3722_ovc_alarm pg_sd6_ovc_alarm;
+       enum as3722_vmask_time pg_sd0_vmask_time;
+       enum as3722_bit oc_pg_inv;
+};
+
+static inline int as3722_reg_read(struct as3722 *as3722, u32 reg, u32 *dest)
+{
+       return regmap_read(as3722->regmap, reg, dest);
+}
+
+static inline int as3722_reg_write(struct as3722 *as3722, u32 reg, u32 value)
+{
+       return regmap_write(as3722->regmap, reg, value);
+}
+
+static inline int as3722_block_read(struct as3722 *as3722, u32 reg,
+               int count, u8 *buf)
+{
+       return regmap_bulk_read(as3722->regmap, reg, buf, count);
+}
+
+static inline int as3722_block_write(struct as3722 *as3722, u32 reg,
+               int count, u8 *data)
+{
+       return regmap_bulk_write(as3722->regmap, reg, data, count);
+}
+
+static inline int as3722_set_bits(struct as3722 *as3722, u32 reg,
+               u32 mask, u8 val)
+{
+       return regmap_update_bits(as3722->regmap, reg, mask, val);
+}
+
+/* ADC */
+enum as3722_adc_source {
+       AS3722_ADC_SD0 = 0,
+       AS3722_ADC_SD1 = 1,
+       AS3722_ADC_SD6 = 2,
+       AS3722_ADC_TEMP_SENSOR = 3,
+       AS3722_ADC_VSUP = 4,
+       AS3722_ADC_GPIO1 = 5,
+       AS3722_ADC_GPIO2 = 6,
+       AS3722_ADC_GPIO3 = 7,
+       AS3722_ADC_GPIO4 = 8,
+       AS3722_ADC_GPIO6 = 9,
+       AS3722_ADC_GPIO7 = 10,
+       AS3722_ADC_VBAT = 11,
+       AS3722_ADC_PWM_CLK2 = 12,
+       AS3722_ADC_PWM_DAT2 = 13,
+       AS3722_ADC_TEMP1_SD0 = 16,
+       AS3722_ADC_TEMP2_SD0 = 17,
+       AS3722_ADC_TEMP3_SD0 = 18,
+       AS3722_ADC_TEMP4_SD0 = 19,
+       AS3722_ADC_TEMP_SD1 = 20,
+       AS3722_ADC_TEMP1_SD6 = 21,
+       AS3722_ADC_TEMP2_SD6 = 22,
+};
+
+enum as3722_adc_channel {
+       AS3722_ADC0 = 0,
+       AS3722_ADC1 = 1,
+};
+
+enum as3722_adc_voltange_range {
+       AS3722_ADC_HIGH_VOLTAGE_RANGE = 0,
+       AS3722_ADC_LOW_VOLTAGE_RANGE = 1,
+};
+
+int as3722_adc_read(struct as3722 *as3722,
+                       enum as3722_adc_channel channel,
+                       enum as3722_adc_source source,
+                       enum as3722_adc_voltange_range voltage_range);
+
+#endif
+
+
+
+
+
+
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/include//linux/mfd/as3722-reg.h ./include/linux/mfd/as3722-reg.h
--- ../kernel_3.8.8/linux-kernel/include//linux/mfd/as3722-reg.h        1970-01-01 01:00:00.000000000 +0100
+++ ./include/linux/mfd/as3722-reg.h    2013-05-23 13:12:37.000000000 +0200
@@ -0,0 +1,468 @@
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
+#ifndef __LINUX_MFD_AS3722_REG_H
+#define __LINUX_MFD_AS3722_REG_H
+
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/power_supply.h>
+#include <linux/irq.h>
+#include <linux/regmap.h>
+#include <linux/regulator/machine.h>
+
+#define AS3722_DEVICE_ID                      0x0C
+#define AS3722_REGISTER_COUNT                  0x92
+#define AS3722_NUM_REGULATORS                  18
+#define AS3722_NUM_STEPDOWN_REGULATORS         7
+#define AS3722_MAX_REG_STBY_COUNT             10
+
+/* defines for register init */
+#define AS3722_REG_INIT(reg_offset, reg_value)  \
+{                                              \
+       .reg     = (reg_offset),                \
+       .val     = (reg_value),                 \
+}
+
+#define AS3722_REG_INIT_TERMINATE              0xFF
+
+/* regulator IDs */
+#define AS3722_LDO0                            0
+#define AS3722_LDO1                            1
+#define AS3722_LDO2                            2
+#define AS3722_LDO3                            3
+#define AS3722_LDO4                            4
+#define AS3722_LDO5                            5
+#define AS3722_LDO6                            6
+#define AS3722_LDO7                            7
+#define AS3722_LDO9                            8
+#define AS3722_LDO10                           9
+#define AS3722_LDO11                           10
+#define AS3722_SD0                             11
+#define AS3722_SD1                             12
+#define AS3722_SD2                             13
+#define AS3722_SD3                             14
+#define AS3722_SD4                             15
+#define AS3722_SD5                             16
+#define AS3722_SD6                             17
+
+/* AS3722 ASIC ID */
+#define AS3722_ADDR_ASIC_ID1                   0x90
+#define AS3722_ADDR_ASIC_ID2                   0x91
+
+/* GPIO IDs */
+#define AS3722_GPIO0                           0
+#define AS3722_GPIO1                           1
+#define AS3722_GPIO2                           2
+#define AS3722_GPIO3                           3
+#define AS3722_GPIO4                           4
+#define AS3722_GPIO5                           5
+#define AS3722_GPIO6                           6
+#define AS3722_GPIO7                           7
+
+#define AS3722_NUM_GPIO                        8
+#define AS3722_GPIO_IRQ_BASE                   0
+
+/* GPIO modes */
+#define AS3722_GPIO_MODE_MASK                  0x07
+#define AS3722_GPIO_MODE_INPUT                 0
+#define AS3722_GPIO_MODE_OUTPUT_VDDH           1
+#define AS3722_GPIO_MODE_IO_OPEN_DRAIN         2
+#define AS3722_GPIO_MODE_ADC_IN                3
+#define AS3722_GPIO_MODE_INPUT_W_PULLUP        4
+#define AS3722_GPIO_MODE_INPUT_W_PULLDOWN      5
+#define AS3722_GPIO_MODE_IO_OPEN_DRAIN_PULLUP  6
+#define AS3722_GPIO_MODE_OUTPUT_VDDL           7
+
+/* Interrupt IDs */
+#define AS3722_IRQ_MAX_HANDLER                 18
+#define AS3722_IRQ_LID                         0
+#define AS3722_IRQ_ACOK                        1
+#define AS3722_IRQ_ENABLE1                    2
+#define AS3722_IRQ_OCURR_ACOK                  3
+#define AS3722_IRQ_ONKEY_LONG                  4
+#define AS3722_IRQ_ONKEY                       5
+#define AS3722_IRQ_OVTMP                       6
+#define AS3722_IRQ_LOWBAT                      7
+#define AS3722_IRQ_RTC_REP                     8
+#define AS3722_IRQ_RTC_ALARM                   9
+#define AS3722_IRQ_SD0                         10
+#define AS3722_IRQ_WATCHDOG                    11
+#define AS3722_IRQ_ADC                         12
+#define AS3722_IRQ_GPIO1                       13
+#define AS3722_IRQ_GPIO2                       14
+#define AS3722_IRQ_GPIO3                       15
+#define AS3722_IRQ_GPIO4                       16
+#define AS3722_IRQ_GPIO5                       17
+
+/* AS3722 registers */
+#define AS3722_SD0_VOLTAGE_REG                 0x00
+#define AS3722_SD1_VOLTAGE_REG                 0x01
+#define AS3722_SD2_VOLTAGE_REG                 0x02
+#define AS3722_SD3_VOLTAGE_REG                 0x03
+#define AS3722_SD4_VOLTAGE_REG                 0x04
+#define AS3722_SD5_VOLTAGE_REG                 0x05
+#define AS3722_SD6_VOLTAGE_REG                 0x06
+#define AS3722_GPIO0_CONTROL_REG               0x08
+#define AS3722_GPIO1_CONTROL_REG               0x09
+#define AS3722_GPIO2_CONTROL_REG               0x0A
+#define AS3722_GPIO3_CONTROL_REG               0x0B
+#define AS3722_GPIO4_CONTROL_REG               0x0C
+#define AS3722_GPIO5_CONTROL_REG               0x0D
+#define AS3722_GPIO6_CONTROL_REG               0x0E
+#define AS3722_GPIO7_CONTROL_REG               0x0F
+#define AS3722_LDO0_VOLTAGE_REG                0x10
+#define AS3722_LDO1_VOLTAGE_REG                0x11
+#define AS3722_LDO2_VOLTAGE_REG                0x12
+#define AS3722_LDO3_VOLTAGE_REG                0x13
+#define AS3722_LDO4_VOLTAGE_REG                0x14
+#define AS3722_LDO5_VOLTAGE_REG                0x15
+#define AS3722_LDO6_VOLTAGE_REG                0x16
+#define AS3722_LDO7_VOLTAGE_REG                0x17
+#define AS3722_LDO9_VOLTAGE_REG                0x19
+#define AS3722_LDO10_VOLTAGE_REG               0x1A
+#define AS3722_LDO11_VOLTAGE_REG               0x1B
+
+#define AS3722_GPIO_SIGNAL_OUT_REG             0x20
+#define AS3722_GPIO_SIGNAL_IN_REG              0x21
+
+#define AS3722_SD0_CONTROL_REG                 0x29
+#define AS3722_SD1_CONTROL_REG                 0x2A
+#define AS3722_SDmph_CONTROL_REG               0x2B
+#define AS3722_SD23_CONTROL_REG                0x2C
+#define AS3722_SD4_CONTROL_REG                 0x2D
+#define AS3722_SD5_CONTROL_REG                 0x2E
+#define AS3722_SD6_CONTROL_REG                 0x2F
+
+#define AS3722_RESETTIMER_REG                 0x34
+#define AS3722_WATCHDOG_CONTROL_REG            0x38
+#define AS3722_REG_STANDBY_MOD1_REG           0x39
+#define AS3722_REG_STANDBY_MOD2_REG           0x3A
+#define AS3722_REG_STANDBY_MOD3_REG           0x3B
+#define AS3722_WATCHDOG_TIMER_REG              0x46
+#define AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG    0x48
+#define AS3722_IOVOLTAGE_REG                   0x49
+#define AS3722_SD_CONTROL_REG                  0x4D
+#define AS3722_LDOCONTROL0_REG                 0x4E
+#define AS3722_LDOCONTROL1_REG                 0x4F
+
+#define AS3722_CTRL1_REG                       0x58
+#define AS3722_CTRL2_REG                       0x59
+#define AS3722_SD_LV_DEB_REG                  0x5C
+#define AS3722_OC_PG_CONTROL_REG              0x5D
+#define AS3722_OC_PG_CONTROL2_REG             0x5E
+#define AS3722_RTC_CONTROL_REG                 0x60
+#define AS3722_RTC_SECOND_REG                  0x61
+#define AS3722_RTC_MINUTE_REG                  0x62
+#define AS3722_RTC_HOUR_REG                    0x63
+#define AS3722_RTC_DAY_REG                     0x64
+#define AS3722_RTC_MONTH_REG                   0x65
+#define AS3722_RTC_YEAR_REG                    0x66
+#define AS3722_RTC_ALARM_SECOND_REG            0x67
+#define AS3722_RTC_ALARM_MINUTE_REG            0x68
+#define AS3722_RTC_ALARM_HOUR_REG              0x69
+#define AS3722_RTC_ALARM_DAY_REG               0x6A
+#define AS3722_RTC_ALARM_MONTH_REG             0x6B
+#define AS3722_RTC_ALARM_YEAR_REG              0x6C
+
+#define AS3722_INTERRUPTMASK1_REG              0x74
+#define AS3722_INTERRUPTMASK2_REG              0x75
+#define AS3722_INTERRUPTMASK3_REG              0x76
+#define AS3722_INTERRUPTMASK4_REG              0x77
+#define AS3722_INTERRUPTSTATUS1_REG            0x78
+#define AS3722_INTERRUPTSTATUS2_REG            0x79
+#define AS3722_INTERRUPTSTATUS3_REG            0x7A
+#define AS3722_INTERRUPTSTATUS4_REG            0x7B
+
+#define AS3722_ADC0_CONTROL_REG                0x80
+#define AS3722_ADC1_CONTROL_REG                0x81
+#define AS3722_ADC0_MSB_RESULT_REG             0x82
+#define AS3722_ADC0_LSB_RESULT_REG             0x83
+#define AS3722_ADC1_MSB_RESULT_REG             0x84
+#define AS3722_ADC1_LSB_RESULT_REG             0x85
+#define AS3722_ADC1_THRESHOLD_HI_MSB_REG       0x86
+#define AS3722_ADC1_THRESHOLD_HI_LSB_REG       0x87
+#define AS3722_ADC1_THRESHOLD_LO_MSB_REG       0x88
+#define AS3722_ADC1_THRESHOLD_LO_LSB_REG       0x89
+#define AS3722_ADC_CONFIG_REG                  0x8A
+
+#define AS3722_REG0_CONTROL_REG                       0xE0
+#define AS3722_REG1_CONTROL_REG                       0xE1
+#define AS3722_REG2_CONTROL_REG                       0xE2
+#define AS3722_REG3_CONTROL_REG                       0xE3
+#define AS3722_REG4_CONTROL_REG                       0xE4
+#define AS3722_REG5_CONTROL_REG                       0xE5
+#define AS3722_REG6_CONTROL_REG                       0xE6
+#define AS3722_REG7_CONTROL_REG                       0xE7
+#define AS3722_REG8_CONTROL_REG                       0xE8
+#define AS3722_REG9_CONTROL_REG                       0xE9
+#define AS3722_REG0_VOLTAGE_REG                       0xEA
+#define AS3722_REG1_VOLTAGE_REG                       0xEB
+#define AS3722_REG2_VOLTAGE_REG                       0xEC
+#define AS3722_REG3_VOLTAGE_REG                       0xED
+#define AS3722_REG4_VOLTAGE_REG                       0xEE
+#define AS3722_REG5_VOLTAGE_REG                       0xEF
+#define AS3722_REG6_VOLTAGE_REG                       0xF0
+#define AS3722_REG7_VOLTAGE_REG                       0xF1
+#define AS3722_REG8_VOLTAGE_REG                       0xF2
+#define AS3722_REG9_VOLTAGE_REG                       0xF3
+
+/* AS3722 register bits and bit masks */
+#define AS3722_LDO_ILIMIT_MASK                 (1 << 7)
+#define AS3722_LDO_ILIMIT_BIT                  (1 << 7)
+#define AS3722_LDO0_VSEL_MASK                  0x1F
+#define AS3722_LDO0_VSEL_MIN                   0x01
+#define AS3722_LDO0_VSEL_MAX                   0x12
+#define AS3722_LDO3_VSEL_MASK                  0x3F
+#define AS3722_LDO3_VSEL_MIN                   0x01
+#define AS3722_LDO3_VSEL_MAX                   0x45
+#define AS3722_LDO_VSEL_MASK                   0x7F
+#define AS3722_LDO_VSEL_MIN                    0x01
+#define AS3722_LDO_VSEL_MAX                    0x7F
+#define AS3722_LDO_VSEL_DNU_MIN                0x25
+#define AS3722_LDO_VSEL_DNU_MAX                0x3F
+#define AS3722_LDO_NUM_VOLT                    100
+
+#define AS3722_LDO0_ON                         (1 << 0)
+#define AS3722_LDO0_OFF                        (0 << 0)
+#define AS3722_LDO0_CTRL_MASK                  (1 << 0)
+#define AS3722_LDO1_ON                         (1 << 1)
+#define AS3722_LDO1_OFF                        (0 << 1)
+#define AS3722_LDO1_CTRL_MASK                  (1 << 1)
+#define AS3722_LDO2_ON                         (1 << 2)
+#define AS3722_LDO2_OFF                        (0 << 2)
+#define AS3722_LDO2_CTRL_MASK                  (1 << 2)
+#define AS3722_LDO3_ON                         (1 << 3)
+#define AS3722_LDO3_OFF                        (0 << 3)
+#define AS3722_LDO3_CTRL_MASK                  (1 << 3)
+#define AS3722_LDO4_ON                         (1 << 4)
+#define AS3722_LDO4_OFF                        (0 << 4)
+#define AS3722_LDO4_CTRL_MASK                  (1 << 4)
+#define AS3722_LDO5_ON                         (1 << 5)
+#define AS3722_LDO5_OFF                        (0 << 5)
+#define AS3722_LDO5_CTRL_MASK                  (1 << 5)
+#define AS3722_LDO6_ON                         (1 << 6)
+#define AS3722_LDO6_OFF                        (0 << 6)
+#define AS3722_LDO6_CTRL_MASK                  (1 << 6)
+#define AS3722_LDO7_ON                         (1 << 7)
+#define AS3722_LDO7_OFF                        (0 << 7)
+#define AS3722_LDO7_CTRL_MASK                  (1 << 7)
+#define AS3722_LDO9_ON                         (1 << 1)
+#define AS3722_LDO9_OFF                        (0 << 1)
+#define AS3722_LDO9_CTRL_MASK                  (1 << 1)
+#define AS3722_LDO10_ON                        (1 << 2)
+#define AS3722_LDO10_OFF                       (0 << 2)
+#define AS3722_LDO10_CTRL_MASK                 (1 << 2)
+#define AS3722_LDO11_ON                        (1 << 3)
+#define AS3722_LDO11_OFF                       (0 << 3)
+#define AS3722_LDO11_CTRL_MASK                 (1 << 3)
+
+#define AS3722_SD_VSEL_MASK                    0x7F
+#define AS3722_SD0_VSEL_MIN                    0x01
+#define AS3722_SD0_VSEL_MAX                    0x5A
+#define AS3722_SD2_VSEL_MIN                    0x01
+#define AS3722_SD2_VSEL_MAX                    0x7F
+#define AS3722_SD0_ON                          (1 << 0)
+#define AS3722_SD0_OFF                         (0 << 0)
+#define AS3722_SD0_CTRL_MASK                   (1 << 0)
+#define AS3722_SD1_ON                          (1 << 1)
+#define AS3722_SD1_OFF                         (0 << 1)
+#define AS3722_SD1_CTRL_MASK                   (1 << 1)
+#define AS3722_SD2_ON                          (1 << 2)
+#define AS3722_SD2_OFF                         (0 << 2)
+#define AS3722_SD2_CTRL_MASK                   (1 << 2)
+#define AS3722_SD3_ON                          (1 << 3)
+#define AS3722_SD3_OFF                         (0 << 3)
+#define AS3722_SD3_CTRL_MASK                   (1 << 3)
+#define AS3722_SD4_ON                          (1 << 4)
+#define AS3722_SD4_OFF                         (0 << 4)
+#define AS3722_SD4_CTRL_MASK                   (1 << 4)
+#define AS3722_SD5_ON                          (1 << 5)
+#define AS3722_SD5_OFF                         (0 << 5)
+#define AS3722_SD5_CTRL_MASK                   (1 << 5)
+#define AS3722_SD6_ON                          (1 << 6)
+#define AS3722_SD6_OFF                         (0 << 6)
+#define AS3722_SD6_CTRL_MASK                   (1 << 6)
+
+#define AS3722_SD0_MODE_FAST                   (1 << 4)
+#define AS3722_SD0_MODE_NORMAL                 (0 << 4)
+#define AS3722_SD0_MODE_MASK                   (1 << 4)
+#define AS3722_SD1_MODE_FAST                   (1 << 4)
+#define AS3722_SD1_MODE_NORMAL                 (0 << 4)
+#define AS3722_SD1_MODE_MASK                   (1 << 4)
+#define AS3722_SD2_MODE_FAST                   (1 << 2)
+#define AS3722_SD2_MODE_NORMAL                 (0 << 2)
+#define AS3722_SD2_MODE_MASK                   (1 << 2)
+#define AS3722_SD3_MODE_FAST                   (1 << 6)
+#define AS3722_SD3_MODE_NORMAL                 (0 << 6)
+#define AS3722_SD3_MODE_MASK                   (1 << 6)
+#define AS3722_SD4_MODE_FAST                   (1 << 2)
+#define AS3722_SD4_MODE_NORMAL                 (0 << 2)
+#define AS3722_SD4_MODE_MASK                   (1 << 2)
+#define AS3722_SD5_MODE_FAST                   (1 << 2)
+#define AS3722_SD5_MODE_NORMAL                 (0 << 2)
+#define AS3722_SD5_MODE_MASK                   (1 << 2)
+#define AS3722_SD6_MODE_FAST                   (1 << 4)
+#define AS3722_SD6_MODE_NORMAL                 (0 << 4)
+#define AS3722_SD6_MODE_MASK                   (1 << 4)
+
+#define AS3722_DELAY_TIME_STBY_MASK           (1 << 6)
+#define AS3722_REG_DELAY_STBY_MASK            (1 << 5)
+#define AS3722_REG_SELECT_STBY_MASK           (0x1F)
+#define AS3722_REG_VOLTAGE_STBY_MASK          (0xFF)
+
+#define AS3722_SD0_LV_DEB_MASK                (0x03)
+#define AS3722_SD1_LV_DEB_MASK                (0x0C)
+#define AS3722_SD6_LV_DEB_MASK                (0x30)
+#define AS3722_PG_SD6_VMASK_TIME_MASK         (0xC0)
+#define AS3722_SD0_LV_DEB_SHIFT                       (0)
+#define AS3722_SD1_LV_DEB_SHIFT                       (2)
+#define AS3722_SD6_LV_DEB_SHIFT                       (4)
+#define AS3722_PG_SD6_VMASK_TIME_SHIFT        (6)
+
+#define AS3722_PG_AC_OK_INV_MASK              (1 << 0)
+#define AS3722_PG_AC_OK_MASK_MASK             (1 << 1)
+#define AS3722_PG_GPIO3_MASK_MASK             (1 << 2)
+#define AS3722_PG_GPIO4_MASK_MASK             (1 << 3)
+#define AS3722_PG_GPIO5_MASK_MASK             (1 << 4)
+#define AS3722_PG_PWRGOOD_SD0_MASK_MASK               (1 << 5)
+#define AS3722_PG_OVCURR_SD0_MASK_MASK        (1 << 6)
+#define AS3722_PG_VRESFALL_MASK_MASK          (1 << 7)
+
+#define AS3722_OC_PG_INV_MASK                 (1 << 0)
+#define AS3722_PG_SD0_VMASK_TIME_MASK         (0x06)
+#define AS3722_PG_SD6_OVC_ALARM_MASK          (0x38)
+#define AS3722_PG_PWRGOOD_SD6_MASK_MASK               (1 << 6)
+#define AS3722_PG_OVCURR_SD6_MASK_MASK        (1 << 7)
+
+#define AS3722_IRQ_MASK_LID                    (1 << 0)
+#define AS3722_IRQ_MASK_ACOK                   (1 << 1)
+#define AS3722_IRQ_MASK_ENABLE1                (1 << 2)
+#define AS3722_IRQ_MASK_OCURR_ACOK             (1 << 3)
+#define AS3722_IRQ_MASK_ONKEY_LONG             (1 << 4)
+#define AS3722_IRQ_MASK_ONKEY                  (1 << 5)
+#define AS3722_IRQ_MASK_OVTMP                  (1 << 6)
+#define AS3722_IRQ_MASK_LOWBAT                 (1 << 7)
+#define AS3722_IRQ_MASK_SD0                    (1 << 0)
+#define AS3722_IRQ_MASK_RTC_REP                (1 << 7)
+#define AS3722_IRQ_MASK_RTC_ALARM              (1 << 0)
+#define AS3722_IRQ_MASK_WATCHDOG               (1 << 6)
+#define AS3722_IRQ_MASK_ADC                    (1 << 7)
+#define AS3722_IRQ_MASK_GPIO1                 (1 << 1)
+#define AS3722_IRQ_MASK_GPIO2                 (1 << 2)
+#define AS3722_IRQ_MASK_GPIO3                 (1 << 3)
+#define AS3722_IRQ_MASK_GPIO4                 (1 << 4)
+#define AS3722_IRQ_MASK_GPIO5                 (1 << 5)
+
+#define AS3722_IRQ_BIT_LID                     (1 << 0)
+#define AS3722_IRQ_BIT_ACOK                    (1 << 1)
+#define AS3722_IRQ_BIT_ENABLE1                (1 << 2)
+#define AS3722_IRQ_BIT_SD0                     (1 << 3)
+#define AS3722_IRQ_BIT_ONKEY_LONG              (1 << 4)
+#define AS3722_IRQ_BIT_ONKEY                   (1 << 5)
+#define AS3722_IRQ_BIT_OVTMP                   (1 << 6)
+#define AS3722_IRQ_BIT_LOWBAT                  (1 << 7)
+#define AS3722_IRQ_BIT_RTC_REP                 (1 << 7)
+#define AS3722_IRQ_BIT_RTC_ALARM               (1 << 0)
+#define AS3722_IRQ_BIT_WATCHDOG                (1 << 6)
+#define AS3722_IRQ_BIT_ADC                     (1 << 7)
+
+#define AS3722_ADC_MASK_BUF_ON                 (1 << 2)
+#define AS3722_ADC_BIT_BUF_ON                  (1 << 2)
+#define AS3722_ADC1_MASK_INT_MODE_ON           (1 << 1)
+#define AS3722_ADC1_BIT_INT_MODE_ON            (1 << 1)
+#define AS3722_ADC1_MASK_INTERVAL_TIME         (1 << 0)
+#define AS3722_ADC1_BIT_INTERVAL_TIME          (1 << 0)
+
+#define AS3722_ADC_MASK_MSB_VAL                0x3F
+#define AS3722_ADC_MASK_LSB_VAL                0x07
+
+#define AS3722_ADC_MASK_CONV_START            (1 << 7)
+#define AS3722_ADC_BIT_CONV_START             (1 << 7)
+#define AS3722_ADC_MASK_CONV_NOTREADY         (1 << 7)
+#define AS3722_ADC_BIT_CONV_NOTREADY          (1 << 7)
+#define AS3722_ADC_MASK_SOURCE_SELECT         0x1F
+#define AS3722_ADC_MASK_VOLTAGE_RANGE        (1 << 5)
+#define AS3722_ADC_SHIFT_VOLTAGE_RANGE       5
+
+#define AS3722_GPIO_INV_MASK                   0x80
+#define AS3722_GPIO_INV                        0x80
+#define AS3722_GPIO_IOSF_MASK                  0x78
+#define AS3722_GPIO_IOSF_NORMAL                0
+#define AS3722_GPIO_IOSF_INTERRUPT_OUT         (1 << 3)
+#define AS3722_GPIO_IOSF_VSUP_LOW_OUT          (2 << 3)
+#define AS3722_GPIO_IOSF_GPIO_INTERRUPT_IN     (3 << 3)
+#define AS3722_GPIO_IOSF_ISINK_PWM_IN          (4 << 3)
+#define AS3722_GPIO_IOSF_VOLTAGE_STBY          (5 << 3)
+#define AS3722_GPIO_IOSF_PWR_GOOD_OUT          (7 << 3)
+#define AS3722_GPIO_IOSF_Q32K_OUT              (8 << 3)
+#define AS3722_GPIO_IOSF_WATCHDOG_IN           (9 << 3)
+#define AS3722_GPIO_IOSF_SOFT_RESET_IN         (11 << 3)
+#define AS3722_GPIO_IOSF_PWM_OUT               (12 << 3)
+#define AS3722_GPIO_IOSF_VSUP_LOW_DEB_OUT      (13 << 3)
+#define AS3722_GPIO_IOSF_SD6_LOW_VOLT_LOW      (14 << 3)
+
+#define AS3722_GPIO0_SIGNAL_MASK               (1 << 0)
+#define AS3722_GPIO1_SIGNAL_MASK               (1 << 1)
+#define AS3722_GPIO2_SIGNAL_MASK               (1 << 2)
+#define AS3722_GPIO3_SIGNAL_MASK               (1 << 3)
+#define AS3722_GPIO4_SIGNAL_MASK               (1 << 4)
+#define AS3722_GPIO5_SIGNAL_MASK               (1 << 5)
+#define AS3722_GPIO6_SIGNAL_MASK               (1 << 6)
+#define AS3722_GPIO7_SIGNAL_MASK               (1 << 7)
+
+#define AS3722_INT_PULLUP_MASK                 (1 << 5)
+#define AS3722_INT_PULLUP_ON                   (1 << 5)
+#define AS3722_INT_PULLUP_OFF                  (0 << 5)
+#define AS3722_I2C_PULLUP_MASK                 (1 << 4)
+#define AS3722_I2C_PULLUP_ON                   (1 << 4)
+#define AS3722_I2C_PULLUP_OFF                  (0 << 4)
+
+#define AS3722_RTC_REP_WAKEUP_EN_MASK          (1 << 0)
+#define AS3722_RTC_ALARM_WAKEUP_EN_MASK        (1 << 1)
+#define AS3722_RTC_ON_MASK                     (1 << 2)
+#define AS3722_RTC_IRQMODE_MASK                (3 << 3)
+#define AS3722_CLK32OUT_ENABLE_MASK           (1 << 5)
+
+#define AS3722_CLK32OUT_ENABLE_ON             (1 << 5)
+#define AS3722_CLK32OUT_ENABLE_OFF            (0 << 5)
+
+#define AS3722_OFF_DELAY_MASK                 (0x18)
+#define AS3722_OFF_DELAY_SHIFT                (3)
+
+#define AS3722_ENABLE1_INVERT_MASK            (1 << 4)
+#define AS3722_ENABLE1_INVERT_ON              (1 << 4)
+#define AS3722_ENABLE1_INVERT_OFF             (0 << 4)
+#define AS3722_ENABLE1_DEEPSLEEP_MASK         (1 << 5)
+#define AS3722_ENABLE1_DEEPSLEEP_ON           (1 << 5)
+#define AS3722_ENABLE1_DEEPSLEEP_OFF          (0 << 5)
+
+#define AS3722_WATCHDOG_TIMER_MAX              127
+#define AS3722_WATCHDOG_ON_MASK                (1 << 0)
+#define AS3722_WATCHDOG_ON                     (1 << 0)
+#define AS3722_WATCHDOG_SW_SIG_MASK            (1 << 0)
+#define AS3722_WATCHDOG_SW_SIG                 (1 << 0)
+
+#endif
