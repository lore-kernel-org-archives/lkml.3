Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3GVLpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:45:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab3GVLpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:45:12 -0400
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC -v2 2/2] watchdog: update watchdog_tresh properly
Date: Mon, 22 Jul 2013 13:45:02 +0200
Message-Id: <1374493502-31907-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374224699-13255-2-git-send-email-mhocko@suse.cz>
References: <1374224699-13255-2-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog_tresh controls how often nmi perf event counter checks per-cpu
hrtimer_interrupts counter and blows up if the counter hasn't changed
since the last check. The counter is updated by per-cpu watchdog_hrtimer
hrtimer which is scheduled with 2/5 watchdog_thresh period which
guarantees that hrtimer is scheduled 2 times per the main period. Both
hrtimer and perf event are started together when the watchdog is
enabled.

So far so good. But...

But what happens when watchdog_thresh is updated from sysctl handler?

proc_dowatchdog will set a new sampling period and hrtimer callback
(watchdog_timer_fn) will use the new value in the next round.
The problem, however, is that nobody tells the perf event that the
sampling period has changed so it is ticking with the period configured
when it has been set up.

This might result in an ear riping dissonance between perf and hrtimer
parts if the watchdog_thresh is increased. And even worse it might lead
to KABOOM if the watchdog is configured to panic on such a spurious
lockup.

This patch fixes the issue by updating both nmi perf even counter and
hrtimers if the threshold value has changed.

The nmi one is disabled and then reinitialized from scratch. This
has an unpleasant side effect that the allocation of the new event might
fail theoretically so the hard lockup detector would be disabled for
such cpus. On the other hand such a memory allocation failure is very
unlikely because the original event is deallocated right before.
It would be much nicer if we just changed perf event period but there
doesn't seem to be any API to do that right now.
It is also unfortunate that perf_event_alloc uses GFP_KERNEL allocation
unconditionally so we cannot use on_each_cpu() and do the same thing
from the per-cpu context. The update from the current CPU should be
safe because perf_event_disable removes the event atomically before
it clears the per-cpu watchdog_ev so it cannot change anything under
running handler feet.

The hrtimer is simply restarted (thanks to Don Zickus who has pointed
this out) because we cannot rely it will fire&adopt to the new sampling
period before a new nmi event triggers (when the treshold is decreased).

Changes since v1
- restart hrtimer to ensure that hrtimer doesn't mess new nmi as pointed
  out by Don Zickus

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/watchdog.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 2d64c02..7108d3d 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -486,7 +486,50 @@ static struct smp_hotplug_thread watchdog_threads = {
 	.unpark			= watchdog_enable,
 };
 
-static int watchdog_enable_all_cpus(void)
+static void restart_watchdog_hrtimer(void *info)
+{
+	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
+
+	hrtimer_restart(hrtimer);
+}
+
+static void update_timers(int cpu)
+{
+	/*
+	 * Make sure that perf event counter will adopt to a new
+	 * sampling period. Updating the sampling period directly would
+	 * be much nicer but we do not have an API for that now so
+	 * let's use a big hammer.
+	 * Hrtimer will adopt the new period on the next tick but this
+	 * might be late already so we have to restart the timer as well.
+	 */
+	watchdog_nmi_disable(cpu);
+	if (cpu == smp_processor_id()) {
+		struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
+
+		hrtimer_restart(hrtimer);
+	} else {
+		struct call_single_data data = {
+			.func = restart_watchdog_hrtimer};
+
+		__smp_call_function_single(cpu, &data, 1);
+	}
+	watchdog_nmi_enable(cpu);
+}
+
+static void update_timers_all_cpus(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	preempt_disable();
+	for_each_online_cpu(cpu)
+		update_timers(cpu);
+	preempt_enable();
+	put_online_cpus();
+}
+
+static int watchdog_enable_all_cpus(bool sample_period_changed)
 {
 	int err = 0;
 
@@ -496,6 +539,8 @@ static int watchdog_enable_all_cpus(void)
 			pr_err("Failed to create watchdog threads, disabled\n");
 		else
 			watchdog_running = 1;
+	} else if (sample_period_changed) {
+		update_timers_all_cpus();
 	}
 
 	return err;
@@ -537,7 +582,7 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 	 * watchdog_*_all_cpus() function takes care of this.
 	 */
 	if (watchdog_user_enabled && watchdog_thresh)
-		err = watchdog_enable_all_cpus();
+		err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
 	else
 		watchdog_disable_all_cpus();
 
@@ -565,5 +610,5 @@ void __init lockup_detector_init(void)
 #endif
 
 	if (watchdog_user_enabled)
-		watchdog_enable_all_cpus();
+		watchdog_enable_all_cpus(false);
 }
-- 
1.8.3.2

