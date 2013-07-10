Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3GJOBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:01:17 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:47082 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab3GJOBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:01:16 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] rtc: Add MOXA ART RTC driver
Date: Wed, 10 Jul 2013 16:00:48 +0200
Message-Id: <1373464848-28146-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RTC driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20130703

 drivers/rtc/Kconfig      |   9 ++
 drivers/rtc/Makefile     |   1 +
 drivers/rtc/rtc-moxart.c | 335 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 345 insertions(+)
 create mode 100644 drivers/rtc/rtc-moxart.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index b983813..7035955 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1233,6 +1233,15 @@ config RTC_DRV_SNVS
 	   This driver can also be built as a module, if so, the module
 	   will be called "rtc-snvs".
 
+config RTC_DRV_MOXART
+	tristate "MOXA ART RTC"
+	help
+	   If you say yes here you get support for the MOXA ART
+	   RTC module.
+
+	   This driver can also be built as a module. If so, the module
+	   will be called rtc-moxart
+
 comment "HID Sensor RTC drivers"
 
 config RTC_DRV_HID_SENSOR_TIME
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index c33f86f..c0381fd 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
 obj-$(CONFIG_RTC_DRV_MAX77686)	+= rtc-max77686.o
 obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
 obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
+obj-$(CONFIG_RTC_DRV_MOXART)	+= rtc-moxart.o
 obj-$(CONFIG_RTC_DRV_MPC5121)	+= rtc-mpc5121.o
 obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
 obj-$(CONFIG_RTC_DRV_NUC900)	+= rtc-nuc900.o
diff --git a/drivers/rtc/rtc-moxart.c b/drivers/rtc/rtc-moxart.c
new file mode 100644
index 0000000..cfdbedc
--- /dev/null
+++ b/drivers/rtc/rtc-moxart.c
@@ -0,0 +1,335 @@
+/*
+ * MOXA ART RTC driver.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * Based on code from
+ * Moxa Technology Co., Ltd. <www.moxa.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+
+#define GPIO_EM1240_HIGH			1
+#define GPIO_EM1240_LOW				0
+#define GPIO_EM1240_OUTPUT			1
+#define GPIO_EM1240_INPUT			0
+
+#define GPIO_RTC_SCLK				(5)
+#define GPIO_RTC_DATA				(6)
+#define GPIO_RTC_RESET				(7)
+
+#define GPIO_RTC_RESERVED			0x0C
+#define GPIO_RTC_DATA_SET			0x10
+#define GPIO_RTC_DATA_CLEAR			0x14
+#define GPIO_RTC_PIN_PULL_ENABLE		0x18
+#define GPIO_RTC_PIN_PULL_TYPE			0x1C
+#define GPIO_RTC_INT_ENABLE			0x20
+#define GPIO_RTC_INT_RAW_STATE			0x24
+#define GPIO_RTC_INT_MASKED_STATE		0x28
+#define GPIO_RTC_INT_MASK			0x2C
+#define GPIO_RTC_INT_CLEAR			0x30
+#define GPIO_RTC_INT_TRIGGER			0x34
+#define GPIO_RTC_INT_BOTH			0x38
+#define GPIO_RTC_INT_RISE_NEG			0x3C
+#define GPIO_RTC_BOUNCE_ENABLE			0x40
+#define GPIO_RTC_BOUNCE_PRE_SCALE		0x44
+
+#define GPIO_RTC_PROTECT_W			0x8E
+#define GPIO_RTC_PROTECT_R			0x8F
+#define GPIO_RTC_YEAR_W				0x8C
+#define GPIO_RTC_YEAR_R				0x8D
+#define GPIO_RTC_DAY_W				0x8A
+#define GPIO_RTC_DAY_R				0x8B
+#define GPIO_RTC_MONTH_W			0x88
+#define GPIO_RTC_MONTH_R			0x89
+#define GPIO_RTC_DATE_W				0x86
+#define GPIO_RTC_DATE_R				0x87
+#define GPIO_RTC_HOURS_W			0x84
+#define GPIO_RTC_HOURS_R			0x85
+#define GPIO_RTC_MINUTES_W			0x82
+#define GPIO_RTC_MINUTES_R			0x83
+#define GPIO_RTC_SECONDS_W			0x80
+#define GPIO_RTC_SECONDS_R			0x81
+#define GPIO_RTC_DELAY_TIME			8	/* 8 usecond */
+#define GPIO_RTC_IS_OPEN			0x01	/* /dev/rtc in use */
+#define GPIO_PIO(x)				(1 << x)
+
+struct rtc_plat_data {
+	struct rtc_device *rtc;
+};
+
+static spinlock_t rtc_lock;
+static int day_of_year[12] =	{ 0, 31, 59, 90, 120, 151, 181,
+				  212, 243, 273, 304, 334 };
+
+void moxart_rtc_write_byte(u8 data)
+{
+	int i;
+
+	for (i = 0; i < 8; i++, data >>= 1) {
+		gpio_set_value(GPIO_RTC_SCLK, GPIO_EM1240_LOW);
+		gpio_set_value(GPIO_RTC_DATA, ((data & 1) == 1));
+		udelay(GPIO_RTC_DELAY_TIME);
+		gpio_set_value(GPIO_RTC_SCLK, GPIO_EM1240_HIGH);
+		udelay(GPIO_RTC_DELAY_TIME);
+	}
+}
+
+u8 moxart_rtc_read_byte(void)
+{
+	int i;
+	u8 data = 0;
+
+	for (i = 0; i < 8; i++) {
+		gpio_set_value(GPIO_RTC_SCLK, GPIO_EM1240_LOW);
+		udelay(GPIO_RTC_DELAY_TIME);
+		gpio_set_value(GPIO_RTC_SCLK, GPIO_EM1240_HIGH);
+		if (gpio_get_value(GPIO_RTC_DATA))
+			data |= (1 << i);
+		udelay(GPIO_RTC_DELAY_TIME);
+	}
+	return data;
+}
+
+static u8 moxart_rtc_read_register(u8 cmd)
+{
+	u8 data;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	gpio_direction_output(GPIO_RTC_DATA, 0);
+	gpio_set_value(GPIO_RTC_RESET, GPIO_EM1240_HIGH);
+	udelay(GPIO_RTC_DELAY_TIME);
+	moxart_rtc_write_byte(cmd);
+	gpio_direction_input(GPIO_RTC_DATA);
+	udelay(GPIO_RTC_DELAY_TIME);
+	data = moxart_rtc_read_byte();
+	gpio_set_value(GPIO_RTC_SCLK, GPIO_EM1240_LOW);
+	gpio_set_value(GPIO_RTC_RESET, GPIO_EM1240_LOW);
+	udelay(GPIO_RTC_DELAY_TIME);
+
+	local_irq_restore(flags);
+
+	return data;
+}
+
+static void moxart_rtc_write_register(u8 cmd, u8 data)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	gpio_direction_output(GPIO_RTC_DATA, 0);
+	gpio_set_value(GPIO_RTC_RESET, GPIO_EM1240_HIGH);
+	udelay(GPIO_RTC_DELAY_TIME);
+	moxart_rtc_write_byte(cmd);
+	moxart_rtc_write_byte(data);
+	gpio_set_value(GPIO_RTC_SCLK, GPIO_EM1240_LOW);
+	gpio_set_value(GPIO_RTC_RESET, GPIO_EM1240_LOW);
+	udelay(GPIO_RTC_DELAY_TIME);
+
+	local_irq_restore(flags);
+}
+
+static int moxart_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	spin_lock_irq(&rtc_lock);
+
+	moxart_rtc_write_register(GPIO_RTC_PROTECT_W, 0);
+	moxart_rtc_write_register(GPIO_RTC_YEAR_W,
+				  (((tm->tm_year - 100) / 10) << 4) |
+				  ((tm->tm_year - 100) % 10));
+
+	moxart_rtc_write_register(GPIO_RTC_MONTH_W,
+				  (((tm->tm_mon + 1) / 10) << 4) |
+				  ((tm->tm_mon + 1) % 10));
+
+	moxart_rtc_write_register(GPIO_RTC_DATE_W,
+				  ((tm->tm_mday / 10) << 4) |
+				  (tm->tm_mday % 10));
+
+	moxart_rtc_write_register(GPIO_RTC_HOURS_W,
+				  ((tm->tm_hour / 10) << 4) |
+				  (tm->tm_hour % 10));
+
+	moxart_rtc_write_register(GPIO_RTC_MINUTES_W,
+				  ((tm->tm_min / 10) << 4) |
+				  (tm->tm_min % 10));
+
+	moxart_rtc_write_register(GPIO_RTC_SECONDS_W,
+				  ((tm->tm_sec / 10) << 4) |
+				  (tm->tm_sec % 10));
+
+	moxart_rtc_write_register(GPIO_RTC_PROTECT_W, 0x80);
+
+	spin_unlock_irq(&rtc_lock);
+
+	dev_dbg(dev, "%s: success tm_year=%d tm_mon=%d\n"
+		"tm_mday=%d tm_hour=%d tm_min=%d tm_sec=%d\n",
+		__func__, tm->tm_year, tm->tm_mon, tm->tm_mday,
+		tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+	return 0;
+}
+
+static int moxart_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	unsigned char v;
+
+	spin_lock_irq(&rtc_lock);
+
+	v = moxart_rtc_read_register(GPIO_RTC_SECONDS_R);
+	tm->tm_sec = (((v & 0x70) >> 4) * 10) + (v & 0x0F);
+
+	v = moxart_rtc_read_register(GPIO_RTC_MINUTES_R);
+	tm->tm_min = (((v & 0x70) >> 4) * 10) + (v & 0x0F);
+
+	v = moxart_rtc_read_register(GPIO_RTC_HOURS_R);
+	if (v & 0x80) { /* 12-hour mode */
+		tm->tm_hour = (((v & 0x10) >> 4) * 10) + (v & 0x0F);
+		if (v & 0x20) { /* PM mode */
+			tm->tm_hour += 12;
+			if (tm->tm_hour >= 24)
+				tm->tm_hour = 0;
+		}
+	} else { /* 24-hour mode */
+		tm->tm_hour = (((v & 0x30) >> 4) * 10) + (v & 0x0F);
+	}
+
+	v = moxart_rtc_read_register(GPIO_RTC_DATE_R);
+	tm->tm_mday = (((v & 0x30) >> 4) * 10) + (v & 0x0F);
+
+	v = moxart_rtc_read_register(GPIO_RTC_MONTH_R);
+	tm->tm_mon = (((v & 0x10) >> 4) * 10) + (v & 0x0F);
+	tm->tm_mon--;
+
+	v = moxart_rtc_read_register(GPIO_RTC_YEAR_R);
+	tm->tm_year = (((v & 0xF0) >> 4) * 10) + (v & 0x0F);
+	tm->tm_year += 100;
+	if (tm->tm_year <= 69)
+		tm->tm_year += 100;
+
+	v = moxart_rtc_read_register(GPIO_RTC_DAY_R);
+	tm->tm_wday = (v & 0x0f) - 1;
+	tm->tm_yday = day_of_year[tm->tm_mon];
+	tm->tm_yday += (tm->tm_mday - 1);
+	if (tm->tm_mon >= 2) {
+		if (!(tm->tm_year % 4) && (tm->tm_year % 100))
+			tm->tm_yday++;
+	}
+
+	tm->tm_isdst = 0;
+
+	spin_unlock_irq(&rtc_lock);
+
+	return 0;
+}
+
+static int moxart_rtc_ioctl(struct device *dev, unsigned int cmd,
+	unsigned long arg)
+{
+	switch (cmd) {
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return 0;
+}
+
+static const struct rtc_class_ops moxart_rtc_ops = {
+	.read_time	= moxart_rtc_read_time,
+	.set_time	= moxart_rtc_set_time,
+	.ioctl		= moxart_rtc_ioctl,
+};
+
+static int moxart_rtc_probe(struct platform_device *pdev)
+{
+	struct rtc_device *rtc;
+	struct rtc_plat_data *pdata = NULL;
+	int ret = 0;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&pdev->dev, "devm_kzalloc failed\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&rtc_lock);
+
+	gpio_request(GPIO_RTC_DATA, "rtc_data");
+	gpio_request(GPIO_RTC_SCLK, "rtc_sclk");
+	gpio_request(GPIO_RTC_RESET, "rtc_reset");
+
+	gpio_direction_output(GPIO_RTC_RESET, 0);
+	gpio_direction_output(GPIO_RTC_SCLK, 0);
+
+	rtc = rtc_device_register(pdev->name, &pdev->dev,
+		&moxart_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		ret = PTR_ERR(rtc);
+		goto out;
+	}
+
+	pdata->rtc = rtc;
+	platform_set_drvdata(pdev, pdata);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	if (ret)
+		goto out;
+
+	return 0;
+
+ out:
+	if (pdata->rtc)
+		rtc_device_unregister(pdata->rtc);
+	devm_kfree(&pdev->dev, pdata);
+	return ret;
+}
+
+static int moxart_rtc_remove(struct platform_device *pdev)
+{
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+
+	gpio_free(GPIO_RTC_DATA);
+	gpio_free(GPIO_RTC_SCLK);
+	gpio_free(GPIO_RTC_RESET);
+
+	rtc_device_unregister(pdata->rtc);
+	devm_kfree(&pdev->dev, pdata);
+
+	return 0;
+}
+
+static const struct of_device_id moxart_rtc_match[] = {
+	{ .compatible = "moxa,moxart-rtc" },
+	{ },
+};
+
+static struct platform_driver moxart_rtc_driver = {
+	.probe	= moxart_rtc_probe,
+	.remove	= moxart_rtc_remove,
+	.driver	= {
+		.name		= "moxart-rtc",
+		.owner		= THIS_MODULE,
+		.of_match_table	= moxart_rtc_match,
+	},
+};
+module_platform_driver(moxart_rtc_driver);
+
+MODULE_DESCRIPTION("MOXART RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
-- 
1.8.2.1

