Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaKGDAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 22:00:30 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:43668 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751393AbaKGDA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 22:00:28 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="42999328"
Message-ID: <545C368C.5040704@cn.fujitsu.com>
Date: Fri, 7 Nov 2014 11:03:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Dongsu Park <dongsu.park@profitbricks.com>
CC: Tejun Heo <tj@kernel.org>, NeilBrown <neilb@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] workqueue: allow rescuer thread to do more work.
References: <20141029172608.39119c80@notabene.brown> <20141029143210.GA25226@htj.dyndns.org> <20141030101932.2241daa7@notabene.brown> <20141104142240.GD14459@htj.dyndns.org> <20141106165811.GA2338@gmail.com>
In-Reply-To: <20141106165811.GA2338@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/2014 12:58 AM, Dongsu Park wrote:
> Hi Tejun & Neil,
> 
> On 04.11.2014 09:22, Tejun Heo wrote:
>> On Thu, Oct 30, 2014 at 10:19:32AM +1100, NeilBrown wrote:
>>>>                           Given that workder depletion is pool-wide
>>>> event, maybe it'd make sense to trigger rescuers immediately while
>>>> workers are in short supply?  e.g. while there's a manager stuck in
>>>> maybe_create_worker() with the mayday timer already triggered?
>>>
>>> So what if I change "need_more_worker" to "need_to_create_worker" ?
>>> Then it will stop as soon as there in an idle worker thread.
>>> That is the condition that keeps maybe_create_worker() looping.
>>> ??
>>
>> Yeah, that'd be a better condition and can work out.  Can you please
>> write up a patch to do that and do some synthetic tests excercising
>> the code path?  Also please cc Lai Jiangshan <laijs@cn.fujitsu.com>
>> when posting the patch.
> 
> This issue looks exactly like what I've encountered occasionally in our test
> setup. (with a custom kernel based on 3.12, MD/raid1, dm-multipath, etc.)
> When a system suffers from high memory pressure, and at the same time
> underlying devices of RAID arrays are repeatedly removed and re-added,
> then sometimes the whole system gets locked up on a worker pool's lock.
> So I had to fix our custom MD code to allocate a separate ordered workqueue
> with WQ_MEM_RECLAIM, apart from md_wq or md_misc_wq.
> Then the lockup seemed to have disappeared.
> 
> Now that I read the Neil's patch, which looks like an ultimate solution
> to the problem I have seen. I'm really looking forward to seeing this
> change in mainline.
> 
> How about the attached patch? Based on the Neil's patch, I replaced
> need_more_worker() with need_to_create_worker() as Tejun suggested.
> 
> Test is running with this patch, which seems to be working for now.
> But I'm going to observe the test result carefully for a few more days.
> 
> Regards,
> Dongsu
> 
> ----
>>From de9aadd6fb742ea8acce4245a27946d3f233ab7f Mon Sep 17 00:00:00 2001
> From: Dongsu Park <dongsu.park@profitbricks.com>
> Date: Wed, 5 Nov 2014 17:28:07 +0100
> Subject: [RFC PATCH] workqueue: allow rescuer thread to do more work
> 
> Original commit message from NeilBrown <neilb@suse.de>:
> ====
> When there is serious memory pressure, all workers in a pool could be
> blocked, and a new thread cannot be created because it requires memory
> allocation.
> 
> In this situation a WQ_MEM_RECLAIM workqueue will wake up the rescuer
> thread to do some work.
> 
> The rescuer will only handle requests that are already on ->worklist.
> If max_requests is 1, that means it will handle a single request.
> 
> The rescuer will be woken again in 100ms to handle another max_requests
> requests.


I also observed this problem by review when I was developing
the per-pwq-worklist patchset which has a side-affect that it also naturally
fix the problem.

However, it is nothing about correctness and I made promise to Frederic Weisbecker
for working on unbound pool for power-saving, then the per-pwq-worklist patchset
is put off. So I have to ack it.

> 
> I've seen a machine (running a 3.0 based "enterprise" kernel) with
> thousands of requests queued for xfslogd, which has a max_requests of 1,
> and is needed for retiring all 'xfs' write requests.  When one of the
> worker pools gets into this state, it progresses extremely slowly and
> possibly never recovers (only waited an hour or two).
> 
> So if, after handling everything on worklist, there is again something
> on worklist (counted in nr_active), and if the queue is still congested,
> keep processing instead of waiting for the next wake-up.
> ====
> 
> Dongsu Park: replaced need_more_worker() with need_to_create_worker(),
> as suggested by Tejun.
> 
> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
> Link: https://lkml.org/lkml/2014/10/29/55
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Original-by: NeilBrown <neilb@suse.de>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  kernel/workqueue.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 09b685d..4d20225 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2244,16 +2244,19 @@ repeat:
>  		spin_lock_irq(&pool->lock);
>  		rescuer->pool = pool;
>  
> -		/*
> -		 * Slurp in all works issued via this workqueue and
> -		 * process'em.
> -		 */
> -		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> -		list_for_each_entry_safe(work, n, &pool->worklist, entry)
> -			if (get_work_pwq(work) == pwq)
> -				move_linked_works(work, scheduled, &n);
> -
> -		process_scheduled_works(rescuer);
> +		do {
> +			/*
> +			 * Slurp in all works issued via this workqueue and
> +			 * process'em.
> +			 */
> +			WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> +			list_for_each_entry_safe(work, n, &pool->worklist,
> +					entry)
> +				if (get_work_pwq(work) == pwq)
> +					move_linked_works(work, scheduled, &n);
> +
> +			process_scheduled_works(rescuer);
> +		} while (need_to_create_worker(pool) && pwq->nr_active);
>  
>  		/*
>  		 * Put the reference grabbed by send_mayday().  @pool won't

