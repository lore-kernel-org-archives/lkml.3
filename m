Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3JKAjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:39:39 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:1125 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915Ab3JKAjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:39:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroGADpIV1J5LFuj/2dsb2JhbABZgweDS7lAhUeBHxd0giUBAQQBOhwjBQsIAw4KCSUPBSUDIROIAAW6PxaPMQeDH4EEA5gEkgODOCg
Date: Fri, 11 Oct 2013 11:39:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
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
        Vlastimil Babka <vbabka@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] mm: thrash detection-based file cache sizing v5
Message-ID: <20131011003930.GC4446@dastard>
References: <1381441622-26215-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381441622-26215-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 05:46:54PM -0400, Johannes Weiner wrote:
> 	Costs
> 
> These patches increase struct inode by three words to manage shadow
> entries in the page cache radix tree.

An additional 24 bytes on a 64 bit system. Filesystem developers
will kill to save 4 bytes in the struct inode, so adding 24 bytes is
a *major* concern.

> However, given that a typical
> inode (like the ext4 inode) is already 1k in size, this is not much.
> It's a 2% size increase for a reclaimable object. 

The struct ext4_inode is one of the larger inodes in the system at
960 bytes (same as the xfs_inode) - most of the filesystem inode
structures are down around the 600-700 byte range.

Really, the struct inode is what you should be comparing the
increase against (i.e. the VFS inode footprint), not the filesystem
specific inode footprint. In that case, it's actually an increase of
closer to a 4% increase in size because we are talking about a 560
byte structure....

> fs_mark metadata
> tests with millions of inodes did not show a measurable difference.
> And as soon as there is any file data involved, the page cache pages
> dominate the memory cost anyway.

We don't need to measure it at runtime to know the difference - a
million inodes will consume an extra 24MB of RAM at minimum. If the
size increase pushes the inode over a slab boundary, it might be
significantly more than that...

The main cost here is a new list head for a new shrinker. There's
interesting new inode lifecycle issues introduced by this shadow
tree - adding serialisation in evict() because the VM can now modify
to the address space without having a reference to the inode
is kinda nasty.

Also, I really don't like the idea of a new inode cache shrinker
that is completely uncoordinated with the existing inode cache
shrinkers. It uses a global lock and list and is not node aware so
all it will do under many workloads is re-introduce a scalability
choke point we just got rid of in 3.12.

I think that you could simply piggy-back on inode_lru_isolate() to
remove shadow mappings in exactly the same manner it removes inode
buffers and page cache pages on inodes that are about to be
reclaimed.  Keeping the size of the inode cache down will have the
side effect of keeping the shadow mappings under control, and so I
don't see a need for a separate shrinker at all here.

And removing the special shrinker will bring the struct inode size
increase back to only 8 bytes, and I think we can live with that
increase given the workload improvements that the rest of the
functionality brings.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
