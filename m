Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3KDLXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:23:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58112 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3KDLX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:23:29 -0500
Date: Mon, 4 Nov 2013 12:22:54 +0100
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
Message-ID: <20131104112254.GK28601@twins.programming.kicks-ass.net>
References: <20131031064015.GV4126@linux.vnet.ibm.com>
 <20131101145634.GH19466@laptop.lan>
 <20131102173239.GB3947@linux.vnet.ibm.com>
 <20131103144017.GA25118@linux.vnet.ibm.com>
 <20131103151704.GJ19466@laptop.lan>
 <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
 <20131103200124.GK19466@laptop.lan>
 <20131103224242.GF3947@linux.vnet.ibm.com>
 <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104105059.GL3947@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104105059.GL3947@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 02:51:00AM -0800, Paul E. McKenney wrote:
> OK, something like this for the definitions (though PowerPC might want
> to locally abstract the lwsync expansion):
> 
> 	#define smp_store_with_release_semantics(p, v) /* x86, s390, etc. */ \
> 	do { \
> 		barrier(); \
> 		ACCESS_ONCE(p) = (v); \
> 	} while (0)
> 
> 	#define smp_store_with_release_semantics(p, v) /* PowerPC. */ \
> 	do { \
> 		__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory"); \
> 		ACCESS_ONCE(p) = (v); \
> 	} while (0)
> 
> 	#define smp_load_with_acquire_semantics(p) /* x86, s390, etc. */ \
> 	({ \
> 		typeof(*p) *_________p1 = ACCESS_ONCE(p); \
> 		barrier(); \
> 		_________p1; \
> 	})
> 
> 	#define smp_load_with_acquire_semantics(p) /* PowerPC. */ \
> 	({ \
> 		typeof(*p) *_________p1 = ACCESS_ONCE(p); \
> 		__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory"); \
> 		_________p1; \
> 	})
> 
> For ARM, smp_load_with_acquire_semantics() is a wrapper around the ARM
> "ldar" instruction and smp_store_with_release_semantics() is a wrapper
> around the ARM "stlr" instruction.

This still leaves me confused as to what to do with my case :/

Slightly modified since last time -- as the simplified version was maybe
simplified too far.

To recap, I'd like to get rid of barrier A where possible, since that's
now a full barrier for every event written.

However, there's no immediate store I can attach it to; the obvious one
would be the kbuf->head store, but that's complicated by the
local_cmpxchg() thing.

And we need that cmpxchg loop because a hardware NMI event can
interleave with a software event.

And to be honest, I'm still totally confused about memory barriers vs
control flow vs C/C++. The only way we're ever getting to that memcpy is
if we've already observed ubuf->tail, so that LOAD has to be fully
processes and completed.

I'm really not seeing how a STORE from the memcpy() could possibly go
wrong; and if C/C++ can hoist the memcpy() over a compiler barrier()
then I suppose we should all just go home.

/me who wants A to be a barrier() but is terminally confused.

---


/*
 * One important detail is that the kbuf part and the kbuf_writer() are
 * strictly per cpu and we can thus rely on program order for those.
 *
 * Only the userspace consumer can possibly run on another cpu, and thus we
 * need to ensure data consistency for those.
 */

struct buffer {
        u64 size;
        u64 tail;
        u64 head;
        void *data;
};

struct buffer *kbuf, *ubuf;

/*
 * If there's space in the buffer; store the data @buf; otherwise
 * discard it.
 */
void kbuf_write(int sz, void *buf)
{
	u64 tail, head, offset;

	do {
		tail = ACCESS_ONCE(ubuf->tail);
		offset = head = kbuf->head;
		if (CIRC_SPACE(head, tail, kbuf->size) < sz) {
			/* discard @buf */
			return;
		}
		head += sz;
	} while (local_cmpxchg(&kbuf->head, offset, head) != offset)

        /*
         * Ensure that if we see the userspace tail (ubuf->tail) such
         * that there is space to write @buf without overwriting data
         * userspace hasn't seen yet, we won't in fact store data before
         * that read completes.
         */

        smp_mb(); /* A, matches with D */

        memcpy(kbuf->data + offset, buf, sz);

        /*
         * Ensure that we write all the @buf data before we update the
         * userspace visible ubuf->head pointer.
         */
        smp_wmb(); /* B, matches with C */

        ubuf->head = kbuf->head;
}

/*
 * Consume the buffer data and update the tail pointer to indicate to
 * kernel space there's 'free' space.
 */
void ubuf_read(void)
{
        u64 head, tail;

        tail = ACCESS_ONCE(ubuf->tail);
        head = ACCESS_ONCE(ubuf->head);

        /*
         * Ensure we read the buffer boundaries before the actual buffer
         * data...
         */
        smp_rmb(); /* C, matches with B */

        while (tail != head) {
                obj = ubuf->data + tail;
                /* process obj */
                tail += obj->size;
                tail %= ubuf->size;
        }

        /*
         * Ensure all data reads are complete before we issue the
         * ubuf->tail update; once that update hits, kbuf_write() can
         * observe and overwrite data.
         */
        smp_mb(); /* D, matches with A */

        ubuf->tail = tail;
}
