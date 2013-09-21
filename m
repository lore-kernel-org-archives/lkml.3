Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3IUX1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 19:27:09 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:54454 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3IUX1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 19:27:07 -0400
Date: Sat, 21 Sep 2013 18:27:02 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Message-ID: <20130921232650.GA11972@localhost.localdomain>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
 <20130920162603.GA30381@localhost.localdomain>
 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
 <1379799901.24090.6.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379799901.24090.6.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 07:45:01AM +1000, Benjamin Herrenschmidt wrote:
> On Sat, 2013-09-21 at 13:58 -0500, Frederic Weisbecker wrote:
> 
> > Now certainly what needs to be fixed then is archs that don't have
> > __ARCH_IRQ_EXIT_IRQS_DISABLED
> > or archs that have any other significant opportunity to nest interrupt.
> 
> Interesting. I notice we don't define it on powerpc

Yeah, x86 doesn't define it either. In fact few archs do.

> but we don't enable
> IRQs in do_IRQ either... our path is very similar to x86 in this regard,
> the only thing that can cause them to become enabled would be if a
> driver interrupt handler did local_irq_enable().
> 
> It used to be fairly common for drivers to do spin_unlock_irq() which
> would unconditionally re-enable. Did we add WARNs or lockdep logic to
> catch these nowadays ?

Right there is a check in handle_irq_event_percpu() that warns if the handler
exits with irqs enabled.

And irq_exit() also warns when (__ARCH_IRQ_EXIT_IRQS_DISABLED && !irq_disabled())

> 
> > >  - process context doing local_bh_enable, and a bh became pending
> > > while it was disabled. See above: this needs a stack switch. Which
> > > stack to use is open, again assuming that a hardirq coming in will
> > > switch to yet another stack.
> > 
> > Right. Now if we do like Thomas suggested, we can have a common irq
> > stack that is big enough for hard and softirqs. After all there should
> > never be more than two or three nesting irq contexts:
> > hardirq->softirq->hardirq, softirq->hardirq, ...
> > 
> > At least if we put aside the unsane archs that can nest irqs somehow.
> 
> I really don't like the "larger" irq stack ... probably because I can't
> make it work easily :-) See my previous comment about how we get to
> thread_info on ppc.
> 
> What I *can* do that would help I suppose would be to switch to the irq
> stack before irq_enter/exit which would at least mean that softirq would
> run from the top of the irq stack which is better than the current
> situation.

Yeah I think that doing this should solve the biggest part of the problem on ppc.
You'll at least ensure that you have splitup stacks for tasks and softirq/irq stacks.

> 
> I'm fact I'll whip up a quick fix see if that might be enough of a band
> aid for RHEL7.
> 
> Cheers,
> Ben.
> 
