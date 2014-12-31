Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaLaI0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:26:08 -0500
Received: from mail.kernel.org ([198.145.29.136]:33724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbaLaI0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:26:06 -0500
Date: Wed, 31 Dec 2014 00:26:03 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
Message-ID: <20141231082442.GA39073@jaegeuk-mac02.mot-mobility.com>
References: <20141222020317.GB3335@lcm>
 <000001d01db6$7d718770$78549650$@samsung.com>
 <20141222231604.GC8287@jaegeuk-mac02.mot.com>
 <002a01d01e5c$e2ba0250$a82e06f0$@samsung.com>
 <20141223073609.GA9946@jaegeuk-mac02.hsd1.ca.comcast.net>
 <006e01d01f4f$ef9fa940$cedefbc0$@samsung.com>
 <20141225083523.GA18401@jaegeuk-mac02.hsd1.ca.comcast.net>
 <003301d02337$e793a210$b6bae630$@samsung.com>
 <20141229212300.GB29975@jaegeuk-mac02.mot.com>
 <004b01d02418$f77db490$e6791db0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004b01d02418$f77db490$e6791db0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Tue, Dec 30, 2014 at 06:10:21PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Tuesday, December 30, 2014 5:23 AM
> > To: Chao Yu
> > Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > 
> > Hi Chao,
> > 
> > On Mon, Dec 29, 2014 at 03:19:18PM +0800, Chao Yu wrote:
> > 
> > [snip]
> > 
> > Nice draft. :)
> 
> Thanks! :)
> 
> > 
> > >
> > > Please see the draft below.
> > >
> > > 1) Extent management:
> > > If we use global management that managing all extents which are from different
> > > inodes in sbi, we will face with serious lock contention when we access these
> > > extents belong to different inodes concurrently, the loss may outweights the
> > > gain.
> > 
> > Agreed.
> > 
> > > So we choose a local management for extent which means all extents are
> > > managed by inode itself to avoid above lock contention. Addtionlly, we manage
> > > all extents globally by linking all inode into a global lru list for extent
> > > cache shrinker.
> > > Approach:
> > > 	a) build extent tree/rwlock/lru list/extent count in each inode.
> > > 		*extent tree: link all extent in rb-tree;
> > > 		*rwlock: protect fields when accessing extent cache concurrently;
> > > 		*lru list: sort all extents in accessing time order;
> > > 		*extent count: record total count of extents in cache.
> > > 	b) use lru shrink list in sbi to manage all inode which cached extents.
> > > 		*inode will be added or repostioned in this global list whenever
> > > 		extent is being access in this inode.
> > > 		*use spinlock to protect this shrink list.
> > 
> > 1. How about adding a data structure with inode number instead of referring
> > inode pointer?
> > 
> > 2. How about managing extent entries globally and setting an upper bound to
> > the number of extent entries instead of limiting them per each inode?
> > (The rb-tree will handle many extents per inode.)
> 
> [assumption]
> Approach A: global lru list;
> Approach B: lru list per inode.
> 
> I have considered Approach A before writing the draft, although Approach A could
> provide us higher ratio hit due to global lru, it may make lock contention more
> intensively and has more memory overhead descripted below. So I choose more
> conservative Approach B.
> 1) as extent_entry will split in Cow, we may lock extent_list more times when
> move these separated extent entries in extent_list, unless we have batch mode
> interface.
> 2) lock overhead between shrinker and lookuper and updater.
> e.g. extent_list: (LRU) A -> B -> C -> D -> E -> F -> G (MRU)
> (#1) has A, C, E, G in rb-tree
> (#2) has B, D, F in rb-tree
> shrinker op: lock list -> trylock #1 -> unlock list -> free A -> unlock #1
> 	lock list -> trylock #2 -> unlock list -> free B -> unlock #2
> 	lock list -> trylock #1 -> unlock list -> free C -> unlock #1
> 	...

lock_list -> list_del(A) -> unlock_list -> lock #1 -> remove_tree(A) -> unlock #1
-> free A.

Or,
lock_list -> list_del(A, B, C) -> unlock_list -> lock #1 -> remove_tree(A, C) ->
unlock #1 -> free A, C -> lock #2 -> remove_tree(B) -> unlock #2

I think a couple of list operations do not cause severe lock contention.
And, if we assing minimum length for extent caches, the contention would be
distributed.

This means that, it needs to manage each of all the extents in the cache should
have the length larger than minimum value.

> *trylock/unlock* for all free extent entries belong to one inode will be separated
> to lots of parts, resulting in more contention.
> 3) it has more memory overhead in each extent entry:
> Approach A: need add inode number for backref and list_head *

It doesn't need to add ino. Just remain them, and shrinker can remove empty
ino_entry_for_extents periodically.

> Approach B: need add list_head *
> 
> Or maybe it's not a problem because we can afford all these above.
> 
> Anyway, I'm not against.
> 
> > 
> > 3. It needs to set a minimum length for the candidate of extent cache.
> >  (e.g., 64)
> 
> Is this used for shrinker? Can you please explain more about this minimum length?
> 
> > 
> > So, for example,
> > struct ino_entry_for_extents {
> > 	inode number;
> > 	rb_tree for extent_entry objects;
> > 	rwlock;
> > };
> > 
> > struct extent_entry {
> > 	blkaddr, len;
> > 	list_head *;
> 
> We should add one other field 'inode number' here, as through it we can get
> rb-tree root from ino_entry_for_extents for rb_erase when we free the extent
> entry in shrinker.
> 
> > };
> > 
> > Something like this.
> > 
> > [A, B, C, ... are extent entry]
> > 
> > The sbi has
> > 1. an extent_list: (LRU) A -> B -> C -> D -> E -> F -> G (MRU)
> > 2. radix_tree:  ino_entry_for_extents (#10) has D, B in rb-tree
> >               ` ino_entry_for_extents (#11) has A, C in rb-tree
> >               ` ino_entry_for_extents (#12) has F    in rb-tree
> >               ` ino_entry_for_extents (#13) has G, E in rb-tree
> > 
> > In f2fs_update_extent_cache and __get_data_block for #10,
> >   ino_entry_for_extents (#10) was founded and updated D or B.
> >   Then, updated entries are moved to MRU.
> > 
> > In f2fs_evict_inode for #11, A and C are moved to LRU.
> > But, if this inode is unlinked, all the A, C, and ino_entry_for_extens (#11)
> > should be released.
> > 
> > In f2fs_balance_fs_bg, some LRU extents are released according to the amount
> > of consumed memory. Then, it frees any ino_entry_for_extents having no extent.
> > 
> > IMO, we don't need to consider readahead for this, since get_data_block will
> > be called by VFS readahead.
> 
> In get_data_block we can cache only one blkaddr once after get_dnode_of_data
> returned, it seems less efficient. So why not readahead selectively more
> contiguous valid blkaddr in get_dnode_of_data once?

Why do you think only one blkaddr?
get_data_block searches extents as many as possible.

Thanks,

> 
> > 
> > Furthermore, we need to think about whether LRU is really best or not.
> > IMO, the extent cache aims to improve second access speed, rather than initial
> > cold misses. So, maybe MRU or another algorithms would be better.
> 
> Agree, let's rethink about this. :)
> 
> Thanks,
> 
> > 
> > Thanks,
> > 
> > >
> > > 2) Limitation:
> > > In one inode, as we split or add extent in extent cache when read/write, extent
> > > number will enlarge, so memory and CPU overhead will increase.
> > > In order to control the overhead of memory and CPU, we try to set a upper bound
> > > number to limit total extent number in each inode, This number is global
> > > configuration which is visable to all inode. This number will be exported to
> > > sysfs for configuring according to requirement of user. By default, designed
> > > number is 8.
> > >
> > > 3) Shrinker:
> > > There are two shrink paths:
> > > 	a) one is triggered when extent count has exceed the upper bound of
> > > 	inode's extent cache. We will try to release extent(s) from head of
> > > 	inode's inner extent lru list until extent count is equal to upper bound.
> > > 	This operation could be in f2fs_update_extent_cache().
> > > 	b) the other one is triggered when memory util exceed threshold, we try
> > > 	get inode from head of global lru list(s), and release extent(s) with
> > > 	fixed number (by default: 64 extents) in inode one by one.
> > > 	This operation could be in f2fs_balance_fs_bg().
> > >
> > > 4) Revalidation:
> > > In ->evict(), extent cache will be released, in order to reuse extent cache
> > > of inode when reopen for high hit ratio, a proper way is to add cached extent
> > > tree into a hash table (could be radix tree), revalidate extent tree and recover
> > > it to inode when reopen.
> > > Besides, a global lru list is needed here for shrinker.
> > >
> > > 5) Readahead:
> > > Expand extent cache by readaheading when we call get_dnode_of_data in non-emergency
> > > path. Note, ra can affect lock contention for both ->rwlock in extent cache and
> > > ->lock of global shrink list.
> > >
