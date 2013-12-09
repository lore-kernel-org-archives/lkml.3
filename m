Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3LISNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:13:36 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:53375 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3LISNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:13:34 -0500
From: bsegall@google.com
To: Chris Redpath <chris.redpath@arm.com>
Cc: pjt@google.com, mingo@redhat.com, peterz@infradead.org,
        alex.shi@linaro.org, morten.rasmussen@arm.com,
        dietmar.eggemann@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sched: update runqueue clock before migrations away
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
	<1386593950-26475-3-git-send-email-chris.redpath@arm.com>
Date: Mon, 09 Dec 2013 10:13:29 -0800
In-Reply-To: <1386593950-26475-3-git-send-email-chris.redpath@arm.com> (Chris
	Redpath's message of "Mon, 9 Dec 2013 12:59:10 +0000")
Message-ID: <xm2661qxq4dy.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Redpath <chris.redpath@arm.com> writes:

> If we migrate a sleeping task away from a CPU which has the
> tick stopped, then both the clock_task and decay_counter will
> be out of date for that CPU and we will not decay load correctly
> regardless of how often we update the blocked load.
>
> This is only an issue for tasks which are not on a runqueue
> (because otherwise that CPU would be awake) and simultaneously
> the CPU the task previously ran on has had the tick stopped.
>
> Signed-off-by: Chris Redpath <chris.redpath@arm.com>

This looks like it is basically correct, but it seems unfortunate to
take any rq lock for these ttwus. I don't know enough about the nohz
machinery to know if that's at all avoidable.


> ---
>  kernel/sched/fair.c |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b7e5945..0af1dc2 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4324,6 +4324,7 @@ unlock:
>  	return new_cpu;
>  }
>  
> +static int nohz_test_cpu(int cpu);
>  /*
>   * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
>   * cfs_rq_of(p) references at time of call are still valid and identify the
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
p->on_rq - se->on_rq must be false to call set_task_cpu at all. That
said, barring bugs like the one you fixed in patch 1 I think decay_count
!= 0 should also imply !p->on_rq.

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
> @@ -6507,6 +6527,11 @@ static struct {
>  	unsigned long next_balance;     /* in jiffy units */
>  } nohz ____cacheline_aligned;
>  
> +static int nohz_test_cpu(int cpu)
> +{
> +	return cpumask_test_cpu(cpu, nohz.idle_cpus_mask);
> +}
> +
>  static inline int find_new_ilb(int call_cpu)
>  {
>  	int ilb = cpumask_first(nohz.idle_cpus_mask);
> @@ -6619,6 +6644,11 @@ static int sched_ilb_notifier(struct notifier_block *nfb,
>  		return NOTIFY_DONE;
>  	}
>  }
> +#else
> +static int nohz_test_cpu(int cpu)
> +{
> +	return 0;
> +}
>  #endif
>  
>  static DEFINE_SPINLOCK(balancing);
