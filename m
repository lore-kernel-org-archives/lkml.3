Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161578Ab3LFODH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:03:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:58568 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab3LFODC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:03:02 -0500
Date: Fri, 6 Dec 2013 15:02:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Max Filippov <jcmvbkbc@gmail.com>
cc: Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, jbeulich@suse.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, mina86@mina86.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, jun.zhang@intel.com,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alex Nemirovsky <Alex.Nemirovsky@cortina-systems.com>,
        Artemi Ivanov <artemi.ivanov@cogentembedded.com>
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling smp_call_function_many()/single()
 in serving irq
In-Reply-To: <52A1286E.9000606@gmail.com>
Message-ID: <alpine.DEB.2.02.1312061459190.30673@ionos.tec.linutronix.de>
References: <1360163901.24670.13.camel@cliu38-desktop-build> <1361023075.11130.12.camel@cliu38-desktop-build> <1361023812.11130.15.camel@cliu38-desktop-build> <alpine.DEB.2.02.1307051548430.32106@ionos.tec.linutronix.de> <alpine.DEB.2.02.1307051615100.32106@ionos.tec.linutronix.de>
 <52A1286E.9000606@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Dec 2013, Max Filippov wrote:
> Hi Thomas,
 
> On Fri, Jul 5, 2013 at 6:37 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 5 Jul 2013, Thomas Gleixner wrote:
> >> On Sat, 16 Feb 2013, Chuansheng Liu wrote:
> >> > Currently the functions smp_call_function_many()/single() will
> >> > give a WARN()ing only in the case of irqs_disabled(), but that
> >> > check is not enough to guarantee execution of the SMP
> >> > cross-calls.
> >> >
> >> > In many other cases such as softirq handling/interrupt handling,
> >> > the two APIs still can not be called, just as the
> >> > smp_call_function_many() comments say:
> >> >
> >> >   * You must not call this function with disabled interrupts or from a
> >> >   * hardware interrupt handler or from a bottom half handler. Preemption
> >> >   * must be disabled when calling this function.
> >> >
> >> > There is a real case for softirq DEADLOCK case:
> >> >
> >> > CPUA                            CPUB
> >> >                                 spin_lock(&spinlock)
> >> >                                 Any irq coming, call the irq handler
> >> >                                 irq_exit()
> >> > spin_lock_irq(&spinlock)
> >> > <== Blocking here due to
> >> > CPUB hold it
> >> >                                   __do_softirq()
> >> >                                     run_timer_softirq()
> >> >                                       timer_cb()
> >> >                                         call smp_call_function_many()
> >> >                                           send IPI interrupt to CPUA
> >> >                                             wait_csd()
> >> >
> >> > Then both CPUA and CPUB will be deadlocked here.
> >>
> >> That's not true if called with wait = 0 as we won't wait for the csd
> >> in that case. The function will be invoked on cpuA after it reenables
> >> interrupt. So for callers who don't care about synchronous execution
> >> it should not warn in softirq context.
> >
> > Hmm, even there it matters, because of the following scenario:
> >
> > CPU 0
> > smp_call_function_single(CPU 1)
> >     csd_lock(CPU 1)
> >     irq_enter()
> >     irq_exit()
> >     __do_softirq()
> >     smp_call_function_many()
> >       setup csd (CPU 1)
> >         csd_lock(CPU 1) ==> CPU 0 deadlocked itself.
> >
> > And this is even more likely to happen than the lock issue.
> 
> I've observed similar deadlock in a real system which has network
> driver that uses smp_call_function_single in the softirq context.
> 
> The proposed fix below keeps IRQs disabled on the sending CPU
> during the period between marking csd locked and sending IPI,
> making it possible to use smp_call_function_single from the softirq
> context. What do you think?

I'm not really exited to encourage IPIs from irq context. Just because
some network driver uses it, is definitely not a good argument. If we
really want to support that, then we need a proper justification why
it is necessary in the first place.

Thanks,

	tglx
