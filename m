Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbbAVCdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:33:45 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58854 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbbAVCcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:32:08 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 3/5] rtc: Modify rtc_hctosys() to address y2038 issues
Date: Thu, 22 Jan 2015 02:31:53 +0000
Message-Id: <1421893915-19309-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
References: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc_hctosys() has a number of y2038 issues.

This patch resolves them by:
- Replace rtc_tm_to_time() with y2038-safe rtc_tm_to_time64()
- Replace do_settimeofday() with y2038-safe do_settimeofday64()

After this patch, it should not have any remaining y2038 issues.

Reviewed-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
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

