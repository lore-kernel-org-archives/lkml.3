Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3BZTSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:18:18 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40694 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932591Ab3BZTSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:18:17 -0500
Date: Tue, 26 Feb 2013 11:17:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] irq: Cleanup context state transitions in irq_exit()
Message-ID: <20130226191758.GA28847@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1361496971-16939-3-git-send-email-fweisbec@gmail.com>
 <alpine.LFD.2.02.1302221528470.22263@ionos>
 <20130222150444.GD18149@somewhere.redhat.com>
 <alpine.LFD.2.02.1302221605520.22263@ionos>
 <CA+55aFxOreKQ-uzfMtXEb6XH4D8By2i=qOxfDLJnchSYsa34PQ@mail.gmail.com>
 <alpine.LFD.2.02.1302261308550.22263@ionos>
 <CAFTL4hyYRO3MGBy9SgCvB+jhBTtW=RH3Pb4cXGpYMQJfCa3M5g@mail.gmail.com>
 <alpine.LFD.2.02.1302261614060.22263@ionos>
 <20130226163911.GA3309@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1302261950120.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1302261950120.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022619-7182-0000-0000-00000587E779
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 07:55:06PM +0100, Thomas Gleixner wrote:
> On Tue, 26 Feb 2013, Paul E. McKenney wrote:
> > On Tue, Feb 26, 2013 at 04:14:43PM +0100, Thomas Gleixner wrote:
> > > 
> > > On Tue, 26 Feb 2013, Frederic Weisbecker wrote:
> > > > And what do you think about Linus's idea to move tick_nohz_irq_exit()
> > > > to do_softirq()?
> > > > This sounds feasible and a right place to do this, I hope that won't
> > > > uglify do_softirq() though.
> > > > I can try something.
> > > 
> > > Yeah, looks doable. the rcu stuff needs to go there as well, right?
> > 
> > If it does, it needs to do so in such a way that rcu_irq_enter() and
> > rcu_irq_exit() nest properly.  One area of concern is the force_irqthreads
> > case, skips calling do_softirq().  Another area of concern is the
> > __ARCH_IRQ_EXIT_IRQS_DISABLED case, which calls __do_softirq() rather
> > than do_softirq().
> 
> That's sorted already. We disable interrupts in irq_exit().
> 
> > Or am I missing some adjustment that is to be made when moving rcu_irq_exit()
> > to do_softirq()?
> 
> Yeah, we need an extra parameter or such, so the other callers of
> __do_softirq() don't mess with it.
> 
> I also noticed that rcu_irq_enter/exit needs to be symetric and the
> NOHZ code will get confused as well if we call it asymetric.

Exactly!

							Thanx, Paul

> So that will become even more ugly than the extra check at the end of
> irq_exit().
> 
> Thanks,
> 
> 	tglx
> 
> 
> 

