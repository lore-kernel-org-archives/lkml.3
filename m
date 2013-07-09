Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3GIM1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:27:13 -0400
Received: from mail1.ams.com ([212.166.112.31]:58497 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab3GIM1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:27:09 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jul 2013 08:27:05 EDT
X-IronPort-AV: E=Sophos;i="4.87,1028,1363129200"; 
   d="scan'208";a="3557468"
From: Florian Lobmaier <Florian.Lobmaier@ams.com>
To: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>
Date: Tue, 9 Jul 2013 14:16:56 +0200
Subject: RE: [PATCH 01/07] mfd patch of ams AS3722 PMIC against linux_3.8.8
Thread-Topic: [PATCH 01/07] mfd patch of ams AS3722 PMIC against linux_3.8.8
Thread-Index: Ac5XwPKeXmzgx/hbTzWDTFJ9tRzmJwk2u5Lw
Message-ID: <EB31996D403C2C48A47628A08DCCFD290184D89C84@SUX2182.office.amsiag.com>
References: <EB31996D403C2C48A47628A08DCCFD290184057088@SUX2182.office.amsiag.com>
 <20130523142218.GK22683@gmail.com>
In-Reply-To: <20130523142218.GK22683@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r69CRS2j010478

Hello,

thanks for the inputs. Please see the updated mfd driver patch attached. Hopefully the format of the patches is correct now. It is stated the old way in Documentation/SubmittingPatches, section 1. May I ask the question on how to send multiple patches correctly (mfd driver, regulator, gpio, etc.)?

Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>

---
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ff553ba..138acb6 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -516,6 +516,21 @@ config MFD_LP8788
          TI LP8788 PMU supports regulators, battery charger, RTC,
          ADC, backlight driver and current sinks.

+config MFD_AS3722
+       tristate "Support for ams AS3722 PMIC"
+       select MFD_CORE
+       select REGMAP_I2C
+       select REGMAP_IRQ
+       depends on I2C=y
+       help
+         Core support for the ams AS3722 PMIC. Additional
+         drivers must be enabled in order to use the functionality of the
+         device.
+         Related drivers are:
+               * ams AS3722 PMIC regulators
+               * ams AS3722 GPIO
+               * ams AS3722 RTC
+
 config MFD_MAX77686
        bool "Maxim Semiconductor MAX77686 PMIC Support"
        depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8b977f8..559779c 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -148,3 +148,4 @@ obj-$(CONFIG_MFD_LM3533)    += lm3533-core.o lm3533-ctrlbank.o
 obj-$(CONFIG_VEXPRESS_CONFIG)  += vexpress-config.o vexpress-sysreg.o
 obj-$(CONFIG_MFD_RETU)         += retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)       += as3711.o
+obj-$(CONFIG_MFD_AS3722)       += as3722-core.o as3722-regmap.o
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
+       AS3722_GPIO_ID,
+       AS3722_REGULATOR_ID,
+       AS3722_RTC_ID,
+       AS3722_WATCHDOG_ID,
+       AS3722_PWM_ID,
+};
+
+static const struct resource as3722_rtc_resource[] = {
+       {
+               .name = "as3722-rtc-alarm",
+               .start = AS3722_IRQ_RTC_ALARM,
+               .end = AS3722_IRQ_RTC_ALARM,
+               .flags = IORESOURCE_IRQ,
+       },
+};
+
+static const struct resource as3722_wdt_resource[] = {
+       {
+               .name = "as3722-watchdog-ping",
+               .start = AS3722_IRQ_WATCHDOG,
+               .end = AS3722_IRQ_WATCHDOG,
+               .flags = IORESOURCE_IRQ,
+       },
+};
+
+static struct mfd_cell as3722_devs[] = {
+       {
+               .name = "as3722-gpio",
+               .id = AS3722_GPIO_ID,
+       },
+       {
+               .name = "as3722-regulator",
+               .id = AS3722_REGULATOR_ID,
+       },
+       {
+               .name = "as3722-rtc",
+               .num_resources = ARRAY_SIZE(as3722_rtc_resource),
+               .resources = as3722_rtc_resource,
+               .id = AS3722_RTC_ID,
+       },
+       {
+               .name = "as3722-wdt",
+               .num_resources = ARRAY_SIZE(as3722_wdt_resource),
+               .resources = as3722_wdt_resource,
+               .id = AS3722_WATCHDOG_ID,
+       },
+       {
+               .name = "as3722-pwm",
+               .id = AS3722_PWM_ID,
+       },
+};
+
+static const struct regmap_irq as3722_irqs[] = {
+       /* INT1 IRQs */
+       [AS3722_IRQ_LID] = {
+               .mask = AS3722_IRQ_MASK_LID,
+       },
+       [AS3722_IRQ_ACOK] = {
+               .mask = AS3722_IRQ_MASK_ACOK,
+       },
+       [AS3722_IRQ_ENABLE1] = {
+               .mask = AS3722_IRQ_MASK_ENABLE1,
+       },
+       [AS3722_IRQ_SD0] = {
+               .mask = AS3722_IRQ_MASK_SD0,
+       },
+       [AS3722_IRQ_ONKEY_LONG] = {
+               .mask = AS3722_IRQ_MASK_ONKEY_LONG,
+       },
+       [AS3722_IRQ_ONKEY] = {
+               .mask = AS3722_IRQ_MASK_ONKEY,
+       },
+       [AS3722_IRQ_OVTMP] = {
+               .mask = AS3722_IRQ_MASK_OVTMP,
+       },
+       [AS3722_IRQ_LOWBAT] = {
+               .mask = AS3722_IRQ_MASK_LOWBAT,
+       },
+       [AS3722_IRQ_RTC_REP] = {
+               .mask = AS3722_IRQ_MASK_RTC_REP,
+               .reg_offset = 1,
+       },
+       [AS3722_IRQ_RTC_ALARM] = {
+               .mask = AS3722_IRQ_MASK_RTC_ALARM,
+               .reg_offset = 2,
+       },
+       [AS3722_IRQ_WATCHDOG] = {
+               .mask = AS3722_IRQ_MASK_WATCHDOG,
+               .reg_offset = 2,
+       },
+       [AS3722_IRQ_ADC] = {
+               .mask = AS3722_IRQ_MASK_ADC,
+               .reg_offset = 3,
+       },
+       [AS3722_IRQ_GPIO1] = {
+               .mask = AS3722_IRQ_MASK_GPIO1,
+               .reg_offset = 2,
+       },
+       [AS3722_IRQ_GPIO2] = {
+               .mask = AS3722_IRQ_MASK_GPIO2,
+               .reg_offset = 2,
+       },
+       [AS3722_IRQ_GPIO3] = {
+               .mask = AS3722_IRQ_MASK_GPIO3,
+               .reg_offset = 2,
+       },
+       [AS3722_IRQ_GPIO4] = {
+               .mask = AS3722_IRQ_MASK_GPIO4,
+               .reg_offset = 2,
+       },
+       [AS3722_IRQ_GPIO5] = {
+               .mask = AS3722_IRQ_MASK_GPIO5,
+               .reg_offset = 2,
+       },
+       [AS3722_IRQ_TEMP_SD0_SHUTDOWN] = {
+               .mask = AS3722_IRQ_MASK_TEMP_SD0_SHUTDOWN,
+               .reg_offset = 3,
+       },
+       [AS3722_IRQ_TEMP_SD1_SHUTDOWN] = {
+               .mask = AS3722_IRQ_MASK_TEMP_SD1_SHUTDOWN,
+               .reg_offset = 3,
+       },
+       [AS3722_IRQ_TEMP_SD6_SHUTDOWN] = {
+               .mask = AS3722_IRQ_MASK_TEMP_SD6_SHUTDOWN,
+               .reg_offset = 3,
+       },
+       [AS3722_IRQ_TEMP_SD0_ALARM] = {
+               .mask = AS3722_IRQ_MASK_TEMP_SD0_ALARM,
+               .reg_offset = 3,
+       },
+       [AS3722_IRQ_TEMP_SD1_ALARM] = {
+               .mask = AS3722_IRQ_MASK_TEMP_SD1_ALARM,
+               .reg_offset = 3,
+       },
+       [AS3722_IRQ_TEMP_SD6_ALARM] = {
+               .mask = AS3722_IRQ_MASK_TEMP_SD6_ALARM,
+               .reg_offset = 3,
+       },
+};
+
+static struct regmap_irq_chip as3722_irq_chip = {
+       .name = "as3722",
+       .irqs = as3722_irqs,
+       .num_irqs = ARRAY_SIZE(as3722_irqs),
+       .num_regs = 4,
+       .status_base = AS3722_INTERRUPTSTATUS1_REG,
+       .mask_base = AS3722_INTERRUPTMASK1_REG,
+       .wake_base = 1,
+};
+
+static void as3722_reg_init(struct as3722 *as3722,
+               struct as3722_reg_init *reg_data)
+{
+       int ret;
+
+       while (reg_data->reg != AS3722_REG_INIT_TERMINATE) {
+               ret = as3722_reg_write(as3722, reg_data->reg, reg_data->val);
+               if (ret) {
+                       dev_err(as3722->dev,
+                                       "reg setup failed: %d\n", ret);
+                       return;
+               }
+               reg_data++;
+       }
+}
+
+int as3722_read_adc(struct as3722 *as3722,
+               enum as3722_adc_channel channel,
+               enum as3722_adc_source source,
+               enum as3722_adc_voltange_range voltage_range)
+{
+       int result = 0;
+       unsigned int try_counter = 0;
+       u32 val;
+
+       mutex_lock(&as3722->adc_mutex);
+       /* select source */
+       as3722_set_bits(as3722,
+                       AS3722_ADC0_CONTROL_REG + channel,
+                       AS3722_ADC_MASK_SOURCE_SELECT,
+                       source);
+       /* select voltage range */
+       as3722_set_bits(as3722,
+                       AS3722_ADC0_CONTROL_REG + channel,
+                       AS3722_ADC_MASK_VOLTAGE_RANGE,
+                       voltage_range << AS3722_ADC_SHIFT_VOLTAGE_RANGE);
+       /* start conversion */
+       as3722_set_bits(as3722,
+                       AS3722_ADC0_CONTROL_REG + channel,
+                       AS3722_ADC_MASK_CONV_START,
+                       AS3722_ADC_BIT_CONV_START);
+
+       /*
+        * check if result ready
+        * as no HW interrupt is available we have to poll
+        * the status bit. The result is available on the next I2C read
+        * at 400kHz I2C speed, so no threaded polling required.
+        */
+       try_counter = 0;
+       do {
+               /* 2*channel for correct channel nr.1 read offset */
+               as3722_reg_read(as3722,
+                               AS3722_ADC0_MSB_RESULT_REG + 2*channel,
+                               &val);
+               /* check if conversion is ready */
+               if ((val & AS3722_ADC_MASK_CONV_NOTREADY)
+                    != AS3722_ADC_BIT_CONV_NOTREADY
+                  )
+                       break;  /* conversion ready */
+               /*
+                * if not, we try  max. 10 times which ensures
+                * that it works up to 4MHz I2C speed and that
+                * we stop if something goes wrong
+                */
+               try_counter++;
+       } while (try_counter < 10);
+
+       /* read result, MSB byte already available from last read */
+       result = ((val & AS3722_ADC_MASK_MSB_VAL) << 8);
+       as3722_reg_read(as3722,
+                       AS3722_ADC0_LSB_RESULT_REG + 2*channel,
+                       &val);
+       result += (val & AS3722_ADC_MASK_LSB_VAL);
+
+       mutex_unlock(&as3722->adc_mutex);
+
+       return result;
+}
+EXPORT_SYMBOL_GPL(as3722_read_adc);
+
+static irqreturn_t as3722_onkey_press_irq(int irq, void *irq_data)
+{
+       struct as3722 *as3722 = irq_data;
+
+       dev_dbg(as3722->dev, "AS3722 ONKEY pressed\n");
+       return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_onkey_lpress_irq(int irq, void *irq_data)
+{
+       struct as3722 *as3722 = irq_data;
+
+       dev_dbg(as3722->dev, "AS3722 ONKEY long pressed\n");
+       return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd0_shutdown_irq(int irq, void *irq_data)
+{
+       struct as3722 *as3722 = irq_data;
+
+       dev_dbg(as3722->dev, "AS3722 temp SD0 shutdown triggered\n");
+       return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd1_shutdown_irq(int irq, void *irq_data)
+{
+       struct as3722 *as3722 = irq_data;
+
+       dev_dbg(as3722->dev, "AS3722 temp SD1 shutdown triggered\n");
+       return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd6_shutdown_irq(int irq, void *irq_data)
+{
+       struct as3722 *as3722 = irq_data;
+
+       dev_dbg(as3722->dev, "AS3722 temp SD6 shutdown triggered\n");
+       return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd0_alarm_irq(int irq, void *irq_data)
+{
+       struct as3722 *as3722 = irq_data;
+
+       dev_dbg(as3722->dev, "AS3722 temp SD0 alarm triggered\n");
+       return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd1_alarm_irq(int irq, void *irq_data)
+{
+       struct as3722 *as3722 = irq_data;
+
+       dev_dbg(as3722->dev, "AS3722 temp SD1 alarm triggered\n");
+       return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_temp_sd6_alarm_irq(int irq, void *irq_data)
+{
+       struct as3722 *as3722 = irq_data;
+
+       dev_dbg(as3722->dev, "AS3722 temp SD6 alarm triggered\n");
+       return IRQ_HANDLED;
+}
+
+static irqreturn_t as3722_ovtmp_alarm_irq(int irq, void *irq_data)
+{
+       struct as3722 *as3722 = irq_data;
+
+       dev_dbg(as3722->dev, "AS3722 ovtmp alarm triggered\n");
+       return IRQ_HANDLED;
+}
+
+static int as3722_init(struct as3722 *as3722,
+               struct as3722_platform_data *pdata, int irq)
+{
+       u32 reg;
+       int ret;
+       int irq_onkey, irq_onkeylong;
+       int irq_temp_sd0_shutdown, irq_temp_sd1_shutdown, irq_temp_sd6_shutdown;
+       int irq_temp_sd0_alarm, irq_temp_sd1_alarm, irq_temp_sd6_alarm;
+       int irq_ovtmp_alarm;
+
+       /* Check that this is actually a AS3722 */
+       ret = regmap_read(as3722->regmap, AS3722_ADDR_ASIC_ID1, &reg);
+       if (ret != 0) {
+               dev_err(as3722->dev,
+                       "Chip ID register read failed\n");
+               return ret;
+       }
+       if (reg != AS3722_DEVICE_ID) {
+               dev_err(as3722->dev,
+                       "Device is not an AS3722, ID is 0x%x\n",
+                       reg);
+               return -ENODEV;
+       }
+
+       ret = regmap_read(as3722->regmap, AS3722_ADDR_ASIC_ID2, &reg);
+       if (ret != 0) {
+               dev_err(as3722->dev,
+                       "ID2 register read failed: %d\n",
+                       ret);
+               return ret;
+       }
+       dev_info(as3722->dev, "AS3722 with revision %x found\n", reg);
+
+       /* init adc mutex */
+       mutex_init(&as3722->adc_mutex);
+
+       /* request irqs for onkey and over temperature */
+       if (as3722->irq_data) {
+               irq_onkey = regmap_irq_get_virq(as3722->irq_data,
+                                               AS3722_IRQ_ONKEY);
+               ret = request_threaded_irq(irq_onkey,
+                                          NULL,
+                                          as3722_onkey_press_irq,
+                                          pdata->irq_type,
+                                          "onkey-press",
+                                          as3722);
+               if (ret < 0)
+                       dev_warn(as3722->dev,
+                                "Failed to request ONKEY IRQ: %d\n",
+                                ret);
+
+               irq_onkeylong = regmap_irq_get_virq(as3722->irq_data,
+                                                   AS3722_IRQ_ONKEY_LONG);
+               ret = request_threaded_irq(irq_onkeylong,
+                                          NULL,
+                                          as3722_onkey_lpress_irq,
+                                          pdata->irq_type,
+                                          "onkey-lpress",
+                                          as3722);
+               if (ret < 0)
+                       dev_warn(as3722->dev,
+                                "Failed to request ONKEY_LONG IRQ: %d\n",
+                                ret);
+
+               irq_temp_sd0_shutdown =
+                       regmap_irq_get_virq(as3722->irq_data,
+                                           AS3722_IRQ_TEMP_SD0_SHUTDOWN);
+               ret = request_threaded_irq(irq_temp_sd0_shutdown,
+                                          NULL,
+                                          as3722_temp_sd0_shutdown_irq,
+                                          pdata->irq_type,
+                                          "temp sd0 shutdown",
+                                          as3722);
+               if (ret < 0)
+                       dev_warn(as3722->dev,
+                                "Failed to request temp sd0 shutdown IRQ:"
+                                " %d\n",
+                                ret);
+               irq_temp_sd1_shutdown =
+                       regmap_irq_get_virq(as3722->irq_data,
+                                           AS3722_IRQ_TEMP_SD1_SHUTDOWN);
+               ret = request_threaded_irq(irq_temp_sd1_shutdown,
+                                          NULL,
+                                          as3722_temp_sd1_shutdown_irq,
+                                          pdata->irq_type,
+                                          "temp sd1 shutdown",
+                                          as3722);
+               if (ret < 0)
+                       dev_warn(as3722->dev,
+                                "Failed to request temp sd1 shutdown IRQ:"
+                                " %d\n",
+                                ret);
+               irq_temp_sd6_shutdown =
+                       regmap_irq_get_virq(as3722->irq_data,
+                                           AS3722_IRQ_TEMP_SD6_SHUTDOWN);
+               ret = request_threaded_irq(irq_temp_sd6_shutdown,
+                                          NULL,
+                                          as3722_temp_sd6_shutdown_irq,
+                                          pdata->irq_type,
+                                          "temp sd6 shutdown",
+                                          as3722);
+               if (ret < 0)
+                       dev_warn(as3722->dev,
+                                "Failed to request temp sd6 shutdown IRQ:"
+                                " %d\n",
+                                ret);
+               irq_temp_sd0_alarm =
+                       regmap_irq_get_virq(as3722->irq_data,
+                                           AS3722_IRQ_TEMP_SD0_ALARM);
+               ret = request_threaded_irq(irq_temp_sd0_alarm,
+                                          NULL,
+                                          as3722_temp_sd0_alarm_irq,
+                                          pdata->irq_type,
+                                          "temp sd0 alarm",
+                                          as3722);
+               if (ret < 0)
+                       dev_warn(as3722->dev,
+                                "Failed to request temp sd0 alarm IRQ:"
+                                " %d\n",
+                                ret);
+
+               irq_temp_sd1_alarm =
+                       regmap_irq_get_virq(as3722->irq_data,
+                                           AS3722_IRQ_TEMP_SD1_ALARM);
+               ret = request_threaded_irq(irq_temp_sd1_alarm,
+                                          NULL,
+                                          as3722_temp_sd1_alarm_irq,
+                                          pdata->irq_type,
+                                          "temp sd1 alarm",
+                                          as3722);
+               if (ret < 0)
+                       dev_warn(as3722->dev,
+                                "Failed to request temp sd1 alarm IRQ:"
+                                " %d\n",
+                                ret);
+               irq_temp_sd6_alarm =
+                       regmap_irq_get_virq(as3722->irq_data,
+                                           AS3722_IRQ_TEMP_SD6_ALARM);
+               ret = request_threaded_irq(irq_temp_sd6_alarm,
+                                          NULL,
+                                          as3722_temp_sd6_alarm_irq,
+                                          pdata->irq_type,
+                                          "temp sd6 alarm",
+                                          as3722);
+               if (ret < 0)
+                       dev_warn(as3722->dev,
+                                "Failed to request temp sd6 alarm IRQ:"
+                                " %d\n",
+                                ret);
+
+               irq_ovtmp_alarm =
+                       regmap_irq_get_virq(as3722->irq_data,
+                                           AS3722_IRQ_OVTMP);
+               ret = request_threaded_irq(irq_ovtmp_alarm,
+                                          NULL,
+                                          as3722_ovtmp_alarm_irq,
+                                          pdata->irq_type,
+                                          "ovtmp alarm",
+                                          as3722);
+               if (ret < 0)
+                       dev_warn(as3722->dev,
+                                "Failed to request ovtmp alarm IRQ:"
+                                " %d\n",
+                                ret);
+       }
+
+       /* do some initial platform register setup */
+       if (pdata->core_init_data)
+               as3722_reg_init(as3722, pdata->core_init_data);
+
+       /* initialise stby reg count variable, used in regulator */
+       as3722->reg_stby_counter = 0;
+
+       /* enable pullups if required */
+       if (pdata->use_internal_int_pullup == 1)
+               as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
+                               AS3722_INT_PULLUP_MASK,
+                               AS3722_INT_PULLUP_ON);
+       else
+               as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
+                               AS3722_INT_PULLUP_MASK,
+                               AS3722_INT_PULLUP_OFF);
+
+       if (pdata->use_internal_i2c_pullup)
+               as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
+                               AS3722_I2C_PULLUP_MASK,
+                               AS3722_I2C_PULLUP_ON);
+       else
+               as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
+                               AS3722_I2C_PULLUP_MASK,
+                               AS3722_I2C_PULLUP_OFF);
+
+       /* enable1 pin standby configuration */
+       if (pdata->enable1_deepsleep)
+               as3722_set_bits(as3722, AS3722_CTRL1_REG,
+                               AS3722_ENABLE1_DEEPSLEEP_MASK,
+                               AS3722_ENABLE1_DEEPSLEEP_ON);
+       else
+               as3722_set_bits(as3722, AS3722_CTRL1_REG,
+                               AS3722_ENABLE1_DEEPSLEEP_MASK,
+                               AS3722_ENABLE1_DEEPSLEEP_OFF);
+
+       if (pdata->enable1_invert)
+               as3722_set_bits(as3722, AS3722_CTRL1_REG,
+                               AS3722_ENABLE1_INVERT_MASK,
+                               AS3722_ENABLE1_INVERT_ON);
+       else
+               as3722_set_bits(as3722, AS3722_CTRL1_REG,
+                               AS3722_ENABLE1_INVERT_MASK,
+                               AS3722_ENABLE1_INVERT_OFF);
+
+       as3722_set_bits(as3722, AS3722_RESETTIMER_REG,
+                       AS3722_OFF_DELAY_MASK,
+                       pdata->off_delay << AS3722_OFF_DELAY_SHIFT);
+
+       /* thermal shutdown control */
+       as3722_set_bits(as3722, AS3722_OVERTEMPERATURE_CONTROL_REG,
+                       AS3722_OVTMP_MASK,
+                       pdata->mask_ovtemp << AS3722_OVTMP_SHIFT);
+
+       /* overcurrent/powergood configuration */
+       reg = (pdata->pg_sd6_vmask_time << AS3722_PG_SD6_VMASK_TIME_SHIFT)
+                       & AS3722_PG_SD6_VMASK_TIME_MASK;
+       reg |= (pdata->sd6_lv_deb_time << AS3722_SD6_LV_DEB_SHIFT)
+                       & AS3722_SD6_LV_DEB_MASK;
+       reg |= (pdata->sd1_lv_deb_time << AS3722_SD1_LV_DEB_SHIFT)
+                       & AS3722_SD1_LV_DEB_MASK;
+       reg |= (pdata->sd0_lv_deb_time << AS3722_SD0_LV_DEB_SHIFT)
+                       & AS3722_SD0_LV_DEB_MASK;
+       as3722_reg_write(as3722, AS3722_SD_LV_DEB_REG, reg);
+
+       reg = (pdata->pg_vresfall_mask << 7)
+                       & AS3722_PG_VRESFALL_MASK_MASK;
+       reg |= (pdata->pg_ovcurr_sd0_mask << 6)
+                       & AS3722_PG_OVCURR_SD0_MASK_MASK;
+       reg |= (pdata->pg_pwrgood_sd0_mask << 5)
+                       & AS3722_PG_PWRGOOD_SD0_MASK_MASK;
+       reg |= (pdata->pg_gpio5_mask << 4)
+                       & AS3722_PG_GPIO5_MASK_MASK;
+       reg |= (pdata->pg_gpio4_mask << 3)
+                       & AS3722_PG_GPIO4_MASK_MASK;
+       reg |= (pdata->pg_gpio3_mask << 2)
+                       & AS3722_PG_GPIO3_MASK_MASK;
+       reg |= (pdata->pg_ac_ok_mask << 1)
+                       & AS3722_PG_AC_OK_MASK_MASK;
+       reg |= (pdata->pg_ac_ok_inv)
+                       & AS3722_PG_AC_OK_INV_MASK;
+       as3722_reg_write(as3722, AS3722_OC_PG_CONTROL_REG, reg);
+
+       reg = (pdata->pg_ovcurr_sd6_mask << 7)
+                       & AS3722_PG_OVCURR_SD6_MASK_MASK;
+       reg |= (pdata->pg_pwrgood_sd6_mask << 6)
+                       & AS3722_PG_PWRGOOD_SD6_MASK_MASK;
+       reg |= (pdata->pg_sd6_ovc_alarm << 3)
+                       & AS3722_PG_SD6_OVC_ALARM_MASK;
+       reg |= (pdata->pg_sd0_vmask_time << 1)
+                       & AS3722_PG_SD0_VMASK_TIME_MASK;
+       reg |= (pdata->oc_pg_inv)
+                       & AS3722_OC_PG_INV_MASK;
+       as3722_reg_write(as3722, AS3722_OC_PG_CONTROL2_REG, reg);
+
+       /* enable 32kHz clock output if required */
+       if (pdata->enable_clk32out_pin)
+               as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
+                               AS3722_CLK32OUT_ENABLE_MASK,
+                               AS3722_CLK32OUT_ENABLE_ON);
+       else
+               as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
+                               AS3722_CLK32OUT_ENABLE_MASK,
+                               AS3722_CLK32OUT_ENABLE_OFF);
+       return 0;
+}
+
+static int as3722_i2c_probe(struct i2c_client *i2c,
+               const struct i2c_device_id *id)
+{
+       struct as3722 *as3722;
+       struct as3722_platform_data *pdata;
+       int irq_flags;
+       int ret;
+
+       pdata = dev_get_platdata(&i2c->dev);
+       if (!pdata) {
+               dev_err(&i2c->dev, "as3722 requires platform data\n");
+               return -EINVAL;
+       }
+
+       as3722 = devm_kzalloc(&i2c->dev, sizeof(struct as3722), GFP_KERNEL);
+       if (!as3722)
+               return -ENOMEM;
+
+       as3722->dev = &i2c->dev;
+       as3722->chip_irq = i2c->irq;
+       i2c_set_clientdata(i2c, as3722);
+
+       as3722->regmap = devm_regmap_init_i2c(i2c, &as3722_regmap_config);
+       if (IS_ERR(as3722->regmap)) {
+               ret = PTR_ERR(as3722->regmap);
+               dev_err(&i2c->dev, "regmap_init failed with err: %d\n", ret);
+               return ret;
+       }
+
+       irq_flags = pdata->irq_type;
+       irq_flags |= IRQF_ONESHOT;
+       ret = regmap_add_irq_chip(as3722->regmap, as3722->chip_irq,
+                       irq_flags, pdata->irq_base, &as3722_irq_chip,
+                       &as3722->irq_data);
+       if (ret < 0) {
+               dev_err(as3722->dev,
+                       "irq allocation failed for as3722 failed\n");
+               return ret;
+       }
+
+       ret = as3722_init(as3722, pdata, i2c->irq);
+       if (ret < 0)
+               return ret;
+
+       ret = mfd_add_devices(&i2c->dev,
+                             -1,
+                             as3722_devs,
+                             ARRAY_SIZE(as3722_devs),
+                             NULL,
+                             pdata->irq_base,
+                             regmap_irq_get_domain(as3722->irq_data));
+       if (ret) {
+               dev_err(as3722->dev,
+                       "add mfd devices failed with err: %d\n",
+                       ret);
+               return ret;
+       }
+
+       dev_info(as3722->dev,
+                "AS3722 core driver initialized successfully\n");
+
+       return 0;
+}
+
+static int as3722_i2c_remove(struct i2c_client *i2c)
+{
+       struct as3722 *as3722 = i2c_get_clientdata(i2c);
+       int irq_onkeylong, irq_onkey;
+       int irq_temp_sd0_shutdown, irq_temp_sd1_shutdown, irq_temp_sd6_shutdown;
+       int irq_temp_sd0_alarm, irq_temp_sd1_alarm, irq_temp_sd6_alarm;
+       int irq_ovtmp_alarm;
+
+       irq_onkeylong = regmap_irq_get_virq(as3722->irq_data,
+                                           AS3722_IRQ_ONKEY_LONG);
+       irq_onkey = regmap_irq_get_virq(as3722->irq_data, AS3722_IRQ_ONKEY);
+       irq_temp_sd0_shutdown =
+               regmap_irq_get_virq(as3722->irq_data,
+                                   AS3722_IRQ_TEMP_SD0_SHUTDOWN);
+       irq_temp_sd1_shutdown =
+               regmap_irq_get_virq(as3722->irq_data,
+                                   AS3722_IRQ_TEMP_SD1_SHUTDOWN);
+       irq_temp_sd6_shutdown =
+               regmap_irq_get_virq(as3722->irq_data,
+                                   AS3722_IRQ_TEMP_SD6_SHUTDOWN);
+       irq_temp_sd0_alarm =
+               regmap_irq_get_virq(as3722->irq_data,
+                                   AS3722_IRQ_TEMP_SD0_ALARM);
+       irq_temp_sd1_alarm =
+               regmap_irq_get_virq(as3722->irq_data,
+                                   AS3722_IRQ_TEMP_SD1_ALARM);
+       irq_temp_sd6_alarm =
+               regmap_irq_get_virq(as3722->irq_data,
+                                   AS3722_IRQ_TEMP_SD6_ALARM);
+       irq_ovtmp_alarm =
+               regmap_irq_get_virq(as3722->irq_data,
+                                   AS3722_IRQ_OVTMP);
+
+       free_irq(irq_onkeylong, as3722);
+       free_irq(irq_onkey, as3722);
+       free_irq(irq_temp_sd0_shutdown, as3722);
+       free_irq(irq_temp_sd1_shutdown, as3722);
+       free_irq(irq_temp_sd6_shutdown, as3722);
+       free_irq(irq_temp_sd0_alarm, as3722);
+       free_irq(irq_temp_sd1_alarm, as3722);
+       free_irq(irq_temp_sd6_alarm, as3722);
+       free_irq(irq_ovtmp_alarm, as3722);
+       mfd_remove_devices(as3722->dev);
+       regmap_del_irq_chip(as3722->chip_irq, as3722->irq_data);
+
+       return 0;
+}
+
+static const struct i2c_device_id as3722_i2c_id[] = {
+       { "as3722", 0 },
+       { }
+};
+
+MODULE_DEVICE_TABLE(i2c, as3722_i2c_id);
+
+static struct i2c_driver as3722_i2c_driver = {
+       .driver = {
+               .name = "as3722",
+               .owner = THIS_MODULE,
+       },
+       .probe = as3722_i2c_probe,
+       .remove = as3722_i2c_remove,
+       .id_table = as3722_i2c_id,
+};
+
+module_i2c_driver(as3722_i2c_driver);
+
+MODULE_DESCRIPTION("I2C, IRQ and ADC support for AS3722 PMICs");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Florian Lobmaier <florian.lobmaier@ams.com>");
diff --git a/drivers/mfd/as3722-regmap.c b/drivers/mfd/as3722-regmap.c
new file mode 100644
index 0000000..725722e
--- /dev/null
+++ b/drivers/mfd/as3722-regmap.c
@@ -0,0 +1,417 @@
+/*
+ * as3722-regmap.c - regmap for AS3722 PMICs
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
+#include <linux/mfd/as3722-reg.h>
+
+/* Default Register Values (for caching)
+ * Please make sure to update (or update cache at startup)
+ * after device is OTP programmed! */
+static struct reg_default as3722_defaults[] = {
+       { 0x0000, 0x0000 }, /* SD0 Voltage */
+       { 0x0001, 0x0000 }, /* SD1 Voltage */
+       { 0x0002, 0x0000 }, /* SD2 Voltage */
+       { 0x0003, 0x0000 }, /* SD3 Voltage */
+       { 0x0004, 0x0000 }, /* SD4 Voltage */
+       { 0x0005, 0x0000 }, /* SD5 Voltage */
+       { 0x0006, 0x0000 }, /* SD6 Voltage */
+       { 0x0008, 0x0003 }, /* GPIO0 Control */
+       { 0x0009, 0x0003 }, /* GPIO1 Control */
+       { 0x000a, 0x0003 }, /* GPIO2 Control */
+       { 0x000b, 0x0003 }, /* GPIO3 Control */
+       { 0x000c, 0x0003 }, /* GPIO4 Control */
+       { 0x000d, 0x0003 }, /* GPIO5 Control */
+       { 0x000e, 0x0003 }, /* GPIO6 Control */
+       { 0x000f, 0x0003 }, /* GPIO7 Control */
+       { 0x0010, 0x0000 }, /* LDO0 Voltage */
+       { 0x0011, 0x0000 }, /* LDO1 Voltage */
+       { 0x0012, 0x0000 }, /* LDO2 Voltage */
+       { 0x0013, 0x0000 }, /* LDO3 Voltage */
+       { 0x0014, 0x0000 }, /* LDO4 Voltage */
+       { 0x0015, 0x0000 }, /* LDO5 Voltage */
+       { 0x0016, 0x0000 }, /* LDO6 Voltage */
+       { 0x0017, 0x0000 }, /* LDO7 Voltage */
+       { 0x0019, 0x0000 }, /* LDO9 Voltage */
+       { 0x001a, 0x0000 }, /* LDO10 Voltage */
+       { 0x001b, 0x0000 }, /* LDO11 Voltage */
+       { 0x001d, 0x0000 }, /* LDO3 Settings */
+       { 0x001e, 0x0000 }, /* GPIO deb1 */
+       { 0x001f, 0x0000 }, /* GPIO deb2 */
+       { 0x0020, 0x0000 }, /* GPIO Signal Out */
+       { 0x0021, 0x0000 }, /* GPIO Signal In */
+       { 0x0022, 0x0000 }, /* Reg_sequ_mod1 */
+       { 0x0023, 0x0000 }, /* Reg_sequ_mod2 */
+       { 0x0024, 0x0000 }, /* Reg_sequ_mod3 */
+       { 0x0027, 0x0000 }, /* SD_phsw_ctrl */
+       { 0x0028, 0x0000 }, /* SD_phsw_status */
+       { 0x0029, 0x0000 }, /* SD0 Control */
+       { 0x002a, 0x0001 }, /* SD1 Control */
+       { 0x002b, 0x0000 }, /* SDmph Control */
+       { 0x002c, 0x0000 }, /* SD23 Control */
+       { 0x002d, 0x0000 }, /* SD4 Control */
+       { 0x002e, 0x0000 }, /* SD5 Control */
+       { 0x002f, 0x0001 }, /* SD6 Control */
+       { 0x0030, 0x0000 }, /* SD_dvm */
+       { 0x0031, 0x0000 }, /* Resetreason */
+       { 0x0032, 0x0000 }, /* Battery Voltage Monitor */
+       { 0x0033, 0x0000 }, /* Startup Control */
+       { 0x0034, 0x0008 }, /* RestTimer */
+       { 0x0035, 0x0000 }, /* ReferenceControl */
+       { 0x0036, 0x0000 }, /* ResetControl */
+       { 0x0037, 0x0001 }, /* OvertemperatureControl */
+       { 0x0038, 0x0000 }, /* WatchdogControl */
+       { 0x0039, 0x0000 }, /* Reg_standby_mod1 */
+       { 0x003a, 0x0000 }, /* Reg_standby_mod2 */
+       { 0x003b, 0x0000 }, /* Reg_standby_mod3 */
+       { 0x003c, 0x0000 }, /* Enable Control 1 */
+       { 0x003d, 0x0000 }, /* Enable Control 2 */
+       { 0x003e, 0x0000 }, /* Enable Control 3 */
+       { 0x003f, 0x0000 }, /* Enable Control 4 */
+       { 0x0040, 0x0000 }, /* Enable Control 5 */
+       { 0x0041, 0x0000 }, /* PWM Control low */
+       { 0x0042, 0x0000 }, /* PWM Control high */
+       { 0x0046, 0x0000 }, /* Watchdog Timer */
+       { 0x0048, 0x0000 }, /* Watchdog Software Signal */
+       { 0x0049, 0x0000 }, /* IO Voltage */
+       { 0x004a, 0x0000 }, /* Battery_voltage_monitor2 */
+       { 0x004d, 0x007f }, /* SDcontrol */
+       { 0x004e, 0x00ff }, /* LDOcontrol0 */
+       { 0x004f, 0x000e }, /* LDOcontrol1 */
+       { 0x0050, 0x0000 }, /* SD0_protect */
+       { 0x0051, 0x0000 }, /* SD6_protect */
+       { 0x0052, 0x0000 }, /* PWM_vcontrol1 */
+       { 0x0053, 0x0000 }, /* PWM_vcontrol2 */
+       { 0x0054, 0x0000 }, /* PWM_vcontrol3 */
+       { 0x0055, 0x0000 }, /* PWM_vcontrol4 */
+       { 0x0057, 0x0040 }, /* BBcharger */
+       { 0x0058, 0x0000 }, /* CTRLsequ1 */
+       { 0x0059, 0x0000 }, /* CTRLsequ2 */
+       { 0x005a, 0x0000 }, /* OVcurrent */
+       { 0x005b, 0x0000 }, /* OVcurrent_deb */
+       { 0x005c, 0x0000 }, /* SDlv_deb */
+       { 0x005d, 0x0000 }, /* OC_pg_ctrl */
+       { 0x005e, 0x0000 }, /* OC_pg_ctrl2 */
+       { 0x005f, 0x0000 }, /* CTRLstatus */
+       { 0x0060, 0x0020 }, /* RTC Control */
+       { 0x0061, 0x0000 }, /* RTCsecond */
+       { 0x0062, 0x0000 }, /* RTCminute */
+       { 0x0063, 0x0000 }, /* RTChour */
+       { 0x0064, 0x0001 }, /* RTCday */
+       { 0x0065, 0x0001 }, /* RTCmonth */
+       { 0x0066, 0x0000 }, /* RTCyear */
+       { 0x0067, 0x0000 }, /* RTCAlarmsecond */
+       { 0x0068, 0x0000 }, /* RTCAlarmminute */
+       { 0x0069, 0x0000 }, /* RTCAlarmhour */
+       { 0x006a, 0x003f }, /* RTCAlarmday */
+       { 0x006b, 0x001f }, /* RTCAlarmmonth */
+       { 0x006c, 0x007f }, /* RTCAlarmyear */
+       { 0x006d, 0x0000 }, /* SRAM */
+       { 0x006f, 0x0000 }, /* RTC_Access */
+       { 0x0073, 0x0000 }, /* RegStatus */
+       { 0x0074, 0x00ff }, /* InterruptMask1 */
+       { 0x0075, 0x00ff }, /* InterruptMask2 */
+       { 0x0076, 0x00ff }, /* InterruptMask3 */
+       { 0x0077, 0x00ff }, /* InterruptMask4 */
+       { 0x0080, 0x0000 }, /* ADC0 Control */
+       { 0x0081, 0x0000 }, /* ADC1 Control */
+       { 0x0086, 0x007f }, /* ADC1 threshold hi MSB */
+       { 0x0087, 0x0007 }, /* ADC1 threshold hi LSB */
+       { 0x0088, 0x0000 }, /* ADC1 threshold lo MSB */
+       { 0x0089, 0x0000 }, /* ADC1 threshold lo LSB */
+       { 0x008a, 0x0000 }, /* ADC Configuration */
+};
+
+/*
+ * Access masks.
+ */
+static bool as3722_readable(struct device *dev, unsigned int reg)
+{
+       switch (reg) {
+       case AS3722_SD0_VOLTAGE_REG:
+       case AS3722_SD1_VOLTAGE_REG:
+       case AS3722_SD2_VOLTAGE_REG:
+       case AS3722_SD3_VOLTAGE_REG:
+       case AS3722_SD4_VOLTAGE_REG:
+       case AS3722_SD5_VOLTAGE_REG:
+       case AS3722_SD6_VOLTAGE_REG:
+       case AS3722_GPIO0_CONTROL_REG:
+       case AS3722_GPIO1_CONTROL_REG:
+       case AS3722_GPIO2_CONTROL_REG:
+       case AS3722_GPIO3_CONTROL_REG:
+       case AS3722_GPIO4_CONTROL_REG:
+       case AS3722_GPIO5_CONTROL_REG:
+       case AS3722_GPIO6_CONTROL_REG:
+       case AS3722_GPIO7_CONTROL_REG:
+       case AS3722_LDO0_VOLTAGE_REG:
+       case AS3722_LDO1_VOLTAGE_REG:
+       case AS3722_LDO2_VOLTAGE_REG:
+       case AS3722_LDO3_VOLTAGE_REG:
+       case AS3722_LDO4_VOLTAGE_REG:
+       case AS3722_LDO5_VOLTAGE_REG:
+       case AS3722_LDO6_VOLTAGE_REG:
+       case AS3722_LDO7_VOLTAGE_REG:
+       case AS3722_LDO9_VOLTAGE_REG:
+       case AS3722_LDO10_VOLTAGE_REG:
+       case AS3722_LDO11_VOLTAGE_REG:
+       case 0x1d:
+       case 0x1e:
+       case 0x1f:
+       case AS3722_GPIO_SIGNAL_OUT_REG:
+       case AS3722_GPIO_SIGNAL_IN_REG:
+       case 0x22:
+       case 0x23:
+       case 0x24:
+       case 0x27:
+       case 0x28:
+       case AS3722_SD0_CONTROL_REG:
+       case AS3722_SD1_CONTROL_REG:
+       case AS3722_SDmph_CONTROL_REG:
+       case AS3722_SD23_CONTROL_REG:
+       case AS3722_SD4_CONTROL_REG:
+       case AS3722_SD5_CONTROL_REG:
+       case AS3722_SD6_CONTROL_REG:
+       case 0x30:
+       case 0x31:
+       case 0x32:
+       case 0x33:
+       case 0x34:
+       case 0x35:
+       case 0x36:
+       case 0x37:
+       case AS3722_WATCHDOG_CONTROL_REG:
+       case 0x39:
+       case 0x3a:
+       case 0x3b:
+       case 0x3c:
+       case 0x3d:
+       case 0x3e:
+       case 0x3f:
+       case 0x40:
+       case 0x41:
+       case 0x42:
+       case AS3722_WATCHDOG_TIMER_REG:
+       case AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG:
+       case AS3722_IOVOLTAGE_REG:
+       case 0x4a:
+       case AS3722_SD_CONTROL_REG:
+       case AS3722_LDOCONTROL0_REG:
+       case AS3722_LDOCONTROL1_REG:
+       case 0x50:
+       case 0x51:
+       case 0x52:
+       case 0x53:
+       case 0x54:
+       case 0x55:
+       case 0x57:
+       case AS3722_CTRL1_REG:
+       case AS3722_CTRL2_REG:
+       case 0x5a:
+       case 0x5b:
+       case 0x5c:
+       case 0x5d:
+       case 0x5e:
+       case 0x5f:
+       case AS3722_RTC_CONTROL_REG:
+       case AS3722_RTC_SECOND_REG:
+       case AS3722_RTC_MINUTE_REG:
+       case AS3722_RTC_HOUR_REG:
+       case AS3722_RTC_DAY_REG:
+       case AS3722_RTC_MONTH_REG:
+       case AS3722_RTC_YEAR_REG:
+       case AS3722_RTC_ALARM_SECOND_REG:
+       case AS3722_RTC_ALARM_MINUTE_REG:
+       case AS3722_RTC_ALARM_HOUR_REG:
+       case AS3722_RTC_ALARM_DAY_REG:
+       case AS3722_RTC_ALARM_MONTH_REG:
+       case AS3722_RTC_ALARM_YEAR_REG:
+       case 0x6d:
+       case 0x6f:
+       case 0x73:
+       case AS3722_INTERRUPTMASK1_REG:
+       case AS3722_INTERRUPTMASK2_REG:
+       case AS3722_INTERRUPTMASK3_REG:
+       case AS3722_INTERRUPTMASK4_REG:
+       case AS3722_INTERRUPTSTATUS1_REG:
+       case AS3722_INTERRUPTSTATUS2_REG:
+       case AS3722_INTERRUPTSTATUS3_REG:
+       case AS3722_INTERRUPTSTATUS4_REG:
+       case 0x7d:
+       case AS3722_ADC0_CONTROL_REG:
+       case AS3722_ADC1_CONTROL_REG:
+       case AS3722_ADC0_MSB_RESULT_REG:
+       case AS3722_ADC0_LSB_RESULT_REG:
+       case AS3722_ADC1_MSB_RESULT_REG:
+       case AS3722_ADC1_LSB_RESULT_REG:
+       case AS3722_ADC1_THRESHOLD_HI_MSB_REG:
+       case AS3722_ADC1_THRESHOLD_HI_LSB_REG:
+       case AS3722_ADC1_THRESHOLD_LO_MSB_REG:
+       case AS3722_ADC1_THRESHOLD_LO_LSB_REG:
+       case AS3722_ADC_CONFIG_REG:
+       case AS3722_ADDR_ASIC_ID1:
+       case AS3722_ADDR_ASIC_ID2:
+               return true;
+       default:
+               return false;
+       }
+}
+
+static bool as3722_writeable(struct device *dev, unsigned int reg)
+{
+       switch (reg) {
+       case AS3722_SD0_VOLTAGE_REG:
+       case AS3722_SD1_VOLTAGE_REG:
+       case AS3722_SD2_VOLTAGE_REG:
+       case AS3722_SD3_VOLTAGE_REG:
+       case AS3722_SD4_VOLTAGE_REG:
+       case AS3722_SD5_VOLTAGE_REG:
+       case AS3722_SD6_VOLTAGE_REG:
+       case AS3722_GPIO0_CONTROL_REG:
+       case AS3722_GPIO1_CONTROL_REG:
+       case AS3722_GPIO2_CONTROL_REG:
+       case AS3722_GPIO3_CONTROL_REG:
+       case AS3722_GPIO4_CONTROL_REG:
+       case AS3722_GPIO5_CONTROL_REG:
+       case AS3722_GPIO6_CONTROL_REG:
+       case AS3722_GPIO7_CONTROL_REG:
+       case AS3722_LDO0_VOLTAGE_REG:
+       case AS3722_LDO1_VOLTAGE_REG:
+       case AS3722_LDO2_VOLTAGE_REG:
+       case AS3722_LDO3_VOLTAGE_REG:
+       case AS3722_LDO4_VOLTAGE_REG:
+       case AS3722_LDO5_VOLTAGE_REG:
+       case AS3722_LDO6_VOLTAGE_REG:
+       case AS3722_LDO7_VOLTAGE_REG:
+       case AS3722_LDO9_VOLTAGE_REG:
+       case AS3722_LDO10_VOLTAGE_REG:
+       case AS3722_LDO11_VOLTAGE_REG:
+       case 0x1d:
+       case 0x1e:
+       case 0x1f:
+       case AS3722_GPIO_SIGNAL_OUT_REG:
+       case 0x22:
+       case 0x23:
+       case 0x24:
+       case 0x27:
+       case 0x28:
+       case AS3722_SD0_CONTROL_REG:
+       case AS3722_SD1_CONTROL_REG:
+       case AS3722_SDmph_CONTROL_REG:
+       case AS3722_SD23_CONTROL_REG:
+       case AS3722_SD4_CONTROL_REG:
+       case AS3722_SD5_CONTROL_REG:
+       case AS3722_SD6_CONTROL_REG:
+       case 0x30:
+       case 0x31:
+       case 0x32:
+       case 0x33:
+       case 0x34:
+       case 0x35:
+       case 0x36:
+       case 0x37:
+       case AS3722_WATCHDOG_CONTROL_REG:
+       case 0x39:
+       case 0x3a:
+       case 0x3b:
+       case 0x3c:
+       case 0x3d:
+       case 0x3e:
+       case 0x3f:
+       case 0x40:
+       case 0x41:
+       case 0x42:
+       case AS3722_WATCHDOG_TIMER_REG:
+       case AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG:
+       case AS3722_IOVOLTAGE_REG:
+       case 0x4a:
+       case AS3722_SD_CONTROL_REG:
+       case AS3722_LDOCONTROL0_REG:
+       case AS3722_LDOCONTROL1_REG:
+       case 0x50:
+       case 0x51:
+       case 0x52:
+       case 0x53:
+       case 0x54:
+       case 0x55:
+       case 0x57:
+       case AS3722_CTRL1_REG:
+       case AS3722_CTRL2_REG:
+       case 0x5a:
+       case 0x5b:
+       case 0x5c:
+       case 0x5d:
+       case 0x5e:
+       case AS3722_RTC_CONTROL_REG:
+       case AS3722_RTC_SECOND_REG:
+       case AS3722_RTC_MINUTE_REG:
+       case AS3722_RTC_HOUR_REG:
+       case AS3722_RTC_DAY_REG:
+       case AS3722_RTC_MONTH_REG:
+       case AS3722_RTC_YEAR_REG:
+       case AS3722_RTC_ALARM_SECOND_REG:
+       case AS3722_RTC_ALARM_MINUTE_REG:
+       case AS3722_RTC_ALARM_HOUR_REG:
+       case AS3722_RTC_ALARM_DAY_REG:
+       case AS3722_RTC_ALARM_MONTH_REG:
+       case AS3722_RTC_ALARM_YEAR_REG:
+       case 0x6d:
+       case 0x6f:
+       case AS3722_INTERRUPTMASK1_REG:
+       case AS3722_INTERRUPTMASK2_REG:
+       case AS3722_INTERRUPTMASK3_REG:
+       case AS3722_INTERRUPTMASK4_REG:
+       case AS3722_INTERRUPTSTATUS1_REG:
+       case AS3722_INTERRUPTSTATUS2_REG:
+       case AS3722_INTERRUPTSTATUS3_REG:
+       case AS3722_INTERRUPTSTATUS4_REG:
+       case 0x7d:
+       case AS3722_ADC0_CONTROL_REG:
+       case AS3722_ADC1_CONTROL_REG:
+       case AS3722_ADC1_THRESHOLD_HI_MSB_REG:
+       case AS3722_ADC1_THRESHOLD_HI_LSB_REG:
+       case AS3722_ADC1_THRESHOLD_LO_MSB_REG:
+       case AS3722_ADC1_THRESHOLD_LO_LSB_REG:
+       case AS3722_ADC_CONFIG_REG:
+               return true;
+       default:
+               return false;
+       }
+}
+
+static bool as3722_volatile(struct device *dev, unsigned int reg)
+{
+       return false;
+}
+
+const struct regmap_config as3722_regmap_config = {
+       .reg_bits = 8,
+       .val_bits = 8,
+
+       .cache_type = REGCACHE_RBTREE,
+
+       .max_register = AS3722_REGISTER_COUNT,
+       .readable_reg = as3722_readable,
+       .writeable_reg = as3722_writeable,
+       .volatile_reg = as3722_volatile,
+
+       .reg_defaults = as3722_defaults,
+       .num_reg_defaults = ARRAY_SIZE(as3722_defaults),
+};

---

-----Original Message-----
From: Lee Jones [mailto:lee.jones@linaro.org]
Sent: Donnerstag, 23. Mai 2013 16:22
To: Florian Lobmaier
Cc: sameo@linux.intel.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/07] mfd patch of ams AS3722 PMIC against linux_3.8.8

On Thu, 23 May 2013, Florian Lobmaier wrote:

> From: Florian Lobmaier <florian.lobmaier@ams.com>
>
> Added multi-function device driver support for ams AS3722 PMIC
> Includes modules gpio, regulator, rtc, and watchdog
>
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
>
> ---
> diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/mfd/as3722-core.c ./drivers/mfd/as3722-core.c
> --- ../kernel_3.8.8/linux-kernel/drivers/mfd/as3722-core.c      1970-01-01 01:00:00.000000000 +0100
> +++ ./drivers/mfd/as3722-core.c 2013-05-23 13:12:36.000000000 +0200
> @@ -0,0 +1,514 @@

Eh? Can you use Git to format your patches?

> +/*
> + * as3722-core.c - core driver for AS3722 PMICs
> + *
> + * Copyright (C) 2013 ams AG
> + *
> + * Author: Florian Lobmaier <florian.lobmaier@ams.com>
> + *
> + * This program is free software; you can redistribute it and/or
> +modify
> + * it under the terms of the GNU General Public License as published
> +by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> +02111-1307 USA
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/regmap.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/core.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/as3722-reg.h>
> +#include <linux/mfd/as3722-plat.h>
> +
> +#define AS3722_DRIVER_VERSION  "v0.9.2"

Are you sure you want this in the upstream version?

> +enum as3722_ids {
> +       AS3722_GPIO_ID,
> +       AS3722_REGULATOR_ID,
> +       AS3722_RTC_ID,
> +       AS3722_WATCHDOG_ID,
> +};
> +
> +static const struct resource as3722_rtc_resource[] = {
> +       {
> +               .name = "as3722-rtc-alarm",
> +               .start = AS3722_IRQ_RTC_ALARM,
> +               .end = AS3722_IRQ_RTC_ALARM,
> +               .flags = IORESOURCE_IRQ,
> +       },
> +};
> +
> +static const struct resource as3722_wdt_resource[] = {
> +       {
> +               .name = "as3722-watchdog-irq",

Drop the -irq.

> +               .start = AS3722_IRQ_WATCHDOG,
> +               .end = AS3722_IRQ_WATCHDOG,
> +               .flags = IORESOURCE_IRQ,
> +       },
> +};
> +
> +static struct mfd_cell as3722_devs[] = {
> +       {
> +               .name = "as3722-gpio",
> +               .id = AS3722_GPIO_ID,
> +       },
> +       {
> +               .name = "as3722-regulator",
> +               .id = AS3722_REGULATOR_ID,
> +       },
> +       {
> +               .name = "as3722-rtc",
> +               .num_resources = ARRAY_SIZE(as3722_rtc_resource),
> +               .resources = as3722_rtc_resource,
> +               .id = AS3722_RTC_ID,
> +       },
> +       {
> +               .name = "as3722-wdt",
> +               .num_resources = ARRAY_SIZE(as3722_wdt_resource),
> +               .resources = as3722_wdt_resource,
> +               .id = AS3722_WATCHDOG_ID,
> +       },
> +};
> +
> +static const struct regmap_irq as3722_irqs[] = {
> +       /* INT1 IRQs */
> +       [AS3722_IRQ_LID] = {
> +               .mask = AS3722_IRQ_MASK_LID,
> +       },
> +       [AS3722_IRQ_ACOK] = {
> +               .mask = AS3722_IRQ_MASK_ACOK,
> +       },
> +       [AS3722_IRQ_ENABLE1] = {
> +               .mask = AS3722_IRQ_MASK_ENABLE1,
> +       },
> +       [AS3722_IRQ_SD0] = {
> +               .mask = AS3722_IRQ_MASK_SD0,
> +       },
> +       [AS3722_IRQ_ONKEY_LONG] = {
> +               .mask = AS3722_IRQ_MASK_ONKEY_LONG,
> +       },
> +       [AS3722_IRQ_ONKEY] = {
> +               .mask = AS3722_IRQ_MASK_ONKEY,
> +       },
> +       [AS3722_IRQ_OVTMP] = {
> +               .mask = AS3722_IRQ_MASK_OVTMP,
> +       },
> +       [AS3722_IRQ_LOWBAT] = {
> +               .mask = AS3722_IRQ_MASK_LOWBAT,
> +       },
> +       [AS3722_IRQ_RTC_REP] = {
> +               .mask = AS3722_IRQ_MASK_RTC_REP,
> +               .reg_offset = 1,
> +       },
> +       [AS3722_IRQ_RTC_ALARM] = {
> +               .mask = AS3722_IRQ_MASK_RTC_ALARM,
> +               .reg_offset = 2,
> +       },
> +       [AS3722_IRQ_WATCHDOG] = {
> +               .mask = AS3722_IRQ_MASK_WATCHDOG,
> +               .reg_offset = 2,
> +       },
> +       [AS3722_IRQ_ADC] = {
> +               .mask = AS3722_IRQ_MASK_ADC,
> +               .reg_offset = 3,
> +       },
> +       [AS3722_IRQ_GPIO1] = {
> +               .mask = AS3722_IRQ_MASK_GPIO1,
> +               .reg_offset = 2,
> +       },
> +       [AS3722_IRQ_GPIO2] = {
> +               .mask = AS3722_IRQ_MASK_GPIO2,
> +               .reg_offset = 2,
> +       },
> +       [AS3722_IRQ_GPIO3] = {
> +               .mask = AS3722_IRQ_MASK_GPIO3,
> +               .reg_offset = 2,
> +       },
> +       [AS3722_IRQ_GPIO4] = {
> +               .mask = AS3722_IRQ_MASK_GPIO4,
> +               .reg_offset = 2,
> +       },
> +       [AS3722_IRQ_GPIO5] = {
> +               .mask = AS3722_IRQ_MASK_GPIO5,
> +               .reg_offset = 2,
> +       },
> +};
> +
> +static struct regmap_irq_chip as3722_irq_chip = {
> +       .name = "as3722",
> +       .irqs = as3722_irqs,
> +       .num_irqs = ARRAY_SIZE(as3722_irqs),
> +       .num_regs = 4,
> +       .status_base = AS3722_INTERRUPTSTATUS1_REG,
> +       .mask_base = AS3722_INTERRUPTMASK1_REG,
> +       .wake_base = 1,
> +};
> +
> +static void as3722_reg_init(struct as3722 *as3722,
> +               struct as3722_reg_init *reg_data) {
> +       int ret;
> +
> +       while (reg_data->reg != AS3722_REG_INIT_TERMINATE) {
> +               ret = as3722_reg_write(as3722, reg_data->reg, reg_data->val);
> +               if (ret) {
> +                       dev_err(as3722->dev,
> +                                       "reg setup failed: %d\n", ret);
> +                       return;
> +               }
> +               reg_data++;
> +       }
> +}
> +
> +int as3722_read_adc(struct as3722 *as3722,
> +               enum as3722_adc_channel channel,
> +               enum as3722_adc_source source,
> +               enum as3722_adc_voltange_range voltage_range) {
> +       int result = 0;
> +       unsigned int try_counter = 0;
> +       u32 val;
> +
> +       mutex_lock(&as3722->adc_mutex);
> +       /* select source */
> +       as3722_set_bits(as3722,
> +                       AS3722_ADC0_CONTROL_REG + channel,
> +                       AS3722_ADC_MASK_SOURCE_SELECT,
> +                       source);
> +       /* select voltage range */
> +       as3722_set_bits(as3722,
> +                       AS3722_ADC0_CONTROL_REG + channel,
> +                       AS3722_ADC_MASK_VOLTAGE_RANGE,
> +                       voltage_range << AS3722_ADC_SHIFT_VOLTAGE_RANGE);
> +       /* start conversion */
> +       as3722_set_bits(as3722,
> +                       AS3722_ADC0_CONTROL_REG + channel,
> +                       AS3722_ADC_MASK_CONV_START,
> +                       AS3722_ADC_BIT_CONV_START);
> +
> +       /* check if result ready
> +        * as no HW interrupt is available for that we have to poll
> +        * the status bit. Should be available on the next I2C read
> +        * at 400kHz I2C speed, so no threaded polling required.
> +        */

Grammar is a bit all over the place in this comment.

Also, leave the top line blank:

The preferred style for long (multi-line) comments is:

        /*
         * This is the preferred style for multi-line
         * comments in the Linux kernel source code.
         * Please use it consistently.
         *
         * Description:  A column of asterisks on the left side,
         * with beginning and ending almost-blank lines.
         */

> +       try_counter = 0;
> +       do {
> +               as3722_reg_read(as3722,
> +                               AS3722_ADC0_MSB_RESULT_REG +
> + 2*channel,

Why 2*channel? Perhaps a small comment would be useful. Also stick some brackets in there to clear up the logic a little.

> +                               &val);
> +               try_counter++;
> +       } while (
> +               ((val & AS3722_ADC_MASK_CONV_NOTREADY)
> +                       == AS3722_ADC_BIT_CONV_NOTREADY)
> +               && (try_counter < 10)

Yuck! Can you find a better way to do this please?

Perhaps put the logic in the look and break out when you need to.

Why 10?

> +               );
> +
> +       /* read result, MSB byte already available from last read */
> +       result = ((val & AS3722_ADC_MASK_MSB_VAL) << 8);
> +       as3722_reg_read(as3722,
> +                       AS3722_ADC0_LSB_RESULT_REG + 2*channel,
> +                       &val);
> +       result += (val & AS3722_ADC_MASK_LSB_VAL);
> +
> +       mutex_unlock(&as3722->adc_mutex);
> +
> +       return result;
> +}
> +EXPORT_SYMBOL_GPL(as3722_read_adc);
> +
> +static irqreturn_t as3722_onkey_press_irq(int irq, void *irq_data) {
> +       struct as3722 *as3722 = irq_data;
> +
> +       dev_info(as3722->dev, "AS3722 ONKEY pressed\n");

I think this is debug is it not? dev_dbg() instead?

> +       return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t as3722_onkey_lpress_irq(int irq, void *irq_data) {
> +       struct as3722 *as3722 = irq_data;
> +
> +       dev_info(as3722->dev, "AS3722 ONKEY long pressed\n");

As above.

> +       return IRQ_HANDLED;
> +}
> +
> +static int as3722_init(struct as3722 *as3722,
> +               struct as3722_platform_data *pdata, int irq) {
> +       u32 reg;
> +       int ret;
> +
> +       /* Check that this is actually a AS3722 */
> +       ret = regmap_read(as3722->regmap, AS3722_ADDR_ASIC_ID1, &reg);
> +       if (ret != 0) {

if (ret)

> +               dev_err(as3722->dev,
> +                               "Chip ID register read failed\n");

Your tabbing looks a little wild here.

> +               return -EIO;

Better to return ret?

> +       }
> +       if (reg != AS3722_DEVICE_ID) {
> +               dev_err(as3722->dev,
> +                               "Device is not an AS3722, ID is 0x%x\n"
> +                               , reg);

Tabbing again and a floating comma, which should be on the line above.

> +               return -ENODEV;
> +       }
> +
> +       ret = regmap_read(as3722->regmap, AS3722_ADDR_ASIC_ID2, &reg);
> +       if (ret < 0) {

Why is this different to the return error check of the regmap_read() above?

> +               dev_err(as3722->dev,
> +                               "ID2 register read failed: %d\n",
> + ret);

More wild tabbing.

> +               return ret;
> +       }
> +       dev_info(as3722->dev, "AS3722 with revision %x found\n",
> +                       reg);

Why is reg on a new line?

> +
> +       /* init adc mutex */
> +       mutex_init(&as3722->adc_mutex);
> +
> +       /* request irqs for onkey */
> +       if (as3722->irq_data) {
> +               ret = request_threaded_irq(regmap_irq_get_virq(
> +                                               as3722->irq_data,
> +                                               AS3722_IRQ_ONKEY),

This is pretty messy, can you break out the regmap_irq_get_virq() call?

> +                                               NULL, as3722_onkey_press_irq,
> +                                               pdata->irq_type,
> +                                               "onkey-press",
> + as3722);

More random tabbing. It would be better if you could align with the '('.

> +               if (ret < 0)
> +                       dev_warn(as3722->dev,
> +                               "Failed to request ONKEY IRQ: %d\n",
> + ret);

Nearly. :)

> +               ret = request_threaded_irq(regmap_irq_get_virq(
> +                                               as3722->irq_data,
> +
> + AS3722_IRQ_ONKEY_LONG),

Please break this out.

> +                                               NULL, as3722_onkey_lpress_irq,
> +                                               pdata->irq_type,
> +                                               "onkey-lpress", as3722);
> +               if (ret < 0)
> +                       dev_warn(as3722->dev,
> +                               "Failed to request ONKEY_LONG IRQ: %d\n",
> +                               ret);

So close...

> +       }
> +
> +       /* do some initial platform register setup */
> +       if (pdata->core_init_data)
> +               as3722_reg_init(as3722, pdata->core_init_data);
> +
> +       /* initialise stby reg count variable */
> +       as3722->reg_stby_counter = 0;

Where is this used?

> +
> +       /* enable pullups if required */
> +       if (pdata->use_internal_int_pullup == 1)

Is this a bool? If so, why not drop the " == 1"?

> +               as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
> +                               AS3722_INT_PULLUP_MASK,
> +                               AS3722_INT_PULLUP_ON);
> +       else
> +               as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
> +                               AS3722_INT_PULLUP_MASK,
> +                               AS3722_INT_PULLUP_OFF);

New line here for readability.

> +       if (pdata->use_internal_i2c_pullup == 1)

Is this a bool? If so, why not drop the " == 1"?

> +               as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
> +                               AS3722_I2C_PULLUP_MASK,
> +                               AS3722_I2C_PULLUP_ON);
> +       else
> +               as3722_set_bits(as3722, AS3722_IOVOLTAGE_REG,
> +                               AS3722_I2C_PULLUP_MASK,
> +                               AS3722_I2C_PULLUP_OFF);
> +
> +       /* enable1 pin standby configuration */
> +       if (pdata->enable1_deepsleep)
> +               as3722_set_bits(as3722, AS3722_CTRL1_REG,
> +                               AS3722_ENABLE1_DEEPSLEEP_MASK,
> +                               AS3722_ENABLE1_DEEPSLEEP_ON);
> +       else
> +               as3722_set_bits(as3722, AS3722_CTRL1_REG,
> +                               AS3722_ENABLE1_DEEPSLEEP_MASK,
> +                               AS3722_ENABLE1_DEEPSLEEP_OFF);

New line separator here.

> +       if (pdata->enable1_invert)
> +               as3722_set_bits(as3722, AS3722_CTRL1_REG,
> +                               AS3722_ENABLE1_INVERT_MASK,
> +                               AS3722_ENABLE1_INVERT_ON);
> +       else
> +               as3722_set_bits(as3722, AS3722_CTRL1_REG,
> +                               AS3722_ENABLE1_INVERT_MASK,
> +                               AS3722_ENABLE1_INVERT_OFF);

What about doing this instead:

        state = pdata->enable1_invert ? AS3722_ENABLE1_INVERT_ON :
                                        AS3722_ENABLE1_INVERT_OFF;

        as3722_set_bits(as3722, AS3722_CTRL1_REG,
                        AS3722_ENABLE1_INVERT_MASK,
                        state);


> +       as3722_set_bits(as3722, AS3722_RESETTIMER_REG,
> +                       AS3722_OFF_DELAY_MASK,
> +                       pdata->off_delay << AS3722_OFF_DELAY_SHIFT);
> +
> +       /* overcurrent/powergood configuration */
> +       reg = (pdata->pg_sd6_vmask_time << AS3722_PG_SD6_VMASK_TIME_SHIFT)
> +                       & AS3722_PG_SD6_VMASK_TIME_MASK;
> +       reg |= (pdata->sd6_lv_deb_time << AS3722_SD6_LV_DEB_SHIFT)
> +                       & AS3722_SD6_LV_DEB_MASK;
> +       reg |= (pdata->sd1_lv_deb_time << AS3722_SD1_LV_DEB_SHIFT)
> +                       & AS3722_SD1_LV_DEB_MASK;
> +       reg |= (pdata->sd0_lv_deb_time << AS3722_SD0_LV_DEB_SHIFT)
> +                       & AS3722_SD0_LV_DEB_MASK;
> +       as3722_reg_write(as3722, AS3722_SD_LV_DEB_REG, reg);
> +
> +       reg = (pdata->pg_vresfall_mask << 7)
> +                       & AS3722_PG_VRESFALL_MASK_MASK;
> +       reg |= (pdata->pg_ovcurr_sd0_mask << 6)
> +                       & AS3722_PG_OVCURR_SD0_MASK_MASK;
> +       reg |= (pdata->pg_pwrgood_sd0_mask << 5)
> +                       & AS3722_PG_PWRGOOD_SD0_MASK_MASK;
> +       reg |= (pdata->pg_gpio5_mask << 4)
> +                       & AS3722_PG_GPIO5_MASK_MASK;
> +       reg |= (pdata->pg_gpio4_mask << 3)
> +                       & AS3722_PG_GPIO4_MASK_MASK;
> +       reg |= (pdata->pg_gpio3_mask << 2)
> +                       & AS3722_PG_GPIO3_MASK_MASK;
> +       reg |= (pdata->pg_ac_ok_mask << 1)
> +                       & AS3722_PG_AC_OK_MASK_MASK;
> +       reg |= (pdata->pg_ac_ok_inv)
> +                       & AS3722_PG_AC_OK_INV_MASK;
> +       as3722_reg_write(as3722, AS3722_OC_PG_CONTROL_REG, reg);
> +
> +       reg = (pdata->pg_ovcurr_sd6_mask << 7)
> +                       & AS3722_PG_OVCURR_SD6_MASK_MASK;
> +       reg |= (pdata->pg_pwrgood_sd6_mask << 6)
> +                       & AS3722_PG_PWRGOOD_SD6_MASK_MASK;
> +       reg |= (pdata->pg_sd6_ovc_alarm << 3)
> +                       & AS3722_PG_SD6_OVC_ALARM_MASK;
> +       reg |= (pdata->pg_sd0_vmask_time << 1)
> +                       & AS3722_PG_SD0_VMASK_TIME_MASK;
> +       reg |= (pdata->oc_pg_inv)
> +                       & AS3722_OC_PG_INV_MASK;
> +       as3722_reg_write(as3722, AS3722_OC_PG_CONTROL2_REG, reg);
> +
> +       /* enable 32kHz clock output if required */
> +       if (pdata->enable_clk32out_pin == 1)

Is this a bool?

> +               as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
> +                               AS3722_CLK32OUT_ENABLE_MASK,
> +                               AS3722_CLK32OUT_ENABLE_ON);
> +       else
> +               as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
> +                               AS3722_CLK32OUT_ENABLE_MASK,
> +                               AS3722_CLK32OUT_ENABLE_OFF);

How about using the code I provided above for all of these?

> +       return 0;
> +}
> +
> +static int as3722_i2c_probe(struct i2c_client *i2c,
> +               const struct i2c_device_id *id) {
> +       struct as3722 *as3722;
> +       struct as3722_platform_data *pdata;
> +       int irq_flags;
> +       int ret;
> +
> +       pdata = dev_get_platdata(&i2c->dev);
> +       if (!pdata) {
> +               dev_err(&i2c->dev, "as3722 requires platform data\n");
> +               return -EINVAL;
> +       }
> +
> +       as3722 = devm_kzalloc(&i2c->dev, sizeof(struct as3722), GFP_KERNEL);
> +       if (as3722 == NULL) {

How about: if (!as3722) {

> +               dev_err(&i2c->dev, "mem alloc for as3722 failed\n");

Do we really need to know if we've run out of memory? I'm sure it would be obvious. Just return -ENOMEM.

> +               return -ENOMEM;
> +       }
> +
> +       as3722->dev = &i2c->dev;
> +       as3722->chip_irq = i2c->irq;
> +       i2c_set_clientdata(i2c, as3722);
> +
> +       as3722->regmap = devm_regmap_init_i2c(i2c, &as3722_regmap_config);
> +       if (IS_ERR(as3722->regmap)) {
> +               ret = PTR_ERR(as3722->regmap);
> +               dev_err(&i2c->dev, "regmap_init failed with err: %d\n", ret);
> +               return ret;
> +       }
> +
> +       irq_flags = pdata->irq_type;
> +       irq_flags |= IRQF_ONESHOT;
> +       ret = regmap_add_irq_chip(as3722->regmap, as3722->chip_irq,
> +                       irq_flags, pdata->irq_base, &as3722_irq_chip,
> +                       &as3722->irq_data);
> +       if (ret < 0) {
> +               dev_err(as3722->dev,
> +                               "irq allocation failed for as3722
> + failed\n");

Random tabbing.

Ah, I see, it's exactly 3 tabs.

I think it's better to align with something instead.

> +               return ret;
> +       }
> +
> +       ret = as3722_init(as3722, pdata, i2c->irq);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = mfd_add_devices(&i2c->dev, -1, as3722_devs,
> +                       ARRAY_SIZE(as3722_devs), NULL,
> +                       pdata->irq_base,
> +                       regmap_irq_get_domain(as3722->irq_data));

I'm just thinking aloud here, but what happens if
regmap_irq_get_domain() returns an error?

> +       if (ret) {
> +               dev_err(as3722->dev, "add mfd devices failed with err: %d\n",
> +                               ret);
> +               return ret;
> +       }
> +
> +       dev_info(as3722->dev,
> +                       "AS3722 core driver %s initialized successfully\n",
> +                       AS3722_DRIVER_VERSION);
> +
> +       return 0;
> +}
> +
> +static int as3722_i2c_remove(struct i2c_client *i2c) {
> +       struct as3722 *as3722 = i2c_get_clientdata(i2c);
> +
> +       free_irq(regmap_irq_get_virq(as3722->irq_data, AS3722_IRQ_ONKEY_LONG),
> +                       as3722);
> +       free_irq(regmap_irq_get_virq(as3722->irq_data, AS3722_IRQ_ONKEY),
> +                       as3722);

Wow, that's messy. Any chance you can break these out?

Even better, if you use devm_* you won't have to free them at all.

> +       mfd_remove_devices(as3722->dev);
> +       regmap_del_irq_chip(as3722->chip_irq, as3722->irq_data);
> +
> +       return 0;
> +}
> +
> +static const struct i2c_device_id as3722_i2c_id[] = {
> +       {"as3722", 0},

Consider spaces before and after the '{}'s.

> +       {}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, as3722_i2c_id);
> +
> +static struct i2c_driver as3722_i2c_driver = {
> +       .driver = {
> +               .name = "as3722",
> +               .owner = THIS_MODULE,
> +       },
> +       .probe = as3722_i2c_probe,
> +       .remove = as3722_i2c_remove,
> +       .id_table = as3722_i2c_id,
> +};

>From here:  -----------------------------------

> +static int __init as3722_i2c_init(void) {
> +       return i2c_add_driver(&as3722_i2c_driver);
> +}
> +
> +subsys_initcall(as3722_i2c_init);
> +
> +static void __exit as3722_i2c_exit(void) {
> +       i2c_del_driver(&as3722_i2c_driver);
> +}
> +
> +module_exit(as3722_i2c_exit);

To here:  -------------------------------------

Swap this out for: module_i2c_driver(as3722_i2c_driver);

> +MODULE_DESCRIPTION("I2C, IRQ and ADC support for AS3722 PMICs");
> +MODULE_LICENSE("GPL"); MODULE_AUTHOR("Florian Lobmaier
> +<florian.lobmaier@ams.com>");

> diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/mfd/as3722-regmap.c ./drivers/mfd/as3722-regmap.c
> --- ../kernel_3.8.8/linux-kernel/drivers/mfd/as3722-regmap.c    1970-01-01 01:00:00.000000000 +0100
> +++ ./drivers/mfd/as3722-regmap.c       2013-05-23 13:12:36.000000000 +0200
> @@ -0,0 +1,417 @@

Arghhhh, what is this? Please use Git.

> +/*
> + * as3722-regmap.c - regmap for AS3722 PMICs

This should really be seperate patch.

> + * Copyright (C) 2013 ams AG
> + *
> + * Author: Florian Lobmaier <florian.lobmaier@ams.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + modify
> + * it under the terms of the GNU General Public License as published
> + by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> + 02111-1307 USA
> + *
> + */
> +
> +#include <linux/mfd/as3722-reg.h>
> +
> +/* Default Register Values (for caching)
> + * Please make sure to update (or update cache at startup)
> + * after device is OTP programmed! */ static struct reg_default
> +as3722_defaults[] = {
> +       { 0x0000, 0x0000 }, /* SD0 Voltage */
> +       { 0x0001, 0x0000 }, /* SD1 Voltage */
> +       { 0x0002, 0x0000 }, /* SD2 Voltage */
> +       { 0x0003, 0x0000 }, /* SD3 Voltage */
> +       { 0x0004, 0x0000 }, /* SD4 Voltage */
> +       { 0x0005, 0x0000 }, /* SD5 Voltage */
> +       { 0x0006, 0x0000 }, /* SD6 Voltage */
> +       { 0x0008, 0x0003 }, /* GPIO0 Control */
> +       { 0x0009, 0x0003 }, /* GPIO1 Control */
> +       { 0x000a, 0x0003 }, /* GPIO2 Control */
> +       { 0x000b, 0x0003 }, /* GPIO3 Control */
> +       { 0x000c, 0x0003 }, /* GPIO4 Control */
> +       { 0x000d, 0x0003 }, /* GPIO5 Control */
> +       { 0x000e, 0x0003 }, /* GPIO6 Control */
> +       { 0x000f, 0x0003 }, /* GPIO7 Control */
> +       { 0x0010, 0x0000 }, /* LDO0 Voltage */
> +       { 0x0011, 0x0000 }, /* LDO1 Voltage */
> +       { 0x0012, 0x0000 }, /* LDO2 Voltage */
> +       { 0x0013, 0x0000 }, /* LDO3 Voltage */
> +       { 0x0014, 0x0000 }, /* LDO4 Voltage */
> +       { 0x0015, 0x0000 }, /* LDO5 Voltage */
> +       { 0x0016, 0x0000 }, /* LDO6 Voltage */
> +       { 0x0017, 0x0000 }, /* LDO7 Voltage */
> +       { 0x0019, 0x0000 }, /* LDO9 Voltage */
> +       { 0x001a, 0x0000 }, /* LDO10 Voltage */
> +       { 0x001b, 0x0000 }, /* LDO11 Voltage */
> +       { 0x001d, 0x0000 }, /* LDO3 Settings */
> +       { 0x001e, 0x0000 }, /* GPIO deb1 */
> +       { 0x001f, 0x0000 }, /* GPIO deb2 */
> +       { 0x0020, 0x0000 }, /* GPIO Signal Out */
> +       { 0x0021, 0x0000 }, /* GPIO Signal In */
> +       { 0x0022, 0x0000 }, /* Reg_sequ_mod1 */
> +       { 0x0023, 0x0000 }, /* Reg_sequ_mod2 */
> +       { 0x0024, 0x0000 }, /* Reg_sequ_mod3 */
> +       { 0x0027, 0x0000 }, /* SD_phsw_ctrl */
> +       { 0x0028, 0x0000 }, /* SD_phsw_status */
> +       { 0x0029, 0x0000 }, /* SD0 Control */
> +       { 0x002a, 0x0001 }, /* SD1 Control */
> +       { 0x002b, 0x0000 }, /* SDmph Control */
> +       { 0x002c, 0x0000 }, /* SD23 Control */
> +       { 0x002d, 0x0000 }, /* SD4 Control */
> +       { 0x002e, 0x0000 }, /* SD5 Control */
> +       { 0x002f, 0x0001 }, /* SD6 Control */
> +       { 0x0030, 0x0000 }, /* SD_dvm */
> +       { 0x0031, 0x0000 }, /* Resetreason */
> +       { 0x0032, 0x0000 }, /* Battery Voltage Monitor */
> +       { 0x0033, 0x0000 }, /* Startup Control */
> +       { 0x0034, 0x0008 }, /* RestTimer */
> +       { 0x0035, 0x0000 }, /* ReferenceControl */
> +       { 0x0036, 0x0000 }, /* ResetControl */
> +       { 0x0037, 0x0001 }, /* OvertemperatureControl */
> +       { 0x0038, 0x0000 }, /* WatchdogControl */
> +       { 0x0039, 0x0000 }, /* Reg_standby_mod1 */
> +       { 0x003a, 0x0000 }, /* Reg_standby_mod2 */
> +       { 0x003b, 0x0000 }, /* Reg_standby_mod3 */
> +       { 0x003c, 0x0000 }, /* Enable Control 1 */
> +       { 0x003d, 0x0000 }, /* Enable Control 2 */
> +       { 0x003e, 0x0000 }, /* Enable Control 3 */
> +       { 0x003f, 0x0000 }, /* Enable Control 4 */
> +       { 0x0040, 0x0000 }, /* Enable Control 5 */
> +       { 0x0041, 0x0000 }, /* PWM Control low */
> +       { 0x0042, 0x0000 }, /* PWM Control high */
> +       { 0x0046, 0x0000 }, /* Watchdog Timer */
> +       { 0x0048, 0x0000 }, /* Watchdog Software Signal */
> +       { 0x0049, 0x0000 }, /* IO Voltage */
> +       { 0x004a, 0x0000 }, /* Battery_voltage_monitor2 */
> +       { 0x004d, 0x007f }, /* SDcontrol */
> +       { 0x004e, 0x00ff }, /* LDOcontrol0 */
> +       { 0x004f, 0x000e }, /* LDOcontrol1 */
> +       { 0x0050, 0x0000 }, /* SD0_protect */
> +       { 0x0051, 0x0000 }, /* SD6_protect */
> +       { 0x0052, 0x0000 }, /* PWM_vcontrol1 */
> +       { 0x0053, 0x0000 }, /* PWM_vcontrol2 */
> +       { 0x0054, 0x0000 }, /* PWM_vcontrol3 */
> +       { 0x0055, 0x0000 }, /* PWM_vcontrol4 */
> +       { 0x0057, 0x0040 }, /* BBcharger */
> +       { 0x0058, 0x0000 }, /* CTRLsequ1 */
> +       { 0x0059, 0x0000 }, /* CTRLsequ2 */
> +       { 0x005a, 0x0000 }, /* OVcurrent */
> +       { 0x005b, 0x0000 }, /* OVcurrent_deb */
> +       { 0x005c, 0x0000 }, /* SDlv_deb */
> +       { 0x005d, 0x0000 }, /* OC_pg_ctrl */
> +       { 0x005e, 0x0000 }, /* OC_pg_ctrl2 */
> +       { 0x005f, 0x0000 }, /* CTRLstatus */
> +       { 0x0060, 0x0020 }, /* RTC Control */
> +       { 0x0061, 0x0000 }, /* RTCsecond */
> +       { 0x0062, 0x0000 }, /* RTCminute */
> +       { 0x0063, 0x0000 }, /* RTChour */
> +       { 0x0064, 0x0001 }, /* RTCday */
> +       { 0x0065, 0x0001 }, /* RTCmonth */
> +       { 0x0066, 0x0000 }, /* RTCyear */
> +       { 0x0067, 0x0000 }, /* RTCAlarmsecond */
> +       { 0x0068, 0x0000 }, /* RTCAlarmminute */
> +       { 0x0069, 0x0000 }, /* RTCAlarmhour */
> +       { 0x006a, 0x003f }, /* RTCAlarmday */
> +       { 0x006b, 0x001f }, /* RTCAlarmmonth */
> +       { 0x006c, 0x007f }, /* RTCAlarmyear */
> +       { 0x006d, 0x0000 }, /* SRAM */
> +       { 0x006f, 0x0000 }, /* RTC_Access */
> +       { 0x0073, 0x0000 }, /* RegStatus */
> +       { 0x0074, 0x00ff }, /* InterruptMask1 */
> +       { 0x0075, 0x00ff }, /* InterruptMask2 */
> +       { 0x0076, 0x00ff }, /* InterruptMask3 */
> +       { 0x0077, 0x00ff }, /* InterruptMask4 */
> +       { 0x0080, 0x0000 }, /* ADC0 Control */
> +       { 0x0081, 0x0000 }, /* ADC1 Control */
> +       { 0x0086, 0x007f }, /* ADC1 threshold hi MSB */
> +       { 0x0087, 0x0007 }, /* ADC1 threshold hi LSB */
> +       { 0x0088, 0x0000 }, /* ADC1 threshold lo MSB */
> +       { 0x0089, 0x0000 }, /* ADC1 threshold lo LSB */
> +       { 0x008a, 0x0000 }, /* ADC Configuration */ };
> +
> +/*
> + * Access masks.
> + */
> +static bool as3722_readable(struct device *dev, unsigned int reg) {
> +       switch (reg) {
> +       case AS3722_SD0_VOLTAGE_REG:
> +       case AS3722_SD1_VOLTAGE_REG:
> +       case AS3722_SD2_VOLTAGE_REG:
> +       case AS3722_SD3_VOLTAGE_REG:
> +       case AS3722_SD4_VOLTAGE_REG:
> +       case AS3722_SD5_VOLTAGE_REG:
> +       case AS3722_SD6_VOLTAGE_REG:
> +       case AS3722_GPIO0_CONTROL_REG:
> +       case AS3722_GPIO1_CONTROL_REG:
> +       case AS3722_GPIO2_CONTROL_REG:
> +       case AS3722_GPIO3_CONTROL_REG:
> +       case AS3722_GPIO4_CONTROL_REG:
> +       case AS3722_GPIO5_CONTROL_REG:
> +       case AS3722_GPIO6_CONTROL_REG:
> +       case AS3722_GPIO7_CONTROL_REG:
> +       case AS3722_LDO0_VOLTAGE_REG:
> +       case AS3722_LDO1_VOLTAGE_REG:
> +       case AS3722_LDO2_VOLTAGE_REG:
> +       case AS3722_LDO3_VOLTAGE_REG:
> +       case AS3722_LDO4_VOLTAGE_REG:
> +       case AS3722_LDO5_VOLTAGE_REG:
> +       case AS3722_LDO6_VOLTAGE_REG:
> +       case AS3722_LDO7_VOLTAGE_REG:
> +       case AS3722_LDO9_VOLTAGE_REG:
> +       case AS3722_LDO10_VOLTAGE_REG:
> +       case AS3722_LDO11_VOLTAGE_REG:
> +       case 0x1d:
> +       case 0x1e:
> +       case 0x1f:
> +       case AS3722_GPIO_SIGNAL_OUT_REG:
> +       case AS3722_GPIO_SIGNAL_IN_REG:
> +       case 0x22:
> +       case 0x23:
> +       case 0x24:
> +       case 0x27:
> +       case 0x28:
> +       case AS3722_SD0_CONTROL_REG:
> +       case AS3722_SD1_CONTROL_REG:
> +       case AS3722_SDmph_CONTROL_REG:
> +       case AS3722_SD23_CONTROL_REG:
> +       case AS3722_SD4_CONTROL_REG:
> +       case AS3722_SD5_CONTROL_REG:
> +       case AS3722_SD6_CONTROL_REG:
> +       case 0x30:
> +       case 0x31:
> +       case 0x32:
> +       case 0x33:
> +       case 0x34:
> +       case 0x35:
> +       case 0x36:
> +       case 0x37:
> +       case AS3722_WATCHDOG_CONTROL_REG:
> +       case 0x39:
> +       case 0x3a:
> +       case 0x3b:
> +       case 0x3c:
> +       case 0x3d:
> +       case 0x3e:
> +       case 0x3f:
> +       case 0x40:
> +       case 0x41:
> +       case 0x42:
> +       case AS3722_WATCHDOG_TIMER_REG:
> +       case AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG:
> +       case AS3722_IOVOLTAGE_REG:
> +       case 0x4a:
> +       case AS3722_SD_CONTROL_REG:
> +       case AS3722_LDOCONTROL0_REG:
> +       case AS3722_LDOCONTROL1_REG:
> +       case 0x50:
> +       case 0x51:
> +       case 0x52:
> +       case 0x53:
> +       case 0x54:
> +       case 0x55:
> +       case 0x57:
> +       case AS3722_CTRL1_REG:
> +       case AS3722_CTRL2_REG:
> +       case 0x5a:
> +       case 0x5b:
> +       case 0x5c:
> +       case 0x5d:
> +       case 0x5e:
> +       case 0x5f:
> +       case AS3722_RTC_CONTROL_REG:
> +       case AS3722_RTC_SECOND_REG:
> +       case AS3722_RTC_MINUTE_REG:
> +       case AS3722_RTC_HOUR_REG:
> +       case AS3722_RTC_DAY_REG:
> +       case AS3722_RTC_MONTH_REG:
> +       case AS3722_RTC_YEAR_REG:
> +       case AS3722_RTC_ALARM_SECOND_REG:
> +       case AS3722_RTC_ALARM_MINUTE_REG:
> +       case AS3722_RTC_ALARM_HOUR_REG:
> +       case AS3722_RTC_ALARM_DAY_REG:
> +       case AS3722_RTC_ALARM_MONTH_REG:
> +       case AS3722_RTC_ALARM_YEAR_REG:
> +       case 0x6d:
> +       case 0x6f:
> +       case 0x73:
> +       case AS3722_INTERRUPTMASK1_REG:
> +       case AS3722_INTERRUPTMASK2_REG:
> +       case AS3722_INTERRUPTMASK3_REG:
> +       case AS3722_INTERRUPTMASK4_REG:
> +       case AS3722_INTERRUPTSTATUS1_REG:
> +       case AS3722_INTERRUPTSTATUS2_REG:
> +       case AS3722_INTERRUPTSTATUS3_REG:
> +       case AS3722_INTERRUPTSTATUS4_REG:
> +       case 0x7d:
> +       case AS3722_ADC0_CONTROL_REG:
> +       case AS3722_ADC1_CONTROL_REG:
> +       case AS3722_ADC0_MSB_RESULT_REG:
> +       case AS3722_ADC0_LSB_RESULT_REG:
> +       case AS3722_ADC1_MSB_RESULT_REG:
> +       case AS3722_ADC1_LSB_RESULT_REG:
> +       case AS3722_ADC1_THRESHOLD_HI_MSB_REG:
> +       case AS3722_ADC1_THRESHOLD_HI_LSB_REG:
> +       case AS3722_ADC1_THRESHOLD_LO_MSB_REG:
> +       case AS3722_ADC1_THRESHOLD_LO_LSB_REG:
> +       case AS3722_ADC_CONFIG_REG:
> +       case AS3722_ADDR_ASIC_ID1:
> +       case AS3722_ADDR_ASIC_ID2:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +static bool as3722_writeable(struct device *dev, unsigned int reg) {
> +       switch (reg) {
> +       case AS3722_SD0_VOLTAGE_REG:
> +       case AS3722_SD1_VOLTAGE_REG:
> +       case AS3722_SD2_VOLTAGE_REG:
> +       case AS3722_SD3_VOLTAGE_REG:
> +       case AS3722_SD4_VOLTAGE_REG:
> +       case AS3722_SD5_VOLTAGE_REG:
> +       case AS3722_SD6_VOLTAGE_REG:
> +       case AS3722_GPIO0_CONTROL_REG:
> +       case AS3722_GPIO1_CONTROL_REG:
> +       case AS3722_GPIO2_CONTROL_REG:
> +       case AS3722_GPIO3_CONTROL_REG:
> +       case AS3722_GPIO4_CONTROL_REG:
> +       case AS3722_GPIO5_CONTROL_REG:
> +       case AS3722_GPIO6_CONTROL_REG:
> +       case AS3722_GPIO7_CONTROL_REG:
> +       case AS3722_LDO0_VOLTAGE_REG:
> +       case AS3722_LDO1_VOLTAGE_REG:
> +       case AS3722_LDO2_VOLTAGE_REG:
> +       case AS3722_LDO3_VOLTAGE_REG:
> +       case AS3722_LDO4_VOLTAGE_REG:
> +       case AS3722_LDO5_VOLTAGE_REG:
> +       case AS3722_LDO6_VOLTAGE_REG:
> +       case AS3722_LDO7_VOLTAGE_REG:
> +       case AS3722_LDO9_VOLTAGE_REG:
> +       case AS3722_LDO10_VOLTAGE_REG:
> +       case AS3722_LDO11_VOLTAGE_REG:
> +       case 0x1d:
> +       case 0x1e:
> +       case 0x1f:
> +       case AS3722_GPIO_SIGNAL_OUT_REG:
> +       case 0x22:
> +       case 0x23:
> +       case 0x24:
> +       case 0x27:
> +       case 0x28:
> +       case AS3722_SD0_CONTROL_REG:
> +       case AS3722_SD1_CONTROL_REG:
> +       case AS3722_SDmph_CONTROL_REG:
> +       case AS3722_SD23_CONTROL_REG:
> +       case AS3722_SD4_CONTROL_REG:
> +       case AS3722_SD5_CONTROL_REG:
> +       case AS3722_SD6_CONTROL_REG:
> +       case 0x30:
> +       case 0x31:
> +       case 0x32:
> +       case 0x33:
> +       case 0x34:
> +       case 0x35:
> +       case 0x36:
> +       case 0x37:
> +       case AS3722_WATCHDOG_CONTROL_REG:
> +       case 0x39:
> +       case 0x3a:
> +       case 0x3b:
> +       case 0x3c:
> +       case 0x3d:
> +       case 0x3e:
> +       case 0x3f:
> +       case 0x40:
> +       case 0x41:
> +       case 0x42:
> +       case AS3722_WATCHDOG_TIMER_REG:
> +       case AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG:
> +       case AS3722_IOVOLTAGE_REG:
> +       case 0x4a:
> +       case AS3722_SD_CONTROL_REG:
> +       case AS3722_LDOCONTROL0_REG:
> +       case AS3722_LDOCONTROL1_REG:
> +       case 0x50:
> +       case 0x51:
> +       case 0x52:
> +       case 0x53:
> +       case 0x54:
> +       case 0x55:
> +       case 0x57:
> +       case AS3722_CTRL1_REG:
> +       case AS3722_CTRL2_REG:
> +       case 0x5a:
> +       case 0x5b:
> +       case 0x5c:
> +       case 0x5d:
> +       case 0x5e:
> +       case AS3722_RTC_CONTROL_REG:
> +       case AS3722_RTC_SECOND_REG:
> +       case AS3722_RTC_MINUTE_REG:
> +       case AS3722_RTC_HOUR_REG:
> +       case AS3722_RTC_DAY_REG:
> +       case AS3722_RTC_MONTH_REG:
> +       case AS3722_RTC_YEAR_REG:
> +       case AS3722_RTC_ALARM_SECOND_REG:
> +       case AS3722_RTC_ALARM_MINUTE_REG:
> +       case AS3722_RTC_ALARM_HOUR_REG:
> +       case AS3722_RTC_ALARM_DAY_REG:
> +       case AS3722_RTC_ALARM_MONTH_REG:
> +       case AS3722_RTC_ALARM_YEAR_REG:
> +       case 0x6d:
> +       case 0x6f:
> +       case AS3722_INTERRUPTMASK1_REG:
> +       case AS3722_INTERRUPTMASK2_REG:
> +       case AS3722_INTERRUPTMASK3_REG:
> +       case AS3722_INTERRUPTMASK4_REG:
> +       case AS3722_INTERRUPTSTATUS1_REG:
> +       case AS3722_INTERRUPTSTATUS2_REG:
> +       case AS3722_INTERRUPTSTATUS3_REG:
> +       case AS3722_INTERRUPTSTATUS4_REG:
> +       case 0x7d:
> +       case AS3722_ADC0_CONTROL_REG:
> +       case AS3722_ADC1_CONTROL_REG:
> +       case AS3722_ADC1_THRESHOLD_HI_MSB_REG:
> +       case AS3722_ADC1_THRESHOLD_HI_LSB_REG:
> +       case AS3722_ADC1_THRESHOLD_LO_MSB_REG:
> +       case AS3722_ADC1_THRESHOLD_LO_LSB_REG:
> +       case AS3722_ADC_CONFIG_REG:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}

Really? Isn't there a better, more dynamic way of doing this?

> +static bool as3722_volatile(struct device *dev, unsigned int reg) {
> +       return false;
> +}
> +
> +const struct regmap_config as3722_regmap_config = {
> +       .reg_bits = 8,
> +       .val_bits = 8,
> +
> +       .cache_type = REGCACHE_RBTREE,
> +
> +       .max_register = AS3722_REGISTER_COUNT,
> +       .readable_reg = as3722_readable,
> +       .writeable_reg = as3722_writeable,
> +       .volatile_reg = as3722_volatile,
> +
> +       .reg_defaults = as3722_defaults,
> +       .num_reg_defaults = ARRAY_SIZE(as3722_defaults), };
> diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/mfd/Kconfig ./drivers/mfd/Kconfig
> --- ../kernel_3.8.8/linux-kernel/drivers/mfd/Kconfig    2013-05-15 14:55:54.000000000 +0200
> +++ ./drivers/mfd/Kconfig       2013-05-23 13:12:36.000000000 +0200
> @@ -516,6 +516,21 @@ config MFD_LP8788

Argh, carnage.

>           TI LP8788 PMU supports regulators, battery charger, RTC,
>           ADC, backlight driver and current sinks.
>
> +config MFD_AS3722
> +       tristate "Support for ams AS3722 PMIC"
> +       select MFD_CORE
> +       select REGMAP_I2C
> +        select REGMAP_IRQ
> +       depends on I2C=y
> +       help
> +         Core support for the ams AS3722 PMIC. Additional
> +         drivers must be enabled in order to use the functionality of the
> +         device.
> +         Related drivers are:
> +               * ams AS3722 PMIC regulators
> +               * ams AS3722 GPIO
> +               * ams AS3722 RTC

Lots of random spacings and line endings above.

>  config MFD_MAX77686
>         bool "Maxim Semiconductor MAX77686 PMIC Support"
>         depends on I2C=y && GENERIC_HARDIRQS diff -uprN -X
> Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/mfd/Makefile ./drivers/mfd/Makefile
> --- ../kernel_3.8.8/linux-kernel/drivers/mfd/Makefile   2013-05-15 14:55:54.000000000 +0200
> +++ ./drivers/mfd/Makefile      2013-05-23 13:12:36.000000000 +0200
> @@ -148,3 +148,4 @@ obj-$(CONFIG_MFD_LM3533)    += lm3533-core.
>  obj-$(CONFIG_VEXPRESS_CONFIG)  += vexpress-config.o vexpress-sysreg.o
>  obj-$(CONFIG_MFD_RETU)         += retu-mfd.o
>  obj-$(CONFIG_MFD_AS3711)       += as3711.o
> +obj-$(CONFIG_MFD_AS3722)       += as3722-core.o as3722-regmap.o

--
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org ‚îÇ Open source software for ARM SoCs Follow Linaro: Facebook | Twitter | Blog
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
