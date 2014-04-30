Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbaD3JY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:24:59 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60746 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516AbaD3JY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:24:56 -0400
Message-ID: <5360C15B.9060608@linaro.org>
Date: Wed, 30 Apr 2014 17:24:43 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org> <20140429145221.GH2639@e103034-lin>
In-Reply-To: <20140429145221.GH2639@e103034-lin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 10:52 PM, Morten Rasmussen wrote:
> On Wed, Apr 16, 2014 at 03:43:21AM +0100, Alex Shi wrote:
>> In the cpu_load decay usage, we mixed the long term, short term load with
>> balance bias, randomly pick a big or small value according to balance 
>> destination or source.
> 
> I disagree that it is random. min()/max() in {source,target}_load()
> provides a conservative bias to the load estimate that should prevent us
> from trying to pull tasks from the source cpu if its current load is
> just a temporary spike. Likewise, we don't try to pull tasks to the
> target cpu if the load is just a temporary drop.

Thanks a lot for review, Morten!

A temporary spike load should be very small bases its runnable load. It
can not cause much impact.
Here the random refer to short term or long term load selection.

> 
>> This mix is wrong, the balance bias should be based
>> on task moving cost between cpu groups, not on random history or instant load.
> 
> Your patch set actually changes everything to be based on the instant
> load alone. rq->cfs.runnable_load_avg is updated instantaneously when
> tasks are enqueued and deqeueue, so this load expression is quite volatile.

Seems we are backing to the predication correction argument. :)

The runnable load is not instant with runnable consideration. And no
testing show that taking too much history load will lead to a better
balance. Current cpu_load[] are decayed with different degree level. And
there is no good reason to support the different level decay setting
after runnable load involved.

> 
> What do you mean by "task moving cost"?

I mean the possible LL cache missing, and memory access latency on
different NUMA after a task move to other cpu.

> 
>> History load maybe diverage a lot from real load, that lead to incorrect bias.
>>
>> like on busy_idx,
>> We mix history load decay and bias together. The ridiculous thing is, when 
>> all cpu load are continuous stable, long/short term load is same. then we 
>> lose the bias meaning, so any minimum imbalance may cause unnecessary task
>> moving. To prevent this funny thing happen, we have to reuse the 
>> imbalance_pct again in find_busiest_group().  But that clearly causes over
>> bias in normal time. If there are some burst load in system, it is more worse.
> 
> Isn't imbalance_pct only used once in the periodic load-balance path?

Yes, but we already used source/target_load bias. Then, we have biased
twice. that is over bias.

> 
> It is not clear to me what the over bias problem is. If you have a
> stable situation, I would expect the long and short term load to be the
> same?

yes, long/short term load is same, then source/taget_load is same, then
any minimum temporary load change can cause rebalance, that is bad
considering the relative bigger task moving cost. so current code still
need add imbalance_pct to prevent such things happen. Using both
source/target load bias and imbalance pct bias is over bias.

> 
>> As to idle_idx:
>> Though I have some cencern of usage corretion, 
>> https://lkml.org/lkml/2014/3/12/247 but since we are working on cpu
>> idle migration into scheduler. The problem will be reconsidered. We don't
>> need to care it too much now.
>>
>> In fact, the cpu_load decays can be replaced by the sched_avg decay, that 
>> also decays load on time. The balance bias part can fullly use fixed bias --
>> imbalance_pct, which is already used in newly idle, wake, forkexec balancing
>> and numa balancing scenarios.
> 
> As I have said previously, I agree that cpu_load[] is somewhat broken in
> its current form, but I don't see how removing it and replacing it with
> the instantaneous cpu load solves the problems you point out.

I am glad that we get an agreement on the cpu_load[] is inappropriate. :)

Actually, this patchset just remove it and use the cpu load which
considered the runnable info, not 'instantaneous'.

> 
> The current cpu_load[] averages the cpu_load over time, while
> rq->cfs.runnable_load_avg is the sum of the currently runnable tasks'
> load_avg_contrib. The former provides a long term view of the cpu_load,

It doesn't. it may or may not use the long term load, just according to
which load is bigger or smaller. It just pretend to consider the long
term load status. but may drop it.

> the latter does not. It can change radically in an instant. I'm
> therefore a bit concerned about the stability of the load-balance
> decisions. However, since most decisions are based on cpu_load[0]
> anyway, we could try setting LB_BIAS to false as Peter suggests and see
> what happens.


Maybe the predication is reasonable on per task history. but on a cpu
load history, with many tasks rebalance. No testing show current method
is helpful.

For task load change, scheduler has no idea for its future except guess
from its history. but for cpu load change, scheduler know this from task
wakeup and balance, which both under control and its aim.


I think the first patch of this serial has the same effect of LB_LIAS
disable. and previous result show performance is good.

Anyway, I just pushed the following patch to github, maybe fengguang's
testing system will care this.

diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 5716929..0bf649f 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -43,7 +43,7 @@ SCHED_FEAT(ARCH_POWER, true)

 SCHED_FEAT(HRTICK, false)
 SCHED_FEAT(DOUBLE_TICK, false)
-SCHED_FEAT(LB_BIAS, true)
+SCHED_FEAT(LB_BIAS, false)


-- 
Thanks
    Alex
