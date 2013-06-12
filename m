Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab3FLXi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:38:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab3FLXi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:38:57 -0400
Date: Wed, 12 Jun 2013 16:38:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-Id: <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
In-Reply-To: <1371009804-11596-1-git-send-email-koverstreet@google.com>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013 21:03:24 -0700 Kent Overstreet <koverstreet@google.com> wrote:

> Allocates integers out of a predefined range 

0..n, I assume.  Not n..m.

> - for use by e.g. a driver
> to allocate tags for communicating with the device.
> 
> v2: Tejun pointed out that the original strategy completely breaks if
> nr_cpus is large enough. I think (hope) I realized that at one point,
> but completely forgot in the months since I originally implemented it.
> 
> Came up with a new strategy where we keep track of the number of cpus
> that have tags on their percpu freelists, then steal from a different
> random cpu if too many cpus have tags on their freelists.
> 
> Note that the synchronization is _definitely_ tricky - we're using
> xchg()/cmpxchg() on the percpu lists, to synchronize between
> steal_tags().
> 
> The alternative would've been adding a spinlock to protect the percpu
> freelists, but that would've required some different tricky code to
> avoid deadlock because of the lock ordering.

The changelog makes this code very hard to review.  Because it fails to
inform us of critical things such as:

What are the actual objectives here?  The requirements as you see them?
What hardware and drivers are we talking about here?  

What are the frequency requirements of that hardware?

Why can't we use ida_get_new_above()?

   If it is "speed" then how bad is the problem and what efforts have
   been made to address them within the idr code?  (A per-cpu magazine
   frontend to ida_get_new_above() might suit).

   If it is "functionality" then what efforts have been made to
   suitably modify the ida code?



And all of that is before we even start to look at the implementation! 
How can one review an implementation without being told what it is to
achieve?


wrt the NR_CPUS=1024 thing: yes, this is a problem with the per-cpu
design.  Especially if the hardware only has a 10-bit-tag!  What's the
worst case here?  What is the smallest tag size which you reasonably
expect we will encounter?  What are the expected failure modes with
large cpu count and small tag size?

>
> ...
>
> +/*
> + * Copyright 2012 Google Inc. All Rights Reserved.
> + * Author: koverstreet@google.com (Kent Overstreet)
> + *
> + * Per cpu tag allocator. Allocates small integers - up to nr_tags passed to
> + * percpu_tag_pool_init() - for use with say driver tag structures for talking
> + * to a device.
> + *
> + * It works by caching tags on percpu freelists, and then tags are
> + * allocated/freed from the global freelist in batches.
> + *
> + * Note that it will in general be impossible to allocate all nr_tags tags,
> + * since some tags will be stranded on other cpu's freelists: but we guarantee
> + * that nr_tags / 2 can always be allocated.
> + *
> + * This is done by keeping track of which cpus have tags on their percpu
> + * freelists in a bitmap, and then on allocation failure if too many cpus have
> + * tags on their freelists - i.e. if cpus_have_tags * TAG_CPU_SIZE (64) >
> + * nr_tags / 2 - then we steal one remote cpu's freelist (effectively picked at
> + * random).

OK, this comment partially makes up for changelog deficiencies.

Why did you choose to directly fiddle with the other-cpus data rather
than issuing a cross-cpu IPI call?  The latter would presumably result
in slower stealing performance but better common-case performance.

I didn't immediately see where this "if cpus_have_tags * TAG_CPU_SIZE
(64) + * nr_tags / 2" was implemented and I don't immediately see *why*
it was implemented.  Why do we care?  If local allocation fails, just
go steal.

> + * This means that if a workload spans a huge number of cpus - in relation to
> + * the number of tags that can be allocated - performance will suffer somewhat;
> + * but as long as the workload is bounded to a reasonable number of cpus the
> + * percpu-ness of the allocator will not be affected.
> + */
> +
> +#ifndef _LINUX_TAGS_H
> +#define _LINUX_TAGS_H
> +
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +
> +struct percpu_tag_cpu_freelist;
> +
> +struct percpu_tag_pool {
> +	unsigned			nr_tags;
> +
> +	struct percpu_tag_cpu_freelist	*tag_cpu;
> +	unsigned long			*cpus_have_tags;
> +
> +	struct {
> +		spinlock_t		lock;
> +		unsigned		cpu_last_stolen;
> +		/* Global freelist */
> +		unsigned		nr_free;
> +		unsigned		*freelist;
> +		wait_queue_head_t	wait;
> +	} ____cacheline_aligned_in_smp;
> +};

Please lovingly document the struct fields - it really pays off. 
Certainly the lack of a roadmap here will make this review harder and
less effective than it needs to be.

It's nice that the cacheline alignment only happens on SMP builds, but
this code already adds tremendous amounts of useless fluff to
uniprocessor builds.  Those kernels would be much happier with
ida_get_new_above().

> +unsigned percpu_tag_alloc(struct percpu_tag_pool *pool, gfp_t gfp);
> +void percpu_tag_free(struct percpu_tag_pool *pool, unsigned tag);
> +
> +void percpu_tag_pool_free(struct percpu_tag_pool *pool);
> +int percpu_tag_pool_init(struct percpu_tag_pool *pool, unsigned long nr_tags);
> +
> +enum {
> +	TAG_FAIL	= -1U,
> +	TAG_MAX		= TAG_FAIL - 1,
> +};

Again, documentation of the meanings of these will help the reader
considerably.

> +#endif
> diff --git a/lib/Makefile b/lib/Makefile
> index 386db4b..e29a354 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
>  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> -	 earlycpio.o percpu-refcount.o
> +	 earlycpio.o percpu-refcount.o percpu-tags.o
>  
>  obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
>  lib-$(CONFIG_MMU) += ioremap.o
> diff --git a/lib/percpu-tags.c b/lib/percpu-tags.c
> new file mode 100644
> index 0000000..e43b428
> --- /dev/null
> +++ b/lib/percpu-tags.c
> @@ -0,0 +1,313 @@
> +/*
> + * Copyright 2012 Google Inc. All Rights Reserved.
> + * Author: koverstreet@google.com (Kent Overstreet)
> + *
> + * Per cpu tag allocator.
> + */
> +
> +#include <linux/gfp.h>
> +#include <linux/module.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/percpu-tags.h>

I expect this isn't a long enough include list.  Just below I see
memcpy, hweight_long, find_next_bit, per_cpu_ptr and xchg.  Please
carefully go through the requirements and don't rely upon
config-dependent nested-include luck.

> +#define TAG_CPU_WATERMARK	32U
> +#define TAG_CPU_SIZE		TAG_CPU_WATERMARK * 2
> +
> +#define TAG_CPU_STEALING	UINT_MAX

What do these do.

> +struct percpu_tag_cpu_freelist {
> +	unsigned			nr_free;
> +	unsigned			freelist[];
> +};
> +
> +static inline void move_tags(unsigned *dst, unsigned *dst_nr,
> +			     unsigned *src, unsigned *src_nr,
> +			     unsigned nr)
> +{
> +	*src_nr -= nr;
> +	memcpy(dst + *dst_nr, src + *src_nr, sizeof(unsigned) * nr);
> +	*dst_nr += nr;
> +}

Overlapping copies are not required?

> +static bool steal_tags(struct percpu_tag_pool *pool,
> +		       struct percpu_tag_cpu_freelist *tags)

An overview of this function would be helpful here.

> +{
> +	unsigned i, nr_free, cpus_have_tags = 0, cpu = pool->cpu_last_stolen;
> +	struct percpu_tag_cpu_freelist *remote;
> +
> +	for (i = 0; i < DIV_ROUND_UP(nr_cpu_ids, BITS_PER_LONG); i++)
> +		cpus_have_tags += hweight_long(pool->cpus_have_tags[i]);

That's an open-coded bitmap_weight().  Generally, the bitmap.h code
might be applicable in this code.  (The bitmap code has some pretty
foul inefficiencies, but they're generally easily fixed).

> +	while (cpus_have_tags-- * TAG_CPU_SIZE > pool->nr_tags / 2) {
> +		cpu = find_next_bit(pool->cpus_have_tags, nr_cpu_ids, cpu);
> +
> +		if (cpu == nr_cpu_ids)
> +			cpu = find_first_bit(pool->cpus_have_tags, nr_cpu_ids);
> +
> +		if (cpu == nr_cpu_ids)
> +			BUG();
> +
> +		pool->cpu_last_stolen = cpu;

I think I can see why this last_stolen thing exists, but I'd prefer to
be told why its creator thinks it needs to exist.

One could just start stealing at this_cpu + 1?

> +		remote = per_cpu_ptr(pool->tag_cpu, cpu);
> +
> +		if (remote == tags)
> +			continue;
> +
> +		clear_bit(cpu, pool->cpus_have_tags);
> +
> +		nr_free = xchg(&remote->nr_free, TAG_CPU_STEALING);

(looks to see what TAG_CPU_STEALING does)

OK, this looks pretty lame.  It adds a rare fallback to the central
allocator, which makes that path hard to test.  And it does this at
basically the same cost of plain old spin_lock().  I do think it would
be better to avoid the underministic code and use plain old
spin_lock().  I appreciate the lock ranking concern, but you're a
cleaver chap ;)

Also, I wonder if this was all done in the incorrect order.  Why make
alloc_local_tag() fail?  steal_tags() could have just noodled off and
tried to steal from the next CPU if alloc_local_tag() was in progress
on this CPU?

> +		if (nr_free) {
> +			memcpy(tags->freelist,
> +			       remote->freelist,
> +			       sizeof(unsigned) * nr_free);
> +			smp_mb();

Please always document barriers.  Explain in full detail to the reader
which scenario(s) we're barriering against.

> +			remote->nr_free = 0;
> +			tags->nr_free = nr_free;
> +			return true;
> +		} else {
> +			remote->nr_free = 0;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +static bool alloc_global_tags(struct percpu_tag_pool *pool,
> +			      struct percpu_tag_cpu_freelist *tags)
> +{
> +	if (pool->nr_free) {
> +		move_tags(tags->freelist, &tags->nr_free,
> +			  pool->freelist, &pool->nr_free,
> +			  min(pool->nr_free, TAG_CPU_WATERMARK));
> +		return true;
> +	}
> +
> +	return false;
> +}

OK, getting a bit lost now.  What does this do and what is
TAG_CPU_WATERMARK.

> +static unsigned alloc_local_tag(struct percpu_tag_pool *pool,
> +				struct percpu_tag_cpu_freelist *tags)
> +{
> +	unsigned nr_free, old, new, tag;
> +
> +	/*
> +	 * Try per cpu freelist
> +	 * Since we don't have global lock held, need to use cmpxchg()
> +	 * to guard against a different thread using steal_tags() on us:
> +	 */
> +	nr_free = tags->nr_free;
> +
> +	do {
> +		if (!nr_free || nr_free == TAG_CPU_STEALING)
> +			return TAG_FAIL;
> +
> +		old = nr_free;
> +		new = old - 1;
> +		tag = tags->freelist[new];
> +
> +		nr_free = cmpxchg(&tags->nr_free, old, new);
> +	} while (nr_free != old);
> +
> +	return tag;
> +}
> +
> +/**
> + * tag_alloc - allocate a tag

percpu_tag_alloc(), actually.

> + * @pool: pool to allocate from
> + * @gfp: gfp flags
> + *
> + * Returns a tag - an integer in the range [0..nr_tags) (passed to
> + * tag_pool_init()), or otherwise TAG_FAIL on allocation failure.
> + *
> + * Will not fail if passed __GFP_WAIT.
> + */
> +unsigned percpu_tag_alloc(struct percpu_tag_pool *pool, gfp_t gfp)
> +{
> +	DEFINE_WAIT(wait);
> +	struct percpu_tag_cpu_freelist *tags;
> +	unsigned long flags;
> +	unsigned tag, this_cpu;
> +
> +	while (1) {
> +		local_irq_save(flags);

why?  Presumably so the main interfaces are irq-safe.  That would be a
useful thing to include in the interface description.

What actions can a driver take if an irq-time tag allocation attempt
fails?  How can the driver author test those actions?

> +		this_cpu = smp_processor_id();
> +		tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
> +
> +		tag = alloc_local_tag(pool, tags);
> +		if (tag != TAG_FAIL)
> +			break;
> +
> +		spin_lock(&pool->lock);
> +
> +		/*
> +		 * prepare_to_wait() must come before steal_tags(), in case
> +		 * percpu_tag_free() on another cpu flips a bit in
> +		 * cpus_have_tags
> +		 */
> +		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> +
> +		/*
> +		 * alloc_global_tags(), steal_tags() return true iff we now have
> +		 * tags on our percpu freelist
> +		 */
> +		if (alloc_global_tags(pool, tags) ||
> +		    steal_tags(pool, tags)) {
> +			/* Global lock held, don't need cmpxchg */
> +			tag = tags->freelist[--tags->nr_free];
> +			if (tags->nr_free)
> +				set_bit(this_cpu, pool->cpus_have_tags);
> +
> +			spin_unlock(&pool->lock);
> +			break;
> +		}
> +
> +		if (!(gfp & __GFP_WAIT)) {
> +			spin_unlock(&pool->lock);
> +			break;

It's a bit inefficient to do the needless prepare_to_wait/finish_wait
in this case, but livable with.

> +		}
> +
> +		spin_unlock(&pool->lock);
> +		local_irq_restore(flags);
> +
> +		schedule();
> +	}

Does this loop need a try_to_freeze()?

> +	local_irq_restore(flags);
> +	finish_wait(&pool->wait, &wait);
> +	return tag;
> +}
> +EXPORT_SYMBOL_GPL(percpu_tag_alloc);
> +
> +/**
> + * tag_free - free a tag

percpu_tag_free

> + * @pool: pool @tag was allocated from
> + * @tag: a tag previously allocated with tag_alloc()
> + */
> +void percpu_tag_free(struct percpu_tag_pool *pool, unsigned tag)
> +{
> +	struct percpu_tag_cpu_freelist *tags;
> +	unsigned long flags;
> +	unsigned nr_free, old, new, this_cpu;
> +
> +	BUG_ON(tag >= pool->nr_tags);
> +
> +	local_irq_save(flags);
> +	this_cpu = smp_processor_id();
> +	tags = per_cpu_ptr(pool->tag_cpu, this_cpu);
> +
> +	/*
> +	 * Need to guard against racing with steal_tags() on another cpu - we
> +	 * can manage with just cmpxchg because we can only race with tags being
> +	 * pulled off our freelist, not other threads pushing tags back onto our
> +	 * freelist
> +	 */
> +	nr_free = tags->nr_free;
> +
> +	do {
> +		if (nr_free == TAG_CPU_STEALING) {
> +			cpu_relax();
> +			nr_free = tags->nr_free;
> +			continue;
> +		}
> +
> +		old = nr_free;
> +		new = old + 1;
> +		tags->freelist[old] = tag;
> +
> +		nr_free = cmpxchg(&tags->nr_free, old, new);
> +	} while (nr_free != old);
> +
> +	if (!nr_free) {
> +		set_bit(this_cpu, pool->cpus_have_tags);
> +		wake_up(&pool->wait);
> +	}
> +
> +	if (new == TAG_CPU_SIZE) {
> +		spin_lock(&pool->lock);
> +		/* Might have had our tags stolen before we took global lock */
> +		if (tags->nr_free == TAG_CPU_SIZE) {
> +			move_tags(pool->freelist, &pool->nr_free,
> +				  tags->freelist, &tags->nr_free,
> +				  TAG_CPU_WATERMARK);
> +
> +			wake_up(&pool->wait);
> +		}
> +		spin_unlock(&pool->lock);
> +	}
> +
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(percpu_tag_free);
>
> ...
>
