Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaK0MDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:03:40 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61701 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaK0MDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:03:38 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        Xunlei Pang <pang.xunlei@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [RFC PATCH 4/4] rtc/imxdi: Update driver to address time issues
Date: Thu, 27 Nov 2014 20:02:40 +0800
Message-Id: <1417089760-26848-5-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc/imxdi rtc driver has a number of y2038/y2106 issues, the worst
one is its hardware only supports 32-bit time.

This patch resolves them based on our foregoing efforts:
- Replace rtc_time_to_tm() with rtc_hw32_to_time64()/rtc_time64_to_tm()
- Replace rtc_tm_to_time() with rtc_tm_to_time64()/rtc_time64_to_hw32()
- Use rtc_time64_to_hw32() to handle dryice_rtc_set_mmss()

After this patch, the drivers should not have any remaining y2038/y2106
issues.

Cc: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-imxdi.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 34d76b2..015290f 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -197,10 +197,10 @@ out:
 static int dryice_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct imxdi_dev *imxdi = dev_get_drvdata(dev);
-	unsigned long now;
+	time64_t now;
 
-	now = __raw_readl(imxdi->ioaddr + DTCMR);
-	rtc_time_to_tm(now, tm);
+	now = rtc_hw32_to_time64(__raw_readl(imxdi->ioaddr + DTCMR));
+	rtc_time64_to_tm(now, tm);
 
 	return 0;
 }
@@ -213,17 +213,16 @@ static int dryice_rtc_set_mmss(struct device *dev, time64_t secs)
 {
 	struct imxdi_dev *imxdi = dev_get_drvdata(dev);
 	int rc;
+	u32 hwtime;
+
+	rc = rtc_time64_to_hw32(secs, &hwtime);
+	if (rc < 0)
+		return rc;
 
 	/* zero the fractional part first */
 	rc = di_write_wait(imxdi, 0, DTCLR);
 	if (rc == 0)
-		/*
-		 * y2106 issue:
-		 *   On 32bit systems the time64_t secs value gets cast to
-		 *   a 32bit long, and thus we can only write a maximum value
-		 *   of y2016
-		 */
-		rc = di_write_wait(imxdi, secs, DTCMR);
+		rc = di_write_wait(imxdi, hwtime, DTCMR);
 
 	return rc;
 }
@@ -248,10 +247,10 @@ static int dryice_rtc_alarm_irq_enable(struct device *dev,
 static int dryice_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct imxdi_dev *imxdi = dev_get_drvdata(dev);
-	u32 dcamr;
+	time64_t alarm_time;
 
-	dcamr = __raw_readl(imxdi->ioaddr + DCAMR);
-	rtc_time_to_tm(dcamr, &alarm->time);
+	alarm_time = rtc_hw32_to_time64(__raw_readl(imxdi->ioaddr + DCAMR));
+	rtc_time64_to_tm(alarm_time, &alarm->time);
 
 	/* alarm is enabled if the interrupt is enabled */
 	alarm->enabled = (__raw_readl(imxdi->ioaddr + DIER) & DIER_CAIE) != 0;
@@ -273,21 +272,23 @@ static int dryice_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 static int dryice_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct imxdi_dev *imxdi = dev_get_drvdata(dev);
-	unsigned long now;
-	unsigned long alarm_time;
+	time64_t alarm_time, now;
+	u32 alarm_hwtime;
 	int rc;
 
-	rc = rtc_tm_to_time(&alarm->time, &alarm_time);
-	if (rc)
-		return rc;
+	alarm_time = rtc_tm_to_time64(&alarm->time);
+	now = rtc_hw32_to_time64(__raw_readl(imxdi->ioaddr + DTCMR));
 
 	/* don't allow setting alarm in the past */
-	now = __raw_readl(imxdi->ioaddr + DTCMR);
 	if (alarm_time < now)
 		return -EINVAL;
 
+	rc = rtc_time64_to_hw32(alarm_time, &alarm_hwtime);
+	if (rc < 0)
+		return rc;
+
 	/* write the new alarm time */
-	rc = di_write_wait(imxdi, (u32)alarm_time, DCAMR);
+	rc = di_write_wait(imxdi, alarm_hwtime, DCAMR);
 	if (rc)
 		return rc;
 
-- 
1.7.9.5

