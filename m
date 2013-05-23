Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab3EWMRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:17:24 -0400
Received: from mail1.ams.com ([212.166.112.31]:48049 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251Ab3EWMRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:17:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,728,1363129200"; 
   d="scan'208";a="2797472"
From: Florian Lobmaier <Florian.Lobmaier@ams.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 May 2013 14:07:49 +0200
Subject: [PATCH 06/07] rtc patch of ams AS3722 PMIC against linux_3.8.8
Thread-Topic: [PATCH 06/07] rtc patch of ams AS3722 PMIC against linux_3.8.8
Thread-Index: Ac5XrWx0BRjUFA3mSkmUmc7OT6TRHg==
Message-ID: <EB31996D403C2C48A47628A08DCCFD29018405708F@SUX2182.office.amsiag.com>
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
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/rtc/Kconfig ./drivers/rtc/Kconfig
--- ../kernel_3.8.8/linux-kernel/drivers/rtc/Kconfig	2013-05-15 14:55:55.000000000 +0200
+++ ./drivers/rtc/Kconfig	2013-05-23 13:12:37.000000000 +0200
@@ -125,6 +125,16 @@ comment "I2C RTC drivers"
 
 if I2C
 
+config RTC_DRV_AS3722
+	tristate "ams AS3722"
+	depends on MFD_AS3722
+	help
+	  If you say Y here you will get support for the RTC feature
+	  of the ams AS3722 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-as3722.
+
 config RTC_DRV_88PM860X
 	tristate "Marvell 88PM860x"
 	depends on I2C && MFD_88PM860X
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/rtc/Makefile ./drivers/rtc/Makefile
--- ../kernel_3.8.8/linux-kernel/drivers/rtc/Makefile	2013-05-15 14:55:55.000000000 +0200
+++ ./drivers/rtc/Makefile	2013-05-23 13:12:37.000000000 +0200
@@ -19,6 +19,7 @@ obj-$(CONFIG_RTC_DRV_88PM860X)  += rtc-8
 obj-$(CONFIG_RTC_DRV_88PM80X)	+= rtc-88pm80x.o
 obj-$(CONFIG_RTC_DRV_AB3100)	+= rtc-ab3100.o
 obj-$(CONFIG_RTC_DRV_AB8500)	+= rtc-ab8500.o
+obj-$(CONFIG_RTC_DRV_AS3722)	+= rtc-as3722.o
 obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
 obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-at91rm9200.o
 obj-$(CONFIG_RTC_DRV_AT91SAM9)	+= rtc-at91sam9.o
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/rtc/rtc-as3722.c ./drivers/rtc/rtc-as3722.c
--- ../kernel_3.8.8/linux-kernel/drivers/rtc/rtc-as3722.c	1970-01-01 01:00:00.000000000 +0100
+++ ./drivers/rtc/rtc-as3722.c	2013-05-23 13:12:37.000000000 +0200
@@ -0,0 +1,356 @@
+/*
+ * rtc-as3722.c - Real Time Clock driver for ams AS3722 PMICs
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
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/time.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/interrupt.h>
+#include <linux/ioctl.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/as3722-reg.h>
+#include <linux/mfd/as3722-plat.h>
+
+/* RTC defines:
+ * start year has to be a century that rtc works
+ * correctly with leap years, etc.
+ */
+#define AS3722_RTC_START_YEAR          2000
+#define AS3722_SET_ALM_RETRIES         5
+#define AS3722_SET_TIME_RETRIES        5
+#define AS3722_GET_TIME_RETRIES        5
+
+/*
+ * Read current time and date in RTC
+ */
+static int as3722_rtc_readtime(struct device *dev, struct rtc_time *tm)
+{
+	struct as3722 *as3722 = dev_get_drvdata(dev->parent);
+	u8 as_time_array[6];
+	int ret;
+
+	ret = as3722_block_read(as3722, AS3722_RTC_SECOND_REG,
+			6, as_time_array);
+	if (ret < 0)
+		return ret;
+
+	tm->tm_sec = ((as_time_array[0] & 0xF0) >> 4) * 10
+			+ (as_time_array[0] & 0x0F);
+	tm->tm_min = ((as_time_array[1] & 0xF0) >> 4) * 10
+			+ (as_time_array[1] & 0x0F);
+	tm->tm_hour = ((as_time_array[2] & 0xF0) >> 4) * 10
+			+ (as_time_array[2] & 0x0F);
+	tm->tm_mday = ((as_time_array[3] & 0xF0) >> 4) * 10
+			+ (as_time_array[3] & 0x0F);
+	tm->tm_mon = ((as_time_array[4] & 0xF0) >> 4) * 10
+			+ (as_time_array[4] & 0x0F);
+	tm->tm_year = (AS3722_RTC_START_YEAR - 1900)
+			+ ((as_time_array[5] & 0xF0) >> 4) * 10
+			+ (as_time_array[5] & 0x0F);
+
+	return 0;
+}
+
+/*
+ * Set current time and date in RTC
+ */
+static int as3722_rtc_settime(struct device *dev, struct rtc_time *tm)
+{
+	struct as3722 *as3722 = dev_get_drvdata(dev->parent);
+	u8 as_time_array[6];
+	int ret;
+
+	/* Write time to RTC */
+	as_time_array[0] = ((tm->tm_sec / 10) << 4)
+			+ (tm->tm_sec % 10);
+	as_time_array[1] = ((tm->tm_min / 10) << 4)
+			+ (tm->tm_min % 10);
+	as_time_array[2] = ((tm->tm_hour / 10) << 4)
+			+ (tm->tm_hour % 10);
+	as_time_array[3] = ((tm->tm_mday / 10) << 4)
+			+ (tm->tm_mday % 10);
+	as_time_array[4] = ((tm->tm_mon / 10) << 4)
+			+ (tm->tm_mon % 10);
+	if (tm->tm_year > AS3722_RTC_START_YEAR)
+		as_time_array[5] = (((tm->tm_year - AS3722_RTC_START_YEAR)
+				/ 10) << 4)
+				+ ((tm->tm_year - AS3722_RTC_START_YEAR) % 10);
+	else
+		return -1;
+
+	ret = as3722_block_write(as3722, AS3722_RTC_SECOND_REG, 6,
+			as_time_array);
+
+	return ret;
+}
+
+/*
+ * Read alarm time and date in RTC
+ */
+static int as3722_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct as3722 *as3722 = dev_get_drvdata(dev->parent);
+	u8 as_time_array[6];
+	int ret;
+
+	ret = as3722_block_read(as3722, AS3722_RTC_SECOND_REG,
+			6, as_time_array);
+	if (ret < 0)
+		return ret;
+
+	alrm->time.tm_sec = ((as_time_array[0] & 0xF0) >> 4) * 10
+			+ (as_time_array[0] & 0x0F);
+	alrm->time.tm_min = ((as_time_array[1] & 0xF0) >> 4) * 10
+			+ (as_time_array[1] & 0x0F);
+	alrm->time.tm_hour = ((as_time_array[2] & 0xF0) >> 4) * 10
+			+ (as_time_array[2] & 0x0F);
+	alrm->time.tm_mday = ((as_time_array[3] & 0xF0) >> 4) * 10
+			+ (as_time_array[3] & 0x0F);
+	alrm->time.tm_mon = ((as_time_array[4] & 0xF0) >> 4) * 10
+			+ (as_time_array[4] & 0x0F);
+	alrm->time.tm_year = (AS3722_RTC_START_YEAR - 1900)
+			+ ((as_time_array[5] & 0xF0) >> 4) * 10
+			+ (as_time_array[5] & 0x0F);
+
+	return 0;
+}
+
+static int as3722_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct as3722 *as3722 = dev_get_drvdata(dev->parent);
+	u8 as_time_array[6];
+	int ret;
+
+	/* Write time to RTC */
+	as_time_array[0] = ((alrm->time.tm_sec / 10) << 4)
+			+ (alrm->time.tm_sec % 10);
+	as_time_array[1] = ((alrm->time.tm_min / 10) << 4)
+			+ (alrm->time.tm_min % 10);
+	as_time_array[2] = ((alrm->time.tm_hour / 10) << 4)
+			+ (alrm->time.tm_hour % 10);
+	as_time_array[3] = ((alrm->time.tm_mday / 10) << 4)
+			+ (alrm->time.tm_mday % 10);
+	as_time_array[4] = ((alrm->time.tm_mon / 10) << 4)
+			+ (alrm->time.tm_mon % 10);
+	if (alrm->time.tm_year > AS3722_RTC_START_YEAR)
+		as_time_array[5] =
+			(((alrm->time.tm_year - AS3722_RTC_START_YEAR)
+			/ 10) << 4)
+			+ ((alrm->time.tm_year - AS3722_RTC_START_YEAR) % 10);
+	else
+		return -1;
+
+	ret = as3722_block_write(as3722, AS3722_RTC_SECOND_REG, 6,
+			as_time_array);
+
+	return ret;
+}
+
+static int as3722_rtc_stop_alarm(struct as3722 *as3722)
+{
+	/* disable rtc alarm interrupt */
+	return as3722_set_bits(as3722, AS3722_INTERRUPTMASK3_REG,
+			AS3722_IRQ_MASK_RTC_ALARM, AS3722_IRQ_BIT_RTC_ALARM);
+}
+
+static int as3722_rtc_start_alarm(struct as3722 *as3722)
+{
+	/* enable rtc alarm interrupt */
+	return as3722_set_bits(as3722, AS3722_INTERRUPTMASK3_REG,
+			AS3722_IRQ_MASK_RTC_ALARM, 0);
+}
+
+static int as3722_rtc_alarm_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	struct as3722 *as3722 = dev_get_drvdata(dev->parent);
+
+	if (enabled)
+		return as3722_rtc_start_alarm(as3722);
+	else
+		return as3722_rtc_stop_alarm(as3722);
+}
+
+static irqreturn_t as3722_alarm_irq(int irq, void *data)
+{
+	struct as3722 *as3722 = data;
+	struct rtc_device *rtc = as3722->rtc.rtc;
+
+	rtc_update_irq(rtc, 1, RTC_IRQF | RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops as3722_rtc_ops = {
+	.read_time = as3722_rtc_readtime,
+	.set_time = as3722_rtc_settime,
+	.read_alarm = as3722_rtc_readalarm,
+	.set_alarm = as3722_rtc_setalarm,
+	.alarm_irq_enable = as3722_rtc_alarm_irq_enable,
+};
+
+#ifdef CONFIG_PM
+static int as3722_rtc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
+	int ret = 0;
+	u32 reg;
+
+	as3722_reg_read(as3722, AS3722_INTERRUPTMASK3_REG, &reg);
+
+	if (device_may_wakeup(dev) &&
+			reg & AS3722_IRQ_MASK_RTC_ALARM) {
+		ret = as3722_rtc_stop_alarm(as3722);
+		if (ret != 0)
+			dev_err(dev, "Failed to stop RTC alarm: %d\n",
+					ret);
+	}
+
+	return ret;
+}
+
+static int as3722_rtc_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
+	int ret;
+
+	if (as3722->rtc.alarm_enabled) {
+		ret = as3722_rtc_start_alarm(as3722);
+		if (ret != 0)
+			dev_err(dev,
+				"Failed to restart RTC alarm: %d\n", ret);
+	}
+
+	return 0;
+}
+
+/* Unconditionally disable the alarm */
+static int as3722_rtc_freeze(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
+	int ret;
+
+	ret = as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
+			AS3722_RTC_ALARM_WAKEUP_EN_MASK, 0);
+	if (ret != 0)
+		dev_err(&pdev->dev, "Failed to stop RTC alarm: %d\n", ret);
+
+	return 0;
+}
+
+#define DEV_PM_OPS     (&as3722_rtc_pm_ops)
+#else
+#define DEV_PM_OPS     NULL
+#endif
+
+static int as3722_rtc_probe(struct platform_device *pdev)
+{
+	struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
+	struct as3722_rtc *rtc = &as3722->rtc;
+	struct as3722_platform_data *pdata = as3722->dev->platform_data;
+	int alarm_irq = regmap_irq_get_virq(as3722->irq_data,
+						AS3722_IRQ_RTC_ALARM);
+	int ret = 0;
+	u32 ctrl;
+	/* enable the RTC if it's not already enabled */
+	as3722_reg_read(as3722, AS3722_RTC_CONTROL_REG, &ctrl);
+	if (!(ctrl &  AS3722_RTC_ON_MASK)) {
+		dev_info(&pdev->dev, "Starting RTC\n");
+
+		ret = as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
+				AS3722_RTC_ON_MASK, AS3722_RTC_ON_MASK);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"failed to enable RTC: %d\n", ret);
+			return ret;
+		}
+	}
+	/* enable alarm wakeup */
+	as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
+			AS3722_RTC_ALARM_WAKEUP_EN_MASK,
+			AS3722_RTC_ALARM_WAKEUP_EN_MASK);
+
+	device_init_wakeup(&pdev->dev, 1);
+
+	rtc->rtc = rtc_device_register("as3722", &pdev->dev,
+			&as3722_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc)) {
+		ret = PTR_ERR(rtc->rtc);
+		dev_err(&pdev->dev, "failed to register RTC: %d\n", ret);
+		return ret;
+	}
+
+	ret = request_threaded_irq(alarm_irq, NULL, as3722_alarm_irq,
+			pdata->irq_type, "RTC alarm",
+			rtc->rtc);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
+				alarm_irq, ret);
+	}
+
+	return 0;
+}
+
+static int as3722_rtc_remove(struct platform_device *pdev)
+{
+	struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
+	struct as3722_rtc *rtc = &as3722->rtc;
+	int alarm_irq = regmap_irq_get_virq(as3722->irq_data,
+						AS3722_IRQ_RTC_ALARM);
+
+	free_irq(alarm_irq, rtc->rtc);
+	rtc_device_unregister(rtc->rtc);
+
+	return 0;
+}
+
+static const struct dev_pm_ops as3722_rtc_pm_ops = {
+	.suspend        = as3722_rtc_suspend,
+	.resume         = as3722_rtc_resume,
+	.freeze         = as3722_rtc_freeze,
+	.thaw           = as3722_rtc_resume,
+	.restore        = as3722_rtc_resume,
+	.poweroff       = as3722_rtc_suspend,
+};
+
+static struct platform_driver as3722_rtc_driver = {
+	.probe = as3722_rtc_probe,
+	.remove = as3722_rtc_remove,
+	.driver = {
+		.name = "as3722-rtc",
+		.pm = DEV_PM_OPS,
+	},
+};
+
+module_platform_driver(as3722_rtc_driver);
+
+MODULE_AUTHOR("Florian Lobmaier <florian.lobmaier@ams.com>");
+MODULE_DESCRIPTION("RTC driver for AS3722 PMICs");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:as3722-rtc");
