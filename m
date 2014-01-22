Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaAVHlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:41:07 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36085 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaAVHkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:40:53 -0500
Message-ID: <52DF75FD.5080304@linaro.org>
Date: Wed, 22 Jan 2014 15:40:45 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: top-down balance purpose discussion -- resend
References: <52DE7E6A.90401@linaro.org> <20140121145708.GY31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140121145708.GY31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 10:57 PM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 10:04:26PM +0800, Alex Shi wrote:
>>
>> Current scheduler load balance is bottom-up mode, each CPU need
>> initiate the balance by self.
>>
>> 1, Like in a integrate computer system, it has smt/core/cpu/numa, 4
>> level scheduler domains. If there is just 2 tasks in whole system that
>> both running on cpu0. Current load balance need to pull task to another
>> smt in smt domain, then pull task to another core, then pull task to
>> another cpu, finally pull task to another numa. Totally it is need 4
>> times task moving to get system balance.
> 
> Except the idle load balancer, and esp. the newidle can totally by-pass
> this.
> 
> If you do the packing right in the newidle pass, you'd get there in 1
> step.

It give me a huge pressure to argue with you a great experts. I am
waiting and very appreciate for any comments and corrections. :)

Yes, a newidle will kindly relief this. but it can not eliminate it. If
a newidle happens on another numa group. It just needs 1 step. But if it
happens on another smt group, it still needs 4 steps. So generally, we
still need one more steps before well balance.

In this example, if a newidle is in the same smallest group, maybe we
should wakeup a remotest cpu in system/llc to avoid extra task moving in
near future for best performance.
And for power saving, maybe we'd better kick the task to smallest group,
then let the remote cpu group idle.
But for current newidle, it's impossible to do this because newidle is
also bottom-up mode.
> 
>> Generally, the task moving complexity is
>> 	O(nm log n),  n := nr_cpus, m := nr_tasks
>>
>> There is a excellent summary and explanation for this in
>> kernel/sched/fair.c:4605
> 
> Which is a perfectly fine scheme for a busy system.
> 
>> Another weakness of current LB is that every cpu need to get the other
>> cpus' load info repeatedly and try to figure out busiest sched
>> group/queue on every sched domain level. But it just waste time, since
>> it may not conduct a task moving. One of reasons is that cpu can only
>> pull task, not pushing.
> 
> This doesn't make sense.. and in fact, we do a limited amount of 3rd
> party movements.

Yes, but the 3rd party movements is too limited, just for task pinned.
> 
> Whatever you do, you have to repeat the information gathering anyhow,
> because it constantly changes.
> 

Yes, it is good to collection the load info once for once balance. but
if the balance cpu is busiest cpu, current balance still keep collecting
every group load info from bottom to up, and then do nothing on this
imbalance system. This is bad.

> Trying to serialize that doesn't make any kind of sense. The only thing
> you want is that the system converges.

Sorry, would you like to give a bit more details of 'serialize' is no sense?
> 
> Skipped the rest because it seems build on a fundament I don't agree
> with. That 4 move thing is just silly for an idle system, and we
> shouldn't do that.
> 
> I also very much do not want a single CPU balancing the entire system,
> that's the anti-thesis of scalable.

Sorry. IMHO, single cpu is possible to handle 1000 cpu balancing. And it
is far more scalable than every cpu do balance in system, since there is
only one cpu need to pick other cpu load info.

BTW, there is no organize among all cpus' balancing currently. That's a
a bit mess. Like if 2 cpus in a small cpu group just do balance for
whole system at the same time, then both of them think self group is
light and want more load. then they have the chance to over pull load to
self group. That is bad. And single balancing has no such problem.

-- 
Thanks
    Alex
