Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3F0JIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:08:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3F0JC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:28 -0400
Date: Thu, 27 Jun 2013 02:01:47 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-a75cdaa915e42ef0e6f38dc7f2a6a1deca91d648@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, alex.shi@intel.com,
        guz.fnst@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, alex.shi@intel.com,
        guz.fnst@cn.fujitsu.com, tglx@linutronix.de
In-Reply-To: <1371694737-29336-4-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-4-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Set an initial value of runnable avg for new forked task
Git-Commit-ID: a75cdaa915e42ef0e6f38dc7f2a6a1deca91d648
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:01:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a75cdaa915e42ef0e6f38dc7f2a6a1deca91d648
Gitweb:     http://git.kernel.org/tip/a75cdaa915e42ef0e6f38dc7f2a6a1deca91d648
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:47 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:30 +0200

sched: Set an initial value of runnable avg for new forked task

We need to initialize the se.avg.{decay_count, load_avg_contrib} for a
new forked task. Otherwise random values of above variables cause a
mess when a new task is enqueued:

    enqueue_task_fair
        enqueue_entity
            enqueue_entity_load_avg

and make fork balancing imbalance due to incorrect load_avg_contrib.

Further more, Morten Rasmussen notice some tasks were not launched at
once after created. So Paul and Peter suggest giving a start value for
new task runnable avg time same as sched_slice().

PeterZ said:

> So the 'problem' is that our running avg is a 'floating' average; ie. it
> decays with time. Now we have to guess about the future of our newly
> spawned task -- something that is nigh impossible seeing these CPU
> vendors keep refusing to implement the crystal ball instruction.
>
> So there's two asymptotic cases we want to deal well with; 1) the case
> where the newly spawned program will be 'nearly' idle for its lifetime;
> and 2) the case where its cpu-bound.
>
> Since we have to guess, we'll go for worst case and assume its
> cpu-bound; now we don't want to make the avg so heavy adjusting to the
> near-idle case takes forever. We want to be able to quickly adjust and
> lower our running avg.
>
> Now we also don't want to make our avg too light, such that it gets
> decremented just for the new task not having had a chance to run yet --
> even if when it would run, it would be more cpu-bound than not.
>
> So what we do is we make the initial avg of the same duration as that we
> guess it takes to run each task on the system at least once -- aka
> sched_slice().
>
> Of course we can defeat this with wakeup/fork bombs, but in the 'normal'
> case it should be good enough.

Paul also contributed most of the code comments in this commit.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Reviewed-by: Paul Turner <pjt@google.com>
[peterz; added explanation of sched_slice() usage]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-4-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  |  6 ++----
 kernel/sched/fair.c  | 24 ++++++++++++++++++++++++
 kernel/sched/sched.h |  2 ++
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0241b1b..729e7fc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1611,10 +1611,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-#ifdef CONFIG_SMP
-	p->se.avg.runnable_avg_period = 0;
-	p->se.avg.runnable_avg_sum = 0;
-#endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
@@ -1758,6 +1754,8 @@ void wake_up_new_task(struct task_struct *p)
 	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 #endif
 
+	/* Initialize new task's runnable average */
+	init_task_runnable_average(p);
 	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
 	p->on_rq = 1;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 36eadaa..e1602a0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -680,6 +680,26 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
+#ifdef CONFIG_SMP
+static inline void __update_task_entity_contrib(struct sched_entity *se);
+
+/* Give new task start runnable values to heavy its load in infant time */
+void init_task_runnable_average(struct task_struct *p)
+{
+	u32 slice;
+
+	p->se.avg.decay_count = 0;
+	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
+	p->se.avg.runnable_avg_sum = slice;
+	p->se.avg.runnable_avg_period = slice;
+	__update_task_entity_contrib(&p->se);
+}
+#else
+void init_task_runnable_average(struct task_struct *p)
+{
+}
+#endif
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -1527,6 +1547,10 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	 * We track migrations using entity decay_count <= 0, on a wake-up
 	 * migration we use a negative decay count to track the remote decays
 	 * accumulated while sleeping.
+	 *
+	 * Newly forked tasks are enqueued with se->avg.decay_count == 0, they
+	 * are seen by enqueue_entity_load_avg() as a migration with an already
+	 * constructed load_avg_contrib.
 	 */
 	if (unlikely(se->avg.decay_count <= 0)) {
 		se->avg.last_runnable_update = rq_clock_task(rq_of(cfs_rq));
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 31d25f8..9c65d46 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1048,6 +1048,8 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
 
 extern void update_idle_cpu_load(struct rq *this_rq);
 
+extern void init_task_runnable_average(struct task_struct *p);
+
 #ifdef CONFIG_PARAVIRT
 static inline u64 steal_ticks(u64 steal)
 {
