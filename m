Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab3KDKvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:51:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49840 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3KDKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:51:08 -0500
Date: Mon, 4 Nov 2013 02:51:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20131104105059.GL3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131030112526.GI16117@laptop.programming.kicks-ass.net>
 <20131031064015.GV4126@linux.vnet.ibm.com>
 <20131101145634.GH19466@laptop.lan>
 <20131102173239.GB3947@linux.vnet.ibm.com>
 <20131103144017.GA25118@linux.vnet.ibm.com>
 <20131103151704.GJ19466@laptop.lan>
 <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
 <20131103200124.GK19466@laptop.lan>
 <20131103224242.GF3947@linux.vnet.ibm.com>
 <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110410-3532-0000-0000-000002B6DBEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 03:34:00PM -0800, Linus Torvalds wrote:
> On Sun, Nov 3, 2013 at 2:42 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > smp_storebuffer_mb() -- A barrier that enforces those orderings
> >         that do not invalidate the hardware store-buffer optimization.
> 
> Ugh. Maybe. Can you guarantee that those are the correct semantics?
> And why talk about the hardware semantics, when you really want
> specific semantics for the *software*.
> 
> > smp_not_w_r_mb() -- A barrier that orders everything except prior
> >         writes against subsequent reads.
> 
> Ok, that sounds more along the lines of "these are the semantics we
> want", but I have to say, it also doesn't make me go "ahh, ok".
> 
> > smp_acqrel_mb() -- A barrier that combines C/C++ acquire and release
> >         semantics.  (C/C++ "acquire" orders a specific load against
> >         subsequent loads and stores, while C/C++ "release" orders
> >         a specific store against prior loads and stores.)
> 
> I don't think this is true. acquire+release is much stronger than what
> you're looking for - it doesn't allow subsequent reads to move past
> the write (because that would violate the acquire part). On x86, for
> example, you'd need to have a locked cycle for smp_acqrel_mb().
> 
> So again, what are the guarantees you actually want? Describe those.
> And then make a name.

I was thinking in terms of the guarantee that TSO systems provide
given a barrier() directive, and that PowerPC provides given the lwsync
instruction.  This guarantee is that loads preceding the barrier will
not be reordered with memory referenced following the barrier, and that
stores preceding the barrier will not be reordered with stores following
the barrier.  But given how much easier RCU reviews became after burying
smp_wmb() and smp_read_barrier_depends() into rcu_assign_pointer() and
rcu_dereference(), respectively, I think I prefer an extension of your
idea below.

> I _think_ the guarantees you want is:
>  - SMP write barrier
>  - *local* read barrier for reads preceding the write.
> 
> but the problem is that the "preceding reads" part is really
> specifically about the write that you had. The barrier should really
> be attached to the *particular* write operation, it cannot be a
> standalone barrier.

Indeed, neither rcu_assign_pointer() nor the circular queue really needs a
standalone barrier, so that attaching the barrier to a particular memory
reference would work.  And as you note below, in the case of ARM this
would turn into one of their new memory-reference instructions.

> So it would *kind* of act like a "smp_wmb() + smp_rmb()", but the
> problem is that a "smp_rmb()" doesn't really "attach" to the preceding
> write.
> 
> This is analogous to a "acquire" operation: you cannot make an
> "acquire" barrier, because it's not a barrier *between* two ops, it's
> associated with one particular op.

But you -could- use any barrier that prevented reordering of any preceding
load with any subsequent memory reference.  Please note that I am -not-
advocating this anymore, because I like the idea of attaching the barrier
to a particular memory operation.  However, for completeness, here it is
in the case of TSO systems and PowerPC, respectively:

#define smp_acquire_mb() barrier();

#define smp_acquire_mb() \
	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory");

This functions correctly, but is a pain to review because you have to
figure out which of many possible preceding loads the smp_acquire_mb()
is supposed to attach to.  As you say, it is -way- better to attach the
barrier to a particular memory operation.

> So what I *think* you actually really really want is a "store with
> release consistency, followed by a write barrier".

I believe that the combination of "store with release consistency" and
"load with acquire consistency" should do the trick for the two use cases
at this point, which again are circular buffers and rcu_assign_pointer().
At this point, I don't see the need for "followed by a write barrier".
But I step through the circular buffers below.

> In TSO, afaik all stores have release consistency, and all writes are
> ordered, which is why this is a no-op in TSO. And x86 also has that
> "all stores have release consistency, and all writes are ordered"
> model, even if TSO doesn't really describe the x86 model.

Yep, as does the mainframe.  And these architectures also have all reads
having acquire consistency.

> But on ARM64, for example, I think you'd really want the store itself
> to be done with "stlr" (store with release), and then follow up with a
> "dsb st" after that.

Agree with the "stlr" but don't (yet, anyway) understand the need for
a subsequent "dsb st".

> And notice how that requires you to mark the store itself. There is no
> actual barrier *after* the store that does the optimized model.

And marking the store itself is a very good thing from my viewpoint.

> Of course, it's entirely possible that it's not worth worrying about
> this on ARM64, and that just doing it as a "normal store followed by a
> full memory barrier" is good enough. But at least in *theory* a
> microarchitecture might make it much cheaper to do a "store with
> release consistency" followed by "write barrier".
> 
> Anyway, having talked exhaustively about exactly what semantics you
> are after, I *think* the best model would be to just have a
> 
>   #define smp_store_with_release_semantics(x, y) ...
> 
> and use that *and* a "smp_wmb()" for this (possibly a special
> "smp_wmb_after_release()" if that allows people to avoid double
> barriers). On x86 (and TSO systems), the
> smp_store_with_release_semantics() would be just a regular store, and
> the smp_wmb() is obviously a no-op. Other platforms would end up doing
> other things.
> 
> Hmm?

OK, something like this for the definitions (though PowerPC might want
to locally abstract the lwsync expansion):

	#define smp_store_with_release_semantics(p, v) /* x86, s390, etc. */ \
	do { \
		barrier(); \
		ACCESS_ONCE(p) = (v); \
	} while (0)

	#define smp_store_with_release_semantics(p, v) /* PowerPC. */ \
	do { \
		__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory"); \
		ACCESS_ONCE(p) = (v); \
	} while (0)

	#define smp_load_with_acquire_semantics(p) /* x86, s390, etc. */ \
	({ \
		typeof(*p) *_________p1 = ACCESS_ONCE(p); \
		barrier(); \
		_________p1; \
	})

	#define smp_load_with_acquire_semantics(p) /* PowerPC. */ \
	({ \
		typeof(*p) *_________p1 = ACCESS_ONCE(p); \
		__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory"); \
		_________p1; \
	})

For ARM, smp_load_with_acquire_semantics() is a wrapper around the ARM
"ldar" instruction and smp_store_with_release_semantics() is a wrapper
around the ARM "stlr" instruction.

Then if I am not too confused (and I would expect Victor to let me know
in short order if I am), the following patch to the current mainline
version of Documentation/circular-buffers.txt would suffice.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/Documentation/circular-buffers.txt b/Documentation/circular-buffers.txt
index 8117e5bf6065..1846044bf6cc 100644
--- a/Documentation/circular-buffers.txt
+++ b/Documentation/circular-buffers.txt
@@ -160,6 +160,7 @@ The producer will look something like this:
 	spin_lock(&producer_lock);
 
 	unsigned long head = buffer->head;
+	/* The spin_unlock() and next spin_lock() provide needed ordering. */
 	unsigned long tail = ACCESS_ONCE(buffer->tail);
 
 	if (CIRC_SPACE(head, tail, buffer->size) >= 1) {
@@ -168,9 +169,8 @@ The producer will look something like this:
 
 		produce_item(item);
 
-		smp_wmb(); /* commit the item before incrementing the head */
-
-		buffer->head = (head + 1) & (buffer->size - 1);
+		smp_store_with_release_semantics(buffer->head,
+						 (head + 1) & (buffer->size - 1));
 
 		/* wake_up() will make sure that the head is committed before
 		 * waking anyone up */
@@ -183,9 +183,14 @@ This will instruct the CPU that the contents of the new item must be written
 before the head index makes it available to the consumer and then instructs the
 CPU that the revised head index must be written before the consumer is woken.
 
-Note that wake_up() doesn't have to be the exact mechanism used, but whatever
-is used must guarantee a (write) memory barrier between the update of the head
-index and the change of state of the consumer, if a change of state occurs.
+Note that wake_up() does not guarantee any sort of barrier unless something
+is actually awakened.  We therefore cannot rely on it for ordering.  However,
+there is always one element of the array left empty.  Therefore, the
+producer must produce two elements before it could possibly corrupt the
+element currently being read by the consumer.  Therefore, the unlock-lock
+pair between consecutive invocations of the consumer provides the necessary
+ordering between the read of the index indicating that the consumer has
+vacated a given element and the write by the producer to that same element.
 
 
 THE CONSUMER
@@ -195,21 +200,18 @@ The consumer will look something like this:
 
 	spin_lock(&consumer_lock);
 
-	unsigned long head = ACCESS_ONCE(buffer->head);
+	unsigned long head = smp_load_with_acquire_semantics(buffer->head);
 	unsigned long tail = buffer->tail;
 
 	if (CIRC_CNT(head, tail, buffer->size) >= 1) {
-		/* read index before reading contents at that index */
-		smp_read_barrier_depends();
 
 		/* extract one item from the buffer */
 		struct item *item = buffer[tail];
 
 		consume_item(item);
 
-		smp_mb(); /* finish reading descriptor before incrementing tail */
-
-		buffer->tail = (tail + 1) & (buffer->size - 1);
+		smp_store_with_release_semantics(buffer->tail,
+						 (tail + 1) & (buffer->size - 1));
 	}
 
 	spin_unlock(&consumer_lock);
@@ -218,12 +220,17 @@ This will instruct the CPU to make sure the index is up to date before reading
 the new item, and then it shall make sure the CPU has finished reading the item
 before it writes the new tail pointer, which will erase the item.
 
-
-Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
-This prevents the compiler from discarding and reloading its cached value -
-which some compilers will do across smp_read_barrier_depends().  This isn't
-strictly needed if you can be sure that the opposition index will _only_ be
-used the once.
+Note the use of ACCESS_ONCE() and smp_load_with_acquire_semantics()
+to read the opposition index.  This prevents the compiler from
+discarding and reloading its cached value - which some compilers will
+do across smp_read_barrier_depends().  This isn't strictly needed
+if you can be sure that the opposition index will _only_ be used
+the once.  The smp_load_with_acquire_semantics() additionally forces
+the CPU to order against subsequent memory references.  Similarly,
+smp_store_with_release_semantics() is used in both algorithms to write
+the thread's index.  This documents the fact that we are writing to
+something that can be read concurrently, prevents the compiler from
+tearing the store, and enforces ordering against previous accesses.
 
 
 ===============

