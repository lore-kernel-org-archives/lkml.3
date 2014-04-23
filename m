Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbaDWPpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:45:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55385 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754400AbaDWPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:45:51 -0400
Message-ID: <5357E024.1000207@arm.com>
Date: Wed, 23 Apr 2014 16:45:40 +0100
From: Chris Redpath <Chris.Redpath@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] sched: let task migration destination cpu do active
 balance
References: <1397648069-6462-1-git-send-email-alex.shi@linaro.org> <20140416121329.GO26782@laptop.programming.kicks-ass.net> <534F69D8.40605@linaro.org>
In-Reply-To: <534F69D8.40605@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/04/14 06:42, Alex Shi wrote:
> On 04/16/2014 08:13 PM, Peter Zijlstra wrote:
>> On Wed, Apr 16, 2014 at 07:34:29PM +0800, Alex Shi wrote:
>>> Chris Redpath found an issue on active balance:
>>> We let the task source cpu, the busiest cpu, do the active balance,
>>> while the destination cpu maybe idle. thus we take the busiest cpu
>>> time, but left the idlest cpu wait. That is not good for performance.
>>>
>>> This patch let the destination cpu do active balance. It will give tasks
>>> more running time.
>>>
>>> Signed-off-by: Alex Shi <alex.shi@linaro.org>
>>> ---
>>>   kernel/sched/fair.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 9b4c4f3..cccee76 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -6308,7 +6308,7 @@ more_balance:
>>>   			raw_spin_unlock_irqrestore(&busiest->lock, flags);
>>>
>>>   			if (active_balance) {
>>> -				stop_one_cpu_nowait(cpu_of(busiest),
>>> +				stop_one_cpu_nowait(busiest->push_cpu,
>>>   					active_load_balance_cpu_stop, busiest,
>>>   					&busiest->active_balance_work);
>>>   			}
>>
>> This doesn't make sense, the whole point of active balance is that we're
>> going to move current, for that to work we have to interrupt the CPU
>> current is running on and make sure another task (the stopper task in
>> this case) is running, so that the previous current is now a !running
>> task and we can move it around.
>>
>
> Sure, you are right. thanks for correction!
>
Hi Alex, Peter,

I've been away but just to clarify, the issue I found wasn't a problem 
in the scheduler. It would be more accurately described as an 
optimization for our big.LITTLE MP support patches (called HMP in the 
sources) that live in Linaro's LSK tree (https://wiki.linaro.org/LSK).

I don't think there is anything to talk about in the mainline scheduler 
yet, but perhaps if the scheduler knows more about the idle states of 
CPUs some similar optimizations could be useful. I'm not convinced that 
this kind of optimization scales but in any case I've included a 
description below the line for anyone interested.

--Chris


--------
In ARM's big.LITTLE MP solution we arrange the CPUs such that all the 
little CPUs are in one MC domain and all the big CPUs are in another MC 
domain. We disable load balancing at the CPU level, and use the task 
load to decide if a task ought to be running in the big or little MC 
domain. If we decide to move a running task, we use a forced migration 
which is functionally identical to the active balance but given a 
different name to reflect being triggered under different circumstances.

When we try to do a forced migration, it's constrained to only target an 
idle big CPU as it's supposed to be increasing the CPU performance 
available to the task. The big.LITTLE architecture has big and little 
CPUs in separate clusters and even the simplest power management 
implementations have total power off for an idle cluster.

It is likely that a lightly-loaded system will have an idle big cluster 
if we hit this code path since we also have idle-pull between big and 
little domains for eligible tasks when a CPU is about to enter idle and 
cannot pull something within its own domain, so there's a good chance 
that the target cpu is completely powered down.

The optimization is for us to set a flag on the RQ of the target CPU and 
send a reschedule IPI instead of running the stopper immediately. The 
target CPU is woken to handle the IPI and the flag tells it to look at 
the tasks in the slower domain and set up a task migration if something 
appropriate should be found. This allows a busy task to continue to 
execute on a little CPU during the power-on time for the big CPU and the 
big CPU will be already awake when the task is pushed there by the 
stopper. There are some details to make it work as expected but that's 
basically it.

The intent is to try to avoid stalling forward progress in a task which 
is ramping up CPU activity.
--------
