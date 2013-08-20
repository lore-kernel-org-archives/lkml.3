Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3HTU7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:59:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3HTU70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:59:26 -0400
Date: Tue, 20 Aug 2013 13:59:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] mm: workingset: keep shadow entries in check
Message-Id: <20130820135924.937d93a3fd0368b48ba01189@linux-foundation.org>
In-Reply-To: <1376767883-4411-10-git-send-email-hannes@cmpxchg.org>
References: <1376767883-4411-1-git-send-email-hannes@cmpxchg.org>
	<1376767883-4411-10-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Aug 2013 15:31:23 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Previously, page cache radix tree nodes were freed after reclaim
> emptied out their page pointers.  But now reclaim stores shadow
> entries in their place, which are only reclaimed when the inodes
> themselves are reclaimed.  This is problematic for bigger files that
> are still in use after they have a significant amount of their cache
> reclaimed, without any of those pages actually refaulting.  The shadow
> entries will just sit there and waste memory.  In the worst case, the
> shadow entries will accumulate until the machine runs out of memory.

erk.  This whole patch is overhead :(

> To get this under control, a list of inodes that contain shadow
> entries is maintained.  If the global number of shadows exceeds a
> certain threshold, a shrinker is activated that reclaims old entries
> from the mappings.  This is heavy-handed but it should not be a hot
> path and is mainly there to protect from accidentally/maliciously
> induced OOM kills.  The global list is also not a problem because the
> modifications are very rare: inodes are added once in their lifetime
> when the first shadow entry is stored (i.e. the first page reclaimed)
> and lazily removed when the inode exits.  Or if the shrinker removes
> all shadow entries.
> 
> ...
>
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -417,6 +417,7 @@ struct address_space {
>  	/* Protected by tree_lock together with the radix tree */
>  	unsigned long		nrpages;	/* number of total pages */
>  	unsigned long		nrshadows;	/* number of shadow entries */
> +	struct list_head	shadow_list;	/* list of mappings with shadows */
>  	pgoff_t			writeback_index;/* writeback starts here */
>  	const struct address_space_operations *a_ops;	/* methods */
>  	unsigned long		flags;		/* error bits/gfp mask */

There's another 16 bytes into the inode.  Bad.

>
> ...
>
> +void workingset_shadows_inc(struct address_space *mapping)
> +{
> +	might_lock(&shadow_lock);
> +
> +	if (mapping->nrshadows == 0 && list_empty(&mapping->shadow_list)) {
> +		spin_lock(&shadow_lock);

I can't work out whether or not shadow_lock is supposed to be irq-save.
Some places it is, others are unobvious.

> +		list_add(&mapping->shadow_list, &shadow_mappings);
> +		spin_unlock(&shadow_lock);
> +	}
> +
> +	mapping->nrshadows++;
> +	this_cpu_inc(nr_shadows);
> +}
> +
>
> ...
>
> +static unsigned long get_nr_old_shadows(void)
> +{
> +	unsigned long nr_max;
> +	unsigned long nr;
> +	long sum = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(nr_shadows, cpu);

Ouch, slow.  shrink_slab() will call this repeatedly and scan_shadows()
calls it from a loop.  Can we use something non-deathly-slow here? 
Like percpu_counter_read_positive()?

> +	nr = max(sum, 0L);
> +
> +	/*
> +	 * Every shadow entry with a refault distance bigger than the
> +	 * active list is ignored and so NR_ACTIVE_FILE would be a
> +	 * reasonable ceiling.  But scanning and shrinking shadow
> +	 * entries is quite expensive, so be generous.
> +	 */
> +	nr_max = global_dirtyable_memory() * 4;
> +
> +	if (nr <= nr_max)
> +		return 0;
> +	return nr - nr_max;
> +}
> +
> +static unsigned long scan_mapping(struct address_space *mapping,
> +				  unsigned long nr_to_scan)

Some methodological description would be useful.

> +{
> +	unsigned long nr_scanned = 0;
> +	struct radix_tree_iter iter;
> +	void **slot;
> +
> +	rcu_read_lock();
> +restart:
> +	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, 0) {
> +		unsigned long nrshadows;
> +		unsigned long distance;
> +		struct zone *zone;
> +		struct page *page;
> +
> +		page = radix_tree_deref_slot(slot);
> +		if (unlikely(!page))
> +			continue;
> +		if (!radix_tree_exception(page))
> +			continue;
> +		if (radix_tree_deref_retry(page))
> +			goto restart;
> +
> +		unpack_shadow(page, &zone, &distance);
> +
> +		if (distance <= zone_page_state(zone, NR_ACTIVE_FILE))
> +			continue;
> +
> +		spin_lock_irq(&mapping->tree_lock);
> +		if (radix_tree_delete_item(&mapping->page_tree,
> +					   iter.index, page)) {
> +			inc_zone_state(zone, WORKINGSET_SHADOWS_RECLAIMED);
> +			workingset_shadows_dec(mapping);
> +			nr_scanned++;
> +		}
> +		nrshadows = mapping->nrshadows;
> +		spin_unlock_irq(&mapping->tree_lock);
> +
> +		if (nrshadows == 0)
> +			break;
> +
> +		if (--nr_to_scan == 0)
> +			break;
> +	}
> +	rcu_read_unlock();
> +
> +	return nr_scanned;
> +}
> +
>
> ...
>

