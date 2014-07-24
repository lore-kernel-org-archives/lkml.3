Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203AbaGXKHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:07:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034AbaGXKHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:07:39 -0400
Date: Thu, 24 Jul 2014 03:07:21 -0700
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-f723aa1817dd8f4fe005aab52ba70c8ab0ef9457@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, stable@vger.kernel.org, tglx@linutronix.de,
        sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, sboyd@codeaurora.org
In-Reply-To: <1406174630-23458-1-git-send-email-john.stultz@linaro.org>
References: <1406174630-23458-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] sched_clock:
  Avoid corrupting hrtimer tree during suspend
Git-Commit-ID: f723aa1817dd8f4fe005aab52ba70c8ab0ef9457
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f723aa1817dd8f4fe005aab52ba70c8ab0ef9457
Gitweb:     http://git.kernel.org/tip/f723aa1817dd8f4fe005aab52ba70c8ab0ef9457
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Wed, 23 Jul 2014 21:03:50 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 24 Jul 2014 12:02:49 +0200

sched_clock: Avoid corrupting hrtimer tree during suspend

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

Fixes: a08ca5d1089d "sched_clock: Use an hrtimer instead of timer"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/1406174630-23458-1-git-send-email-john.stultz@linaro.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
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
 
