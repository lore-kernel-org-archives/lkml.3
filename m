Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab3GPMlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:41:42 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:36589 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3GPMll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:41:41 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, broonie@kernel.org,
        arnd@arndb.de, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v3] rtc: Add MOXA ART RTC driver
Date: Tue, 16 Jul 2013 14:41:25 +0200
Message-Id: <1373978485-17496-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1373550711-18828-1-git-send-email-jonas.jensen@gmail.com>
References: <1373550711-18828-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RTC driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Thanks for the replies. This should fix the remaining issues mentioned by Mark and Arnd.
    
    Changes since v2:
    
    1. don't use hardcoded GPIO numbers, use of_get_named_gpio
    2. make two functions static, moxart_rtc_write_byte and moxart_rtc_read_byte
    3. use devm_gpio_request_one where appropriate
    4. add gpio_is_valid check to all of_get_named_gpio
    5. check devm_gpio_request return value
    6. use devm_rtc_device_register instead of rtc_device_register
    7. remove label "out" from moxart_rtc_probe
    8. remove moxart_rtc_remove function
    
    Applies to next-20130716

 drivers/rtc/Kconfig      |   9 ++
 drivers/rtc/Makefile     |   1 +
 drivers/rtc/rtc-moxart.c | 330 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 340 insertions(+)
 create mode 100644 drivers/rtc/rtc-moxart.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 9e3498b..9654aa3 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1249,6 +1249,15 @@ config RTC_DRV_SIRFSOC
 	  Say "yes" here to support the real time clock on SiRF SOC chips.
 	  This driver can also be built as a module called rtc-sirfsoc.
 
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
index d3b4488..2dff3d2 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -130,3 +130,4 @@ obj-$(CONFIG_RTC_DRV_WM831X)	+= rtc-wm831x.o
 obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
 obj-$(CONFIG_RTC_DRV_SIRFSOC)	+= rtc-sirfsoc.o
+obj-$(CONFIG_RTC_DRV_MOXART)	+= rtc-moxart.o
diff --git a/drivers/rtc/rtc-moxart.c b/drivers/rtc/rtc-moxart.c
new file mode 100644
index 0000000..c29dee0
--- /dev/null
+++ b/drivers/rtc/rtc-moxart.c
@@ -0,0 +1,330 @@
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
+#include <linux/of_gpio.h>
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
+#define GPIO_RTC_DELAY_TIME			8
+
+struct moxart_rtc {
+	struct rtc_device *rtc;
+	spinlock_t rtc_lock;
+	int gpio_data, gpio_sclk, gpio_reset;
+};
+
+static int day_of_year[12] =	{ 0, 31, 59, 90, 120, 151, 181,
+				  212, 243, 273, 304, 334 };
+
+static void moxart_rtc_write_byte(struct device *dev, u8 data)
+{
+	struct moxart_rtc *moxart_rtc = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < 8; i++, data >>= 1) {
+		gpio_set_value(moxart_rtc->gpio_sclk, 0);
+		gpio_set_value(moxart_rtc->gpio_data, ((data & 1) == 1));
+		udelay(GPIO_RTC_DELAY_TIME);
+		gpio_set_value(moxart_rtc->gpio_sclk, 1);
+		udelay(GPIO_RTC_DELAY_TIME);
+	}
+}
+
+static u8 moxart_rtc_read_byte(struct device *dev)
+{
+	struct moxart_rtc *moxart_rtc = dev_get_drvdata(dev);
+	int i;
+	u8 data = 0;
+
+	for (i = 0; i < 8; i++) {
+		gpio_set_value(moxart_rtc->gpio_sclk, 0);
+		udelay(GPIO_RTC_DELAY_TIME);
+		gpio_set_value(moxart_rtc->gpio_sclk, 1);
+		udelay(GPIO_RTC_DELAY_TIME);
+		if (gpio_get_value(moxart_rtc->gpio_data))
+			data |= (1 << i);
+		udelay(GPIO_RTC_DELAY_TIME);
+	}
+	return data;
+}
+
+static u8 moxart_rtc_read_register(struct device *dev, u8 cmd)
+{
+	struct moxart_rtc *moxart_rtc = dev_get_drvdata(dev);
+	u8 data;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	gpio_direction_output(moxart_rtc->gpio_data, 0);
+	gpio_set_value(moxart_rtc->gpio_reset, 1);
+	udelay(GPIO_RTC_DELAY_TIME);
+	moxart_rtc_write_byte(dev, cmd);
+	gpio_direction_input(moxart_rtc->gpio_data);
+	udelay(GPIO_RTC_DELAY_TIME);
+	data = moxart_rtc_read_byte(dev);
+	gpio_set_value(moxart_rtc->gpio_sclk, 0);
+	gpio_set_value(moxart_rtc->gpio_reset, 0);
+	udelay(GPIO_RTC_DELAY_TIME);
+
+	local_irq_restore(flags);
+
+	return data;
+}
+
+static void moxart_rtc_write_register(struct device *dev, u8 cmd, u8 data)
+{
+	struct moxart_rtc *moxart_rtc = dev_get_drvdata(dev);
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	gpio_direction_output(moxart_rtc->gpio_data, 0);
+	gpio_set_value(moxart_rtc->gpio_reset, 1);
+	udelay(GPIO_RTC_DELAY_TIME);
+	moxart_rtc_write_byte(dev, cmd);
+	moxart_rtc_write_byte(dev, data);
+	gpio_set_value(moxart_rtc->gpio_sclk, 0);
+	gpio_set_value(moxart_rtc->gpio_reset, 0);
+	udelay(GPIO_RTC_DELAY_TIME);
+
+	local_irq_restore(flags);
+}
+
+static int moxart_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct moxart_rtc *moxart_rtc = dev_get_drvdata(dev);
+
+	spin_lock_irq(&moxart_rtc->rtc_lock);
+
+	moxart_rtc_write_register(dev, GPIO_RTC_PROTECT_W, 0);
+	moxart_rtc_write_register(dev, GPIO_RTC_YEAR_W,
+				  (((tm->tm_year - 100) / 10) << 4) |
+				  ((tm->tm_year - 100) % 10));
+
+	moxart_rtc_write_register(dev, GPIO_RTC_MONTH_W,
+				  (((tm->tm_mon + 1) / 10) << 4) |
+				  ((tm->tm_mon + 1) % 10));
+
+	moxart_rtc_write_register(dev, GPIO_RTC_DATE_W,
+				  ((tm->tm_mday / 10) << 4) |
+				  (tm->tm_mday % 10));
+
+	moxart_rtc_write_register(dev, GPIO_RTC_HOURS_W,
+				  ((tm->tm_hour / 10) << 4) |
+				  (tm->tm_hour % 10));
+
+	moxart_rtc_write_register(dev, GPIO_RTC_MINUTES_W,
+				  ((tm->tm_min / 10) << 4) |
+				  (tm->tm_min % 10));
+
+	moxart_rtc_write_register(dev, GPIO_RTC_SECONDS_W,
+				  ((tm->tm_sec / 10) << 4) |
+				  (tm->tm_sec % 10));
+
+	moxart_rtc_write_register(dev, GPIO_RTC_PROTECT_W, 0x80);
+
+	spin_unlock_irq(&moxart_rtc->rtc_lock);
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
+	struct moxart_rtc *moxart_rtc = dev_get_drvdata(dev);
+	unsigned char v;
+
+	spin_lock_irq(&moxart_rtc->rtc_lock);
+
+	v = moxart_rtc_read_register(dev, GPIO_RTC_SECONDS_R);
+	tm->tm_sec = (((v & 0x70) >> 4) * 10) + (v & 0x0F);
+
+	v = moxart_rtc_read_register(dev, GPIO_RTC_MINUTES_R);
+	tm->tm_min = (((v & 0x70) >> 4) * 10) + (v & 0x0F);
+
+	v = moxart_rtc_read_register(dev, GPIO_RTC_HOURS_R);
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
+	v = moxart_rtc_read_register(dev, GPIO_RTC_DATE_R);
+	tm->tm_mday = (((v & 0x30) >> 4) * 10) + (v & 0x0F);
+
+	v = moxart_rtc_read_register(dev, GPIO_RTC_MONTH_R);
+	tm->tm_mon = (((v & 0x10) >> 4) * 10) + (v & 0x0F);
+	tm->tm_mon--;
+
+	v = moxart_rtc_read_register(dev, GPIO_RTC_YEAR_R);
+	tm->tm_year = (((v & 0xF0) >> 4) * 10) + (v & 0x0F);
+	tm->tm_year += 100;
+	if (tm->tm_year <= 69)
+		tm->tm_year += 100;
+
+	v = moxart_rtc_read_register(dev, GPIO_RTC_DAY_R);
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
+	spin_unlock_irq(&moxart_rtc->rtc_lock);
+
+	return 0;
+}
+
+static const struct rtc_class_ops moxart_rtc_ops = {
+	.read_time	= moxart_rtc_read_time,
+	.set_time	= moxart_rtc_set_time,
+};
+
+static int moxart_rtc_probe(struct platform_device *pdev)
+{
+	struct moxart_rtc *moxart_rtc;
+	int ret = 0;
+
+	moxart_rtc = devm_kzalloc(&pdev->dev, sizeof(*moxart_rtc), GFP_KERNEL);
+	if (!moxart_rtc) {
+		dev_err(&pdev->dev, "devm_kzalloc failed\n");
+		return -ENOMEM;
+	}
+
+	moxart_rtc->gpio_data = of_get_named_gpio(pdev->dev.of_node,
+						  "gpio-rtc-data", 0);
+	if (!gpio_is_valid(moxart_rtc->gpio_data)) {
+		dev_err(&pdev->dev, "invalid gpio (data): %d\n",
+			moxart_rtc->gpio_data);
+		return moxart_rtc->gpio_data;
+	}
+
+	moxart_rtc->gpio_sclk = of_get_named_gpio(pdev->dev.of_node,
+						  "gpio-rtc-sclk", 0);
+	if (!gpio_is_valid(moxart_rtc->gpio_sclk)) {
+		dev_err(&pdev->dev, "invalid gpio (sclk): %d\n",
+			moxart_rtc->gpio_sclk);
+		return moxart_rtc->gpio_sclk;
+	}
+
+	moxart_rtc->gpio_reset = of_get_named_gpio(pdev->dev.of_node,
+						   "gpio-rtc-reset", 0);
+	if (!gpio_is_valid(moxart_rtc->gpio_reset)) {
+		dev_err(&pdev->dev, "invalid gpio (reset): %d\n",
+			moxart_rtc->gpio_reset);
+		return moxart_rtc->gpio_reset;
+	}
+
+	spin_lock_init(&moxart_rtc->rtc_lock);
+	platform_set_drvdata(pdev, moxart_rtc);
+
+	ret = devm_gpio_request(&pdev->dev, moxart_rtc->gpio_data, "rtc_data");
+	if (ret) {
+		dev_err(&pdev->dev, "can't get rtc_data gpio\n");
+		return ret;
+	}
+
+	ret = devm_gpio_request_one(&pdev->dev, moxart_rtc->gpio_sclk,
+				    GPIOF_DIR_OUT, "rtc_sclk");
+	if (ret) {
+		dev_err(&pdev->dev, "can't get rtc_sclk gpio\n");
+		return ret;
+	}
+
+	ret = devm_gpio_request_one(&pdev->dev, moxart_rtc->gpio_reset,
+				    GPIOF_DIR_OUT, "rtc_reset");
+	if (ret) {
+		dev_err(&pdev->dev, "can't get rtc_reset gpio\n");
+		return ret;
+	}
+
+	moxart_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+						   &moxart_rtc_ops,
+						   THIS_MODULE);
+	if (IS_ERR(moxart_rtc->rtc)) {
+		dev_err(&pdev->dev, "devm_rtc_device_register failed\n");
+		return PTR_ERR(moxart_rtc->rtc);
+	}
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

