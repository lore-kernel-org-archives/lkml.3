Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3KCWqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 17:46:01 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:39450 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3KCWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 17:46:00 -0500
Date: Sun, 3 Nov 2013 14:42:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20131103224242.GF3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <20131030112526.GI16117@laptop.programming.kicks-ass.net>
 <20131031064015.GV4126@linux.vnet.ibm.com>
 <20131101145634.GH19466@laptop.lan>
 <20131102173239.GB3947@linux.vnet.ibm.com>
 <20131103144017.GA25118@linux.vnet.ibm.com>
 <20131103151704.GJ19466@laptop.lan>
 <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
 <20131103200124.GK19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131103200124.GK19466@laptop.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110322-6688-0000-0000-000003234CE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 09:01:24PM +0100, Peter Zijlstra wrote:
> On Sun, Nov 03, 2013 at 10:08:14AM -0800, Linus Torvalds wrote:
> > On Sun, Nov 3, 2013 at 7:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Sun, Nov 03, 2013 at 06:40:17AM -0800, Paul E. McKenney wrote:
> > >> If there was an smp_tmb(), I would likely use it in rcu_assign_pointer().
> > >
> > > Well, I'm obviously all for introducing this new barrier, for it will
> > > reduce a full mfence on x86 to a compiler barrier. And ppc can use
> > > lwsync as opposed to sync afaict. Not sure ARM can do better.
> > >
> > > ---
> > > Subject: arch: Introduce new TSO memory barrier smp_tmb()
> > 
> > This is specialized enough that I would *really* like the name to be
> > more descriptive. Compare to the special "smp_read_barrier_depends()"
> > maco: it's unusual, and it has very specific semantics, so it gets a
> > long and descriptive name.
> > 
> > Memory ordering is subtle enough without then using names that are
> > subtle in themselves. mb/rmb/wmb are conceptually pretty simple
> > operations, and very basic when talking about memory ordering.
> > "acquire" and "release" are less simple, but have descriptive names
> > and have very specific uses in locking.
> > 
> > In contrast "smp_tmb()" is a *horrible* name, because TSO is a
> > description of the memory ordering, not of a particular barrier. It's
> > also not even clear that you can have a "tso barrier", since the
> > ordering (like acquire/release) presumably is really about one
> > particular *store*, not about some kind of barrier between different
> > operations.
> > 
> > So please describe exactly what the semantics that barrier has, and
> > then name the barrier that way.
> > 
> > I assume that in this particular case, the semantics RCU wants is
> > "write barrier, and no preceding reads can move past this point".

Its semantics order prior reads against subsequent reads, prior reads
against subsequent writes, and prior writes against subsequent writes.
It does -not- order prior writes against subsequent reads.

> > Calling that "smp_tmb()" is f*cking insane, imnsho.
> 
> Fair enough; from what I could gather the proposed semantics are
> RELEASE+WMB, such that neither reads not writes can cross over, writes
> can't cross back, but reads could.
> 
> Since both RELEASE and WMB are trivial under TSO the entire thing
> collapses.

And here are some candidate names, with no attempt to sort sanity from
insanity:

smp_storebuffer_mb() -- A barrier that enforces those orderings
	that do not invalidate the hardware store-buffer optimization.

smp_not_w_r_mb() -- A barrier that orders everything except prior
	writes against subsequent reads.

smp_acqrel_mb() -- A barrier that combines C/C++ acquire and release
	semantics.  (C/C++ "acquire" orders a specific load against
	subsequent loads and stores, while C/C++ "release" orders
	a specific store against prior loads and stores.)

Others?

> Now I'm currently completely confused as to what C/C++ wrecks vs actual
> proper memory order issues; let alone fully comprehend the case that
> started all this.

Each can result in similar wreckage.  In either case, it is about failing
to guarantee needed orderings.

							Thanx, Paul

