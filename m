Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3IUVrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 17:47:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:36333 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab3IUVrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 17:47:08 -0400
Message-ID: <1379799901.24090.6.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Date: Sun, 22 Sep 2013 07:45:01 +1000
In-Reply-To: <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-21 at 13:58 -0500, Frederic Weisbecker wrote:

> Now certainly what needs to be fixed then is archs that don't have
> __ARCH_IRQ_EXIT_IRQS_DISABLED
> or archs that have any other significant opportunity to nest interrupt.

Interesting. I notice we don't define it on powerpc but we don't enable
IRQs in do_IRQ either... our path is very similar to x86 in this regard,
the only thing that can cause them to become enabled would be if a
driver interrupt handler did local_irq_enable().

It used to be fairly common for drivers to do spin_unlock_irq() which
would unconditionally re-enable. Did we add WARNs or lockdep logic to
catch these nowadays ?

> >  - process context doing local_bh_enable, and a bh became pending
> > while it was disabled. See above: this needs a stack switch. Which
> > stack to use is open, again assuming that a hardirq coming in will
> > switch to yet another stack.
> 
> Right. Now if we do like Thomas suggested, we can have a common irq
> stack that is big enough for hard and softirqs. After all there should
> never be more than two or three nesting irq contexts:
> hardirq->softirq->hardirq, softirq->hardirq, ...
> 
> At least if we put aside the unsane archs that can nest irqs somehow.

I really don't like the "larger" irq stack ... probably because I can't
make it work easily :-) See my previous comment about how we get to
thread_info on ppc.

What I *can* do that would help I suppose would be to switch to the irq
stack before irq_enter/exit which would at least mean that softirq would
run from the top of the irq stack which is better than the current
situation.

I'm fact I'll whip up a quick fix see if that might be enough of a band
aid for RHEL7.

Cheers,
Ben.

