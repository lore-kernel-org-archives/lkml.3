Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab3K0BKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:10:00 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43307 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758854Ab3K0A7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8IAGRDlVJ5LHyk/2dsb2JhbABZgweDMbMRhUyBJxd0giUBAQQBJxMcIwULCAMOCgklDwUlAyETh3sFv2cXFo5mB4MggRMDmBOSFIM8KIEsJA
Date: Wed, 27 Nov 2013 11:59:48 +1100
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
Message-ID: <20131127005948.GD10988@dastard>
References: <1385336308-27121-1-git-send-email-hannes@cmpxchg.org>
 <1385336308-27121-10-git-send-email-hannes@cmpxchg.org>
 <20131125234921.GK8803@dastard>
 <20131126212725.GG22729@cmpxchg.org>
 <20131126222937.GA10988@dastard>
 <20131126230010.GJ22729@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126230010.GJ22729@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 06:00:10PM -0500, Johannes Weiner wrote:
> On Wed, Nov 27, 2013 at 09:29:37AM +1100, Dave Chinner wrote:
> > On Tue, Nov 26, 2013 at 04:27:25PM -0500, Johannes Weiner wrote:
> > > On Tue, Nov 26, 2013 at 10:49:21AM +1100, Dave Chinner wrote:
> > > > On Sun, Nov 24, 2013 at 06:38:28PM -0500, Johannes Weiner wrote:
> > > > > Previously, page cache radix tree nodes were freed after reclaim
> > > > > emptied out their page pointers.  But now reclaim stores shadow
> > > > > entries in their place, which are only reclaimed when the inodes
> > > > > themselves are reclaimed.  This is problematic for bigger files that
> > > > > are still in use after they have a significant amount of their cache
> > > > > reclaimed, without any of those pages actually refaulting.  The shadow
> > > > > entries will just sit there and waste memory.  In the worst case, the
> > > > > shadow entries will accumulate until the machine runs out of memory.
> > ....
> > > > ....
> > > > > +	radix_tree_replace_slot(slot, page);
> > > > > +	if (node) {
> > > > > +		node->count++;
> > > > > +		/* Installed page, can't be shadow-only anymore */
> > > > > +		if (!list_empty(&node->lru))
> > > > > +			list_lru_del(&workingset_shadow_nodes, &node->lru);
> > > > > +	}
> > > > > +	return 0;
> > > > 
> > > > Hmmmmm - what's the overhead of direct management of LRU removal
> > > > here? Most list_lru code uses lazy removal (i.e. via the shrinker)
> > > > to avoid having to touch the LRU when adding new references to an
> > > > object.....
> > > 
> > > It's measurable in microbenchmarks, but not when any real IO is
> > > involved.  The difference was in the noise even on SSD drives.
> > 
> > Well, it's not an SSD or two I'm worried about - it's devices that
> > can do millions of IOPS where this is likely to be noticable...
> > 
> > > The other list_lru users see items only once they become unused and
> > > subsequent references are expected to be few and temporary, right?
> > 
> > They go onto the list when the refcount falls to zero, but reuse can
> > be frequent when being referenced repeatedly by a single user. That
> > avoids every reuse from removing the object from the LRU then
> > putting it back on the LRU for every reference cycle...
> 
> That's true, but it's less of a concern in the radix_tree_node case
> because it takes a full inactive list cycle after a refault before the
> node is put back on the LRU.  Or a really unlikely placed partial node
> truncation/invalidation (full truncation would just delete the whole
> node anyway).

OK, fair enough. We can deal with the problem if we see it being a
limitation.

> > > We expect pages to refault in spades on certain loads, at which point
> > > we may have thousands of those nodes on the list that are no longer
> > > reclaimable (10k nodes for about 2.5G of cache).
> > 
> > Sure, look at the way the inode and dentry caches work - entire
> > caches of millions of inodes and dentries often sit on the LRUs. A
> > quick look at my workstations dentry cache shows:
> > 
> > $ at /proc/sys/fs/dentry-state 
> > 180108  170596  45      0       0       0
> > 
> > 180k allocated dentries, 170k sitting on the LRU...
> 
> Hm, and a significant amount of those 170k could rotate on the next
> shrinker scan due to recent references or do you generally have
> smaller spikes?

I see very little dentry/inode reclaim because the shrinker tends to
skip most inodes and dentries because they have the referenced bit
set on them whenever the shrinker runs. i.e. that's the working set,
and it gets maintained pretty well...

> But as per above I think the case for lazily removing shadow nodes is
> less convincing than for inodes and dentries.

Agreed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
