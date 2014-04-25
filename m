Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaDYFRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:17:43 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38153 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaDYFRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:17:42 -0400
Message-ID: <5359EEBE.2030808@linux.vnet.ibm.com>
Date: Fri, 25 Apr 2014 10:42:30 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com> <1398303035-18255-2-git-send-email-jason.low2@hp.com> <5358E417.8090503@linux.vnet.ibm.com> <20140424120415.GS11096@twins.programming.kicks-ass.net> <20140424124438.GT13658@twins.programming.kicks-ass.net> <1398358417.3509.11.camel@j-VirtualBox> <20140424171453.GZ11096@twins.programming.kicks-ass.net> <1398377917.3509.32.camel@j-VirtualBox>
In-Reply-To: <1398377917.3509.32.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042505-7164-0000-0000-0000014C2A6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On 04/25/2014 03:48 AM, Jason Low wrote:
> On Thu, 2014-04-24 at 19:14 +0200, Peter Zijlstra wrote:
>> On Thu, Apr 24, 2014 at 09:53:37AM -0700, Jason Low wrote:
>>>
>>> So I thought that the original rationale (commit 1bd77f2d) behind
>>> updating rq->next_balance in idle_balance() is that, if we are going
>>> idle (!pulled_task), we want to ensure that the next_balance gets
>>> calculated without the busy_factor.
>>>
>>> If the rq is busy, then rq->next_balance gets updated based on
>>> sd->interval * busy_factor. However, when the rq goes from "busy"
>>> to idle, rq->next_balance might still have been calculated under
>>> the assumption that the rq is busy. Thus, if we are going idle, we
>>> would then properly update next_balance without the busy factor
>>> if we update when !pulled_task.
>>>
>>
>> Its late here and I'm confused!
>>
>> So the for_each_domain() loop calculates a new next_balance based on
>> ->balance_interval (which has that busy_factor on, right).
>>
>> But if it fails to pull anything, we'll (potentially) iterate the entire
>> tree up to the largest domain; and supposedly set next_balanced to the
>> largest possible interval.
>>
>> So when we go from busy to idle (!pulled_task), we actually set
>> ->next_balance to the longest interval. Whereas the commit you
>> referenced says it sets it to a shorter while.
>>
>> Not seeing it.
> 
> So this is the way I understand that code:
> 
> In rebalance_domain, next_balance is suppose to be set to the
> minimum of all sd->last_balance + interval so that we properly call
> into rebalance_domains() if one of the domains is due for a balance.
> 
> In the domain traversals:
> 
> 	if (time_after(next_balance, sd->last_balance + interval))
> 		next_balance = sd->last_balance + interval;
> 
> we update next_balance to a new value if the current next_balance
> is after, and we only update next_balance to a smaller value.
> 
> In rebalance_domains, we have code:
> 
> 	interval = sd->balance_interval;
> 	if (idle != CPU_IDLE)
> 		interval *= sd->busy_factor;
> 
> 	...
> 
> 	if (time_after(next_balance, sd->last_balance + interval)) {
> 		next_balance = sd->last_balance + interval;
> 
> 	...
> 
> 	rq->next_balance = next_balance;
> 
> In the CPU_IDLE case, interval would not include the busy factor,
> whereas in the !CPU_IDLE case, we multiply the interval by the
> sd->busy_factor.
> 
> So as an example, if a CPU is not idle and we run this:
> 
> rebalance_domain()
> 	interval = 1 ms;
> 	if (idle != CPU_IDLE)
> 		interval *= 64;
> 
> 	next_balance = sd->last_balance + 64 ms
> 
> 	rq->next_balance = next_balance
> 
> The rq->next_balance is set to a large value since the CPU is not idle.
> 
> Then, let's say the CPU then goes idle 1 ms later. The
> rq->next_balance can be up to 63 ms later, because we computed
> it when the CPU is not idle. Now that we are going idle,
> we would have to wait a long time for the next balance.
> 
> So I believe that the initial reason why rq->next_balance was
> updated in idle_balance is that if the CPU is in the process 
> of going idle (!pulled_task in idle_balance()), we can reset the
> rq->next_balance based on the interval = 1 ms, as oppose to
> having it remain up to 64 ms later (in idle_balance(), interval
> doesn't get multiplied by sd->busy_factor).

I agree with this. However I am concerned with an additional point that
I have mentioned in my reply to Peter's mail on this thread.

Should we verify if rq->next_balance update is independent of
pulled_tasks? sd->balance_interval is changed during load_balance() and
rq->next_balance should perhaps consider that?

Regards
Preeti U Murthy
> 
> 
> 

