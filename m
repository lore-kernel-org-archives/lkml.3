Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbaGCNRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:17:05 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35203 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbaGCNRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:17:02 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [RFC PATCH v2 3/5] rtc: add qpnp rtc driver
Date: Thu,  3 Jul 2014 16:14:01 +0300
Message-Id: <1404393243-7324-4-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com>
References: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 32bits RTC is housed inside PMIC. The RTC driver uses QPNP
SPMI interface to communicate with the PMIC RTC module.

The RTC device is divided into two sub-peripherals:
 - RTC read-write peripheral having basic RTC registers
 - alarm peripheral for controlling alarm

These two RTC peripherals are childrens of QPNP SPMI bus. They
use regmap to read/write to its registers into PMIC.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/rtc/Kconfig    |    8 +
 drivers/rtc/Makefile   |    1 +
 drivers/rtc/rtc-qpnp.c |  489 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 498 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-qpnp.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 0754f5c..eb97b0a 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1365,6 +1365,14 @@ config RTC_DRV_XGENE
 	  This driver can also be built as a module, if so, the module
 	  will be called "rtc-xgene".
 
+config RTC_DRV_QPNP
+	tristate "Qualcomm QPNP PMIC RTC"
+	depends on MFD_QPNP_SPMI
+	help
+	  Say Y here if you want to support the Qualcomm QPNP PMIC RTC.
+	  To compile this driver as a module, choose M here: the
+	  module will be called rtc-qpnp.
+
 comment "HID Sensor RTC drivers"
 
 config RTC_DRV_HID_SENSOR_TIME
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 70347d0..52488b5 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -141,3 +141,4 @@ obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
 obj-$(CONFIG_RTC_DRV_XGENE)	+= rtc-xgene.o
 obj-$(CONFIG_RTC_DRV_SIRFSOC)	+= rtc-sirfsoc.o
 obj-$(CONFIG_RTC_DRV_MOXART)	+= rtc-moxart.o
+obj-$(CONFIG_RTC_DRV_QPNP)	+= rtc-qpnp.o
diff --git a/drivers/rtc/rtc-qpnp.c b/drivers/rtc/rtc-qpnp.c
new file mode 100644
index 0000000..ea26e62
--- /dev/null
+++ b/drivers/rtc/rtc-qpnp.c
@@ -0,0 +1,489 @@
+/* Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/rtc.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+/* RTC/ALARM register offsets */
+#define REG_ALARM_RW			0x40
+#define REG_ALARM_CTRL1			0x46
+#define REG_ALARM_CTRL2			0x48
+#define REG_RTC_WRITE			0x40
+#define REG_RTC_CTRL			0x46
+#define REG_RTC_READ			0x48
+#define REG_PERP_SUBTYPE		0x05
+
+/* RTC_CTRL register bit fields */
+#define RTC_ENABLE			BIT(7)
+#define RTC_ALARM_ENABLE		BIT(7)
+#define RTC_ABORT_ENABLE		BIT(0)
+#define RTC_ALARM_CLEAR			BIT(0)
+
+/* RTC/ALARM peripheral subtype values */
+#define PERPH_SUBTYPE_RTC		0x1
+#define PERPH_SUBTYPE_ALARM		0x3
+#define NUM_8_BIT_RTC_REGS		0x4
+
+#define TO_SECS(arr)			\
+		(arr[0] | (arr[1] << 8) | (arr[2] << 16) | (arr[3] << 24))
+
+/* rtc driver internal structure */
+struct qpnp_rtc {
+	struct regmap *regmap;
+	struct device *dev;
+	struct rtc_device *rtc;
+	spinlock_t lock;	/* to protect RTC control register */
+	struct rtc_class_ops ops;
+	u8 rtc_ctrl_reg;
+	u8 alarm_ctrl_reg1;
+	u16 rtc_base;
+	u16 alarm_base;
+	int alarm_irq;
+};
+
+static int qpnp_rtc_read(struct qpnp_rtc *rtc, u8 *val, u16 off, int len)
+{
+	return regmap_bulk_read(rtc->regmap, rtc->rtc_base + off, val, len);
+}
+
+static int qpnp_rtc_write(struct qpnp_rtc *rtc, u8 *val, u16 off, int len)
+{
+	return regmap_bulk_write(rtc->regmap, rtc->rtc_base + off, val, len);
+}
+
+static int qpnp_alarm_read(struct qpnp_rtc *rtc, u8 *val, u16 off, int len)
+{
+	return regmap_bulk_read(rtc->regmap, rtc->alarm_base + off, val, len);
+}
+
+static int qpnp_alarm_write(struct qpnp_rtc *rtc, u8 *val, u16 off, int len)
+{
+	return regmap_bulk_write(rtc->regmap, rtc->alarm_base + off, val, len);
+}
+
+static int qpnp_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct qpnp_rtc *rtc = dev_get_drvdata(dev);
+	u8 value[4], reg = 0, alarm_enabled = 0, ctrl_reg;
+	u8 rtc_disabled = 0, rtc_ctrl_reg;
+	unsigned long secs, flags;
+	int ret;
+
+	rtc_tm_to_time(tm, &secs);
+
+	value[0] = (secs >>  0) & 0xff;
+	value[1] = (secs >>  8) & 0xff;
+	value[2] = (secs >> 16) & 0xff;
+	value[3] = (secs >> 24) & 0xff;
+
+	dev_dbg(dev, "Seconds value to be written to RTC = %lu\n", secs);
+
+	spin_lock_irqsave(&rtc->lock, flags);
+	ctrl_reg = rtc->alarm_ctrl_reg1;
+
+	if (ctrl_reg & RTC_ALARM_ENABLE) {
+		alarm_enabled = 1;
+		ctrl_reg &= ~RTC_ALARM_ENABLE;
+		ret = qpnp_alarm_write(rtc, &ctrl_reg, REG_ALARM_CTRL1, 1);
+		if (ret)
+			goto rtc_rw_fail;
+	} else {
+		spin_unlock_irqrestore(&rtc->lock, flags);
+	}
+
+	/*
+	 * 32 bit seconds value is coverted to four 8 bit values
+	 *	|<------  32 bit time value in seconds  ------>|
+	 *      <- 8 bit ->|<- 8 bit ->|<- 8 bit ->|<- 8 bit ->|
+	 *       ----------------------------------------------
+	 *      | BYTE[3]  |  BYTE[2]  |  BYTE[1]  |  BYTE[0]  |
+	 *       ----------------------------------------------
+	 *
+	 * RTC has four 8 bit registers for writting time in seconds:
+	 *             WDATA[3], WDATA[2], WDATA[1], WDATA[0]
+	 *
+	 * Write to the RTC registers should be done in following order
+	 * Clear WDATA[0] register
+	 *
+	 * Write BYTE[1], BYTE[2] and BYTE[3] of time to
+	 * RTC WDATA[3], WDATA[2], WDATA[1] registers
+	 *
+	 * Write BYTE[0] of time to RTC WDATA[0] register
+	 *
+	 * Clearing BYTE[0] and writting in the end will prevent any
+	 * unintentional overflow from WDATA[0] to higher bytes during the
+	 * write operation
+	 */
+
+	/* Disable RTC H/w before writing on RTC register*/
+	rtc_ctrl_reg = rtc->rtc_ctrl_reg;
+	if (rtc_ctrl_reg & RTC_ENABLE) {
+		rtc_disabled = 1;
+		rtc_ctrl_reg &= ~RTC_ENABLE;
+		ret = qpnp_rtc_write(rtc, &rtc_ctrl_reg, REG_RTC_CTRL, 1);
+		if (ret)
+			goto rtc_rw_fail;
+		rtc->rtc_ctrl_reg = rtc_ctrl_reg;
+	}
+
+	/* Clear WDATA[0] */
+	reg = 0x0;
+	ret = qpnp_rtc_write(rtc, &reg, REG_RTC_WRITE, 1);
+	if (ret)
+		goto rtc_rw_fail;
+
+	/* Write to WDATA[3], WDATA[2] and WDATA[1] */
+	ret = qpnp_rtc_write(rtc, &value[1], REG_RTC_WRITE + 1, 3);
+	if (ret)
+		goto rtc_rw_fail;
+
+	/* Write to WDATA[0] */
+	ret = qpnp_rtc_write(rtc, value, REG_RTC_WRITE, 1);
+	if (ret)
+		goto rtc_rw_fail;
+
+	/* Enable RTC after writing on RTC register */
+	if (rtc_disabled) {
+		rtc_ctrl_reg |= RTC_ENABLE;
+		ret = qpnp_rtc_write(rtc, &rtc_ctrl_reg, REG_RTC_CTRL, 1);
+		if (ret)
+			goto rtc_rw_fail;
+		rtc->rtc_ctrl_reg = rtc_ctrl_reg;
+	}
+
+	if (alarm_enabled) {
+		ctrl_reg |= RTC_ALARM_ENABLE;
+		ret = qpnp_alarm_write(rtc, &ctrl_reg, REG_ALARM_CTRL1, 1);
+		if (ret)
+			goto rtc_rw_fail;
+	}
+
+	rtc->alarm_ctrl_reg1 = ctrl_reg;
+
+rtc_rw_fail:
+	if (alarm_enabled)
+		spin_unlock_irqrestore(&rtc->lock, flags);
+
+	return ret;
+}
+
+static int qpnp_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct qpnp_rtc *rtc = dev_get_drvdata(dev);
+	u8 value[4], reg;
+	unsigned long secs;
+	int ret;
+
+	ret = qpnp_rtc_read(rtc, value, REG_RTC_READ, NUM_8_BIT_RTC_REGS);
+	if (ret)
+		return ret;
+
+	/*
+	 * Read the LSB again and check if there has been a carry over
+	 * If there is, redo the read operation
+	 */
+	ret = qpnp_rtc_read(rtc, &reg, REG_RTC_READ, 1);
+	if (ret)
+		return ret;
+
+	if (reg < value[0]) {
+		ret = qpnp_rtc_read(rtc, value, REG_RTC_READ,
+				    NUM_8_BIT_RTC_REGS);
+		if (ret)
+			return ret;
+	}
+
+	secs = TO_SECS(value);
+	rtc_time_to_tm(secs, tm);
+
+	ret = rtc_valid_tm(tm);
+	if (ret)
+		return ret;
+
+	dev_dbg(dev, "secs = %lu, h:m:s == %d:%d:%d, d/m/y = %d/%d/%d\n",
+		secs, tm->tm_hour, tm->tm_min, tm->tm_sec,
+		tm->tm_mday, tm->tm_mon, tm->tm_year);
+
+	return 0;
+}
+
+static int qpnp_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct qpnp_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long secs, secs_rtc, irq_flags;
+	struct rtc_time rtc_tm;
+	u8 value[4], ctrl_reg;
+	int ret;
+
+	rtc_tm_to_time(&alarm->time, &secs);
+
+	/*
+	 * Read the current RTC time and verify if the alarm time is in the
+	 * past. If yes, return invalid
+	 */
+	ret = qpnp_rtc_read_time(dev, &rtc_tm);
+	if (ret)
+		return -EINVAL;
+
+	rtc_tm_to_time(&rtc_tm, &secs_rtc);
+	if (secs < secs_rtc)
+		return -EINVAL;
+
+	value[0] = (secs >>  0) & 0xff;
+	value[1] = (secs >>  8) & 0xff;
+	value[2] = (secs >> 16) & 0xff;
+	value[3] = (secs >> 24) & 0xff;
+
+	spin_lock_irqsave(&rtc->lock, irq_flags);
+
+	ret = qpnp_alarm_write(rtc, value, REG_ALARM_RW, NUM_8_BIT_RTC_REGS);
+	if (ret)
+		goto rtc_rw_fail;
+
+	ctrl_reg = alarm->enabled ?
+			(rtc->alarm_ctrl_reg1 |  RTC_ALARM_ENABLE) :
+			(rtc->alarm_ctrl_reg1 & ~RTC_ALARM_ENABLE);
+
+	ret = qpnp_alarm_write(rtc, &ctrl_reg, REG_ALARM_CTRL1, 1);
+	if (ret)
+		goto rtc_rw_fail;
+
+	rtc->alarm_ctrl_reg1 = ctrl_reg;
+
+	dev_dbg(dev, "Alarm Set for h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
+			alarm->time.tm_hour, alarm->time.tm_min,
+			alarm->time.tm_sec, alarm->time.tm_mday,
+			alarm->time.tm_mon, alarm->time.tm_year);
+
+rtc_rw_fail:
+	spin_unlock_irqrestore(&rtc->lock, irq_flags);
+	return ret;
+}
+
+static int qpnp_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct qpnp_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long secs;
+	u8 value[4];
+	int ret;
+
+	ret = qpnp_alarm_read(rtc, value, REG_ALARM_RW, NUM_8_BIT_RTC_REGS);
+	if (ret)
+		return ret;
+
+	secs = TO_SECS(value);
+	rtc_time_to_tm(secs, &alarm->time);
+
+	ret = rtc_valid_tm(&alarm->time);
+	if (ret)
+		return ret;
+
+	dev_dbg(dev, "Alarm set for - h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
+		alarm->time.tm_hour, alarm->time.tm_min,
+				alarm->time.tm_sec, alarm->time.tm_mday,
+				alarm->time.tm_mon, alarm->time.tm_year);
+
+	return 0;
+}
+
+static int qpnp_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct qpnp_rtc *rtc = dev_get_drvdata(dev);
+	unsigned long flags;
+	u8 ctrl_reg;
+	u8 value[4] = {0};
+	int ret;
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	ctrl_reg = rtc->alarm_ctrl_reg1;
+	ctrl_reg = enabled ?
+		(ctrl_reg | RTC_ALARM_ENABLE) : (ctrl_reg & ~RTC_ALARM_ENABLE);
+
+	ret = qpnp_alarm_write(rtc, &ctrl_reg, REG_ALARM_CTRL1, 1);
+	if (ret)
+		goto rtc_rw_fail;
+
+	rtc->alarm_ctrl_reg1 = ctrl_reg;
+
+	/* Clear Alarm register */
+	if (!enabled)
+		ret = qpnp_alarm_write(rtc, value, REG_ALARM_RW,
+				       NUM_8_BIT_RTC_REGS);
+
+rtc_rw_fail:
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	return ret;
+}
+
+static irqreturn_t qpnp_alarm_trigger(int irq, void *dev_id)
+{
+	struct qpnp_rtc *rtc = dev_id;
+	unsigned long flags;
+	u8 ctrl_reg;
+	int ret;
+
+	rtc_update_irq(rtc->rtc, 1, RTC_IRQF | RTC_AF);
+
+	spin_lock_irqsave(&rtc->lock, flags);
+
+	/* Clear the alarm enable bit */
+	ctrl_reg = rtc->alarm_ctrl_reg1;
+	ctrl_reg &= ~RTC_ALARM_ENABLE;
+
+	ret = qpnp_alarm_write(rtc, &ctrl_reg, REG_ALARM_CTRL1, 1);
+	if (ret) {
+		spin_unlock_irqrestore(&rtc->lock, flags);
+		return IRQ_HANDLED;
+	}
+
+	rtc->alarm_ctrl_reg1 = ctrl_reg;
+	spin_unlock_irqrestore(&rtc->lock, flags);
+
+	/* Set ALARM_CLR bit */
+	ctrl_reg = 0x1;
+	ret = qpnp_alarm_write(rtc, &ctrl_reg, REG_ALARM_CTRL2, 1);
+	if (ret)
+		dev_dbg(rtc->dev, "Write to ALARM control reg failed\n");
+
+	return IRQ_HANDLED;
+}
+
+static int qpnp_rtc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct qpnp_rtc *rtc;
+	struct resource *res;
+	u8 subtype;
+	int ret;
+
+	rtc = devm_kzalloc(dev, sizeof(*rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	spin_lock_init(&rtc->lock);
+
+	rtc->regmap = dev_get_regmap(dev->parent, NULL);
+	if (!rtc->regmap)
+		return -ENODEV;
+
+	rtc->dev = dev;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_REG, "rtc");
+	if (!res)
+		return -ENODEV;
+
+	rtc->rtc_base = res->start;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_REG, "alarm");
+	if (!res)
+		return -ENODEV;
+
+	rtc->alarm_base = res->start;
+
+	ret = qpnp_rtc_read(rtc, &subtype, REG_PERP_SUBTYPE, 1);
+	if (ret)
+		return ret;
+
+	if (subtype != PERPH_SUBTYPE_RTC)
+		return -ENODEV;
+
+	ret = qpnp_alarm_read(rtc, &subtype, REG_PERP_SUBTYPE, 1);
+	if (ret)
+		return ret;
+
+	if (subtype != PERPH_SUBTYPE_ALARM)
+		return -ENODEV;
+
+	rtc->alarm_irq = platform_get_irq(pdev, 0);
+	if (rtc->alarm_irq < 0)
+		return rtc->alarm_irq;
+
+	ret = qpnp_rtc_read(rtc, &rtc->rtc_ctrl_reg, REG_RTC_CTRL, 1);
+	if (ret)
+		return ret;
+
+	if (!(rtc->rtc_ctrl_reg & RTC_ENABLE)) {
+		dev_dbg(dev, "RTC h/w disabled, rtc not registered\n");
+		return -ENODEV;
+	}
+
+	ret = qpnp_alarm_read(rtc, &rtc->alarm_ctrl_reg1, REG_ALARM_CTRL1, 1);
+	if (ret)
+		return ret;
+
+	rtc->alarm_ctrl_reg1 |= RTC_ABORT_ENABLE;
+	ret = qpnp_alarm_write(rtc, &rtc->alarm_ctrl_reg1, REG_ALARM_CTRL1, 1);
+	if (ret)
+		return ret;
+
+	ret = devm_request_any_context_irq(dev, rtc->alarm_irq,
+					   qpnp_alarm_trigger,
+					   IRQF_TRIGGER_RISING,
+					   "qpnp_rtc_alarm", rtc);
+	if (ret < 0)
+		return ret;
+
+	device_init_wakeup(dev, 1);
+	enable_irq_wake(rtc->alarm_irq);
+
+	platform_set_drvdata(pdev, rtc);
+
+	rtc->ops.read_time = qpnp_rtc_read_time;
+	rtc->ops.set_alarm = qpnp_rtc_set_alarm;
+	rtc->ops.read_alarm = qpnp_rtc_read_alarm;
+	rtc->ops.alarm_irq_enable = qpnp_rtc_alarm_irq_enable;
+	rtc->ops.set_time = qpnp_rtc_set_time;
+
+	rtc->rtc = rtc_device_register("qpnp-rtc", dev, &rtc->ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc))
+		return PTR_ERR(rtc->rtc);
+
+	return 0;
+}
+
+static int qpnp_rtc_remove(struct platform_device *pdev)
+{
+	struct qpnp_rtc *rtc = platform_get_drvdata(pdev);
+
+	device_init_wakeup(rtc->dev, 0);
+	free_irq(rtc->alarm_irq, rtc);
+	rtc_device_unregister(rtc->rtc);
+
+	return 0;
+}
+
+static const struct of_device_id qpnp_rtc_table[] = {
+	{ .compatible = "qcom,qpnp-rtc", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, rtc_qpnp_table);
+
+static struct platform_driver qpnp_rtc_driver = {
+	.probe = qpnp_rtc_probe,
+	.remove = qpnp_rtc_remove,
+	.driver = {
+		.name = "qpnp-rtc",
+		.owner = THIS_MODULE,
+		.of_match_table = qpnp_rtc_table,
+	},
+};
+module_platform_driver(qpnp_rtc_driver);
+
+MODULE_ALIAS("platform:" KBUILD_MODNAME);
+MODULE_DESCRIPTION("SMPI PMIC RTC driver");
+MODULE_AUTHOR("The Linux Foundation");
+MODULE_LICENSE("GPL v2");
-- 
1.7.0.4

