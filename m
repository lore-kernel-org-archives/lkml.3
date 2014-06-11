Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbaFKJSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:18:44 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46569 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaFKJSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:18:41 -0400
Message-ID: <53981EE5.5080903@linux.vnet.ibm.com>
Date: Wed, 11 Jun 2014 17:18:29 +0800
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
References: <20140515090638.GI30445@twins.programming.kicks-ass.net> <53748A5D.6070605@linux.vnet.ibm.com> <20140515115751.GK30445@twins.programming.kicks-ass.net> <5375768F.1010000@linux.vnet.ibm.com> <1400208690.7133.11.camel@marge.simpson.net> <53759303.40409@linux.vnet.ibm.com> <20140516075421.GL11096@twins.programming.kicks-ass.net> <5396C82C.6060101@linux.vnet.ibm.com> <20140610121222.GE6758@twins.programming.kicks-ass.net> <5397F396.2060801@linux.vnet.ibm.com> <20140611082433.GH3213@twins.programming.kicks-ass.net>
In-Reply-To: <20140611082433.GH3213@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061109-5140-0000-0000-000005488693
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 04:24 PM, Peter Zijlstra wrote:
[snip]
>>
>> IMHO, when we put tasks one group deeper, in other word the totally
>> weight of these tasks is 1024 (prev is 3072), the load become more
>> balancing in root, which make bl-routine consider the system is
>> balanced, which make we migrate less in lb-routine.
> 
> But how? The absolute value (1024 vs 3072) is of no effect to the
> imbalance, the imbalance is computed from relative differences between
> cpus.

Ok, forgive me for the confusion, please allow me to explain things
again, for gathered cases like:

		cpu 0		cpu 1

		dbench		task_sys
		dbench		task_sys
		dbench
		dbench
		dbench
		dbench
		task_sys
		task_sys

task_sys is other tasks belong to root which is nice 0, so when dbench
in l1:

		cpu 0			cpu 1
	load	1024 + 1024*2		1024*2

		3072: 2048	imbalance %150

now when they belong to l2:

		cpu 0			cpu 1
	load	1024/3 + 1024*2		1024*2

		2389 : 2048	imbalance %116

And it could be even less during my testing...

This is just try to explain that when 'group_load : rq_load' become
lower, it's influence to 'rq_load' become lower too, and if the system
is balanced with only 'rq_load' there, it will be considered still
balanced even 'group_load' gathered on one cpu.

Please let me know if I missed something here...

> 
[snip]
>>
>> Although the l1-group gain the same resources (1200%), it doesn't assign
>> to l2-ABC correctly like the root-group did.
> 
> But in this case select_idle_sibling() should function identially, so
> that cannot be the problem.

Yes, it's clean, select_idle_sibling() just return curr or prev cpu in
this case.

> 
[snip]
>>
>> Exactly, however, when group is deep, the chance of it to make root
>> imbalance reduced, in good case, gathered on cpu means 1024 load, while
>> in bad case it dropped to 1024/3 ideally, that make it harder to trigger
>> imbalance and gain help from the routine, please note that although
>> dbench and stress are the only workload in system, there are still other
>> tasks serve for the system need to be wakeup (some very actively since
>> the dbench...), compared to them, deep group load means nothing...
> 
> What tasks are these? And is it their interference that disturbs
> load-balancing?

These are dbench and stress with less root-load when put into l2-groups,
that make it harder to trigger root-group imbalance like in the case above.

> 
>>>> By which means even tasks in deep group all gathered on one CPU, the load
>>>> could still balanced from the view of root group, and the tasks lost the
>>>> only chances (balance) to spread when they already on the same CPU...
>>>
>>> Sure, but see above.
>>
>> The lb-routine could not provide enough help for deep group, since the
>> imbalance happened inside the group could not cause imbalance in root,
>> ideally each l2-task will gain 1024/18 ~= 56 root-load, which could be
>> easily ignored, but inside the l2-group, the gathered case could already
>> means imbalance like (1024 * 5) : 1024.
> 
> your explanation is not making sense, we have 3 cgroups, so the total
> root weight is at least 3072, with 18 tasks you would get 3072/18 ~ 170.

I mean the l2-groups case here... since l1 share is 1024, the total load
of l2-groups will be 1024 by theory.

> 
> And again, the absolute value doesn't matter, with (istr) 12 cpus the
> avg cpu load would be 3072/12 ~ 256, and 170 is significant on that
> scale.
> 
> Same with l2, total weight of 1024, giving a per task weight of ~56 and
> a per-cpu weight of ~85, which is again significant.

We have other tasks which has to running in the system, in order to
serve dbench and others, and that also the case in real world, dbench
and stress are not the only tasks on rq time to time.

May be we could focus on the case above and see if it could make things
more clear firstly?

Regards,
Michael Wang

> 
> Also, you said load-balance doesn't usually participate much because
> dbench is too fast, so please make up your mind, does it or doesn't it
> matter?
> 
>>> So I think that approach is wrong, select_idle_siblings() works because
>>> we want to keep CPUs from being idle, but if they're not actually idle,
>>> pretending like they are (in a cgroup) is actively wrong and can skew
>>> load pretty bad.
>>
>> We only choose the timing when no idle cpu located, and flips is
>> somewhat high, also the group is deep.
> 
> -enotmakingsense
> 
>> In such cases, select_idle_siblings() doesn't works anyway, it return
>> the target even it is very busy, we just check twice to prevent it from
>> making some obviously bad decision ;-)
> 
> -emakinglesssense
> 
>>> Furthermore, if as I expect, dbench sucks on a busy system, then the
>>> proposed cgroup thing is wrong, as a cgroup isn't supposed to radically
>>> alter behaviour like that.
>>
>> That's true and that's why we currently still need to shut down the
>> GENTLE_FAIR_SLEEPERS feature, but that's another problem we need to
>> solve later...
> 
> more confusion..
> 
>> What we currently expect is that the cgroup assign the resource
>> according to the share, it works well in l1-groups, so we expect it to
>> work the same well in l2-groups...
> 
> Sure, but explain why it isn't? So far you're just saying words that
> don't compute.
> 

