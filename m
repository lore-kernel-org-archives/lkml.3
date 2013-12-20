Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3LTOnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:43:53 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49946 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3LTOnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:43:51 -0500
Message-ID: <52B45791.4080009@linaro.org>
Date: Fri, 20 Dec 2013 22:43:29 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] sched: remove cpu_load decay
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org> <20131213200303.GI2480@laptop.programming.kicks-ass.net> <52AC5CDF.8050209@linaro.org> <20131217140457.GF10134@e103034-lin> <20131217153723.GO21999@twins.programming.kicks-ass.net> <20131217181255.GG28621@e103034-lin>
In-Reply-To: <20131217181255.GG28621@e103034-lin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for comments from Morten & Peter! :)

On 12/18/2013 02:12 AM, Morten Rasmussen wrote:
> On Tue, Dec 17, 2013 at 03:37:23PM +0000, Peter Zijlstra wrote:
>> On Tue, Dec 17, 2013 at 02:04:57PM +0000, Morten Rasmussen wrote:
>>> On Sat, Dec 14, 2013 at 01:27:59PM +0000, Alex Shi wrote:
>>>> On 12/14/2013 04:03 AM, Peter Zijlstra wrote:
>>>>>
>>>>>
>>>>> I had a quick peek at the actual patches.
>>>>>
>>>>> afaict we're now using weighted_cpuload() aka runnable_load_avg as the
>>>>> ->cpu_load. Whatever happened to also using the blocked_avg?
>>>
>>> AFAICT, ->cpu_load is actually a snapshot value of weigthed_cpuload()
>>> that gets updated occasionally. That has been the case since b92486cb.
>>> By removing the cpu_load indexes {source,target}_load are now comparing
>>> an old snapshot of weighted_cpuload() with the current value. I don't
>>> think that really makes sense. 
>>
>> Agreed, worse cpu_load is a very very recent snapshot, so there's not
>> been much chance to really diverge much between when we last looked at
>> it.
>>
>> [ for busy load-balance, for newidle there might be since we can run
>> between ticks ]
>>
>>> weighted_cpuload() may change rapidly
>>> when tasks are enqueued or dequeued so the old snapshot doesn't have
>>> much meaning in my opinion. Maybe I'm missing something?
>>
>> Right, which is where it makes sense to also account some of the blocked
>> load, since that anticipates these arrivals/departures and should smooth
>> out the over-all load pictures. Which is something that sounds right for
>> balancing.
>>
>> You don't want to really care too much about the high freq fluctuation,
>> but care more about the longer term load.
>>
>> Or rather -- and this is where the idx thing came from, you want a
>> longer term view the bigger your sched_domain is. Since that balances
>> nicely against the cost of actually moving tasks around.

As to blocked_load_avg, It looks like give some respect of left tasks.
But since there are many cpus in each sched domain. The chances for back
to same cpu is very limited. So forget that legacy, clear memory for new
tasks seems a better choice. And the previous trying also show this.

> 
> That makes sense.
> 
>>
>> And while runnable_load_avg still includes high freq arrival/departure
>> events, the runnable+blocked load should have much less of that.
> 
> Agreed, we either need a smooth version of runnable_load_avg or add the
> blocked load (given that we fix the priority issue).
> 
> There is actually another long-term view of the cpu load in
> rq->avg.runnable_avg_sum but I think it might be too conversative. Also
> it doesn't track the weight of the tasks on the cpu, just whether the
> cpu was idle or not.
> 
>>
>>> Comparing cpu_load indexes with different decay rates in {source,
>>> target}_load() sort of make sense as it makes load-balancing decisions
>>> more conservative.
>>
>> *nod*
>>
>>> I believe we have discussed using blocked_load_avg in weighted_cpuload()
>>> in the past. While it seems to be the right thing to include it, it
>>> causes problems related to the priority scaling of the task loads.
>>> If you include a blocked load in the weighted_cpuload() and have tiny
>>> (very low cpu utilization) task running at very high priority, your
>>> weighted_cpuload() will be quite high and force other normal priority
>>> tasks away from the cpu and leaving the cpu idle most of the time.
>>
>> Ah, right. Which is where we should look at balancing utilization as
>> well as weight.
>>
>> Let me ponder this a bit more.
> 
> Yes. At least for Android devices this is a big deal.
> 
> Would it be too invasive to have an unweighted_cpuload() for balancing
> utilization? It would require maintaining an unweighted version of
> runnable_load_avg and blocked load.
> 
> Maybe you have better ideas.
> 
>>
>>>>
>>>> When enabling the sched_avg in load balance, I didn't find any positive
>>>> testing result for several blocked_avg trying, just few regression. :(
>>>>
>>>> And since this patchset is almost clean up only, no blocked_load_avg
>>>> trying again...
>>>
>>> My worry here is that I don't really understand why the current code
>>> works when the decayed cpu_load has been removed.
>>
>> Not too much different from before I think; but it does loose the longer
>> term view on the bigger domains. That in turn makes it slightly more
>> agressive, which can be good or bad depending on the workload (good on
>> high spawn loads like hackbenchs, bad on more gentle stuff that has
>> cache footprint).

Yes, That is the point. :)
But I don't know why we need this long term view. the hackbench a bit
worse on Intel old core2 machine, -- even it is a bit out of date.
>>
>>>>> I totally hate patch 4; it seems like a random hack to make up for the
>>>>> lack of blocked_avg.
>>>>
>>>> Yes, this bias criteria seems a bit arbitrary. :)
>>>
>>> This is why I think {source, target}_load() and their use need to be
>>> reconsidered.
>>
>> Aside from that, there's something entirely wrong with 4 in that we
>> already have an imbalance between source and target loads, adding
>> another basically random imbalance pass on top of that just doesn't make
>> any kind of sense what so ff'ing ever.

My fault, I will reconsider more on this point.
> 
> Agreed.
> 
> Morten
> 


-- 
Thanks
    Alex
