Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaAaIUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:20:18 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:52002 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaAaIUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:20:14 -0500
Date: Fri, 31 Jan 2014 09:20:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer/dynticks updates
Message-ID: <20140131082010.GC7544@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   # HEAD: a2b4c607c93a0850c8e3d90688cf3bd08576b986 Merge branch 'timers/core' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks into timers/urgent

This tree contains misc dynticks updates: a fix and three cleanups.

 Thanks,

	Ingo

------------------>
Alex Shi (1):
      nohz_full: fix code style issue of tick_nohz_full_stop_tick

Frederic Weisbecker (2):
      tick: Rename tick_check_idle() to tick_irq_enter()
      nohz: Get timekeeping max deferment outside jiffies_lock

Kevin Hilman (1):
      sched/nohz: Fix overflow error in scheduler_tick_max_deferment()


 include/linux/jiffies.h  |  6 ++++++
 include/linux/tick.h     |  6 +++---
 kernel/sched/core.c      |  2 +-
 kernel/softirq.c         |  2 +-
 kernel/time/tick-sched.c | 27 ++++++++++++++-------------
 5 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index d235e88..1f44466 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -294,6 +294,12 @@ extern unsigned long preset_lpj;
  */
 extern unsigned int jiffies_to_msecs(const unsigned long j);
 extern unsigned int jiffies_to_usecs(const unsigned long j);
+
+static inline u64 jiffies_to_nsecs(const unsigned long j)
+{
+	return (u64)jiffies_to_usecs(j) * NSEC_PER_USEC;
+}
+
 extern unsigned long msecs_to_jiffies(const unsigned int m);
 extern unsigned long usecs_to_jiffies(const unsigned int u);
 extern unsigned long timespec_to_jiffies(const struct timespec *value);
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0175d86..b84773c 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -104,7 +104,7 @@ extern struct cpumask *tick_get_broadcast_oneshot_mask(void);
 extern void tick_clock_notify(void);
 extern int tick_check_oneshot_change(int allow_nohz);
 extern struct tick_sched *tick_get_tick_sched(int cpu);
-extern void tick_check_idle(void);
+extern void tick_irq_enter(void);
 extern int tick_oneshot_mode_active(void);
 #  ifndef arch_needs_cpu
 #   define arch_needs_cpu(cpu) (0)
@@ -112,7 +112,7 @@ extern int tick_oneshot_mode_active(void);
 # else
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
-static inline void tick_check_idle(void) { }
+static inline void tick_irq_enter(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 # endif
 
@@ -121,7 +121,7 @@ static inline void tick_init(void) { }
 static inline void tick_cancel_sched_timer(int cpu) { }
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
-static inline void tick_check_idle(void) { }
+static inline void tick_irq_enter(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 36c951b..75badda 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2453,7 +2453,7 @@ u64 scheduler_tick_max_deferment(void)
 	if (time_before_eq(next, now))
 		return 0;
 
-	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
+	return jiffies_to_nsecs(next - now);
 }
 #endif
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 8a1e6e1..991e38d 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -326,7 +326,7 @@ void irq_enter(void)
 		 * here, as softirq will be serviced on return from interrupt.
 		 */
 		local_bh_disable();
-		tick_check_idle();
+		tick_irq_enter();
 		_local_bh_enable();
 	}
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 08cb0c3..9f8af69 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -533,12 +533,13 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
 
+	time_delta = timekeeping_max_deferment();
+
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
 		seq = read_seqbegin(&jiffies_lock);
 		last_update = last_jiffies_update;
 		last_jiffies = jiffies;
-		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&jiffies_lock, seq));
 
 	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
@@ -678,18 +679,18 @@ out:
 static void tick_nohz_full_stop_tick(struct tick_sched *ts)
 {
 #ifdef CONFIG_NO_HZ_FULL
-       int cpu = smp_processor_id();
+	int cpu = smp_processor_id();
 
-       if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
-               return;
+	if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
+		return;
 
-       if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
-	       return;
+	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
+		return;
 
-       if (!can_stop_full_tick())
-               return;
+	if (!can_stop_full_tick())
+		return;
 
-       tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
+	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
 #endif
 }
 
@@ -1023,7 +1024,7 @@ static void tick_nohz_kick_tick(struct tick_sched *ts, ktime_t now)
 #endif
 }
 
-static inline void tick_check_nohz_this_cpu(void)
+static inline void tick_nohz_irq_enter(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now;
@@ -1042,17 +1043,17 @@ static inline void tick_check_nohz_this_cpu(void)
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
-static inline void tick_check_nohz_this_cpu(void) { }
+static inline void tick_nohz_irq_enter(void) { }
 
 #endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * Called from irq_enter to notify about the possible interruption of idle()
  */
-void tick_check_idle(void)
+void tick_irq_enter(void)
 {
 	tick_check_oneshot_broadcast_this_cpu();
-	tick_check_nohz_this_cpu();
+	tick_nohz_irq_enter();
 }
 
 /*
