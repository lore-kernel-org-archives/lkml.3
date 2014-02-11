Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaBKQmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:42:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33120 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaBKQmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:42:04 -0500
Date: Tue, 11 Feb 2014 17:41:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>, Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Message-ID: <20140211164136.GT27965@twins.programming.kicks-ass.net>
References: <20140131090230.GM5002@laptop.programming.kicks-ass.net>
 <52EB6F65.8050008@linux.vnet.ibm.com>
 <52EBBC23.8020603@linux.intel.com>
 <52EBC33A.6080101@linaro.org>
 <52EBC645.2040607@linux.intel.com>
 <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr>
 <20140203125441.GD19029@e103034-lin>
 <52EFA9D3.1030601@linux.intel.com>
 <20140203145605.GL8874@twins.programming.kicks-ass.net>
 <52EFC12B.50704@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EFC12B.50704@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 08:17:47AM -0800, Arjan van de Ven wrote:
> On 2/3/2014 6:56 AM, Peter Zijlstra wrote:
> if there's a simple api like
> 
> sched_cpu_cache_wiped(int llc)
> 
> that would be very nice for this; the menuidle side knows this
> for some cases and thus can just call it. This would be a very
> small and minimal change
> 
> * if you don't care about llc vs core local caches then that
>   parameter can go away
> 
> * I assume this is also called for the local cpu... if not then we
>   need to add a cpu number argument
> 
> * we can also call this from architecture code when wbinvd or the
>   arm equivalent is called etc

A little something like so?

---
 kernel/sched/core.c  | 21 +++++++++++++++++++++
 kernel/sched/fair.c  | 13 ++++++++++---
 kernel/sched/sched.h |  1 +
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fb9764fbc537..b06bcadc6d71 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5466,6 +5466,27 @@ static void update_top_cache_domain(int cpu)
 }
 
 /*
+ * Mark the current LLC as empty.
+ */
+void sched_llc_wipe_cache(void)
+{
+	struct sched_domain *sd;
+
+	rcu_read_lock();
+	sd = rcu_dereference(__get_cpu_var(sd_llc));
+	if (sd) {
+		int cpu;
+
+		for_each_cpu(cpu, sched_domain_span(sd)) {
+			struct rq *rq = cpu_rq(cpu);
+
+			rq->llc_wiped = sched_clock_cpu(cpu);
+		}
+	}
+	rcu_read_unlock();
+}
+
+/*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
  */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 235cfa7ad8fc..9f8ce98f8131 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5025,9 +5025,10 @@ static void move_task(struct task_struct *p, struct lb_env *env)
 /*
  * Is this task likely cache-hot:
  */
-static int
-task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
+static int task_hot(struct task_struct *p, struct lb_env *env)
 {
+	u64 now = rq_clock_task(env->src_rq);
+	struct sched_domain *sd = env->sd;
 	s64 delta;
 
 	if (p->sched_class != &fair_sched_class)
@@ -5049,6 +5050,12 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	if (sysctl_sched_migration_cost == 0)
 		return 0;
 
+	/*
+	 * If its LLC got wiped after it ran last, we're as cold as it gets.
+	 */
+	if ((s64)(p->se.exec_start - env->src_rq->llc_wiped) < 0)
+		return 0;
+
 	delta = now - p->se.exec_start;
 
 	return delta < (s64)sysctl_sched_migration_cost;
@@ -5187,7 +5194,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) task is cache cold, or
 	 * 3) too many balance attempts have failed.
 	 */
-	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq), env->sd);
+	tsk_cache_hot = task_hot(p, env);
 	if (!tsk_cache_hot)
 		tsk_cache_hot = migrate_degrades_locality(p, env);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bf34c257d3b..c98793112614 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -582,6 +582,7 @@ struct rq {
 
 	struct list_head cfs_tasks;
 
+	u64 llc_wiped;
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
