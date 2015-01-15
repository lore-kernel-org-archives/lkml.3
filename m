Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbbAOLX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:23:56 -0500
Received: from mail3.unitn.it ([193.205.206.24]:59873 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbbAOLXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:23:54 -0500
Message-ID: <54B7A33F.20904@unitn.it>
Date: Thu, 15 Jan 2015 12:23:43 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>
CC: Juri Lelli <juri.lelli@arm.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
References: <20141230002738.6c12db31@utopia>	 <2629881420411885@web9m.yandex.ru>	 <54AAABFB.3060109@unitn.it>	 <1420499241.3361.14.camel@yandex.ru>	 <20150107080155.1d42d123@luca-1225C>	 <1420633741.12772.10.camel@yandex.ru>	 <54B4D2DF.9010308@arm.com>	 <4500351421141200@web2m.yandex.ru> <20150113140436.GI25256@twins.programming.kicks-ass.net> <4632021421239387@web25g.yandex.ru>
In-Reply-To: <4632021421239387@web25g.yandex.ru>
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On 01/14/2015 01:43 PM, Kirill Tkhai wrote:
[...]
>> Say we have a userspace task that evaluates and changes runtime
>> parameters for other tasks (basically what Luca is doing IIRC), and the
>> changes keep resetting the sleep time, the whole guarantee system comes
>> down, rendering the deadline system useless.
>>>>>    If in the future we allow non-privileged users to increase deadline,
>>>>>    we will reflect that in __setparam_dl() too.
>>>>   I'd say it is better to implement the right behavior even for root, so
>>>>   that we will find it right when we'll grant access to non root users
>>>>   too. Also, even if root can do everything, we always try not to break
>>>>   guarantees that come with admission control (root or non root that is).
>>
>> Just so.
>
> How about something like this?
There are some parts of the patch that I do not understand (for example:
if I understand well, if the task is not throttled you set dl_new to 1...
And if it is throttled you change its current runtime and scheduling deadline...
Why?)
Anyway, I tested the patch and I confirm that it fixes the hang I originally
reported.


			Luca
>
>   include/linux/sched/deadline.h |  2 ++
>   kernel/sched/core.c            | 33 +++++++++++++++++++++++++++++----
>   kernel/sched/deadline.c        | 10 +---------
>   kernel/sched/sched.h           |  1 -
>   4 files changed, 32 insertions(+), 14 deletions(-)
> diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
> index 9d303b8..c70a7fc 100644
> --- a/include/linux/sched/deadline.h
> +++ b/include/linux/sched/deadline.h
> @@ -21,4 +21,6 @@ static inline int dl_task(struct task_struct *p)
>   	return dl_prio(p->prio);
>   }
>
> +extern enum hrtimer_restart dl_task_timer(struct hrtimer *timer);
> +
>   #endif /* _SCHED_DEADLINE_H */
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index c0accc0..edf9d91 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1809,6 +1809,8 @@ void __dl_clear_params(struct task_struct *p)
>   {
>   	struct sched_dl_entity *dl_se = &p->dl;
>
> +	dl_se->dl_throttled = 0;
> +	dl_se->dl_yielded = 0;
>   	dl_se->dl_runtime = 0;
>   	dl_se->dl_deadline = 0;
>   	dl_se->dl_period = 0;
> @@ -1840,6 +1842,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
>
>   	RB_CLEAR_NODE(&p->dl.rb_node);
>   	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	p->dl.dl_timer.function = dl_task_timer;
>   	__dl_clear_params(p);
>
>   	INIT_LIST_HEAD(&p->rt.run_list);
> @@ -3250,16 +3253,38 @@ static void
>   __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
>   {
>   	struct sched_dl_entity *dl_se = &p->dl;
> +	struct hrtimer *timer = &dl_se->dl_timer;
> +	struct rq *rq = task_rq(p);
> +	int pending = 0;
> +
> +	if (hrtimer_is_queued(timer)) {
> +		/*
> +		 * Not need smp_rmb() here, synchronization points
> +		 * are rq lock in our caller and in dl_task_timer().
> +		 */
> +		pending = 1;
> +	} else if (hrtimer_callback_running(timer)) {
> +		smp_rmb(); /* Pairs with rq lock in timer handler */
> +
> +		/* Has the timer handler already finished? */
> +		if (dl_se->dl_throttled)
> +			pending = 1; /* No */
> +	}
> +
> +	if (!pending) {
> +		BUG_ON(dl_se->dl_throttled);
> +		dl_se->dl_new = 1;
> +	} else {
> +		dl_se->deadline = rq_clock(rq) + attr->sched_deadline;
> +		dl_se->runtime = attr->sched_runtime;
> +	}
>
> -	init_dl_task_timer(dl_se);
> +	dl_se->dl_yielded = 0;
>   	dl_se->dl_runtime = attr->sched_runtime;
>   	dl_se->dl_deadline = attr->sched_deadline;
>   	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
>   	dl_se->flags = attr->sched_flags;
>   	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
> -	dl_se->dl_throttled = 0;
> -	dl_se->dl_new = 1;
> -	dl_se->dl_yielded = 0;
>   }
>
>   /*
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index b52092f..b457ca7 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -500,7 +500,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
>    * updating (and the queueing back to dl_rq) will be done by the
>    * next call to enqueue_task_dl().
>    */
> -static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
> +enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>   {
>   	struct sched_dl_entity *dl_se = container_of(timer,
>   						     struct sched_dl_entity,
> @@ -559,14 +559,6 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>   	return HRTIMER_NORESTART;
>   }
>
> -void init_dl_task_timer(struct sched_dl_entity *dl_se)
> -{
> -	struct hrtimer *timer = &dl_se->dl_timer;
> -
> -	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -	timer->function = dl_task_timer;
> -}
> -
>   static
>   int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
>   {
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 9a2a45c..ad3a2f0 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1257,7 +1257,6 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
>
>   extern struct dl_bandwidth def_dl_bandwidth;
>   extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime);
> -extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
>
>   unsigned long to_ratio(u64 period, u64 runtime);
>
>

