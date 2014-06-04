Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaFDNXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:23:14 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42203 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaFDNXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:23:13 -0400
Date: Wed, 4 Jun 2014 15:23:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [Query] Can we use normal timers (kernel/timer.c) while in
 NO_HZ_FULL mode?
Message-ID: <20140604132305.GB13827@localhost.localdomain>
References: <CAKohponiCH35ZBTicCkVV3KoJzCWrnJExeR9HqwSMv+QDp36gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponiCH35ZBTicCkVV3KoJzCWrnJExeR9HqwSMv+QDp36gg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 05:11:08PM +0530, Viresh Kumar wrote:
> Hi,
> 
> While working on the ONESHOT_STOPPED mode I came across
> another confusing scenario..
> 
> Normal timers (kernel/timer.c) don't configure clockevent devices
> at all but they always rely on PERIODIC tick interrupts to get them
> scheduled. i.e. normal timers would be only serviced at next tick
> interrupt (in both LOW & HIGH resolution modes)..
> 
> Suppose we have entered into NO_HZ_FULL mode (we made
> sure that there are no normal timers queued) and a normal
> timer was added after that. We will add it to the timer list but
> as there is no tick-sched timer, we wouldn't be able to service
> the normal timer until next time tick fires again (MAX 1 second
> currently)..
> 
> And once we remove this MAX 1 second limitation, we might
> not service this normal timer for long..
> 
> Does this problem statement make sense? Or we don't have
> any such problem?

Right, if we enqueue a timer when the tick is stopped, we call wake_up_nohz_cpu().
So here is two scenarios:

1) Target is remote. An IPI is sent if necessary and the next tick is reevaluated from the
target's irq exit

2) Target is local. We assume that nobody needs to enqueue a timer between
tick_nohz_idle_enter() and tick_nohz_idle_exit() calls. Because it's dead idle area.
But irqs can happen in nohz mode, and they can queue timers. Then the next tick
can be reevaluated on irq exit. But we should better check that no code like idle
drivers, governors and other idle stuff ever call a timer on the dead zone.

Now full nohz is actually special in that it can call the ipi locally if the target
is local. This is currently using the scheduler IPI but I may change that to use
irq work because I'm not sure that all archs support scheduler self-IPIs.
