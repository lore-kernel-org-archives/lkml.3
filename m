Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3H3B47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:56:59 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:9757 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451Ab3H3B46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:56:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0JAAv7H1J5LJ62/2dsb2JhbABagweDRLhLhUSBIhd0giQBAQQBJxMcIwULCAMYCSUPBSUDIROHewW5UxaPXgeEHAOXcpFngzIq
Date: Fri, 30 Aug 2013 11:56:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
Message-ID: <20130830015654.GU12779@dastard>
References: <1377726732.3625.31.camel@schen9-DESK>
 <20130829110741.GA23571@dastard>
 <1377799676.3625.69.camel@schen9-DESK>
 <521F949A.2020908@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521F949A.2020908@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 11:36:10AM -0700, Dave Hansen wrote:
> The new shrinker infrastructure in mmotm looks like it will make this
> problem worse.
> 
> old code:
> shrink_slab()
> 	for_each_shrinker {
> 		do_shrinker_shrink(); // one per batch
> 			prune_super()
> 				grab_super_passive()
> 	}
> }

I think you've simplified it down too far. The current code does:

	for_each_shrinker {
		max_pass = do_shrinker_shrink(0);
		// ^^ does grab_super_passive()

		while(total_scan >= batch_size) {
			do_shrinker_shrink(0)
			// ^^ does grab_super_passive()
			do_shrinker_shrink(batch_size)
			// ^^ does grab_super_passive()
		}
	}

> Which means we've got at _most_ one grab_super_passive() per batch.

No, there's two. one count, one scan per batch.

> The new code is something like this:
>
> shrink_slab()
> {
> 	list_for_each_entry(shrinker, &shrinker_list, list) {
>                 for_each_node_mask(... shrinkctl->nodes_to_scan) {
> 			shrink_slab_node()
> 		}
> 	}
> }

Right, but what you are missing here is that the nodemask passed in
to shrink_slab() only has a single node bit set during reclaim -
the bit that matches the zone being reclaimed from.

drop_slab(), OTOH, does:

	nodes_setall(shrink.nodes_to_scan);

before calling shrink_slab in a loopi because it's trying to free
*everything*, and that's why the shrink_slab() code handles that
case.

> shrink_slab_node()
> {
>         max_pass = shrinker->count_objects(shrinker, shrinkctl);
> 	// ^^ does grab_super_passive()
> 	...
> 	while (total_scan >= batch_size) {
> 		ret = shrinker->scan_objects(shrinker, shrinkctl);
> 		// ^^ does grab_super_passive()
> 	}
> }
> 
> We've got an extra grab_super_passive()s in the case where we are
> actually doing a scan, plus we've got the extra for_each_node_mask()
> loop.  That means even more lock acquisitions in the multi-node NUMA
> case, which is exactly where we want to get rid of global lock acquisitions.

I disagree.  With direct memory reclaim, we have an identical number
of calls to shrink_slab() occurring, and each target a single node.
hence there is typically a 1:1 call ratio for
shrink_slab:shrink_slab_node. An because shrink_slab_node() has one
less callout per batch iteration, there is an overall reduction in
the number of grab_super_passive calls from the shrinker. Worst case
is no change, best case is a 50% reduction in the number of calls.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
