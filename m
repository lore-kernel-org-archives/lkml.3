Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3KYTxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:53:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:55151 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab3KYTxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:53:04 -0500
Message-ID: <1385409103.9218.15.camel@pasglop>
Subject: Re: Preventing IPI sending races in arch code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Noam Camus <noamc@ezchip.com>,
        David Daney <david.daney@cavium.com>,
        James Hogan <james.hogan@imgtec.com>,
        thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Richard Kuo <rkuo@codeaurora.org>
Date: Tue, 26 Nov 2013 06:51:43 +1100
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307515715C@IN01WEMBXA.internal.synopsys.com>
References: <52932BE2.5010201@synopsys.com>
	 <20131125110006.GU3866@twins.programming.kicks-ass.net>
	 <529334CA.1000401@synopsys.com>
	 <20131125122726.GZ10022@twins.programming.kicks-ass.net>
	 <C2D7FE5348E1B147BCA15975FBA2307515715C@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 13:35 +0000, Vineet Gupta wrote:

> Before reading ur email I was coding something like below:
> 
> void arch_send_ipi(int cpu, int type)
> {
>   u32 *pending_ptr = per_cpu_ptr(ipi_bits, cpu);
> 
>   while (cmpxchg(pending_ptr, 0, 1 << type) != 0)
> 	cpu_relax();
> 
>   raise_ipi(cpu);
> }

So you would have blocked the sender while there was already
a pending IPI on the target ? Why ?

The optimization proposed by Peter is actually the only interesting
change here, without it the existing set_bit was perfectly fine.
Remember that set_bit is atomic.

Ben.

> But obviously your version is nicer due to optimization, unless I'm over-analyzing it.
> 
> 
> > Also, the above can be thought of as a memory ordering issue:
> >
> >   STORE pending
> >   MB /* implied by cmpxchg */
> >   STORE ipi /* raise the actual thing */
> >
> > In that case the other end must be:
> >
> >   LOAD ipi
> >   MB /* implied by xchg */
> >   LOAD pending
> >
> > Which is what your code seems to do.
> 
> ...
> 
> >
> >> IMO the while loop is
> >> completely useless specially if IPIs are not coalesced in h/w. 
> > Agreed, the while loops seems superfluous.
> 
> Not with your version of sender, since we need it as described above.
> 
> >> And we need to move
> >> the xchg ahead of ACK'ing the IPI
> >>
> >> do_IPI
> >>    pending = xchg(&ipi_data->bits, 0);
> >>    plat_smp_ops.ipi_clear(irq);
> >>    while (ffs....)
> >>       switch(next-msg)
> >>       ...
> >>
> >> Does that look sane to you.
> > This I'm not at all certain of; continuing with the memory order analogy
> > this would allow for the case where we see 0 pending, set a bit, try and
> > raise the interrupt but then do not because its already assert.
> >
> > And since you just removed the while() loop, we'll be left with a !0
> > pending vector and nobody processing it.
> 
> Right we need it with ur version of sender. Bit don't with my simplistic one.
> 
> -Vineet
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


