Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3CYFY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 01:24:27 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:36929 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab3CYFYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 01:24:25 -0400
Message-ID: <514FDF76.2060806@linux.vnet.ibm.com>
Date: Mon, 25 Mar 2013 13:24:06 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH] sched: wake-affine throttle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032505-4790-0000-0000-0000078BC762
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently testing show that wake-affine stuff cause regression on pgbench, the
hiding rat was finally catched out.

wake-affine stuff is always trying to pull wakee close to waker, by theory,
this will benefit us if waker's cpu cached hot data for wakee, or the extreme
ping-pong case.

However, the whole stuff is somewhat blindly, there is no examining on the
relationship between waker and wakee, and since the stuff itself
is time-consuming, some workload suffered, pgbench is just the one who
has been found.

Thus, throttle the wake-affine stuff for such workload is necessary.

This patch introduced a new knob 'sysctl_sched_wake_affine_interval' with the
default value 1ms, which means wake-affine stuff only effect once per 1ms, which
usually the minimum balance interval (the idea is that the rapid of wake-affine
should lower than the rapid of load-balance at least).

By turning the new knob, those workload who suffered will have the chance to
stop the regression.

Test:
	Test with 12 cpu X86 server and tip 3.9.0-rc2.

	Default 1ms interval bring limited performance improvement(<5%) for
	pgbench, significant improvement start to show when turning the
	knob to 100ms.

			    original	100ms	

	| db_size | clients |  tps  |	|  tps  |
	+---------+---------+-------+   +-------+
	| 21 MB   |       1 | 10572 |   | 10675 |
	| 21 MB   |       2 | 21275 |   | 21228 |
	| 21 MB   |       4 | 41866 |   | 41946 |
	| 21 MB   |       8 | 53931 |   | 55176 |
	| 21 MB   |      12 | 50956 |   | 54457 |	+6.87%
	| 21 MB   |      16 | 49911 |   | 55468 |	+11.11%
	| 21 MB   |      24 | 46046 |   | 56446 |	+22.59%
	| 21 MB   |      32 | 43405 |   | 55177 |	+27.12%
	| 7483 MB |       1 |  7734 |   |  7721 |
	| 7483 MB |       2 | 19375 |   | 19277 |
	| 7483 MB |       4 | 37408 |   | 37685 |
	| 7483 MB |       8 | 49033 |   | 49152 |
	| 7483 MB |      12 | 45525 |   | 49241 |	+8.16%
	| 7483 MB |      16 | 45731 |   | 51425 |	+12.45%
	| 7483 MB |      24 | 41533 |   | 52349 |	+26.04%
	| 7483 MB |      32 | 36370 |   | 51022 |	+40.28%
	| 15 GB   |       1 |  7576 |   |  7422 |
	| 15 GB   |       2 | 19157 |   | 19176 |
	| 15 GB   |       4 | 37285 |   | 36982 |
	| 15 GB   |       8 | 48718 |   | 48413 |
	| 15 GB   |      12 | 45167 |   | 48497 |	+7.37%
	| 15 GB   |      16 | 45270 |   | 51276 |	+13.27%
	| 15 GB   |      24 | 40984 |   | 51628 |	+25.97%
	| 15 GB   |      32 | 35918 |   | 51060 |	+42.16%

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    5 +++++
 kernel/sched/fair.c   |   33 ++++++++++++++++++++++++++++++++-
 kernel/sysctl.c       |   10 ++++++++++
 3 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..e9efd3a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1197,6 +1197,10 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_sched_wake_affine_interval;
+#endif
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1207,6 +1211,7 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	struct llist_node wake_entry;
 	int on_cpu;
+	unsigned long next_wake_affine;
 #endif
 	int on_rq;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..00d7f45 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3087,6 +3087,22 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 #endif
 
+/*
+ * Default is 1ms, to prevent the wake_affine() stuff working too frequently.
+ */
+unsigned int sysctl_sched_wake_affine_interval = 1U;
+
+static inline int wake_affine_throttled(struct task_struct *p)
+{
+	return time_before(jiffies, p->next_wake_affine);
+}
+
+static inline void wake_affine_throttle(struct task_struct *p)
+{
+	p->next_wake_affine = jiffies +
+			msecs_to_jiffies(sysctl_sched_wake_affine_interval);
+}
+
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
@@ -3096,6 +3112,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	unsigned long weight;
 	int balanced;
 
+	if (wake_affine_throttled(p))
+		return 0;
+
 	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
@@ -3342,8 +3361,20 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
+		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync)) {
+			/*
+			 * wake_affine() stuff try to pull wakee to the cpu
+			 * around waker, this will benefit us if the data
+			 * cached on waker cpu is hot for wakee, or the extreme
+			 * ping-pong case.
+			 *
+			 * However, do such blindly work too frequently will
+			 * cause regression to some workload, thus, each time
+			 * when wake_affine() succeed, throttle it for a while.
+			 */
+			wake_affine_throttle(p);
 			prev_cpu = cpu;
+		}
 
 		new_cpu = select_idle_sibling(p, prev_cpu);
 		goto unlock;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index afc1dc6..6b798b6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -437,6 +437,16 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &one,
 	},
 #endif
+#ifdef CONFIG_SMP
+	{
+		.procname	= "sched_wake_affine_interval",
+		.data		= &sysctl_sched_wake_affine_interval,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
-- 
1.7.4.1

