Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3DAGrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:47:23 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:44762 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab3DAGrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:47:20 -0400
Message-ID: <51592D1E.7030707@linux.vnet.ibm.com>
Date: Mon, 01 Apr 2013 12:15:50 +0530
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
Subject: Re: [PATCH 5/5] sched: limit sched_slice if it is more than sysctl_sched_latency
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com> <1364457537-15114-6-git-send-email-iamjoonsoo.kim@lge.com> <51557C89.4070201@linux.vnet.ibm.com> <20130401050926.GB12015@lge.com>
In-Reply-To: <20130401050926.GB12015@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040106-5564-0000-0000-0000074FA9CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On 04/01/2013 10:39 AM, Joonsoo Kim wrote:
> Hello Preeti.
> So we should limit this possible weird situation.
>>>
>>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index e232421..6ceffbc 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -645,6 +645,9 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>>>  	}
>>>  	slice = calc_delta_mine(slice, se->load.weight, load);
>>>
>>> +	if (unlikely(slice > sysctl_sched_latency))
>>> +		slice = sysctl_sched_latency;
>>
>> Then in this case the highest priority thread would get
>> 20ms(sysctl_sched_latency), and the rest would get
>> sysctl_sched_min_granularity * 10 * (1024/97977) which would be 0.4ms.
>> Then all tasks would get scheduled ateast once within 20ms + (0.4*9) ms
>> = 23.7ms, while your scheduling latency period was extended to 40ms,just
>> so that each of these tasks don't have their sched_slices shrunk due to
>> large number of tasks.
> 
> I don't know I understand your question correctly.
> I will do my best to answer your comment. :)
> 
> With this patch, I just limit maximum slice at one time. Scheduling is
> controlled through the vruntime. So, in this case, the task with nice -20
> will be scheduled twice.
> 
> 20 + (0.4 * 9) + 20 = 43.9 ms
> 
> And after 43.9 ms, this process is repeated.
> 
> So I can tell you that scheduling period is preserved as before.
> 
> If we give a long period to a task at one go, it can cause
> a latency problem. So IMHO, limiting this is meaningful.

Thank you very much for the explanation. Just one question. What is the
reason behind you choosing sysctl_sched_latency as the upper bound here?

Regards
Preeti U Murthy

