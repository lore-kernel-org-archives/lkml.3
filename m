Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaC1Rg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:36:59 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62554 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaC1Rg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:36:57 -0400
Message-ID: <5335B336.9020602@linaro.org>
Date: Fri, 28 Mar 2014 10:36:54 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk: add sleep time into timestamp
References: <1395908241-6392-1-git-send-email-zhangwm@marvell.com> <CANcMJZCG7CT_rOShK7jGo3xVZ0MiRD-jUJE=FCTW68tv88g-Bw@mail.gmail.com> <175CCF5F49938B4D99B2E3EF7F558EBE550559A27C@SC-VEXCH4.marvell.com>
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE550559A27C@SC-VEXCH4.marvell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 11:45 PM, Neil Zhang wrote:
> John,
>  
>> -----Original Message-----
>> From: johnstul.lkml@gmail.com [mailto:johnstul.lkml@gmail.com] On Behalf
>> Of John Stultz
>> Sent: 2014Äê3ÔÂ28ÈÕ 11:18
>> To: Neil Zhang
>> Cc: Andrew Morton; Linux Kernel Mailing List
>> Subject: Re: [PATCH] printk: add sleep time into timestamp
>>
>> On Thu, Mar 27, 2014 at 1:17 AM, Neil Zhang <zhangwm@marvell.com>
>> wrote:
>>> Add sleep time into timestamp to reflect the actual time since
>>> sched_clock will be stopped during suspend.
>> So why is this change necessary?
>>
>> Further, since the sleep time may be updated a bit late in the resume cycle (in
>> many cases we cannot access the RTC until irqs are enabled back on), you may
>> see messages that show pre-suspend times when really they occur after we
>> resume (but before the sleep time is incremented).
>>
> Thanks for the comments.
> Yes, the sleep time will be update in RTC and the print in the resume procedure still w/o the sleep time.
> But I think the messages are not too much at this stage. 

Not sure I understand what you mean by "the messages are not too much",
could you expand that a bit?

>> More comments below....
>>
>>> This patch depends on the following patch.
>>> timekeeping: check params before use them
>>>
>>> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
>>> ---
>>>  kernel/printk/printk.c |   15 +++++++++++++--
>>>  1 file changed, 13 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c index
>>> 4dae9cb..2dc6145 100644
>>> --- a/kernel/printk/printk.c
>>> +++ b/kernel/printk/printk.c
>>> @@ -250,6 +250,17 @@ static char __log_buf[__LOG_BUF_LEN]
>>> __aligned(LOG_ALIGN);  static char *log_buf = __log_buf;  static u32
>>> log_buf_len = __LOG_BUF_LEN;
>>>
>>> +static u64 print_clock(void)
>>> +{
>>> +       struct timespec ts;
>>> +       u64 ts_nsec = local_clock();
>>> +
>>> +       get_xtime_and_monotonic_and_sleep_offset(NULL, NULL, &ts);
>> So this will cause deadlocks anytime we print from the timekeeping core, since
>> we may hold a write on the timekeeper lock, and this patch makes every printk
>> try to take a read-lock on the timekeeper lock.
>>
> Sorry, I don't quite understand why it will cause deadlock.
> Yes, it will take a read-lock, but it should not be expensive.

If we call or trigger a printk while holding a write on the timekeeping
lock, the printk code will then try to aquire a read-lock on the
timekeeping lock and this will deadlock the machine.

The printk code already has trouble with the timekeeping code, but this
would make it worse.


>> I'd suggest you use monotonic_to_bootbased() here instead of hacking up this
>> hrtimer specific interface, but even so, right now that call doesn't take the
>> timekeeper lock, but probably should, so its not a good long term plan.
> It maybe doable, or whether we can add another function to only return sleep time.
> Then no read-lock is needed.

Well, you're returning a timespec, which cannot be read atomically, so
it would need to take the lock (that's why I was saying
monotonic_to_bootbased() should probably take the lock, and seems broken).

But using monotonic_to_bootbased would give you the same functionality
without having to modify get_xtime_and_monotonic_and_sleep_offset().

>> I'm still not convinced this change needs to be done, but a  better solution
>> here would be to add infrastructure that when the sleep time is updated we
>> update an offset that the is adding to the local_clock() however, you probably
>> want to be careful since you don't want sleep time in normal
>> local_clock/sched_clock calls since it would mess up scheduling.
>>
> Sometimes we need to compare the kernel log with user space log, 
> so it would be convenient to add the sleep time into kernel timestamp.

Which userspace log? You can have the syslog capture the kernel messages
and timestamp them properly. Also, if you are using your own logging,
you can use CLOCK_MONOTONIC which will provide the closest approximation
to the sched_clock based printk clock.

thanks
-john



