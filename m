Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3BXK60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 05:58:26 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39661 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3BXK6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 05:58:24 -0500
Message-ID: <5129F200.6080309@linux.vnet.ibm.com>
Date: Sun, 24 Feb 2013 16:27:04 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Subject: Re: [patch v5 02/15] sched: set initial load avg of new forked task
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-3-git-send-email-alex.shi@intel.com> <51246B1A.8040100@intel.com>
In-Reply-To: <51246B1A.8040100@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022410-5140-0000-0000-000002CD42D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 02/20/2013 11:50 AM, Alex Shi wrote:
> On 02/18/2013 01:07 PM, Alex Shi wrote:
>> New task has no runnable sum at its first runnable time, so its
>> runnable load is zero. That makes burst forking balancing just select
>> few idle cpus to assign tasks if we engage runnable load in balancing.
>>
>> Set initial load avg of new forked task as its load weight to resolve
>> this issue.
>>
> 
> patch answering PJT's update here. that merged the 1st and 2nd patches 
> into one. other patches in serial don't need to change.
> 
> =========
> From 89b56f2e5a323a0cb91c98be15c94d34e8904098 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Mon, 3 Dec 2012 17:30:39 +0800
> Subject: [PATCH 01/14] sched: set initial value of runnable avg for new
>  forked task
> 
> We need initialize the se.avg.{decay_count, load_avg_contrib} for a
> new forked task.
> Otherwise random values of above variables cause mess when do new task
> enqueue:
>     enqueue_task_fair
>         enqueue_entity
>             enqueue_entity_load_avg
> 
> and make forking balancing imbalance since incorrect load_avg_contrib.
> 
> set avg.decay_count = 0, and avg.load_avg_contrib = se->load.weight to
> resolve such issues.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c | 3 +++
>  kernel/sched/fair.c | 4 ++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26058d0..1452e14 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1559,6 +1559,7 @@ static void __sched_fork(struct task_struct *p)
>  #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
>  	p->se.avg.runnable_avg_period = 0;
>  	p->se.avg.runnable_avg_sum = 0;
> +	p->se.avg.decay_count = 0;
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
>  	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
> @@ -1646,6 +1647,8 @@ void sched_fork(struct task_struct *p)
>  		p->sched_reset_on_fork = 0;
>  	}
> 
I think the following comment will help here.
/* All forked tasks are assumed to have full utilization to begin with */
> +	p->se.avg.load_avg_contrib = p->se.load.weight;
> +
>  	if (!rt_prio(p->prio))
>  		p->sched_class = &fair_sched_class;
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 81fa536..cae5134 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1509,6 +1509,10 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>  	 * We track migrations using entity decay_count <= 0, on a wake-up
>  	 * migration we use a negative decay count to track the remote decays
>  	 * accumulated while sleeping.
> +	 *
> +	 * When enqueue a new forked task, the se->avg.decay_count == 0, so
> +	 * we bypass update_entity_load_avg(), use avg.load_avg_contrib initial
> +	 * value: se->load.weight.

I disagree with the comment.update_entity_load_avg() gets called for all
forked tasks.
enqueue_task_fair->update_entity_load_avg() during the second
iteration.But __update_entity_load_avg() in update_entity_load_avg()
,where the actual load update happens does not get called.This is
because as below,the last_update of the forked task is nearly equal to
the clock task of the runqueue.Hence probably 1ms has not passed by for
the load to get updated.Which is why the load of the task nor the load
of the runqueue gets updated when the task forks.

Also note that the reason we bypass update_entity_load_avg() below is
not because our decay_count=0.Its because the forked tasks have nothing
to update.Only woken up tasks and migrated wake ups have load updates to
do.Forked tasks just got created,they have no load to "update" but only
to "create". This I feel is rightly done in sched_fork by this patch.

So ideally I dont think we should have any comment here.It does not
sound relevant.

>  	 */
>  	if (unlikely(se->avg.decay_count <= 0)) {
>  		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
> 


Regards
Preeti U Murthy

