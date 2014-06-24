Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbaFXDKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 23:10:33 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43589 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaFXDKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 23:10:32 -0400
Message-ID: <53A8EC1E.1060504@linux.vnet.ibm.com>
Date: Tue, 24 Jun 2014 11:10:22 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <20140515115751.GK30445@twins.programming.kicks-ass.net> <5375768F.1010000@linux.vnet.ibm.com> <1400208690.7133.11.camel@marge.simpson.net> <53759303.40409@linux.vnet.ibm.com> <20140516075421.GL11096@twins.programming.kicks-ass.net> <5396C82C.6060101@linux.vnet.ibm.com> <20140610121222.GE6758@twins.programming.kicks-ass.net> <5397F396.2060801@linux.vnet.ibm.com> <20140611082433.GH3213@twins.programming.kicks-ass.net> <53981EE5.5080903@linux.vnet.ibm.com> <20140623094214.GR19860@laptop.programming.kicks-ass.net>
In-Reply-To: <20140623094214.GR19860@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062403-6102-0000-0000-000005D84997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

Thanks for the reply :)

On 06/23/2014 05:42 PM, Peter Zijlstra wrote:
[snip]
>>
>> 		cpu 0		cpu 1
>>
>> 		dbench		task_sys
>> 		dbench		task_sys
>> 		dbench
>> 		dbench
>> 		dbench
>> 		dbench
>> 		task_sys
>> 		task_sys
> 
> It might help if you prefix each task with the cgroup they're in;

My bad...

but I
> think I get it, its like:
> 
> 	cpu0
> 
> 	A/dbench
> 	A/dbench
> 	A/dbench
> 	A/dbench
> 	A/dbench
> 	A/dbench
> 	/task_sys
> 	/task_sys

Yeah, it's like that.

> 
[snip]
> 
> 	cpu0
> 
> 	A/B/dbench
> 	A/B/dbench
> 	A/B/dbench
> 	A/B/dbench
> 	A/B/dbench
> 	A/B/dbench
> 	/task_sys
> 	/task_sys
> 
> Right?

My bad to missed the group symbol here... it's actually like:

	cpu0

	/l1/A/dbench
	/l1/A/dbench
	/l1/A/dbench
	/l1/A/dbench
	/l1/A/dbench
	/task_sys
	/task_sys

And we also have six:

	/l1/B/stress

and six:

	/l1/C/stress

running in system.

A, B, C is the child groups of l1.

> 
>> 		cpu 0			cpu 1
>> 	load	1024/3 + 1024*2		1024*2
>>
>> 		2389 : 2048	imbalance %116
> 
> Which should still end up with 3072, because A is still 1024 in total,
> and all its member tasks run on the one CPU.

l1 have 3 child groups, each got 6 NICE 0 tasks, so ideally each task
will got 1024/18, 6 dbench will means (1024/18)*6 == 1024/3.

Previously each of the 3 group got 1024 shares, now they need to share
1024 shares, it will become less for each of them.

> 
>> And it could be even less during my testing...
> 
> Well, yes, up to 1024/nr_cpus I imagine.
> 
>> This is just try to explain that when 'group_load : rq_load' become
>> lower, it's influence to 'rq_load' become lower too, and if the system
>> is balanced with only 'rq_load' there, it will be considered still
>> balanced even 'group_load' gathered on one cpu.
>>
>> Please let me know if I missed something here...
> 
> Yeah, what other tasks are these task_sys things? workqueue crap?

There are some other tasks but mostly showup are the kworkers, yes the
workqueue stuff.

They rapidly showup on each CPU, in some period if they showup too much,
they will eat some CPU% too, but not very much.

> 
[snip]
>>
>> These are dbench and stress with less root-load when put into l2-groups,
>> that make it harder to trigger root-group imbalance like in the case above.
> 
> You're still not making sense here.. without the task_sys thingies in
> you get something like:
> 
>  cpu0		cpu1
> 
>  A/dbench	A/dbench
>  B/stress	B/stress
> 
> And the total loads are: 512+512 vs 512+512.

Without other task's influence, I believe the balance should be fine,
but in our cases, at least these kworkers will join the battle anyway...

> 
>>> Same with l2, total weight of 1024, giving a per task weight of ~56 and
>>> a per-cpu weight of ~85, which is again significant.
>>
>> We have other tasks which has to running in the system, in order to
>> serve dbench and others, and that also the case in real world, dbench
>> and stress are not the only tasks on rq time to time.
>>
>> May be we could focus on the case above and see if it could make things
>> more clear firstly?
> 
> Well, this all smells like you need some cgroup affinity for whatever
> system tasks are running. Not fuck up the scheduler for no sane reason.

These kworkers are bind to their CPU already, I don't know how to handle
them to prevent the issue, they just keep working on their CPU, and
whenever they showup, dbench spreading inactively...

We just want a way which could help workload like dbench to work
normally with cpu-group when there are stress likely workload running in
the system.

We want dbench to gain more CPU% but cpu-shares doesn't work as
expected... dbench can get no more than 100% whatever how big it's
group's shares is, and we consider that cpu-group was broken in this
cases...

I agree that this is not a generic requirement and scheduler should only
be responsible for general situation, but since it's really a too big
regression, could we at least provide some way to stop the damage? After
all, most of the cpu-group logic is insider scheduler...

I'd like to list some real numbers in patch-thread, we really desired
for some way to make cpu-group perform normally on workload like dbench,
actually we also find some transaction workloads suffered from this
issue too, in such cases, cpu-group just failed on managing the CPU
resources...

Regards,
Michael Wang

> 

