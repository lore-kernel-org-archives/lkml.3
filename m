Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3KALPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:15:47 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35181 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3KALPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:15:42 -0400
Date: Wed, 30 Oct 2013 23:40:15 -0700
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
Message-ID: <20131031064015.GV4126@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131023141948.GB3566@localhost.localdomain>
 <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <20131030112526.GI16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030112526.GI16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110111-7182-0000-0000-000008F966C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:25:26PM +0100, Peter Zijlstra wrote:
> On Wed, Oct 30, 2013 at 02:27:25AM -0700, Paul E. McKenney wrote:
> > On Mon, Oct 28, 2013 at 10:58:58PM +0200, Victor Kaplansky wrote:
> > > Oleg Nesterov <oleg@redhat.com> wrote on 10/28/2013 10:17:35 PM:
> > > 
> > > >       mb();   // XXXXXXXX: do we really need it? I think yes.
> > > 
> > > Oh, it is hard to argue with feelings. Also, it is easy to be on
> > > conservative side and put the barrier here just in case.
> > > But I still insist that the barrier is redundant in your example.
> > 
> > If you were to back up that insistence with a description of the orderings
> > you are relying on, why other orderings are not important, and how the
> > important orderings are enforced, I might be tempted to pay attention
> > to your opinion.
> 
> OK, so let me try.. a slightly less convoluted version of the code in
> kernel/events/ring_buffer.c coupled with a userspace consumer would look
> something like the below.
> 
> One important detail is that the kbuf part and the kbuf_writer() are
> strictly per cpu and we can thus rely on implicit ordering for those.
> 
> Only the userspace consumer can possibly run on another cpu, and thus we
> need to ensure data consistency for those. 
> 
> struct buffer {
> 	u64 size;
> 	u64 tail;
> 	u64 head;
> 	void *data;
> };
> 
> struct buffer *kbuf, *ubuf;
> 
> /*
>  * Determine there's space in the buffer to store data at @offset to
>  * @head without overwriting data at @tail.
>  */
> bool space(u64 tail, u64 offset, u64 head)
> {
> 	offset = (offset - tail) % kbuf->size;
> 	head   = (head   - tail) % kbuf->size;
> 
> 	return (s64)(head - offset) >= 0;
> }
> 
> /*
>  * If there's space in the buffer; store the data @buf; otherwise
>  * discard it.
>  */
> void kbuf_write(int sz, void *buf)
> {
> 	u64 tail = ACCESS_ONCE(ubuf->tail); /* last location userspace read */
> 	u64 offset = kbuf->head; /* we already know where we last wrote */
> 	u64 head = offset + sz;
> 
> 	if (!space(tail, offset, head)) {
> 		/* discard @buf */
> 		return;
> 	}
> 
> 	/*
> 	 * Ensure that if we see the userspace tail (ubuf->tail) such
> 	 * that there is space to write @buf without overwriting data
> 	 * userspace hasn't seen yet, we won't in fact store data before
> 	 * that read completes.
> 	 */
> 
> 	smp_mb(); /* A, matches with D */
> 
> 	write(kbuf->data + offset, buf, sz);
> 	kbuf->head = head % kbuf->size;
> 
> 	/*
> 	 * Ensure that we write all the @buf data before we update the
> 	 * userspace visible ubuf->head pointer.
> 	 */
> 	smp_wmb(); /* B, matches with C */
> 
> 	ubuf->head = kbuf->head;
> }
> 
> /*
>  * Consume the buffer data and update the tail pointer to indicate to
>  * kernel space there's 'free' space.
>  */
> void ubuf_read(void)
> {
> 	u64 head, tail;
> 
> 	tail = ACCESS_ONCE(ubuf->tail);
> 	head = ACCESS_ONCE(ubuf->head);
> 
> 	/*
> 	 * Ensure we read the buffer boundaries before the actual buffer
> 	 * data...
> 	 */
> 	smp_rmb(); /* C, matches with B */
> 
> 	while (tail != head) {
> 		obj = ubuf->data + tail;
> 		/* process obj */
> 		tail += obj->size;
> 		tail %= ubuf->size;
> 	}
> 
> 	/*
> 	 * Ensure all data reads are complete before we issue the
> 	 * ubuf->tail update; once that update hits, kbuf_write() can
> 	 * observe and overwrite data.
> 	 */
> 	smp_mb(); /* D, matches with A */
> 
> 	ubuf->tail = tail;
> }
> 
> 
> Now the whole crux of the question is if we need barrier A at all, since
> the STORES issued by the @buf writes are dependent on the ubuf->tail
> read.

The dependency you are talking about is via the "if" statement?
Even C/C++11 is not required to respect control dependencies.

This one is a bit annoying.  The x86 TSO means that you really only
need barrier(), ARM (recent ARM, anyway) and Power could use a weaker
barrier, and so on -- but smp_mb() emits a full barrier.

Perhaps a new smp_tmb() for TSO semantics, where reads are ordered
before reads, writes before writes, and reads before writes, but not
writes before reads?  Another approach would be to define a per-arch
barrier for this particular case.

> If the read shows no available space, we simply will not issue those
> writes -- therefore we could argue we can avoid the memory barrier.

Proving that means iterating through the permitted combinations of
compilers and architectures...  There is always hand-coded assembly
language, I suppose.

> However, that leaves D unpaired and me confused. We must have D because
> otherwise the CPU could reorder that write into the reads previous and
> the kernel could start overwriting data we're still reading.. which
> seems like a bad deal.

Yep.  If you were hand-coding only for x86 and s390, D would pair with
the required barrier() asm.

> Also, I'm not entirely sure on C, that too seems like a dependency, we
> simply cannot read the buffer @tail before we've read the tail itself,
> now can we? Similarly we cannot compare tail to head without having the
> head read completed.
> 
> Could we replace A and C with an smp_read_barrier_depends()?

C, yes, given that you have ACCESS_ONCE() on the fetch from ->tail
and that the value fetch from ->tail feeds into the address used for
the "obj =" assignment.  A, not so much -- again, compilers are not
required to respect control dependencies.

							Thanx, Paul

