Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbbAXBp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:45:28 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37472 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbbAXBoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:44:17 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Xunlei Pang <pang.xunlei@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 5/8] rtc: Update rtc-dev to use y2038-safe time interfaces
Date: Fri, 23 Jan 2015 17:43:57 -0800
Message-Id: <1422063840-2837-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
References: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

Currently, rtc-dev.c uses y2038 problematic rtc_tm_to_time()
and rtc_time_to_tm(). So replace them with their corresponding
y2038-safe versions: rtc_tm_to_time64() and rtc_time64_to_tm().

Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
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

