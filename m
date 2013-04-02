Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab3DBE5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:57:39 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37928 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab3DBE5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:57:38 -0400
Message-ID: <515A64BB.5050005@linux.vnet.ibm.com>
Date: Tue, 02 Apr 2013 10:25:23 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] sched: don't consider upper se in sched_slice()
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com> <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com> <51553EF5.90702@linux.vnet.ibm.com> <20130401040820.GA12015@lge.com> <5159320C.4050903@linux.vnet.ibm.com> <20130402022556.GD16699@lge.com>
In-Reply-To: <20130402022556.GD16699@lge.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 13040204-5490-0000-0000-00000335C9FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On 04/02/2013 07:55 AM, Joonsoo Kim wrote:
> Hello, Preeti.
> 
> On Mon, Apr 01, 2013 at 12:36:52PM +0530, Preeti U Murthy wrote:
>> Hi Joonsoo,
>>
>> On 04/01/2013 09:38 AM, Joonsoo Kim wrote:
>>> Hello, Preeti.
>>>
>>
>>>>
>>>> Ideally the children's cpu share must add upto the parent's share.
>>>>
>>>
>>> I don't think so.
>>>
>>> We should schedule out the parent tg if 5ms is over. As we do so, we can
>>> fairly distribute time slice to every tg within short term. If we add
>>> the children's cpu share upto the parent's, the parent tg may have
>>> large time slice, so it cannot be preempted easily. There may be a latency
>>> problem if there are many tgs.
>>
>> In the case where the #running < sched_nr_latency, the children's
>> sched_slices add up to the parent's.
>>
>> A rq with two tgs,each with 3 tasks.
>>
>> Each of these tasks have a sched slice of
>> [(sysctl_sched_latency / 3) / 2] as of the present implementation.
>>
>> The sum of the above sched_slice of all tasks of a tg will lead to the
>> sched_slice of its parent: sysctl_sched_latency / 2
>>
>> This breaks when the nr_running on each tg > sched_nr_latency. However I
>> don't know if this is a good thing or a bad thing.
> 
> Ah.. Now I get your point. Yes, you are right and it may be good thing.
> With that property, all tasks in the system can be scheduled at least once
> in sysctl_sched_latency. sysctl_sched_latency is system-wide configuration,
> so my patch may be wrong. With my patch, all tasks in the system cannot be
> scheduled at least once in sysctl_sched_latency. Instead, it schedule
> all tasks in cfs_rq at least once in sysctl_sched_latency if there is
> no other tgs.

Exactly. You have got all the above points right.

> 
> I think that it is real problem that sysctl_sched_min_granularity is not
> guaranteed for each task.
> Instead of this patch, how about considering low bound?
> 
> if (slice < sysctl_sched_min_granularity)
> 	slice = sysctl_sched_min_granularity;

Consider the below scenario.

A runqueue has two task groups,each with 10 tasks.

With the current implementation,each of these tasks get a sched_slice of
2ms.Hence in a matter of (10*2) + (10*2) = 40 ms, all tasks( all tasks
of both the task groups) will get the chance to run.

But what is the scheduling period in this scenario? Is it 40ms (extended
sysctl_sched_latency), which is the scheduling period for each of the
runqueues with 10 tasks in it?
Or is it 80ms which is the total of the scheduling periods of each of
the run queues with 10 tasks.Either way all tasks seem to get scheduled
atleast once within the scheduling period.So we appear to be safe.
Although the sched_slice < sched_min_granularity.

With your above lower bound of sysctl_sched_min_granularity, each task
of each tg gets 4ms as its sched_slice.So in a matter of
(10*4) + (10*4) = 80ms,all tasks get to run. With the above question
being put forth here as well, we don't appear to be safe if the
scheduling_period is considered to be 40ms, otherwise it appears fine to
me, because it ensures the sched_slice is atleast sched_min_granularity
no matter what.


Thank you

Regards
Preeti U Murthy

