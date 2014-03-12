Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaCLKgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:36:32 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36962 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaCLKga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:36:30 -0400
Message-ID: <5320389B.5030806@linaro.org>
Date: Wed, 12 Mar 2014 18:36:11 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, james.hogan@imgtec.com,
        jason.low2@hp.com, viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: Re: [PATCH 04/11] sched: unify imbalance bias for target group
References: <1393293054-11378-1-git-send-email-alex.shi@linaro.org> <1393293054-11378-5-git-send-email-alex.shi@linaro.org> <20140225141407.GT9987@twins.programming.kicks-ass.net> <530E0531.7000303@linaro.org>
In-Reply-To: <530E0531.7000303@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 11:16 PM, Alex Shi wrote:
>> > So this patch is weird..
>> > 
>> > So the original bias in the source/target load is purely based on actual
>> > load figures. It only pulls-down/pulls-up resp. the long term avg with a
>> > shorter term average; iow. it allows the source to decrease faster and
>> > the target to increase faster, giving a natural inertia (ie. a
>> > resistance to movement).
>> > 
>> > Therefore this gives rise to a conservative imbalance.
>> > 
>> > Then at the end we use the imbalance_pct thing as a normal hysteresis
>> > control to avoid the rapid state switching associated with a single
>> > control point system.
> Peter, Thanks response and detailed explanations! :)
> 
> Yes, fixed bias can not replace the current bias.
> If we said sth inertia, we usually mean the previous value or long term
> value here. but source/target_load doesn't prefer a long term or shorter
> term load, Just get the min or max of them. so I can't see other meaning
> except source/target bias. And the long term load is a decayed load with
> history load value, not a real actual load.
> 
> And in current logical, assume the load of cpu is constant in a period,
> then the source/target_load will lose its 'resistance' function for
> balance. Considering the moving cost, rq locking and potential cpu cache
> missing, Is some bias needed here?
> 
> Another problem is, we bias load twice for busy_idx scenario. once in
> source/target_load another is imbalance_pct in find_busiest_group. I
> can't figure out the reason. :(
> 
> So would rather select a random long/shorter term load, than maybe it's
> better to use a fixed bias, like in current NUMA balancing, and in
> newidle/wake balance.
> 


May I didn't say clear about the issue of cpu_load. So forgive my
verbose explanation again.

In 5 cpu load idx, only busy_idx and idle_idx are not zero, only they
are using long term load value.

The other idxes, wake_idx, forexec_idx and new_idle_idx are all zero.
They are using imbalance_pct as fixed bias consideration *only*, as well
as in numa balancing.

As to busy_idx,
We considered the cpu load history and src/dst bias both. But we are
wrong to mix them together. Considering long/short term load isn't
related with bias. The long term load consideration is done in runnable
load avg. And the bias value should be isolated and based on task
migration cost between cpu/groups.
Now we mix them together, the ridiculous thing is, when all cpu load are
continuous stable, long/short term load is same. then we lose the bias
meaning, so any minimum imbalance may cause unnecessary task moving. To
prevent this funny thing happen, we have to reuse the imbalance_pct
again in find_busiest_group().  But That clearly causes over bias in
normal time. If there are some burst load in system, it is more worse.

As to idle_idx, it is not use imbalance_pct at all.
Since short term load is zero, so it looks clearly, we pretend we are
long term load when cpu in dst group. or zero load, when cpu in src
group. But from maximum performance point view. It's better to balance
task to idle cpu. So we'd better to move tasks to dst group unless the
moving cost is beyond task migration cost, that is the imbalance_pct
for. Now pretending we have some load in dst group rejects the incoming
load we pretend have. And It also prefer to move task to long time idle
cpu, that actually costs performance/latency both since low latency of
deep c-state waking.
Anyway, for idle cpu load balance, since we are working on cpu idle
migration into scheduler. The problem must be reconsidered. We don't
need to care much now.


Base on above reasons, I believe mixing long term load with task moving
bias consideration is stupid. And I admit the imbalance_pct need more
tuning or even remake, but it is not a bad start, at least it is used in
balance anywhere now.


-- 
Thanks
    Alex
