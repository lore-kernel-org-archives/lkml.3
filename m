Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaKLKLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:11:15 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56648 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaKLKLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:11:10 -0500
Date: Wed, 12 Nov 2014 10:10:51 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Tony Luck <tony.luck@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] arch: Introduce read_acquire()
Message-ID: <20141112101051.GA26437@arm.com>
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home>
 <CA+55aFwo9f3tWaRqN1Xam9UkWv1B5F4YnRP1Qx3T78E4o=8YJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwo9f3tWaRqN1Xam9UkWv1B5F4YnRP1Qx3T78E4o=8YJQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 07:40:22PM +0000, Linus Torvalds wrote:
> On Tue, Nov 11, 2014 at 10:57 AM,  <alexander.duyck@gmail.com> wrote:
> > On reviewing the documentation and code for smp_load_acquire() it occured
> > to me that implementing something similar for CPU <-> device interraction
> > would be worth while.  This commit provides just the load/read side of this
> > in the form of read_acquire().
> 
> So I don't hate the concept, but. there's a couple of reasons to think
> this is broken.
> 
> One is just the name. Why do we have "smp_load_acquire()", but then
> call the non-smp version "read_acquire()"? That makes very little
> sense to me. Why did "load" become "read"?

[...]

> But we do have a very real difference between "smp_rmb()" (inter-cpu
> cache coherency read barrier) and "rmb()" (full memory barrier that
> synchronizes with IO).
> 
> And your patch is very confused about this. In *some* places you use
> "rmb()", and in other places you just use "smp_load_acquire()". Have
> you done extensive verification to check that this is actually ok?
> Because the performance difference you quote very much seems to be
> about your x86 testing now akipping the IO-synchronizing "rmb()", and
> depending on DMA being ordered even without it.
> 
> And I'm pretty sure that's actually fine on x86. The real
> IO-synchronizing rmb() (which translates into a lfence) is only needed
> for when you have uncached accesses (ie mmio) on x86. So I don't think
> your code is wrong, I just want to verify that everybody understands
> the issues. I'm not even sure DMA can ever really have weaker memory
> ordering (I really don't see how you'd be able to do a read barrier
> without DMA stores being ordered natively), so maybe I worry too much,
> but the ppc people in particular should look at this, because the ppc
> memory ordering rules and serialization are some completely odd ad-hoc
> black magic....

Right, so now I see what's going on here. This isn't actually anything
to do with acquire/release (I don't know of any architectures that have
a read-barrier-acquire instruction), it's all about DMA to main memory.

If a device is DMA'ing data *and* control information (e.g. 'descriptor
valid') to memory, then it must be maintaining order between those writes
with respect to memory. In that case, using the usual MMIO barriers can
be overkill because we really just want to enforce read-ordering on the CPU
side. In fact, I think you could even do this with a fake address dependency
on ARM (although I'm not actually suggesting we do that).

In light of that, it actually sounds like we want a new set of barrier
macros that apply only to DMA buffer accesses by the CPU -- they wouldn't
enforce ordering against things like MMIO registers. I wonder whether any
architectures would implement them differently to the smp_* flavours?

> But anything with non-cache-coherent DMA is obviously very suspect too.

I think non-cache-coherent DMA should work too (at least, on ARM), but
only for buffers mapped via dma_alloc_coherent (i.e. a non-cacheable
mapping).

Will
