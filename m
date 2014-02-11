Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaBKPdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:33:44 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34878 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBKPdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:33:43 -0500
Message-ID: <52FA42D4.9050401@linaro.org>
Date: Tue, 11 Feb 2014 16:33:40 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/fair: Remove idle_balance() declaration in sched.h
References: <1392130864-4416-1-git-send-email-daniel.lezcano@linaro.org> <20140211151148.GP27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140211151148.GP27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 04:11 PM, Peter Zijlstra wrote:
> On Tue, Feb 11, 2014 at 04:01:04PM +0100, Daniel Lezcano wrote:
>> The idle_balance() function is called within a #ifdef CONFIG_SMP section.
>>
>> Remove its declaration in sched.h for !CONFIG_SMP because it is pointless.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> The below again makes a horrible mess of idle_balance() -- which you
> tried to clean up.. but it does rid us of some #ifdef goo.
>
> Hmmm?

Yes, it sounds ok.

Why is idle_enter_fair() called unconditionally in idle_balance() ?
Isn't the call in pick_next_task_idle enough ?  Shouldn't be called when 
we will go to idle effectively ?

If I am not wrong idle_enter_fair() is called from idle_balance() but a 
task may be pulled, so we the next task won't be the idle task and 
idle_exit_fair won't be called at put_prev_task.

May be I missed this change which was done at purpose in the previous 
patchset you sent...


> ---
>   kernel/sched/fair.c  | 47 +++++++++++++++++++++++++++++------------------
>   kernel/sched/sched.h |  7 -------
>   2 files changed, 29 insertions(+), 25 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 235cfa7ad8fc..d168c968195b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2374,13 +2374,13 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
>   		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
>   	}
>   }
> -#else
> +#else /* CONFIG_FAIR_GROUP_SCHED */
>   static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>   						 int force_update) {}
>   static inline void __update_tg_runnable_avg(struct sched_avg *sa,
>   						  struct cfs_rq *cfs_rq) {}
>   static inline void __update_group_entity_contrib(struct sched_entity *se) {}
> -#endif
> +#endif /* CONFIG_FAIR_GROUP_SCHED */
>
>   static inline void __update_task_entity_contrib(struct sched_entity *se)
>   {
> @@ -2571,6 +2571,8 @@ void idle_exit_fair(struct rq *this_rq)
>   	update_rq_runnable_avg(this_rq, 0);
>   }
>
> +static int idle_balance(struct rq *this_rq);
> +
>   #else /* CONFIG_SMP */
>
>   static inline void update_entity_load_avg(struct sched_entity *se,
> @@ -2584,6 +2586,12 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
>   					   int sleep) {}
>   static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
>   					      int force_update) {}
> +
> +static inline int idle_balance(struct rq *rq)
> +{
> +	return 0;
> +}
> +
>   #endif /* CONFIG_SMP */
>
>   static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
> @@ -4677,7 +4685,7 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>   	struct sched_entity *se;
>   	struct task_struct *p;
>
> -again: __maybe_unused
> +again:
>   #ifdef CONFIG_FAIR_GROUP_SCHED
>   	if (!cfs_rq->nr_running)
>   		goto idle;
> @@ -4775,18 +4783,8 @@ again: __maybe_unused
>   	return p;
>
>   idle:
> -#ifdef CONFIG_SMP
> -	idle_enter_fair(rq);
> -	/*
> -	 * We must set idle_stamp _before_ calling idle_balance(), such that we
> -	 * measure the duration of idle_balance() as idle time.
> -	 */
> -	rq->idle_stamp = rq_clock(rq);
> -	if (idle_balance(rq)) { /* drops rq->lock */
> -		rq->idle_stamp = 0;
> +	if (idle_balance(rq)) /* drops rq->lock */
>   		goto again;
> -	}
> -#endif
>
>   	return NULL;
>   }
> @@ -6634,7 +6632,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>    * idle_balance is called by schedule() if this_cpu is about to become
>    * idle. Attempts to pull tasks from other CPUs.
>    */
> -int idle_balance(struct rq *this_rq)
> +static int idle_balance(struct rq *this_rq)
>   {
>   	struct sched_domain *sd;
>   	int pulled_task = 0;
> @@ -6642,8 +6640,15 @@ int idle_balance(struct rq *this_rq)
>   	u64 curr_cost = 0;
>   	int this_cpu = this_rq->cpu;
>
> +	idle_enter_fair(this_rq);
> +	/*
> +	 * We must set idle_stamp _before_ calling idle_balance(), such that we
> +	 * measure the duration of idle_balance() as idle time.
> +	 */
> +	this_rq->idle_stamp = rq_clock(this_rq);
> +
>   	if (this_rq->avg_idle < sysctl_sched_migration_cost)
> -		return 0;
> +		goto out;
>
>   	/*
>   	 * Drop the rq->lock, but keep IRQ/preempt disabled.
> @@ -6692,8 +6697,10 @@ int idle_balance(struct rq *this_rq)
>   	 * While browsing the domains, we released the rq lock.
>   	 * A task could have be enqueued in the meantime
>   	 */
> -	if (this_rq->nr_running && !pulled_task)
> -		return 1;
> +	if (this_rq->nr_running && !pulled_task) {
> +		pulled_task = 1;
> +		goto out;
> +	}
>
>   	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
>   		/*
> @@ -6706,6 +6713,10 @@ int idle_balance(struct rq *this_rq)
>   	if (curr_cost > this_rq->max_idle_balance_cost)
>   		this_rq->max_idle_balance_cost = curr_cost;
>
> +out:
> +	if (pulled_task)
> +		this_rq->idle_stamp = 0;
> +
>   	return pulled_task;
>   }
>
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 1bf34c257d3b..92018f9821e8 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1163,17 +1163,10 @@ extern const struct sched_class idle_sched_class;
>   extern void update_group_power(struct sched_domain *sd, int cpu);
>
>   extern void trigger_load_balance(struct rq *rq);
> -extern int idle_balance(struct rq *this_rq);
>
>   extern void idle_enter_fair(struct rq *this_rq);
>   extern void idle_exit_fair(struct rq *this_rq);
>
> -#else	/* CONFIG_SMP */
> -
> -static inline void idle_balance(int cpu, struct rq *rq)
> -{
> -}
> -
>   #endif
>
>   extern void sysrq_sched_debug_show(void);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

