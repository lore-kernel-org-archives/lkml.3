Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaGKBZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:25:48 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54498 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaGKBZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:25:47 -0400
X-Original-SENDERIP: 165.186.175.61
X-Original-MAILFROM: hyogi.gim@lge.com
From: Hyogi Gim <hyogi.gim@lge.com>
To: John Stultz <john.stultz@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, Hyogi Gim <hyogi.gim@lge.com>
Subject: [PATCH] alarmtimer: Add the verification code for rtc device error.
Date: Fri, 11 Jul 2014 10:24:14 +0900
Message-Id: <1405041854-17902-1-git-send-email-hyogi.gim@lge.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In alarmtimer_suspend(), the error after rtc_read_time() is not checked.
If rtc device fail to read rtc time, we cannot ensure the following process.

Furthermore, the return value of rtc_timer_start() needs to distinguish
-ETIME and other rtc device error. If the error is relevant to rtc device,
suspend is failed unintentionally. In this case, it just returns zero for
a stable suspend. Otherwise, in the worst case, suspend will fail continually.

So, this patch verifies the rtc device error in alarmtimer_suspend(). it
includes "rtc_err goto" statement instead of a direct "return 0" to clarify
the rtc device error.

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
---
 kernel/time/alarmtimer.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 88c9c65..8cc43b8 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -261,15 +261,23 @@ static int alarmtimer_suspend(struct device *dev)
 
 	/* Setup an rtc timer to fire that far in the future */
 	rtc_timer_cancel(rtc, &rtctimer);
-	rtc_read_time(rtc, &tm);
+	ret = rtc_read_time(rtc, &tm);
+	if (ret < 0)
+		goto rtc_err;
 	now = rtc_tm_to_ktime(tm);
 	now = ktime_add(now, min);
 
 	/* Set alarm, if in the past reject suspend briefly to handle */
 	ret = rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
-	if (ret < 0)
+	if (ret == -ETIME)
 		__pm_wakeup_event(ws, MSEC_PER_SEC);
+	else if (ret < 0)
+		goto rtc_err;
+
 	return ret;
+
+rtc_err:
+	return 0;
 }
 #else
 static int alarmtimer_suspend(struct device *dev)
-- 
1.8.3.2

