Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbbAXBo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:44:29 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49949 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbbAXBoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:44:19 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Xunlei Pang <pang.xunlei@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 6/8] rtc: Modify rtc_hctosys() to address y2038 issues
Date: Fri, 23 Jan 2015 17:43:58 -0800
Message-Id: <1422063840-2837-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
References: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

rtc_hctosys() has a number of y2038 issues.

This patch resolves them by:
- Replace rtc_tm_to_time() with y2038-safe rtc_tm_to_time64()
- Replace do_settimeofday() with y2038-safe do_settimeofday64()

After this patch, it should not have any remaining y2038 issues.

Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/hctosys.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index 4aa60d7..2153b52 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -26,7 +26,7 @@ static int __init rtc_hctosys(void)
 {
 	int err = -ENODEV;
 	struct rtc_time tm;
-	struct timespec tv = {
+	struct timespec64 tv64 = {
 		.tv_nsec = NSEC_PER_SEC >> 1,
 	};
 	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
@@ -52,16 +52,16 @@ static int __init rtc_hctosys(void)
 		goto err_invalid;
 	}
 
-	rtc_tm_to_time(&tm, &tv.tv_sec);
+	tv64.tv_sec = rtc_tm_to_time64(&tm);
 
-	err = do_settimeofday(&tv);
+	err = do_settimeofday64(&tv64);
 
 	dev_info(rtc->dev.parent,
 		"setting system clock to "
-		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+		"%d-%02d-%02d %02d:%02d:%02d UTC (%lld)\n",
 		tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
 		tm.tm_hour, tm.tm_min, tm.tm_sec,
-		(unsigned int) tv.tv_sec);
+		(long long) tv64.tv_sec);
 
 err_invalid:
 err_read:
-- 
1.9.1

