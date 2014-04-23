Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaDWTCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:02:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516AbaDWTCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:02:12 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 3/3] nohz: Fix iowait overcounting if iowait task migrates
Date: Wed, 23 Apr 2014 21:00:36 +0200
Message-Id: <1398279636-21503-3-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1398279636-21503-1-git-send-email-dvlasenk@redhat.com>
References: <1398279636-21503-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change, if last IO-blocked task wakes up
on a different CPU, the original CPU may stay idle for much longer,
and the entire time it stays idle is accounted as iowait time.

This change adds struct tick_sched::iowait_exittime member.
On entry to idle, it is set to KTIME_MAX.
Last IO-blocked task, if migrated, sets it to current time.
Note that this can happen only once per each idle period:
new iowaiting tasks can't magically appear on idle CPU's rq.

If iowait_exittime is set, then (iowait_exittime - idle_entrytime)
gets accounted as iowait, and the remaining (now - iowait_exittime)
as "true" idle.

Run-tested: /proc/stats no longer go backwards.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/tick.h     |  3 ++
 kernel/sched/core.c      | 20 ++++++++++++++
 kernel/time/tick-sched.c | 72 ++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..2a27883 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -67,6 +67,7 @@ struct tick_sched {
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				iowait_sleeptime;
+	ktime_t				iowait_exittime;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
@@ -139,6 +140,7 @@ extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
+extern void tick_nohz_iowait_to_idle(int cpu);
 
 # else /* !CONFIG_NO_HZ_COMMON */
 static inline int tick_nohz_tick_stopped(void)
@@ -157,6 +159,7 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
+static inline void tick_nohz_iowait_to_idle(int cpu) { }
 # endif /* !CONFIG_NO_HZ_COMMON */
 
 #ifdef CONFIG_NO_HZ_FULL
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9cae286..08dd220 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4255,6 +4255,9 @@ EXPORT_SYMBOL_GPL(yield_to);
  */
 void __sched io_schedule(void)
 {
+#ifdef CONFIG_NO_HZ_COMMON
+	int cpu_on_entry = smp_processor_id();
+#endif
 	struct rq *rq = raw_rq();
 
 	delayacct_blkio_start();
@@ -4263,13 +4266,23 @@ void __sched io_schedule(void)
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;
+#ifdef CONFIG_NO_HZ_COMMON
+	if (atomic_dec_and_test(&rq->nr_iowait)) {
+		if (smp_processor_id() != cpu_on_entry)
+			tick_nohz_iowait_to_idle(cpu_on_entry);
+	}
+#else
 	atomic_dec(&rq->nr_iowait);
+#endif
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
 
 long __sched io_schedule_timeout(long timeout)
 {
+#ifdef CONFIG_NO_HZ_COMMON
+	int cpu_on_entry = smp_processor_id();
+#endif
 	struct rq *rq = raw_rq();
 	long ret;
 
@@ -4279,7 +4292,14 @@ long __sched io_schedule_timeout(long timeout)
 	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
 	current->in_iowait = 0;
+#ifdef CONFIG_NO_HZ_COMMON
+	if (atomic_dec_and_test(&rq->nr_iowait)) {
+		if (smp_processor_id() != cpu_on_entry)
+			tick_nohz_iowait_to_idle(cpu_on_entry);
+	}
+#else
 	atomic_dec(&rq->nr_iowait);
+#endif
 	delayacct_blkio_end();
 	return ret;
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a99770e..679a577 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -403,17 +403,48 @@ static void tick_nohz_update_jiffies(ktime_t now)
 	touch_softlockup_watchdog();
 }
 
+/*
+ * Race prevention for idle/iowait counters:
+ *
+ * On entry and exit to idle/iowait states,
+ * ts->idle_entrytime, ts->{idle,iowait}_sleeptime and ts->idle_active
+ * fields are updated in this order, serialized with smp_wmb().
+ * On exit, ts->idle_entrytime is zeroed.
+ *
+ * The readers - get_cpu_{idle,iowait}_time_us() - fetch these fields
+ * in reversed order, serialized with smp_rmb().
+ * If ts->idle_active == 0, reading of ts->idle_entrytime (and one smp_rmb())
+ * are not necessary. If ts->idle_active != 0, ts->idle_entrytime
+ * (which is needed anyway for calculations)
+ * needs to be checked for zero, and reads need to be done anew if it is zeroed.
+ *
+ * This implements a seqlock-like race detection without needing additional
+ * data fields and read-modify-write ops on them.
+ */
 static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
-	ktime_t delta;
+	ktime_t delta, entry;
 
 	/* Updates the per cpu time idle statistics counters */
-	delta = ktime_sub(now, ts->idle_entrytime);
+	entry = ts->idle_entrytime;
+	delta = ktime_sub(now, entry);
 	ts->idle_entrytime.tv64 = 0;
 	smp_wmb();
 
-	if (ts->idle_active == 2)
+	if (ts->idle_active == 2) {
+		ktime_t end = ts->iowait_exittime;
+
+		if (end.tv64 != KTIME_MAX) {
+			/*
+			 * Last iowaiting task on our rq was woken up on other CPU
+			 * sometime in the past, it updated ts->iowait_exittime.
+			 */
+			delta = ktime_sub(now, end);
+			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+			delta = ktime_sub(end, entry);
+		}
 		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+	}
 	else
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 
@@ -430,10 +461,18 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 	ts->idle_entrytime = now;
 	smp_wmb();
 	ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;
+	ts->iowait_exittime.tv64 = KTIME_MAX;
 	sched_clock_idle_sleep_event();
 	return now;
 }
 
+void tick_nohz_iowait_to_idle(int cpu)
+{
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
+
+	ts->iowait_exittime = ktime_get();
+}
+
 /**
  * get_cpu_idle_time_us - get the total idle time of a cpu
  * @cpu: CPU number to query
@@ -467,7 +506,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	active = ACCESS_ONCE(ts->idle_active);
 	smp_rmb();
 	count = ACCESS_ONCE(ts->idle_sleeptime);
-	if (active == 1) {
+	if (active /* either 1 or 2 */) {
 		ktime_t delta, start;
 
 		smp_rmb();
@@ -479,6 +518,18 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 			 */
 			goto again;
 		}
+		if (active == 2) {
+			/* This idle period started as "iowait idle" */
+			ktime_t iowait_exit = ACCESS_ONCE(ts->iowait_exittime);
+
+			if (iowait_exit.tv64 == KTIME_MAX)
+				goto skip; /* and it still is */
+			/*
+			 * This CPU used to be "iowait idle", but iowait task
+			 * has migrated. The rest of idle time is "true idle":
+			 */
+			start = iowait_exit;
+		}
 		delta = ktime_sub(now, start);
 		count = ktime_add(count, delta);
 	} else {
@@ -488,6 +539,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 		 * we fetched idle_active, so count must be valid.
 		 */
 	}
+ skip:
 
 	return ktime_to_us(count);
 }
@@ -527,7 +579,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 	smp_rmb();
 	count = ACCESS_ONCE(ts->iowait_sleeptime);
 	if (active == 2) {
-		ktime_t delta, start;
+		ktime_t delta, start, end;
 
 		smp_rmb();
 		start = ACCESS_ONCE(ts->idle_entrytime);
@@ -538,7 +590,15 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 			 */
 			goto again;
 		}
-		delta = ktime_sub(now, start);
+		/*
+		 * If last iowaiting task on our rq was woken up on other CPU
+		 * sometime in the past, it updated ts->iowait_exittime.
+		 * Otherwise, ts->iowait_exittime == KTIME_MAX.
+		 */
+		end = ACCESS_ONCE(ts->iowait_exittime);
+		if (end.tv64 == KTIME_MAX)
+			end = now;
+		delta = ktime_sub(end, start);
 		count = ktime_add(count, delta);
 	} else {
 		/*
-- 
1.8.1.4

