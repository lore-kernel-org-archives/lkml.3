Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbbAMPqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:46:42 -0500
Received: from m15-111.126.com ([220.181.15.111]:37347 "EHLO m15-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbbAMPqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:46:37 -0500
From: Xunlei Pang <xlpang@126.com>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 6/9] rtc/mxc: Modify rtc_update_alarm() not to touch the alarm time
Date: Tue, 13 Jan 2015 23:44:54 +0800
Message-Id: <1421163897-8020-7-git-send-email-xlpang@126.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1421163897-8020-1-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
X-CM-TRANSID: C8mowEAZEUVxPbVUBIRpDg--.692S9
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw4UKw1fCFyxZw1Uury8Krg_yoW8tw15pF
	W3Cayktr4ktFySgw1DGFsruF45Jw18J39Fq3WfJ34S9rn5Aa4kJF95Cry8KrW5tFZ5u3Zr
	J3W3ZF15urWUZF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jd_-9UUUUU=
X-Originating-IP: [182.149.91.53]
X-CM-SenderInfo: p0ost0bj6rjloofrz/1tbimRqAv00vL4USVAAAsy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

rtc_class_ops's set_alarm() shouldn't deal with the alarm date,
as this is handled in the rtc core.

See rtc_dev_ioctl()'s RTC_ALM_SET and RTC_WKALM_SET cases.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-mxc.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 3c3f8d1..a7b218f 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -173,29 +173,18 @@ static void set_alarm_or_time(struct device *dev, int time_alarm, u32 time)
  * This function updates the RTC alarm registers and then clears all the
  * interrupt status bits.
  */
-static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
+static void rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
 {
-	struct rtc_time alarm_tm, now_tm;
-	unsigned long now, time;
+	unsigned long time;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 
-	now = get_alarm_or_time(dev, MXC_RTC_TIME);
-	rtc_time_to_tm(now, &now_tm);
-	alarm_tm.tm_year = now_tm.tm_year;
-	alarm_tm.tm_mon = now_tm.tm_mon;
-	alarm_tm.tm_mday = now_tm.tm_mday;
-	alarm_tm.tm_hour = alrm->tm_hour;
-	alarm_tm.tm_min = alrm->tm_min;
-	alarm_tm.tm_sec = alrm->tm_sec;
-	rtc_tm_to_time(&alarm_tm, &time);
+	rtc_tm_to_time(alrm, &time);
 
 	/* clear all the interrupt status bits */
 	writew(readw(ioaddr + RTC_RTCISR), ioaddr + RTC_RTCISR);
 	set_alarm_or_time(dev, MXC_RTC_ALARM, time);
-
-	return 0;
 }
 
 static void mxc_rtc_irq_enable(struct device *dev, unsigned int bit,
@@ -346,11 +335,8 @@ static int mxc_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = rtc_update_alarm(dev, &alrm->time);
-	if (ret)
-		return ret;
+	rtc_update_alarm(dev, &alrm->time);
 
 	memcpy(&pdata->g_rtc_alarm, &alrm->time, sizeof(struct rtc_time));
 	mxc_rtc_irq_enable(dev, RTC_ALM_BIT, alrm->enabled);
-- 
1.9.1


