Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3EUDUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:20:30 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39906 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3EUDU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:20:29 -0400
Message-ID: <519AE7F2.706@linux.vnet.ibm.com>
Date: Tue, 21 May 2013 11:20:18 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v2] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com>
In-Reply-To: <5164DCE7.8080906@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052103-9264-0000-0000-000003C89AE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Log since v1:
	Add cc list.
	Add more comments.
	Tested on tip 3.10.0-rc1.

wake-affine stuff is always trying to pull wakee close to waker, by theory,
this will benefit us if waker's cpu cached hot data for wakee, or the extreme
ping-pong case, and testing show it could benefit hackbench 15% at most.

However, the whole feature is somewhat blindly, load balance is the only factor
to be guaranteed, and since the stuff itself is time-consuming, some workload
suffered, and testing show it could damage pgbench 41% at most.

The feature currently settled in mainline, which means the current scheduler
force sacrificed some workloads to benefit others, that is definitely unfair.

Thus, this patch provide the way to throttle wake-affine stuff, in order to
adjust the gain and loss according to demand.

The patch introduced a new knob 'sysctl_sched_wake_affine_interval' with the
default value 1ms (default minimum balance interval), which means wake-affine
will keep silent for 1ms after it's failure.

By turning the new knob, compared with mainline, which currently blindly using
wake-affine, pgbench show 41% improvement at most.

Link:
	Analysis from Mike Galbraith about the improvement:
		https://lkml.org/lkml/2013/4/11/54

	Analysis about the reason of throttle after failed:
		https://lkml.org/lkml/2013/5/3/31

Test:
	Test with 12 cpu X86 server and tip 3.10.0-rc1.

				default
		    base	1ms interval	 10ms interval	   100ms interval
| db_size | clients |  tps  |   |  tps  |        |  tps  |         |  tps  |
+---------+---------+-------+   +-------+        +-------+         +-------+
| 22 MB   |       1 | 10828 |   | 10850 |        | 10795 |         | 10845 |
| 22 MB   |       2 | 21434 |   | 21469 |        | 21463 |         | 21455 |
| 22 MB   |       4 | 41563 |   | 41826 |        | 41789 |         | 41779 |
| 22 MB   |       8 | 53451 |   | 54917 |        | 59250 |         | 59097 |
| 22 MB   |      12 | 48681 |   | 50454 |        | 53248 |         | 54881 |
| 22 MB   |      16 | 46352 |   | 49627 | +7.07% | 54029 | +16.56% | 55935 | +20.67%
| 22 MB   |      24 | 44200 |   | 46745 | +5.76% | 52106 | +17.89% | 57907 | +31.01%
| 22 MB   |      32 | 43567 |   | 45264 | +3.90% | 51463 | +18.12% | 57122 | +31.11%
| 7484 MB |       1 |  8926 |   |  8959 |        |  8765 |         |  8682 |
| 7484 MB |       2 | 19308 |   | 19470 |        | 19397 |         | 19409 |
| 7484 MB |       4 | 37269 |   | 37501 |        | 37552 |         | 37470 |
| 7484 MB |       8 | 47277 |   | 48452 |        | 51535 |         | 52095 |
| 7484 MB |      12 | 42815 |   | 45347 |        | 48478 |         | 49256 |
| 7484 MB |      16 | 40951 |   | 44063 | +7.60% | 48536 | +18.52% | 51141 | +24.88%
| 7484 MB |      24 | 37389 |   | 39620 | +5.97% | 47052 | +25.84% | 52720 | +41.00%
| 7484 MB |      32 | 36705 |   | 38109 | +3.83% | 45932 | +25.14% | 51456 | +40.19%
| 15 GB   |       1 |  8642 |   |  8850 |        |  9092 |         |  8560 |
| 15 GB   |       2 | 19256 |   | 19285 |        | 19362 |         | 19322 |
| 15 GB   |       4 | 37114 |   | 37131 |        | 37221 |         | 37257 |
| 15 GB   |       8 | 47120 |   | 48053 |        | 50845 |         | 50923 |
| 15 GB   |      12 | 42386 |   | 44748 |        | 47868 |         | 48875 |
| 15 GB   |      16 | 40624 |   | 43414 | +6.87% | 48169 | +18.57% | 50814 | +25.08%
| 15 GB   |      24 | 37110 |   | 39096 | +5.35% | 46594 | +25.56% | 52477 | +41.41%
| 15 GB   |      32 | 36252 |   | 37316 | +2.94% | 45327 | +25.03% | 51217 | +41.28%

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>
CC: Alex Shi <alex.shi@intel.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    5 +++++
 kernel/sched/fair.c   |   35 +++++++++++++++++++++++++++++++++++
 kernel/sysctl.c       |   10 ++++++++++
 3 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..1af1473 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1031,6 +1031,10 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_sched_wake_affine_interval;
+#endif
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1041,6 +1045,7 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	struct llist_node wake_entry;
 	int on_cpu;
+	unsigned long next_wake_affine;
 #endif
 	int on_rq;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f62b16d..417fa87 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3127,6 +3127,22 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
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
@@ -3136,6 +3152,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	unsigned long weight;
 	int balanced;
 
+	if (wake_affine_throttled(p))
+		return 0;
+
 	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
@@ -3207,6 +3226,22 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 		return 1;
 	}
+
+	/*
+	 * wake_affine() stuff try to pull wakee to the cpu
+	 * around waker, this will benefit us if the data
+	 * cached on waker cpu is hot for wakee, or the extreme
+	 * ping-pong case.
+	 *
+	 * However, do such blindly work too frequently will
+	 * cause regression to some workload, thus, each time
+	 * when wake_affine() failed, throttle it for a while.
+	 *
+	 * Throttle when failed is supposed to make the interval
+	 * cover more failures, since failed wake_affine()
+	 * is nothing but wasting cpu cycles.
+	 */
+	wake_affine_throttle(p);
 	return 0;
 }
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..3ca46d7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -436,6 +436,16 @@ static struct ctl_table kern_table[] = {
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
+		.extra1		= &zero,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
-- 
1.7.4.1

