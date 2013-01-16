Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3APGBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:01:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:43466 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab3APGBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:01:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="272617485"
Message-ID: <50F6426D.7030201@intel.com>
Date: Wed, 16 Jan 2013 14:02:21 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 16/22] sched: add power aware scheduling in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-17-git-send-email-alex.shi@intel.com> <20130110150108.GF2046@e103034-lin> <50EFBA7D.5070907@intel.com> <20130114160934.GA8528@e103034-lin>
In-Reply-To: <20130114160934.GA8528@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 12:09 AM, Morten Rasmussen wrote:
> On Fri, Jan 11, 2013 at 07:08:45AM +0000, Alex Shi wrote:
>> On 01/10/2013 11:01 PM, Morten Rasmussen wrote:
>>> On Sat, Jan 05, 2013 at 08:37:45AM +0000, Alex Shi wrote:
>>>> This patch add power aware scheduling in fork/exec/wake. It try to
>>>> select cpu from the busiest while still has utilization group. That's
>>>> will save power for other groups.
>>>>
>>>> The trade off is adding a power aware statistics collection in group
>>>> seeking. But since the collection just happened in power scheduling
>>>> eligible condition, the worst case of hackbench testing just drops
>>>> about 2% with powersaving/balance policy. No clear change for
>>>> performance policy.
>>>>
>>>> I had tried to use rq load avg utilisation in this balancing, but since
>>>> the utilisation need much time to accumulate itself. It's unfit for any
>>>> burst balancing. So I use nr_running as instant rq utilisation.
>>>
>>> So you effective use a mix of nr_running (counting tasks) and PJT's
>>> tracked load for balancing?
>>
>> no, just task number here.
>>>
>>> The problem of slow reaction time of the tracked load a cpu/rq is an
>>> interesting one. Would it be possible to use it if you maintained a
>>> sched group runnable_load_avg similar to cfs_rq->runnable_load_avg where
>>> load contribution of a tasks is added when a task is enqueued and
>>> removed again if it migrates to another cpu?
>>> This way you would know the new load of the sched group/domain instantly
>>> when you migrate a task there. It might not be precise as the load
>>> contribution of the task to some extend depends on the load of the cpu
>>> where it is running. But it would probably be a fair estimate, which is
>>> quite likely to be better than just counting tasks (nr_running).
>>
>> For power consideration scenario, it ask task number less than Lcpu
>> number, don't care the load weight, since whatever the load weight, the
>> task only can burn one LCPU.
>>
> 
> True, but you miss the opportunities for power saving when you have many
> light tasks (> LCPU). Currently, the sd_utils < threshold check will go
> for SCHED_POLICY_PERFORMANCE if the number tasks (sd_utils) is greater
> than the domain weight/capacity irrespective of the actual load caused
> by those tasks.
> 
> If you used tracked task load weight for sd_utils instead you would be
> able to go for power saving in scenarios with many light tasks as well.

yes, that's right on power consideration. but for performance consider,
it's better to spread tasks on different LCPU to save CS cost. And if
the cpu usage is nearly full, we don't know if some tasks real want more
cpu time.
Even in the power sched policy, we still want to get better performance
if it's possible. :)
> 
>>>> +
>>>> +		if (sched_policy == SCHED_POLICY_POWERSAVING)
>>>> +			threshold = sgs.group_weight;
>>>> +		else
>>>> +			threshold = sgs.group_capacity;
>>>
>>> Is group_capacity larger or smaller than group_weight on your platform?
>>
>> Guess most of your confusing come from the capacity != weight here.
>>
>> In most of Intel CPU, a cpu core's power(with 2 HT) is usually 1178, it
>> just bigger than a normal cpu power - 1024. but the capacity is still 1,
>> while the group weight is 2.
>>
> 
> Thanks for clarifying. To the best of my knowledge there are no
> guidelines for how to specify cpu power so it may be a bit dangerous to
> assume that capacity < weight when capacity is based on cpu power.

Sure. I also just got them from code. and don't know other arch how to
different them.
but currently, seems this cpu power concept works fine.
> 
> You could have architectures where the cpu power of each LCPU (HT, core,
> cpu, whatever LCPU is on the particular platform) is greater than 1024
> for most LCPUs. In that case, the capacity < weight assumption fails.
> Also, on non-HT systems it is quite likely that you will have capacity =
> weight.

yes.
> 
> Morten
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 


-- 
Thanks Alex
