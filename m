Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3HPPoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:44:06 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56634 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3HPPmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:42:46 -0400
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
Subject: [PATCH 3/4] nohz: Consolidate sleep time stats read code
Date: Fri, 16 Aug 2013 17:42:32 +0200
Message-Id: <1376667753-29014-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_cpu_idle_time_us() and get_cpu_iowait_time_us() mostly share
the same code. Lets consolidate both implementations.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/time/tick-sched.c |   76 ++++++++++++++++++++--------------------------
 1 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f7fc27b..017bec2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -440,24 +440,10 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 	return now;
 }
 
-/**
- * get_cpu_idle_time_us - get the total idle time of a cpu
- * @cpu: CPU number to query
- * @last_update_time: variable to store update time in. Do not update
- * counters if NULL.
- *
- * Return the cummulative idle time (since boot) for a given
- * CPU, in microseconds.
- *
- * This time is measured via accounting rather than sampling,
- * and is as accurate as ktime_get() is.
- *
- * This function returns -1 if NOHZ is not enabled.
- */
-u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
+static u64 get_cpu_sleep_time_us(int cpu, bool io, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now, idle;
+	ktime_t now, sleep;
 	unsigned int seq;
 
 	if (!tick_nohz_enabled)
@@ -469,16 +455,41 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 
 	do {
 		seq = read_seqcount_begin(&ts->sleeptime_seq);
-		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+		if (io)
+			sleep = ts->iowait_sleeptime;
+		else
+			sleep = ts->idle_sleeptime;
+
+		if (ts->idle_active)
+			continue;
+
+		if ((io && nr_iowait_cpu(cpu)) || (!io && !nr_iowait_cpu(cpu))) {
 			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-			idle = ktime_add(ts->idle_sleeptime, delta);
-		} else {
-			idle = ts->idle_sleeptime;
+			sleep = ktime_add(sleep, delta);
 		}
 	} while (read_seqcount_retry(&ts->sleeptime_seq, seq));
 
-	return ktime_to_us(idle);
+	return ktime_to_us(sleep);
+
+}
 
+/**
+ * get_cpu_idle_time_us - get the total idle time of a cpu
+ * @cpu: CPU number to query
+ * @last_update_time: variable to store update time in. Do not update
+ * counters if NULL.
+ *
+ * Return the cummulative idle time (since boot) for a given
+ * CPU, in microseconds.
+ *
+ * This time is measured via accounting rather than sampling,
+ * and is as accurate as ktime_get() is.
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
+u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
+{
+	return get_cpu_sleep_time_us(cpu, false, last_update_time);
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
@@ -498,28 +509,7 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
  */
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now, iowait;
-	unsigned int seq;
-
-	if (!tick_nohz_enabled)
-		return -1;
-
-	now = ktime_get();
-	if (last_update_time)
-		*last_update_time = ktime_to_us(now);
-
-	do {
-		seq = read_seqcount_begin(&ts->sleeptime_seq);
-		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
-			iowait = ktime_add(ts->iowait_sleeptime, delta);
-		} else {
-			iowait = ts->iowait_sleeptime;
-		}
-	} while (read_seqcount_retry(&ts->sleeptime_seq, seq));
-
-	return ktime_to_us(iowait);
+	return get_cpu_sleep_time_us(cpu, true, last_update_time);
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
-- 
1.7.5.4

