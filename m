Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaA3TYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:24:24 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:60552 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaA3TYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:24:21 -0500
Date: Thu, 30 Jan 2014 14:24:18 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/6] idle: move the cpuidle entry point to the generic
 idle loop
In-Reply-To: <52EA8BD4.6020803@linaro.org>
Message-ID: <alpine.LFD.2.11.1401301358040.1652@knanqh.ubzr>
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org> <1391017513-12995-2-git-send-email-nicolas.pitre@linaro.org> <alpine.LFD.2.11.1401291526320.1652@knanqh.ubzr> <52E9C946.50704@linux.vnet.ibm.com> <alpine.LFD.2.11.1401300021530.1652@knanqh.ubzr>
 <52EA5720.8010000@linaro.org> <alpine.LFD.2.11.1401301056180.1652@knanqh.ubzr> <52EA8BD4.6020803@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Daniel Lezcano wrote:

> On 01/30/2014 05:07 PM, Nicolas Pitre wrote:
> > On Thu, 30 Jan 2014, Daniel Lezcano wrote:
> > > But what I don't get with your comment is the local_irq_enable is done
> > > from
> > > the cpuidle common framework in 'cpuidle_enter_state' it is not done from
> > > the
> > > arch specific backend cpuidle driver.
> >
> > Oh well... This certainly means we'll have to clean this mess as some
> > drivers do it on their own while some others don't.  Some drivers also
> > loop on !need_resched() while some others simply return on the first
> > interrupt.
> 
> Ok, I think the mess is coming from 'default_idle' which does not re-enable
> the local_irq but used from different places like amd_e400_idle and
> apm_cpu_idle.

Yet if you look at the code path before my patches you'll see that IRQs 
were enabled only after cpuidle_idle_call() had returned success.

> void default_idle(void)
> {
>         trace_cpu_idle_rcuidle(1, smp_processor_id());
>         safe_halt();
>         trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
> }
> 
> Considering the system configured without cpuidle because this one *always*
> enable the local irq,

Yet this is discutable. Given that some hardware do have IRQs turned on 
upon exiting idle mode, I think we should generalize it so that 
the explicit enabling 
of IRQs, when needed, should be done as close as possible to the 
operation that caused idle mode to be entered.

> we have the different cases:
> 
> x86_idle = default_idle();
> ==> local_irq_enable is missing

According to Peter it is not.

> x86_idle = amd_e400_idle();
> ==> it calls local_irq_disable(); but in the idle loop context where the 
> local irqs are already disabled.

Since it returned from default_idle() then IRQs are enabled.

> ==> if amd_e400_c1e_detected is true, the local_irq are enabled
> ==> otherwise no
> ==> default_idle is called from there and does not enable local_irqs

Again, it does.

> > > So the code above could be:
> > >
> > >  if (cpuidle_idle_call())
> > >   x86_idle();
> > >
> > > without the else section, this local_irq_enable is pointless. Or may be I
> > > missed something ?
> >
> > A later patch removes it anyway.  But if it is really necessary to
> > enable interrupts then the core will do it but with a warning now.
> 
> This WARN should disappear. It was there because it was up to the backend
> cpuidle driver to enable the irq. But in the meantime, that was consolidated
> into a single place in the cpuidle framework so no need to try to catch
> errors.

And that consolidation was a mistake IMHO.  We should assume that the 
exiting of idle mode has IRQs enabled already, and do so manually in the 
backend driver if it is not the case on particular hardware.  That's the 
only way to ensure uniformity at a higher level.

Yet, if a code path is buggy in that regard, whether this is through 
cpuidle when enabled, or the default idle function otherwise, then the 
warning is there in cpu_idle_loop() to catch them all.

> What about (based on this patchset).
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 4505e2a..2d60cbb 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -299,6 +299,7 @@ void arch_cpu_idle_dead(void)
>  void arch_cpu_idle(void)
>  {
>         x86_idle();
> +       local_irq_enable();
>  }

Again this is redundant.


Nicolas
