Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaKKLdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:33:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:36501 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaKKLdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:33:49 -0500
Date: Tue, 11 Nov 2014 12:33:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@arm.com>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3] sched/deadline: support dl task migration during
 cpu hotplug
Message-ID: <20141111113347.GL10501@worktop.programming.kicks-ass.net>
References: <1415241649-59561-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415241649-59561-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:40:49AM +0800, Wanpeng Li wrote:
> @@ -538,6 +539,46 @@ again:
>  	update_rq_clock(rq);
>  	dl_se->dl_throttled = 0;
>  	dl_se->dl_yielded = 0;
> +
> +	/*
> +	 * So if we find that the rq the task was on is no longer
> +	 * available, we need to select a new rq.
> +	 */
> +	if (!rq->online) {
> +		struct rq *later_rq = NULL;
> +
> +		raw_spin_unlock(&rq->lock);
> +
> +		later_rq = find_lock_later_rq(p, rq);
> +
> +		if (!later_rq) {
> +			int cpu;
> +
> +			/*
> +			 * If cannot preempt any rq, fallback to pick any
> +			 * online cpu.
> +			 */
> +			for_each_cpu(cpu, &p->cpus_allowed)
> +				if (cpu_online(cpu))
> +					later_rq = cpu_rq(cpu);

			cpu = cpumask_any_and(cpu_active_mask, tsk_cpus_allowed(p));
			if (cpu >= nr_cpu_ids)
				/* fail */

			later_rq = cpu_rq(cpu);

> +			if (!later_rq) {
> +				pr_warn("fail to find any online and task
> +						will never come back to us\n");
> +				goto out;
> +			}
> +		}
> +
> +		deactivate_task(rq, p, 0);
> +		set_task_cpu(p, later_rq->cpu);
> +		activate_task(later_rq, p, 0);
> +
> +		resched_curr(later_rq);
> +
> +		double_unlock_balance(rq, later_rq);
> +
> +		goto out;
> +	}
> +
>  	if (task_on_rq_queued(p)) {
>  		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
>  		if (dl_task(rq->curr))
> @@ -555,7 +596,7 @@ again:
>  	}
>  unlock:
>  	raw_spin_unlock(&rq->lock);
> -
> +out:
>  	return HRTIMER_NORESTART;
>  }
>  
> @@ -1185,8 +1226,12 @@ static int find_later_rq(struct task_struct *task)
>  	 * We have to consider system topology and task affinity
>  	 * first, then we can look for a suitable cpu.
>  	 */
> -	cpumask_copy(later_mask, task_rq(task)->rd->span);
> -	cpumask_and(later_mask, later_mask, cpu_active_mask);
> +	if (likely(task_rq(task)->online)) {
> +		cpumask_copy(later_mask, task_rq(task)->rd->span);
> +		cpumask_and(later_mask, later_mask, cpu_active_mask);
> +	} else
> +		/* for offline cpus we have a singleton rd */
> +		cpumask_copy(later_mask, cpu_active_mask);
>  	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
>  	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
>  			task, later_mask);

	cpumask_copy(later_mask, cpu_active_mask);
	if (likely(task_rq(task)->online))
		cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);

Is the same, right and less lines.

