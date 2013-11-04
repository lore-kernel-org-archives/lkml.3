Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3KDRCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:02:43 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51403 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KDRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:02:42 -0500
Date: Mon, 4 Nov 2013 08:34:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
Message-ID: <20131104163421.GO3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131031064015.GV4126@linux.vnet.ibm.com>
 <20131101145634.GH19466@laptop.lan>
 <20131102173239.GB3947@linux.vnet.ibm.com>
 <20131103144017.GA25118@linux.vnet.ibm.com>
 <20131103151704.GJ19466@laptop.lan>
 <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
 <20131103200124.GK19466@laptop.lan>
 <20131103224242.GF3947@linux.vnet.ibm.com>
 <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104110553.GA8595@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104110553.GA8595@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-0928-0000-0000-0000034001A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 11:05:53AM +0000, Will Deacon wrote:
> On Sun, Nov 03, 2013 at 11:34:00PM +0000, Linus Torvalds wrote:
> > So it would *kind* of act like a "smp_wmb() + smp_rmb()", but the
> > problem is that a "smp_rmb()" doesn't really "attach" to the preceding
> > write.
> 
> Agreed.
> 
> > This is analogous to a "acquire" operation: you cannot make an
> > "acquire" barrier, because it's not a barrier *between* two ops, it's
> > associated with one particular op.
> > 
> > So what I *think* you actually really really want is a "store with
> > release consistency, followed by a write barrier".
> 
> How does that order reads against reads? (Paul mentioned this as a
> requirement). I not clear about the use case for this, so perhaps there is a
> dependency that I'm not aware of.

An smp_store_with_release_semantics() orders against prior reads -and-
writes.  It maps to barrier() for x86, stlr for ARM, and lwsync for
PowerPC, as called out in my prototype definitions.

> > In TSO, afaik all stores have release consistency, and all writes are
> > ordered, which is why this is a no-op in TSO. And x86 also has that
> > "all stores have release consistency, and all writes are ordered"
> > model, even if TSO doesn't really describe the x86 model.
> > 
> > But on ARM64, for example, I think you'd really want the store itself
> > to be done with "stlr" (store with release), and then follow up with a
> > "dsb st" after that.
> 
> So a dsb is pretty heavyweight here (it prevents execution of *any* further
> instructions until all preceeding stores have completed, as well as
> ensuring completion of any ongoing cache flushes). In conjunction with the
> store-release, that's going to hold everything up until the store-release
> (and therefore any preceeding memory accesses) have completed. Granted, I
> think that gives Paul his read/read ordering, but it's a lot heavier than
> what's required.

I do not believe that we need the trailing "dsb st".

> > And notice how that requires you to mark the store itself. There is no
> > actual barrier *after* the store that does the optimized model.
> > 
> > Of course, it's entirely possible that it's not worth worrying about
> > this on ARM64, and that just doing it as a "normal store followed by a
> > full memory barrier" is good enough. But at least in *theory* a
> > microarchitecture might make it much cheaper to do a "store with
> > release consistency" followed by "write barrier".
> 
> I agree with the sentiment but, given that this stuff is so heavily
> microarchitecture-dependent (and not simple to probe), a simple dmb ish
> might be the best option after all. That's especially true if the
> microarchitecture decided to ignore the barrier options and treat everything
> as `all accesses, full system' in order to keep the hardware design simple.

I believe that we can do quite a bit better with current hardware
instructions (in the case of ARM, for a recent definition of "current")
and also simplify the memory ordering quite a bit.

								Thanx, Paul

