Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaGXEEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:04:06 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34136 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaGXEEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:04:04 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] sched_clock: Avoid corrupting hrtimer tree during suspend
Date: Wed, 23 Jul 2014 21:03:50 -0700
Message-Id: <1406174630-23458-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

During suspend we call sched_clock_poll() to update the epoch and
accumulated time and reprogram the sched_clock_timer to fire
before the next wrap-around time. Unfortunately,
sched_clock_poll() doesn't restart the timer, instead it relies
on the hrtimer layer to do that and during suspend we aren't
calling that function from the hrtimer layer. Instead, we're
reprogramming the expires time while the hrtimer is enqueued,
which can cause the hrtimer tree to be corrupted. Furthermore, we
restart the timer during suspend but we update the epoch during
resume which seems counter-intuitive.

Let's fix this by saving the accumulated state and canceling the
timer during suspend. On resume we can update the epoch and
restart the timer similar to what we would do if we were starting
the clock for the first time.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable <stable@vger.kernel.org>
Fixes: a08ca5d1089d "sched_clock: Use an hrtimer instead of timer"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---

Ingo/Thomas: Here's a fix for tip/timers/urgent for 3.16 and -stable.
Let me know if you have any objections.

thanks
-john

 kernel/time/sched_clock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 445106d..01d2d15 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -191,7 +191,8 @@ void __init sched_clock_postinit(void)
 
 static int sched_clock_suspend(void)
 {
-	sched_clock_poll(&sched_clock_timer);
+	update_sched_clock();
+	hrtimer_cancel(&sched_clock_timer);
 	cd.suspended = true;
 	return 0;
 }
@@ -199,6 +200,7 @@ static int sched_clock_suspend(void)
 static void sched_clock_resume(void)
 {
 	cd.epoch_cyc = read_sched_clock();
+	hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
 	cd.suspended = false;
 }
 
-- 
1.9.1

