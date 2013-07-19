Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059Ab3GSJGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:06:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759927Ab3GSJF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:05:56 -0400
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC 2/2] watchdog: update watchdog_tresh properly
Date: Fri, 19 Jul 2013 11:04:59 +0200
Message-Id: <1374224699-13255-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374224699-13255-1-git-send-email-mhocko@suse.cz>
References: <1374224699-13255-1-git-send-email-mhocko@suse.cz>
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

This patch fixes the issue by disabling nmi perf event counter and
reinitialize it from scratch if the threshold value has changed. This
has an unpleasant side effect that the allocation of the new event might
fail theoretically so the hard lockup detector would be disabled for
such cpus. On the other hand such a memory allocation failure is very
unlikely because the original event is deallocated right before.
It would be much nicer if we just changed perf event period but there
doesn't seem to be any API to do that right now.

It is also unfortunate that perf_event_alloc uses GFP_KERNEL allocation
unconditionally so we cannot use on_each_cpu() and do the same thing
from the per-cpu context. The update from the current CPU should be safe
because perf_event_disable removes the event atomically before it clears
the per-cpu watchdog_ev so it cannot change under running handler feet.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/watchdog.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 2d64c02..75e0bef 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -486,7 +486,31 @@ static struct smp_hotplug_thread watchdog_threads = {
 	.unpark			= watchdog_enable,
 };
 
-static int watchdog_enable_all_cpus(void)
+static void watchdog_nmi_reenable(int cpu)
+{
+	/*
+	 * Make sure that perf event counter will adopt to a new
+	 * sampling period. Update the sampling period directly would
+	 * be much nicer but we do not have an API for that now so
+	 * let's use a big hammer.
+	 */
+	watchdog_nmi_disable(cpu);
+	watchdog_nmi_enable(cpu);
+}
+
+static void watchdog_nmi_reenable_all_cpus(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	preempt_disable();
+	for_each_online_cpu(cpu)
+		watchdog_nmi_reenable(cpu);
+	preempt_enable();
+	put_online_cpus();
+}
+
+static int watchdog_enable_all_cpus(bool sample_period_changed)
 {
 	int err = 0;
 
@@ -496,6 +520,8 @@ static int watchdog_enable_all_cpus(void)
 			pr_err("Failed to create watchdog threads, disabled\n");
 		else
 			watchdog_running = 1;
+	} else if (sample_period_changed) {
+		watchdog_nmi_reenable_all_cpus();
 	}
 
 	return err;
@@ -537,7 +563,7 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 	 * watchdog_*_all_cpus() function takes care of this.
 	 */
 	if (watchdog_user_enabled && watchdog_thresh)
-		err = watchdog_enable_all_cpus();
+		err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
 	else
 		watchdog_disable_all_cpus();
 
@@ -565,5 +591,5 @@ void __init lockup_detector_init(void)
 #endif
 
 	if (watchdog_user_enabled)
-		watchdog_enable_all_cpus();
+		watchdog_enable_all_cpus(false);
 }
-- 
1.8.3.2

