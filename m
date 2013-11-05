Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3KESud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:50:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37370 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3KESuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:50:32 -0500
Date: Tue, 5 Nov 2013 19:49:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
Message-ID: <20131105184943.GY16117@laptop.programming.kicks-ass.net>
References: <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
 <20131103200124.GK19466@laptop.lan>
 <20131103224242.GF3947@linux.vnet.ibm.com>
 <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104105059.GL3947@linux.vnet.ibm.com>
 <20131104112254.GK28601@twins.programming.kicks-ass.net>
 <20131104162732.GN3947@linux.vnet.ibm.com>
 <20131104191127.GW16117@laptop.programming.kicks-ass.net>
 <20131104205344.GW3947@linux.vnet.ibm.com>
 <20131105140548.GD26895@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105140548.GD26895@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 02:05:48PM +0000, Will Deacon wrote:
> > > +
> > > +#define smp_store_release(p, v)                                              \
> > > +do {                                                                 \
> > > +     smp_mb();                                                       \
> > > +     ACCESS_ONCE(p) = (v);                                           \
> > > +} while (0)
> > > +
> > > +#define smp_load_acquire(p, v)                                               \
> > > +do {                                                                 \
> > > +     typeof(p) ___p1 = ACCESS_ONCE(p);                               \
> > > +     smp_mb();                                                       \
> > > +     return ___p1;                                                   \
> > > +} while (0)
> 
> What data sizes do these accessors operate on? Assuming that we want
> single-copy atomicity (with respect to interrupts in the UP case), we
> probably want a check to stop people passing in things like structs.

Fair enough; I think we should restrict to native word sizes same as we
do for atomics.

Something like so perhaps:

#ifdef CONFIG_64BIT
#define __check_native_word(t)	(sizeof(t) == 4 || sizeof(t) == 8)
#else
#define __check_native_word(t)	(sizeof(t) == 4)
#endif

#define smp_store_release(p, v) 		\
do {						\
	BUILD_BUG_ON(!__check_native_word(p));	\
	smp_mb();				\
	ACCESS_ONCE(p) = (v);			\
} while (0)

> > > +#define smp_store_release(p, v)                                              \
> > > +do {                                                                 \
> > > +     asm volatile ("stlr %w0 [%1]" : : "r" (v), "r" (&p) : "memory");\
> 
> Missing comma between the operands. Also, that 'w' output modifier enforces
> a 32-bit store (same early question about sizes). Finally, it might be more
> efficient to use "=Q" for the addressing mode, rather than take the address
> of p manually.

so something like:

	asm volatile ("stlr %0, [%1]" : : "r" (v), "=Q" (p) : "memory");

?

My inline asm foo is horrid and I mostly get by with copy paste from a
semi similar existing form :/

> Random other question: have you considered how these accessors should behave
> when presented with __iomem pointers?

A what? ;-)
