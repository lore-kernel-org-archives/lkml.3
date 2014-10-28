Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaJ1RH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:07:27 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:49905 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaJ1RH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:07:26 -0400
Date: Tue, 28 Oct 2014 17:07:15 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Message-ID: <20141028170715.GJ29706@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
 <20141028160729.GH29706@arm.com>
 <CA+55aFxvz=guax4KcAszyjkqdqXGwV38O+G23xMvGFJDTrZqtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxvz=guax4KcAszyjkqdqXGwV38O+G23xMvGFJDTrZqtg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 04:25:35PM +0000, Linus Torvalds wrote:
> On Tue, Oct 28, 2014 at 9:07 AM, Will Deacon <will.deacon@arm.com> wrote:
> > I was certainly seeing this issue trigger regularly when running firefox,
> > but I'll need to dig and find out the differences in range size.
> 
> I'm wondering whether that was perhaps because of the mix-up with
> initialization of the range. Afaik, that would always break your
> min/max thing for the first batch (and since the batches are fairly
> large, "first" may be "only")
> 
> But hey. it's possible that firefox does some big mappings but only
> populates the beginning. Most architectures don't tend to have
> excessive glass jaws in this area: invalidating things page-by-page is
> invariably so slow that at some point you just go "just do the whole
> range".
> 
> > Since we have hardware broadcasting of TLB invalidations on ARM, it is
> > in our interest to keep the number of outstanding operations as small as
> > possible, particularly on large systems where we don't get the targetted
> > shootdown with a single message that you can perform using IPIs (i.e.
> > you can only broadcast to all or no CPUs, and that happens for each pte).
> 
> Do you seriously *have* to broadcast for each pte?
> 
> Because that is quite frankly moronic.  We batch things up in software
> for a real good reason: doing things one entry at a time just cannot
> ever scale. At some point (and that point is usually not even very far
> away), it's much better to do a single invalidate over a range. The
> cost of having to refill the TLB's is *much* smaller than the cost of
> doing tons of cross-CPU invalidates.

I don't think that's necessarily true, at least not on the systems I'm
familiar with. A table walk can be comparatively expensive, particularly
when virtualisation is involved and the depth of the host and guest page
tables starts to grow -- we're talking >20 memory accesses per walk. By
contrast, the TLB invalidation messages are asynchronous and carried on
the interconnect (a DSB instruction is used to synchronise the updates).

> That's true even for the cases where we track the CPU's involved in
> that mapping, and only invalidate a small subset. With a "all CPU's
> broadcast", the cross-over point must be even smaller. Doing thousands
> of CPU broadcasts is just crazy, even if they are hw-accelerated.
> 
> Can't you just do a full invalidate and a SW IPI for larger ranges?

We already do that, but it's mainly there to catch *really* large ranges
(like the negative ones...), which can trigger the soft lockup detector.
The cases we've seen for this so far have been bugs (e.g. this thread and
also a related issue where we try to flush the whole of vmalloc space).

> And as mentioned, true sparse mappings are actually fairly rare, so
> making extra effort (and data structures) to have individual ranges
> sounds crazy.

Sure, I'll try and get some data on this. I'd like to resolve the THP case,
at least, which means keeping track of calls to __tlb_remove_pmd_tlb_entry.

> Is this some hw-enforced thing? You really can't turn off the
> cross-cpu-for-each-pte braindamage?

We could use IPIs if we wanted to and issue local TLB invalidations on
the targetted cores, but I'd be surprised if this showed an improvement
on ARM-based systems.

Will
