Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaKLPIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:08:32 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52476 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaKLPIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:08:30 -0500
Message-ID: <546377FC.4090408@arm.com>
Date: Wed, 12 Nov 2014 15:08:44 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched/deadline: support dl task migration during cpu
 hotplug
References: <1415754413-13988-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1415754413-13988-1-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 12 Nov 2014 15:08:24.0849 (UTC) FILETIME=[817DF010:01CFFE8A]
X-MC-Unique: 114111215082702601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/11/14 01:06, Wanpeng Li wrote:
> I observe that dl task can't be migrated to other cpus during cpu hotplug, 
> in addition, task may/may not be running again if cpu is added back. The 
> root cause which I found is that dl task will be throtted and removed from 
> dl rq after comsuming all budget, which leads to stop task can't pick it up 
> from dl rq and migrate to other cpus during hotplug.
> 
> The method to reproduce:
> schedtool -E -t 50000:100000 -e ./test
> Actually test is just a simple for loop. Then observe which cpu the test
> task is on.
> echo 0 > /sys/devices/system/cpu/cpuN/online
> 
> This patch adds the dl task migration during cpu hotplug by finding a most 
> suitable later deadline rq after dl timer fire if current rq is offline, 
> if fail to find a suitable later deadline rq then fallback to any eligible 
> online cpu in order that the deadline task will come back to us, and the 
> push/pull mechanism should then move it around properly.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
> v4 -> v5:
>  * remove raw_spin_unlock(&rq->lock)
>  * cleanup codes, spotted by Peterz
>  * cleanup patch description
> v3 -> v4:
>  * use tsk_cpus_allowed wrapper
>  * fix compile error
> v2 -> v3:
>  * don't get_task_struct
>  * if cannot preempt any rq, fallback to pick any online cpus
>  * use cpu_active_mask as original later_mask if cpu is offline
> v1 -> v2:
>  * push the task to another cpu in dl_task_timer() if rq is offline.
> 
>  kernel/sched/deadline.c | 43 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index f3d7776..7c31906 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -487,6 +487,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
>  	return hrtimer_active(&dl_se->dl_timer);
>  }
>  
> +static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq);
>  /*
>   * This is the bandwidth enforcement timer callback. If here, we know
>   * a task is not on its dl_rq, since the fact that the timer was running
> @@ -538,6 +539,43 @@ again:
>  	update_rq_clock(rq);
>  	dl_se->dl_throttled = 0;
>  	dl_se->dl_yielded = 0;
> +
> +	/*
> +	 * So if we find that the rq the task was on is no longer
> +	 * available, we need to select a new rq.
> +	 */
> +	if (unlikely(!rq->online)) {
> +		struct rq *later_rq = NULL;
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
> +			cpu = cpumask_any_and(cpu_active_mask,
> +					tsk_cpus_allowed(p));
> +			if (cpu >= nr_cpu_ids) {
> +				pr_warn("fail to find any online cpu and task will never come back\n");
> +				goto unlock;
> +			}
> +			later_rq = cpu_rq(cpu);
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
> +		goto unlock;
> +	}
> +
>  	if (task_on_rq_queued(p)) {
>  		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
>  		if (dl_task(rq->curr))
> @@ -1185,8 +1223,9 @@ static int find_later_rq(struct task_struct *task)
>  	 * We have to consider system topology and task affinity
>  	 * first, then we can look for a suitable cpu.
>  	 */
> -	cpumask_copy(later_mask, task_rq(task)->rd->span);
> -	cpumask_and(later_mask, later_mask, cpu_active_mask);
> +	cpumask_copy(later_mask, cpu_active_mask);
> +	if (likely(task_rq(task)->online))
> +		cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);

So, here you consider the span only when the task_rq is online,
but there might be others cpus still online belonging to the same
rd->span. And you have to consider them when migrating. Actually,
migration must still be restricted to the online cpus of task's
original rd->span, or I fear you can break clustered scheduling.

Thanks,

- Juri

>  	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
>  	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
>  			task, later_mask);
> 

