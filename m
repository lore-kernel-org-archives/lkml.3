Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaAWNfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:35:47 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58939 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaAWNfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:35:45 -0500
Date: Thu, 23 Jan 2014 14:35:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lei Wen <adrian.wenl@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Is it ok for deferrable timer wakeup the idle cpu?
Message-ID: <20140123133537.GA13345@localhost.localdomain>
References: <CALZhoSQZQcM0yKTw1=ZkYz3Z_3X2QxLk0vCw6gKXW55HSrVEdw@mail.gmail.com>
 <alpine.DEB.2.02.1401221459590.4260@ionos.tec.linutronix.de>
 <CALZhoSSSOZKwDok2ZHumeZAs0R88SC6bU2BaL54U3TU6jgoaZA@mail.gmail.com>
 <CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:22:32AM +0530, Viresh Kumar wrote:
> I think below diff might get this fixed for you, though I am not sure if it
> breaks something else. Probably Thomas/Frederic can answer here.
> If this looks fine I will send it formally again:
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index accfd24..3a2c7fa 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -940,7 +940,8 @@ void add_timer_on(struct timer_list *timer, int cpu)
>          * makes sure that a CPU on the way to stop its tick can not
>          * evaluate the timer wheel.
>          */
> -       wake_up_nohz_cpu(cpu);
> +       if (!tbase_get_deferrable(timer->base))
> +               wake_up_nohz_cpu(cpu);

So you simply rely on the next tick to see the new timer. This should work with
CONFIG_NO_HZ_IDLE but not with CONFIG_NO_HZ_FULL since the target may be running
without the tick.

Basically, in the case of a deferrable timer you need to manage to call
wake_up_full_nohz_cpu() but not wake_up_idle_cpu().

It should be even possible to spare the IPI in a full dynticks CPU if it is
running idle. But that's an optional bonus because it require some deep
care on complicated races against the call to tick_nohz_idle_exit().

I also realize than when we enqueue a timer on a full nohz CPU, we should set_need_resched()
the target before sending the IPI if it is idle like does wake_up_idle_cpu(). Otherwise the
IPI will be ignored without exiting the idle loop nor reevaluating the tick on irq exit.
If you can fix that along the way, that will be much appreciated.

Thanks!
