Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3EIOXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:23:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:41224 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3EIOXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:23:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,641,1363158000"; 
   d="scan'208";a="334954055"
Message-ID: <518BB14D.6050707@intel.com>
Date: Thu, 09 May 2013 22:23:09 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com> <5187760D.8060900@intel.com> <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com> <51886460.3020009@intel.com> <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com> <51887404.4060102@intel.com> <51888B2D.30901@intel.com> <518B5EC9.1030605@intel.com> <CAPM31RJ-t-WzgzFy6t8MbD4hXd2o+S8d=UTASJ0=NVhNCjsQLg@mail.gmail.com>
In-Reply-To: <CAPM31RJ-t-WzgzFy6t8MbD4hXd2o+S8d=UTASJ0=NVhNCjsQLg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 05:30 PM, Paul Turner wrote:
>> > With sched_slice, we need to set the runnable avg sum/period after new
>> > task assigned to a specific CPU.
>> > So, set them __sched_fork is meaningless. and then
> This is still a reasonable choice.
> 
> Assuming the system is well balanced, sched_slice() on the current CPU
> should be reasonably indicative of the slice wherever we end up.  The
> alternative is still to pick a constant.  We should do one of these.
> 
>> > __update_task_entity_contrib(&p->se) also no reason to use.
> Surely we'd still want it so that the right load is added by
> enqueue_entity_load_avg()?
> 

thanks for comments! 
the new patch attached, hope it is your liked this time. :)

---
>From 5606df1e46e83e64b0ade30522096c00448a97be Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 3 Dec 2012 17:30:39 +0800
Subject: [PATCH 3/7] sched: set initial value of runnable avg for new forked
 task

We need initialize the se.avg.{decay_count, load_avg_contrib} for a
new forked task.
Otherwise random values of above variables cause mess when do new task
enqueue:
    enqueue_task_fair
        enqueue_entity
            enqueue_entity_load_avg

and make forking balancing imbalance since incorrect load_avg_contrib.

Further more, Morten Rasmussen notice some tasks were not launched at
once after created. So Paul and Peter suggest giving a start value for
new task runnable avg time same as sched_slice().

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c  |    6 ++----
 kernel/sched/fair.c  |   23 +++++++++++++++++++++++
 kernel/sched/sched.h |    2 ++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c8db984..866c05a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1563,10 +1563,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-#ifdef CONFIG_SMP
-	p->se.avg.runnable_avg_period = 0;
-	p->se.avg.runnable_avg_sum = 0;
-#endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
@@ -1710,6 +1706,8 @@ void wake_up_new_task(struct task_struct *p)
 	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 #endif
 
+	/* Give new task start runnable values */
+	set_task_runnable_avg(p);
 	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
 	p->on_rq = 1;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9c2f726..203f236 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -661,6 +661,26 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
+#ifdef CONFIG_SMP
+static inline void __update_task_entity_contrib(struct sched_entity *se);
+
+/* Give new task start runnable values to heavy its load in infant time */
+void set_task_runnable_avg(struct task_struct *p)
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
+void set_task_runnable_avg(struct task_struct *p)
+{
+}
+#endif
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -1508,6 +1528,9 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	 * We track migrations using entity decay_count <= 0, on a wake-up
 	 * migration we use a negative decay count to track the remote decays
 	 * accumulated while sleeping.
+	 *
+	 * When enqueue a new forked task, the se->avg.decay_count == 0, so
+	 * we bypass update_entity_load_avg(), use avg.load_avg_contrib direct.
 	 */
 	if (unlikely(se->avg.decay_count <= 0)) {
 		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c6634f1..518f3d8a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -900,6 +900,8 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
 
 extern void update_idle_cpu_load(struct rq *this_rq);
 
+extern void set_task_runnable_avg(struct task_struct *p);
+
 #ifdef CONFIG_CGROUP_CPUACCT
 #include <linux/cgroup.h>
 /* track cpu usage of a group of tasks and its child groups */
-- 
1.7.5.4


-- 
Thanks
    Alex
