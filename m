Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3KAQLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:11:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54549 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3KAQLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:11:47 -0400
Date: Fri, 1 Nov 2013 17:11:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20131101161129.GU16117@laptop.programming.kicks-ass.net>
References: <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <20131030112526.GI16117@laptop.programming.kicks-ass.net>
 <20131031064015.GV4126@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031064015.GV4126@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 11:40:15PM -0700, Paul E. McKenney wrote:
> > void kbuf_write(int sz, void *buf)
> > {
> > 	u64 tail = ACCESS_ONCE(ubuf->tail); /* last location userspace read */
> > 	u64 offset = kbuf->head; /* we already know where we last wrote */
> > 	u64 head = offset + sz;
> > 
> > 	if (!space(tail, offset, head)) {
> > 		/* discard @buf */
> > 		return;
> > 	}
> > 
> > 	/*
> > 	 * Ensure that if we see the userspace tail (ubuf->tail) such
> > 	 * that there is space to write @buf without overwriting data
> > 	 * userspace hasn't seen yet, we won't in fact store data before
> > 	 * that read completes.
> > 	 */
> > 
> > 	smp_mb(); /* A, matches with D */
> > 
> > 	write(kbuf->data + offset, buf, sz);
> > 	kbuf->head = head % kbuf->size;
> > 
> > 	/*
> > 	 * Ensure that we write all the @buf data before we update the
> > 	 * userspace visible ubuf->head pointer.
> > 	 */
> > 	smp_wmb(); /* B, matches with C */
> > 
> > 	ubuf->head = kbuf->head;
> > }

> > Now the whole crux of the question is if we need barrier A at all, since
> > the STORES issued by the @buf writes are dependent on the ubuf->tail
> > read.
> 
> The dependency you are talking about is via the "if" statement?
> Even C/C++11 is not required to respect control dependencies.

But surely we must be able to make it so; otherwise you'd never be able
to write:

void *ptr = obj1;

void foo(void)
{

	/* create obj2, obj3 */

	smp_wmb(); /* ensure the objs are complete */

	/* expose either obj2 or obj3 */
	if (x)
		ptr = obj2;
	else
		ptr = obj3;


	/* free the unused one */
	if (x)
		free(obj3);
	else
		free(obj2);
}

Earlier you said that 'volatile' or '__atomic' avoids speculative
writes; so would:

volatile void *ptr = obj1;

Make the compiler respect control dependencies again? If so, could we
somehow mark that !space() condition volatile?

Currently the above would be considered a valid pattern. But you're
saying its not because the compiler is free to expose both obj2 and obj3
(for however short a time) and thus the free of the 'unused' object is
incorrect and can cause use-after-free.

In fact; how can we be sure that:

void *ptr = NULL;

void bar(void)
{
	void *obj = malloc(...);

	/* fill obj */

	if (!err)
		rcu_assign_pointer(ptr, obj);
	else
		free(obj);
}

Does not get 'optimized' into:

void bar(void)
{
	void *obj = malloc(...);
	void *old_ptr = ptr;

	/* fill obj */

	rcu_assign_pointer(ptr, obj);
	if (err) { /* because runtime profile data says this is unlikely */
		ptr = old_ptr;
		free(obj);
	}
}

We _MUST_ be able to rely on control flow, otherwise me might as well
all go back to writing kernels in asm.

