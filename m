Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbaDXSrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:47:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734AbaDXSqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:46:52 -0400
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
Subject: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Date: Thu, 24 Apr 2014 20:45:56 +0200
Message-Id: <1398365158-12568-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com>
References: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is adapted from a very similar patch
by Frederic Weisbecker. The commit message text is also mostly
from Frederic's patch.

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

This fixes potential cpufreq governor bugs.
It also works towards fixing reported bug where non-monotonic sleeptime stats
are returned by /proc/stat when it is frequently read.

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
 include/linux/tick.h     |  1 +
 kernel/time/tick-sched.c | 37 ++++++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..4de1f9e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -67,6 +67,7 @@ struct tick_sched {
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				iowait_sleeptime;
+	seqcount_t			idle_sleeptime_seq;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7d86a54..8f0f2ee 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -411,12 +411,14 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 	ktime_t delta;
 
 	/* Updates the per cpu time idle statistics counters */
+	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	delta = ktime_sub(now, ts->idle_entrytime);
 	if (nr_iowait_cpu(smp_processor_id()) > 0)
 		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
 	else
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 	ts->idle_active = 0;
+	write_seqcount_end(&ts->idle_sleeptime_seq);
 
 	sched_clock_idle_wakeup_event(0);
 }
@@ -425,9 +427,13 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
 	ktime_t now = ktime_get();
 
+	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
+	write_seqcount_end(&ts->idle_sleeptime_seq);
+
 	sched_clock_idle_sleep_event();
+
 	return now;
 }
 
@@ -449,6 +455,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, idle;
+	unsigned int seq;
 
 	if (!tick_nohz_active)
 		return -1;
@@ -457,15 +464,18 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
-	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-		idle = ktime_add(ts->idle_sleeptime, delta);
-	} else {
+	do {
+		ktime_t delta;
+
+		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		idle = ts->idle_sleeptime;
-	}
+		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+			delta = ktime_sub(now, ts->idle_entrytime);
+			idle = ktime_add(idle, delta);
+		}
+	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	return ktime_to_us(idle);
-
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
@@ -487,6 +497,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, iowait;
+	unsigned int seq;
 
 	if (!tick_nohz_active)
 		return -1;
@@ -495,12 +506,16 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
-	if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-		iowait = ktime_add(ts->iowait_sleeptime, delta);
-	} else {
+	do {
+		ktime_t delta;
+
+		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		iowait = ts->iowait_sleeptime;
-	}
+		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+			delta = ktime_sub(now, ts->idle_entrytime);
+			iowait = ktime_add(ts->iowait_sleeptime, delta);
+		}
+	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	return ktime_to_us(iowait);
 }
-- 
1.8.1.4

