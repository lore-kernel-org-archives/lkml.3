Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaAVStR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:49:17 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:50932 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaAVStQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:49:16 -0500
Date: Wed, 22 Jan 2014 13:48:36 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] mm: keep page cache radix tree nodes in check
Message-ID: <20140122184836.GE4407@cmpxchg.org>
References: <1389377443-11755-1-git-send-email-hannes@cmpxchg.org>
 <1389377443-11755-10-git-send-email-hannes@cmpxchg.org>
 <20140117000517.GB18112@dastard>
 <20140120231737.GS6963@cmpxchg.org>
 <20140121030358.GN18112@dastard>
 <20140121055017.GT6963@cmpxchg.org>
 <20140122030607.GB27606@dastard>
 <20140122065714.GU6963@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122065714.GU6963@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 01:57:14AM -0500, Johannes Weiner wrote:
> Not at this time, I'll try to look into that.  For now, I am updating
> the patch to revert the shrinker back to DEFAULT_SEEKS and change the
> object count to only include objects above a certain threshold, which
> assumes a worst-case population of 4 in 64 slots.  It's not perfect,
> but neither was the seeks magic, and it's easier to reason about what
> it's actually doing.

Ah, the quality of 2am submissions...  8 out of 64 of course.

> @@ -266,14 +269,38 @@ struct list_lru workingset_shadow_nodes;
>  static unsigned long count_shadow_nodes(struct shrinker *shrinker,
>  					struct shrink_control *sc)
>  {
> -	return list_lru_count_node(&workingset_shadow_nodes, sc->nid);
> +	unsigned long shadow_nodes;
> +	unsigned long max_nodes;
> +	unsigned long pages;
> +
> +	shadow_nodes = list_lru_count_node(&workingset_shadow_nodes, sc->nid);
> +	pages = node_present_pages(sc->nid);
> +	/*
> +	 * Active cache pages are limited to 50% of memory, and shadow
> +	 * entries that represent a refault distance bigger than that
> +	 * do not have any effect.  Limit the number of shadow nodes
> +	 * such that shadow entries do not exceed the number of active
> +	 * cache pages, assuming a worst-case node population density
> +	 * of 1/16th on average.

1/8th.  The actual code is consistent:

> +	 * On 64-bit with 7 radix_tree_nodes per page and 64 slots
> +	 * each, this will reclaim shadow entries when they consume
> +	 * ~2% of available memory:
> +	 *
> +	 * PAGE_SIZE / radix_tree_nodes / node_entries / PAGE_SIZE
> +	 */
> +	max_nodes = pages >> (1 + RADIX_TREE_MAP_SHIFT - 3);
> +
> +	if (shadow_nodes <= max_nodes)
> +		return 0;
> +
> +	return shadow_nodes - max_nodes;
>  }
>  
>  static enum lru_status shadow_lru_isolate(struct list_head *item,
>  					  spinlock_t *lru_lock,
>  					  void *arg)
>  {
> -	unsigned long *nr_reclaimed = arg;
>  	struct address_space *mapping;
>  	struct radix_tree_node *node;
>  	unsigned int i;
