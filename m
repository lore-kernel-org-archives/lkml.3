Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3CTPNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:13:12 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33745 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab3CTPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:13:10 -0400
MIME-Version: 1.0
In-Reply-To: <1354024039.6276.72.camel@gandalf.local.home>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<d12b25130db5a8b645929eb93d1cf4ddc2d68826.1352196505.git.viresh.kumar@linaro.org>
	<1354024039.6276.72.camel@gandalf.local.home>
Date: Wed, 20 Mar 2013 20:43:08 +0530
Message-ID: <CAKohponv-AKZzM98Ujeek4oXQx+8ba+sMgMbM9eV8PgQR38kZw@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 4/4] timer: Migrate running timer
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de, Steven Rostedt <rostedt@goodmis.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tj@kernel.org,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, john stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2012 19:17, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-11-06 at 16:08 +0530, Viresh Kumar wrote:

>> diff --git a/kernel/timer.c b/kernel/timer.c
>> @@ -729,6 +730,12 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
>>
>>       base = lock_timer_base(timer, &flags);
>>
>> +     if (timer->sched_del) {
>> +             /* Don't schedule it again, as it is getting deleted */
>> +             ret = -EBUSY;
>> +             goto out_unlock;
>> +     }
>> +
>>       ret = detach_if_pending(timer, base, false);
>>       if (!ret && pending_only)
>>               goto out_unlock;
>> @@ -746,21 +753,12 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
>>       new_base = per_cpu(tvec_bases, cpu);
>>
>>       if (base != new_base) {
>> -             /*
>> -              * We are trying to schedule the timer on the local CPU.
>> -              * However we can't change timer's base while it is running,
>> -              * otherwise del_timer_sync() can't detect that the timer's
>> -              * handler yet has not finished. This also guarantees that
>> -              * the timer is serialized wrt itself.
>> -              */
>> -             if (likely(base->running_timer != timer)) {
>> -                     /* See the comment in lock_timer_base() */
>> -                     timer_set_base(timer, NULL);
>> -                     spin_unlock(&base->lock);
>> -                     base = new_base;
>> -                     spin_lock(&base->lock);
>> -                     timer_set_base(timer, base);
>> -             }
>> +             /* See the comment in lock_timer_base() */
>> +             timer_set_base(timer, NULL);
>> +             spin_unlock(&base->lock);
>> +             base = new_base;
>> +             spin_lock(&base->lock);
>> +             timer_set_base(timer, base);
>>       }

> I don't think this is good enough. For one thing, it doesn't handle
> try_to_del_timer_sync() or even del_timer_sync() for that matter. As
> that may return success when the timer happens to be running on another
> CPU.
>
> We have this:
>
>         CPU0                    CPU1
>         ----                    ----
>    timerA (running)
>    mod_timer(timerA)
>    [ migrate to CPU2 ]
>    release timer base lock
>                            del_timer_sync(timerA)
>                            timer->sched_del = true
>                            try_to_del_timer_sync(timerA)
>                                 base(CPU2)->timer != timerA
>                                 [TRUE!]
>   timerA (finishes)
>
> Fail!

Hi Steven/Thomas,

I came back to this patch after completing some other stuff and posting
wq part of this patchset separately.

I got your point and understand how this would fail.

@Thomas: I need your opinion first. Do you like this concept of migrating
running timer or not? Or you see some basic problem with this concept?

If no (i.e. i can go ahead with another version), then i have some solution to
fix earlier problems reported by Steven:

The problem lies with del_timer_sync() which just checks
base->running_timer != timer to check if timer is currently running or not.

What if we add another variable in struct timer_list, that will store if we are
running timer callback or not. And so, before we call callback in timer core,
we will set this variable and will reset it after finishing callback.

del_timer_sync() will have something like:

if (base->running_timer != timer)
    remove timer and return;
else if (timer->running_callback)
    go back to its loop...

So, with my existing patch + this change, del_timer_sync() will not return
back unless the callback is completed on CPU0.

But what can happen now is base->running_timer == timer can be true
for two cpus simultaneously cpu0 (running callback) and cpu2 (running hardware
timer). Will that cause any issues?

--
viresh
