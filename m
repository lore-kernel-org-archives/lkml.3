Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaA0PqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:46:05 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:35479 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaA0PqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:46:03 -0500
Date: Mon, 27 Jan 2014 10:45:59 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/9] ARM: get rid of arch_cpu_idle_prepare()
In-Reply-To: <20140127124511.GK15937@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1401271004060.1652@knanqh.ubzr>
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org> <1390802904-28399-2-git-send-email-nicolas.pitre@linaro.org> <20140127124511.GK15937@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, Russell King - ARM Linux wrote:

> On Mon, Jan 27, 2014 at 01:08:16AM -0500, Nicolas Pitre wrote:
> > ARM and ARM64 are the only two architectures implementing
> > arch_cpu_idle_prepare() simply to call local_fiq_enable().
> > 
> > We have secondary_start_kernel() already calling local_fiq_enable() and
> > this is done a second time in arch_cpu_idle_prepare() in that case. And
> > enabling FIQs has nothing to do with idling the CPU to start with.
> > 
> > So let's introduce init_fiq_boot_cpu() to take care of FIQs on the boot
> > CPU and remove arch_cpu_idle_prepare(). This is now done a bit earlier
> > at late_initcall time but this shouldn't make a difference in practice
> > i.e. when FIQs are actually used.
> > 
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> > ---
> >  arch/arm/kernel/process.c | 5 -----
> >  arch/arm/kernel/setup.c   | 7 +++++++
> >  2 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> > index 92f7b15dd2..725b8c95e0 100644
> > --- a/arch/arm/kernel/process.c
> > +++ b/arch/arm/kernel/process.c
> > @@ -142,11 +142,6 @@ static void default_idle(void)
> >  	local_irq_enable();
> >  }
> >  
> > -void arch_cpu_idle_prepare(void)
> > -{
> > -	local_fiq_enable();
> > -}
> > -
> >  void arch_cpu_idle_enter(void)
> >  {
> >  	ledtrig_cpu(CPU_LED_IDLE_START);
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index 987a7f5bce..d027b1a6fe 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -789,6 +789,13 @@ static int __init init_machine_late(void)
> >  }
> >  late_initcall(init_machine_late);
> >  
> > +static int __init init_fiq_boot_cpu(void)
> > +{
> > +	local_fiq_enable();
> > +	return 0;
> > +}
> > +late_initcall(init_fiq_boot_cpu);
> 
> arch_cpu_idle_prepare() gets called from the swapper thread, and changes
> the swapper thread's CPSR. init_fiq_boot_cpu() gets called from PID1, the
> init thread, and changes the init thread's CPSR, which will already have
> FIQs enabled by way of how kernel threads are created.
> 
> Hence, the above code fragment has no effect what so ever, and those
> platforms using FIQs will not have FIQs delivered if they're idle
> (because the swapper will have FIQs masked at the CPU.)

You're right.

What about moving local_fiq_enable() to trap_init() then?


Nicolas
