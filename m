Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3BUHAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 02:00:45 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55485 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3BUHAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 02:00:44 -0500
Message-ID: <5125C607.8090909@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2013 15:00:23 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com> <1361427108.5861.41.camel@marge.simpson.net>
In-Reply-To: <1361427108.5861.41.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022106-3864-0000-0000-000006EC2AB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 02:11 PM, Mike Galbraith wrote:
> On Thu, 2013-02-21 at 12:51 +0800, Michael Wang wrote: 
>> On 02/20/2013 06:49 PM, Ingo Molnar wrote:
>> [snip]
[snip]
>>
>> 	if wake_affine()
>> 		new_cpu = select_idle_sibling(curr_cpu)
>> 	else
>> 		new_cpu = select_idle_sibling(prev_cpu)
>>
>> 	return new_cpu
>>
>> Actually that doesn't make sense.
>>
>> I think wake_affine() is trying to check whether move a task from
>> prev_cpu to curr_cpu will break the balance in affine_sd or not, but why
>> won't break balance means curr_cpu is better than prev_cpu for searching
>> the idle cpu?
> 
> You could argue that it's impossible to break balance by moving any task
> to any idle cpu, but that would mean bouncing tasks cross node on every
> wakeup is fine, which it isn't.

I don't get it... could you please give me more detail on how
wake_affine() related with bouncing?

> 
>> So the new logical in this patch set is:
>>
>> 	new_cpu = select_idle_sibling(prev_cpu)
>> 	if idle_cpu(new_cpu)
>> 		return new_cpu
> 
> So you tilted the scales in favor of leaving tasks in their current
> package, which should benefit large footprint tasks, but should also
> penalize light communicating tasks.

Yes, I'd prefer to wakeup the task on a cpu which:
1. idle
2. close to prev_cpu

So if both curr_cpu and prev_cpu have idle cpu in their topology, which
one is better? that depends on how task benefit from cache and the
balance situation, whatever, I don't think the benefit worth the high
cost of wake_affine() in most cases...

Regards,
Michael Wang

> 
> I suspect that much of the pgbench improvement comes from the preemption
> mitigation from keeping 1:N load maximally spread, which is the perfect
> thing to do with such loads.  In all the testing I ever did with it in
> 1:N mode, preemption dominated performance numbers.  Keep server away
> from clients, it has fewer fair competition worries, can consume more
> CPU preemption free, pushing the load collapse point strongly upward.
> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

