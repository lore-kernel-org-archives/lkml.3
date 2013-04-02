Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab3DBReW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:34:22 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37527 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759008Ab3DBReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:34:19 -0400
Message-ID: <515B163B.8050509@linux.vnet.ibm.com>
Date: Tue, 02 Apr 2013 23:02:43 +0530
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
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com> <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com> <51553EF5.90702@linux.vnet.ibm.com> <20130401040820.GA12015@lge.com> <5159320C.4050903@linux.vnet.ibm.com> <20130402022556.GD16699@lge.com> <515A64BB.5050005@linux.vnet.ibm.com> <20130402092647.GE16699@lge.com>
In-Reply-To: <20130402092647.GE16699@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040217-1618-0000-0000-0000039D6C50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,


>>> I think that it is real problem that sysctl_sched_min_granularity is not
>>> guaranteed for each task.
>>> Instead of this patch, how about considering low bound?
>>>
>>> if (slice < sysctl_sched_min_granularity)
>>> 	slice = sysctl_sched_min_granularity;
>>
>> Consider the below scenario.
>>
>> A runqueue has two task groups,each with 10 tasks.
>>
>> With the current implementation,each of these tasks get a sched_slice of
>> 2ms.Hence in a matter of (10*2) + (10*2) = 40 ms, all tasks( all tasks
>> of both the task groups) will get the chance to run.
>>
>> But what is the scheduling period in this scenario? Is it 40ms (extended
>> sysctl_sched_latency), which is the scheduling period for each of the
>> runqueues with 10 tasks in it?
>> Or is it 80ms which is the total of the scheduling periods of each of
>> the run queues with 10 tasks.Either way all tasks seem to get scheduled
>> atleast once within the scheduling period.So we appear to be safe.
>> Although the sched_slice < sched_min_granularity.
>>
>> With your above lower bound of sysctl_sched_min_granularity, each task
>> of each tg gets 4ms as its sched_slice.So in a matter of
>> (10*4) + (10*4) = 80ms,all tasks get to run. With the above question
>> being put forth here as well, we don't appear to be safe if the
>> scheduling_period is considered to be 40ms, otherwise it appears fine to
>> me, because it ensures the sched_slice is atleast sched_min_granularity
>> no matter what.
> 
> So, you mean that we should guarantee to schedule each task atleast once
> in sysctl_sched_latency? 

I would rather say all tasks get to run atleast once in a sched_period,
which could be just sysctl_sched_latency or more depending on the number
of tasks in the current implementation.

But this is not guaranteed in current code,
> this is why I made this patch. Please refer a patch description.

Ok,take the example of a runqueue with 2 task groups,each with 10
tasks.Same as your previous example. Can you explain how your patch
ensures that all 20 tasks get to run atleast once in a sched_period?

Regards
Preeti U Murthy

