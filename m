Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab3FMCFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:05:41 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63586 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3FMCFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:05:40 -0400
Date: Wed, 12 Jun 2013 19:05:36 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613020536.GA10979@localhost>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 04:38:54PM -0700, Andrew Morton wrote:
> On Tue, 11 Jun 2013 21:03:24 -0700 Kent Overstreet <koverstreet@google.com> wrote:
> 
> > Allocates integers out of a predefined range 
> 
> 0..n, I assume.  Not n..m.

Yes (though n..m would be trivial if anyone wanted it)... and
percpu_tag_pool_init() is explicit about [0, nr_free)

> 
> > - for use by e.g. a driver
> > to allocate tags for communicating with the device.
> > 
> > v2: Tejun pointed out that the original strategy completely breaks if
> > nr_cpus is large enough. I think (hope) I realized that at one point,
> > but completely forgot in the months since I originally implemented it.
> > 
> > Came up with a new strategy where we keep track of the number of cpus
> > that have tags on their percpu freelists, then steal from a different
> > random cpu if too many cpus have tags on their freelists.
> > 
> > Note that the synchronization is _definitely_ tricky - we're using
> > xchg()/cmpxchg() on the percpu lists, to synchronize between
> > steal_tags().
> > 
> > The alternative would've been adding a spinlock to protect the percpu
> > freelists, but that would've required some different tricky code to
> > avoid deadlock because of the lock ordering.
> 
> The changelog makes this code very hard to review.  Because it fails to
> inform us of critical things such as:
> 
> What are the actual objectives here?  The requirements as you see them?
> What hardware and drivers are we talking about here?  
> 
> What are the frequency requirements of that hardware?

Code that would be using this (not just driver code, I'm using it for
the aio code to efficiently support cancellation) would typically today
be allocating out of a preallocated array, probably using something like
an atomic bit vector (find_next_unset_bit() etc.) to track free objects.
This is a faster and more scaleable replacement.

I originally wrote it for a driver that was doing exactly that atomic
bit vector thing. Jens forked an earlier version of this code for his
blk-mq stuff, and Nicholas Bellinger just posted a patch the other day
using this in the iscsi target code.

But all it's supposed to do is hand you integers that you then use to
index into your (probably preallocated) array.

Frequency requirements - aio would probably have higher performance
requirements than any individual piece of hardware, if the cancellation
stuff goes in. Individual flash devices do ~1M iops though and that's
the sort of driver this is targeted at.

> Why can't we use ida_get_new_above()?
> 
>    If it is "speed" then how bad is the problem and what efforts have
>    been made to address them within the idr code?  (A per-cpu magazine
>    frontend to ida_get_new_above() might suit).
> 
>    If it is "functionality" then what efforts have been made to
>    suitably modify the ida code?

Originally, it was because every time I opened idr.[ch] I was confronted
with an enormous pile of little functions, with very little indication
in the way of what they were all trying to do or which ones I might want
to start with.

Having finally read enough of the code to maybe get a handle on what
it's about - performance is a large part of it, but idr is also a more
complicated api that does more than what I wanted.

Re: the per-cpu magazine frontend - if I did that still need pretty much
exactly what I've got implemented here - the non smp version of this
code would be basically just a single stack, all the complexity is in
making it percpu.

> wrt the NR_CPUS=1024 thing: yes, this is a problem with the per-cpu
> design.  Especially if the hardware only has a 10-bit-tag!  What's the
> worst case here?  What is the smallest tag size which you reasonably
> expect we will encounter?  What are the expected failure modes with
> large cpu count and small tag size?

Well, ncq/tcq have a 5 bit tag space, you probably wouldn't want to use
this code for that :)

So the worst case is that on your NR_CPUS=1024 system, you don't have a
big enough tag space to keep tags on most of the percpu freelists _and_
your workload is running across all the cpus at once.

The key thing is with the way tag stealing works, it's not NR_CPUS that
matters, it's how many your workload is currently running on. And you
can't really expect good things if you're trying to use a device from
1024 cpus at once anyways, so I think it'll work out well enough in
practice.

Also, it should degrade _reasonably_gracefully as the number of cpus
you're running on starts to exceed the point at which you have to steal
tags - since to steal tags we only have to compete with one other cpu
for the needed cachelines. The global lock will eventually become a
bottleneck, but only so much we can do about that.

> > +/*
> > + * Copyright 2012 Google Inc. All Rights Reserved.
> > + * Author: koverstreet@google.com (Kent Overstreet)
> > + *
> > + * Per cpu tag allocator. Allocates small integers - up to nr_tags passed to
> > + * percpu_tag_pool_init() - for use with say driver tag structures for talking
> > + * to a device.
> > + *
> > + * It works by caching tags on percpu freelists, and then tags are
> > + * allocated/freed from the global freelist in batches.
> > + *
> > + * Note that it will in general be impossible to allocate all nr_tags tags,
> > + * since some tags will be stranded on other cpu's freelists: but we guarantee
> > + * that nr_tags / 2 can always be allocated.
> > + *
> > + * This is done by keeping track of which cpus have tags on their percpu
> > + * freelists in a bitmap, and then on allocation failure if too many cpus have
> > + * tags on their freelists - i.e. if cpus_have_tags * TAG_CPU_SIZE (64) >
> > + * nr_tags / 2 - then we steal one remote cpu's freelist (effectively picked at
> > + * random).
> 
> OK, this comment partially makes up for changelog deficiencies.
> 
> Why did you choose to directly fiddle with the other-cpus data rather
> than issuing a cross-cpu IPI call?  The latter would presumably result
> in slower stealing performance but better common-case performance.

I could handwave an argument (the extra needed synchronization doesn't
cost much since in the common case it's in cache and there's no
contention) - but I haven't tested the IPI version.

Jens used IPIs in his fork (but he didn't figure out the trick of
limiting when we steal and stealing from a random other cpu, so there's
way more cacheline contention in his version).

> I didn't immediately see where this "if cpus_have_tags * TAG_CPU_SIZE
> (64) + * nr_tags / 2" was implemented and I don't immediately see *why*
> it was implemented.  Why do we care?  If local allocation fails, just
> go steal.

There's a tradeoff between percentage of tags you can guarantee will be
available for allocation, and amount of global communication required.

If we say up front "We only guarantee that half of the tag space can be
succesfully allocated, depending on what happens with the percpu
freelists" - then we can guarantee drastically less cacheline
contention/bouncing even when we're trying to keep as many tags as
possible allocated.

The cost of stealing tags isn't just to the thread that's doing the
stealing - it's already gone and touched the global stuff, and it's
probably going to sleep, so it might not matter much there. But now some
other cpu is going to have to touch the global cachelines a lot sooner
than it would have otherwise.

And then, if we didn't keep track of which cpus had tags on their
freelists, we'd always have to potentially try stealing from _every_
cpu, until we found tags - that would scale quadratically (i think, i'm
tired) as nr_cpus goes up w.r.t. cacheline bouncing.

> 
> Please lovingly document the struct fields - it really pays off. 
> Certainly the lack of a roadmap here will make this review harder and
> less effective than it needs to be.

Will do.

> 
> It's nice that the cacheline alignment only happens on SMP builds, but
> this code already adds tremendous amounts of useless fluff to
> uniprocessor builds.  Those kernels would be much happier with
> ida_get_new_above().

I hate #ifdefs, but I suppose it's warrented here. The non CONFIG_SMP
version will be trivial, I'll add that.

> > +unsigned percpu_tag_alloc(struct percpu_tag_pool *pool, gfp_t gfp);
> > +void percpu_tag_free(struct percpu_tag_pool *pool, unsigned tag);
> > +
> > +void percpu_tag_pool_free(struct percpu_tag_pool *pool);
> > +int percpu_tag_pool_init(struct percpu_tag_pool *pool, unsigned long nr_tags);
> > +
> > +enum {
> > +	TAG_FAIL	= -1U,
> > +	TAG_MAX		= TAG_FAIL - 1,
> > +};
> 
> Again, documentation of the meanings of these will help the reader
> considerably.

Check.

> > +#endif
> > diff --git a/lib/Makefile b/lib/Makefile
> > index 386db4b..e29a354 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
> >  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
> >  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
> >  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> > -	 earlycpio.o percpu-refcount.o
> > +	 earlycpio.o percpu-refcount.o percpu-tags.o
> >  
> >  obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
> >  lib-$(CONFIG_MMU) += ioremap.o
> > diff --git a/lib/percpu-tags.c b/lib/percpu-tags.c
> > new file mode 100644
> > index 0000000..e43b428
> > --- /dev/null
> > +++ b/lib/percpu-tags.c
> > @@ -0,0 +1,313 @@
> > +/*
> > + * Copyright 2012 Google Inc. All Rights Reserved.
> > + * Author: koverstreet@google.com (Kent Overstreet)
> > + *
> > + * Per cpu tag allocator.
> > + */
> > +
> > +#include <linux/gfp.h>
> > +#include <linux/module.h>
> > +#include <linux/sched.h>
> > +#include <linux/slab.h>
> > +#include <linux/percpu-tags.h>
> 
> I expect this isn't a long enough include list.  Just below I see
> memcpy, hweight_long, find_next_bit, per_cpu_ptr and xchg.  Please
> carefully go through the requirements and don't rely upon
> config-dependent nested-include luck.

Will do.

> > +#define TAG_CPU_WATERMARK	32U
> > +#define TAG_CPU_SIZE		TAG_CPU_WATERMARK * 2
> > +
> > +#define TAG_CPU_STEALING	UINT_MAX
> 
> What do these do.
> 
> > +struct percpu_tag_cpu_freelist {
> > +	unsigned			nr_free;
> > +	unsigned			freelist[];
> > +};
> > +
> > +static inline void move_tags(unsigned *dst, unsigned *dst_nr,
> > +			     unsigned *src, unsigned *src_nr,
> > +			     unsigned nr)
> > +{
> > +	*src_nr -= nr;
> > +	memcpy(dst + *dst_nr, src + *src_nr, sizeof(unsigned) * nr);
> > +	*dst_nr += nr;
> > +}
> 
> Overlapping copies are not required?

No, it's only for moving tags between different freelists (a percpu
freelist and the global freelist).

> > +static bool steal_tags(struct percpu_tag_pool *pool,
> > +		       struct percpu_tag_cpu_freelist *tags)
> 
> An overview of this function would be helpful here.

Here's what I just wrote:

/*
 * Try to steal tags from a remote cpu's percpu freelist.
 *
 * We first check how many percpu freelists have tags - we don't steal tags
 * unless enough percpu freelists have tags on them that it's possible more than
 * half the total tags could be stuck on remote percpu freelists.
 *
 * Then we iterate through the cpus until we find some tags - we don't attempt
 * to find the "best" cpu to steal from, to keep cacheline bouncing to a
 * minimum.
 *
 * Returns true on success (our percpu freelist is no longer empty), false on
 * failure.
 */

> > +{
> > +	unsigned i, nr_free, cpus_have_tags = 0, cpu = pool->cpu_last_stolen;
> > +	struct percpu_tag_cpu_freelist *remote;
> > +
> > +	for (i = 0; i < DIV_ROUND_UP(nr_cpu_ids, BITS_PER_LONG); i++)
> > +		cpus_have_tags += hweight_long(pool->cpus_have_tags[i]);
> 
> That's an open-coded bitmap_weight().  Generally, the bitmap.h code
> might be applicable in this code.  (The bitmap code has some pretty
> foul inefficiencies, but they're generally easily fixed).

Yeah, Oleg pointed that out, I've already fixed it in my version.

> > +	while (cpus_have_tags-- * TAG_CPU_SIZE > pool->nr_tags / 2) {
> > +		cpu = find_next_bit(pool->cpus_have_tags, nr_cpu_ids, cpu);
> > +
> > +		if (cpu == nr_cpu_ids)
> > +			cpu = find_first_bit(pool->cpus_have_tags, nr_cpu_ids);
> > +
> > +		if (cpu == nr_cpu_ids)
> > +			BUG();
> > +
> > +		pool->cpu_last_stolen = cpu;
> 
> I think I can see why this last_stolen thing exists, but I'd prefer to
> be told why its creator thinks it needs to exist.
> 
> One could just start stealing at this_cpu + 1?

Starting at this_cpu + 1 isn't a bad idea.

I think keeping the index around and cycling through is still better
though - suppose you have a workload running on some subset of the cpus
in the system, and those cpus happen to all have adjacent indices.

We want to have an equal chance of picking any given cpu to steal from,
so that the stealing is fair - if we were sarting at this_cpu + 1, we'd
steal more from the cpus our workload is currently running on, when what
we want is to make sure we also steal from the cpus we _aren't_
currently running on.

> 
> > +		remote = per_cpu_ptr(pool->tag_cpu, cpu);
> > +
> > +		if (remote == tags)
> > +			continue;
> > +
> > +		clear_bit(cpu, pool->cpus_have_tags);
> > +
> > +		nr_free = xchg(&remote->nr_free, TAG_CPU_STEALING);
> 
> (looks to see what TAG_CPU_STEALING does)
> 
> OK, this looks pretty lame.  It adds a rare fallback to the central
> allocator, which makes that path hard to test.  And it does this at
> basically the same cost of plain old spin_lock().  I do think it would
> be better to avoid the underministic code and use plain old
> spin_lock().  I appreciate the lock ranking concern, but you're a
> cleaver chap ;)

Yeah, the cmpxchg() stuff turned out trickier than I'd hoped - it's
actually the barriers (guarding against a race with percpu_tag_free())
that concern me more than that fallback.

I did torture test this code quite a bit and I'm not terribly eager to
futz with it more, but I may try switching to spinlocks for the percpu
freelists to see how it works out - I had the idea that I might be able
to avoid some writes to shared cachelines if I can simplify that stuff,
which would probably make it worth it.

> Also, I wonder if this was all done in the incorrect order.  Why make
> alloc_local_tag() fail?  steal_tags() could have just noodled off and
> tried to steal from the next CPU if alloc_local_tag() was in progress
> on this CPU?

steal_tags() can't notice that alloc_local_tag() is in progress,
alloc_local_tag() just uses cmpxchg to update nr_free - there's no
sentinal value or anything.

OTOH, if alloc_local_tag() sees TAG_CPU_STEALING - the next thing that's
going to happen is steal_tags() is going to set nr_free to 0, and the
only way tags are going to end up back on our cpu's freelist is if we
fail and do something else - we've got irqs disabled so
percpu_tag_free() can't do it.


> 
> > +		if (nr_free) {
> > +			memcpy(tags->freelist,
> > +			       remote->freelist,
> > +			       sizeof(unsigned) * nr_free);
> > +			smp_mb();
> 
> Please always document barriers.  Explain in full detail to the reader
> which scenario(s) we're barriering against.

Will do

> 
> > +			remote->nr_free = 0;
> > +			tags->nr_free = nr_free;
> > +			return true;
> > +		} else {
> > +			remote->nr_free = 0;
> > +		}
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +static bool alloc_global_tags(struct percpu_tag_pool *pool,
> > +			      struct percpu_tag_cpu_freelist *tags)
> > +{
> > +	if (pool->nr_free) {
> > +		move_tags(tags->freelist, &tags->nr_free,
> > +			  pool->freelist, &pool->nr_free,
> > +			  min(pool->nr_free, TAG_CPU_WATERMARK));
> > +		return true;
> > +	}
> > +
> > +	return false;
> > +}
> 
> OK, getting a bit lost now.  What does this do and what is
> TAG_CPU_WATERMARK.

TAG_CPU_WATERMARK is just the number of tags we shuffle back and forth
between the percpu freelists and the global freelist at a time - half
the maximum size of the percpu freelists.

Jens renamed that to BATCH_MOVE, I suppose that might've been a better
name.

> percpu_tag_alloc(), actually.

Whoops, missed some renaming.

> > + * @pool: pool to allocate from
> > + * @gfp: gfp flags
> > + *
> > + * Returns a tag - an integer in the range [0..nr_tags) (passed to
> > + * tag_pool_init()), or otherwise TAG_FAIL on allocation failure.
> > + *
> > + * Will not fail if passed __GFP_WAIT.
> > + */
> > +unsigned percpu_tag_alloc(struct percpu_tag_pool *pool, gfp_t gfp)
> > +{
> > +	DEFINE_WAIT(wait);
> > +	struct percpu_tag_cpu_freelist *tags;
> > +	unsigned long flags;
> > +	unsigned tag, this_cpu;
> > +
> > +	while (1) {
> > +		local_irq_save(flags);
> 
> why?  Presumably so the main interfaces are irq-safe.  That would be a
> useful thing to include in the interface description.

An allocator that wasn't irq safe (and explicitly percpu and thus meant
for concurrency) would seem to be an odd thing. I suppose from the
user's perspective it could just be disabling preemption... I'll make a
note of it.

> What actions can a driver take if an irq-time tag allocation attempt
> fails?  How can the driver author test those actions?

You mean if a GFP_NOWAIT allocation fails? It's the same as any other
allocation, I suppose.

Did you have something else in mind that could be implemented? I don't
want to add code for a reserve to this code - IMO, if a reserve is
needed it should be done elsewhere (like how mempools work on top of
existing allocators).

> It's a bit inefficient to do the needless prepare_to_wait/finish_wait
> in this case, but livable with.

After profiling this morning I added a fast path that doesn't do the
finish_wait(), that was more expensive that I expected.

> 
> > +		}
> > +
> > +		spin_unlock(&pool->lock);
> > +		local_irq_restore(flags);
> > +
> > +		schedule();
> > +	}
> 
> Does this loop need a try_to_freeze()?

I suppose it does, I hadn't run across that one before...
