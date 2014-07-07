Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaGGWZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:25:13 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61921 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaGGWZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:25:09 -0400
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuyang Du <yuyang.du@intel.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average tracking
In-Reply-To: <20140707104646.GK6758@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Mon, 7 Jul 2014 12:46:46 +0200")
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
	<1404268256-3019-2-git-send-email-yuyang.du@intel.com>
	<20140707104646.GK6758@twins.programming.kicks-ass.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Mon, 07 Jul 2014 15:25:07 -0700
Message-ID: <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Jul 02, 2014 at 10:30:56AM +0800, Yuyang Du wrote:
>> The idea of per entity runnable load average (aggregated to cfs_rq and task_group load)
>> was proposed by Paul Turner, and it is still followed by this rewrite. But this rewrite
>> is made due to the following ends:
>> 
>> (1). cfs_rq's load average (namely runnable_load_avg and blocked_load_avg) is updated
>> incrementally by one entity at one time, which means the cfs_rq load average is only
>> partially updated or asynchronous accross its entities (the entity in question is up
>> to date and contributes to the cfs_rq, but all other entities are effectively lagging
>> behind).
>> 
>> (2). cfs_rq load average is different between top rq->cfs_rq and task_group's per CPU
>> cfs_rqs in whether or not blocked_load_average contributes to the load.
>
> ISTR there was a reason for it; can't remember though, maybe pjt/ben can
> remember.

I'm not sure exactly which usages are being talked about here, but we
used runnanble+blocked for tg_load_contrib because that's the number
which has any actual meaning. The stuff (h_load, weighted_cpuload, etc)
that uses runnable_load_avg by itself is all morally wrong, but iirc
when the patches came up making them use runnable+blocked always was
worse on the quoted benchmarks.


>
>> (3). How task_group's load is tracked is very confusing and complex.
>> 
>> Therefore, this rewrite tackles these by:
>> 
>> (1). Combine runnable and blocked load averages for cfs_rq. And track cfs_rq's load average
>> as a whole (contributed by all runnabled and blocked entities on this cfs_rq).
>> 
>> (2). Only track task load average. Do not track task_group's per CPU entity average, but
>> track that entity's own cfs_rq's aggregated average.
>> 
>> This rewrite resutls in significantly reduced codes and expected consistency and clarity.
>> Also, if draw the lines of previous cfs_rq runnable_load_avg and blocked_load_avg and the
>> new rewritten load_avg, then compare those lines, you can see the new load_avg is much
>> more continuous (no abrupt jumping ups and downs) and decayed/updated more quickly and
>> synchronously.
>
> OK, maybe seeing what you're doing. I worry about a fwe things though:
>
>> +static inline void synchronize_tg_load_avg(struct cfs_rq *cfs_rq, u32 old)
>>  {
>> +       s32 delta = cfs_rq->avg.load_avg - old;
>>  
>> +       if (delta)
>> +               atomic_long_add(delta, &cfs_rq->tg->load_avg);
>>  }
>
> That tg->load_avg cacheline is already red hot glowing, and you've just
> increased the amount of updates to it.. That's not going to be
> pleasant.

Yeah, while this is technically limited to 1/us (per cpu), it is still
much higher - the replaced code would do updates generally only on
period overflow (1ms) and even then only with nontrivial delta.

Also something to note is that cfs_rq->load_avg just takes samples of
load.weight every 1us, which seems unfortunate. We thought this was ok
for p->se.load.weight, because it isn't really likely for userspace to
be calling nice(2) all the time, but wake/sleeps are more frequent,
particularly on newer cpus. Still, it might not be /that/ bad.

>
>
>> +static inline void enqueue_entity_load_avg(struct sched_entity *se)
>>  {
>> +	struct sched_avg *sa = &se->avg;
>> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
>> +	u64 now = cfs_rq_clock_task(cfs_rq);
>> +	u32 old_load_avg = cfs_rq->avg.load_avg;
>> +	int migrated = 0;
>>  
>> +	if (entity_is_task(se)) {
>> +		if (sa->last_update_time == 0) {
>> +			sa->last_update_time = now;
>> +			migrated = 1;
>>  		}
>> +		else
>> +			__update_load_avg(now, sa, se->on_rq * se->load.weight);
>>  	}
>>  
>> +	__update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
>>  
>> +	if (migrated)
>> +		cfs_rq->avg.load_avg += sa->load_avg;
>>  
>> +	synchronize_tg_load_avg(cfs_rq, old_load_avg);
>>  }
>
> So here you add the task to the cfs_rq avg when its got migrate in,
> however:
>
>> @@ -4552,17 +4326,9 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>>  	struct sched_entity *se = &p->se;
>>  	struct cfs_rq *cfs_rq = cfs_rq_of(se);
>>  
>> +	/* Update task on old CPU, then ready to go (entity must be off the queue) */
>> +	__update_load_avg(cfs_rq_clock_task(cfs_rq), &se->avg, 0);
>> +	se->avg.last_update_time = 0;
>>  
>>  	/* We have migrated, no longer consider this task hot */
>>  	se->exec_start = 0;
>
> there you don't remove it first..

Yeah, the issue is that you can't remove it, because you don't hold the
lock. Thus the whole runnable/blocked split iirc. Also the
cfs_rq_clock_task read is incorrect for the same reason (and while
rq_clock_task could certainly be fixed min_vruntime-style,
cfs_rq_clock_task would be harder).

The problem with just working around the clock issue somehow and then using an
atomic to do this subtraction is that you have no idea when the /cfs_rq/
last updated - there's no guarantee it is up to date, and if it's not
then the subtraction is wrong. You can't update it to make it up to date
like the se->avg, becasue you don't hold any locks. You would need
decay_counter stuff like the current code, and I'm not certain how well
that would work out without the runnable/blocked split.

Other issues:
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 306f4f0..7abdd13 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1069,14 +1069,11 @@ struct load_weight {
>  
>  struct sched_avg {
>  	/*
> -	 * These sums represent an infinite geometric series and so are bound
> -	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
> -	 * choices of y < 1-2^(-32)*1024.
> +	 * The load_avg represents an infinite geometric series.
>  	 */
> -	u32 runnable_avg_sum, runnable_avg_period;
> -	u64 last_runnable_update;
> -	s64 decay_count;
> -	unsigned long load_avg_contrib;
> +	u32 load_avg;

As the patch notes later, this absolutely cannot be u32, this needs to be
unsigned long, as with any weight variable. Actually, it's worse, I
think this is up to LOAD_AVG_MAX * weight, and thus probably needs to
just be u64 even on 32 bit, since having only 16 bits of
cfs_rq->load.weight is not a great plan. While this is mostly
u32*u32=>u64 multiplies, calc_cfs_shares would be a u64/u64 per cfs_rq
on every enqueue/dequeue.

Also, as a nitpick/annoyance this does a lot of
 if (entity_is_task(se)) __update_load_avg(... se ...)
 __update_load_avg(... cfs_rq_of(se) ...)
which is just a waste of the avg struct on every group se, and all it
buys you is the ability to not have a separate rq->avg struct (removed
by patch 1) instead of rq->cfs.avg.

