Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaFWIJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:09:46 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:62965 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaFWIJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:09:44 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH V2 4/5] hrtimer: Kick lowres dynticks targets on timer enqueue
Date: Mon, 23 Jun 2014 13:39:37 +0530
Message-Id: <3d7ea08ce008698e26bd39fe10f55949391073ab.1403507178.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1403393357-2070-5-git-send-email-fweisbec@gmail.com>
References: <1403393357-2070-5-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In lowres mode, hrtimers are serviced by the tick instead of a clock
event. It works well as long as the tick stays periodic but we must also
make sure that the hrtimers are serviced in dynticks mode targets,
pretty much like timer list timers do.

Note that all dynticks modes are concerned: get_nohz_timer_target()
tries not to return remote idle CPUs but there is nothing to prevent
the elected target from entering dynticks idle mode until we lock its
base. It's also prefectly legal to enqueue hrtimers on full dynticks CPU.

So there are two requirements to correctly handle dynticks:

1) On target's tick stop time, we must not delay the next tick further
   the next hrtimer.

2) On hrtimer queue time. If the tick of the target is stopped, we must
   wake up that CPU such that it sees the new hrtimer and recalculate
   the next tick accordingly.

The point 1 is well handled currently through get_nohz_timer_interrupt() and
cmp_next_hrtimer_event().

But the point 2 isn't handled at all.

Fixing this is easy though as we have the necessary API ready for that.
All we need is to call wake_up_nohz_cpu() on a target when a newly
enqueued hrtimer requires tick rescheduling, like timer list timer do.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
Hi Thomas,

Frederic is on vacations and so sending it directly.

V1->V2: s/base/new_base as pointed out by Thomas.

Pushed here as well:
git://git.kernel.org/pub/scm/linux/kernel/git/vireshk/linux.git timers/missing-kick-v2

 kernel/hrtimer.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0e32d4e..f900747 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1013,14 +1013,25 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	leftmost = enqueue_hrtimer(timer, new_base);
 
-	/*
-	 * Only allow reprogramming if the new base is on this CPU.
-	 * (it might still be on another CPU if the timer was pending)
-	 *
-	 * XXX send_remote_softirq() ?
-	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
-		&& hrtimer_enqueue_reprogram(timer, new_base)) {
+	if (!leftmost) {
+		unlock_hrtimer_base(timer, &flags);
+		return ret;
+	}
+
+	if (!hrtimer_is_hres_active(timer)) {
+		/*
+		 * Kick to reschedule the next tick to handle the new timer
+		 * on dynticks target.
+		 */
+		wake_up_nohz_cpu(new_base->cpu_base->cpu);
+	} else if (new_base->cpu_base == &__get_cpu_var(hrtimer_bases) &&
+			hrtimer_enqueue_reprogram(timer, new_base)) {
+		/*
+		 * Only allow reprogramming if the new base is on this CPU.
+		 * (it might still be on another CPU if the timer was pending)
+		 *
+		 * XXX send_remote_softirq() ?
+		 */
 		if (wakeup) {
 			/*
 			 * We need to drop cpu_base->lock to avoid a
-- 
2.0.0.rc2

