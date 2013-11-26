Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab3KZW3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:29:48 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25522 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491Ab3KZW3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:29:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhEIADEglVJ5LHyk/2dsb2JhbABZgwc4gnmzEYVMgSsXdIIlAQEEAScTHCMFCwgDDgoJJQ8FJQMhE4d7Bb9qEwQWjHCBdgeDIIETA5Qxg2KSFIM8KIEsJA
Date: Wed, 27 Nov 2013 09:29:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] mm: keep page cache radix tree nodes in check
Message-ID: <20131126222937.GA10988@dastard>
References: <1385336308-27121-1-git-send-email-hannes@cmpxchg.org>
 <1385336308-27121-10-git-send-email-hannes@cmpxchg.org>
 <20131125234921.GK8803@dastard>
 <20131126212725.GG22729@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126212725.GG22729@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 04:27:25PM -0500, Johannes Weiner wrote:
> On Tue, Nov 26, 2013 at 10:49:21AM +1100, Dave Chinner wrote:
> > On Sun, Nov 24, 2013 at 06:38:28PM -0500, Johannes Weiner wrote:
> > > Previously, page cache radix tree nodes were freed after reclaim
> > > emptied out their page pointers.  But now reclaim stores shadow
> > > entries in their place, which are only reclaimed when the inodes
> > > themselves are reclaimed.  This is problematic for bigger files that
> > > are still in use after they have a significant amount of their cache
> > > reclaimed, without any of those pages actually refaulting.  The shadow
> > > entries will just sit there and waste memory.  In the worst case, the
> > > shadow entries will accumulate until the machine runs out of memory.
....
> > ....
> > > +	radix_tree_replace_slot(slot, page);
> > > +	if (node) {
> > > +		node->count++;
> > > +		/* Installed page, can't be shadow-only anymore */
> > > +		if (!list_empty(&node->lru))
> > > +			list_lru_del(&workingset_shadow_nodes, &node->lru);
> > > +	}
> > > +	return 0;
> > 
> > Hmmmmm - what's the overhead of direct management of LRU removal
> > here? Most list_lru code uses lazy removal (i.e. via the shrinker)
> > to avoid having to touch the LRU when adding new references to an
> > object.....
> 
> It's measurable in microbenchmarks, but not when any real IO is
> involved.  The difference was in the noise even on SSD drives.

Well, it's not an SSD or two I'm worried about - it's devices that
can do millions of IOPS where this is likely to be noticable...

> The other list_lru users see items only once they become unused and
> subsequent references are expected to be few and temporary, right?

They go onto the list when the refcount falls to zero, but reuse can
be frequent when being referenced repeatedly by a single user. That
avoids every reuse from removing the object from the LRU then
putting it back on the LRU for every reference cycle...

> We expect pages to refault in spades on certain loads, at which point
> we may have thousands of those nodes on the list that are no longer
> reclaimable (10k nodes for about 2.5G of cache).

Sure, look at the way the inode and dentry caches work - entire
caches of millions of inodes and dentries often sit on the LRUs. A
quick look at my workstations dentry cache shows:

$ at /proc/sys/fs/dentry-state 
180108  170596  45      0       0       0

180k allocated dentries, 170k sitting on the LRU...

> > > + * Page cache radix tree nodes containing only shadow entries can grow
> > > + * excessively on certain workloads.  That's why they are tracked on
> > > + * per-(NUMA)node lists and pushed back by a shrinker, but with a
> > > + * slightly higher threshold than regular shrinkers so we don't
> > > + * discard the entries too eagerly - after all, during light memory
> > > + * pressure is exactly when we need them.
> > > + *
> > > + * The list_lru lock nests inside the IRQ-safe mapping->tree_lock, so
> > > + * we have to disable IRQs for any list_lru operation as well.
> > > + */
> > > +
> > > +struct list_lru workingset_shadow_nodes;
> > > +
> > > +static unsigned long count_shadow_nodes(struct shrinker *shrinker,
> > > +					struct shrink_control *sc)
> > > +{
> > > +	unsigned long count;
> > > +
> > > +	local_irq_disable();
> > > +	count = list_lru_count_node(&workingset_shadow_nodes, sc->nid);
> > > +	local_irq_enable();
> > 
> > The count returned is not perfectly accurate, and the use of it in
> > the shrinker will be concurrent with other modifications, so
> > disabling IRQs here doesn't add any anything but unnecessary
> > overhead.
> 
> Lockdep complains when taking an IRQ-unsafe lock (lru_lock) inside an
> IRQ-safe lock (mapping->tree_lock).

Bah - sometimes I hate lockdep because it makes people do silly
things just to shut it up. IMO, the right fix is this patch:

https://lkml.org/lkml/2013/7/31/7

> > > +#define NOIRQ_BATCH 32
> > > +
> > > +static enum lru_status shadow_lru_isolate(struct list_head *item,
> > > +					  spinlock_t *lru_lock,
> > > +					  void *arg)
> > > +{
> > > +	struct address_space *mapping;
> > > +	struct radix_tree_node *node;
> > > +	unsigned long *batch = arg;
> > > +	unsigned int i;
> > > +
> > > +	node = container_of(item, struct radix_tree_node, lru);
> > > +	mapping = node->private;
> > > +
> > > +	/* Don't disable IRQs for too long */
> > > +	if (--(*batch) == 0) {
> > > +		spin_unlock_irq(lru_lock);
> > > +		*batch = NOIRQ_BATCH;
> > > +		spin_lock_irq(lru_lock);
> > > +		return LRU_RETRY;
> > > +	}
> > 
> > Ugh.
> > 
> > > +	/* Coming from the list, inverse the lock order */
> > > +	if (!spin_trylock(&mapping->tree_lock))
> > > +		return LRU_SKIP;
> > 
> > Why not spin_trylock_irq(&mapping->tree_lock) and get rid of the
> > nasty irq batching stuff? The LRU list is internally consistent,
> > so I don't see why irqs need to be disabled to walk across the
> > objects in the list - we only need that to avoid taking an interrupt
> > while holding the mapping->tree_lock() and the interrupt running
> > I/O completion which may try to take the mapping->tree_lock....
> 
> Same reason, IRQ-unsafe nesting inside IRQ-safe lock...

Seems to me like you're designing the code to workaround lockdep
deficiencies rather than thinking about the most efficient way to
solve the problem. lockdep can always be fixed to work with
whatever code we come up with, so don't let lockdep stifle your
creativity. ;)

> > Given that we should always be removing the item from the head of
> > the LRU list (except when we can't get the mapping lock), I'd
> > suggest that it would be better to do something like this:
> > 
> > 	/*
> > 	 * Coming from the list, inverse the lock order. Drop the
> > 	 * list lock, too, so that if a caller is spinning on it we
> > 	 * don't get stuck here.
> > 	 */
> > 	if (!spin_trylock(&mapping->tree_lock)) {

That should be spin_trylock_irq()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
