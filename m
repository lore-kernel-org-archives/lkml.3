Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaBLG0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 01:26:38 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56674 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBLG0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 01:26:36 -0500
Message-ID: <52FB1411.1040305@linux.vnet.ibm.com>
Date: Wed, 12 Feb 2014 14:26:25 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Push down pre_schedule() and idle_balance
 ()
References: <tip-a8k6vvaebtn64nie345kx1je@git.kernel.org>
In-Reply-To: <tip-a8k6vvaebtn64nie345kx1je@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021206-3568-0000-0000-000004EDF6CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

On 02/11/2014 08:17 PM, tip-bot for Peter Zijlstra wrote:
[snip]
> +
> +idle:
> +#ifdef CONFIG_SMP
> +	idle_enter_fair(rq);
> +	/*
> +	 * We must set idle_stamp _before_ calling idle_balance(), such that we
> +	 * measure the duration of idle_balance() as idle time.
> +	 */
> +	rq->idle_stamp = rq_clock(rq);
> +	if (idle_balance(rq)) { /* drops rq->lock */

Since idle_balance() will release the rq lock, will it happen that some
rt or dl tasks was waken up and enqueued before it hold the lock again?

Should we recheck 'rq->nr_running == rq->cfs.h_nr_running' here before
goto pick fair entity to make sure the priority?

May be like:

if (idle_balance(rq) &&
	rq->nr_running == rq->cfs.h_nr_running)

Regards,
Michael Wang

> +		rq->idle_stamp = 0;
> +		goto again;
> +	}
> +#endif
> +
> +	return NULL;
>  }
> 
>  /*
> diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
> index 721371b..f7d03af 100644
> --- a/kernel/sched/idle_task.c
> +++ b/kernel/sched/idle_task.c
> @@ -13,13 +13,8 @@ select_task_rq_idle(struct task_struct *p, int cpu, int sd_flag, int flags)
>  {
>  	return task_cpu(p); /* IDLE tasks as never migrated */
>  }
> -
> -static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
> -{
> -	idle_exit_fair(rq);
> -	rq_last_tick_reset(rq);
> -}
>  #endif /* CONFIG_SMP */
> +
>  /*
>   * Idle tasks are unconditionally rescheduled:
>   */
> @@ -56,6 +51,10 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
> 
>  static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
>  {
> +#ifdef CONFIG_SMP
> +	idle_exit_fair(rq);
> +	rq_last_tick_reset(rq);
> +#endif
>  }
> 
>  static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
> @@ -99,7 +98,6 @@ const struct sched_class idle_sched_class = {
> 
>  #ifdef CONFIG_SMP
>  	.select_task_rq		= select_task_rq_idle,
> -	.pre_schedule		= pre_schedule_idle,
>  #endif
> 
>  	.set_curr_task          = set_curr_task_idle,
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index a15ca1c..72f9ec7 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -229,6 +229,8 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
> 
>  #ifdef CONFIG_SMP
> 
> +static int pull_rt_task(struct rq *this_rq);
> +
>  static inline int rt_overloaded(struct rq *rq)
>  {
>  	return atomic_read(&rq->rd->rto_count);
> @@ -1330,6 +1332,12 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
>  	struct task_struct *p;
>  	struct rt_rq *rt_rq = &rq->rt;
> 
> +#ifdef CONFIG_SMP
> +	/* Try to pull RT tasks here if we lower this rq's prio */
> +	if (rq->rt.highest_prio.curr > prev->prio)
> +		pull_rt_task(rq);
> +#endif
> +
>  	if (!rt_rq->rt_nr_running)
>  		return NULL;
> 
> @@ -1721,13 +1729,6 @@ skip:
>  	return ret;
>  }
> 
> -static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
> -{
> -	/* Try to pull RT tasks here if we lower this rq's prio */
> -	if (rq->rt.highest_prio.curr > prev->prio)
> -		pull_rt_task(rq);
> -}
> -
>  static void post_schedule_rt(struct rq *rq)
>  {
>  	push_rt_tasks(rq);
> @@ -2004,7 +2005,6 @@ const struct sched_class rt_sched_class = {
>  	.set_cpus_allowed       = set_cpus_allowed_rt,
>  	.rq_online              = rq_online_rt,
>  	.rq_offline             = rq_offline_rt,
> -	.pre_schedule		= pre_schedule_rt,
>  	.post_schedule		= post_schedule_rt,
>  	.task_woken		= task_woken_rt,
>  	.switched_from		= switched_from_rt,
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index c534cf4..1bf34c2 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1118,7 +1118,6 @@ struct sched_class {
>  	int  (*select_task_rq)(struct task_struct *p, int task_cpu, int sd_flag, int flags);
>  	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
> 
> -	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
>  	void (*post_schedule) (struct rq *this_rq);
>  	void (*task_waking) (struct task_struct *task);
>  	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

