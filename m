Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaCFQw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:52:26 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.174]:57193 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbaCFQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:52:09 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-16.tower-38.messagelabs.com!1394124684!40521!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <93327cde91bcaef9a467adc6c7b34c3231d9e1e7.1394124002.git.stwiss.opensource@diasemi.com>
In-Reply-To: <cover.1394124002.git.stwiss.opensource@diasemi.com>
References: <cover.1394124002.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Thu, 6 Mar 2014 16:40:02 +0000
Subject: [PATCH V1 2/2] rtc: da9063: RTC driver
To: Alessandro Zummo <a.zummo@towertech.it>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Add the RTC driver for DA9063.

Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
---
Checks performed with next-20140306/scripts/checkpatch.pl
 Kconfig                   total: 0 errors, 21 warnings, 1344 lines checked
 Makefile                  total: 0 errors, 0 warnings, 139 lines checked
 rtc-da9063.c              total: 0 errors, 0 warnings, 332 lines checked

Although there are 21 warnings in Kconfig, these do not apply to the
changes made in this patch set.

Change History:

Changes made to this driver since previous RFC V1
Comments by Alessandro Zummo
- http://www.kernelhub.org/?p=2&msg=426327
- Use return PTR_ERR(rtc->rtc_dev); instead of goto err; return err.
- Request the interrupt before the RTC device is registered with the
  call to devm_rtc_device_register.

Dependencies:

This driver requires the register changes associated with this patch
set. It requires the changes made to registers.h and in particular,
the new register DA9063_REG_ALARM_S (now appearing at addr=0x46) and
DA9063_ALARM_S_MASK 0x3F are required to allow the triggering of
alarms down to the second resolution level.

This patch applies against kernel version linux-next next-20140306
 
Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 drivers/rtc/Kconfig      |   10 ++
 drivers/rtc/Makefile     |    1 +
 drivers/rtc/rtc-da9063.c |  332 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 343 insertions(+)
 create mode 100644 drivers/rtc/rtc-da9063.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index db933de..472a5b9 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -746,6 +746,16 @@ config RTC_DRV_DA9055
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-da9055
 
+config RTC_DRV_DA9063
+	tristate "Dialog Semiconductor DA9063 RTC"
+	depends on MFD_DA9063
+	help
+	  If you say yes here you will get support for the RTC subsystem
+	  of the Dialog Semiconductor DA9063.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called "rtc-da9063".
+
 config RTC_DRV_EFI
 	tristate "EFI RTC"
 	depends on IA64
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index b427bf7..4a4fed9 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
 obj-$(CONFIG_RTC_DRV_DA9052)	+= rtc-da9052.o
 obj-$(CONFIG_RTC_DRV_DA9055)	+= rtc-da9055.o
+obj-$(CONFIG_RTC_DRV_DA9063)	+= rtc-da9063.o
 obj-$(CONFIG_RTC_DRV_DAVINCI)	+= rtc-davinci.o
 obj-$(CONFIG_RTC_DRV_DM355EVM)	+= rtc-dm355evm.o
 obj-$(CONFIG_RTC_DRV_VRTC)	+= rtc-mrst.o
diff --git a/drivers/rtc/rtc-da9063.c b/drivers/rtc/rtc-da9063.c
new file mode 100644
index 0000000..d7b15e3
--- /dev/null
+++ b/drivers/rtc/rtc-da9063.c
@@ -0,0 +1,332 @@
+/* rtc-da9063.c - Real time clock device driver for DA9063
+ * Copyright (C) 2013-14  Dialog Semiconductor Ltd.
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/rtc.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/regmap.h>
+#include <linux/mfd/da9063/registers.h>
+#include <linux/mfd/da9063/core.h>
+
+#define YEARS_TO_DA9063(year)		((year) - 100)
+#define MONTHS_TO_DA9063(month)		((month) + 1)
+#define YEARS_FROM_DA9063(year)		((year) + 100)
+#define MONTHS_FROM_DA9063(month)	((month) - 1)
+
+#define RTC_DATA_LEN	(DA9063_REG_COUNT_Y - DA9063_REG_COUNT_S + 1)
+#define RTC_SEC		0
+#define RTC_MIN		1
+#define RTC_HOUR	2
+#define RTC_DAY		3
+#define RTC_MONTH	4
+#define RTC_YEAR	5
+
+struct da9063_rtc {
+	struct rtc_device	*rtc_dev;
+	struct da9063		*hw;
+	struct rtc_time		alarm_time;
+	bool			rtc_sync;
+};
+
+static void da9063_data_to_tm(u8 *data, struct rtc_time *tm)
+{
+	tm->tm_sec  = data[RTC_SEC]  & DA9063_COUNT_SEC_MASK;
+	tm->tm_min  = data[RTC_MIN]  & DA9063_COUNT_MIN_MASK;
+	tm->tm_hour = data[RTC_HOUR] & DA9063_COUNT_HOUR_MASK;
+	tm->tm_mday = data[RTC_DAY]  & DA9063_COUNT_DAY_MASK;
+	tm->tm_mon  = MONTHS_FROM_DA9063(data[RTC_MONTH] &
+					 DA9063_COUNT_MONTH_MASK);
+	tm->tm_year = YEARS_FROM_DA9063(data[RTC_YEAR] &
+					DA9063_COUNT_YEAR_MASK);
+}
+
+static void da9063_tm_to_data(struct rtc_time *tm, u8 *data)
+{
+	data[RTC_SEC] &= ~DA9063_COUNT_SEC_MASK;
+	data[RTC_SEC] |= tm->tm_sec & DA9063_COUNT_SEC_MASK;
+
+	data[RTC_MIN] &= ~DA9063_COUNT_MIN_MASK;
+	data[RTC_MIN] |= tm->tm_min & DA9063_COUNT_MIN_MASK;
+
+	data[RTC_HOUR] &= ~DA9063_COUNT_HOUR_MASK;
+	data[RTC_HOUR] |= tm->tm_hour & DA9063_COUNT_HOUR_MASK;
+
+	data[RTC_DAY] &= ~DA9063_COUNT_DAY_MASK;
+	data[RTC_DAY] |= tm->tm_mday & DA9063_COUNT_DAY_MASK;
+
+	data[RTC_MONTH] &= ~DA9063_COUNT_MONTH_MASK;
+	data[RTC_MONTH] |= MONTHS_TO_DA9063(tm->tm_mon) &
+				DA9063_COUNT_MONTH_MASK;
+
+	data[RTC_YEAR] &= ~DA9063_COUNT_YEAR_MASK;
+	data[RTC_YEAR] |= YEARS_TO_DA9063(tm->tm_year) &
+				DA9063_COUNT_YEAR_MASK;
+}
+
+static int da9063_rtc_stop_alarm(struct device *dev)
+{
+	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
+				  DA9063_ALARM_ON, 0);
+}
+
+static int da9063_rtc_start_alarm(struct device *dev)
+{
+	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
+				  DA9063_ALARM_ON, DA9063_ALARM_ON);
+}
+
+static int da9063_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long tm_secs;
+	unsigned long al_secs;
+	u8 data[RTC_DATA_LEN];
+	int ret;
+
+	ret = regmap_bulk_read(rtc->hw->regmap, DA9063_REG_COUNT_S,
+			       data, RTC_DATA_LEN);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read RTC time data: %d\n", ret);
+		return ret;
+	}
+
+	if (!(data[RTC_SEC] & DA9063_RTC_READ)) {
+		dev_dbg(dev, "RTC not yet ready to be read by the host\n");
+		return -EINVAL;
+	}
+
+	da9063_data_to_tm(data, tm);
+
+	(void)rtc_tm_to_time(tm, &tm_secs);
+	(void)rtc_tm_to_time(&rtc->alarm_time, &al_secs);
+
+	/* handle the rtc synchronisation delay */
+	if (rtc->rtc_sync == true && al_secs - tm_secs == 1)
+		(void)memcpy((void *)tm, (const void *)&rtc->alarm_time,
+			     sizeof(struct rtc_time));
+	else
+		rtc->rtc_sync = false;
+
+	return rtc_valid_tm(tm);
+}
+
+static int da9063_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+	u8 data[RTC_DATA_LEN];
+	int ret;
+
+	da9063_tm_to_data(tm, data);
+	ret = regmap_bulk_write(rtc->hw->regmap, DA9063_REG_COUNT_S,
+				data, RTC_DATA_LEN);
+	if (ret < 0)
+		dev_err(dev, "Failed to set RTC time data: %d\n", ret);
+
+	return ret;
+}
+
+static int da9063_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+	u8 data[RTC_DATA_LEN];
+	int ret;
+	unsigned int val;
+
+	ret = regmap_bulk_read(rtc->hw->regmap, DA9063_REG_ALARM_S,
+			       &data[RTC_SEC], RTC_DATA_LEN);
+	if (ret < 0)
+		return ret;
+
+	da9063_data_to_tm(data, &alrm->time);
+
+	alrm->enabled = !!(data[RTC_YEAR] & DA9063_ALARM_ON);
+
+	ret = regmap_read(rtc->hw->regmap, DA9063_REG_EVENT_A, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val & (DA9063_E_ALARM))
+		alrm->pending = 1;
+	else
+		alrm->pending = 0;
+
+	return 0;
+}
+
+static int da9063_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+	u8 data[RTC_DATA_LEN];
+	int ret;
+
+	da9063_tm_to_data(&alrm->time, data);
+
+	ret = da9063_rtc_stop_alarm(dev);
+	if (ret < 0) {
+		dev_err(dev, "Failed to stop alarm: %d\n", ret);
+		return ret;
+	}
+
+	ret = regmap_bulk_write(rtc->hw->regmap, DA9063_REG_ALARM_S,
+				data, RTC_DATA_LEN);
+	if (ret < 0) {
+		dev_err(dev, "Failed to write alarm: %d\n", ret);
+		return ret;
+	}
+
+	rtc->alarm_time = alrm->time;
+
+	if (alrm->enabled) {
+		ret = da9063_rtc_start_alarm(dev);
+		if (ret < 0) {
+			dev_err(dev, "Failed to start alarm: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+static int da9063_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	if (enabled)
+		return da9063_rtc_start_alarm(dev);
+	else
+		return da9063_rtc_stop_alarm(dev);
+}
+
+static irqreturn_t da9063_alarm_event(int irq, void *data)
+{
+	struct da9063_rtc *rtc = data;
+
+	regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
+			   DA9063_ALARM_ON, 0);
+
+	rtc->rtc_sync = true;
+	rtc_update_irq(rtc->rtc_dev, 1, RTC_IRQF | RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops da9063_rtc_ops = {
+	.read_time = da9063_rtc_read_time,
+	.set_time = da9063_rtc_set_time,
+	.read_alarm = da9063_rtc_read_alarm,
+	.set_alarm = da9063_rtc_set_alarm,
+	.alarm_irq_enable = da9063_rtc_alarm_irq_enable,
+};
+
+static int da9063_rtc_probe(struct platform_device *pdev)
+{
+	struct da9063 *da9063 = dev_get_drvdata(pdev->dev.parent);
+	struct da9063_rtc *rtc;
+	int irq_alarm;
+	u8 data[RTC_DATA_LEN];
+	int ret;
+
+	ret = regmap_update_bits(da9063->regmap, DA9063_REG_CONTROL_E,
+				 DA9063_RTC_EN, DA9063_RTC_EN);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to enable RTC\n");
+		goto err;
+	}
+
+	ret = regmap_update_bits(da9063->regmap, DA9063_REG_EN_32K,
+				 DA9063_CRYSTAL, DA9063_CRYSTAL);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to run 32kHz oscillator\n");
+		goto err;
+	}
+
+	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_S,
+			DA9063_ALARM_STATUS_TICK | DA9063_ALARM_STATUS_ALARM,
+			0);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to access RTC alarm register\n");
+		goto err;
+	}
+
+	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_S,
+				 DA9063_ALARM_STATUS_ALARM,
+				 DA9063_ALARM_STATUS_ALARM);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to access RTC alarm register\n");
+		goto err;
+	}
+
+	ret = regmap_update_bits(da9063->regmap, DA9063_REG_ALARM_Y,
+				 DA9063_TICK_ON, 0);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to disable TICKs\n");
+		goto err;
+	}
+
+	ret = regmap_bulk_read(da9063->regmap, DA9063_REG_ALARM_S,
+			       data, RTC_DATA_LEN);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to read initial alarm data: %d\n",
+			ret);
+		goto err;
+	}
+
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, rtc);
+
+	irq_alarm = platform_get_irq_byname(pdev, "ALARM");
+	ret = devm_request_threaded_irq(&pdev->dev, irq_alarm, NULL,
+					da9063_alarm_event,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					"ALARM", rtc);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request ALARM IRQ %d: %d\n",
+			irq_alarm, ret);
+		goto err;
+	}
+
+	rtc->hw = da9063;
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, DA9063_DRVNAME_RTC,
+					   &da9063_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc_dev))
+		return PTR_ERR(rtc->rtc_dev);
+
+	da9063_data_to_tm(data, &rtc->alarm_time);
+	rtc->rtc_sync = false;
+err:
+	return ret;
+}
+
+static struct platform_driver da9063_rtc_driver = {
+	.probe		= da9063_rtc_probe,
+	.driver		= {
+		.name	= DA9063_DRVNAME_RTC,
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(da9063_rtc_driver);
+
+MODULE_AUTHOR("S Twiss <stwiss.opensource@diasemi.com>");
+MODULE_DESCRIPTION("Real time clock device driver for Dialog DA9063");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9063_DRVNAME_RTC);
-- 
end-of-patch for PATCH V1

