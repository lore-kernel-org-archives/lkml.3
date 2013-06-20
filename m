Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422698Ab3FTUpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:45:53 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61615 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965700Ab3FTUps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:45:48 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH 1/4] sched: Disable lb_bias feature for full dynticks
Date: Thu, 20 Jun 2013 22:45:38 +0200
Message-Id: <1371761141-25386-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371761141-25386-1-git-send-email-fweisbec@gmail.com>
References: <1371761141-25386-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we run in full dynticks mode, we currently have no way to
correctly update the secondary decaying indexes of the CPU
load stats as it is typically maintained by update_cpu_load_active()
at each tick.

We have an available infrastructure that handles tickless loads
(cf: decay_load_missed) but it seems to only work for idle tickless
loads, which only applies if the CPU hasn't run any real task but
idle on the tickless timeslice.

Until we can provide a sane mathematical solution to handle full
dynticks loads, lets simply deactivate the LB_BIAS sched feature
if CONFIG_NO_HZ_FULL as it is currently the only user of the decayed
load records.

The first load index that represents the current runqueue load weight
is still maintained and usable.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c     |   13 +++++++++++--
 kernel/sched/features.h |    3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c0ac2c3..2e8df6f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2937,6 +2937,15 @@ static unsigned long weighted_cpuload(const int cpu)
 	return cpu_rq(cpu)->load.weight;
 }
 
+static inline int sched_lb_bias(void)
+{
+#ifndef CONFIG_NO_HZ_FULL
+	return sched_feat(LB_BIAS);
+#else
+	return 0;
+#endif
+}
+
 /*
  * Return a low guess at the load of a migration-source cpu weighted
  * according to the scheduling class and "nice" value.
@@ -2949,7 +2958,7 @@ static unsigned long source_load(int cpu, int type)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (type == 0 || !sched_lb_bias())
 		return total;
 
 	return min(rq->cpu_load[type-1], total);
@@ -2964,7 +2973,7 @@ static unsigned long target_load(int cpu, int type)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (type == 0 || !sched_lb_bias())
 		return total;
 
 	return max(rq->cpu_load[type-1], total);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 99399f8..635f902 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -43,7 +43,10 @@ SCHED_FEAT(ARCH_POWER, true)
 
 SCHED_FEAT(HRTICK, false)
 SCHED_FEAT(DOUBLE_TICK, false)
+
+#ifndef CONFIG_NO_HZ_FULL
 SCHED_FEAT(LB_BIAS, true)
+#endif
 
 /*
  * Decrement CPU power based on time not spent running tasks
-- 
1.7.5.4

