Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab3CFOjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:39:20 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:41722 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab3CFOjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:39:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130305163228.GA12795@htj.dyndns.org>
References: <CALZhoSR0+SzPLHzJafmny=o8PJ2d7MaH9N6_6s0QZ_oCQm43Xg@mail.gmail.com>
	<20130305163228.GA12795@htj.dyndns.org>
Date: Wed, 6 Mar 2013 22:39:15 +0800
Message-ID: <CALZhoSRyjRYVcKpq9cECHWgKkci6V+O_zn2CkiwqnFo57tZDfQ@mail.gmail.com>
Subject: Re: workqueue panic in 3.4 kernel
From: Lei Wen <adrian.wenl@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun

On Wed, Mar 6, 2013 at 12:32 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Mar 05, 2013 at 03:31:45PM +0800, Lei Wen wrote:
>> With checking memory,  we find work->data becomes 0x300, when it try
>> to call get_work_cwq
>
> Why would that become 0x300?  Who's writing to that memory?  Nobody
> should be.

We find a race condition as below:
CPU0                                                                  CPU1
timer interrupt happen
__run_timers
   __run_timers::spin_lock_irq(&base->lock)
   __run_timers::spin_unlock_irq(&base->lock)

   __cancel_work_timer

   __cancel_work_timer::del_timer

   __cancel_work_timer::wait_on_work

   __cancel_work_timer::clear_work_data
   __run_timers::call_timer_fn(timer, fn, data);
         delayed_work_timer_fn::get_work_cwq
   __run_timers::spin_lock_irq(&base->lock)

It is possible for __cancel_work_timer to be run over cpu1 __BEFORE__
cpu0 is ready to
run the timer callback, which is delayed_work_timer_fn in our case.

Although __cancel_work_timer would call wait_on_work to wait the
already inserted work
complete, but for the work is not queued yet for its calback is not
being executed, so
the result should be wait_on_work directly return, and clear_work_data
clears work->data.
Thus when delayed_work_timer_fn is called, it would see work->data as 0x300.

Do you think it is possible for this kind of sequence?

>
>> in delayed_work_timer_fn. Thus cwq becomes NULL before calls __queue_work.
>> So it is reasonable kernel get panic when it try to access wq with cwq->wq.
>>
>> To fix it, we try to backport below patches:
>> commit 60c057bca22285efefbba033624763a778f243bf
>> Author: Lai Jiangshan <laijs@cn.fujitsu.com>
>> Date:   Wed Feb 6 18:04:53 2013 -0800
>>
>>     workqueue: add delayed_work->wq to simplify reentrancy handling
>>
>> commit 1265057fa02c7bed3b6d9ddc8a2048065a370364
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Wed Aug 8 09:38:42 2012 -0700
>>
>>     workqueue: fix CPU binding of flush_delayed_work[_sync]()
>
> Neither should affect the problem you described above.  It *could*
> make the problem go away just because it would stop using wq->data to
> record cwq if the corruption was contained to that field but that
> isn't a proper fix and the underlying problem could easily cause other
> issues.
>
>> And add below change to make sure __cancel_work_timer cannot preempt
>> between run_timer_softirq and delayed_work_timer_fn.
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index bf4888c..0e9f77c 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -2627,7 +2627,7 @@ static bool __cancel_work_timer(struct work_struct *work,
>>                 ret = (timer && likely(del_timer(timer)));
>>                 if (!ret)
>>                         ret = try_to_grab_pending(work);
>> -               wait_on_work(work);
>> +               flush_work(work);
>>         } while (unlikely(ret < 0));
>>
>>         clear_work_data(work);
>>
>> Do you think this fix is enough? And add flush_work directly in
>> __cancel_work_timer is ok for
>> the fix?
>
> Maybe I'm missing something but it looks like the root cause hasn't
> been diagnosed and you're piling up band-aids in workqueue code.  You
> might get away with it but could also be making the problem just more
> obscure and difficult to debug (reproducible bugs are happy bugs).
>
> I'd suggest finding out who owns the delayed_work item and examining
> why the delayed_work is getting corrupted in the first place.
>
> Thanks.
>
> --
> tejun

Thanks,
Lei
