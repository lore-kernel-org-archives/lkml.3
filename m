Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3KYN5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:57:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41809 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab3KYN5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:57:39 -0500
Date: Mon, 25 Nov 2013 14:57:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Noam Camus <noamc@ezchip.com>,
        David Daney <david.daney@cavium.com>,
        James Hogan <james.hogan@imgtec.com>,
        thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Richard Kuo <rkuo@codeaurora.org>
Subject: Re: Preventing IPI sending races in arch code
Message-ID: <20131125135725.GA10022@twins.programming.kicks-ass.net>
References: <52932BE2.5010201@synopsys.com>
 <20131125110006.GU3866@twins.programming.kicks-ass.net>
 <529334CA.1000401@synopsys.com>
 <20131125122726.GZ10022@twins.programming.kicks-ass.net>
 <C2D7FE5348E1B147BCA15975FBA2307515715C@IN01WEMBXA.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307515715C@IN01WEMBXA.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 01:35:38PM +0000, Vineet Gupta wrote:
> On 11/25/2013 05:57 PM, Peter Zijlstra wrote:

> > So sure, then someone can again assert the interrupt, but given we just
> > established a protocol for raising the thing; namely something like
> > this:
> >
> > void arch_send_ipi(int cpu, int type)
> > {
> >   u32 *pending_ptr = per_cpu_ptr(ipi_bits, cpu);
> >   u32 new, old;
> >
> >   do {
> >   	new = old = *pending_ptr;
> > 	new |= 1U << type;
> >   } while (cmpxchg(pending_ptr, old, new) != old)
> >
> >   if (!old) /* only raise the actual IPI if we set the first bit */
> >   	raise_ipi(cpu);
> > }
> >
> > Who would re-assert it if we have !0 pending?
> 
> I see your point. So in receiver, it is OK to de-assert the IPI before processing
> the msg itself.
> 
> Actually your code seems to be optimizing away asserting an IPI, if sender already
> had a pending msg (assuming we retain the xchg loop in receiver). Was that an
> intended optimization - or just a side effect of your code ;-)

No, full intention. As you mentioned you wanted to avoid sending IPIs
where none were needed.

> >> IMO the while loop is
> >> completely useless specially if IPIs are not coalesced in h/w. 
> > Agreed, the while loops seems superfluous.
> 
> Not with your version of sender, since we need it as described above.

No, even with my code; the receiving end should look like:

void handle_ipi(struct pt_regs *regs)
{
	u32 pending;

	ipi_clear(irq);

	pending = xchg(this_cpu_ptr(ipi_bits), 0);

	while (pending) {
		bit = ffs(pending);

		/* handle bit */

		pending &= ~(1U << bit);
	}
}

So while it does have a while() loop, it only does a single xchg().

The version you showed before had the xchg() in the loop, that is not
required.
