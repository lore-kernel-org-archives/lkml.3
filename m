Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3EGFDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:03:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:35340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab3EGFDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:03:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="237858341"
Message-ID: <51888B2D.30901@intel.com>
Date: Tue, 07 May 2013 13:03:41 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
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
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com> <5187760D.8060900@intel.com> <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com> <51886460.3020009@intel.com> <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com> <51887404.4060102@intel.com>
In-Reply-To: <51887404.4060102@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 11:24 AM, Alex Shi wrote:
>> > The reason to store a small initial "observation" here is so that as
>> > when we reach our next period edge our load converges (presumably
>> > down) towards its true target more smoothly; as well as providing a
>> > task additional protection from being considered "small" through
>> > start-up.
>> > 
> It will give new forked task 1 ms extra running time. That will bring
> incorrect info if the new forked goes to sleep a while.
> But this info should benefit to some benchmarks like aim7,
> pthread_cond_broadcast. So I am convinced. :)
> 
> What's your opinion of this, Peter?


Here is the patch according to Paul's opinions. 
just refer the __update_task_entity_contrib in sched.h looks ugly.
comments are appreciated!

---
>From 647404447c996507b6a94110ed13fd122e4ee154 Mon Sep 17 00:00:00 2001
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

set avg.decay_count = 0, and give initial value of runnable_avg_sum/period
to resolve such issues.

Thanks for Pual's suggestions

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c  | 8 +++++++-
 kernel/sched/fair.c  | 4 ++++
 kernel/sched/sched.h | 1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c8db984..4e78de1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1566,6 +1566,11 @@ static void __sched_fork(struct task_struct *p)
 #ifdef CONFIG_SMP
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
+	p->se.avg.decay_count = 0;
+	/* New forked task assumed with full utilization */
+	p->se.avg.runnable_avg_period = 1024;
+	p->se.avg.runnable_avg_sum = 1024;
+	__update_task_entity_contrib(&p->se);
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
@@ -1619,7 +1624,6 @@ void sched_fork(struct task_struct *p)
 	unsigned long flags;
 	int cpu = get_cpu();
 
-	__sched_fork(p);
 	/*
 	 * We mark the process as running here. This guarantees that
 	 * nobody will actually run it, and a signal or other external
@@ -1653,6 +1657,8 @@ void sched_fork(struct task_struct *p)
 		p->sched_reset_on_fork = 0;
 	}
 
+	__sched_fork(p);
+
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9c2f726..2881d42 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1508,6 +1508,10 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	 * We track migrations using entity decay_count <= 0, on a wake-up
 	 * migration we use a negative decay count to track the remote decays
 	 * accumulated while sleeping.
+	 *
+	 * When enqueue a new forked task, the se->avg.decay_count == 0, so
+	 * we bypass update_entity_load_avg(), use avg.load_avg_contrib initial
+	 * value: se->load.weight.
 	 */
 	if (unlikely(se->avg.decay_count <= 0)) {
 		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c6634f1..ec4cb9b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -876,6 +876,7 @@ extern const struct sched_class idle_sched_class;
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
+extern inline void __update_task_entity_contrib(struct sched_entity *se);
 #else	/* CONFIG_SMP */
 
 static inline void idle_balance(int cpu, struct rq *rq)
-- 
1.7.12

-- 
Thanks
    Alex
