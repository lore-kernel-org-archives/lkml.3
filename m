Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbaEGNmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:42:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161AbaEGNmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:42:53 -0400
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
Subject: [PATCH 4/4 v2] nohz: Fix iowait overcounting if iowait task migrates
Date: Wed,  7 May 2014 15:41:34 +0200
Message-Id: <1399470094-8070-4-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1399470094-8070-1-git-send-email-dvlasenk@redhat.com>
References: <1399470094-8070-1-git-send-email-dvlasenk@redhat.com>
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

v2:
* Made iowait_exittime atomic64_t. This way, no locking
  is necessary when setting/accessing it.
* Do more paranoid checking of iowait_exittime before using it:
  now code checks that idle_entrytime <= iowait_exittime
  and iowait_exittime <= now, and uses iowait_exittime only
  if both are true.

Run-tested: /proc/stat counters no longer go backwards.

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
 include/linux/tick.h     |  2 ++
 kernel/sched/core.c      | 19 ++++++++--
 kernel/time/tick-sched.c | 91 +++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 98 insertions(+), 14 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 4de1f9e..49f8b29 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -67,6 +67,7 @@ struct tick_sched {
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				iowait_sleeptime;
+	atomic64_t			iowait_exittime;
 	seqcount_t			idle_sleeptime_seq;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
@@ -140,6 +141,7 @@ extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
+extern void tick_nohz_iowait_to_idle(int cpu);
 
 # else /* !CONFIG_NO_HZ_COMMON */
 static inline int tick_nohz_tick_stopped(void)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..3137980 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4208,6 +4208,21 @@ EXPORT_SYMBOL_GPL(yield_to);
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
  */
+#ifdef CONFIG_NO_HZ_COMMON
+static __sched void io_wait_end(struct rq *rq)
+{
+	if (atomic_dec_and_test(&rq->nr_iowait)) {
+		if (raw_smp_processor_id() != cpu_of(rq))
+			tick_nohz_iowait_to_idle(cpu_of(rq));
+	}
+}
+#else
+static inline void io_wait_end(struct rq *rq)
+{
+	atomic_dec(&rq->nr_iowait);
+}
+#endif
+
 void __sched io_schedule(void)
 {
 	struct rq *rq = raw_rq();
@@ -4218,7 +4233,7 @@ void __sched io_schedule(void)
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	io_wait_end(rq);
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
@@ -4234,7 +4249,7 @@ long __sched io_schedule_timeout(long timeout)
 	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	io_wait_end(rq);
 	delayacct_blkio_end();
 	return ret;
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7d0e14a..f3b214d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -411,17 +411,41 @@ enum {
 	IOWAIT_IDLE = 2,
 };
 
+/* We always access iowait_exittime atomically. */
+static inline ktime_t fetch_iowait_exittime(struct tick_sched *ts)
+{
+	ktime_t v;
+
+	v.tv64 = atomic64_read(&ts->iowait_exittime);
+	return v;
+}
+
 static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
-	ktime_t delta;
+	ktime_t start, delta, end;
 
 	/* Updates the per cpu time idle statistics counters */
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
-	delta = ktime_sub(now, ts->idle_entrytime);
-	if (ts->idle_active == IOWAIT_IDLE)
+	start = ts->idle_entrytime;
+	delta = ktime_sub(now, start);
+
+	if (ts->idle_active == IOWAIT_IDLE) {
+		/*
+		 * If last iowaiting task on our rq wakes up on another
+		 * CPU, it sets iowait_exittime.
+		 * It's the only case it can satisfy "start <= end <= now".
+		 */
+		end = fetch_iowait_exittime(ts);
+		if (ktime_compare(start, end) <= 0 && ktime_compare(end, now) <= 0) {
+			/* [end, now] goes to "true idle" counter */
+			delta = ktime_sub(now, end);
+			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+			delta = ktime_sub(end, start);
+		}
 		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-	else
+	} else {
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	}
 	ts->idle_active = 0;
 	write_seqcount_end(&ts->idle_sleeptime_seq);
 
@@ -435,6 +459,7 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	ts->idle_entrytime = now;
 	ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? IOWAIT_IDLE : TRUE_IDLE;
+	atomic64_set(&ts->iowait_exittime, KTIME_MAX);
 	write_seqcount_end(&ts->idle_sleeptime_seq);
 
 	sched_clock_idle_sleep_event();
@@ -442,6 +467,14 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 	return now;
 }
 
+void tick_nohz_iowait_to_idle(int cpu)
+{
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
+	ktime_t now = ktime_get();
+
+	atomic64_set(&ts->iowait_exittime, now.tv64);
+}
+
 /**
  * get_cpu_idle_time_us - get the total idle time of a cpu
  * @cpu: CPU number to query
@@ -458,7 +491,7 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
  */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts;
 	ktime_t now, idle;
 	unsigned int seq;
 
@@ -469,14 +502,35 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
+	ts = &per_cpu(tick_cpu_sched, cpu);
+
 	do {
-		ktime_t delta;
+		ktime_t start, delta, iowait_exit;
 
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		idle = ts->idle_sleeptime;
-		if (ts->idle_active == TRUE_IDLE) {
-			delta = ktime_sub(now, ts->idle_entrytime);
+
+		if (ts->idle_active /* either IOWAIT_IDLE or TRUE_IDLE */) {
+			start = ts->idle_entrytime;
+
+			if (ts->idle_active == IOWAIT_IDLE) {
+				/* This idle period started as iowait */
+
+				iowait_exit = fetch_iowait_exittime(ts);
+				if (ktime_compare(start, iowait_exit) > 0 ||
+				    ktime_compare(iowait_exit, now) > 0) {
+					/* And it still is (iowait_exit isn't set) */
+					goto skip;
+				}
+				/*
+				 * This CPU used to be "iowait idle", but iowait task
+				 * has migrated. The rest of idle time is "true idle":
+				 */
+				start = iowait_exit;
+			}
+			delta = ktime_sub(now, start);
 			idle = ktime_add(idle, delta);
+ skip: ;
 		}
 	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
@@ -500,7 +554,7 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
  */
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts;
 	ktime_t now, iowait;
 	unsigned int seq;
 
@@ -511,14 +565,27 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
+	ts = &per_cpu(tick_cpu_sched, cpu);
+
 	do {
-		ktime_t delta;
+		ktime_t start, delta, iowait_exit;
 
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		iowait = ts->iowait_sleeptime;
+
 		if (ts->idle_active == IOWAIT_IDLE) {
-			delta = ktime_sub(now, ts->idle_entrytime);
-			iowait = ktime_add(ts->iowait_sleeptime, delta);
+			start = ts->idle_entrytime;
+			iowait_exit = fetch_iowait_exittime(ts);
+			/*
+			 * Did last iowaiting task on our rq wake up on other CPU
+			 * sometime in the past, and updated ts->iowait_exittime?
+			 */
+			if (ktime_compare(start, iowait_exit) > 0 ||
+			    ktime_compare(iowait_exit, now) > 0) {
+				iowait_exit = now; /* no */
+			}
+			delta = ktime_sub(iowait_exit, start);
+			iowait = ktime_add(iowait, delta);
 		}
 	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
-- 
1.8.1.4

