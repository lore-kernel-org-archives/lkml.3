Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaHYNgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:36:38 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:48324 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaHYNgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:36:36 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <1d7b80f65207ec3ceb9b2a0290864eac>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v5 3/5] RTC: RK808: add RTC driver for RK808
Date: Mon, 25 Aug 2014 21:34:28 +0800
Message-Id: <1408973668-21436-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding RTC driver for supporting RTC device present inside RK808 PMIC.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v5:
- fixed a bug about set_time failed

Changes in v4:
- use &client->dev replace rk808->dev

Changes in v3: None
Changes in v2:
Adviced by javier.martinez
- Add a separate clock driver, rather than in RTC driver

 drivers/rtc/Kconfig     |   11 ++
 drivers/rtc/Makefile    |    1 +
 drivers/rtc/rtc-rk808.c |  442 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 454 insertions(+)
 create mode 100644 drivers/rtc/rtc-rk808.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index a168e96..48f61b2 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -288,6 +288,17 @@ config RTC_DRV_MAX77686
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max77686.
 
+config RTC_DRV_RK808
+	tristate "Rockchip RK808 RTC"
+	depends on MFD_RK808
+	help
+	  If you say yes here you will get support for the
+	  RTC of Rk808 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-rk808.
+
+
 config RTC_DRV_RS5C372
 	tristate "Ricoh R2025S/D, RS5C372A/B, RV5C386, RV5C387A"
 	help
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 56f061c..91fe4647 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -109,6 +109,7 @@ obj-$(CONFIG_RTC_DRV_PUV3)	+= rtc-puv3.o
 obj-$(CONFIG_RTC_DRV_PXA)	+= rtc-pxa.o
 obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
 obj-$(CONFIG_RTC_DRV_RC5T583)	+= rtc-rc5t583.o
+obj-$(CONFIG_RTC_DRV_RK808)	+= rtc-rk808.o
 obj-$(CONFIG_RTC_DRV_RP5C01)	+= rtc-rp5c01.o
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
diff --git a/drivers/rtc/rtc-rk808.c b/drivers/rtc/rtc-rk808.c
new file mode 100644
index 0000000..b5f0df5
--- /dev/null
+++ b/drivers/rtc/rtc-rk808.c
@@ -0,0 +1,442 @@
+/*
+ * RTC driver for Rockchip RK808
+ *
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * Author: Chris Zhong <zyw@rock-chips.com>
+ * Author: Zhang Qing <zhangqing@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/mfd/rk808.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+
+/* RTC_CTRL_REG bitfields */
+#define BIT_RTC_CTRL_REG_STOP_RTC_M		BIT(0)
+#define BIT_RTC_CTRL_REG_RTC_V_OPT_M		BIT(7)
+#define BIT_RTC_INTERRUPTS_REG_IT_ALARM_M	BIT(3)
+
+#define SECONDS_REG_MSK		0x7F
+#define MINUTES_REG_MAK		0x7F
+#define HOURS_REG_MSK		0x3F
+#define DAYS_REG_MSK		0x3F
+#define MONTHS_REG_MSK		0x1F
+#define YEARS_REG_MSK		0xFF
+#define WEEKS_REG_MSK		0x7
+
+/* REG_SECONDS_REG through REG_YEARS_REG is how many registers? */
+
+#define ALL_TIME_REGS				7
+#define ALL_ALM_REGS				6
+
+struct rk808_rtc {
+	struct rk808 *rk808;
+	struct rtc_device *rtc;
+	unsigned int alarm_enabled:1;
+};
+
+/*
+ * Read current time and date in RTC
+ */
+static int rk808_rtc_readtime(struct device *dev, struct rtc_time *tm)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	unsigned char rtc_data[ALL_TIME_REGS];
+	int ret;
+
+	/* Has the RTC been programmed? */
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
+				 BIT_RTC_CTRL_REG_RTC_V_OPT_M, 0);
+	if (ret) {
+		dev_err(dev, "Failed to update RTC control: %d\n", ret);
+		return ret;
+	}
+
+	ret = regmap_bulk_read(rk808->regmap, RK808_SECONDS_REG,
+			       rtc_data, ALL_TIME_REGS);
+	if (ret) {
+		dev_err(dev, "Failed to bulk read rtc_data: %d\n", ret);
+		return ret;
+	}
+
+	tm->tm_sec = bcd2bin(rtc_data[0]) & SECONDS_REG_MSK;
+	tm->tm_min = bcd2bin(rtc_data[1]) & MINUTES_REG_MAK;
+	tm->tm_hour = bcd2bin(rtc_data[2]) & HOURS_REG_MSK;
+	tm->tm_mday = bcd2bin(rtc_data[3]) & DAYS_REG_MSK;
+	tm->tm_mon = (bcd2bin(rtc_data[4]) & MONTHS_REG_MSK) - 1;
+	tm->tm_year = (bcd2bin(rtc_data[5]) & YEARS_REG_MSK) + 100;
+	tm->tm_wday = bcd2bin(rtc_data[6]) & WEEKS_REG_MSK;
+	dev_dbg(dev, "RTC date/time %4d-%02d-%02d(%d) %02d:%02d:%02d\n",
+		1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
+		tm->tm_wday, tm->tm_hour , tm->tm_min, tm->tm_sec);
+
+	return 0;
+}
+
+/*
+ * Set current time and date in RTC
+ */
+static int rk808_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	unsigned char rtc_data[ALL_TIME_REGS + 1];
+	int ret;
+
+	rtc_data[0] = bin2bcd(tm->tm_sec);
+	rtc_data[1] = bin2bcd(tm->tm_min);
+	rtc_data[2] = bin2bcd(tm->tm_hour);
+	rtc_data[3] = bin2bcd(tm->tm_mday);
+	rtc_data[4] = bin2bcd(tm->tm_mon + 1);
+	rtc_data[5] = bin2bcd(tm->tm_year - 100);
+	rtc_data[6] = bin2bcd(tm->tm_wday);
+	dev_dbg(dev, "set RTC date/time %4d-%02d-%02d(%d) %02d:%02d:%02d\n",
+		1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
+		tm->tm_wday, tm->tm_hour , tm->tm_min, tm->tm_sec);
+
+	/* Stop RTC while updating the RTC registers */
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
+				 BIT_RTC_CTRL_REG_STOP_RTC_M,
+				 BIT_RTC_CTRL_REG_STOP_RTC_M);
+	if (ret) {
+		dev_err(dev, "Failed to update RTC control: %d\n", ret);
+		return ret;
+	}
+
+	ret = regmap_bulk_write(rk808->regmap, RK808_SECONDS_REG,
+				rtc_data, ALL_TIME_REGS);
+	if (ret) {
+		dev_err(dev, "Failed to bull write rtc_data: %d\n", ret);
+		return ret;
+	}
+	/* Start RTC again */
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
+				 BIT_RTC_CTRL_REG_STOP_RTC_M, 0);
+	if (ret) {
+		dev_err(dev, "Failed to update RTC control: %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+/*
+ * Read alarm time and date in RTC
+ */
+static int rk808_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	unsigned char alrm_data[ALL_ALM_REGS];
+	uint32_t int_reg;
+	int ret;
+
+	ret = regmap_bulk_read(rk808->regmap, RK808_ALARM_SECONDS_REG,
+			       alrm_data, ALL_ALM_REGS);
+
+	/* some of these fields may be wildcard/"match all" */
+	alrm->time.tm_sec = bcd2bin(alrm_data[0]) & SECONDS_REG_MSK;
+	alrm->time.tm_min = bcd2bin(alrm_data[1]) & MINUTES_REG_MAK;
+	alrm->time.tm_hour = bcd2bin(alrm_data[2]) & HOURS_REG_MSK;
+	alrm->time.tm_mday = bcd2bin(alrm_data[3]) & DAYS_REG_MSK;
+	alrm->time.tm_mon = (bcd2bin(alrm_data[4]) & MONTHS_REG_MSK) - 1;
+	alrm->time.tm_year = (bcd2bin(alrm_data[5]) & YEARS_REG_MSK) + 100;
+
+	ret = regmap_read(rk808->regmap, RK808_RTC_INT_REG, &int_reg);
+	if (ret) {
+		dev_err(dev, "Failed to read RTC INT REG: %d\n", ret);
+		return ret;
+	}
+
+	dev_dbg(dev, "alrm read RTC date/time %4d-%02d-%02d(%d) %02d:%02d:%02d\n",
+		1900 + alrm->time.tm_year, alrm->time.tm_mon + 1,
+		alrm->time.tm_mday, alrm->time.tm_wday, alrm->time.tm_hour,
+		alrm->time.tm_min, alrm->time.tm_sec);
+
+	alrm->enabled = (int_reg & BIT_RTC_INTERRUPTS_REG_IT_ALARM_M) ? 1 : 0;
+
+	return 0;
+}
+
+static int rk808_rtc_stop_alarm(struct rk808_rtc *rk808_rtc)
+{
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	int ret;
+
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_INT_REG,
+				 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M, 0);
+	if (!ret)
+		rk808_rtc->alarm_enabled = 0;
+
+	return ret;
+}
+
+static int rk808_rtc_start_alarm(struct rk808_rtc *rk808_rtc)
+{
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	int ret;
+
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_INT_REG,
+				 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M,
+				 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+	if (!ret)
+		rk808_rtc->alarm_enabled = 1;
+
+	return ret;
+}
+
+static int rk808_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	unsigned char alrm_data[ALL_TIME_REGS];
+	int ret;
+
+	ret = rk808_rtc_stop_alarm(rk808_rtc);
+	if (ret) {
+		dev_err(dev, "Failed to stop alarm: %d\n", ret);
+		return ret;
+	}
+	dev_dbg(dev, "alrm set RTC date/time %4d-%02d-%02d(%d) %02d:%02d:%02d\n",
+		1900 + alrm->time.tm_year, alrm->time.tm_mon + 1,
+		alrm->time.tm_mday, alrm->time.tm_wday, alrm->time.tm_hour,
+		alrm->time.tm_min, alrm->time.tm_sec);
+
+	alrm_data[0] = bin2bcd(alrm->time.tm_sec);
+	alrm_data[1] = bin2bcd(alrm->time.tm_min);
+	alrm_data[2] = bin2bcd(alrm->time.tm_hour);
+	alrm_data[3] = bin2bcd(alrm->time.tm_mday);
+	alrm_data[4] = bin2bcd(alrm->time.tm_mon + 1);
+	alrm_data[5] = bin2bcd(alrm->time.tm_year - 100);
+
+	ret = regmap_bulk_write(rk808->regmap, RK808_ALARM_SECONDS_REG,
+				alrm_data, ALL_ALM_REGS);
+	if (ret) {
+		dev_err(dev, "Failed to bulk write: %d\n", ret);
+		return ret;
+	}
+	if (alrm->enabled) {
+		ret = rk808_rtc_start_alarm(rk808_rtc);
+		if (ret) {
+			dev_err(dev, "Failed to start alarm: %d\n", ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int rk808_rtc_alarm_irq_enable(struct device *dev,
+				      unsigned int enabled)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+
+	if (enabled)
+		return rk808_rtc_start_alarm(rk808_rtc);
+
+	return rk808_rtc_stop_alarm(rk808_rtc);
+}
+
+/*
+ * We will just handle setting the frequency and make use the framework for
+ * reading the periodic interupts.
+ *
+ * @freq: Current periodic IRQ freq:
+ * bit 0: every second
+ * bit 1: every minute
+ * bit 2: every hour
+ * bit 3: every day
+ */
+static irqreturn_t rk808_alm_irq(int irq, void *data)
+{
+	struct rk808_rtc *rk808_rtc = data;
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	struct i2c_client *client = rk808->i2c;
+	uint32_t rtc_ctl;
+	int ret;
+
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_STATUS_REG,
+				 0, 0);
+	if (ret) {
+		dev_err(&client->dev,
+			"%s:Failed to update RTC status: %d\n", __func__, ret);
+		return ret;
+	}
+
+	rtc_update_irq(rk808_rtc->rtc, 1, RTC_IRQF | RTC_AF);
+	dev_info(&client->dev,
+		 "%s:irq=%d,rtc_ctl=0x%x\n", __func__, irq, rtc_ctl);
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops rk808_rtc_ops = {
+	.read_time = rk808_rtc_readtime,
+	.set_time = rk808_rtc_set_time,
+	.read_alarm = rk808_rtc_readalarm,
+	.set_alarm = rk808_rtc_setalarm,
+	.alarm_irq_enable = rk808_rtc_alarm_irq_enable,
+};
+
+#ifdef CONFIG_PM
+/* Turn off the alarm if it should not be a wake source. */
+static int rk808_rtc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(&pdev->dev);
+	int ret;
+
+	if (rk808_rtc->alarm_enabled && device_may_wakeup(&pdev->dev))
+		ret = rk808_rtc_start_alarm(rk808_rtc);
+	else
+		ret = rk808_rtc_stop_alarm(rk808_rtc);
+
+	if (ret)
+		dev_err(&pdev->dev, "Failed to update RTC alarm: %d\n", ret);
+
+	return ret;
+}
+
+/* Enable the alarm if it should be enabled (in case it was disabled to
+ * prevent use as a wake source).
+ */
+static int rk808_rtc_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(&pdev->dev);
+	int ret;
+
+	if (rk808_rtc->alarm_enabled) {
+		ret = rk808_rtc_start_alarm(rk808_rtc);
+		if (ret)
+			dev_err(&pdev->dev,
+				"Failed to restart RTC alarm: %d\n", ret);
+	}
+
+	return ret;
+}
+#else
+#define rk808_rtc_suspend NULL
+#define rk808_rtc_resume NULL
+#endif
+
+static const struct dev_pm_ops rk808_rtc_pm_ops = {
+	.suspend = rk808_rtc_suspend,
+	.resume = rk808_rtc_resume,
+	.poweroff = rk808_rtc_suspend,
+};
+
+/*2012.1.1 12:00:00 Saturday*/
+struct rtc_time tm_def = {
+			.tm_wday = 6,
+			.tm_year = 112,
+			.tm_mon = 0,
+			.tm_mday = 1,
+			.tm_hour = 12,
+			.tm_min = 0,
+			.tm_sec = 0,
+};
+
+static int rk808_rtc_probe(struct platform_device *pdev)
+{
+	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
+	struct i2c_client *client = rk808->i2c;
+	struct rk808_rtc *rk808_rtc;
+	struct rtc_time tm;
+	int alm_irq;
+	int ret;
+
+	rk808_rtc = devm_kzalloc(&pdev->dev, sizeof(*rk808_rtc), GFP_KERNEL);
+	if (rk808_rtc == NULL)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, rk808_rtc);
+	rk808_rtc->rk808 = rk808;
+
+	/* start rtc default */
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
+				 BIT_RTC_CTRL_REG_STOP_RTC_M, 0);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to read RTC control: %d\n", ret);
+		return ret;
+	}
+
+	ret = regmap_write(rk808->regmap, RK808_RTC_STATUS_REG, 0xfe);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to write RTC control: %d\n", ret);
+			return ret;
+	}
+
+	/* set init time */
+	ret = rk808_rtc_readtime(&pdev->dev, &tm);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to read RTC time\n");
+		return ret;
+	}
+	ret = rtc_valid_tm(&tm);
+	if (ret) {
+		dev_err(&pdev->dev, "invalid date/time and init time\n");
+		rk808_rtc_set_time(&pdev->dev, &tm_def);
+	}
+
+	device_init_wakeup(&pdev->dev, 1);
+
+	rk808_rtc->rtc = devm_rtc_device_register(&pdev->dev,
+		"rk808", &rk808_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rk808_rtc->rtc)) {
+		ret = PTR_ERR(rk808_rtc->rtc);
+		return ret;
+	}
+
+	alm_irq  = platform_get_irq(pdev, 0);
+	if (alm_irq <= 0) {
+		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
+			 alm_irq);
+		return -ENXIO;
+	}
+
+	/* request alarm irq of rk808 */
+	ret = devm_request_threaded_irq(&pdev->dev, alm_irq, NULL,
+					rk808_alm_irq,
+					IRQF_TRIGGER_LOW | IRQF_EARLY_RESUME,
+					"RTC alarm", rk808_rtc);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
+			alm_irq, ret);
+	}
+	device_set_wakeup_capable(&pdev->dev, 1);
+
+	dev_info(&client->dev, "%s:ok\n", __func__);
+
+	return ret;
+}
+
+static struct platform_driver rk808_rtc_driver = {
+	.probe = rk808_rtc_probe,
+	.driver = {
+		.name = "rk808-rtc",
+		.pm = &rk808_rtc_pm_ops,
+	},
+};
+
+module_platform_driver(rk808_rtc_driver);
+
+MODULE_DESCRIPTION("RTC driver for the rk808 series PMICs");
+MODULE_AUTHOR("Chris Zhong <zyw@rock-chips.com>");
+MODULE_AUTHOR("Zhang Qing <zhanqging@rock-chips.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rk808-rtc");
-- 
1.7.9.5


