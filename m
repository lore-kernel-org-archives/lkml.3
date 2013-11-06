Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3KFSY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:24:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34921 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3KFSY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:24:56 -0500
Date: Wed, 6 Nov 2013 19:24:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
Message-ID: <20131106182437.GJ16117@laptop.programming.kicks-ass.net>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
 <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
 <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy>
 <20131106140011.GL10651@twins.programming.kicks-ass.net>
 <20131106144456.GI26785@twins.programming.kicks-ass.net>
 <20131106160720.GK26785@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1311061223290.28798@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311061223290.28798@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 12:31:53PM -0500, Vince Weaver wrote:
> On Wed, 6 Nov 2013, Peter Zijlstra wrote:
> 
> > On Wed, Nov 06, 2013 at 03:44:56PM +0100, Peter Zijlstra wrote:
> > > long head = ((__atomic long)pc->data_head).load(memory_order_acquire);
> > > 
> > > coupled with:
> > > 
> > > ((__atomic long)pc->data_tail).store(tail, memory_order_release);
> > > 
> > > might be the 'right' and proper C11 incantations to avoid having to
> > > touch kernel macros; but would obviously require a recent compiler.
> > > 
> > > Barring that, I think we're stuck with:
> > > 
> > > long head = ACCESS_ONCE(pc->data_head);
> > > smp_rmb();
> > > 
> > > ...
> > > 
> > > smp_mb();
> > > pc->data_tail = tail;
> > > 
> > > And using the right asm goo for the barriers. That said, all these asm
> > > barriers should include a compiler barriers (memory clobber) which
> > > _should_ avoid the worst compiler trickery -- although I don't think it
> > > completely obviates the need for ACCESS_ONCE() -- uncertain there.
> > 
> > http://software.intel.com/en-us/articles/single-producer-single-consumer-queue/
> > 
> > There's one for icc on x86.
> > 
> 
> I think the problem here is this really isn't a good interface.

Its _so_ common Intel put it on a website ;-) This is a fairly well
documented 'problem'.

> Most users just want the most recent batch of samples.  Something like
> 
>     char buffer[4096];
>     int count;
> 
>     do {
>        count=perf_read_sample_buffer(buffer,4096);
>        process_samples(buffer);
>     } while(count);
> 
> where perf_read_sample_buffer() is a syscall that just copies the current 
> valid samples to userspace.
> 
> Yes, this is inefficient (requires an extra copy of the values) but the 
> kernel then could handle all the SMP/multithread/barrier/locking issues.
> 
> How much overhead is really introduced by making a copy?

It would make the current perf-record like thing do 2 copies; one into
userspace, and one back into the kernel for write().

Also, we've (unfortunately) already used the read() implementation of
the perf-fd and I'm fairly sure people will not like adding a special
purpose read-like syscall just for this.

That said, I've no idea how expensive it is, not having actually done
it. I do know people were trying to get rid of the one copy we currently
already do.

> Requiring the user of a kernel interface to have a deep knowledge of 
> optimizing compilers, barriers, and CPU memory models is just asking for 
> trouble.

It shouldn't be all that hard to put this in a (lgpl) library others can
link to -- that way you can build it once (using GCC).

We'd basically need to lift the proposed smp_load_acquire() and
smp_store_release() into userspace for all relevant architectures and
then have something like:

unsigned long perf_read_sample_buffer(void *mmap, long mmap_size, void *dst, long len)
{
	struct perf_event_mmap_page *pc = mmap;
	void *data = mmap + page_size;
	unsigned long data_size = mmap_size - page_size; /* should be 2^n */
	unsigned long tail, head, size, copied = 0;

	tail = pc->data_tail;
	head = smp_load_acquire(&pc->data_head);

	size = (head - tail) & (data_size - 1);

	while (len && size) {
		unsigned long offset = tail & (data_size - 1);
		unsigned long bytes = min(len, data_size - offset);

		memcpy(data + offset, dst, bytes);

		dst += bytes;
		tail += bytes;
		copied += bytes;
		size -= bytes;
		len -= bytes;
	}

	smp_store_release(&pc->data_tail, tail);

	return copied;
}

And presto!

> Especially as this all needs to get documented in the manpage and I'm not 
> sure that's possible in a sane fashion.

Given that this is a fairly well documented problem that shouldn't be
too hard.
