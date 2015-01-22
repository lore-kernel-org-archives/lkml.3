Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbbAVCcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:32:16 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:53867 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbbAVCcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:32:07 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 2/5] drivers/rtc/rtc-dev.c: Update code to use y2038-safe time interfaces
Date: Thu, 22 Jan 2015 02:31:52 +0000
Message-Id: <1421893915-19309-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
References: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, rtc-dev.c uses y2038 problematic rtc_tm_to_time()
and rtc_time_to_tm(). So replace them with their corresponding
y2038-safe versions: rtc_tm_to_time64() and rtc_time64_to_tm().

Reviewed-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index d049393..799c34b 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -304,12 +304,12 @@ static long rtc_dev_ioctl(struct file *file,
 		 * Not supported here.
 		 */
 		{
-			unsigned long now, then;
+			time64_t now, then;
 
 			err = rtc_read_time(rtc, &tm);
 			if (err < 0)
 				return err;
-			rtc_tm_to_time(&tm, &now);
+			now = rtc_tm_to_time64(&tm);
 
 			alarm.time.tm_mday = tm.tm_mday;
 			alarm.time.tm_mon = tm.tm_mon;
@@ -317,11 +317,11 @@ static long rtc_dev_ioctl(struct file *file,
 			err  = rtc_valid_tm(&alarm.time);
 			if (err < 0)
 				return err;
-			rtc_tm_to_time(&alarm.time, &then);
+			then = rtc_tm_to_time64(&alarm.time);
 
 			/* alarm may need to wrap into tomorrow */
 			if (then < now) {
-				rtc_time_to_tm(now + 24 * 60 * 60, &tm);
+				rtc_time64_to_tm(now + 24 * 60 * 60, &tm);
 				alarm.time.tm_mday = tm.tm_mday;
 				alarm.time.tm_mon = tm.tm_mon;
 				alarm.time.tm_year = tm.tm_year;
-- 
1.9.1

