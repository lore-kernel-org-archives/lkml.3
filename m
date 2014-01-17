Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaAQPJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:09:44 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51936 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaAQPJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:09:42 -0500
Message-ID: <52D947B3.3010601@linaro.org>
Date: Fri, 17 Jan 2014 16:09:39 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 4/4] sched: Idle task shortcut optimization
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org> <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org> <20140117140939.GH11314@laptop.programming.kicks-ass.net>
In-Reply-To: <20140117140939.GH11314@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 03:09 PM, Peter Zijlstra wrote:
> On Fri, Jan 17, 2014 at 10:04:04AM +0100, Daniel Lezcano wrote:
>> +	schedstat_inc(rq, sched_goidle);
>> +#ifdef CONFIG_SMP
>> +	/* Trigger the post schedule to do an idle_enter for CFS */
>> +	rq->post_schedule = 1;
>> +#endif
>> +	return rq->idle;
>
> Urgh, that retains the stupid idle crap like it is.
>
> I've not yet tested this, but is there a reason something like the below
> couldn't work?

I tested it by running hackbench and it seems to work as expected.

> ---
> Subject: sched: Clean up idle task SMP logic
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri Jan 17 14:54:02 CET 2014
>
> The idle post_schedule hook is just a vile waste of time, fix it proper.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>   kernel/sched/fair.c      |    5 +++--
>   kernel/sched/idle_task.c |   21 ++++++---------------
>   2 files changed, 9 insertions(+), 17 deletions(-)
>
> Index: linux-2.6/kernel/sched/fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/fair.c
> +++ linux-2.6/kernel/sched/fair.c
> @@ -2416,7 +2416,8 @@ void idle_exit_fair(struct rq *this_rq)
>   	update_rq_runnable_avg(this_rq, 0);
>   }
>
> -#else
> +#else /* CONFIG_SMP */
> +
>   static inline void update_entity_load_avg(struct sched_entity *se,
>   					  int update_cfs_rq) {}
>   static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
> @@ -2428,7 +2429,7 @@ static inline void dequeue_entity_load_a
>   					   int sleep) {}
>   static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
>   					      int force_update) {}
> -#endif
> +#endif /* CONFIG_SMP */
>
>   static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
>   {
> Index: linux-2.6/kernel/sched/idle_task.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/idle_task.c
> +++ linux-2.6/kernel/sched/idle_task.c
> @@ -13,18 +13,8 @@ select_task_rq_idle(struct task_struct *
>   {
>   	return task_cpu(p); /* IDLE tasks as never migrated */
>   }
> -
> -static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
> -{
> -	idle_exit_fair(rq);
> -	rq_last_tick_reset(rq);
> -}
> -
> -static void post_schedule_idle(struct rq *rq)
> -{
> -	idle_enter_fair(rq);
> -}
>   #endif /* CONFIG_SMP */
> +
>   /*
>    * Idle tasks are unconditionally rescheduled:
>    */
> @@ -37,8 +27,7 @@ static struct task_struct *pick_next_tas
>   {
>   	schedstat_inc(rq, sched_goidle);
>   #ifdef CONFIG_SMP
> -	/* Trigger the post schedule to do an idle_enter for CFS */
> -	rq->post_schedule = 1;
> +	idle_enter_fair(rq);
>   #endif
>   	return rq->idle;
>   }
> @@ -58,6 +47,10 @@ dequeue_task_idle(struct rq *rq, struct
>
>   static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
>   {
> +#ifdef CONFIG_SMP
> +	idle_exit_fair(rq);
> +	rq_last_tick_reset(rq);
> +#endif
>   }
>
>   static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
> @@ -101,8 +94,6 @@ const struct sched_class idle_sched_clas
>
>   #ifdef CONFIG_SMP
>   	.select_task_rq		= select_task_rq_idle,
> -	.pre_schedule		= pre_schedule_idle,
> -	.post_schedule		= post_schedule_idle,
>   #endif
>
>   	.set_curr_task          = set_curr_task_idle,
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

