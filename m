Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3HPPnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:43:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54406 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab3HPPmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:42:44 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Date: Fri, 16 Aug 2013 17:42:31 +0200
Message-Id: <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When some call site uses get_cpu_*_time_us() to read a sleeptime
stat, it deduces the total sleeptime by adding the pending time
to the last sleeptime snapshot if the CPU target is idle.

Namely this sums up to:

       sleeptime = ts($CPU)->idle_sleeptime;
       if (ts($CPU)->idle_active)
       	  sleeptime += NOW() - ts($CPU)->idle_entrytime

But this only works if idle_sleeptime, idle_entrytime and idle_active are
read and updated under some disciplined order.

Lets consider the following scenario:

             CPU 0                                            CPU 1

  (seq 1)    ts(CPU 0)->idle_active = 1
             ts(CPU 0)->idle_entrytime = NOW()

  (seq 2)    sleeptime = NOW() - ts(CPU 0)->idle_entrytime
             ts(CPU 0)->idle_sleeptime += sleeptime           sleeptime = ts(CPU 0)->idle_sleeptime;
                                                              if (ts(CPU 0)->idle_active)
             ts(CPU 0)->idle_entrytime = NOW()                    sleeptime += NOW() - ts(CPU 0)->idle_entrytime

The resulting value of sleeptime in CPU 1 can vary depending of some
ordering scenario:

* If it sees the value of idle_entrytime after seq 1 and the value of idle_sleeptime
after seq 2, the value of sleeptime will be buggy because it accounts the delta twice,
so it will be too high.

* If it sees the value of idle_entrytime after seq 2 and the value of idle_sleeptime
after seq 1, the value of sleeptime will be buggy because it misses the delta, so it
will be too low.

* If it sees the value of idle_entrytime and idle_sleeptime, both as seen after seq 1 or 2,
the value will be correct.

Some more tricky scenario can also happen if idle_active value is read from a former sequence.

Hence we must honour the following constraints:

- idle_sleeptime, idle_active and idle_entrytime must be updated and read
under some correctly enforced SMP ordering

- The three variable values as read by CPU 1 must belong to the same update
sequences from CPU 0. The update sequences must be delimited such that the
resulting three values after a sequence completion produce a coherent result
together when read from the CPU 1.

- We need to prevent from fetching middle-state sequence values.

The ideal solution to implement this synchronization is to use a seqcount. Lets
use one here around these three values to enforce sequence synchronization between
updates and read.

This fixes a reported bug where non-monotonic sleeptime stats are returned by /proc/stat
when it is frequently read. And potential cpufreq governor bugs.

Reported-by: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/tick.h     |    2 ++
 kernel/time/tick-sched.c |   37 +++++++++++++++++++++++++------------
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 62bd8b7..49f9720 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -10,6 +10,7 @@
 #include <linux/irqflags.h>
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>
+#include <linux/seqlock.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -70,6 +71,7 @@ struct tick_sched {
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
 	int				do_timer_last;
+	seqcount_t			sleeptime_seq;
 };
 
 extern void __init tick_init(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ede0405..f7fc27b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -414,6 +414,7 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 	ktime_t delta;
 
 	/* Updates the per cpu time idle statistics counters */
+	write_seqcount_begin(&ts->sleeptime_seq);
 	delta = ktime_sub(now, ts->idle_entrytime);
 	if (nr_iowait_cpu(cpu) > 0)
 		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
@@ -421,6 +422,7 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 	ts->idle_entrytime = now;
 	ts->idle_active = 0;
+	write_seqcount_end(&ts->sleeptime_seq);
 
 	sched_clock_idle_wakeup_event(0);
 }
@@ -429,8 +431,11 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 {
 	ktime_t now = ktime_get();
 
+	write_seqcount_begin(&ts->sleeptime_seq);
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
+	write_seqcount_end(&ts->sleeptime_seq);
+
 	sched_clock_idle_sleep_event();
 	return now;
 }
@@ -453,6 +458,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, idle;
+	unsigned int seq;
 
 	if (!tick_nohz_enabled)
 		return -1;
@@ -461,12 +467,15 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
-	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-		idle = ktime_add(ts->idle_sleeptime, delta);
-	} else {
-		idle = ts->idle_sleeptime;
-	}
+	do {
+		seq = read_seqcount_begin(&ts->sleeptime_seq);
+		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			idle = ktime_add(ts->idle_sleeptime, delta);
+		} else {
+			idle = ts->idle_sleeptime;
+		}
+	} while (read_seqcount_retry(&ts->sleeptime_seq, seq));
 
 	return ktime_to_us(idle);
 
@@ -491,6 +500,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, iowait;
+	unsigned int seq;
 
 	if (!tick_nohz_enabled)
 		return -1;
@@ -499,12 +509,15 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
-	if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-		iowait = ktime_add(ts->iowait_sleeptime, delta);
-	} else {
-		iowait = ts->iowait_sleeptime;
-	}
+	do {
+		seq = read_seqcount_begin(&ts->sleeptime_seq);
+		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			iowait = ktime_add(ts->iowait_sleeptime, delta);
+		} else {
+			iowait = ts->iowait_sleeptime;
+		}
+	} while (read_seqcount_retry(&ts->sleeptime_seq, seq));
 
 	return ktime_to_us(iowait);
 }
-- 
1.7.5.4

