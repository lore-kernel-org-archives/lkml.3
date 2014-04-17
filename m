Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaDQQFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:05:05 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42340 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaDQQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:04:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140417152744.GM15326@htj.dyndns.org>
References: <20140416165052.GK1257@htj.dyndns.org>
	<1397691258-11639-1-git-send-email-laijs@cn.fujitsu.com>
	<20140417152744.GM15326@htj.dyndns.org>
Date: Fri, 18 Apr 2014 00:04:29 +0800
X-Google-Sender-Auth: jE5R5_KVDUrO0n9z_dAIE67jJFQ
Message-ID: <CACvQF527RneJwUXf0=C6L0_9ncdS6--iqhdpWAFKqHtd25LOYg@mail.gmail.com>
Subject: Re: [PATCH 1/2] workqueue: rescuer_thread() processes all pwqs before exit
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:27 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Thu, Apr 17, 2014 at 07:34:08AM +0800, Lai Jiangshan wrote:
>> Before the rescuer is picked to running, the works of the @pwq
>> may be processed by some other workers, and destroy_workqueue()
>> may called at the same time. This may result a nasty situation
>> that rescuer may exit with non-empty mayday list.
>>
>> It is no harm currently, destroy_workqueue() can safely to free
>> them all(workqueue&pwqs) togerther, since the rescuer is stopped.
>> No rescuer nor mayday-timer can access the mayday list.
>>
>> But it is nasty and error-prone in future develop. Fix it.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>  kernel/workqueue.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 0ee63af..832125f 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -2409,12 +2409,6 @@ static int rescuer_thread(void *__rescuer)
>>  repeat:
>>       set_current_state(TASK_INTERRUPTIBLE);
>>
>> -     if (kthread_should_stop()) {
>> -             __set_current_state(TASK_RUNNING);
>> -             rescuer->task->flags &= ~PF_WQ_WORKER;
>> -             return 0;
>> -     }
>> -
>>       /* see whether any pwq is asking for help */
>>       spin_lock_irq(&wq_mayday_lock);
>>
>> @@ -2459,6 +2453,12 @@ repeat:
>>
>>       spin_unlock_irq(&wq_mayday_lock);
>>
>> +     if (kthread_should_stop()) {
>> +             __set_current_state(TASK_RUNNING);
>> +             rescuer->task->flags &= ~PF_WQ_WORKER;
>> +             return 0;
>> +     }
>> +
>
> I don't think this is reliable.  What if mayday requests take place
> between wq_mayday_lock and kthread_should_stop() check?  We'll
> probably need to run through mayday list after checking should_stop.

It is destroy_workqueue()'s responsibility to avoid this.
destroy_workqueue() should drain all works and refuse any new work queued
on the wq before destroy the wq.

So since there is no works, there is no new mayday request,
and there is no mayday request take place between wq_mayday_lock
and kthread_should_stop() check.

Thanks,
Lai

>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
