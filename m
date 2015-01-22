Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbbAVL5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:57:18 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:46127 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbbAVL5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:57:12 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, rtc-linux@googlegroups.com,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux@roeck-us.net, david.paris@st.com
Subject: [PATCH v2 8/9] rtc: st: add new driver for ST's LPC RTC
Date: Thu, 22 Jan 2015 11:56:06 +0000
Message-Id: <1421927767-28889-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421927767-28889-1-git-send-email-lee.jones@linaro.org>
References: <1421927767-28889-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST's Low Power Controller (LPC) controls two devices; watchdog and RTC.
Only one of the devices can be used at any one time.  This is enforced
by the correlating MFD driver.  This portion of the driver-set controls
the Real Time Clock.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rtc/Kconfig      |  12 ++
 drivers/rtc/Makefile     |   1 +
 drivers/rtc/rtc-st-lpc.c | 354 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 367 insertions(+)
 create mode 100644 drivers/rtc/rtc-st-lpc.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index f15cddf..ca509e8 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1417,6 +1417,18 @@ config RTC_DRV_SIRFSOC
 	  Say "yes" here to support the real time clock on SiRF SOC chips.
 	  This driver can also be built as a module called rtc-sirfsoc.
 
+config RTC_DRV_ST_LPC
+	tristate "STMicroelectronics LPC RTC"
+	depends on ARCH_STI
+	depends on OF
+	select MFD_ST_LPC
+	help
+	  Say Y here to include STMicroelectronics Low Power Controller
+	  (LPC) based RTC support.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rtc-st-lpc.
+
 config RTC_DRV_MOXART
 	tristate "MOXA ART RTC"
 	depends on ARCH_MOXART || COMPILE_TEST
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index c8ef3e1..6dbb7d9 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -149,4 +149,5 @@ obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
 obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
 obj-$(CONFIG_RTC_DRV_XGENE)	+= rtc-xgene.o
 obj-$(CONFIG_RTC_DRV_SIRFSOC)	+= rtc-sirfsoc.o
+obj-$(CONFIG_RTC_DRV_ST_LPC)	+= rtc-st-lpc.o
 obj-$(CONFIG_RTC_DRV_MOXART)	+= rtc-moxart.o
diff --git a/drivers/rtc/rtc-st-lpc.c b/drivers/rtc/rtc-st-lpc.c
new file mode 100644
index 0000000..f1344ac
--- /dev/null
+++ b/drivers/rtc/rtc-st-lpc.c
@@ -0,0 +1,354 @@
+/*
+ * rtc-st-lpc.c - ST's LPC RTC, powered by the Low Power Timer
+ *
+ * Copyright (C) 2014 STMicroelectronics Limited
+ *
+ * Author: David Paris <david.paris@st.com> for STMicroelectronics
+ *         Lee Jones <lee.jones@linaro.org> for STMicroelectronics
+ *
+ * Based on the original driver written by Stuart Menefy.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+
+#include <dt-bindings/mfd/st-lpc.h>
+
+/* Low Power Timer */
+#define LPC_LPT_LSB_OFF		0x400
+#define LPC_LPT_MSB_OFF		0x404
+#define LPC_LPT_START_OFF	0x408
+
+/* Low Power Alarm */
+#define LPC_LPA_LSB_OFF		0x410
+#define LPC_LPA_MSB_OFF		0x414
+#define LPC_LPA_START_OFF	0x418
+
+/* LPC as WDT */
+#define LPC_WDT_OFF		0x510
+#define LPC_WDT_FLAG_OFF	0x514
+
+struct st_rtc {
+	struct rtc_device *rtc_dev;
+	struct rtc_wkalrm alarm;
+	struct resource *res;
+	struct clk *clk;
+	unsigned long clkrate;
+	void __iomem *ioaddr;
+	bool irq_enabled:1;
+	spinlock_t lock;
+	short irq;
+};
+
+static void st_rtc_set_hw_alarm(struct st_rtc *rtc,
+				unsigned long msb, unsigned long  lsb)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	writel(1, rtc->ioaddr + LPC_WDT_OFF);
+
+	writel(msb, rtc->ioaddr + LPC_LPA_MSB_OFF);
+	writel(lsb, rtc->ioaddr + LPC_LPA_LSB_OFF);
+	writel(1, rtc->ioaddr + LPC_LPA_START_OFF);
+
+	writel(0, rtc->ioaddr + LPC_WDT_OFF);
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+}
+
+static irqreturn_t st_rtc_handler(int this_irq, void *data)
+{
+	struct st_rtc *rtc = (struct st_rtc *)data;
+
+	rtc_update_irq(rtc->rtc_dev, 1, RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static int st_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct st_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long lpt_lsb, lpt_msb;
+	unsigned long long lpt;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	do {
+		lpt_msb = readl(rtc->ioaddr + LPC_LPT_MSB_OFF);
+		lpt_lsb = readl(rtc->ioaddr + LPC_LPT_LSB_OFF);
+	} while (readl(rtc->ioaddr + LPC_LPT_MSB_OFF) != lpt_msb);
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	lpt = ((unsigned long long)lpt_msb << 32) | lpt_lsb;
+	do_div(lpt, rtc->clkrate);
+	rtc_time_to_tm(lpt, tm);
+
+	return 0;
+}
+
+static int st_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct st_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long long lpt;
+	unsigned long secs, flags;
+	int ret;
+
+	ret = rtc_tm_to_time(tm, &secs);
+	if (ret)
+		return ret;
+
+	lpt = (unsigned long long)secs * rtc->clkrate;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	writel(lpt >> 32, rtc->ioaddr + LPC_LPT_MSB_OFF);
+	writel(lpt, rtc->ioaddr + LPC_LPT_LSB_OFF);
+	writel(1, rtc->ioaddr + LPC_LPT_START_OFF);
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	return 0;
+}
+
+static int st_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
+{
+	struct st_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	memcpy(wkalrm, &rtc->alarm, sizeof(struct rtc_wkalrm));
+
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	return 0;
+}
+
+static int st_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct st_rtc *rtc = dev_get_drvdata(dev);
+
+	if (enabled && !rtc->irq_enabled) {
+		enable_irq(rtc->irq);
+		rtc->irq_enabled = true;
+	} else if (!enabled && rtc->irq_enabled) {
+		disable_irq(rtc->irq);
+		rtc->irq_enabled = false;
+	}
+
+	return 0;
+}
+
+static int st_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
+{
+	struct st_rtc *rtc = dev_get_drvdata(dev);
+	struct rtc_time now;
+	unsigned long now_secs;
+	unsigned long alarm_secs;
+	unsigned long long lpa;
+
+	st_rtc_read_time(dev, &now);
+	rtc_tm_to_time(&now, &now_secs);
+	rtc_tm_to_time(&t->time, &alarm_secs);
+
+	/* Invalid alarm time */
+	if (now_secs > alarm_secs)
+		return -EINVAL;
+
+	memcpy(&rtc->alarm, t, sizeof(struct rtc_wkalrm));
+
+	/* Now many secs to fire */
+	alarm_secs -= now_secs;
+	lpa = (unsigned long long)alarm_secs * rtc->clkrate;
+
+	st_rtc_set_hw_alarm(rtc, lpa >> 32, lpa);
+	st_rtc_alarm_irq_enable(dev, t->enabled);
+
+	return 0;
+}
+
+static struct rtc_class_ops st_rtc_ops = {
+	.read_time		= st_rtc_read_time,
+	.set_time		= st_rtc_set_time,
+	.read_alarm		= st_rtc_read_alarm,
+	.set_alarm		= st_rtc_set_alarm,
+	.alarm_irq_enable	= st_rtc_alarm_irq_enable,
+};
+
+static int st_rtc_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct st_rtc *rtc;
+	struct resource *res;
+	struct rtc_time tm_check;
+	uint32_t mode;
+	int ret = 0;
+
+	ret = of_property_read_u32(np, "st,lpc-mode", &mode);
+	if (ret) {
+		dev_err(&pdev->dev, "An LPC mode must be provided\n");
+		return -EINVAL;
+	}
+
+	/* LPC can either run in RTC or WDT mode */
+	if (mode != ST_LPC_MODE_RTC)
+		return -ENODEV;
+
+	rtc = devm_kzalloc(&pdev->dev, sizeof(struct st_rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	spin_lock_init(&rtc->lock);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rtc->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtc->ioaddr))
+		return PTR_ERR(rtc->ioaddr);
+
+	rtc->irq = irq_of_parse_and_map(np, 0);
+	if (!rtc->irq) {
+		dev_err(&pdev->dev, "IRQ missing or invalid\n");
+		return -EINVAL;
+	}
+
+	ret = devm_request_irq(&pdev->dev, rtc->irq, st_rtc_handler, 0,
+			       pdev->name, rtc);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request irq %i\n", rtc->irq);
+		return ret;
+	}
+
+	enable_irq_wake(rtc->irq);
+	disable_irq(rtc->irq);
+
+	rtc->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(rtc->clk)) {
+		dev_err(&pdev->dev, "Unable to request clock\n");
+		return PTR_ERR(rtc->clk);
+	}
+
+	clk_prepare_enable(rtc->clk);
+
+	rtc->clkrate = clk_get_rate(rtc->clk);
+	if (!rtc->clkrate) {
+		dev_err(&pdev->dev, "Unable to fetch clock rate\n");
+		return -EINVAL;
+	}
+
+	device_set_wakeup_capable(&pdev->dev, 1);
+
+	platform_set_drvdata(pdev, rtc);
+
+	/*
+	 * The RTC-LPC is able to manage date.year > 2038
+	 * but currently the kernel can not manage this date!
+	 * If the RTC-LPC has a date.year > 2038 then
+	 * it's set to the epoch "Jan 1st 2000"
+	 */
+	st_rtc_read_time(&pdev->dev, &tm_check);
+
+	if (tm_check.tm_year >=  (2038 - 1900)) {
+		memset(&tm_check, 0, sizeof(tm_check));
+		tm_check.tm_year = 100;
+		tm_check.tm_mday = 1;
+		st_rtc_set_time(&pdev->dev, &tm_check);
+	}
+
+	rtc->rtc_dev = rtc_device_register("st-lpc-rtc", &pdev->dev,
+					   &st_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc_dev)) {
+		clk_disable_unprepare(rtc->clk);
+		return PTR_ERR(rtc->rtc_dev);
+	}
+
+	return 0;
+}
+
+static int st_rtc_remove(struct platform_device *pdev)
+{
+	struct st_rtc *rtc = platform_get_drvdata(pdev);
+
+	if (likely(rtc->rtc_dev))
+		rtc_device_unregister(rtc->rtc_dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int st_rtc_suspend(struct device *dev)
+{
+	struct st_rtc *rtc = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		return 0;
+
+	writel(1, rtc->ioaddr + LPC_WDT_OFF);
+	writel(0, rtc->ioaddr + LPC_LPA_START_OFF);
+	writel(0, rtc->ioaddr + LPC_WDT_OFF);
+
+	return 0;
+}
+
+static int st_rtc_resume(struct device *dev)
+{
+	struct st_rtc *rtc = dev_get_drvdata(dev);
+
+	rtc_alarm_irq_enable(rtc->rtc_dev, 0);
+
+	/*
+	 * clean 'rtc->alarm' to allow a new
+	 * .set_alarm to the upper RTC layer
+	 */
+	memset(&rtc->alarm, 0, sizeof(struct rtc_wkalrm));
+
+	writel(0, rtc->ioaddr + LPC_LPA_MSB_OFF);
+	writel(0, rtc->ioaddr + LPC_LPA_LSB_OFF);
+	writel(1, rtc->ioaddr + LPC_WDT_OFF);
+	writel(1, rtc->ioaddr + LPC_LPA_START_OFF);
+	writel(0, rtc->ioaddr + LPC_WDT_OFF);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(st_rtc_pm_ops, st_rtc_suspend, st_rtc_resume);
+
+static struct of_device_id st_rtc_match[] = {
+	{ .compatible = "st,stih407-lpc" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, st_wdog_match);
+
+static struct platform_driver st_rtc_platform_driver = {
+	.driver = {
+		.name = "st-lpc-rtc",
+		.pm = &st_rtc_pm_ops,
+		.of_match_table = st_rtc_match,
+	},
+	.probe = st_rtc_probe,
+	.remove = st_rtc_remove,
+};
+
+module_platform_driver(st_rtc_platform_driver);
+
+MODULE_DESCRIPTION("STMicroelectronics LPC RTC driver");
+MODULE_AUTHOR("David Paris <david.paris@st.com>");
+MODULE_LICENSE("GPLv2");
-- 
1.9.1

