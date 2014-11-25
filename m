Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaKYBQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:16:40 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58108 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaKYBQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:16:39 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Cc: LKP <lkp@01.org>, "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH] time: Avoid possible NTP adjustment mult overflow
Date: Tue, 25 Nov 2014 09:16:20 +0800
Message-Id: <1416878180-25312-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ideally, __clocksource_updatefreq_scale, selects the largest shift
value possible for a clocksource. This results in the mult memember
of struct clocksource being particularly large, although not so large
that NTP would adjust the clock to cause it to overflow.

That said, nothing actually prohibits an overflow from occurring, its
just that it "shouldn't" occur.

So while very unlikely, and so far never observed, the value of
(cs->mult+cs->maxadj) may have a chance to reach very near 0xFFFFFFFF,
so there is a possibility it may overflow when doing NTP positive
adjustment

See the following detail: When NTP slewes the clock, kernel goes
through update_wall_time()->...->timekeeping_apply_adjustment():
		 tk->tkr.mult += mult_adj;

Since there is no guard against it, its possible tk->tkr.mult may
overflow during this operation.

This patch avoids any possible mult overflow by judging the overflow
case before adding mult_adj to mult, also adds the WARNING message
when capturing such case.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
Fix the problem in the former patch catched by Fengguang's 0day robot:
[time] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337 update_wall_time()

 kernel/time/timekeeping.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0aef92a..9a1482e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1390,6 +1390,12 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
 	 *
 	 * XXX - TODO: Doc ntp_error calculation.
 	 */
+	if (mult_adj > 0 && (tk->tkr.mult + mult_adj < mult_adj)) {
+		/* NTP adjustment caused clocksource mult overflow */
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	tk->tkr.mult += mult_adj;
 	tk->xtime_interval += interval;
 	tk->tkr.xtime_nsec -= offset;
-- 
1.7.9.5

