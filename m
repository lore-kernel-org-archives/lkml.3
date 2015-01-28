Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbbA1VRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:17:20 -0500
Received: from mail3.unitn.it ([193.205.206.24]:49878 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758949AbbA1Uub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:31 -0500
Message-ID: <54C8F4F5.1070803@unitn.it>
Date: Wed, 28 Jan 2015 15:40:53 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>, Juri Lelli <juri.lelli@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
References: <1420499241.3361.14.camel@yandex.ru> <20150107080155.1d42d123@luca-1225C> <1420633741.12772.10.camel@yandex.ru> <54B4D2DF.9010308@arm.com> <4500351421141200@web2m.yandex.ru> <20150113140436.GI25256@twins.programming.kicks-ass.net> <4632021421239387@web25g.yandex.ru> <54B7A33F.20904@unitn.it> <20150115122323.GU23965@worktop.programming.kicks-ass.net> <54B7C232.8060806@unitn.it> <20150128140803.GF23038@twins.programming.kicks-ass.net>
In-Reply-To: <20150128140803.GF23038@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 01/28/2015 03:08 PM, Peter Zijlstra wrote:
> On Thu, Jan 15, 2015 at 02:35:46PM +0100, Luca Abeni wrote:
>
>>> >From what I understand we should either modify the tasks run/sleep stats
>>> when we change its parameters or we should schedule a delayed release of
>>> the bandwidth delta (when it reaches its 0-lag point, if thats in the
>>> future).
>
>> I suspect the correct behaviour can be difficult to implement:
>> - When a SCHED_DEADLINE task ends (or changes its scheduling policy to
>>    something different), its bandwidth cannot be released immediately,
>>    but should be released at the "0-lag time" (which reminds me about the
>>    GRUB patches... I had to implement a similar behaviour in those patches :)
>> - The same applies when the task changes its scheduling parameters decreasing
>>    its bandwidth. In this case, we also need to update the current runtime (if
>>    it is larger than the new runtime, set it to the new maximum value - I think
>>    this is the safest thing to do)
>> - When a task changes its parameters to increase its bandwidth, be do not
>>    have such problems.
>>
>> As far as I can see, if we apply the runtime / deadline changes starting from
>> the next reservation period we are safe (because the "0-lag time" is always
>> smaller than the current scheduling deadline).
>> This might cause some transient overloads (because if I change the parameters
>> of a task at time t, the update takes action a little bit later - at the next
>> scheduling deadline), but guarantees that a task never consumes more than
>> expected (for example: if a task continuously changes its bandwidth between
>> 0.4 and 0.3, it will never consume more than 0.4. I suspect that if we
>> immediately update dl_se->deadline and dl_se->runtime a task can arrive to
>> consume much more CPU time).
>
>
> OK, how about something like this; it seems to survive your Bug-Test for
> at least 50 cycles.
Thanks; tomorrow I'll test this patch and I'll let you know how it works in
my setup (but looking at it I am pretty sure it will solve my issue).


			Thanks,
				Luca

>
> ---
>   kernel/sched/core.c     | 33 ++++++++++++++++++++++++++++-----
>   kernel/sched/deadline.c |  3 ++-
>   2 files changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ade2958a9197..d787d6553d72 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1816,6 +1816,10 @@ void __dl_clear_params(struct task_struct *p)
>   	dl_se->dl_period = 0;
>   	dl_se->flags = 0;
>   	dl_se->dl_bw = 0;
> +
> +	dl_se->dl_throttled = 0;
> +	dl_se->dl_new = 1;
> +	dl_se->dl_yielded = 0;
>   }
>
>   /*
> @@ -1844,7 +1848,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
>   #endif
>
>   	RB_CLEAR_NODE(&p->dl.rb_node);
> -	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	init_dl_task_timer(&p->dl);
>   	__dl_clear_params(p);
>
>   	INIT_LIST_HEAD(&p->rt.run_list);
> @@ -2054,6 +2058,9 @@ static inline int dl_bw_cpus(int i)
>    * allocated bandwidth to reflect the new situation.
>    *
>    * This function is called while holding p's rq->lock.
> + *
> + * XXX we should delay bw change until the task's 0-lag point, see
> + * __setparam_dl().
>    */
>   static int dl_overflow(struct task_struct *p, int policy,
>   		       const struct sched_attr *attr)
> @@ -3258,15 +3265,31 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
>   {
>   	struct sched_dl_entity *dl_se = &p->dl;
>
> -	init_dl_task_timer(dl_se);
>   	dl_se->dl_runtime = attr->sched_runtime;
>   	dl_se->dl_deadline = attr->sched_deadline;
>   	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
>   	dl_se->flags = attr->sched_flags;
>   	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
> -	dl_se->dl_throttled = 0;
> -	dl_se->dl_new = 1;
> -	dl_se->dl_yielded = 0;
> +
> +	/*
> +	 * Changing the parameters of a task is 'tricky' and we're not doing
> +	 * the correct thing -- also see task_dead_dl() and switched_from_dl().
> +	 *
> +	 * What we SHOULD do is delay the bandwidth release until the 0-lag
> +	 * point. This would include retaining the task_struct until that time
> +	 * and change dl_overflow() to not immediately decrement the current
> +	 * amount.
> +	 *
> +	 * Instead we retain the current runtime/deadline and let the new
> +	 * parameters take effect after the current reservation period lapses.
> +	 * This is safe (albeit pessimistic) because the 0-lag point is always
> +	 * before the current scheduling deadline.
> +	 *
> +	 * We can still have temporary overloads because we do not delay the
> +	 * change in bandwidth until that time; so admission control is
> +	 * not on the safe side. It does however guarantee tasks will never
> +	 * consume more than promised.
> +	 */
>   }
>
>   /*
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index b52092f2636d..726470d47f87 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1094,6 +1094,7 @@ static void task_dead_dl(struct task_struct *p)
>   	 * Since we are TASK_DEAD we won't slip out of the domain!
>   	 */
>   	raw_spin_lock_irq(&dl_b->lock);
> +	/* XXX we should retain the bw until 0-lag */
>   	dl_b->total_bw -= p->dl.dl_bw;
>   	raw_spin_unlock_irq(&dl_b->lock);
>
> @@ -1614,8 +1615,8 @@ static void cancel_dl_timer(struct rq *rq, struct task_struct *p)
>
>   static void switched_from_dl(struct rq *rq, struct task_struct *p)
>   {
> +	/* XXX we should retain the bw until 0-lag */
>   	cancel_dl_timer(rq, p);
> -
>   	__dl_clear_params(p);
>
>   	/*
>

