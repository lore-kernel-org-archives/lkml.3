Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaIURb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:31:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47920 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaIURbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:31:25 -0400
Date: Sun, 21 Sep 2014 19:31:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: klamm@yandex-team.ru
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        stfomichev@yandex-team.ru
Subject: Re: [PATCH 06/19] smart: use CPU selection logic if smart is enabled
Message-ID: <20140921173114.GA11414@xo-6d-61-c0.localdomain>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
 <1409848265-17150-6-git-send-email-klamm@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409848265-17150-6-git-send-email-klamm@yandex-team.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-09-04 20:30:52, klamm@yandex-team.ru wrote:
> From: Roman Gushchin <klamm@yandex-team.ru>
> 
> This patch causes rt scheduler to use smart CPU selection logic,
> if smart_enabled() returns true.

SMART is a technology to report HDD health, so while it is cool name, it might
be better to use different name to avoid confusion.

									Pavel

> @@ -1262,8 +1262,12 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
>  	 *   not worry about this generic constraint ]
>  	 */
>  	if (unlikely(!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)) ||
> -		     !cpu_online(cpu)))
> +		     !cpu_online(cpu))) {
> +		if (smart_enabled() && task_has_rt_policy(p) && cpu >= 0)
> +			release_core(cpu);
> +
>  		cpu = select_fallback_rq(task_cpu(p), p);
> +	}
>  
>  	return cpu;
>  }
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 805951b..1993c47 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -15,6 +15,14 @@ struct static_key __smart_enabled = STATIC_KEY_INIT_TRUE;
>  DEFINE_MUTEX(smart_mutex);
>  
>  DEFINE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
> +
> +static int smart_find_lowest_rq(struct task_struct *task, bool wakeup);
> +
> +#else /* CONFIG_SMART */
> +static inline int smart_find_lowest_rq(struct task_struct *task, bool wakeup)
> +{
> +	return -1;
> +}
>  #endif /* CONFIG_SMART */
>  
>  int sched_rr_timeslice = RR_TIMESLICE;
> @@ -1211,6 +1219,7 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
>  		enqueue_pushable_task(rq, p);
>  
>  	inc_nr_running(rq);
> +	release_core(cpu_of(rq));
>  }
>  
>  static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
> @@ -1278,6 +1287,13 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
>  	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
>  		goto out;
>  
> +	if (smart_enabled()) {
> +		int target = smart_find_lowest_rq(p, true);
> +		if (likely(target != -1))
> +			cpu = target;
> +		goto out;
> +	}
> +
>  	rq = cpu_rq(cpu);
>  
>  	rcu_read_lock();
> @@ -1580,10 +1596,17 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
>  	int cpu;
>  
>  	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
> -		cpu = find_lowest_rq(task);
> +		if (smart_enabled())
> +			cpu = smart_find_lowest_rq(task, false);
> +		else
> +			cpu = find_lowest_rq(task);
> +
> +		if ((cpu == -1) || (cpu == rq->cpu)) {
> +			if (cpu == rq->cpu)
> +				release_core(cpu);
>  
> -		if ((cpu == -1) || (cpu == rq->cpu))
>  			break;
> +		}
>  
>  		lowest_rq = cpu_rq(cpu);
>  
> @@ -1602,6 +1625,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
>  				     !task->on_rq)) {
>  
>  				double_unlock_balance(rq, lowest_rq);
> +				release_core(cpu);
>  				lowest_rq = NULL;
>  				break;
>  			}
> @@ -1614,6 +1638,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
>  		/* try again */
>  		double_unlock_balance(rq, lowest_rq);
>  		lowest_rq = NULL;
> +		release_core(cpu);
>  	}
>  
>  	return lowest_rq;
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
