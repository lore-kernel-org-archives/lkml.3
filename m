Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaAWOUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:20:43 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:36367 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaAWOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:20:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140123133537.GA13345@localhost.localdomain>
References: <CALZhoSQZQcM0yKTw1=ZkYz3Z_3X2QxLk0vCw6gKXW55HSrVEdw@mail.gmail.com>
	<alpine.DEB.2.02.1401221459590.4260@ionos.tec.linutronix.de>
	<CALZhoSSSOZKwDok2ZHumeZAs0R88SC6bU2BaL54U3TU6jgoaZA@mail.gmail.com>
	<CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
	<20140123133537.GA13345@localhost.localdomain>
Date: Thu, 23 Jan 2014 19:50:40 +0530
Message-ID: <CAKohponoTb-SeRx8Za6HhmVNwrT0COxykhi=s=uOR8SGNvkgUA@mail.gmail.com>
Subject: Re: Is it ok for deferrable timer wakeup the idle cpu?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lei Wen <adrian.wenl@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2014 19:05, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Jan 23, 2014 at 11:22:32AM +0530, Viresh Kumar wrote:
>> I think below diff might get this fixed for you, though I am not sure if it
>> breaks something else. Probably Thomas/Frederic can answer here.
>> If this looks fine I will send it formally again:
>>
>> diff --git a/kernel/timer.c b/kernel/timer.c
>> index accfd24..3a2c7fa 100644
>> --- a/kernel/timer.c
>> +++ b/kernel/timer.c
>> @@ -940,7 +940,8 @@ void add_timer_on(struct timer_list *timer, int cpu)
>>          * makes sure that a CPU on the way to stop its tick can not
>>          * evaluate the timer wheel.
>>          */
>> -       wake_up_nohz_cpu(cpu);
>> +       if (!tbase_get_deferrable(timer->base))
>> +               wake_up_nohz_cpu(cpu);

Wait, I got the wrong code here. That's wasn't my initial intention.
I actually wanted to write something like this:

 -       wake_up_nohz_cpu(cpu);
 +       if (!tbase_get_deferrable(timer->base) || idle_cpu(cpu))
 +               wake_up_nohz_cpu(cpu);

Will that work?

> So you simply rely on the next tick to see the new timer. This should work with
> CONFIG_NO_HZ_IDLE but not with CONFIG_NO_HZ_FULL since the target may be running
> without the tick.
>
> Basically, in the case of a deferrable timer you need to manage to call
> wake_up_full_nohz_cpu() but not wake_up_idle_cpu().
>
> It should be even possible to spare the IPI in a full dynticks CPU if it is
> running idle. But that's an optional bonus because it require some deep
> care on complicated races against the call to tick_nohz_idle_exit().
>
> I also realize than when we enqueue a timer on a full nohz CPU, we should set_need_resched()
> the target before sending the IPI if it is idle like does wake_up_idle_cpu(). Otherwise the
> IPI will be ignored without exiting the idle loop nor reevaluating the tick on irq exit.
> If you can fix that along the way, that will be much appreciated.

I haven't thought much about this currently as I have limited knowledge of
these routines. Though the problem we were facing wasn't related to
NO_HZ_FULL. It was just about waking up an idle cpu.
