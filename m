Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab3BZQyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:54:18 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:38184 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab3BZQyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:54:17 -0500
Date: Tue, 26 Feb 2013 08:39:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] irq: Cleanup context state transitions in irq_exit()
Message-ID: <20130226163911.GA3309@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com>
 <1361496971-16939-3-git-send-email-fweisbec@gmail.com>
 <alpine.LFD.2.02.1302221528470.22263@ionos>
 <20130222150444.GD18149@somewhere.redhat.com>
 <alpine.LFD.2.02.1302221605520.22263@ionos>
 <CA+55aFxOreKQ-uzfMtXEb6XH4D8By2i=qOxfDLJnchSYsa34PQ@mail.gmail.com>
 <alpine.LFD.2.02.1302261308550.22263@ionos>
 <CAFTL4hyYRO3MGBy9SgCvB+jhBTtW=RH3Pb4cXGpYMQJfCa3M5g@mail.gmail.com>
 <alpine.LFD.2.02.1302261614060.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1302261614060.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022616-7282-0000-0000-000014A0AC83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 04:14:43PM +0100, Thomas Gleixner wrote:
> 
> On Tue, 26 Feb 2013, Frederic Weisbecker wrote:
> 
> > 2013/2/26 Thomas Gleixner <tglx@linutronix.de>:
> > > On Fri, 22 Feb 2013, Linus Torvalds wrote:
> > >> On Fri, Feb 22, 2013 at 7:06 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >> >>
> > >> >> I prefer to let you guys have the final word on this patch. Whether you
> > >> >> apply it or not, I fear I'll never be entirely happy either way :)
> > >> >> That's the sad fate of dealing with circular dependencies...
> > >> >
> > >> > plus the butt ugly softirq semantics or the lack thereof ...
> > >>
> > >> The softirq semantics are perfectly fine. Don't blame softirq for the
> > >> fact that irq_exit() has had shit-for-brains for a long time.
> > >>
> > >> Just move the whole "invoke_softirq()" thing down to *after* the
> > >> tick_nohz_irq_exit() stuff.
> > >
> > > We can't move tick_nohz_irq_exit() before invoke_softirq() simply
> > > because we need to take the timers into account for NOHZ and those can
> > > change when the softirq code runs.
> > >
> > > So no, we need an extra check after invoke_softirq() and the same is
> > > true for RCU.
> > 
> > And what do you think about Linus's idea to move tick_nohz_irq_exit()
> > to do_softirq()?
> > This sounds feasible and a right place to do this, I hope that won't
> > uglify do_softirq() though.
> > I can try something.
> 
> Yeah, looks doable. the rcu stuff needs to go there as well, right?

If it does, it needs to do so in such a way that rcu_irq_enter() and
rcu_irq_exit() nest properly.  One area of concern is the force_irqthreads
case, skips calling do_softirq().  Another area of concern is the
__ARCH_IRQ_EXIT_IRQS_DISABLED case, which calls __do_softirq() rather
than do_softirq().

Or am I missing some adjustment that is to be made when moving rcu_irq_exit()
to do_softirq()?

							Thanx, Paul

