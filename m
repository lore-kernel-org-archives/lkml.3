Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaIDJZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:25:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53020 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaIDJZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:25:29 -0400
Message-ID: <54083019.4060907@arm.com>
Date: Thu, 04 Sep 2014 10:25:45 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Luca Abeni <luca.abeni@unitn.it>, Henrik Austad <henrik@austad.us>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] Documentation/scheduler/sched-deadline.txt: improve
 and clarify AC bits
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com> <1409220029-9002-4-git-send-email-juri.lelli@arm.com> <20140902214538.GC22581@sisyphus.home.austad.us> <5406BA02.20806@unitn.it> <5406DCE6.7@arm.com>
In-Reply-To: <5406DCE6.7@arm.com>
X-OriginalArrivalTime: 04 Sep 2014 09:25:25.0070 (UTC) FILETIME=[287C1EE0:01CFC822]
X-MC-Unique: 114090410252706101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/09/14 10:18, Juri Lelli wrote:
> Hi,
> 
> On 03/09/14 07:49, Luca Abeni wrote:
>> Hi,
>>
>> On 09/02/2014 11:45 PM, Henrik Austad wrote:
>> [...]
>>>> + On multiprocessor systems with global EDF scheduling (non partitioned
>>>> + systems), a sufficient test for schedulability can not be based on the
>>>> + utilisations (it can be shown that task sets with utilisations slightly
>>>> + larger than 1 can miss deadlines regardless of the number of CPUs M).
>>>> + However, as previously stated, enforcing that the total utilisation is smaller
>>>> + than M is enough to guarantee that non real-time tasks are not starved and
>>>> + that the tardiness of real-time tasks has an upper bound.
>>>
>>> I'd _really_ appreciate a link to a paper where all of this is presented
>>> and proved!
>> Well, my original plan was to add the bibliography in the next round of patches...
>> Is this ok?
>>
>> [...]
>>>> + As already stated in Section 3, a necessary condition to be respected to
>>>> + correctly schedule a set of real-time tasks is that the total utilisation
>>>> + is smaller than M. When talking about -deadline tasks, this requires to
>>>> + impose that the sum of the ratio between runtime and period for all tasks
>>>> + is smaller than M.
>>>
>>> "This requires to impose that .." uhm, what? Drop 'to impose'.
>> Ok. I'll send an updated patch to Juri in few days
>>
>>
>>>> [...] Notice that the ratio runtime/period is equivalent to
>>>> + the utilisation of a "traditional" real-time task, and is also often
>>>> + referred to as "bandwidth".
>>>> + The interface used to control the CPU bandwidth that can be allocated
>>>> + to -deadline tasks is similar to the one already used for -rt
>>>>    tasks with real-time group scheduling (a.k.a. RT-throttling - see
>>>>    Documentation/scheduler/sched-rt-group.txt), and is based on readable/
>>>>    writable control files located in procfs (for system wide settings).
>>>> @@ -232,8 +285,16 @@ CONTENTS
>>>>    950000. With rt_period equal to 1000000, by default, it means that -deadline
>>>>    tasks can use at most 95%, multiplied by the number of CPUs that compose the
>>>>    root_domain, for each root_domain.
>>>> -
>>>> - A -deadline task cannot fork.
>>>> + This means that non -deadline tasks will receive at least 5% of the CPU time,
>>>> + and that -deadline tasks will receive their runtime with a guaranteed
>>>> + worst-case delay respect to the "deadline" parameter. If "deadline" = "period"
>>>> + and the cpuset mechanism is used to implement partitioned scheduling (see
>>>> + Section 5), then this simple setting of the bandwidth management is able to
>>>> + deterministically guarantee that -deadline tasks will receive their runtime
>>>> + in a period.
>>>
>>> The whole 950000 / 1000000, is at least 50 *consecutive* ms given to non
>>> rt/dl tasks every second, or is this more finegrained now?
>>>
>>> If the 50ms can be given in a single go, then I don't think you can
>>> guarantee that deadline-tasks will receive their runtime in a period - a
>>> period can be <50ms, no?
>> Uhmm... Maybe there is something I am missing in how the SCHED_DEADLINE admission
>> control is implemented, but I do not know about any "50 consecutive ms to non dl
>> tasks" rule. I agree that if there is such a rule then deadline tasks are screwed.
>> Juri?
>>
>>
> 
> In SCHED_DEADLINE we use those values only at admission control time (when
> the user calls sched_setattr()). Then, at runtime, we use tasks' parameters
> to perform scheduling. So there is no consecutive 50ms time for !SCHED_DEADLINE
> tasks.
> 
> We could probably clarify this aspect in the previous patch with something
> like this:
> 
> [snip]
> + The interface used to control the fraction of CPU bandwidth that can be
> + allocated to -deadline tasks is similar to the one already used for -rt
> + tasks with real-time group scheduling (a.k.a. RT-throttling - see
> + Documentation/scheduler/sched-rt-group.txt), and is based on readable/
> + writable control files located in procfs (for system wide settings).
> + Notice that per-group settings (controlled through cgroupfs) are still not
> + defined for -deadline tasks, because more discussion is needed in order to
> + figure out how we want to manage SCHED_DEADLINE bandwidth at the task group
> + level.
> +
> + A main difference between deadline bandwidth management and RT-throttling
>   is that -deadline tasks have bandwidth on their own (while -rt ones don't!),
> - and thus we don't need an higher level throttling mechanism to enforce the
> - desired bandwidth.
> + and thus we don't need a higher level throttling mechanism to enforce the
> ---->
> + desired bandwidth. In other words, this means that interface parameters are
> + only used at admission control time (i.e., when the user calls
> + sched_setattr()). Scheduling is then performed considering actual tasks'
> + parameters, so that CPU bandwidth is allocated to SCHED_DEADLINE tasks
> + respecting their needs in terms of granularity. Therefore, using this simple
> <---
> + interface we can put a cap on total utilization of -deadline tasks (i.e.,
> + \Sum (runtime_i / period_i) < some_desired_value).
> [snip]
> 
> What you think?
> 

As agreed on IRC I fixed this, and the other typos.

Thanks,

- Juri

>>>> + Finally, notice that in order not to jeopardize this admission control a
>>>> + -deadline task cannot fork.
>>>
>>> s/this/the
>>> (there aren't any other admission controls in the kernel)
>> Ok; this will go in my updated patch
>>
>>
>>
>> 			Thanks,
>> 				Luca
>>
> 
> 

