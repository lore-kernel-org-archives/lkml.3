Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaEGXO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:14:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:51048 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaEGXO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:14:56 -0400
Date: Thu, 8 May 2014 01:15:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>, Tony Lu <zlu@tilera.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 03/32] genirq: Provide generic hwirq allocation
 facility
In-Reply-To: <536A998A.4000307@tilera.com>
Message-ID: <alpine.DEB.2.02.1405072259230.6261@ionos.tec.linutronix.de>
References: <20140507153622.703412101@linutronix.de> <20140507154334.208629358@linutronix.de> <536A998A.4000307@tilera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Chris Metcalf wrote:

> On 5/7/2014 11:44 AM, Thomas Gleixner wrote:
> > Not really the solution to the problem, but at least it confines the
> > mess in the core code and allows to get rid of the create/destroy_irq
> > variants from hell, i.e. 3 implementations with different semantics
> > plus the x86 specific variants __create_irqs and create_irq_nr
> > which have been invented in another circle of hell.
> >
> > [...]
> >
> > tile: Might use irq domains as well, but it has a very limited
> >       interrupt space, so handling it via this functionality might be
> >       the right thing to do even in the long run.
> 
> We have an internal change that we haven't upstreamed yet that makes
> irqs actually (cpu,ipi) pairs, so that more irqs can be allocated.
> As a result we allocate some irqs as bound to a specific IPI on a single
> cpu, and some irqs get bound to a particular IPI registered on every cpu.
>
> I'll have to set aside a bit of time to look more closely at how your
> change interacts with the work we've done internally.  I've appended the
> per-cpu IRQ change from our internal tree here (and cc'ed the author).
> The API change is in the <asm/irq.h> diff at the very start.

Sure it'll break it. And I said clearly it's only designed for simple
allocations.

And no, we really can do without

> +int create_irq_on(int cpu);
> +static inline int create_irq_on_any(void)
> +int create_irq(void);

or any other new abomination of this coming along with another private
allocation mechanism.

The issue you are describing is very similar to what x86 needs for
handling the hardware vector space and that's existing x86 private
horror which needs a replacement. Itanic could use something like that
as well, but I doubt that anyone is masochistic enough to tackle the
never sinking ship :)

So the right thing to do is to provide a generic infrastructure for
handling a matrix mapping.

So basically we need something like this:

   bitmap __percpu *vector_map;

   vector_map = alloc_percpu(sizeof bitmap);

And an allocation function, which takes a cpumask and not a single
cpu. With your approach you are going to add create_irq_mask() faster
than you can mainline the first cruft. That wants to be an algorithm
which searches for a free slot in some intelligent way, i.e. using
free slots which are already occupied on at least one cpu instead of
using up the globaly free slots right away. It's not that hard to do
if you have bitmaps.

Plus the corresponding free and supporting helpers.

Now on top of that we need irq domain support for this kind of matrix
mappings down to the vector level and everything else falls in
place. I have not thought through the irq domain angle, but maybe
Grant/Ben can give some input on that.

Sorry for spoiling your plans. I went a long way in the past 10 years
to consolidate all that as far as it goes, and I'm not willing to
accept any new arch specific interrupt infrastructure which goes
beyond the low level hardware requirements.

Thanks,

	tglx
