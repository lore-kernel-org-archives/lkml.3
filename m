Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaF0R13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:27:29 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54688 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaF0R1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:27:24 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, John Whitmore <arigead@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/2][RFC] rtc: Rework hctosys so that it is called on RTC registration
Date: Fri, 27 Jun 2014 10:27:11 -0700
Message-Id: <1403890031-26419-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>
References: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather then calling hctosys at late_init, when RTC modules may not
yet be loaded, call hctosys on each RTC device registration.

We also change hctosys to usilize do_first_settimeofday() in
order to make sure the time is only initialized once by an RTC
and doesn't overwrite any time changes already made by userspace.

Cc: John Whitmore <arigead@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/class.c   |  2 ++
 drivers/rtc/hctosys.c | 19 ++++++++-----------
 include/linux/rtc.h   |  6 ++++++
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 589351e..6986529 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -237,6 +237,8 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	dev_info(dev, "rtc core: registered %s as %s\n",
 			rtc->name, dev_name(&rtc->dev));
 
+	rtc_hctosys();
+
 	return rtc;
 
 exit_kfree:
diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index 4aa60d7..72be031 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -22,7 +22,7 @@
  * the best guess is to add 0.5s.
  */
 
-static int __init rtc_hctosys(void)
+int rtc_hctosys(void)
 {
 	int err = -ENODEV;
 	struct rtc_time tm;
@@ -54,14 +54,13 @@ static int __init rtc_hctosys(void)
 
 	rtc_tm_to_time(&tm, &tv.tv_sec);
 
-	err = do_settimeofday(&tv);
-
-	dev_info(rtc->dev.parent,
-		"setting system clock to "
-		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
-		tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
-		tm.tm_hour, tm.tm_min, tm.tm_sec,
-		(unsigned int) tv.tv_sec);
+	if (!do_first_settimeofday(&tv))
+		dev_info(rtc->dev.parent,
+			"setting system clock to "
+			"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+			tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
+			tm.tm_hour, tm.tm_min, tm.tm_sec,
+			(unsigned int) tv.tv_sec);
 
 err_invalid:
 err_read:
@@ -72,5 +71,3 @@ err_open:
 
 	return err;
 }
-
-late_initcall(rtc_hctosys);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c2897..a524cc6 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -191,6 +191,12 @@ static inline bool is_leap_year(unsigned int year)
 	return (!(year % 4) && (year % 100)) || !(year % 400);
 }
 
+#ifdef CONFIG_RTC_SYSTOHC
+int rtc_hctosys(void);
+#else
+#define rtc_hctosys() 0
+#endif
+
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
 extern int rtc_hctosys_ret;
 #else
-- 
1.9.1

