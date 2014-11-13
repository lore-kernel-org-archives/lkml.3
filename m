Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaKMKKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:10:52 -0500
Received: from relay.parallels.com ([195.214.232.42]:43487 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbaKMKKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:10:50 -0500
Message-ID: <1415873444.15631.42.camel@tkhai>
Subject: Re: [PATCH v5] sched/deadline: support dl task migration during cpu
 hotplug
From: Kirill Tkhai <ktkhai@parallels.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@arm.com>, <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 13:10:44 +0300
In-Reply-To: <20141112225636.GA23249@kernel>
References: <1415754413-13988-1-git-send-email-wanpeng.li@linux.intel.com>
	 <1415809626.15631.35.camel@tkhai> <20141112225636.GA23249@kernel>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Чт, 13/11/2014 в 06:56 +0800, Wanpeng Li пишет:
> Hi Kirill,
> On Wed, Nov 12, 2014 at 07:27:06PM +0300, Kirill Tkhai wrote:
> >В Ср, 12/11/2014 в 09:06 +0800, Wanpeng Li пишет:
> >> I observe that dl task can't be migrated to other cpus during cpu hotplug, 
> >> in addition, task may/may not be running again if cpu is added back. The 
> >> root cause which I found is that dl task will be throtted and removed from 
> >> dl rq after comsuming all budget, which leads to stop task can't pick it up 
> >> from dl rq and migrate to other cpus during hotplug.
> >> 
> >> The method to reproduce:
> >> schedtool -E -t 50000:100000 -e ./test
> >> Actually test is just a simple for loop. Then observe which cpu the test
> >> task is on.
> >> echo 0 > /sys/devices/system/cpu/cpuN/online
> >> 
> >> This patch adds the dl task migration during cpu hotplug by finding a most 
> >> suitable later deadline rq after dl timer fire if current rq is offline, 
> >> if fail to find a suitable later deadline rq then fallback to any eligible 
> >> online cpu in order that the deadline task will come back to us, and the 
> >> push/pull mechanism should then move it around properly.
> >> 
> >> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> >> ---
> >> v4 -> v5:
> >>  * remove raw_spin_unlock(&rq->lock)
> >>  * cleanup codes, spotted by Peterz
> >>  * cleanup patch description
> >> v3 -> v4:
> >>  * use tsk_cpus_allowed wrapper
> >>  * fix compile error
> >> v2 -> v3:
> >>  * don't get_task_struct
> >>  * if cannot preempt any rq, fallback to pick any online cpus
> >>  * use cpu_active_mask as original later_mask if cpu is offline
> >> v1 -> v2:
> >>  * push the task to another cpu in dl_task_timer() if rq is offline.
> >> 
> >>  kernel/sched/deadline.c | 43 +++++++++++++++++++++++++++++++++++++++++--
> >>  1 file changed, 41 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> >> index f3d7776..7c31906 100644
> >> --- a/kernel/sched/deadline.c
> >> +++ b/kernel/sched/deadline.c
> >> @@ -487,6 +487,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
> >>  	return hrtimer_active(&dl_se->dl_timer);
> >>  }
> >>  
> >> +static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq);
> >>  /*
> >>   * This is the bandwidth enforcement timer callback. If here, we know
> >>   * a task is not on its dl_rq, since the fact that the timer was running
> >> @@ -538,6 +539,43 @@ again:
> >>  	update_rq_clock(rq);
> >>  	dl_se->dl_throttled = 0;
> >>  	dl_se->dl_yielded = 0;
> >> +
> >> +	/*
> >> +	 * So if we find that the rq the task was on is no longer
> >> +	 * available, we need to select a new rq.
> >> +	 */
> >> +	if (unlikely(!rq->online)) {
> >> +		struct rq *later_rq = NULL;
> >> +
> >> +		later_rq = find_lock_later_rq(p, rq);
> >> +
> >> +		if (!later_rq) {
> >> +			int cpu;
> >> +
> >> +			/*
> >> +			 * If cannot preempt any rq, fallback to pick any
> >> +			 * online cpu.
> >> +			 */
> >> +			cpu = cpumask_any_and(cpu_active_mask,
> >> +					tsk_cpus_allowed(p));
> >> +			if (cpu >= nr_cpu_ids) {
> >> +				pr_warn("fail to find any online cpu and task will never come back\n");
> >> +				goto unlock;
> >> +			}
> >> +			later_rq = cpu_rq(cpu);
> >
> >later_rq is not locked here, but you activate p on it and you do unlock below.
> 
> Great catch! How about add double_lock_balance(rq, later_rq); here?

This sounds good.

> 
> Regards,
> Wanpeng Li 
> 
> >
> >> +		}
> >> +
> >> +		deactivate_task(rq, p, 0);
> >> +		set_task_cpu(p, later_rq->cpu);
> >> +		activate_task(later_rq, p, 0);
> >
> >		^^^^^
> >
> >> +
> >> +		resched_curr(later_rq);
> >> +
> >> +		double_unlock_balance(rq, later_rq);
> >
> >		^^^^^^
> >
> >> +
> >> +		goto unlock;
> >> +	}
> >> +
> >>  	if (task_on_rq_queued(p)) {
> >>  		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
> >>  		if (dl_task(rq->curr))
> >> @@ -1185,8 +1223,9 @@ static int find_later_rq(struct task_struct *task)
> >>  	 * We have to consider system topology and task affinity
> >>  	 * first, then we can look for a suitable cpu.
> >>  	 */
> >> -	cpumask_copy(later_mask, task_rq(task)->rd->span);
> >> -	cpumask_and(later_mask, later_mask, cpu_active_mask);
> >> +	cpumask_copy(later_mask, cpu_active_mask);
> >> +	if (likely(task_rq(task)->online))
> >> +		cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);
> >>  	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
> >>  	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
> >>  			task, later_mask);
> >

Also, we should think about the following situation.

DL task is left on dead rq. In your scheme it will be moved by the timer.
But what will be if somebody changes the class of the task (before timer)?
In this case the task still remains on dead rq.

We should handle this situation in some way.

Kirill


