Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3JSPSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 11:18:04 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56043 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3JSPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 11:17:31 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 3/5] timer: Change idle/iowait accounting semantics
Date: Sat, 19 Oct 2013 17:17:19 +0200
Message-Id: <1382195841-6558-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
References: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare for fixing a race between iowait and idle time stats,
this patch changes the following semantics:

* iowait time is going to be accounted from the scheduler rather than
the dynticks idle code, lets remove it from the /proc/timer_list dump.

* idle sleeptime now also includes the iowait time for simplicity.
Its accounting was relying on nr_iowait_cpu() which made the whole
share of time accounting between idle and iowait very racy. So
accounting the whole sleeptime in ts->idle_sleeptime makes it more
simple and improve its correctness.

Given the semantic change of ts->idle_sleeptime, it results in another
ABI change on /proc/timer_list for this field.

/proc/stat and other callers of get_cpu_idle_time_us() and
get_cpu_iowait_time_us() are not concerned though because we maintain
the old ABI by substracting the iowait time from the idle time.

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
 include/linux/ktime.h    |  7 +++++++
 kernel/time/tick-sched.c | 12 +++++++++---
 kernel/time/timer_list.c |  3 +--
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index 31c0cd1..7a98f6a 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -379,6 +379,13 @@ static inline ktime_t ns_to_ktime(u64 ns)
 	return ktime_add_ns(ktime_zero, ns);
 }
 
+static inline ktime_t us_to_ktime(u64 us)
+{
+	static const ktime_t ktime_zero = { .tv64 = 0 };
+
+	return ktime_add_us(ktime_zero, us);
+}
+
 static inline ktime_t ms_to_ktime(u64 ms)
 {
 	static const ktime_t ktime_zero = { .tv64 = 0 };
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7f0fb78..fbcb249 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -410,8 +410,8 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 	delta = ktime_sub(now, ts->idle_entrytime);
 	if (nr_iowait_cpu(smp_processor_id()) > 0)
 		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-	else
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+
+	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
@@ -445,6 +445,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, idle;
+	u64 iowait;
 
 	if (!tick_nohz_enabled)
 		return -1;
@@ -453,13 +454,18 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
-	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+	if (ts->idle_active) {
 		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 		idle = ktime_add(ts->idle_sleeptime, delta);
 	} else {
 		idle = ts->idle_sleeptime;
 	}
 
+	iowait = get_cpu_iowait_time_us(cpu, NULL);
+
+	if (ktime_compare(idle, us_to_ktime(iowait)) > 0)
+		idle = ktime_sub_us(idle, iowait);
+
 	return ktime_to_us(idle);
 
 }
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 61ed862..9a3f8e2 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -182,7 +182,6 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P_ns(idle_waketime);
 		P_ns(idle_exittime);
 		P_ns(idle_sleeptime);
-		P_ns(iowait_sleeptime);
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
@@ -256,7 +255,7 @@ static void timer_list_show_tickdevices_header(struct seq_file *m)
 
 static inline void timer_list_header(struct seq_file *m, u64 now)
 {
-	SEQ_printf(m, "Timer List Version: v0.7\n");
+	SEQ_printf(m, "Timer List Version: v0.8\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 	SEQ_printf(m, "\n");
-- 
1.8.3.1

