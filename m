Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbaJ3OmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:42:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41217 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737AbaJ3OmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:42:17 -0400
Message-ID: <54524E4E.9060504@arm.com>
Date: Thu, 30 Oct 2014 14:42:22 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: [PATCH 5/6] sched/dl: reschedule if successfully pull earlier
 deadline task
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com> <1414374067-7209-5-git-send-email-wanpeng.li@linux.intel.com> <5452110C.40108@arm.com> <20141030131259.GA474@kernel>
In-Reply-To: <20141030131259.GA474@kernel>
X-OriginalArrivalTime: 30 Oct 2014 14:42:14.0668 (UTC) FILETIME=[B23894C0:01CFF44F]
X-MC-Unique: 114103014421402901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 30/10/14 13:12, Wanpeng Li wrote:
> Hi Juri,
> On Thu, Oct 30, 2014 at 10:21:00AM +0000, Juri Lelli wrote:
>> Hi,
>>
>> On 27/10/14 01:41, Wanpeng Li wrote:
>>> Reschedule if successfully pull earlier deadline task.
>>>
>>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>>> ---
>>>  kernel/sched/deadline.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>>> index 97141e2..21de865 100644
>>> --- a/kernel/sched/deadline.c
>>> +++ b/kernel/sched/deadline.c
>>> @@ -1583,8 +1583,8 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
>>>  	 * this is the right place to try to pull some other one
>>>  	 * from an overloaded cpu, if any.
>>>  	 */
>>> -	if (!rq->dl.dl_nr_running)
>>> -		pull_dl_task(rq);
>>> +	if (!rq->dl.dl_nr_running && pull_dl_task(rq))
>>> +			resched_curr(rq);
>>
>> Right, we have to reschedule. But, how about we fully align to -rt?
>>
>> Peter, is the task_on_rq_queued() check for cases in which p is not
>> enqueued but its class changes after a setscheduler/rt_mutex_setprio?
>>
>> Thanks,
>>
>> - Juri
>>
>> >From 404749782e493cb6019193f347163b640ebd552d Mon Sep 17 00:00:00 2001
>> From: Juri Lelli <juri.lelli@arm.com>
>> Date: Thu, 30 Oct 2014 10:15:40 +0000
>> Subject: [PATCH] sched/deadline: reschedule from switched_from_dl() after a
>> successful pull
>>
>> In switched_from_dl() we have to issue a resched if we
>> successfully pulled some task from other cpus.
>> This patch also aligns the behaviour with -rt.
>>
> 
> Good idea.
> 
>> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
> 
> I will send out version two of this patchset with the update of 2/6 and
> 5/6 with *your Suggested-by*. Thanks for your great proposal. ;-)
> 

Well, I've actually *wrote* (especially 2/6 is a different fix w.r.t.
your version) and *tested* the updates . But, I'm not really getting
anxious about signing patches, so fair enough.

Thanks,

- Juri

> Regards,
> Wanpeng Li
> 
>> Suggested-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>> kernel/sched/deadline.c | 7 +++++--
>> 1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index db6ad38..e8943fc 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -1623,8 +1623,11 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
>> 	 * this is the right place to try to pull some other one
>> 	 * from an overloaded cpu, if any.
>> 	 */
>> -	if (!rq->dl.dl_nr_running)
>> -		pull_dl_task(rq);
>> +	if (!task_on_rq_queued(p) || rq->dl.dl_nr_running)
>> +		return;
>> +
>> +	if (pull_dl_task(rq))
>> +		resched_curr(rq);
>> #endif
>> }
>>
>> -- 
>> 2.1.2
> 

