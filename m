Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaJ0Ftd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:49:33 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63787 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaJ0FrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:18 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 04/12] time: Add rtc_tm_to_time() safe version(using time64_t)
Date: Mon, 27 Oct 2014 13:46:34 +0800
Message-Id: <1414388802-5866-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, thus it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

As part of addressing 2038 saftey for in-kernel uses, this patch adds the safe rtc_tm_to_time()
using time64_t. After this patch, rtc_tm_to_time_unsafe() should be replaced by rtc_tm_to_time()
one by one.

Eventually, rtc_tm_to_time_unsafe() will be removed from the kernel when it has no users.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-lib.c |    9 +++++++++
 include/linux/rtc.h   |    1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index 168d2a2..829eef8 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -111,6 +111,15 @@ EXPORT_SYMBOL(rtc_valid_tm);
 /*
  * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
  */
+int rtc_tm_to_time(struct rtc_time *tm, time64_t *time)
+{
+        *time = mktime(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
+                        tm->tm_hour, tm->tm_min, tm->tm_sec);
+        return 0;
+}
+EXPORT_SYMBOL(rtc_tm_to_time);
+
+/* TODO: [2038 safety] unsafe for legacy, and should be replaced by rtc_tm_to_time() */
 int rtc_tm_to_time_unsafe(struct rtc_time *tm, unsigned long *time)
 {
 	*time = (unsigned long) mktime(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 97bbb6f..ffd22e9 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -19,6 +19,7 @@
 extern int rtc_month_days(unsigned int month, unsigned int year);
 extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year);
 extern int rtc_valid_tm(struct rtc_time *tm);
+extern int rtc_tm_to_time(struct rtc_time *tm, time64_t *time);
 extern int rtc_tm_to_time_unsafe(struct rtc_time *tm, unsigned long *time);
 extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm);
-- 
1.7.9.5

