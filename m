Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3IZC6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:58:47 -0400
Received: from intranet.asianux.com ([58.214.24.6]:23150 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3IZC6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:58:45 -0400
X-Spam-Score: -100.8
Message-ID: <5243A2A3.1050402@asianux.com>
Date: Thu, 26 Sep 2013 10:57:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 08/11] rcu: Micro-optimize rcu_cpu_has_callbacks()
References: <20130925012750.GA30601@linux.vnet.ibm.com> <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com> <1380072561-31134-8-git-send-email-paulmck@linux.vnet.ibm.com> <524250A2.3050502@asianux.com> <20130925201640.GZ9093@linux.vnet.ibm.com>
In-Reply-To: <20130925201640.GZ9093@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 04:16 AM, Paul E. McKenney wrote:
> On Wed, Sep 25, 2013 at 10:55:30AM +0800, Chen Gang wrote:
>>
>> Thank you for your whole work, firstly  :-).
>>
>> And your suggestion about testing (in our discussion) is also valuable
>> to me.
>>
>> I need start LTP in q4. After referenced your suggestion, my first step
>> for using/learning LTP is not mainly for finding kernel issues, but for
>> testing kernel (to improve my kernel testing efficiency).
>>
>> When I want to find issues by reading code, I will consider about LTP
>> too (I will try to find issues which can be tested by LTP).
> 
> Doing more testing will be good!  You will probably need more tests
> than just LTP, but you must of course start somewhere.
>

Give more testing is good, but also mean more time resources cost. If
spend the 'cost', also need get additional 'contributions' (not only
prove an issue), or the 'efficiency' can not be 'acceptable'.


When "I need more tests than just LTP", firstly I need perform this
test, and then, also try to send "test case" to LTP (I guess, these
kinds of mails are welcomed by LTP).

And LTP is also a way to find kernel issues, although I will not mainly
depend on it now (but maybe in future), it is better to familiar with it
step by step.


LTP (Linux Test Project) is one of main kernel mad user at downstream.
Tool chain (GCC/Binutils) is one of kernel main mad tools at upstream.
If we face to the whole kernel, suggest to use them. ;-)


Thanks.

> 							Thanx, Paul
> 
>> On 09/25/2013 09:29 AM, Paul E. McKenney wrote:
>>> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>>>
>>> The for_each_rcu_flavor() loop unconditionally scans all flavors, even
>>> when the first flavor might have some non-lazy callbacks.  Once the
>>> loop has seen a non-lazy callback, further passes through the loop
>>> cannot change the state.  This is not a huge problem, given that there
>>> can be at most three RCU flavors (RCU-bh, RCU-preempt, and RCU-sched),
>>> but this code is on the path to idle, so speeding it up even a small
>>> amount would have some benefit.
>>>
>>> This commit therefore does two things:
>>>
>>> 1.	Rearranges the order of the list of RCU flavors in order to
>>> 	place the most active flavor first in the list.  The most active
>>> 	RCU flavor is RCU-preempt, or, if there is no RCU-preempt,
>>> 	RCU-sched.
>>>
>>> 2.	Reworks the for_each_rcu_flavor() to exit early when the first
>>> 	non-lazy callback is seen, or, in the case where the caller
>>> 	does not care about non-lazy callbacks (RCU_FAST_NO_HZ=n),
>>> 	when the first callback is seen.
>>>
>>> Reported-by: Chen Gang <gang.chen@asianux.com>
>>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> ---
>>>  kernel/rcutree.c | 11 +++++++----
>>>  1 file changed, 7 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>>> index e6f2e8f..49464ad 100644
>>> --- a/kernel/rcutree.c
>>> +++ b/kernel/rcutree.c
>>> @@ -2727,10 +2727,13 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>>>  
>>>  	for_each_rcu_flavor(rsp) {
>>>  		rdp = per_cpu_ptr(rsp->rda, cpu);
>>> -		if (rdp->qlen != rdp->qlen_lazy)
>>> +		if (!rdp->nxtlist)
>>> +			continue;
>>> +		hc = true;
>>> +		if (rdp->qlen != rdp->qlen_lazy || !all_lazy) {
>>>  			al = false;
>>> -		if (rdp->nxtlist)
>>> -			hc = true;
>>> +			break;
>>> +		}
>>>  	}
>>>  	if (all_lazy)
>>>  		*all_lazy = al;
>>> @@ -3297,8 +3300,8 @@ void __init rcu_init(void)
>>>  
>>>  	rcu_bootup_announce();
>>>  	rcu_init_geometry();
>>> -	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
>>>  	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
>>> +	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
>>>  	__rcu_init_preempt();
>>>  	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
>>>  
>>>
>>
>>
>> -- 
>> Chen Gang
>>
>> -- 
>> Chen Gang
>>
> 
> 
> 


-- 
Chen Gang
