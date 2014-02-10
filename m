Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaBJPfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:35:42 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41342 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaBJPfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:35:38 -0500
Date: Mon, 10 Feb 2014 16:35:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lei Wen <adrian.wenl@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Is it ok for deferrable timer wakeup the idle cpu?
Message-ID: <20140210153530.GA21060@localhost.localdomain>
References: <CALZhoSQZQcM0yKTw1=ZkYz3Z_3X2QxLk0vCw6gKXW55HSrVEdw@mail.gmail.com>
 <alpine.DEB.2.02.1401221459590.4260@ionos.tec.linutronix.de>
 <CALZhoSSSOZKwDok2ZHumeZAs0R88SC6bU2BaL54U3TU6jgoaZA@mail.gmail.com>
 <CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
 <20140123133537.GA13345@localhost.localdomain>
 <CAKohponoTb-SeRx8Za6HhmVNwrT0COxykhi=s=uOR8SGNvkgUA@mail.gmail.com>
 <20140128135033.GC9172@localhost.localdomain>
 <CAKohpok7obD9LqPwLLQMOPw9fTyKg4WpwiZ8EPAgqtHSsC0fxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpok7obD9LqPwLLQMOPw9fTyKg4WpwiZ8EPAgqtHSsC0fxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 12:21:16PM +0530, Viresh Kumar wrote:
> Sorry was away for short vacation.
> 
> On 28 January 2014 19:20, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Thu, Jan 23, 2014 at 07:50:40PM +0530, Viresh Kumar wrote:
> >> Wait, I got the wrong code here. That's wasn't my initial intention.
> >> I actually wanted to write something like this:
> >>
> >>  -       wake_up_nohz_cpu(cpu);
> >>  +       if (!tbase_get_deferrable(timer->base) || idle_cpu(cpu))
> >>  +               wake_up_nohz_cpu(cpu);
> >>
> >> Will that work?
> 
> Something is seriously wrong with me, again wrote rubbish code.
> Let me phrase what I wanted to write :)
> 
> "don't send IPI to a idle CPU for a deferrable timer."
> 
> Probably I code it correctly this time atleast.
> 
> -       wake_up_nohz_cpu(cpu);
> +       if (!(tbase_get_deferrable(timer->base) && idle_cpu(cpu)))
> +               wake_up_nohz_cpu(cpu);

Yeah but that's racy if the target is nohz full. We may be seeing it idle whereas
it woke up lately and run in userspace tickless for a while.

> 
> > Well, this is going to wake up the target from its idle state, which is
> > what we want to avoid if the timer is deferrable, right?
> 
> Yeah, sorry for doing it for second time :(

I'm certainly not blaming you for being confused, that would be the pot calling the kettle black ;)

> 
> > The simplest thing we want is:
> >
> >            if (!tbase_get_deferrable(timer->base) || tick_nohz_full_cpu(cpu))
> >                wake_up_nohz_cpu(cpu);
> >
> > This spares the IPI for the common case where the timer is deferrable and we run
> > in periodic or dynticks-idle mode (which should be 99.99% of the existing workloads).
> 
> I wasn't looking at this problem with NO_HZ_FULL in mind. As I thought its
> only about if the CPU is idle or not. And so the solution I was
> talking about was:
> 
> "don't send IPI to a idle CPU for a deferrable timer."
> 
> But I see that still failing with the code you wrote. For normal cases where we
> don't enable NO_HZ_FULL, we will still end up waking up idle CPUs which
> is what Lei Wen reported initially.

Not with the small change I proposed above.
I'm applying it.

> 
> Also if a CPU is marked for NO_HZ_FULL and is not idle currently then we
> wouldn't send a IPI for a deferrable timer. But we actually need that, so that
> we can reevaluate the timers order again?

Right.
