Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbaEPR6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:58:04 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:45338 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbaEPR6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:58:02 -0400
From: bsegall@google.com
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, pjt@google.com,
        chris.j.arges@canonical.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
References: <87mwej0yja.wl%klamm@yandex-team.ru>
	<xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<87lhu215ky.wl%klamm@yandex-team.ru>
Date: Fri, 16 May 2014 10:57:59 -0700
In-Reply-To: <87lhu215ky.wl%klamm@yandex-team.ru> (Roman Gushchin's message of
	"Fri, 16 May 2014 12:38:21 +0400")
Message-ID: <xm264n0p4ndk.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Gushchin <klamm@yandex-team.ru> writes:

> At Thu, 15 May 2014 10:43:14 -0700,
> bsegall@google.com wrote:
>> 
>> Roman Gushchin <klamm@yandex-team.ru> writes:
>> 
>> > tg_set_cfs_bandwidth() sets cfs_b->timer_active to 0 to
>> > force the period timer restart. It's not safe, because
>> > can lead to deadlock, described in commit 927b54fccbf0:
>> > "__start_cfs_bandwidth calls hrtimer_cancel while holding rq->lock,
>> > waiting for the hrtimer to finish. However, if sched_cfs_period_timer
>> > runs for another loop iteration, the hrtimer can attempt to take
>> > rq->lock, resulting in deadlock."
>> > If tg_set_cfs_bandwidth() resets cfs_b->timer_active concurrently
>> > to the second iteration of sched_cfs_period_timer, deadlock occurs.
>> 
>> I do not see this deadlock. cfs_b->timer_active is protected by
>> cfs_b->lock on both read and write, and I don't think it would even
>> directly cause deadlock if it wasn't. In particular this patch makes us
>> run for strictly longer outside of the interrupt (although I think the
>> patched version is also correct). The old issue was calling
>> hrtimer_cancel, which would mean we hold cfs_b->lock while waiting for
>> the interrupt to complete, while the interrupt was waiting to take
>> cfs_b->lock.
>
> I still think, there is a deadlock. I'll try to explain.
> Three CPUs must be involved:
> CPU0				CPU1				CPU2
> take rq->lock			period timer fired		
> ...				take cfs_b lock
> ...				...				tg_set_cfs_bandwidth()
> throttle_cfs_rq()		release cfs_b lock		take cfs_b lock
> ...				distribute_cfs_runtime()	timer_active = 0
> take cfs_b->lock		wait for rq->lock		...
> __start_cfs_bandwidth()	
> {wait for timer callback
>  break if timer_active == 1}
>
> So, CPU0 and CPU1 are deadlocked.

Ahhh, yes, there is a three-cpu race here. Could you clarify the commit
message that this is a race involving all three of tg_set_cfs_bandwidth,
period timer, and then a second __start_cfs_bandwidth call?

The code looks good however.

>> I just did notice however that sched_cfs_period_timer reads
>> cfs_b->period without any locks, which can in fact race with an update
>> to period (and isn't fixed by this patch). If this write doesn't happen
>> to be atomic (which is certainly not guaranteed, and is entirely
>> plausible on say 32-bit x86, much less other archs), we could read a
>> partially written value and move the timer incorrectly. Pulling the
>> lock/unlock out of do_sched_cfs_period_timer should fix this easily
>> enough.
>
> Looks like an another issue.

Yeah.
>
> Thanks,
> Roman
>
>> 
>> unthrottle_offline_cfs_rqs could cause similar issues with its unlocked
>> read of quota, and can also be easily fixed.
>> 
>> 
>> >
>> > Instead of resetting cfs_b->timer_active, tg_set_cfs_bandwidth can
>> > wait for period timer callbacks (ignoring cfs_b->timer_active) and
>> > restart the timer explicitly.
>> >
>> > Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
>> > Cc: Ben Segall <bsegall@google.com>
>> > Cc: Peter Zijlstra <peterz@infradead.org>
>> > Cc: pjt@google.com
>> > Cc: Chris J Arges <chris.j.arges@canonical.com>
>> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > ---
>> >  kernel/sched/core.c  |    3 +--
>> >  kernel/sched/fair.c  |    8 ++++----
>> >  kernel/sched/sched.h |    2 +-
>> >  3 files changed, 6 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> > index d9d8ece..e9b9c66 100644
>> > --- a/kernel/sched/core.c
>> > +++ b/kernel/sched/core.c
>> > @@ -7717,8 +7717,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
>> >  	/* restart the period timer (if active) to handle new period expiry */
>> >  	if (runtime_enabled && cfs_b->timer_active) {
>> >  		/* force a reprogram */
>> > -		cfs_b->timer_active = 0;
>> > -		__start_cfs_bandwidth(cfs_b);
>> > +		__start_cfs_bandwidth(cfs_b, true);
>> >  	}
>> >  	raw_spin_unlock_irq(&cfs_b->lock);
>> >  
>> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> > index 7570dd9..55a0a5b 100644
>> > --- a/kernel/sched/fair.c
>> > +++ b/kernel/sched/fair.c
>> > @@ -3129,7 +3129,7 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>> >  		 */
>> >  		if (!cfs_b->timer_active) {
>> >  			__refill_cfs_bandwidth_runtime(cfs_b);
>> > -			__start_cfs_bandwidth(cfs_b);
>> > +			__start_cfs_bandwidth(cfs_b, false);
>> >  		}
>> >  
>> >  		if (cfs_b->runtime > 0) {
>> > @@ -3308,7 +3308,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
>> >  	raw_spin_lock(&cfs_b->lock);
>> >  	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
>> >  	if (!cfs_b->timer_active)
>> > -		__start_cfs_bandwidth(cfs_b);
>> > +		__start_cfs_bandwidth(cfs_b, false);
>> >  	raw_spin_unlock(&cfs_b->lock);
>> >  }
>> >  
>> > @@ -3690,7 +3690,7 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>> >  }
>> >  
>> >  /* requires cfs_b->lock, may release to reprogram timer */
>> > -void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
>> > +void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b, bool force)
>> >  {
>> >  	/*
>> >  	 * The timer may be active because we're trying to set a new bandwidth
>> > @@ -3705,7 +3705,7 @@ void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
>> >  		cpu_relax();
>> >  		raw_spin_lock(&cfs_b->lock);
>> >  		/* if someone else restarted the timer then we're done */
>> > -		if (cfs_b->timer_active)
>> > +		if (!force && cfs_b->timer_active)
>> >  			return;
>> >  	}
>> >  
>> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> > index 456e492..369b4d6 100644
>> > --- a/kernel/sched/sched.h
>> > +++ b/kernel/sched/sched.h
>> > @@ -278,7 +278,7 @@ extern void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
>> >  extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
>> >  
>> >  extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
>> > -extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
>> > +extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b, bool force);
>> >  extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
>> >  
>> >  extern void free_rt_sched_group(struct task_group *tg);
