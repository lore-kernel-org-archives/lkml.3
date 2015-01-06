Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbbAFXAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:00:45 -0500
Received: from mail.kernel.org ([198.145.29.136]:56613 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbbAFXAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:00:43 -0500
Date: Tue, 6 Jan 2015 15:00:37 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
Message-ID: <20150106225916.GD54001@jaegeuk-mac02>
References: <20141222231604.GC8287@jaegeuk-mac02.mot.com>
 <002a01d01e5c$e2ba0250$a82e06f0$@samsung.com>
 <20141223073609.GA9946@jaegeuk-mac02.hsd1.ca.comcast.net>
 <006e01d01f4f$ef9fa940$cedefbc0$@samsung.com>
 <20141225083523.GA18401@jaegeuk-mac02.hsd1.ca.comcast.net>
 <003301d02337$e793a210$b6bae630$@samsung.com>
 <20141229212300.GB29975@jaegeuk-mac02.mot.com>
 <004b01d02418$f77db490$e6791db0$@samsung.com>
 <20141231082442.GA39073@jaegeuk-mac02.mot-mobility.com>
 <003b01d027f7$f499a620$ddccf260$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003b01d027f7$f499a620$ddccf260$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Sun, Jan 04, 2015 at 04:24:10PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Wednesday, December 31, 2014 4:26 PM
> > To: Chao Yu
> > Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > 
> > Hi Chao,
> > 
> > On Tue, Dec 30, 2014 at 06:10:21PM +0800, Chao Yu wrote:
> > > Hi Jaegeuk,
> > >
> > > > -----Original Message-----
> > > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > > Sent: Tuesday, December 30, 2014 5:23 AM
> > > > To: Chao Yu
> > > > Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > > >
> > > > Hi Chao,
> > > >
> > > > On Mon, Dec 29, 2014 at 03:19:18PM +0800, Chao Yu wrote:
> > > >
> > > > [snip]
> > > >
> > > > Nice draft. :)
> > >
> > > Thanks! :)
> > >
> > > >
> > > > >
> > > > > Please see the draft below.
> > > > >
> > > > > 1) Extent management:
> > > > > If we use global management that managing all extents which are from different
> > > > > inodes in sbi, we will face with serious lock contention when we access these
> > > > > extents belong to different inodes concurrently, the loss may outweights the
> > > > > gain.
> > > >
> > > > Agreed.
> > > >
> > > > > So we choose a local management for extent which means all extents are
> > > > > managed by inode itself to avoid above lock contention. Addtionlly, we manage
> > > > > all extents globally by linking all inode into a global lru list for extent
> > > > > cache shrinker.
> > > > > Approach:
> > > > > 	a) build extent tree/rwlock/lru list/extent count in each inode.
> > > > > 		*extent tree: link all extent in rb-tree;
> > > > > 		*rwlock: protect fields when accessing extent cache concurrently;
> > > > > 		*lru list: sort all extents in accessing time order;
> > > > > 		*extent count: record total count of extents in cache.
> > > > > 	b) use lru shrink list in sbi to manage all inode which cached extents.
> > > > > 		*inode will be added or repostioned in this global list whenever
> > > > > 		extent is being access in this inode.
> > > > > 		*use spinlock to protect this shrink list.
> > > >
> > > > 1. How about adding a data structure with inode number instead of referring
> > > > inode pointer?
> > > >
> > > > 2. How about managing extent entries globally and setting an upper bound to
> > > > the number of extent entries instead of limiting them per each inode?
> > > > (The rb-tree will handle many extents per inode.)
> > >
> > > [assumption]
> > > Approach A: global lru list;
> > > Approach B: lru list per inode.
> > >
> > > I have considered Approach A before writing the draft, although Approach A could
> > > provide us higher ratio hit due to global lru, it may make lock contention more
> > > intensively and has more memory overhead descripted below. So I choose more
> > > conservative Approach B.
> > > 1) as extent_entry will split in Cow, we may lock extent_list more times when
> > > move these separated extent entries in extent_list, unless we have batch mode
> > > interface.
> > > 2) lock overhead between shrinker and lookuper and updater.
> > > e.g. extent_list: (LRU) A -> B -> C -> D -> E -> F -> G (MRU)
> > > (#1) has A, C, E, G in rb-tree
> > > (#2) has B, D, F in rb-tree
> > > shrinker op: lock list -> trylock #1 -> unlock list -> free A -> unlock #1
> > > 	lock list -> trylock #2 -> unlock list -> free B -> unlock #2
> > > 	lock list -> trylock #1 -> unlock list -> free C -> unlock #1
> > > 	...
> > 
> > lock_list -> list_del(A) -> unlock_list -> lock #1 -> remove_tree(A) -> unlock #1
> > -> free A.
> 
> If unlock_list before lock #1, (A) could be modified by other thread between ->unlock_list
> and lock #1, so one more "lookup_tree(A)" is needed under lock #1:
> lock #1 -> lookup_tree(A) -> remove_tree(A) -> unlock #1
> 
> > 
> > Or,
> > lock_list -> list_del(A, B, C) -> unlock_list -> lock #1 -> remove_tree(A, C) ->
> > unlock #1 -> free A, C -> lock #2 -> remove_tree(B) -> unlock #2
> 
> ditto.
> To avoid unneeded lookup_tree(A), maybe we can use this series:
> 
> lock list -> get A from head -> trylock #1 -> try to get more node(C, E, G) of #1 in list
> -> unlock list -> remove_tree&free(A, C, E, G) -> unlock #1
> 
> > 
> > I think a couple of list operations do not cause severe lock contention.
> 
> Yeah, batch operation is better.
> But sometimes random write break extent into everywhere in shrinker's list,
> so batch operation can gain less in this condition.
> 
> > And, if we assing minimum length for extent caches, the contention would be
> > distributed.
> > 
> > This means that, it needs to manage each of all the extents in the cache should
> > have the length larger than minimum value.
> 
> If I do not misunderstand, what you mean is that if extent number in one inode cache
> is bigger than minimum value, then, we will start to add all extents of this inode
> into shrinker's list, and reposition them in the list when f2fs_{lookup,update}_extent_cache?
> 
> > 
> > > *trylock/unlock* for all free extent entries belong to one inode will be separated
> > > to lots of parts, resulting in more contention.
> > > 3) it has more memory overhead in each extent entry:
> > > Approach A: need add inode number for backref and list_head *
> > 
> > It doesn't need to add ino. Just remain them, and shrinker can remove empty
> > ino_entry_for_extents periodically.
> 
> I do not understand why we don't need ino, :(.
> Without ino, how can we get the rb-tree root pointer for rb_erase(node, root)?

Let me describe in more detail.

For example,

- global radix tree in sbi
  --> ino #1 --> rb_tree (rb_tree, rb_tree_lock, refcount=0)
  --> ino #2 --> rb_tree
  --> ino #3 --> rb_tree
                    `-> extent A 
		    `-> extent B (fofs, blkaddr, length, *list_head=empty)

- global extent list in sbi

  extent_list: (LRU) A -> B -> C -> D -> E -> F -> G (MRU)
  (#1) has A, C, E, G in rb-tree
  (#2) has B, D, F in rb-tree

1) update extents (#1)

 - lock_radix_tree
     if (notfound #1)
         allocate #1;
     #1's refcount++;
 - unlock_radix_tree

 - lock_rb_tree (#1)
     update A
     rb_delete E, if E->length is smaller than MIN_LEN.
     allocate & rb_add K, if K->length is larget than MIN_LEN.

     list_lock
     list_move(A)
     list_del(E)
     list_add_tail(K)
     list_unlock
 - unlock_rb_tree (#1)

 - #1's rafcount--;

2) shrinker

 - list_lock
     list_del A, B, C, ...
 - list_unlock

 - gang_look_up_radix_tree_with_lock {

     #N's refcount++;

     lock_rb_tree (#N)
         for_each_rb_node {
             if (list_empty(extent->list_head)) {
                 remove_rb_node(extent);
                 free(extent);
             }
	 }
     unlock_rb_tree (#N)

     #N's refcount--;
 - }

 - for_each_radix_tree_with_lock {
     if (radix_node->refcount == 0 && rb_tree_is_empty)
         free(radix_node);
 - }

3) lookup extents (#1)

 - lock_radix_tree
     if (notfound #1)
         goto out;
     #1's refcount++;
 - unlock_radix_tree

 - lock_rb_tree (#1)
     found extent A

     list_lock
     list_move(A)
     list_unlock
 - unlock_rb_tree (#1)

 - #1's rafcount--;


> 
> > 
> > > Approach B: need add list_head *
> > >
> > > Or maybe it's not a problem because we can afford all these above.
> > >
> > > Anyway, I'm not against.
> > >
> > > >
> > > > 3. It needs to set a minimum length for the candidate of extent cache.
> > > >  (e.g., 64)
> > >
> > > Is this used for shrinker? Can you please explain more about this minimum length?
> > >
> > > >
> > > > So, for example,
> > > > struct ino_entry_for_extents {
> > > > 	inode number;
> > > > 	rb_tree for extent_entry objects;
> > > > 	rwlock;
> > > > };
> > > >
> > > > struct extent_entry {
> > > > 	blkaddr, len;
> > > > 	list_head *;
> > >
> > > We should add one other field 'inode number' here, as through it we can get
> > > rb-tree root from ino_entry_for_extents for rb_erase when we free the extent
> > > entry in shrinker.
> > >
> > > > };
> > > >
> > > > Something like this.
> > > >
> > > > [A, B, C, ... are extent entry]
> > > >
> > > > The sbi has
> > > > 1. an extent_list: (LRU) A -> B -> C -> D -> E -> F -> G (MRU)
> > > > 2. radix_tree:  ino_entry_for_extents (#10) has D, B in rb-tree
> > > >               ` ino_entry_for_extents (#11) has A, C in rb-tree
> > > >               ` ino_entry_for_extents (#12) has F    in rb-tree
> > > >               ` ino_entry_for_extents (#13) has G, E in rb-tree
> > > >
> > > > In f2fs_update_extent_cache and __get_data_block for #10,
> > > >   ino_entry_for_extents (#10) was founded and updated D or B.
> > > >   Then, updated entries are moved to MRU.
> > > >
> > > > In f2fs_evict_inode for #11, A and C are moved to LRU.
> > > > But, if this inode is unlinked, all the A, C, and ino_entry_for_extens (#11)
> > > > should be released.
> > > >
> > > > In f2fs_balance_fs_bg, some LRU extents are released according to the amount
> > > > of consumed memory. Then, it frees any ino_entry_for_extents having no extent.
> > > >
> > > > IMO, we don't need to consider readahead for this, since get_data_block will
> > > > be called by VFS readahead.
> > >
> > > In get_data_block we can cache only one blkaddr once after get_dnode_of_data
> > > returned, it seems less efficient. So why not readahead selectively more
> > > contiguous valid blkaddr in get_dnode_of_data once?
> > 
> > Why do you think only one blkaddr?
> > get_data_block searches extents as many as possible.
> 
> Surely not one blkaddr.
> 
> Actually, what I mean is that:
> ->get_dnode_of_data
>   ->f2fs_ra_extent_cache()
> 
> f2fs_ra_extent_cache(node_page, offset) {
> 	for (i = offset; i < max; i++) {
> 		if (is_valid() && is_contiguous())
> 			len++;
> 	}
> 	f2fs_update_extent_cache(inode, fofs, blk_addr, len)
> }
> 
> But not:
> ->__get_data_block
>   ->get_dnode_of_data
>   ->f2fs_update_extent_cache(inode, fofs, blk_addr, 1);
> 
> Thanks,
> Yu
> 
> > 
> > Thanks,
> > 
> > >
> > > >
> > > > Furthermore, we need to think about whether LRU is really best or not.
> > > > IMO, the extent cache aims to improve second access speed, rather than initial
> > > > cold misses. So, maybe MRU or another algorithms would be better.
> > >
> > > Agree, let's rethink about this. :)
> > >
> > > Thanks,
> > >
> > > >
> > > > Thanks,
> > > >
> > > > >
> > > > > 2) Limitation:
> > > > > In one inode, as we split or add extent in extent cache when read/write, extent
> > > > > number will enlarge, so memory and CPU overhead will increase.
> > > > > In order to control the overhead of memory and CPU, we try to set a upper bound
> > > > > number to limit total extent number in each inode, This number is global
> > > > > configuration which is visable to all inode. This number will be exported to
> > > > > sysfs for configuring according to requirement of user. By default, designed
> > > > > number is 8.
> > > > >
> > > > > 3) Shrinker:
> > > > > There are two shrink paths:
> > > > > 	a) one is triggered when extent count has exceed the upper bound of
> > > > > 	inode's extent cache. We will try to release extent(s) from head of
> > > > > 	inode's inner extent lru list until extent count is equal to upper bound.
> > > > > 	This operation could be in f2fs_update_extent_cache().
> > > > > 	b) the other one is triggered when memory util exceed threshold, we try
> > > > > 	get inode from head of global lru list(s), and release extent(s) with
> > > > > 	fixed number (by default: 64 extents) in inode one by one.
> > > > > 	This operation could be in f2fs_balance_fs_bg().
> > > > >
> > > > > 4) Revalidation:
> > > > > In ->evict(), extent cache will be released, in order to reuse extent cache
> > > > > of inode when reopen for high hit ratio, a proper way is to add cached extent
> > > > > tree into a hash table (could be radix tree), revalidate extent tree and recover
> > > > > it to inode when reopen.
> > > > > Besides, a global lru list is needed here for shrinker.
> > > > >
> > > > > 5) Readahead:
> > > > > Expand extent cache by readaheading when we call get_dnode_of_data in non-emergency
> > > > > path. Note, ra can affect lock contention for both ->rwlock in extent cache and
> > > > > ->lock of global shrink list.
> > > > >
