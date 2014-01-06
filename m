Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaAFNoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:44:46 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36457 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaAFNoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:44:44 -0500
Message-ID: <52CAB344.9050208@linaro.org>
Date: Mon, 06 Jan 2014 21:44:36 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Mark Brown <broonie@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion] simpler load balance in scheduler
References: <52A95588.5040905@linaro.org> <52AADCEB.50105@linaro.org> <20131217163232.GI5919@linux.vnet.ibm.com>
In-Reply-To: <20131217163232.GI5919@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 12:32 AM, Paul E. McKenney wrote:
> On Fri, Dec 13, 2013 at 06:09:47PM +0800, Alex Shi wrote:
>> Hi Paul,
>>
>> Would you like to give some comments when you'r free? Especially for the
>> 3rd point.
>>
>> Appreciate for your any input!
> 
> Hello, Alex,
> 
> I guess my main question is why we are discussing this internally rather
> than on LKML.  Is this to be some writeup somewhere?  (That would be
> a good thing.)

Thanks Paul!
I very appreciate your great comments and suggestions!

I thought it could be better to collect more comments before send to
Peter and LKML. But since the main idea has no much change, and Paul had
give very valuable suggestions. Rewrite/resend may cover the Paul's wise
comments. So, I'd forward this email to LKML. sorry if the format
doesn't looks good.
> 
> On to #3 below...
> 
>> On 12/12/2013 02:19 PM, Alex Shi wrote:
>>> Paul & Vincent & Morten,
>>>
>>> The following rough idea get during this KS. I want to have internal
>>> review before send to LKML. Would you like to give some comments?
>>>
>>> ==========================
>>> 1, Current scheduler load balance is bottom-up mode, each CPU need
>>> initiate the balance by self. Like in a integrate computer system, it
>>> has smt/core/cpu/numa, 4 level scheduler domains.
>>> If there is just 2 tasks in whole system that both running on cpu0.
>>> Current load balance need to pull task to another smt in smt domain,
>>> then pull task to another core, then pull task to another cpu, finally
>>> pull task to another numa. Totally it is need 4 times task moving to get
>>> system balance.

As Vincent pointed out, idle balance may help a little for this task
moving. But it depends on the CPU topology and which cpu is just idle in
chance, so can not help much.

>>> Generally, the task moving complexity is
>>> 	O(nm log n),  n := nr_cpus, m := nr_tasks
>>>
>>> PeterZ has a excellent summary and explanation for this in
>>> kernel/sched/fair.c:4605
>>>
>>> Another weakness of current LB is that every cpu need to get the other
>>> cpus' load info repeatedly and try to figure out busiest sched
>>> group/queue on every sched domain level. but may not conduct a task
>>> moving, one of reasons is that cpu can only pull task, not pushing.
>>>
>>> 2, Consider huge cost of task moving: CS, tlb/cache refill, and the
>>> useless remote cpu load info getting. If we can have better solution for
>>> load balance, like reduce the balance times to.
>>> 	O(m) m := nr_tasks
>>>
>>> It will be a great win on performance. like above example, we can move
>>> task from cpu0 direct to another numa. that only need 1 task moving,
>>> save 3 CS and tlb/cache refill.
>>>
>>> To get this point, a rough idea is changing the load balance behaviour
>>> to top-down mode. Say let each of cpu report self load status on per-cpu
>>> memory. And a baby-sitter in system to collect these cpus load info,
>>> then decide how to move task centralize, finally send IPI to each hungry
>>> cpu to let them pull load quota from appointed cpus.
>>>
>>> Like in above example, the baby-sitter will fetch each cpus' load info,
>>> then send a pull task IPI to let a cpu in another numa pull one task
>>> from cpu0. So in the task pulling, we still just involved 2 cpus, can
>>> reuse move_tasks functions.
>>>
>>> BTW, the baby-sitter can care all kind of balance, regular balance, idle
>>> balance, wake up balance.
>>>
>>> 3, One of concern of top-down mode is that baby-sitter need remote

The new mode is more like a flat mode balance. But if numa access is
really unbearable, we may give a baby-sitter for each of NUMA node, then
reduce the numa balance frequency, and do more frequency internal numa
node balance. -- I hope that's not needed.
>>> access cpu load info on top domain level every times. But the fact is
>>> current load balance also need to get remote cpu load info for top level
>>> domain balance. and more worse, such remote accessing maybe useless.
>>> -- since there is just one thread reading the info, no competitor
>>> writer, Paul, do you think it is worthy concern?
> 
> Might be -- key thing is to measure it on a big system.  If it is a
> problem, here are some workarounds with varying degrees of sanity:
> 
> 1.	Reduce cache misses by keeping three values:
> 
> 	a.	Current load value.
> 	b.	Last exported value.  (Should be in same cache line
> 		as a.)
> 	c.	Exported value.  (Should be in separate cache line.)
> 
> 	The avoid writing to c unless a has deviated sufficiently from a.
> 	If the load values stay constant for long time periods, this
> 	can reduce the number of cache misses.  On the other hand,
> 	it introduces an extra compare and branch -- though this should
> 	not be a problem if the load value is computed relatively
> 	infrequently.
> 
> 2.	As above, but provide additional information to allow the
> 	other CPU to extrapolate values.  For example, if a CPU goes
> 	idle, some of its values will decay exponentially.  The
> 	remote CPU could compute the decay rate, removing the need
> 	for the subject CPU to wake up to recompute its value.
> 	(Maybe you already do this?)

The idle_cpus_mask should be one of additional info to allow
extrapolation action. As Vincent explained, this variable set when CPU
enter idle and cleared during next tick. So we mayn't need to look at
the cpu load for idle cpu.

And yes, current scheduler has similar behaviour.
> 
> 	Similarly if a CPU remains CPU-bound with given runqueue
> 	loading for some time.
> 
> 3.	Allow the exported values to become inaccurate, and resample
> 	the actual values remotely if extrapolated values indicate
> 	that action is warranted.

It is a very heuristic idea! Could you give a bit more hints/clues to
get remote cpu load by extrapolated value? I know RCU use this way
wonderfully. but still no much idea to get live cpu load...
> 
> There are probably other approaches.  I am being quite general here
> because I don't have the full picture of the scheduler statistics
> in my head.  It is likely possible to obtain a much better approach
> by considering the scheduler's specifics.
> 
>>> BTW, to reduce unnecessary remote info fetching, we can use current
>>> idle_cpus_mask in nohz, we just skip the idle cpu in this cpumask simply.

[..]
> 
> 							Thanx, Paul
> 
>>> 4, From power saving POV, top-down give the whole system cpu topology
>>> info directly. So beside the CS reducing, it can reduce the idle cpu
>>> interfere by a transition task. and let idle cpu sleep better.

-- 
Thanks
    Alex
