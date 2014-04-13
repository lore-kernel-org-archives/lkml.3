Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaDMVDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 17:03:43 -0400
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:1942 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbaDMVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 17:03:41 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Apr 2014 17:03:39 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicLADn4SlNIo8UY/2dsb2JhbABZg0G8RYc1gTJ0CQ6BEWIbAQEBAwEnEQIUKwULCw4KHREhEAwaBggDCAkUBIdHAwkIDcNZDYZjF4xVHIF9B4Q4BIlajRmBboE2iS6CEAOFTIM5NYFA
X-IronPort-AV: E=Sophos;i="4.97,852,1389744000"; 
   d="scan'208";a="39943888"
Date: Mon, 14 Apr 2014 02:23:16 +0530 (IST)
From: Govindarajulu Varadarajan <gvaradar@cisco.com>
X-X-Sender: gvaradar@ws.cisco
To: Mike Galbraith <bitbucket@online.de>
cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mgorman@suse.com, akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [tip:sched/core] sched/numa: Move task_numa_free() to
 __put_task_struct()
In-Reply-To: <1396860915.5170.5.camel@marge.simpson.net>
Message-ID: <alpine.LNX.2.03.1404140201210.21969@cisco.com>
References: <1393568591.6018.27.camel@marge.simpson.net>  <tip-156654f491dd8d52687a5fbe1637f472a52ce75b@git.kernel.org>  <5341A84C.4050902@oracle.com> <1396848585.5218.27.camel@marge.simpson.net>  <1396855830.28539.10.camel@marge.simpson.net> 
 <20140407081644.GD11096@twins.programming.kicks-ass.net> <1396860915.5170.5.camel@marge.simpson.net>
User-Agent: Alpine 2.03 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Authenticated-User: gvaradar@cisco.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Apr 2014, Mike Galbraith wrote:

> On Mon, 2014-04-07 at 10:16 +0200, Peter Zijlstra wrote:
>> On Mon, Apr 07, 2014 at 09:30:30AM +0200, Mike Galbraith wrote:
>>> -	double_lock(&my_grp->lock, &grp->lock);
>>> +	BUG_ON(irqs_disabled());
>>> +	double_lock_irq(&my_grp->lock, &grp->lock);
>>
>> So either make this:
>>
>> 	local_irq_disable();
>> 	double_lock();
>>
>> or
>>
>>>
>>>  	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
>>>  		my_grp->faults[i] -= p->numa_faults_memory[i];
>>> @@ -1692,6 +1693,7 @@ static void task_numa_group(struct task_
>>>
>>>  	spin_unlock(&my_grp->lock);
>>>  	spin_unlock(&grp->lock);
>>> +	local_irq_enable();
>>
>> use:
>> 	spin_unlock()
>> 	spin_unlock_irq()
>>
>> or so, but this imbalance is making my itch :-)
>
> sched, numa: fix task_numa_free() lockdep splat
>
> Sasha reports that lockdep claims 156654f491dd8d52687a5fbe1637f472a52ce75b made
> numa_group.lock interrupt unsafe.  While I don't see how that could be given the
> commit in question moved task_numa_free() from one irq enabled region to another,
> the below does make both gripes and lockups upon gripe with numa=fake=4 go away.
>

Hi

I Am hitting this bug quite frequently. I do not see the problem after applying
this patch.

Thanks

Tested-by: Govindarajulu Varadarajan <govindx7c6@gmail.com>

> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Mike Galbraith <bitbucket@online.de>
> ---
> kernel/sched/fair.c  |   13 +++++++------
> kernel/sched/sched.h |    9 +++++++++
> 2 files changed, 16 insertions(+), 6 deletions(-)
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1497,7 +1497,7 @@ static void task_numa_placement(struct t
> 	/* If the task is part of a group prevent parallel updates to group stats */
> 	if (p->numa_group) {
> 		group_lock = &p->numa_group->lock;
> -		spin_lock(group_lock);
> +		spin_lock_irq(group_lock);
> 	}
>
> 	/* Find the node with the highest number of faults */
> @@ -1572,7 +1572,7 @@ static void task_numa_placement(struct t
> 			}
> 		}
>
> -		spin_unlock(group_lock);
> +		spin_unlock_irq(group_lock);
> 	}
>
> 	/* Preferred node as the node with the most faults */
> @@ -1677,7 +1677,8 @@ static void task_numa_group(struct task_
> 	if (!join)
> 		return;
>
> -	double_lock(&my_grp->lock, &grp->lock);
> +	BUG_ON(irqs_disabled());
> +	double_lock_irq(&my_grp->lock, &grp->lock);
>
> 	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
> 		my_grp->faults[i] -= p->numa_faults_memory[i];
> @@ -1691,7 +1692,7 @@ static void task_numa_group(struct task_
> 	grp->nr_tasks++;
>
> 	spin_unlock(&my_grp->lock);
> -	spin_unlock(&grp->lock);
> +	spin_unlock_irq(&grp->lock);
>
> 	rcu_assign_pointer(p->numa_group, grp);
>
> @@ -1710,14 +1711,14 @@ void task_numa_free(struct task_struct *
> 	void *numa_faults = p->numa_faults_memory;
>
> 	if (grp) {
> -		spin_lock(&grp->lock);
> +		spin_lock_irq(&grp->lock);
> 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
> 			grp->faults[i] -= p->numa_faults_memory[i];
> 		grp->total_faults -= p->total_numa_faults;
>
> 		list_del(&p->numa_entry);
> 		grp->nr_tasks--;
> -		spin_unlock(&grp->lock);
> +		spin_unlock_irq(&grp->lock);
> 		rcu_assign_pointer(p->numa_group, NULL);
> 		put_numa_group(grp);
> 	}
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1388,6 +1388,15 @@ static inline void double_lock(spinlock_
> 	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
> }
>
> +static inline void double_lock_irq(spinlock_t *l1, spinlock_t *l2)
> +{
> +	if (l1 > l2)
> +		swap(l1, l2);
> +
> +	spin_lock_irq(l1);
> +	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
> +}
> +
> static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
> {
> 	if (l1 > l2)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
