Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaJWEEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:04:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36805 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbaJWEEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:04:50 -0400
Message-ID: <54487E28.7070305@linux.vnet.ibm.com>
Date: Thu, 23 Oct 2014 09:33:52 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, peterz@infradead.org,
        mingo@kernel.org
CC: linux-kernel@vger.kernel.org, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, riel@redhat.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com,
        bsegall@google.com, vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org
Subject: Re: [PATCH RFC 6/7] sched: cfs: cpu frequency scaling based on task
 placement
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org> <1413958051-7103-7-git-send-email-mturquette@linaro.org>
In-Reply-To: <1413958051-7103-7-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102304-0033-0000-0000-000000CDE316
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 10/22/2014 11:37 AM, Mike Turquette wrote:
> {en,de}queue_task_fair are updated to track which cpus will have changed
> utilization values as function of task queueing. The affected cpus are
> passed on to arch_eval_cpu_freq for further machine-specific processing
> based on a selectable policy.
> 
> arch_scale_cpu_freq is called from run_rebalance_domains as a way to
> kick off the scaling process (via wake_up_process), so as to prevent
> re-entering the {en,de}queue code.
> 
> All of the call sites in this patch are up for discussion. Does it make
> sense to track which cpus have updated statistics in enqueue_fair_task?
> I chose this because I wanted to gather statistics for all cpus affected
> in the event CONFIG_FAIR_GROUP_SCHED is enabled. As agreed at LPC14 the

Can you explain how pstate selection can get affected by the presence of
task groups? We are after all concerned with the cpu load. So when we
enqueue/dequeue a task, we update the cpu load and pass it on for cpu
pstate scaling. How does this change if we have task groups?
I know that this issue was brought up during LPC, but I have yet not
managed to gain clarity here.

> next version of this patch will focus on the simpler case of not using
> scheduler cgroups, which should remove a good chunk of this code,
> including the cpumask stuff.
> 
> Also discussed at LPC14 is that fact that load_balance is a very
> interesting place to do this as frequency can be considered in concert
> with task placement. Please put forth any ideas on a sensible way to do
> this.
> 
> Is run_rebalance_domains a logical place to change cpu frequency? What
> other call sites make sense?
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

All the cfs_rqs that you iterate through here will belong to the same
rq/cpu right?

Regards
Preeti U Murthy

