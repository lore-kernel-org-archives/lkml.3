Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3JSPSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 11:18:01 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61937 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3JSPRb (ORCPT
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
Subject: [PATCH 2/5] nohz: Only update sleeptime stats locally
Date: Sat, 19 Oct 2013 17:17:18 +0200
Message-Id: <1382195841-6558-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
References: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle and io sleeptime stats can be updated concurrently from callers
of get_cpu_idle_time_us(), get_cpu_iowait_time_us() and
tick_nohz_stop_idle().

Updaters can easily race and mess up with internal datas coherency,
for example when a governor calls a get_cpu_*_time_us() API and the
target CPU exits idle at the same time, because no locking or whatsoever
is there to protect against this concurrency.

To fix this, lets only update the sleeptime stats locally when the CPU
exits from idle. This is the only place where a real update is truly
needed. The callers of get_cpu_*_time_us() can simply add up the pending
sleep time delta to the last sleeptime snapshot in order to get a coherent
result. There is no need for them to also update the stats.

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
 kernel/time/tick-sched.c | 63 ++++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 42 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b93b5b9..7f0fb78 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -402,31 +402,16 @@ static void tick_nohz_update_jiffies(ktime_t now)
 	touch_softlockup_watchdog();
 }
 
-/*
- * Updates the per cpu time idle statistics counters
- */
-static void
-update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_update_time)
+static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
 	ktime_t delta;
 
-	if (ts->idle_active) {
-		delta = ktime_sub(now, ts->idle_entrytime);
-		if (nr_iowait_cpu(cpu) > 0)
-			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-		else
-			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		ts->idle_entrytime = now;
-	}
-
-	if (last_update_time)
-		*last_update_time = ktime_to_us(now);
-
-}
-
-static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
-{
-	update_ts_time_stats(smp_processor_id(), ts, now, NULL);
+	/* Updates the per cpu time idle statistics counters */
+	delta = ktime_sub(now, ts->idle_entrytime);
+	if (nr_iowait_cpu(smp_processor_id()) > 0)
+		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+	else
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
@@ -465,17 +450,14 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 		return -1;
 
 	now = ktime_get();
-	if (last_update_time) {
-		update_ts_time_stats(cpu, ts, now, last_update_time);
-		idle = ts->idle_sleeptime;
-	} else {
-		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+	if (last_update_time)
+		*last_update_time = ktime_to_us(now);
 
-			idle = ktime_add(ts->idle_sleeptime, delta);
-		} else {
-			idle = ts->idle_sleeptime;
-		}
+	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+		idle = ktime_add(ts->idle_sleeptime, delta);
+	} else {
+		idle = ts->idle_sleeptime;
 	}
 
 	return ktime_to_us(idle);
@@ -506,17 +488,14 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 		return -1;
 
 	now = ktime_get();
-	if (last_update_time) {
-		update_ts_time_stats(cpu, ts, now, last_update_time);
-		iowait = ts->iowait_sleeptime;
-	} else {
-		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+	if (last_update_time)
+		*last_update_time = ktime_to_us(now);
 
-			iowait = ktime_add(ts->iowait_sleeptime, delta);
-		} else {
-			iowait = ts->iowait_sleeptime;
-		}
+	if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+		iowait = ktime_add(ts->iowait_sleeptime, delta);
+	} else {
+		iowait = ts->iowait_sleeptime;
 	}
 
 	return ktime_to_us(iowait);
-- 
1.8.3.1

