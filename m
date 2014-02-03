Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaBCGvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:51:18 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:57615 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaBCGvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:51:16 -0500
MIME-Version: 1.0
In-Reply-To: <20140128135033.GC9172@localhost.localdomain>
References: <CALZhoSQZQcM0yKTw1=ZkYz3Z_3X2QxLk0vCw6gKXW55HSrVEdw@mail.gmail.com>
	<alpine.DEB.2.02.1401221459590.4260@ionos.tec.linutronix.de>
	<CALZhoSSSOZKwDok2ZHumeZAs0R88SC6bU2BaL54U3TU6jgoaZA@mail.gmail.com>
	<CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
	<20140123133537.GA13345@localhost.localdomain>
	<CAKohponoTb-SeRx8Za6HhmVNwrT0COxykhi=s=uOR8SGNvkgUA@mail.gmail.com>
	<20140128135033.GC9172@localhost.localdomain>
Date: Mon, 3 Feb 2014 12:21:16 +0530
Message-ID: <CAKohpok7obD9LqPwLLQMOPw9fTyKg4WpwiZ8EPAgqtHSsC0fxw@mail.gmail.com>
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

Sorry was away for short vacation.

On 28 January 2014 19:20, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Jan 23, 2014 at 07:50:40PM +0530, Viresh Kumar wrote:
>> Wait, I got the wrong code here. That's wasn't my initial intention.
>> I actually wanted to write something like this:
>>
>>  -       wake_up_nohz_cpu(cpu);
>>  +       if (!tbase_get_deferrable(timer->base) || idle_cpu(cpu))
>>  +               wake_up_nohz_cpu(cpu);
>>
>> Will that work?

Something is seriously wrong with me, again wrote rubbish code.
Let me phrase what I wanted to write :)

"don't send IPI to a idle CPU for a deferrable timer."

Probably I code it correctly this time atleast.

-       wake_up_nohz_cpu(cpu);
+       if (!(tbase_get_deferrable(timer->base) && idle_cpu(cpu)))
+               wake_up_nohz_cpu(cpu);

> Well, this is going to wake up the target from its idle state, which is
> what we want to avoid if the timer is deferrable, right?

Yeah, sorry for doing it for second time :(

> The simplest thing we want is:
>
>            if (!tbase_get_deferrable(timer->base) || tick_nohz_full_cpu(cpu))
>                wake_up_nohz_cpu(cpu);
>
> This spares the IPI for the common case where the timer is deferrable and we run
> in periodic or dynticks-idle mode (which should be 99.99% of the existing workloads).

I wasn't looking at this problem with NO_HZ_FULL in mind. As I thought its
only about if the CPU is idle or not. And so the solution I was
talking about was:

"don't send IPI to a idle CPU for a deferrable timer."

But I see that still failing with the code you wrote. For normal cases where we
don't enable NO_HZ_FULL, we will still end up waking up idle CPUs which
is what Lei Wen reported initially.

Also if a CPU is marked for NO_HZ_FULL and is not idle currently then we
wouldn't send a IPI for a deferrable timer. But we actually need that, so that
we can reevaluate the timers order again?

> Then we can later optimize that and spare the IPI on full dynticks CPUs when they run
> idle, but that require some special care about subtle races which can't be dealt
> with a simple test on "idle_cpu(target)". And power consumption in full dynticks
> is already very suboptimized anyway.
>
> So I suggest we start simple with the above test, and a big fat comment which explains
> what we are doing and what needs to be done in the future.
