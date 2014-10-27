Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaJ0RmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:42:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49625 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaJ0RmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:42:04 -0400
Message-ID: <544E8401.2030409@arm.com>
Date: Mon, 27 Oct 2014 17:42:25 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "tuukka.tikkanen@linaro.org" <tuukka.tikkanen@linaro.org>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>
Subject: Re: [PATCH RFC 6/7] sched: cfs: cpu frequency scaling based on task
 placement
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org> <1413958051-7103-7-git-send-email-mturquette@linaro.org>
In-Reply-To: <1413958051-7103-7-git-send-email-mturquette@linaro.org>
X-OriginalArrivalTime: 27 Oct 2014 17:42:00.0019 (UTC) FILETIME=[4F8D4A30:01CFF20D]
X-MC-Unique: 114102717420109901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 22/10/14 07:07, Mike Turquette wrote:
> {en,de}queue_task_fair are updated to track which cpus will have changed
> utilization values as function of task queueing.

The sentence is a little bit misleading. We update the se utilization
contrib and the cfs_rq utilization in {en,de}queue_task_fair for a
specific se and a specific cpu = rq_of(cfs_rq_of(se))->cpu .

> The affected cpus are
> passed on to arch_eval_cpu_freq for further machine-specific processing
> based on a selectable policy.

I'm not sure if separating the evaluation and the setting of the cpu
frequency makes sense. You could evaluate and possibly set the cpu
frequency in one go. Right now you evaluate if the cfs_rq utilization
exceeds the thresholds for the current index every time a task is
enqueued or dequeued but that's not necessary since you only try to set
the cpu frequency in the softirq. The history (and the future if we
consider blocked utilization) is already captured in the cfs_rq
utilization itself.

> 
> arch_scale_cpu_freq is called from run_rebalance_domains as a way to
> kick off the scaling process (via wake_up_process), so as to prevent
> re-entering the {en,de}queue code.

The name is misleading from the viewpoint of the CFS sched class. The
original scaling function of the CFS scheduler
(arch_scale_{freq,smt/cpu,rt}_capacity) scale capacity based on
frequency, uarch or rt. So your function should be call
arch_scale_util_cpu_freq or even better arch_set_cpu_freq.

> 
> All of the call sites in this patch are up for discussion. Does it make
> sense to track which cpus have updated statistics in enqueue_fair_task?

Not really because cfs_rq utilization tracks the history/(future) of cpu
utilization and you can evaluate the signal when you want to set the cpu
frequency.

> I chose this because I wanted to gather statistics for all cpus affected
> in the event CONFIG_FAIR_GROUP_SCHED is enabled. As agreed at LPC14 the
> next version of this patch will focus on the simpler case of not using
> scheduler cgroups, which should remove a good chunk of this code,
> including the cpumask stuff.

I don't understand why you should care about task groups at all. The
task groups contribution to the utilization of a cpu should be already
encountered for in the appropriate cpu's cfs_rq utilization signal.

But I can see a dependency to the fact that there is a difference
between systems with per-cluster (package) or per-cpu frequency scaling.
But there is no SD_SHARE_FREQDOMAIN (sched domain flag) today which
applied to the SD level MC could tell you tahts we deal with per-cluster
frequency scaling though.
On systems with per-cpu frequency scaling you can set the frequency for
individual cpus by hooking into the scheduler but for systems with
per-cluster frequency scaling, you would have to respect the maximum cpu
utilization of all cpus in the cluster.

A similar problem occurs with hardware threads (SMT sd level).

But I don't know right now how the sd topology hierarchy can become
handy here.

> 
> Also discussed at LPC14 is that fact that load_balance is a very
> interesting place to do this as frequency can be considered in concert
> with task placement. Please put forth any ideas on a sensible way to do
> this.
> 
> Is run_rebalance_domains a logical place to change cpu frequency? What
> other call sites make sense?

At least it's a good place to test this feature for now.

> 
> Even for platforms that can target a cpu frequency without sleeping
> (x86, some ARM platforms with PM microcontrollers) it is currently
> necessary to always kick the frequency target work out into a kthread.
> This is because of the rw_sem usage in the cpufreq core which might
> sleep. Replacing that lock type is probably a good idea.
> 
> Not-signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>  kernel/sched/fair.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1af6f6d..3619f63 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3999,6 +3999,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  {
>  	struct cfs_rq *cfs_rq;
>  	struct sched_entity *se = &p->se;
> +	struct cpumask update_cpus;
> +
> +	cpumask_clear(&update_cpus);
>  
>  	for_each_sched_entity(se) {
>  		if (se->on_rq)
> @@ -4028,12 +4031,27 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  
>  		update_cfs_shares(cfs_rq);
>  		update_entity_load_avg(se, 1);
> +		/* track cpus that need to be re-evaluated */
> +		cpumask_set_cpu(cpu_of(rq_of(cfs_rq)), &update_cpus);
>  	}
>  
> +	/* !CONFIG_FAIR_GROUP_SCHED */
>  	if (!se) {
>  		update_rq_runnable_avg(rq, rq->nr_running);
>  		add_nr_running(rq, 1);
> +
> +		/*
> +		 * FIXME for !CONFIG_FAIR_GROUP_SCHED it might be nice to
> +		 * typedef update_cpus into an int and skip all of the cpumask
> +		 * stuff
> +		 */
> +		cpumask_set_cpu(cpu_of(rq), &update_cpus);
>  	}
> +
> +	if (energy_aware())
> +		if (!cpumask_empty(&update_cpus))
> +			arch_eval_cpu_freq(&update_cpus);
> +
>  	hrtick_update(rq);
>  }
>  
> @@ -4049,6 +4067,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  	struct cfs_rq *cfs_rq;
>  	struct sched_entity *se = &p->se;
>  	int task_sleep = flags & DEQUEUE_SLEEP;
> +	struct cpumask update_cpus;
> +
> +	cpumask_clear(&update_cpus);
>  
>  	for_each_sched_entity(se) {
>  		cfs_rq = cfs_rq_of(se);
> @@ -4089,12 +4110,27 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  
>  		update_cfs_shares(cfs_rq);
>  		update_entity_load_avg(se, 1);
> +		/* track runqueues/cpus that need to be re-evaluated */
> +		cpumask_set_cpu(cpu_of(rq_of(cfs_rq)), &update_cpus);
>  	}
>  
> +	/* !CONFIG_FAIR_GROUP_SCHED */
>  	if (!se) {
>  		sub_nr_running(rq, 1);
>  		update_rq_runnable_avg(rq, 1);
> +
> +		/*
> +		 * FIXME for !CONFIG_FAIR_GROUP_SCHED it might be nice to
> +		 * typedef update_cpus into an int and skip all of the cpumask
> +		 * stuff
> +		 */
> +		cpumask_set_cpu(cpu_of(rq), &update_cpus);
>  	}
> +
> +	if (energy_aware())
> +		if (!cpumask_empty(&update_cpus))
> +			arch_eval_cpu_freq(&update_cpus);
> +
>  	hrtick_update(rq);
>  }
>  
> @@ -7536,6 +7572,9 @@ static void run_rebalance_domains(struct softirq_action *h)
>  	 * stopped.
>  	 */
>  	nohz_idle_balance(this_rq, idle);
> +
> +	if (energy_aware())
> +		arch_scale_cpu_freq();
>  }
>  
>  /*
> 


