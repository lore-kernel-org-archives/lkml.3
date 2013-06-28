Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3F1K2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:28:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab3F1K2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:28:24 -0400
Date: Fri, 28 Jun 2013 12:28:19 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130628102819.GA4725@quack.suse.cz>
References: <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627100612.GA29338@dastard>
 <20130627125218.GB32195@dastard>
 <20130627152151.GA11551@redhat.com>
 <20130628011301.GC32195@dastard>
 <20130628035825.GC29338@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628035825.GC29338@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28-06-13 13:58:25, Dave Chinner wrote:
> On Fri, Jun 28, 2013 at 11:13:01AM +1000, Dave Chinner wrote:
> > On Thu, Jun 27, 2013 at 11:21:51AM -0400, Dave Jones wrote:
> > > On Thu, Jun 27, 2013 at 10:52:18PM +1000, Dave Chinner wrote:
> > >  
> > >  
> > >  > > Yup, that's about three of orders of magnitude faster on this
> > >  > > workload....
> > >  > > 
> > >  > > Lightly smoke tested patch below - it passed the first round of
> > >  > > XFS data integrity tests in xfstests, so it's not completely
> > >  > > busted...
> > >  > 
> > >  > And now with even less smoke out that the first version. This one
> > >  > gets though a full xfstests run...
> > > 
> > > :sadface:
> > > 
> > > [  567.680836] ======================================================
> > > [  567.681582] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
> > > [  567.682389] 3.10.0-rc7+ #9 Not tainted
> > > [  567.682862] ------------------------------------------------------
> > > [  567.683607] trinity-child2/8665 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> > > [  567.684464]  (&sb->s_type->i_lock_key#3){+.+...}, at: [<ffffffff811d74e5>] sync_inodes_sb+0x225/0x3b0
> > > [  567.685632] 
> > > and this task is already holding:
> > > [  567.686334]  (&(&wb->wb_list_lock)->rlock){..-...}, at: [<ffffffff811d7451>] sync_inodes_sb+0x191/0x3b0
> > > [  567.687506] which would create a new lock dependency:
> > > [  567.688115]  (&(&wb->wb_list_lock)->rlock){..-...} -> (&sb->s_type->i_lock_key#3){+.+...}
> > 
> > .....
> > 
> > > other info that might help us debug this:
> > > 
> > > [  567.750396]  Possible interrupt unsafe locking scenario:
> > > 
> > > [  567.752062]        CPU0                    CPU1
> > > [  567.753025]        ----                    ----
> > > [  567.753981]   lock(&sb->s_type->i_lock_key#3);
> > > [  567.754969]                                local_irq_disable();
> > > [  567.756085]                                lock(&(&wb->wb_list_lock)->rlock);
> > > [  567.757368]                                lock(&sb->s_type->i_lock_key#3);
> > > [  567.758642]   <Interrupt>
> > > [  567.759370]     lock(&(&wb->wb_list_lock)->rlock);
> > 
> > Oh, that's easy enough to fix. It's just changing the wait_sb_inodes
> > loop to use a spin_trylock(&inode->i_lock), moving the inode to
> > the end of the sync list, dropping all locks and starting again...
> 
> New version below, went through xfstests with lockdep enabled this
> time....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> writeback: store inodes under writeback on a separate list
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When there are lots of cached inodes, a sync(2) operation walks all
> of them to try to find which ones are under writeback and wait for
> IO completion on them. Run enough load, and this caused catastrophic
> lock contention on the inode_sb_list_lock.
> 
> Try to fix this problem by tracking inodes under data IO and wait
> specifically for only those inodes that haven't completed their data
> IO in wait_sb_inodes().
> 
> This is a bit hacky and messy, but demonstrates one method of
> solving this problem....
> 
> XXX: This will catch data IO - do we need to catch actual inode
> writeback (i.e. the metadata) here? I'm pretty sure we don't need to
> because the existing code just calls filemap_fdatawait() and that
> doesn't wait for the inode metadata writeback to occur....
> 
> [v3 - avoid deadlock due to interrupt while holding inode->i_lock]
> 
> [v2 - needs spin_lock_irq variants in wait_sb_inodes.
>     - move freeing inodes back to primary list, we don't wait for
>       them
>     - take mapping lock in wait_sb_inodes when requeuing.]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/fs-writeback.c           |   70 +++++++++++++++++++++++++++++++++++++------
>  fs/inode.c                  |    1 +
>  include/linux/backing-dev.h |    3 ++
>  include/linux/fs.h          |    3 +-
>  mm/backing-dev.c            |    2 ++
>  mm/page-writeback.c         |   22 ++++++++++++++
>  6 files changed, 91 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 3be5718..589c40b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1208,7 +1208,10 @@ EXPORT_SYMBOL(__mark_inode_dirty);
>  
>  static void wait_sb_inodes(struct super_block *sb)
>  {
> -	struct inode *inode, *old_inode = NULL;
> +	struct backing_dev_info *bdi = sb->s_bdi;
> +	struct inode *old_inode = NULL;
> +	unsigned long flags;
> +	LIST_HEAD(sync_list);
>  
>  	/*
>  	 * We need to be protected against the filesystem going from
> @@ -1216,7 +1219,6 @@ static void wait_sb_inodes(struct super_block *sb)
>  	 */
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
> -	spin_lock(&inode_sb_list_lock);
>  
>  	/*
>  	 * Data integrity sync. Must wait for all pages under writeback,
> @@ -1224,19 +1226,58 @@ static void wait_sb_inodes(struct super_block *sb)
>  	 * call, but which had writeout started before we write it out.
>  	 * In which case, the inode may not be on the dirty list, but
>  	 * we still have to wait for that writeout.
> +	 *
> +	 * To avoid syncing inodes put under IO after we have started here,
> +	 * splice the io list to a temporary list head and walk that. Newly
> +	 * dirtied inodes will go onto the primary list so we won't wait for
> +	 * them.
> +	 *
> +	 * Inodes that have pages under writeback after we've finished the wait
> +	 * may or may not be on the primary list. They had pages under put IOi
> +	 * after
> +	 * we started our wait, so we need to make sure the next sync or IO
> +	 * completion treats them correctly, Move them back to the primary list
> +	 * and restart the walk.
> +	 *
> +	 * Inodes that are clean after we have waited for them don't belong
> +	 * on any list, and the cleaning of them should have removed them from
> +	 * the temporary list. Check this is true, and restart the walk.
>  	 */
> -	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> +	spin_lock_irqsave(&bdi->wb.wb_list_lock, flags);
> +	list_splice_init(&bdi->wb.b_wb, &sync_list);
> +
> +	while (!list_empty(&sync_list)) {
> +		struct inode *inode = list_first_entry(&sync_list, struct inode,
> +						       i_io_list);
>  		struct address_space *mapping = inode->i_mapping;
>  
> -		spin_lock(&inode->i_lock);
> -		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
> -		    (mapping->nrpages == 0)) {
> +		/*
> +		 * we are nesting the inode->i_lock inside a IRQ disabled
> +		 * section here, so there's the possibility that we could have
> +		 * a lock inversion due to an interrupt while holding the
> +		 * inode->i_lock elsewhere. This is the only place we take the
> +		 * inode->i_lock inside the wb_list_lock, so we need to use a
> +		 * trylock to avoid a deadlock. If we fail to get the lock,
> +		 * the only way to make progress is to also drop the
> +		 * wb_list_lock so the interrupt trying to get it can make
> +		 * progress.
> +		 */
> +		if (!spin_trylock(&inode->i_lock)) {
> +			list_move(&inode->i_io_list, &bdi->wb.b_wb);
> +			spin_unlock_irqrestore(&bdi->wb.wb_list_lock, flags);
> +			cpu_relax();
> +			spin_lock_irqsave(&bdi->wb.wb_list_lock, flags);
> +			continue;
> +		}
> +
> +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
> +			list_move(&inode->i_io_list, &bdi->wb.b_wb);
>  			spin_unlock(&inode->i_lock);
>  			continue;
>  		}
  Ugh, the locking looks ugly. Plus the list handling is buggy because the
first wait_sb_inodes() invocation will move all inodes to its private
sync_list so if there's another wait_sb_inodes() invocation racing with it,
it won't wait properly for all the inodes it should.

Won't it be easier to remove inodes from b_wb list (btw, I'd slightly
prefer name b_writeback) lazily instead of from
test_clear_page_writeback()? I mean we would remove inodes from b_wb list
only in wait_sb_inodes() or when inodes get reclaimed from memory. That way
we save some work in test_clear_page_writeback() which is a fast path and
defer it to sync which isn't that performance critical. Also we would avoid
that ugly games with irq safe spinlocks.

>  		__iget(inode);
>  		spin_unlock(&inode->i_lock);
> -		spin_unlock(&inode_sb_list_lock);
> +		spin_unlock_irqrestore(&bdi->wb.wb_list_lock, flags);
>  
>  		/*
>  		 * We hold a reference to 'inode' so it couldn't have been
> @@ -1253,9 +1294,20 @@ static void wait_sb_inodes(struct super_block *sb)
>  
>  		cond_resched();
>  
> -		spin_lock(&inode_sb_list_lock);
> +		/*
> +		 * the inode has been written back now, so check whether we
> +		 * still have pages under IO and move it back to the primary
> +		 * list if necessary
> +		 */
> +		spin_lock_irqsave(&mapping->tree_lock, flags);
> +		spin_lock(&bdi->wb.wb_list_lock);
> +		if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
> +			WARN_ON(list_empty(&inode->i_io_list));
> +			list_move(&inode->i_io_list, &bdi->wb.b_wb);
> +		}
> +		spin_unlock(&mapping->tree_lock);
>  	}
> -	spin_unlock(&inode_sb_list_lock);
> +	spin_unlock_irqrestore(&bdi->wb.wb_list_lock, flags);
>  	iput(old_inode);
>  }
>  
> diff --git a/fs/inode.c b/fs/inode.c
> index 00d5fc3..f25c1ca 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -364,6 +364,7 @@ void inode_init_once(struct inode *inode)
>  	INIT_HLIST_NODE(&inode->i_hash);
>  	INIT_LIST_HEAD(&inode->i_devices);
>  	INIT_LIST_HEAD(&inode->i_wb_list);
> +	INIT_LIST_HEAD(&inode->i_io_list);
>  	INIT_LIST_HEAD(&inode->i_lru);
>  	address_space_init_once(&inode->i_data);
>  	i_size_ordered_init(inode);
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index c388155..4a6283c 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -59,6 +59,9 @@ struct bdi_writeback {
>  	struct list_head b_io;		/* parked for writeback */
>  	struct list_head b_more_io;	/* parked for more writeback */
>  	spinlock_t list_lock;		/* protects the b_* lists */
> +
> +	spinlock_t wb_list_lock;	/* writeback list lock */
> +	struct list_head b_wb;		/* under writeback, for wait_sb_inodes */
>  };
>  
>  struct backing_dev_info {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 63cac31..7861017 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -573,7 +573,8 @@ struct inode {
>  	unsigned long		dirtied_when;	/* jiffies of first dirtying */
>  
>  	struct hlist_node	i_hash;
> -	struct list_head	i_wb_list;	/* backing dev IO list */
> +	struct list_head	i_wb_list;	/* backing dev WB list */
> +	struct list_head	i_io_list;	/* backing dev IO list */
>  	struct list_head	i_lru;		/* inode LRU list */
>  	struct list_head	i_sb_list;
>  	union {
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 5025174..896b8f5 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -421,7 +421,9 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
>  	INIT_LIST_HEAD(&wb->b_dirty);
>  	INIT_LIST_HEAD(&wb->b_io);
>  	INIT_LIST_HEAD(&wb->b_more_io);
> +	INIT_LIST_HEAD(&wb->b_wb);
>  	spin_lock_init(&wb->list_lock);
> +	spin_lock_init(&wb->wb_list_lock);
>  	INIT_DELAYED_WORK(&wb->dwork, bdi_writeback_workfn);
>  }
>  
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 4514ad7..4c411fe 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2238,6 +2238,15 @@ int test_clear_page_writeback(struct page *page)
>  				__dec_bdi_stat(bdi, BDI_WRITEBACK);
>  				__bdi_writeout_inc(bdi);
>  			}
> +			if (mapping->host &&
> +			    !mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
> +				struct inode *inode = mapping->host;
> +
> +				WARN_ON(list_empty(&inode->i_io_list));
> +				spin_lock(&bdi->wb.wb_list_lock);
> +				list_del_init(&inode->i_io_list);
> +				spin_unlock(&bdi->wb.wb_list_lock);
> +			}
>  		}
>  		spin_unlock_irqrestore(&mapping->tree_lock, flags);
>  	} else {
> @@ -2262,11 +2271,24 @@ int test_set_page_writeback(struct page *page)
>  		spin_lock_irqsave(&mapping->tree_lock, flags);
>  		ret = TestSetPageWriteback(page);
>  		if (!ret) {
> +			bool on_wblist;
> +
> +			/* __swap_writepage comes through here */
> +			on_wblist = mapping_tagged(mapping,
> +						   PAGECACHE_TAG_WRITEBACK);
>  			radix_tree_tag_set(&mapping->page_tree,
>  						page_index(page),
>  						PAGECACHE_TAG_WRITEBACK);
>  			if (bdi_cap_account_writeback(bdi))
>  				__inc_bdi_stat(bdi, BDI_WRITEBACK);
> +			if (!on_wblist && mapping->host) {
> +				struct inode *inode = mapping->host;
> +
> +				WARN_ON(!list_empty(&inode->i_io_list));
> +				spin_lock(&bdi->wb.wb_list_lock);
> +				list_add_tail(&inode->i_io_list, &bdi->wb.b_wb);
> +				spin_unlock(&bdi->wb.wb_list_lock);
> +			}
>  		}
>  		if (!PageDirty(page))
>  			radix_tree_tag_clear(&mapping->page_tree,
  I'm somewhat uneasy about this. Writeback code generally uses
inode_to_bdi() function to get from the mapping to backing_dev_info (which
uses inode->i_sb->s_bdi except for inodes on blockdev_superblock). That isn't
always the same as inode->i_mapping->backing_dev_info used here although
I now fail to remember a case where inode->i_mapping->backing_dev_info
would be a wrong bdi to use for sync purposes.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
