Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaFKGN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 02:13:57 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48299 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaFKGN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 02:13:56 -0400
Message-ID: <5397F396.2060801@linux.vnet.ibm.com>
Date: Wed, 11 Jun 2014 14:13:42 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <20140515083531.GE30445@twins.programming.kicks-ass.net> <53747EE4.3020605@linux.vnet.ibm.com> <20140515090638.GI30445@twins.programming.kicks-ass.net> <53748A5D.6070605@linux.vnet.ibm.com> <20140515115751.GK30445@twins.programming.kicks-ass.net> <5375768F.1010000@linux.vnet.ibm.com> <1400208690.7133.11.camel@marge.simpson.net> <53759303.40409@linux.vnet.ibm.com> <20140516075421.GL11096@twins.programming.kicks-ass.net> <5396C82C.6060101@linux.vnet.ibm.com> <20140610121222.GE6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140610121222.GE6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061106-1396-0000-0000-00000500C7C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

Thanks for the reply :)

On 06/10/2014 08:12 PM, Peter Zijlstra wrote:
[snip]
>> Wake-affine for sure pull tasks together for workload like dbench, what make
>> it difference when put dbench into a group one level deeper is the
>> load-balance, which happened less.
> 
> We load-balance less (frequently) or we migrate less tasks due to
> load-balancing ?

IMHO, when we put tasks one group deeper, in other word the totally
weight of these tasks is 1024 (prev is 3072), the load become more
balancing in root, which make bl-routine consider the system is
balanced, which make we migrate less in lb-routine.

> 
>> Usually, when system is busy, during the wakeup when we could not locate
>> idle cpu, we pick the search point instead, whatever how busy it is since
>> we count on the balance routine later to help balance the load.
> 
> But above you said that dbench usually triggers the wake-affine logic,
> but now you say it doesn't and we rely on select_idle_sibling?

During wakeup, it triggered wake-affine, after that, go inside
select_idle_sibling() and found no idle cpu, than pick the search point
instead (curr cpu if wake-affine or prev cpu if not).

> 
> Note that the comparison isn't fair, running dbench on an idle system vs
> running dbench on a busy system is the first step.

Our comparison is based on the same busy-system, all the two cases have
the same workload running, the only difference is that we put the same
workload (dbench + stress) one group deeper, it's like:

Good case:
		root
		l1-A	l1-B	l1-C
		dbench	stress	stress

	results:
		dbench got around 300%
		each stress got around 450%

Bad case:
		root
		l1
		l2-A	l2-B	l2-C
		dbench	stress	stress

	results:
		dbench got around 100% (throughout dropped too)
		each stress got around 550%

Although the l1-group gain the same resources (1200%), it doesn't assign
to l2-ABC correctly like the root-group did.

> 
> The second is adding the cgroup crap on.
> 
>> However, in our cases the load balance could not help on that, since deeper
>> the group is, less the load effect it means to root group.
> 
> But since all actual load is on the same depth, the relative threshold
> (imbalance pct) should work the same, the size of the values don't
> matter, the relative ratios do.

Exactly, however, when group is deep, the chance of it to make root
imbalance reduced, in good case, gathered on cpu means 1024 load, while
in bad case it dropped to 1024/3 ideally, that make it harder to trigger
imbalance and gain help from the routine, please note that although
dbench and stress are the only workload in system, there are still other
tasks serve for the system need to be wakeup (some very actively since
the dbench...), compared to them, deep group load means nothing...

> 
>> By which means even tasks in deep group all gathered on one CPU, the load
>> could still balanced from the view of root group, and the tasks lost the
>> only chances (balance) to spread when they already on the same CPU...
> 
> Sure, but see above.

The lb-routine could not provide enough help for deep group, since the
imbalance happened inside the group could not cause imbalance in root,
ideally each l2-task will gain 1024/18 ~= 56 root-load, which could be
easily ignored, but inside the l2-group, the gathered case could already
means imbalance like (1024 * 5) : 1024.

> 
>> Furthermore, for tasks flip frequently like dbench, it'll become far more
>> harder for load balance to help, it could even rarely catch them on rq.
> 
> And I suspect that is the main problem; so see what it does on a busy
> system: !cgroup: nr_cpus busy loops + dbench, because that's your
> benchmark for adding cgroups, the cgroup can only shift that behaviour
> around.

There are busy loops in good case too, and dbench behaviour in l1-groups
should not changed after put them to l2-group, what make things worse is
the chance for them to spread after gathered become less.

> 
[snip]
>> Below patch has solved the problem during the testing, I'd like to do more
>> testing on other benchmarks before send out the formal patch, any comments
>> are welcomed ;-)
> 
> So I think that approach is wrong, select_idle_siblings() works because
> we want to keep CPUs from being idle, but if they're not actually idle,
> pretending like they are (in a cgroup) is actively wrong and can skew
> load pretty bad.

We only choose the timing when no idle cpu located, and flips is
somewhat high, also the group is deep.

In such cases, select_idle_siblings() doesn't works anyway, it return
the target even it is very busy, we just check twice to prevent it from
making some obviously bad decision ;-)

> 
> Furthermore, if as I expect, dbench sucks on a busy system, then the
> proposed cgroup thing is wrong, as a cgroup isn't supposed to radically
> alter behaviour like that.

That's true and that's why we currently still need to shut down the
GENTLE_FAIR_SLEEPERS feature, but that's another problem we need to
solve later...

What we currently expect is that the cgroup assign the resource
according to the share, it works well in l1-groups, so we expect it to
work the same well in l2-groups...

> 
> More so, I suspect that patch will tend to overload cpu0 (and lower cpu
> numbers in general -- because its scanning in the same direction for
> each cgroup) for other workloads. You can't just go pile more and more
> work on cpu0 just because there's nothing running in this particular
> cgroup.

That's a good point...

However during the testing, this doesn't happen on the 3 groups, tasks
stay on high-cpu as often as low-cpu, IMHO the key point here is the
lb-routine still works, although much less than before.

So the fix just make the result of lb-routine effect longer, since the
higher cpu it picked is usually idle in group (directly pick later), in
other word, tasks on high-cpu is harder to be wake-affine to low-cpu
than before.

And when this apply to all the groups, each of them will be balanced
both internally and externally, then we will see equal tasks on each cpu.

select_idle_sibling() do pick low-cpu more often, and combined with
wake-affine, without enough load-balance, the tasks will gathered on
low-cpu more often, but our solution will make the less load-balance
become more valuable (when they need to be), IMHO, it could even
contribute to balance work in some cases...

> 
> So dbench is very sensitive to queueing, and select_idle_siblings()
> avoids a lot of queueing on an idle system. I don't think that's
> something we should fix with cgroups.

It has to queue anyway after wakeup, isn't it? we just want a good
candidate which won't make things too bad inside group, and only do this
when select_idle_siblings() give up on searching...

Regards,
Michael Wang

> 

