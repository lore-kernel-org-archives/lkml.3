Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaKDASg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:18:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:29466 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaKDASd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:18:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,310,1413270000"; 
   d="scan'208";a="630778055"
Date: Tue, 4 Nov 2014 07:57:48 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH RFC] sched/deadline: support dl task migrate during cpu
 hotplug
Message-ID: <20141103235747.GA26702@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1414740497-7232-1-git-send-email-wanpeng.li@linux.intel.com>
 <20141103104111.GA23531@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103104111.GA23531@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
On Mon, Nov 03, 2014 at 11:41:11AM +0100, Peter Zijlstra wrote:
>On Fri, Oct 31, 2014 at 03:28:17PM +0800, Wanpeng Li wrote:
>> Hi all,
>> 
>> I observe that dl task can't be migrated to other cpus during cpu hotplug, in 
>> addition, task may/may not be running again if cpu is added back. The root cause 
>> which I found is that dl task will be throtted and removed from dl rq after 
>> comsuming all budget, which leads to stop task can't pick it up from dl rq and 
>> migrate to other cpus during hotplug. 
>> 
>> So I try two methods.
>> 
>> - add throttled dl sched_entity to a throttled_list, the list will be traversed
>>   during cpu hotplug, and the dl sched_entity will be picked and enqueue, then 
>>   stop task will pick and migrate it. However, dl sched_entity is throttled again 
>>   before stop task running since the below path. This path will set rq->online 0 
>>   which lead to set_rq_offline() won't be called in function migration_call().
>> 
>
>This seems wrong to me; this screws around with the CBS by replenishing
>too soon.

Agreed.

>
>> @@ -1593,9 +1602,20 @@ static void rq_online_dl(struct rq *rq)
>>  /* Assumes rq->lock is held */
>>  static void rq_offline_dl(struct rq *rq)
>>  {
>> +	struct task_struct *p, *n;
>> +
>>  	if (rq->dl.overloaded)
>>  		dl_clear_overload(rq);
>>  
>> +	/* Make sched_dl_entity available for pick_next_task() */
>> +	list_for_each_entry_safe(p, n, &rq->dl.throttled_list, dl.throttled_node) {
>> +		p->dl.dl_throttled = 0;
>> +		hrtimer_cancel(&p->dl.dl_timer);
>> +		p->dl.dl_runtime = p->dl.dl_runtime;
>> +		if (task_on_rq_queued(p))
>> +			enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
>> +	}
>> +
>>  	cpudl_set(&rq->rd->cpudl, rq->cpu, 0, 0);
>>  }
>
>
>So what is wrong with making dl_task_timer() deal with it? The timer
>will still fire on the correct time, canceling it and or otherwise
>messing with the CBS is wrong. Once it fires, all we need to do is
>migrate it to another cpu (preferably one that is still online of course
>:-).

Do you mean what I need to do is push the task to another cpu in dl_task_timer() 
if rq is offline? In addition, what will happen if dl task can't preempt on 
another cpu?

Regards,
Wanpeng Li 
