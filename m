Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab3BZSzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:55:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:51026 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab3BZSzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:55:19 -0500
Date: Tue, 26 Feb 2013 19:55:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] irq: Cleanup context state transitions in
 irq_exit()
In-Reply-To: <20130226163911.GA3309@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1302261950120.22263@ionos>
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com> <1361496971-16939-3-git-send-email-fweisbec@gmail.com> <alpine.LFD.2.02.1302221528470.22263@ionos> <20130222150444.GD18149@somewhere.redhat.com> <alpine.LFD.2.02.1302221605520.22263@ionos>
 <CA+55aFxOreKQ-uzfMtXEb6XH4D8By2i=qOxfDLJnchSYsa34PQ@mail.gmail.com> <alpine.LFD.2.02.1302261308550.22263@ionos> <CAFTL4hyYRO3MGBy9SgCvB+jhBTtW=RH3Pb4cXGpYMQJfCa3M5g@mail.gmail.com> <alpine.LFD.2.02.1302261614060.22263@ionos>
 <20130226163911.GA3309@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013, Paul E. McKenney wrote:
> On Tue, Feb 26, 2013 at 04:14:43PM +0100, Thomas Gleixner wrote:
> > 
> > On Tue, 26 Feb 2013, Frederic Weisbecker wrote:
> > > And what do you think about Linus's idea to move tick_nohz_irq_exit()
> > > to do_softirq()?
> > > This sounds feasible and a right place to do this, I hope that won't
> > > uglify do_softirq() though.
> > > I can try something.
> > 
> > Yeah, looks doable. the rcu stuff needs to go there as well, right?
> 
> If it does, it needs to do so in such a way that rcu_irq_enter() and
> rcu_irq_exit() nest properly.  One area of concern is the force_irqthreads
> case, skips calling do_softirq().  Another area of concern is the
> __ARCH_IRQ_EXIT_IRQS_DISABLED case, which calls __do_softirq() rather
> than do_softirq().

That's sorted already. We disable interrupts in irq_exit().

> Or am I missing some adjustment that is to be made when moving rcu_irq_exit()
> to do_softirq()?

Yeah, we need an extra parameter or such, so the other callers of
__do_softirq() don't mess with it.

I also noticed that rcu_irq_enter/exit needs to be symetric and the
NOHZ code will get confused as well if we call it asymetric.

So that will become even more ugly than the extra check at the end of
irq_exit().

Thanks,

	tglx



