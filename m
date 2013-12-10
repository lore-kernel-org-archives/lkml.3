Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3LJLsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:48:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46590 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab3LJLsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:48:38 -0500
Date: Tue, 10 Dec 2013 12:48:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Redpath <chris.redpath@arm.com>
Cc: pjt@google.com, mingo@redhat.com, alex.shi@linaro.org,
        morten.rasmussen@arm.com, dietmar.eggemann@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sched: update runqueue clock before migrations away
Message-ID: <20131210114825.GF12849@twins.programming.kicks-ass.net>
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
 <1386593950-26475-3-git-send-email-chris.redpath@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386593950-26475-3-git-send-email-chris.redpath@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 12:59:10PM +0000, Chris Redpath wrote:
> If we migrate a sleeping task away from a CPU which has the
> tick stopped, then both the clock_task and decay_counter will
> be out of date for that CPU and we will not decay load correctly
> regardless of how often we update the blocked load.
> 
> This is only an issue for tasks which are not on a runqueue
> (because otherwise that CPU would be awake) and simultaneously
> the CPU the task previously ran on has had the tick stopped.

OK, so the idiot in a hurry (me) isn't quite getting the issue.

Normally we update the blocked averages from the tick; clearly when no
tick, no update. So far so good.

Now, we also update blocked load from idle balance -- which would
include the CPUs without tick through nohz_idle_balance() -- however
this only appears to be done for CONFIG_FAIR_GROUP_SCHED.

Are you running without cgroup muck? If so should we make this
unconditional?

If you have cgroup muck enabled; what's the problem? Don't we run
nohz_idle_balance() frequently enough to be effective for updating the
blocked load?

You also seem to have overlooked NO_HZ_FULL, that can stop a tick even
when there's a running task and makes the situation even more fun.

> @@ -4343,6 +4344,25 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>  	 * be negative here since on-rq tasks have decay-count == 0.
>  	 */
>  	if (se->avg.decay_count) {
> +		/*
> +		 * If we migrate a sleeping task away from a CPU
> +		 * which has the tick stopped, then both the clock_task
> +		 * and decay_counter will be out of date for that CPU
> +		 * and we will not decay load correctly.
> +		 */
> +		if (!se->on_rq && nohz_test_cpu(task_cpu(p))) {
> +			struct rq *rq = cpu_rq(task_cpu(p));
> +			unsigned long flags;
> +			/*
> +			 * Current CPU cannot be holding rq->lock in this
> +			 * circumstance, but another might be. We must hold
> +			 * rq->lock before we go poking around in its clocks
> +			 */
> +			raw_spin_lock_irqsave(&rq->lock, flags);
> +			update_rq_clock(rq);
> +			update_cfs_rq_blocked_load(cfs_rq, 0);
> +			raw_spin_unlock_irqrestore(&rq->lock, flags);
> +		}
>  		se->avg.decay_count = -__synchronize_entity_decay(se);
>  		atomic_long_add(se->avg.load_avg_contrib,
>  						&cfs_rq->removed_load);

Right, as Ben already said; taking a rq->lock there is unfortunate at
best.

So normally we 'throttle' the expense of decaying the blocked load to
ticks. But the above does it on every (suitable) task migration which
might be far more often.

So ideally we'd get it all sorted through the nohz_idle_balance() path;
what exactly are the problems with that?
