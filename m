Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3FJBx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 21:53:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10229 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3FJBxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 21:53:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,833,1363104000"; 
   d="scan'208";a="7511146"
Message-ID: <51B5310C.90606@cn.fujitsu.com>
Date: Mon, 10 Jun 2013 09:51:08 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-4-git-send-email-alex.shi@intel.com>
In-Reply-To: <1370589652-24549-4-git-send-email-alex.shi@intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 09:52:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 09:52:05,
	Serialize complete at 2013/06/10 09:52:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 03:20 PM, Alex Shi wrote:

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
> Further more, Morten Rasmussen notice some tasks were not launched at
> once after created. So Paul and Peter suggest giving a start value for
> new task runnable avg time same as sched_slice().
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>


Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
>  kernel/sched/core.c  |  6 ++----
>  kernel/sched/fair.c  | 23 +++++++++++++++++++++++
>  kernel/sched/sched.h |  2 ++
>  3 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b9e7036..6f226c2 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1598,10 +1598,6 @@ static void __sched_fork(struct task_struct *p)
>  	p->se.vruntime			= 0;
>  	INIT_LIST_HEAD(&p->se.group_node);
>  
> -#ifdef CONFIG_SMP
> -	p->se.avg.runnable_avg_period = 0;
> -	p->se.avg.runnable_avg_sum = 0;
> -#endif
>  #ifdef CONFIG_SCHEDSTATS
>  	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
>  #endif
> @@ -1745,6 +1741,8 @@ void wake_up_new_task(struct task_struct *p)
>  	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
>  #endif
>  
> +	/* Give new task start runnable values */
> +	set_task_runnable_avg(p);
>  	rq = __task_rq_lock(p);
>  	activate_task(rq, p, 0);
>  	p->on_rq = 1;
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f404468..1fc30b9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -680,6 +680,26 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  	return calc_delta_fair(sched_slice(cfs_rq, se), se);
>  }
>  
> +#ifdef CONFIG_SMP
> +static inline void __update_task_entity_contrib(struct sched_entity *se);
> +
> +/* Give new task start runnable values to heavy its load in infant time */
> +void set_task_runnable_avg(struct task_struct *p)
> +{
> +	u32 slice;
> +
> +	p->se.avg.decay_count = 0;
> +	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
> +	p->se.avg.runnable_avg_sum = slice;
> +	p->se.avg.runnable_avg_period = slice;
> +	__update_task_entity_contrib(&p->se);
> +}
> +#else
> +void set_task_runnable_avg(struct task_struct *p)
> +{
> +}
> +#endif
> +
>  /*
>   * Update the current task's runtime statistics. Skip current tasks that
>   * are not in our scheduling class.
> @@ -1527,6 +1547,9 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>  	 * We track migrations using entity decay_count <= 0, on a wake-up
>  	 * migration we use a negative decay count to track the remote decays
>  	 * accumulated while sleeping.
> +	 *
> +	 * When enqueue a new forked task, the se->avg.decay_count == 0, so
> +	 * we bypass update_entity_load_avg(), use avg.load_avg_contrib direct.
>  	 */
>  	if (unlikely(se->avg.decay_count <= 0)) {
>  		se->avg.last_runnable_update = rq_clock_task(rq_of(cfs_rq));
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 24b1503..8bc66c6 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1058,6 +1058,8 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
>  
>  extern void update_idle_cpu_load(struct rq *this_rq);
>  
> +extern void set_task_runnable_avg(struct task_struct *p);
> +
>  #ifdef CONFIG_PARAVIRT
>  static inline u64 steal_ticks(u64 steal)
>  {


