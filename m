Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3KCEEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 00:04:39 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45645 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3KCEEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 00:04:37 -0400
Date: Sat, 2 Nov 2013 10:46:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131102174645.GC3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <20131030112526.GI16117@laptop.programming.kicks-ass.net>
 <20131031064015.GV4126@linux.vnet.ibm.com>
 <20131101161129.GU16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101161129.GU16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110304-6688-0000-0000-0000031E2360
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 05:11:29PM +0100, Peter Zijlstra wrote:
> On Wed, Oct 30, 2013 at 11:40:15PM -0700, Paul E. McKenney wrote:
> > > void kbuf_write(int sz, void *buf)
> > > {
> > > 	u64 tail = ACCESS_ONCE(ubuf->tail); /* last location userspace read */
> > > 	u64 offset = kbuf->head; /* we already know where we last wrote */
> > > 	u64 head = offset + sz;
> > > 
> > > 	if (!space(tail, offset, head)) {
> > > 		/* discard @buf */
> > > 		return;
> > > 	}
> > > 
> > > 	/*
> > > 	 * Ensure that if we see the userspace tail (ubuf->tail) such
> > > 	 * that there is space to write @buf without overwriting data
> > > 	 * userspace hasn't seen yet, we won't in fact store data before
> > > 	 * that read completes.
> > > 	 */
> > > 
> > > 	smp_mb(); /* A, matches with D */
> > > 
> > > 	write(kbuf->data + offset, buf, sz);
> > > 	kbuf->head = head % kbuf->size;
> > > 
> > > 	/*
> > > 	 * Ensure that we write all the @buf data before we update the
> > > 	 * userspace visible ubuf->head pointer.
> > > 	 */
> > > 	smp_wmb(); /* B, matches with C */
> > > 
> > > 	ubuf->head = kbuf->head;
> > > }
> 
> > > Now the whole crux of the question is if we need barrier A at all, since
> > > the STORES issued by the @buf writes are dependent on the ubuf->tail
> > > read.
> > 
> > The dependency you are talking about is via the "if" statement?
> > Even C/C++11 is not required to respect control dependencies.
> 
> But surely we must be able to make it so; otherwise you'd never be able
> to write:
> 
> void *ptr = obj1;
> 
> void foo(void)
> {
> 
> 	/* create obj2, obj3 */
> 
> 	smp_wmb(); /* ensure the objs are complete */
> 
> 	/* expose either obj2 or obj3 */
> 	if (x)
> 		ptr = obj2;
> 	else
> 		ptr = obj3;

OK, the smp_wmb() orders the creation and the exposing.  But the
compiler can do this:

	ptr = obj3;
	if (x)
		ptr = obj2;

And that could momentarily expose obj3 to readers, and these readers
might be fatally disappointed by the free() below.  If you instead said:

	if (x)
		ACCESS_ONCE(ptr) = obj2;
	else
		ACCESS_ONCE(ptr) = obj3;

then the general consensus appears to be that the compiler would not
be permitted to carry out the above optimization.  Since you have
the smp_wmb(), readers that are properly ordered (e.g., smp_rmb() or
rcu_dereference()) would be prevented from seeing pre-initialization
state.

> 	/* free the unused one */
> 	if (x)
> 		free(obj3);
> 	else
> 		free(obj2);
> }
> 
> Earlier you said that 'volatile' or '__atomic' avoids speculative
> writes; so would:
> 
> volatile void *ptr = obj1;
> 
> Make the compiler respect control dependencies again? If so, could we
> somehow mark that !space() condition volatile?

The compiler should, but the CPU is still free to ignore the control
dependencies in the general case.

We might be able to rely on weakly ordered hardware refraining
from speculating stores, but not sure that this applies across all
architectures of interest.  We definitely can -not- rely on weakly
ordered hardware refraining from speculating loads.

> Currently the above would be considered a valid pattern. But you're
> saying its not because the compiler is free to expose both obj2 and obj3
> (for however short a time) and thus the free of the 'unused' object is
> incorrect and can cause use-after-free.

Yes, it is definitely unsafe and invalid in absence of ACCESS_ONCE().

> In fact; how can we be sure that:
> 
> void *ptr = NULL;
> 
> void bar(void)
> {
> 	void *obj = malloc(...);
> 
> 	/* fill obj */
> 
> 	if (!err)
> 		rcu_assign_pointer(ptr, obj);
> 	else
> 		free(obj);
> }
> 
> Does not get 'optimized' into:
> 
> void bar(void)
> {
> 	void *obj = malloc(...);
> 	void *old_ptr = ptr;
> 
> 	/* fill obj */
> 
> 	rcu_assign_pointer(ptr, obj);
> 	if (err) { /* because runtime profile data says this is unlikely */
> 		ptr = old_ptr;
> 		free(obj);
> 	}
> }

In this particular case, the barrier() implied by the smp_wmb() in
rcu_assign_pointer() will prevent this "optimization".  However, other
"optimizations" are the reason why I am working to introduce ACCESS_ONCE()
into rcu_assign_pointer.

> We _MUST_ be able to rely on control flow, otherwise me might as well
> all go back to writing kernels in asm.

It isn't -that- bad!  ;-)

							Thanx, Paul

