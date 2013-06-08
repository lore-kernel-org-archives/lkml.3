Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3FHVWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 17:22:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:51107 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3FHVWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 17:22:43 -0400
Date: Sat, 8 Jun 2013 23:22:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT Pull] timer fixes for 3.10
Message-ID: <alpine.LFD.2.02.1306082316510.24812@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

 * Trivial fixes: Unused variable removal

 * Posix-timers: Add the clock ID to the new proc interface to make it
   useful. The interface is new and should be functional when we reach
   the final 3.10 release.

 * Cure a false positive warning in the tick code introduced by the
   overhaul in 3.10

 * Fix for a persistant clock detection regression introduced in this
   cycle

Thanks,

	tglx

------------------>
Geert Uytterhoeven (1):
      ntp: Remove unused variable flags in __hardpps

Pavel Tikhomirov (1):
      posix-timers: Show clock ID in proc file

Thomas Gleixner (1):
      tick: Cure broadcast false positive pending bit warning

Zoran Markovic (1):
      timekeeping: Correct run-time detection of persistent_clock.


 fs/proc/base.c               |    1 +
 kernel/time/ntp.c            |    1 -
 kernel/time/tick-broadcast.c |    8 +++++++-
 kernel/time/timekeeping.c    |    8 ++++++++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index dd51e50..c3834da 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2118,6 +2118,7 @@ static int show_timer(struct seq_file *m, void *v)
 		nstr[notify & ~SIGEV_THREAD_ID],
 		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
 		pid_nr_ns(timer->it_pid, tp->ns));
+	seq_printf(m, "ClockID: %d\n", timer->it_clock);
 
 	return 0;
 }
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 12ff13a..8f5b3b9 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -874,7 +874,6 @@ static void hardpps_update_phase(long error)
 void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
 	struct pps_normtime pts_norm, freq_norm;
-	unsigned long flags;
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 24938d5..0c73942 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -511,6 +511,12 @@ again:
 		}
 	}
 
+	/*
+	 * Remove the current cpu from the pending mask. The event is
+	 * delivered immediately in tick_do_broadcast() !
+	 */
+	cpumask_clear_cpu(smp_processor_id(), tick_broadcast_pending_mask);
+
 	/* Take care of enforced broadcast requests */
 	cpumask_or(tmpmask, tmpmask, tick_broadcast_force_mask);
 	cpumask_clear(tick_broadcast_force_mask);
@@ -575,8 +581,8 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
-		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
+			WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			/*
 			 * We only reprogram the broadcast timer if we
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 98cd470..baeeb5c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -975,6 +975,14 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
+	/*
+	 * On some systems the persistent_clock can not be detected at
+	 * timekeeping_init by its return value, so if we see a valid
+	 * value returned, update the persistent_clock_exists flag.
+	 */
+	if (timekeeping_suspend_time.tv_sec || timekeeping_suspend_time.tv_nsec)
+		persistent_clock_exist = true;
+
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 	timekeeping_forward_now(tk);
