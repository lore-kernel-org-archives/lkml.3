Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaJ0Frc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:47:32 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38831 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaJ0FrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:23 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 05/12] time: Convert rtc_tm_to_time_unsafe() to rtc_tm_to_time() in rtc_hctosys()
Date: Mon, 27 Oct 2014 13:46:35 +0800
Message-Id: <1414388802-5866-4-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, so it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

As part of addressing 2038 saftey for in-kernel uses, this patch creates no functional change
in existing users, and converts rtc_tm_to_time_unsafe() to rtc_tm_to_time() in rtc_hctosys().

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 drivers/rtc/hctosys.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index 4e9a5c6..c80723f 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -26,9 +26,10 @@ static int __init rtc_hctosys(void)
 {
 	int err = -ENODEV;
 	struct rtc_time tm;
-	struct timespec tv = {
+	struct timespec64 tv = {
 		.tv_nsec = NSEC_PER_SEC >> 1,
 	};
+	struct timespec ts32;
 	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
 
 	if (rtc == NULL) {
@@ -52,16 +53,17 @@ static int __init rtc_hctosys(void)
 		goto err_invalid;
 	}
 
-	rtc_tm_to_time_unsafe(&tm, &tv.tv_sec);
+	rtc_tm_to_time(&tm, &tv.tv_sec);
 
-	err = do_settimeofday(&tv);
+	ts32 = timespec64_to_timespec(tv);
+	err = do_settimeofday(&ts32);
 
 	dev_info(rtc->dev.parent,
 		"setting system clock to "
-		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+		"%d-%02d-%02d %02d:%02d:%02d UTC (%llu)\n",
 		tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
 		tm.tm_hour, tm.tm_min, tm.tm_sec,
-		(unsigned int) tv.tv_sec);
+		(unsigned long long) tv.tv_sec);
 
 err_invalid:
 err_read:
-- 
1.7.9.5

