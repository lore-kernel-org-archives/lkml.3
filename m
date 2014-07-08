Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaGHBL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:11:59 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45784 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbaGHBL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:11:56 -0400
Message-ID: <53BB4510.5090704@huawei.com>
Date: Tue, 8 Jul 2014 09:10:40 +0800
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <xiaofeng.yan2012@gmail.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] sched/rt: overrun could happen in start_hrtick_dl
References: <1404475341-22536-1-git-send-email-xiaofeng.yan@huawei.com> <20140707084150.GC19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140707084150.GC19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.133]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/7 16:41, Peter Zijlstra wrote:
> On Fri, Jul 04, 2014 at 12:02:21PM +0000, xiaofeng.yan wrote:
>> It could be wrong for the precision of runtime and deadline
>> when the precision is within microsecond level. For example:
>> Task runtime deadline period
>>   P1   200us   500us   500us
>>
>> This case need enbale HRTICK feature by the next command
>> PC#echo "HRTICK" > /sys/kernel/debug/sched_features
>> PC#./schedtool -E -t 200000:500000 -e ./test&
>> PC#trace-cmd record -e sched_switch
> Are you actually using HRTICK ?
yes, If HRTICK is close , then all of runtime and deadline will be wrong.
>> Some of runtime and deadline run with millisecond level by
>> reading kernershark.
>> The problem is caused by a conditional judgment "delta > 10000".
>> Because no hrtimer start up to control the runtime when runtime is less than 10us.
>> So the process will continue to run until tick-period coming.
>> For fixing this problem, Let delta is equal to 10us when it is less than 10us.
>> So the hrtimer will start up to control the end of process.
>>
>> Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>
> Always when sending patches for deadline, also CC Juri.
>
>> ---
>>   kernel/sched/deadline.c |    6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index fc4f98b1..dfefa82 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -997,10 +997,8 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
>>   #ifdef CONFIG_SCHED_HRTICK
>>   static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
>>   {
>> -	s64 delta = p->dl.dl_runtime - p->dl.runtime;
>> -
>> -	if (delta > 10000)
>> -		hrtick_start(rq, p->dl.runtime);
>> +	s64 delta = p->dl.runtime > 10000 ? p->dl.runtime : 10000;
>> +	hrtick_start(rq, delta);
> Yeah, that looks funny. And seeing how the only other user does
> something similar:
>
> hrtick_start_fair()
> 	delta = max(10000ULL, delta)
> 	hrtick_start(rq, delta)
I will modify my code according to your suggest.
>
> Does it make sense to move this max() into hrtick_start()?
>
> Also; and I don't think you mentioned that but did fix, the argument to
> hrtick_start() is wrong, it should be the delta, not the absolute
> timeout.
Perhaps , if the runtime  is less than 10us,  the context switch 
overhead for system could be closed to 10us.
So it could loss more then you gain.

Thanks for your reply.

Thanks
Yan

