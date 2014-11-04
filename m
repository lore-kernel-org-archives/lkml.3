Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaKDXdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:33:49 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42119 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaKDXdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:33:47 -0500
Message-ID: <54596254.6090401@gmail.com>
Date: Wed, 05 Nov 2014 07:33:40 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 5/6] sched/dl: Optimize select_task_rq_dl() for non-DL
 curr task
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>	<1415099585-31174-5-git-send-email-pang.xunlei@linaro.org> <20141104094549.59acebb6@gandalf.local.home>
In-Reply-To: <20141104094549.59acebb6@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,
On 14/11/4 下午10:45, Steven Rostedt wrote:
> On Tue,  4 Nov 2014 19:13:04 +0800
> "pang.xunlei" <pang.xunlei@linaro.org> wrote:
>
>> When selecting the cpu for a waking DL task, if curr is a non-DL
>> task which is bound only on this cpu, then we can give it a chance
>> to select a different cpu for this DL task to avoid curr starving.
>>
>> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
>> ---
>>   kernel/sched/deadline.c |   14 ++++++++++----
>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index 7b0b2d2..1f64d4a 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -954,6 +954,9 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
>>   	struct task_struct *curr;
>>   	struct rq *rq;
>>   
>> +	if (p->nr_cpus_allowed == 1)
>> +		goto out;
>> +
> This looks fine, and I'm wondering if we shouldn't just move this into
> kernel/sched/core.c: select_task_rq(). Why bother calling the select_rq
> code if the task is pinned?
>
> This change will make fair.c, rt.c, and deadline.c all start with the
> same logic. If this should be an optimization, just move it to core.c
> and be done with it.

Actually I have already do this for dl class and patch merged in tip 
tree currently, maybe pang.xunlei miss it. I will send a patch to move 
them all to core.c soon.

Regards,
Wanpeng Li

>
>
>>   	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
>>   		goto out;
>>   
>> @@ -970,11 +973,14 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
>>   	 * can!) we prefer to send it somewhere else. On the
>>   	 * other hand, if it has a shorter deadline, we
>>   	 * try to make it stay here, it might be important.
>> +	 *
>> +	 * If the current task on @p's runqueue is a non-DL task,
>> +	 * and this task is bound on current runqueue, then try to
>> +	 * see if we can wake this DL task up on a different runqueue,
>>   	 */
>> -	if (unlikely(dl_task(curr)) &&
>> -	    (curr->nr_cpus_allowed < 2 ||
>> -	     !dl_entity_preempt(&p->dl, &curr->dl)) &&
>> -	    (p->nr_cpus_allowed > 1)) {
>> +	if (unlikely(curr->nr_cpus_allowed < 2) ||
>> +		unlikely(dl_task(curr) &&
>> +				!dl_entity_preempt(&p->dl, &curr->dl))) {
> This has the same issue as the rt.c change.
>
> -- Steve
>
>>   		int target = find_later_rq(p);
>>   
>>   		if (target != -1)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

