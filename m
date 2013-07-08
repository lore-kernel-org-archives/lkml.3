Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3GHJRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:17:47 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36074 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3GHJRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:17:46 -0400
Message-ID: <51DA844C.2060509@gmail.com>
Date: Mon, 08 Jul 2013 11:20:12 +0200
From: Marcus Gelderie <redmnic@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: artem.bityutskiy@linux.intel.com, herbert@gondor.hengli.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel:time fix race condition in alaramtimer.c
References: <1373126870-17978-1-git-send-email-redmnic@gmail.com> <51DA4EC5.10707@linux.vnet.ibm.com>
In-Reply-To: <51DA4EC5.10707@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok you're right, that prevents it.

Sorry, I missed this check somehow.

Cheers
Marcus

On 07/08/2013 07:31 AM, Srivatsa S. Bhat wrote:
> On 07/06/2013 09:37 PM, Marcus Gelderie wrote:
>> This patch fixes a race condition whereby the process can be caused to
>> sleep indefinitely. The problem occurs when the process is preempted
>> after having set its state to TASK_INTERRUPTIBLE but before starting the
>> alarm.
>>
> 
> I don't think there is any such problem. The __schedule() function does
> this check before dequeuing a task:
> 
> if (prev->state && !(preempt_count() & PREEMPT_ACTIVE))
> 
> The latter part helps prevent the kind of indefinite sleeping you described
> above. Also, take a look at preempt_schedule(), preempt_schedule_irq()
> and friends to see how in-kernel preemption is dealt with, by using
> PREEMPT_ACTIVE. That would clarify why there is no bug here.
> 
> Regards,
> Srivatsa S. Bhat
> 
>> ---
>>  kernel/time/alarmtimer.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
>> index f11d83b..81c8b31 100644
>> --- a/kernel/time/alarmtimer.c
>> +++ b/kernel/time/alarmtimer.c
>> @@ -585,15 +585,19 @@ static int alarmtimer_do_nsleep(struct alarm *alarm, ktime_t absexp)
>>  {
>>  	alarm->data = (void *)current;
>>  	do {
>> +		preempt_disable();
>>  		set_current_state(TASK_INTERRUPTIBLE);
>>  		alarm_start(alarm, absexp);
>> +		preempt_enable_no_resched();
>>  		if (likely(alarm->data))
>>  			schedule();
>>
>> +		preempt_disable();
>>  		alarm_cancel(alarm);
>> +		__set_current_state(TASK_RUNNING);
>> +		preempt_enable_no_resched();
>>  	} while (alarm->data && !signal_pending(current));
>>
>> -	__set_current_state(TASK_RUNNING);
>>
>>  	return (alarm->data == NULL);
>>  }
>>
> 

