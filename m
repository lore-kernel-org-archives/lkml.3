Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3FSIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:16:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:14002 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab3FSIQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:16:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="319298137"
Message-ID: <51C168BA.8090403@intel.com>
Date: Wed, 19 Jun 2013 16:15:54 +0800
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
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-7-git-send-email-alex.shi@intel.com> <CAPM31RKwNUh+nNcsEftD4pyP+gdwXhRK7wCRNWa8Y0sE0hf-DQ@mail.gmail.com> <CAPM31R+DBFt1wr10GCGEHDW_J_-79imdTCYEBF7YiKdFc1V7iQ@mail.gmail.com> <51BF15C4.1090906@intel.com> <CAPM31RKHtEYsNV+kzxFpH=55dLaFn1jcQcWD4qYAdHrW_xN+8A@mail.gmail.com> <51BFD787.5020708@intel.com> <51C02C03.8090501@intel.com>
In-Reply-To: <51C02C03.8090501@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 05:44 PM, Alex Shi wrote:
> 
>>
>> Paul, could I summary your point here:
>> keep current weighted_cpu_load, but add blocked load avg in
>> get_rq_runnable_load?
>>
>> I will test this change.
> 
> Current testing(kbuild, oltp, aim7) don't show clear different on my NHM EP box
> between the following and the origin patch, 
> the only different is get_rq_runnable_load added blocked_load_avg. in SMP
> will test more cases and more box.

I tested the tip/sched/core, tip/sched/core with old patchset and
tip/schec/core with the blocked_load_avg on Core2 2S, NHM EP, IVB EP,
SNB EP 2S and SNB EP 4S box, with benchmark kbuild, sysbench oltp,
hackbench, tbench, dbench.

blocked_load_avg VS origin patchset, oltp has suspicious 5% and
hackbench has 3% drop on NHM EX; dbench has suspicious 6% drop on NHM
EP. other benchmarks has no clear change on all other machines.

origin patchset VS sched/core, hackbench rise 20% on NHM EX, 60% on SNB
EP 4S, and 30% on IVB EP. others no clear changes.

> 
> ---
>  kernel/sched/fair.c |  5 +++--
>  kernel/sched/proc.c | 17 +++++++++++++++--
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1e5a5e6..7d5c477 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2968,7 +2968,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  /* Used instead of source_load when we know the type == 0 */
>  static unsigned long weighted_cpuload(const int cpu)
>  {
> -	return cpu_rq(cpu)->load.weight;
> +	return cpu_rq(cpu)->cfs.runnable_load_avg;
>  }
>  
>  /*
> @@ -3013,9 +3013,10 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
>  	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
> +	unsigned long load_avg = rq->cfs.runnable_load_avg;
>  
>  	if (nr_running)
> -		return rq->load.weight / nr_running;
> +		return load_avg / nr_running;
>  
>  	return 0;
>  }
> diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
> index bb3a6a0..36d7db6 100644
> --- a/kernel/sched/proc.c
> +++ b/kernel/sched/proc.c
> @@ -501,6 +501,18 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  	sched_avg_update(this_rq);
>  }
>  
> +#ifdef CONFIG_SMP
> +unsigned long get_rq_runnable_load(struct rq *rq)
> +{
> +	return rq->cfs.runnable_load_avg + rq->cfs.blocked_load_avg;
> +}
> +#else
> +unsigned long get_rq_runnable_load(struct rq *rq)
> +{
> +	return rq->load.weight;
> +}
> +#endif
> +
>  #ifdef CONFIG_NO_HZ_COMMON
>  /*
>   * There is no sane way to deal with nohz on smp when using jiffies because the
> @@ -522,7 +534,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  void update_idle_cpu_load(struct rq *this_rq)
>  {
>  	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> -	unsigned long load = this_rq->load.weight;
> +	unsigned long load = get_rq_runnable_load(this_rq);
>  	unsigned long pending_updates;
>  
>  	/*
> @@ -568,11 +580,12 @@ void update_cpu_load_nohz(void)
>   */
>  void update_cpu_load_active(struct rq *this_rq)
>  {
> +	unsigned long load = get_rq_runnable_load(this_rq);
>  	/*
>  	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>  	 */
>  	this_rq->last_load_update_tick = jiffies;
> -	__update_cpu_load(this_rq, this_rq->load.weight, 1);
> +	__update_cpu_load(this_rq, load, 1);
>  
>  	calc_load_account_active(this_rq);
>  }
> 


-- 
Thanks
    Alex
