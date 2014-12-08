Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaLHMEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:04:07 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40141 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaLHMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:04:03 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 2/2] rtc: Refine rtc_timer_do_work() to consider other set alarm failures
Date: Mon,  8 Dec 2014 20:03:07 +0800
Message-Id: <1418040187-5372-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418040187-5372-1-git-send-email-pang.xunlei@linaro.org>
References: <1418040187-5372-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc_timer_do_work() only judges -ETIME failure of__rtc_set_alarm(),
but doesn't handle other failures like -EIO, -EBUSY, etc.

If there is a failure other than -ETIME, the next rtc_timer will stay
in the timerqueue. Then later rtc_timers will be enqueued directly because
they have a later expires time, so the alarm irq will never be programmed.

When such failures happen, this patch will retry __rtc_set_alarm(), if
still can't program the alarm time, it will remove current rtc_timer from
timerqueue and fetch next one, thus preventing it from affecting other
rtc timers.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/interface.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index af19213..77a1529 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -898,11 +898,24 @@ again:
 	if (next) {
 		struct rtc_wkalrm alarm;
 		int err;
+		int retry = 3;
+
 		alarm.time = rtc_ktime_to_tm(next->expires);
 		alarm.enabled = 1;
+reprogram:
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			goto again;
+		else if (err) {
+			if (retry-- > 0)
+				goto reprogram;
+
+			timer = container_of(next, struct rtc_timer, node);
+			timerqueue_del(&rtc->timerqueue, &timer->node);
+			timer->enabled = 0;
+			dev_err(&rtc->dev, "__rtc_set_alarm: err=%d\n", err);
+			goto again;
+		}
 	} else
 		rtc_alarm_disable(rtc);
 
-- 
1.9.1

