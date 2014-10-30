Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbaJ3LRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:17:10 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35231 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759108AbaJ3LRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:17:05 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 03/11] time: Add rtc_tm_to_time64() safe version(using time64_t)
Date: Thu, 30 Oct 2014 19:15:37 +0800
Message-Id: <1414667745-7703-4-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of addressing 2038 saftey for in-kernel uses, this patch
adds safe rtc_tm_to_time64() using time64_t. After this patch,
rtc_tm_to_time() should be replaced by rtc_tm_to_time64() one by
one. Eventually, rtc_tm_to_time() will be removed from the kernel
when it has no users.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-lib.c |   15 ++++++++++++++-
 include/linux/rtc.h   |    1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index c4cf057..6948cbd 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -110,10 +110,23 @@ EXPORT_SYMBOL(rtc_valid_tm);
 
 /*
  * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
+ * Safe version for 2038 safety.
+ */
+int rtc_tm_to_time64(struct rtc_time *tm, time64_t *time)
+{
+	*time = mktime64(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
+			tm->tm_hour, tm->tm_min, tm->tm_sec);
+	return 0;
+}
+EXPORT_SYMBOL(rtc_tm_to_time64);
+
+/*
+ * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
+ * TODO: [2038 safety] should be replaced by rtc_tm_to_time64.
  */
 int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
 {
-	*time = mktime(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
+	*time = (unsigned long) mktime64(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
 			tm->tm_hour, tm->tm_min, tm->tm_sec);
 	return 0;
 }
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c2897..2a6a9ce 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -19,6 +19,7 @@
 extern int rtc_month_days(unsigned int month, unsigned int year);
 extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year);
 extern int rtc_valid_tm(struct rtc_time *tm);
+extern int rtc_tm_to_time64(struct rtc_time *tm, time64_t *time);
 extern int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time);
 extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm);
-- 
1.7.9.5

