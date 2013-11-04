Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab3KDQtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:49:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36267 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3KDQs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:48:59 -0500
Date: Mon, 4 Nov 2013 17:48:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20131104164810.GM28601@twins.programming.kicks-ass.net>
References: <20131102173239.GB3947@linux.vnet.ibm.com>
 <20131103144017.GA25118@linux.vnet.ibm.com>
 <20131103151704.GJ19466@laptop.lan>
 <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
 <20131103200124.GK19466@laptop.lan>
 <20131103224242.GF3947@linux.vnet.ibm.com>
 <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104105059.GL3947@linux.vnet.ibm.com>
 <20131104112254.GK28601@twins.programming.kicks-ass.net>
 <20131104162732.GN3947@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104162732.GN3947@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 08:27:32AM -0800, Paul E. McKenney wrote:
> > 
> > 
> > /*
> >  * One important detail is that the kbuf part and the kbuf_writer() are
> >  * strictly per cpu and we can thus rely on program order for those.
> >  *
> >  * Only the userspace consumer can possibly run on another cpu, and thus we
> >  * need to ensure data consistency for those.
> >  */
> > 
> > struct buffer {
> >         u64 size;
> >         u64 tail;
> >         u64 head;
> >         void *data;
> > };
> > 
> > struct buffer *kbuf, *ubuf;
> > 
> > /*
> >  * If there's space in the buffer; store the data @buf; otherwise
> >  * discard it.
> >  */
> > void kbuf_write(int sz, void *buf)
> > {
> > 	u64 tail, head, offset;
> > 
> > 	do {
> > 		tail = ACCESS_ONCE(ubuf->tail);
> 
> So the above load is the key load.  It determines whether or not we
> have space in the buffer.  This of course assumes that only this CPU
> writes to ->head.

This assumption is true.

> If so, then:
> 
> 		tail = smp_load_with_acquire_semantics(ubuf->tail); /* A -> D */
> 

OK, the way I understand ACQUIRE semantics are the semi-permeable LOCK
semantics from Documetnation/memory-barriers.txt. In which case the
relevant STORES below could be hoisted up here, but not across the READ,
which I suppose is sufficient.

> > 		offset = head = kbuf->head;
> > 		if (CIRC_SPACE(head, tail, kbuf->size) < sz) {
> > 			/* discard @buf */
> > 			return;
> > 		}
> > 		head += sz;
> > 	} while (local_cmpxchg(&kbuf->head, offset, head) != offset)
> 
> If there is an issue with kbuf->head, presumably local_cmpxchg() fails
> and we retry.
> 
> But sheesh, do you think we could have buried the definitions of
> local_cmpxchg() under a few more layers of macro expansion just to
> keep things more obscure?  Anyway, griping aside...
> 
> o	__cmpxchg_local_generic() in include/asm-generic/cmpxchg-local.h
> 	doesn't seem to exclude NMIs, so is not safe for this usage.
> 
> o	__cmpxchg_local() in ARM handles NMI as long as the
> 	argument is 32 bits, otherwise, it uses the aforementionted
> 	__cmpxchg_local_generic(), which does not handle NMI.  Given your
> 	u64, this does not look good...
> 
> 	And some ARM subarches (e.g., metag) seem to fail to handle NMI
> 	even in the 32-bit case.
> 
> o	FRV and M32r seem to act similar to ARM.
> 
> Or maybe these architectures don't do NMIs?  If they do, local_cmpxchg()
> does not seem to be safe against NMIs in general.  :-/
> 
> That said, powerpc, 64-bit s390, sparc, and x86 seem to handle it.

Ah my bad, so the in-kernel kbuf variant uses unsigned long, which on
all archs should be the native words size and cover the address space.

Only the public variant (ubuf) is u64 wide to not change data structure
layout on compat etc.

I suppose this was a victim on the simplification :/

And in case of 32bit the upper word will always be zero and the partial
reads should all work out just fine.

> Of course, x86's local_cmpxchg() has full memory barriers implicitly.

Not quite, the 'lock' in __raw_cmpxchg() expands to "" due to
__cmpxchg_local(), etc.. 

> > 
> >         /*
> >          * Ensure that if we see the userspace tail (ubuf->tail) such
> >          * that there is space to write @buf without overwriting data
> >          * userspace hasn't seen yet, we won't in fact store data before
> >          * that read completes.
> >          */
> > 
> >         smp_mb(); /* A, matches with D */
> 
> Given a change to smp_load_with_acquire_semantics() above, you should not
> need this smp_mb().

Because the STORES can not be hoisted across the ACQUIRE, indeed.

> 
> >         memcpy(kbuf->data + offset, buf, sz);
> > 
> >         /*
> >          * Ensure that we write all the @buf data before we update the
> >          * userspace visible ubuf->head pointer.
> >          */
> >         smp_wmb(); /* B, matches with C */
> > 
> >         ubuf->head = kbuf->head;
> 
> Replace the smp_wmb() and the assignment with:
> 
> 	smp_store_with_release_semantics(ubuf->head, kbuf->head); /* B -> C */

And here the RELEASE semantics I assume are the same as the
semi-permeable UNLOCK from _The_ document? In which case the above
STORES cannot be lowered across this store and all should, again, be
well.

> > }
> > 
> > /*
> >  * Consume the buffer data and update the tail pointer to indicate to
> >  * kernel space there's 'free' space.
> >  */
> > void ubuf_read(void)
> > {
> >         u64 head, tail;
> > 
> >         tail = ACCESS_ONCE(ubuf->tail);
> 
> Does anyone else write tail?  Or is this defense against NMIs?

No, we're the sole writer; just general paranoia. Not sure the actual
userspace does this; /me checks. Nope, distinct lack of ACCESS_ONCE()
there, just the rmb(), which including a barrier() should hopefully
accomplish similar things most of the time ;-)

I'll need to introduce ACCESS_ONCE to the userspace code.

> If no one else writes to tail and if NMIs cannot muck things up, then
> the above ACCESS_ONCE() is not needed, though I would not object to its
> staying.
> 
> >         head = ACCESS_ONCE(ubuf->head);
> 
> Make the above be:
> 
> 	head = smp_load_with_acquire_semantics(ubuf->head);  /* C -> B */
> 
> >         /*
> >          * Ensure we read the buffer boundaries before the actual buffer
> >          * data...
> >          */
> >         smp_rmb(); /* C, matches with B */
> 
> And drop the above memory barrier.
> 
> >         while (tail != head) {
> >                 obj = ubuf->data + tail;
> >                 /* process obj */
> >                 tail += obj->size;
> >                 tail %= ubuf->size;
> >         }
> > 
> >         /*
> >          * Ensure all data reads are complete before we issue the
> >          * ubuf->tail update; once that update hits, kbuf_write() can
> >          * observe and overwrite data.
> >          */
> >         smp_mb(); /* D, matches with A */
> > 
> >         ubuf->tail = tail;
> 
> Replace the above barrier and the assignment with:
> 
> 	smp_store_with_release_semantics(ubuf->tail, tail); /* D -> B. */
> 
> > }

Right, so this consumer side isn't called that often and the two
barriers are only per consume, not per event, so I don't care too much
about these.

It would also mean hoisting the implementation of the proposed
primitives into userspace -- which reminds me: should we make
include/asm/barrier.h a uapi header?

> All this is leading me to suggest the following shortenings of names:
> 
> 	smp_load_with_acquire_semantics() -> smp_load_acquire()
> 
> 	smp_store_with_release_semantics() -> smp_store_release()
> 
> But names aside, the above gets rid of explicit barriers on TSO architectures,
> allows ARM to avoid full DMB, and allows PowerPC to use lwsync instead of
> the heavier-weight sync.

Totally awesome! ;-) And full ack on the shorter names.
