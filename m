Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaFZJKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:10:10 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:37492 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaFZJKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:10:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE351.9000602@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:09:37 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 2/8] cputime, nohz: handle last_iowait for nohz
References: <53ABE28F.6010402@jp.fujitsu.com>
In-Reply-To: <53ABE28F.6010402@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now observer cpu can refer both of idle entry time and iowait exit
time of observed sleeping cpu, so observer can get idle/iowait time
of sleeping cpu by calculating cputimes not accounted yet.

Not-Tested-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 include/linux/sched.h    |    1 +
 kernel/sched/core.c      |   27 +++++++++++++++++++++++++
 kernel/time/tick-sched.c |   48 +++++++++++++++++++++++++++++++++------------
 3 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0..29e1af0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -168,6 +168,7 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
+extern void nr_iowait_deltas(int cpu, ktime_t start, ktime_t now, ktime_t *iowait, ktime_t *idle);
 extern unsigned long this_cpu_load(void);
 
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e759238..814ee2e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2384,6 +2384,33 @@ unsigned long nr_iowait_cpu(int cpu)
 	return cpu_rq(cpu)->nr_iowait;
 }
 
+/*
+ * nr_iowait_deltas - divide idle time into idle delta and iowait delta
+ *
+ * @start: time stamp at start of idle span
+ * @now: time stamp at end of idle span
+ * @iowait_delta: address to store calculated iowait
+ * @idle_delta: address to store calculated idle
+ */
+void nr_iowait_deltas(int cpu, ktime_t start, ktime_t now,
+		      ktime_t *iowait_delta, ktime_t *idle_delta)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	raw_spin_lock(&rq->iowait_lock);
+	if (rq->nr_iowait || ktime_compare(rq->last_iowait, now) > 0) {
+		*iowait_delta = ktime_sub(now, start);
+		*idle_delta = ktime_set(0, 0);
+	} else if (ktime_compare(rq->last_iowait, start) > 0) {
+		*iowait_delta = ktime_sub(rq->last_iowait, start);
+		*idle_delta = ktime_sub(now, rq->last_iowait);
+	} else {
+		*iowait_delta = ktime_set(0, 0);
+		*idle_delta = ktime_sub(now, start);
+	}
+	raw_spin_unlock(&rq->iowait_lock);
+}
+
 #ifdef CONFIG_SMP
 
 /*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 44eb187..8d23af5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -408,16 +408,22 @@ static void tick_nohz_update_jiffies(ktime_t now)
 
 static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
-	ktime_t delta;
+	static const ktime_t ktime_zero = { .tv64 = 0 };
+	ktime_t iowait_delta = ktime_zero, idle_delta = ktime_zero;
 
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
 
 	/* Updates the per cpu time idle statistics counters */
-	delta = ktime_sub(now, ts->idle_entrytime);
-	if (nr_iowait_cpu(smp_processor_id()) > 0)
-		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-	else
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	if (ts->idle_active == 2) {
+		nr_iowait_deltas(smp_processor_id(), ts->idle_entrytime, now,
+				 &iowait_delta, &idle_delta);
+		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime,
+						 iowait_delta);
+	} else {
+		idle_delta = ktime_sub(now, ts->idle_entrytime);
+	}
+	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, idle_delta);
+
 	ts->idle_entrytime = now;
 	ts->idle_active = 0;
 
@@ -432,7 +438,13 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 
 	write_seqcount_begin(&ts->idle_sleeptime_seq);
 	ts->idle_entrytime = now;
-	ts->idle_active = 1;
+	/*
+	 * idle_active:
+	 *  0: cpu is not idle
+	 *  1: cpu is performing idle
+	 *  2: cpu is performing iowait and idle
+	 */
+	ts->idle_active = 1 + !!nr_iowait_cpu(smp_processor_id());
 	write_seqcount_end(&ts->idle_sleeptime_seq);
 
 	sched_clock_idle_sleep_event();
@@ -467,10 +479,18 @@ u64 get_cpu_idle_time_us(int cpu, u64 *wall)
 
 	do {
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
- 
-		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 
+		if (ts->idle_active) {
+			ktime_t delta;
+
+			if (ts->idle_active == 2) {
+				ktime_t unused;
+
+				nr_iowait_deltas(cpu, ts->idle_entrytime, now,
+						 &unused, &delta);
+			} else {
+				delta = ktime_sub(now, ts->idle_entrytime);
+			}
 			idle = ktime_add(ts->idle_sleeptime, delta);
 		} else {
 			idle = ts->idle_sleeptime;
@@ -510,10 +530,12 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *wall)
 
 	do {
 		seq = read_seqcount_begin(&ts->idle_sleeptime_seq);
- 
-		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
-			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 
+		if (ts->idle_active == 2) {
+			ktime_t delta, unused;
+
+			nr_iowait_deltas(cpu, ts->idle_entrytime, now,
+					 &delta, &unused);
 			iowait = ktime_add(ts->iowait_sleeptime, delta);
 		} else {
 			iowait = ts->iowait_sleeptime;
-- 
1.7.1


