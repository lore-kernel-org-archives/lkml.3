Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaBGKsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:48:35 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:55865 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaBGKsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:48:33 -0500
Date: Fri, 7 Feb 2014 10:48:31 +0000 (GMT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/2] PPC: powernv: remove redundant cpuidle_idle_call()
In-Reply-To: <52F46EB3.5080403@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.11.1402071022490.1906@knanqh.ubzr>
References: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org> <CAKnoXLxCAqKaniGOwegNcOarS4FpoNKDY5PxOhe6j4wdtUAkLQ@mail.gmail.com> <52F3BCFE.3010703@linux.vnet.ibm.com> <alpine.LFD.2.11.1402070105170.1906@knanqh.ubzr>
 <52F46EB3.5080403@linux.vnet.ibm.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Preeti U Murthy wrote:

> Hi Nicolas,
> 
> On 02/07/2014 06:47 AM, Nicolas Pitre wrote:
> > 
> > What about creating arch_cpu_idle_enter() and arch_cpu_idle_exit() in 
> > arch/powerpc/kernel/idle.c and calling ppc64_runlatch_off() and 
> > ppc64_runlatch_on() respectively from there instead?  Would that work?  
> > That would make the idle consolidation much easier afterwards.
> 
> I would not suggest doing this. The ppc64_runlatch_*() routines need to
> be called when we are sure that the cpu is about to enter or has exit an
> idle state. Moving the ppc64_runlatch_on() routine to
> arch_cpu_idle_enter() for instance is not a good idea because there are
> places where the cpu can decide not to enter any idle state before the
> call to cpuidle_idle_call() itself. In that case communicating
> prematurely that we are in an idle state would not be a good idea.
> 
> So its best to add the ppc64_runlatch_* calls in the powernv cpuidle
> driver IMO. We could however create idle_loop_prologue/epilogue()
> variants inside it so that in addition to the runlatch routines we could
> potentially add more such similar routines that are powernv specific.
>   If there are cases where there is work to be done prior to and post an
> entry into an idle state common to both pseries and powernv, we will
> probably put them in arch_cpu_idle_enter/exit(). But the runlatch
> routines are not suitable to be moved there as far as I can see.

OK.

However, one thing we need to do as much as possible is to remove those 
loops based on need_resched() from idle backend drivers.  A somewhat 
common pattern is:

my_idle()
{
	/* interrupts disabled on entry */
	while (!need_resched()) {
		lowpower_wait_for_interrupts();
		local_irq_enable();
		/* IRQ serviced from here */
		local_irq_disable();
	}
	local_irq_enable();
	/* interrupts enabled on exit */
}

To be able to keep statistics on the actual idleness of the CPU we'd 
need for all idle backends to always return to generic code on every 
interrupt similar to this:

my_idle()
{
	/* interrupts disabled on entry */
	lowpower_wait_for_interrupts();
	local_irq_enable();
	/* interrupts enabled on exit */
}

The generic code would be responsible for dealing with need_resched() 
and call back into the backend right away if necessary after updating 
some stats.

Do you see a problem with the runlatch calls happening around each 
interrrupt from such a simplified idle backend?


Nicolas
