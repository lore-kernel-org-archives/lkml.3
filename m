Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3LCOio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:38:44 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47667 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3LCOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:38:35 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/6] nohz: Convert a few places to use local per cpu accesses
Date: Tue,  3 Dec 2013 15:38:21 +0100
Message-Id: <1386081506-24358-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
References: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few functions use remote per CPU access APIs when they
deal with local values.

Just do the right conversion to improve performance, code
readability and debug checks.

While at it, lets extend some of these function names with *_this_cpu()
suffix in order to display their purpose more clearly.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tick.h         |  6 +++---
 kernel/softirq.c             |  4 +---
 kernel/time/tick-broadcast.c |  6 +++---
 kernel/time/tick-internal.h  |  4 ++--
 kernel/time/tick-sched.c     | 39 ++++++++++++++++-----------------------
 5 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 5128d33..a004f66 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -104,7 +104,7 @@ extern struct cpumask *tick_get_broadcast_oneshot_mask(void);
 extern void tick_clock_notify(void);
 extern int tick_check_oneshot_change(int allow_nohz);
 extern struct tick_sched *tick_get_tick_sched(int cpu);
-extern void tick_check_idle(int cpu);
+extern void tick_check_idle(void);
 extern int tick_oneshot_mode_active(void);
 #  ifndef arch_needs_cpu
 #   define arch_needs_cpu(cpu) (0)
@@ -112,7 +112,7 @@ extern int tick_oneshot_mode_active(void);
 # else
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
-static inline void tick_check_idle(int cpu) { }
+static inline void tick_check_idle(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 # endif
 
@@ -121,7 +121,7 @@ static inline void tick_init(void) { }
 static inline void tick_cancel_sched_timer(int cpu) { }
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
-static inline void tick_check_idle(int cpu) { }
+static inline void tick_check_idle(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 11025cc..11348de 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -311,8 +311,6 @@ asmlinkage void do_softirq(void)
  */
 void irq_enter(void)
 {
-	int cpu = smp_processor_id();
-
 	rcu_irq_enter();
 	if (is_idle_task(current) && !in_interrupt()) {
 		/*
@@ -320,7 +318,7 @@ void irq_enter(void)
 		 * here, as softirq will be serviced on return from interrupt.
 		 */
 		local_bh_disable();
-		tick_check_idle(cpu);
+		tick_check_idle();
 		_local_bh_enable();
 	}
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 9532690..43780ab 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -538,10 +538,10 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
  * Called from irq_enter() when idle was interrupted to reenable the
  * per cpu device.
  */
-void tick_check_oneshot_broadcast(int cpu)
+void tick_check_oneshot_broadcast_this_cpu(void)
 {
-	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
-		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
+	if (cpumask_test_cpu(smp_processor_id(), tick_broadcast_oneshot_mask)) {
+		struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 
 		/*
 		 * We might be in the middle of switching over from
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 18e71f7..e2bced5 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -51,7 +51,7 @@ extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
-extern void tick_check_oneshot_broadcast(int cpu);
+extern void tick_check_oneshot_broadcast_this_cpu(void);
 bool tick_broadcast_oneshot_available(void);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
@@ -62,7 +62,7 @@ static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
-static inline void tick_check_oneshot_broadcast(int cpu) { }
+static inline void tick_check_oneshot_broadcast_this_cpu(void) { }
 static inline bool tick_broadcast_oneshot_available(void) { return true; }
 # endif /* !BROADCAST */
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3612fc7..2afd43f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -391,11 +391,9 @@ __setup("nohz=", setup_tick_nohz);
  */
 static void tick_nohz_update_jiffies(ktime_t now)
 {
-	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long flags;
 
-	ts->idle_waketime = now;
+	__this_cpu_write(tick_cpu_sched.idle_waketime, now);
 
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
@@ -426,17 +424,15 @@ update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_upda
 
 }
 
-static void tick_nohz_stop_idle(int cpu, ktime_t now)
+static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-
-	update_ts_time_stats(cpu, ts, now, NULL);
+	update_ts_time_stats(smp_processor_id(), ts, now, NULL);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
 }
 
-static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
+static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
 	ktime_t now = ktime_get();
 
@@ -752,7 +748,7 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
 	ktime_t now, expires;
 	int cpu = smp_processor_id();
 
-	now = tick_nohz_start_idle(cpu, ts);
+	now = tick_nohz_start_idle(ts);
 
 	if (can_stop_idle_tick(cpu, ts)) {
 		int was_stopped = ts->tick_stopped;
@@ -914,8 +910,7 @@ static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
  */
 void tick_nohz_idle_exit(void)
 {
-	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now;
 
 	local_irq_disable();
@@ -928,7 +923,7 @@ void tick_nohz_idle_exit(void)
 		now = ktime_get();
 
 	if (ts->idle_active)
-		tick_nohz_stop_idle(cpu, now);
+		tick_nohz_stop_idle(ts, now);
 
 	if (ts->tick_stopped) {
 		tick_nohz_restart_sched_tick(ts, now);
@@ -1012,12 +1007,10 @@ static void tick_nohz_switch_to_nohz(void)
  * timer and do not touch the other magic bits which need to be done
  * when idle is left.
  */
-static void tick_nohz_kick_tick(int cpu, ktime_t now)
+static void tick_nohz_kick_tick(struct tick_sched *ts, ktime_t now)
 {
 #if 0
 	/* Switch back to 2.6.27 behaviour */
-
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t delta;
 
 	/*
@@ -1032,36 +1025,36 @@ static void tick_nohz_kick_tick(int cpu, ktime_t now)
 #endif
 }
 
-static inline void tick_check_nohz(int cpu)
+static inline void tick_check_nohz_this_cpu(void)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now;
 
 	if (!ts->idle_active && !ts->tick_stopped)
 		return;
 	now = ktime_get();
 	if (ts->idle_active)
-		tick_nohz_stop_idle(cpu, now);
+		tick_nohz_stop_idle(ts, now);
 	if (ts->tick_stopped) {
 		tick_nohz_update_jiffies(now);
-		tick_nohz_kick_tick(cpu, now);
+		tick_nohz_kick_tick(ts, now);
 	}
 }
 
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
-static inline void tick_check_nohz(int cpu) { }
+static inline void tick_check_nohz_this_cpu(void) { }
 
 #endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * Called from irq_enter to notify about the possible interruption of idle()
  */
-void tick_check_idle(int cpu)
+void tick_check_idle(void)
 {
-	tick_check_oneshot_broadcast(cpu);
-	tick_check_nohz(cpu);
+	tick_check_oneshot_broadcast_this_cpu();
+	tick_check_nohz_this_cpu();
 }
 
 /*
-- 
1.8.3.1

