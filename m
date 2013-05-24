Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab3EXKAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:00:21 -0400
Received: from mail-wi0-f196.google.com ([209.85.212.196]:52325 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760092Ab3EXKAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:00:17 -0400
From: Alexandre Torgue <alexandre.torgue.st@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Julien Delacou <julien.delacou@stericsson.com>
Subject: [PATCH 2/2] rtc: ab8540: add second resolution to rtc driver
Date: Fri, 24 May 2013 11:59:48 +0200
Message-Id: <1369389588-27568-3-git-send-email-alexandre.torgue.st@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1369389588-27568-1-git-send-email-alexandre.torgue.st@gmail.com>
References: <1369389588-27568-1-git-send-email-alexandre.torgue.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@st.com>

Android expects the RTC to have second resolution. On ab8540 cut2 RTC
block has a new register which allows setting seconds for wakeup
alarms.

Existing registers (minutes hi, mid and low) have seen their offsets
changed. Here is the new mapping:
  * AlarmSec     (A) 0x22
  * AlarmMinLow  (M) from 0x8 to 0x23
  * AlarmMinMid  (M) from 0x9 to 0x24
  * AlarmMinHigh (M) from 0xA to 0x25

Signed-off-by: Julien Delacou <julien.delacou@stericsson.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>

Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 63cfa31..4de5cd9 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -35,6 +35,10 @@
 #define AB8500_RTC_FORCE_BKUP_REG	0x0D
 #define AB8500_RTC_CALIB_REG		0x0E
 #define AB8500_RTC_SWITCH_STAT_REG	0x0F
+#define AB8540_RTC_ALRM_SEC		0x22
+#define AB8540_RTC_ALRM_MIN_LOW_REG	0x23
+#define AB8540_RTC_ALRM_MIN_MID_REG	0x24
+#define AB8540_RTC_ALRM_MIN_HI_REG	0x25
 
 /* RtcReadRequest bits */
 #define RTC_READ_REQUEST		0x01
@@ -58,6 +62,11 @@ static const u8 ab8500_rtc_alarm_regs[] = {
 	AB8500_RTC_ALRM_MIN_LOW_REG
 };
 
+static const u8 ab8540_rtc_alarm_regs[] = {
+	AB8540_RTC_ALRM_MIN_HI_REG, AB8540_RTC_ALRM_MIN_MID_REG,
+	AB8540_RTC_ALRM_MIN_LOW_REG, AB8540_RTC_ALRM_SEC
+};
+
 /* Calculate the seconds from 1970 to 01-01-2000 00:00:00 */
 static unsigned long get_elapsed_seconds(int year)
 {
@@ -267,6 +276,42 @@ static int ab8500_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	return ab8500_rtc_irq_enable(dev, alarm->enabled);
 }
 
+static int ab8540_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	int retval, i;
+	unsigned char buf[ARRAY_SIZE(ab8540_rtc_alarm_regs)];
+	unsigned long mins, secs = 0;
+
+	if (alarm->time.tm_year < (AB8500_RTC_EPOCH - 1900)) {
+		dev_dbg(dev, "year should be equal to or greater than %d\n",
+				AB8500_RTC_EPOCH);
+		return -EINVAL;
+	}
+
+	/* Get the number of seconds since 1970 */
+	rtc_tm_to_time(&alarm->time, &secs);
+
+	/*
+	 * Convert it to the number of seconds since 01-01-2000 00:00:00
+	 */
+	secs -= get_elapsed_seconds(AB8500_RTC_EPOCH);
+	mins = secs / 60;
+
+	buf[3] = secs % 60;
+	buf[2] = mins & 0xFF;
+	buf[1] = (mins >> 8) & 0xFF;
+	buf[0] = (mins >> 16) & 0xFF;
+
+	/* Set the alarm time */
+	for (i = 0; i < ARRAY_SIZE(ab8540_rtc_alarm_regs); i++) {
+		retval = abx500_set_register_interruptible(dev, AB8500_RTC,
+			ab8540_rtc_alarm_regs[i], buf[i]);
+		if (retval < 0)
+			return retval;
+	}
+
+	return ab8500_rtc_irq_enable(dev, alarm->enabled);
+}
 
 static int ab8500_rtc_set_calibration(struct device *dev, int calibration)
 {
@@ -389,8 +434,22 @@ static const struct rtc_class_ops ab8500_rtc_ops = {
 	.alarm_irq_enable	= ab8500_rtc_irq_enable,
 };
 
+static const struct rtc_class_ops ab8540_rtc_ops = {
+	.read_time		= ab8500_rtc_read_time,
+	.set_time		= ab8500_rtc_set_time,
+	.read_alarm		= ab8500_rtc_read_alarm,
+	.set_alarm		= ab8540_rtc_set_alarm,
+	.alarm_irq_enable	= ab8500_rtc_irq_enable,
+};
+
+static struct platform_device_id ab85xx_rtc_ids[] = {
+	{ "ab8500-rtc", (kernel_ulong_t)&ab8500_rtc_ops, },
+	{ "ab8540-rtc", (kernel_ulong_t)&ab8540_rtc_ops, },
+};
+
 static int ab8500_rtc_probe(struct platform_device *pdev)
 {
+	const struct platform_device_id *platid = platform_get_device_id(pdev);
 	int err;
 	struct rtc_device *rtc;
 	u8 rtc_ctrl;
@@ -423,7 +482,8 @@ static int ab8500_rtc_probe(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, true);
 
 	rtc = devm_rtc_device_register(&pdev->dev, "ab8500-rtc",
-					&ab8500_rtc_ops, THIS_MODULE);
+				(struct rtc_class_ops *)platid->driver_data,
+				THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		dev_err(&pdev->dev, "Registration failed\n");
 		err = PTR_ERR(rtc);
@@ -463,6 +523,7 @@ static struct platform_driver ab8500_rtc_driver = {
 	},
 	.probe	= ab8500_rtc_probe,
 	.remove = ab8500_rtc_remove,
+	.id_table = ab85xx_rtc_ids,
 };
 
 module_platform_driver(ab8500_rtc_driver);
-- 
1.8.2.1

