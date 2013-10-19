Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3JSPSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 11:18:08 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60134 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3JSPRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 11:17:34 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 5/5] nohz: Synchronize sleep time stats with seqlock
Date: Sat, 19 Oct 2013 17:17:21 +0200
Message-Id: <1382195841-6558-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
References: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
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
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/tick.h     |  1 +
 kernel/time/tick-sched.c | 22 ++++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 7a66bf6..4d6131e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -65,6 +65,7 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
+	seqcount_t			idle_sleeptime_seq;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a038d4e..da53cbf 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -407,9 +407,11 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 	ktime_t delta;
 
 	/* Updates the per cpu time idle statistics counters */
+	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	delta = ktime_sub(now, ts->idle_entrytime);
 	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 	ts->idle_active = 0;
+	write_seqcount_end(&ts->idle_sleeptime_seq);
 
 	sched_clock_idle_wakeup_event(0);
 }
@@ -418,9 +420,13 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
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
 
@@ -442,6 +448,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, idle;
+	unsigned int seq;
 	u64 iowait;
 
 	if (!tick_nohz_enabled)
@@ -451,12 +458,16 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
-	if (ts->idle_active) {
-		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-		idle = ktime_add(ts->idle_sleeptime, delta);
-	} else {
+	do {
+		ktime_t delta;
+
+		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
 		idle = ts->idle_sleeptime;
-	}
+		if (ts->idle_active) {
+			delta = ktime_sub(now, ts->idle_entrytime);
+			idle = ktime_add(idle, delta);
+		}
+	} while (read_seqcount_retry(&ts->idle_sleeptime_seq, seq));
 
 	iowait = get_cpu_iowait_time_us(cpu, NULL);
 
@@ -468,7 +479,6 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 		idle = ktime_sub_us(idle, iowait);
 
 	return ktime_to_us(idle);
-
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
-- 
1.8.3.1

