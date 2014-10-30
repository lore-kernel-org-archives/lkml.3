Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbaJ3KEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:04:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35768 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaJ3KED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:04:03 -0400
Message-ID: <54520D13.7020904@arm.com>
Date: Thu, 30 Oct 2014 10:04:03 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <kernellwp@gmail.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: [PATCH 2/6] sched/dl: fix yield task artificial overrun
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com> <1414374067-7209-2-git-send-email-wanpeng.li@linux.intel.com> <545116F7.7080607@arm.com> <54516F0F.7000901@gmail.com>
In-Reply-To: <54516F0F.7000901@gmail.com>
X-OriginalArrivalTime: 30 Oct 2014 10:03:56.0036 (UTC) FILETIME=[D10F8C40:01CFF428]
X-MC-Unique: 114103010035701501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 29/10/14 22:49, Wanpeng Li wrote:
> Hi Juri,
> 2014/10/30 0:33, Juri Lelli:
>> Hi,
>>
>> On 27/10/14 01:41, Wanpeng Li wrote:
>>> The yield semantic of deadline class is to reduce remaining runtime to
>>> zero, and then update_curr_dl() will stop it. However, comsumed bandwidth
>>> is reduced from the budget of yield task again even if it has already been
>>> set to zero which leads to artificial overrun. This patch fix it by reduce
>>> remaining runtime to zero if there is still remaining runtime after comsumed
>>> bandwidth is accumulated.
>>>
>> Oh, right. But, how about what below instead (with a proper comment
>> and changelog)?
>>
>> Thanks,
>>
>> - Juri
>>
>>  From 108ecdff52b154ea2c79d4aac552ddf1ead871c7 Mon Sep 17 00:00:00 2001
>> From: Juri Lelli <juri.lelli@arm.com>
>> Date: Wed, 29 Oct 2014 16:09:06 +0000
>> Subject: [PATCH] sched/deadline: fix artificial overrun introduced by
>>   yield_task_dl
>>
>> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
>> ---
>>   kernel/sched/deadline.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index 2e31a30..db6ad38 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -633,7 +633,7 @@ static void update_curr_dl(struct rq *rq)
>>   
>>   	sched_rt_avg_update(rq, delta_exec);
>>   
>> -	dl_se->runtime -= delta_exec;
>> +	dl_se->runtime -= dl_se->dl_yielded ? 0 : delta_exec;
> 
> +	if (dl_se->dl_yielded && dl_se->runtime > 0)
> +		dl_se->runtime = 0;
> 

We already did this in yield_task_dl(). In update_curr_dl() we now
just have to make sure we don't steal some more runtime from the
task that yielded (but we do all other accounting).

Thanks,

- Juri

> Maybe this can be moved to update_curr_dl().
> 
> I think the consumed bandwidth still should be reduced from remaining 
> runtime even if yield, then the remaining runtime will be reset to 0 if 
> there is still remaining runtime as what my patch do. What's your option?
> 
> Regards,
> Wanpeng Li
> 
>>   	if (dl_runtime_exceeded(rq, dl_se)) {
>>   		__dequeue_task_dl(rq, curr, 0);
>>   		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
> 
> 

