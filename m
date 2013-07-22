Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab3GVTEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:04:47 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45972 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab3GVTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:04:46 -0400
Message-ID: <51ED824B.10102@linaro.org>
Date: Mon, 22 Jul 2013 12:04:43 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Marcus Gelderie <redmnic@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Race condition in time/alarmtimer.c
References: <20130624191202.GA22643@cantor.Speedport_W_503V_Typ_C> <20130629134715.GB19380@cantor.Speedport_W_503V_Typ_C>
In-Reply-To: <20130629134715.GB19380@cantor.Speedport_W_503V_Typ_C>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2013 06:47 AM, Marcus Gelderie wrote:
> On Mo, Jun 24, 2013 at 09:12:03PM +0200, Marcus Gelderie wrote:
>> Hi,
>>
>> there seems to be a race condition in kernel/time/alarmtimer.c
>>
>> More specifically, the following function (line numbers correspond to actual file):
>>
>> 584 static int alarmtimer_do_nsleep(struct alarm *alarm, ktime_t absexp)
>> 585 {
>> 586         alarm->data = (void *)current;
>> 587         do {
>> 588                 set_current_state(TASK_INTERRUPTIBLE);
>> 589                 alarm_start(alarm, absexp);
>> 590                 if (likely(alarm->data))
>> 591                         schedule();
>> 592
>> 593                 alarm_cancel(alarm);
>> 594         } while (alarm->data && !signal_pending(current));
>> 595
>> 596         __set_current_state(TASK_RUNNING);
>> 597
>> 598         return (alarm->data == NULL);
>> 599 }
>>
>> has a race: If the task is preempted after set_current_state(TASK_INTERRUPTIBLE)
>> but before the alarm is started in the next line, the task never wakes up.
>>
>> Swapping both lines is not an option either, because then the alarm might trigger before
>> the thread sets itself to TASK_INTERRUPTIBLE, thereby loosing the wakeup.
>>
>> A spinlock would disable preemption and protect alarm->data against the race from another CPU.
>> We could wrap lines 588 and 589 with a spin lock. Then the wakeup code would also aquire the
>> lock, of course. The lock could be attached to struct alarm.
>>
>> An alternative would be a waitqueue, of course.
>>
>> If folks agree with me, I will provide a patch.

So does this race also affect the hrtimer do_nanosleep?

thanks
-john


