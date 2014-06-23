Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaFWJel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:34:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbaFWJei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:34:38 -0400
Date: Mon, 23 Jun 2014 02:34:26 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-49a2a07514a3a2ea4a02482fa60575e106d960f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <3d7ea08ce008698e26bd39fe10f55949391073ab.1403507178.git.viresh.kumar@linaro.org>
References: <3d7ea08ce008698e26bd39fe10f55949391073ab.1403507178.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimer:
  Kick lowres dynticks targets on timer enqueue
Git-Commit-ID: 49a2a07514a3a2ea4a02482fa60575e106d960f9
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

Commit-ID:  49a2a07514a3a2ea4a02482fa60575e106d960f9
Gitweb:     http://git.kernel.org/tip/49a2a07514a3a2ea4a02482fa60575e106d960f9
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Mon, 23 Jun 2014 13:39:37 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 23 Jun 2014 11:23:47 +0200

hrtimer: Kick lowres dynticks targets on timer enqueue

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
Link: http://lkml.kernel.org/r/3d7ea08ce008698e26bd39fe10f55949391073ab.1403507178.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/hrtimer.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 0e32d4e..f900747 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
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
