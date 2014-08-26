Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbaHZDzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 23:55:04 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34341 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbaHZDzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 23:55:01 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-sunxi@googlegroups.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Varka Bhadram <varkabhadram@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        rtc-linux@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH resend v5 1/2] rtc: sun6i: Add sun6i RTC driver
Date: Tue, 26 Aug 2014 11:54:55 +0800
Message-Id: <1409025296-6342-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409025296-6342-1-git-send-email-wens@csie.org>
References: <1409025296-6342-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the driver for the RTC in the Allwinner A31 and
A23 SoCs.

Unlike the RTC found in A10/A20 SoCs, which was part of the timer, the
RTC in A31/A23 are a separate hardware block, which also contain a few
controls for the RTC block hardware (a regulator and RTC block GPIO pin
latches), while also having separate interrupts for the alarms.

The hardware is different enough to make a different driver for it.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Reviewed-by: Varka Bhadram <varkabhadram@gmail.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../devicetree/bindings/rtc/sun6i-rtc.txt          |  17 +
 drivers/rtc/Kconfig                                |   7 +
 drivers/rtc/Makefile                               |   1 +
 drivers/rtc/rtc-sun6i.c                            | 447 +++++++++++++++++++++
 4 files changed, 472 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/sun6i-rtc.txt
 create mode 100644 drivers/rtc/rtc-sun6i.c

diff --git a/Documentation/devicetree/bindings/rtc/sun6i-rtc.txt b/Documentation/devicetree/bindings/rtc/sun6i-rtc.txt
new file mode 100644
index 0000000..f007e42
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/sun6i-rtc.txt
@@ -0,0 +1,17 @@
+* sun6i Real Time Clock
+
+RTC controller for the Allwinner A31
+
+Required properties:
+- compatible	: Should be "allwinner,sun6i-a31-rtc"
+- reg		: physical base address of the controller and length of
+		  memory mapped region.
+- interrupts	: IRQ lines for the RTC alarm 0 and alarm 1, in that order.
+
+Example:
+
+rtc: rtc@01f00000 {
+	compatible = "allwinner,sun6i-a31-rtc";
+	reg = <0x01f00000 0x54>;
+	interrupts = <0 40 4>, <0 41 4>;
+};
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index a168e96..f2300b4 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1175,6 +1175,13 @@ config RTC_DRV_SUN4V
 	  If you say Y here you will get support for the Hypervisor
 	  based RTC on SUN4V systems.
 
+config RTC_DRV_SUN6I
+	tristate "Allwinner A31 RTC"
+	depends on MACH_SUN6I || MACH_SUN8I
+	help
+	  If you say Y here you will get support for the RTC found on
+	  Allwinner A31.
+
 config RTC_DRV_SUNXI
 	tristate "Allwinner sun4i/sun7i RTC"
 	depends on ARCH_SUNXI
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 56f061c..9055b7d 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -128,6 +128,7 @@ obj-$(CONFIG_RTC_DRV_STARFIRE)	+= rtc-starfire.o
 obj-$(CONFIG_RTC_DRV_STK17TA8)	+= rtc-stk17ta8.o
 obj-$(CONFIG_RTC_DRV_STMP)	+= rtc-stmp3xxx.o
 obj-$(CONFIG_RTC_DRV_SUN4V)	+= rtc-sun4v.o
+obj-$(CONFIG_RTC_DRV_SUN6I)	+= rtc-sun6i.o
 obj-$(CONFIG_RTC_DRV_SUNXI)	+= rtc-sunxi.o
 obj-$(CONFIG_RTC_DRV_TEGRA)	+= rtc-tegra.o
 obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
new file mode 100644
index 0000000..c169a2c
--- /dev/null
+++ b/drivers/rtc/rtc-sun6i.c
@@ -0,0 +1,447 @@
+/*
+ * An RTC driver for Allwinner A31/A23
+ *
+ * Copyright (c) 2014, Chen-Yu Tsai <wens@csie.org>
+ *
+ * based on rtc-sunxi.c
+ *
+ * An RTC driver for Allwinner A10/A20
+ *
+ * Copyright (c) 2013, Carlo Caione <carlo.caione@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/types.h>
+
+/* Control register */
+#define SUN6I_LOSC_CTRL				0x0000
+#define SUN6I_LOSC_CTRL_ALM_DHMS_ACC		BIT(9)
+#define SUN6I_LOSC_CTRL_RTC_HMS_ACC		BIT(8)
+#define SUN6I_LOSC_CTRL_RTC_YMD_ACC		BIT(7)
+#define SUN6I_LOSC_CTRL_ACC_MASK		GENMASK(9, 7)
+
+/* RTC */
+#define SUN6I_RTC_YMD				0x0010
+#define SUN6I_RTC_HMS				0x0014
+
+/* Alarm 0 (counter) */
+#define SUN6I_ALRM_COUNTER			0x0020
+#define SUN6I_ALRM_CUR_VAL			0x0024
+#define SUN6I_ALRM_EN				0x0028
+#define SUN6I_ALRM_EN_CNT_EN			BIT(0)
+#define SUN6I_ALRM_IRQ_EN			0x002c
+#define SUN6I_ALRM_IRQ_EN_CNT_IRQ_EN		BIT(0)
+#define SUN6I_ALRM_IRQ_STA			0x0030
+#define SUN6I_ALRM_IRQ_STA_CNT_IRQ_PEND		BIT(0)
+
+/* Alarm 1 (wall clock) */
+#define SUN6I_ALRM1_EN				0x0044
+#define SUN6I_ALRM1_IRQ_EN			0x0048
+#define SUN6I_ALRM1_IRQ_STA			0x004c
+#define SUN6I_ALRM1_IRQ_STA_WEEK_IRQ_PEND	BIT(0)
+
+/* Alarm config */
+#define SUN6I_ALARM_CONFIG			0x0050
+#define SUN6I_ALARM_CONFIG_WAKEUP		BIT(0)
+
+/*
+ * Get date values
+ */
+#define SUN6I_DATE_GET_DAY_VALUE(x)		((x)  & 0x0000001f)
+#define SUN6I_DATE_GET_MON_VALUE(x)		(((x) & 0x00000f00) >> 8)
+#define SUN6I_DATE_GET_YEAR_VALUE(x)		(((x) & 0x003f0000) >> 16)
+#define SUN6I_LEAP_GET_VALUE(x)			(((x) & 0x00400000) >> 22)
+
+/*
+ * Get time values
+ */
+#define SUN6I_TIME_GET_SEC_VALUE(x)		((x)  & 0x0000003f)
+#define SUN6I_TIME_GET_MIN_VALUE(x)		(((x) & 0x00003f00) >> 8)
+#define SUN6I_TIME_GET_HOUR_VALUE(x)		(((x) & 0x001f0000) >> 16)
+
+/*
+ * Set date values
+ */
+#define SUN6I_DATE_SET_DAY_VALUE(x)		((x)       & 0x0000001f)
+#define SUN6I_DATE_SET_MON_VALUE(x)		((x) <<  8 & 0x00000f00)
+#define SUN6I_DATE_SET_YEAR_VALUE(x)		((x) << 16 & 0x003f0000)
+#define SUN6I_LEAP_SET_VALUE(x)			((x) << 22 & 0x00400000)
+
+/*
+ * Set time values
+ */
+#define SUN6I_TIME_SET_SEC_VALUE(x)		((x)       & 0x0000003f)
+#define SUN6I_TIME_SET_MIN_VALUE(x)		((x) <<  8 & 0x00003f00)
+#define SUN6I_TIME_SET_HOUR_VALUE(x)		((x) << 16 & 0x001f0000)
+
+/*
+ * The year parameter passed to the driver is usually an offset relative to
+ * the year 1900. This macro is used to convert this offset to another one
+ * relative to the minimum year allowed by the hardware.
+ *
+ * The year range is 1970 - 2033. This range is selected to match Allwinner's
+ * driver, even though it is somewhat limited.
+ */
+#define SUN6I_YEAR_MIN				1970
+#define SUN6I_YEAR_MAX				2033
+#define SUN6I_YEAR_OFF				(SUN6I_YEAR_MIN - 1900)
+
+struct sun6i_rtc_dev {
+	struct rtc_device *rtc;
+	struct device *dev;
+	void __iomem *base;
+	int irq;
+	unsigned long alarm;
+};
+
+static irqreturn_t sun6i_rtc_alarmirq(int irq, void *id)
+{
+	struct sun6i_rtc_dev *chip = (struct sun6i_rtc_dev *) id;
+	u32 val;
+
+	val = readl(chip->base + SUN6I_ALRM_IRQ_STA);
+
+	if (val & SUN6I_ALRM_IRQ_STA_CNT_IRQ_PEND) {
+		val |= SUN6I_ALRM_IRQ_STA_CNT_IRQ_PEND;
+		writel(val, chip->base + SUN6I_ALRM_IRQ_STA);
+
+		rtc_update_irq(chip->rtc, 1, RTC_AF | RTC_IRQF);
+
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static void sun6i_rtc_setaie(int to, struct sun6i_rtc_dev *chip)
+{
+	u32 alrm_val = 0;
+	u32 alrm_irq_val = 0;
+	u32 alrm_wake_val = 0;
+
+	if (to) {
+		alrm_val = SUN6I_ALRM_EN_CNT_EN;
+		alrm_irq_val = SUN6I_ALRM_IRQ_EN_CNT_IRQ_EN;
+		alrm_wake_val = SUN6I_ALARM_CONFIG_WAKEUP;
+	} else {
+		writel(SUN6I_ALRM_IRQ_STA_CNT_IRQ_PEND,
+		       chip->base + SUN6I_ALRM_IRQ_STA);
+	}
+
+	writel(alrm_val, chip->base + SUN6I_ALRM_EN);
+	writel(alrm_irq_val, chip->base + SUN6I_ALRM_IRQ_EN);
+	writel(alrm_wake_val, chip->base + SUN6I_ALARM_CONFIG);
+}
+
+static int sun6i_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
+{
+	struct sun6i_rtc_dev *chip = dev_get_drvdata(dev);
+	u32 date, time;
+
+	/*
+	 * read again in case it changes
+	 */
+	do {
+		date = readl(chip->base + SUN6I_RTC_YMD);
+		time = readl(chip->base + SUN6I_RTC_HMS);
+	} while ((date != readl(chip->base + SUN6I_RTC_YMD)) ||
+		 (time != readl(chip->base + SUN6I_RTC_HMS)));
+
+	rtc_tm->tm_sec  = SUN6I_TIME_GET_SEC_VALUE(time);
+	rtc_tm->tm_min  = SUN6I_TIME_GET_MIN_VALUE(time);
+	rtc_tm->tm_hour = SUN6I_TIME_GET_HOUR_VALUE(time);
+
+	rtc_tm->tm_mday = SUN6I_DATE_GET_DAY_VALUE(date);
+	rtc_tm->tm_mon  = SUN6I_DATE_GET_MON_VALUE(date);
+	rtc_tm->tm_year = SUN6I_DATE_GET_YEAR_VALUE(date);
+
+	rtc_tm->tm_mon  -= 1;
+
+	/*
+	 * switch from (data_year->min)-relative offset to
+	 * a (1900)-relative one
+	 */
+	rtc_tm->tm_year += SUN6I_YEAR_OFF;
+
+	return rtc_valid_tm(rtc_tm);
+}
+
+static int sun6i_rtc_getalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
+{
+	struct sun6i_rtc_dev *chip = dev_get_drvdata(dev);
+	u32 alrm_st;
+	u32 alrm_en;
+
+	alrm_en = readl(chip->base + SUN6I_ALRM_IRQ_EN);
+	alrm_st = readl(chip->base + SUN6I_ALRM_IRQ_STA);
+	wkalrm->enabled = !!(alrm_en & SUN6I_ALRM_EN_CNT_EN);
+	wkalrm->pending = !!(alrm_st & SUN6I_ALRM_EN_CNT_EN);
+	rtc_time_to_tm(chip->alarm, &wkalrm->time);
+
+	return 0;
+}
+
+static int sun6i_rtc_setalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
+{
+	struct sun6i_rtc_dev *chip = dev_get_drvdata(dev);
+	struct rtc_time *alrm_tm = &wkalrm->time;
+	struct rtc_time tm_now;
+	unsigned long time_now = 0;
+	unsigned long time_set = 0;
+	unsigned long time_gap = 0;
+	int ret = 0;
+
+	ret = sun6i_rtc_gettime(dev, &tm_now);
+	if (ret < 0) {
+		dev_err(dev, "Error in getting time\n");
+		return -EINVAL;
+	}
+
+	rtc_tm_to_time(alrm_tm, &time_set);
+	rtc_tm_to_time(&tm_now, &time_now);
+	if (time_set <= time_now) {
+		dev_err(dev, "Date to set in the past\n");
+		return -EINVAL;
+	}
+
+	time_gap = time_set - time_now;
+
+	if (time_gap > U32_MAX) {
+		dev_err(dev, "Date too far in the future\n");
+		return -EINVAL;
+	}
+
+	sun6i_rtc_setaie(0, chip);
+	writel(0, chip->base + SUN6I_ALRM_COUNTER);
+	usleep_range(100, 300);
+
+	writel(time_gap, chip->base + SUN6I_ALRM_COUNTER);
+	chip->alarm = time_set;
+
+	sun6i_rtc_setaie(wkalrm->enabled, chip);
+
+	return 0;
+}
+
+static int sun6i_rtc_wait(struct sun6i_rtc_dev *chip, int offset,
+			  unsigned int mask, unsigned int ms_timeout)
+{
+	const unsigned long timeout = jiffies + msecs_to_jiffies(ms_timeout);
+	u32 reg;
+
+	do {
+		reg = readl(chip->base + offset);
+		reg &= mask;
+
+		if (!reg)
+			return 0;
+
+	} while (time_before(jiffies, timeout));
+
+	return -ETIMEDOUT;
+}
+
+static int sun6i_rtc_settime(struct device *dev, struct rtc_time *rtc_tm)
+{
+	struct sun6i_rtc_dev *chip = dev_get_drvdata(dev);
+	u32 date = 0;
+	u32 time = 0;
+	int year;
+
+	year = rtc_tm->tm_year + 1900;
+	if (year < SUN6I_YEAR_MIN || year > SUN6I_YEAR_MAX) {
+		dev_err(dev, "rtc only supports year in range %d - %d\n",
+			SUN6I_YEAR_MIN, SUN6I_YEAR_MAX);
+		return -EINVAL;
+	}
+
+	rtc_tm->tm_year -= SUN6I_YEAR_OFF;
+	rtc_tm->tm_mon += 1;
+
+	date = SUN6I_DATE_SET_DAY_VALUE(rtc_tm->tm_mday) |
+		SUN6I_DATE_SET_MON_VALUE(rtc_tm->tm_mon)  |
+		SUN6I_DATE_SET_YEAR_VALUE(rtc_tm->tm_year);
+
+	if (is_leap_year(year))
+		date |= SUN6I_LEAP_SET_VALUE(1);
+
+	time = SUN6I_TIME_SET_SEC_VALUE(rtc_tm->tm_sec)  |
+		SUN6I_TIME_SET_MIN_VALUE(rtc_tm->tm_min)  |
+		SUN6I_TIME_SET_HOUR_VALUE(rtc_tm->tm_hour);
+
+	/* Check whether registers are writable */
+	if (sun6i_rtc_wait(chip, SUN6I_LOSC_CTRL,
+			   SUN6I_LOSC_CTRL_ACC_MASK, 50)) {
+		dev_err(dev, "rtc is still busy.\n");
+		return -EBUSY;
+	}
+
+	writel(time, chip->base + SUN6I_RTC_HMS);
+
+	/*
+	 * After writing the RTC HH-MM-SS register, the
+	 * SUN6I_LOSC_CTRL_RTC_HMS_ACC bit is set and it will not
+	 * be cleared until the real writing operation is finished
+	 */
+
+	if (sun6i_rtc_wait(chip, SUN6I_LOSC_CTRL,
+			   SUN6I_LOSC_CTRL_RTC_HMS_ACC, 50)) {
+		dev_err(dev, "Failed to set rtc time.\n");
+		return -ETIMEDOUT;
+	}
+
+	writel(date, chip->base + SUN6I_RTC_YMD);
+
+	/*
+	 * After writing the RTC YY-MM-DD register, the
+	 * SUN6I_LOSC_CTRL_RTC_YMD_ACC bit is set and it will not
+	 * be cleared until the real writing operation is finished
+	 */
+
+	if (sun6i_rtc_wait(chip, SUN6I_LOSC_CTRL,
+			   SUN6I_LOSC_CTRL_RTC_YMD_ACC, 50)) {
+		dev_err(dev, "Failed to set rtc time.\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int sun6i_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct sun6i_rtc_dev *chip = dev_get_drvdata(dev);
+
+	if (!enabled)
+		sun6i_rtc_setaie(enabled, chip);
+
+	return 0;
+}
+
+static const struct rtc_class_ops sun6i_rtc_ops = {
+	.read_time		= sun6i_rtc_gettime,
+	.set_time		= sun6i_rtc_settime,
+	.read_alarm		= sun6i_rtc_getalarm,
+	.set_alarm		= sun6i_rtc_setalarm,
+	.alarm_irq_enable	= sun6i_rtc_alarm_irq_enable
+};
+
+static int sun6i_rtc_probe(struct platform_device *pdev)
+{
+	struct sun6i_rtc_dev *chip;
+	struct resource *res;
+	int ret;
+
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, chip);
+	chip->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	chip->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(chip->base))
+		return PTR_ERR(chip->base);
+
+	chip->irq = platform_get_irq(pdev, 0);
+	if (chip->irq < 0) {
+		dev_err(&pdev->dev, "No IRQ resource\n");
+		return chip->irq;
+	}
+
+	ret = devm_request_irq(&pdev->dev, chip->irq, sun6i_rtc_alarmirq,
+			       0, dev_name(&pdev->dev), chip);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not request IRQ\n");
+		return ret;
+	}
+
+	/* clear the alarm counter value */
+	writel(0, chip->base + SUN6I_ALRM_COUNTER);
+
+	/* disable counter alarm */
+	writel(0, chip->base + SUN6I_ALRM_EN);
+
+	/* disable counter alarm interrupt */
+	writel(0, chip->base + SUN6I_ALRM_IRQ_EN);
+
+	/* disable week alarm */
+	writel(0, chip->base + SUN6I_ALRM1_EN);
+
+	/* disable week alarm interrupt */
+	writel(0, chip->base + SUN6I_ALRM1_IRQ_EN);
+
+	/* clear counter alarm pending interrupts */
+	writel(SUN6I_ALRM_IRQ_STA_CNT_IRQ_PEND,
+	       chip->base + SUN6I_ALRM_IRQ_STA);
+
+	/* clear week alarm pending interrupts */
+	writel(SUN6I_ALRM1_IRQ_STA_WEEK_IRQ_PEND,
+	       chip->base + SUN6I_ALRM1_IRQ_STA);
+
+	/* disable alarm wakeup */
+	writel(0, chip->base + SUN6I_ALARM_CONFIG);
+
+	chip->rtc = rtc_device_register("rtc-sun6i", &pdev->dev,
+					&sun6i_rtc_ops, THIS_MODULE);
+	if (IS_ERR(chip->rtc)) {
+		dev_err(&pdev->dev, "unable to register device\n");
+		return PTR_ERR(chip->rtc);
+	}
+
+	dev_info(&pdev->dev, "RTC enabled\n");
+
+	return 0;
+}
+
+static int sun6i_rtc_remove(struct platform_device *pdev)
+{
+	struct sun6i_rtc_dev *chip = platform_get_drvdata(pdev);
+
+	rtc_device_unregister(chip->rtc);
+
+	return 0;
+}
+
+static const struct of_device_id sun6i_rtc_dt_ids[] = {
+	{ .compatible = "allwinner,sun6i-a31-rtc" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, sun6i_rtc_dt_ids);
+
+static struct platform_driver sun6i_rtc_driver = {
+	.probe		= sun6i_rtc_probe,
+	.remove		= sun6i_rtc_remove,
+	.driver		= {
+		.name		= "sun6i-rtc",
+		.of_match_table = sun6i_rtc_dt_ids,
+	},
+};
+
+module_platform_driver(sun6i_rtc_driver);
+
+MODULE_DESCRIPTION("sun6i RTC driver");
+MODULE_AUTHOR("Chen-Yu Tsai <wens@csie.org>");
+MODULE_LICENSE("GPL");
-- 
2.1.0

