Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbaDXSrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:47:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbaDXSrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:47:10 -0400
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
Subject: [PATCH 4/4] nohz: Fix iowait overcounting if iowait task migrates
Date: Thu, 24 Apr 2014 20:45:58 +0200
Message-Id: <1398365158-12568-4-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com>
References: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com>
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
 kernel/sched/core.c      | 14 +++++++++++
 kernel/time/tick-sched.c | 64 ++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 4de1f9e..1bf653e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -67,6 +67,7 @@ struct tick_sched {
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				iowait_sleeptime;
+	ktime_t				iowait_exittime;
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
index 268a45e..ffea757 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4218,7 +4218,14 @@ void __sched io_schedule(void)
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;
+#ifdef CONFIG_NO_HZ_COMMON
+	if (atomic_dec_and_test(&rq->nr_iowait)) {
+		if (raw_smp_processor_id() != cpu_of(rq))
+			tick_nohz_iowait_to_idle(cpu_of(rq));
+	}
+#else
 	atomic_dec(&rq->nr_iowait);
+#endif
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
@@ -4234,7 +4241,14 @@ long __sched io_schedule_timeout(long timeout)
 	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
 	current->in_iowait = 0;
+#ifdef CONFIG_NO_HZ_COMMON
+	if (atomic_dec_and_test(&rq->nr_iowait)) {
+		if (raw_smp_processor_id() != cpu_of(rq))
+			tick_nohz_iowait_to_idle(cpu_of(rq));
+	}
+#else
 	atomic_dec(&rq->nr_iowait);
+#endif
 	delayacct_blkio_end();
 	return ret;
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 47ed7cf..d78c942 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -408,15 +408,27 @@ static void tick_nohz_update_jiffies(ktime_t now)
 
 static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
-	ktime_t delta;
+	ktime_t delta, entry, end;
 
 	/* Updates the per cpu time idle statistics counters */
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
-	delta = ktime_sub(now, ts->idle_entrytime);
-	if (ts->idle_active == 2)
+	entry = ts->idle_entrytime;
+	delta = ktime_sub(now, entry);
+	if (ts->idle_active == 2) {
+		end = ts->iowait_exittime;
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
-	else
+	} else {
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	}
 	ts->idle_active = 0;
 	write_seqcount_end(&ts->idle_sleeptime_seq);
 
@@ -430,6 +442,7 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	ts->idle_entrytime = now;
 	ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;
+	ts->iowait_exittime.tv64 = KTIME_MAX;
 	write_seqcount_end(&ts->idle_sleeptime_seq);
 
 	sched_clock_idle_sleep_event();
@@ -437,6 +450,16 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 	return now;
 }
 
+void tick_nohz_iowait_to_idle(int cpu)
+{
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
+	ktime_t now = ktime_get();
+
+	write_seqcount_begin(&ts->idle_sleeptime_seq);
+	ts->iowait_exittime = now;
+	write_seqcount_end(&ts->idle_sleeptime_seq);
+}
+
 /**
  * get_cpu_idle_time_us - get the total idle time of a cpu
  * @cpu: CPU number to query
@@ -465,13 +488,26 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 		*last_update_time = ktime_to_us(now);
 
 	do {
-		ktime_t delta;
+		ktime_t start, delta, iowait_exit;
 
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		idle = ts->idle_sleeptime;
-		if (ts->idle_active == 1) {
-			delta = ktime_sub(now, ts->idle_entrytime);
+		if (ts->idle_active /* either 1 or 2 */) {
+			start = ts->idle_entrytime;
+			if (ts->idle_active == 2) {
+				/* This idle period started as "iowait idle" */
+				iowait_exit = ts->iowait_exittime;
+				if (iowait_exit.tv64 == KTIME_MAX)
+					goto skip; /* and it still is */
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
 
@@ -507,13 +543,21 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 		*last_update_time = ktime_to_us(now);
 
 	do {
-		ktime_t delta;
+		ktime_t delta, end;
 
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		iowait = ts->iowait_sleeptime;
 		if (ts->idle_active == 2) {
-			delta = ktime_sub(now, ts->idle_entrytime);
-			iowait = ktime_add(ts->iowait_sleeptime, delta);
+			/*
+			 * If last iowaiting task on our rq was woken up on other CPU
+			 * sometime in the past, it updated ts->iowait_exittime.
+			 * Otherwise, ts->iowait_exittime == KTIME_MAX.
+			 */
+			end = ts->iowait_exittime;
+			if (end.tv64 == KTIME_MAX)
+				end = now;
+			delta = ktime_sub(end, ts->idle_entrytime);
+			iowait = ktime_add(iowait, delta);
 		}
 	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
-- 
1.8.1.4

