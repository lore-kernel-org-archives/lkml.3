Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3GAMIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:08:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab3GAMIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:08:16 -0400
Date: Mon, 1 Jul 2013 14:00:37 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130701120037.GA6196@quack.suse.cz>
References: <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627100612.GA29338@dastard>
 <20130627125218.GB32195@dastard>
 <20130627152151.GA11551@redhat.com>
 <20130628011301.GC32195@dastard>
 <20130628035825.GC29338@dastard>
 <20130628102819.GA4725@quack.suse.cz>
 <20130629033924.GK32195@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629033924.GK32195@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 29-06-13 13:39:24, Dave Chinner wrote:
> On Fri, Jun 28, 2013 at 12:28:19PM +0200, Jan Kara wrote:
> > On Fri 28-06-13 13:58:25, Dave Chinner wrote:
> > > writeback: store inodes under writeback on a separate list
> > > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When there are lots of cached inodes, a sync(2) operation walks all
> > > of them to try to find which ones are under writeback and wait for
> > > IO completion on them. Run enough load, and this caused catastrophic
> > > lock contention on the inode_sb_list_lock.
> > > 
> > > Try to fix this problem by tracking inodes under data IO and wait
> > > specifically for only those inodes that haven't completed their data
> > > IO in wait_sb_inodes().
> > > 
> > > This is a bit hacky and messy, but demonstrates one method of
> > > solving this problem....
> > > 
> > > XXX: This will catch data IO - do we need to catch actual inode
> > > writeback (i.e. the metadata) here? I'm pretty sure we don't need to
> > > because the existing code just calls filemap_fdatawait() and that
> > > doesn't wait for the inode metadata writeback to occur....
> > > 
> > > [v3 - avoid deadlock due to interrupt while holding inode->i_lock]
> > > 
> > > [v2 - needs spin_lock_irq variants in wait_sb_inodes.
> > >     - move freeing inodes back to primary list, we don't wait for
> > >       them
> > >     - take mapping lock in wait_sb_inodes when requeuing.]
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/fs-writeback.c           |   70 +++++++++++++++++++++++++++++++++++++------
> > >  fs/inode.c                  |    1 +
> > >  include/linux/backing-dev.h |    3 ++
> > >  include/linux/fs.h          |    3 +-
> > >  mm/backing-dev.c            |    2 ++
> > >  mm/page-writeback.c         |   22 ++++++++++++++
> > >  6 files changed, 91 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > index 3be5718..589c40b 100644
> > > --- a/fs/fs-writeback.c
> > > +++ b/fs/fs-writeback.c
> > > @@ -1208,7 +1208,10 @@ EXPORT_SYMBOL(__mark_inode_dirty);
> > >  
> > >  static void wait_sb_inodes(struct super_block *sb)
> > >  {
> > > -	struct inode *inode, *old_inode = NULL;
> > > +	struct backing_dev_info *bdi = sb->s_bdi;
> > > +	struct inode *old_inode = NULL;
> > > +	unsigned long flags;
> > > +	LIST_HEAD(sync_list);
> > >  
> > >  	/*
> > >  	 * We need to be protected against the filesystem going from
> > > @@ -1216,7 +1219,6 @@ static void wait_sb_inodes(struct super_block *sb)
> > >  	 */
> > >  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> > >  
> > > -	spin_lock(&inode_sb_list_lock);
> > >  
> > >  	/*
> > >  	 * Data integrity sync. Must wait for all pages under writeback,
> > > @@ -1224,19 +1226,58 @@ static void wait_sb_inodes(struct super_block *sb)
> > >  	 * call, but which had writeout started before we write it out.
> > >  	 * In which case, the inode may not be on the dirty list, but
> > >  	 * we still have to wait for that writeout.
> > > +	 *
> > > +	 * To avoid syncing inodes put under IO after we have started here,
> > > +	 * splice the io list to a temporary list head and walk that. Newly
> > > +	 * dirtied inodes will go onto the primary list so we won't wait for
> > > +	 * them.
> > > +	 *
> > > +	 * Inodes that have pages under writeback after we've finished the wait
> > > +	 * may or may not be on the primary list. They had pages under put IOi
> > > +	 * after
> > > +	 * we started our wait, so we need to make sure the next sync or IO
> > > +	 * completion treats them correctly, Move them back to the primary list
> > > +	 * and restart the walk.
> > > +	 *
> > > +	 * Inodes that are clean after we have waited for them don't belong
> > > +	 * on any list, and the cleaning of them should have removed them from
> > > +	 * the temporary list. Check this is true, and restart the walk.
> > >  	 */
> > > -	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > > +	spin_lock_irqsave(&bdi->wb.wb_list_lock, flags);
> > > +	list_splice_init(&bdi->wb.b_wb, &sync_list);
> > > +
> > > +	while (!list_empty(&sync_list)) {
> > > +		struct inode *inode = list_first_entry(&sync_list, struct inode,
> > > +						       i_io_list);
> > >  		struct address_space *mapping = inode->i_mapping;
> > >  
> > > -		spin_lock(&inode->i_lock);
> > > -		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
> > > -		    (mapping->nrpages == 0)) {
> > > +		/*
> > > +		 * we are nesting the inode->i_lock inside a IRQ disabled
> > > +		 * section here, so there's the possibility that we could have
> > > +		 * a lock inversion due to an interrupt while holding the
> > > +		 * inode->i_lock elsewhere. This is the only place we take the
> > > +		 * inode->i_lock inside the wb_list_lock, so we need to use a
> > > +		 * trylock to avoid a deadlock. If we fail to get the lock,
> > > +		 * the only way to make progress is to also drop the
> > > +		 * wb_list_lock so the interrupt trying to get it can make
> > > +		 * progress.
> > > +		 */
> > > +		if (!spin_trylock(&inode->i_lock)) {
> > > +			list_move(&inode->i_io_list, &bdi->wb.b_wb);
> > > +			spin_unlock_irqrestore(&bdi->wb.wb_list_lock, flags);
> > > +			cpu_relax();
> > > +			spin_lock_irqsave(&bdi->wb.wb_list_lock, flags);
> > > +			continue;
> > > +		}
> > > +
> > > +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
> > > +			list_move(&inode->i_io_list, &bdi->wb.b_wb);
> > >  			spin_unlock(&inode->i_lock);
> > >  			continue;
> > >  		}
> >   Ugh, the locking looks ugly.
> 
> Yes, it is, and I don't really like it.
> 
> >   Plus the list handling is buggy because the
> > first wait_sb_inodes() invocation will move all inodes to its private
> > sync_list so if there's another wait_sb_inodes() invocation racing with it,
> > it won't wait properly for all the inodes it should.
> 
> Hmmmm - yeah, we only have implicit ordering of concurrent sync()
> calls based on the serialisation of bdi-flusher work queuing and
> dispatch. The waiting for IO completion is not serialised at all.
> Seems like it's easy to fix with a per-sb sync mutex around the
> dispatch and wait in sync_inodes_sb()....
> 
> > Won't it be easier to remove inodes from b_wb list (btw, I'd slightly
> > prefer name b_writeback)
> 
> Yeah, b_writeback would be nicer. It's messy, though - the writeback
> structure uses b_io/b_more_io for stuff that is queued for writeback
> (not actually under IO), while the inode calls that the i_wb_list.
> Now we add a writeback list to the writeback structure for inodes
> under IO, and call the inode list i_io_list. I think this needs to
> be cleaned up as well...
  Good point. The naming is somewhat inconsistent and would use a cleanup.

> > lazily instead of from
> > test_clear_page_writeback()? I mean we would remove inodes from b_wb list
> > only in wait_sb_inodes() or when inodes get reclaimed from memory. That way
> > we save some work in test_clear_page_writeback() which is a fast path and
> > defer it to sync which isn't that performance critical.
> 
> We could, but we just end up in the same place with sync as we are
> now - with a long list of clean inodes with a few inodes hidden in
> it that are under IO. i.e. we still have to walk lots of clean
> inodes to find the dirty ones that we need to wait on....
  If the syncs are rare then yes. If they are relatively frequent, you
would win because the first sync will cleanup the list and subsequent ones
will be fast.

> > Also we would avoid
> > that ugly games with irq safe spinlocks.
> 
> Yeah, that is a definite bonus to being lazy.
> 
> Hmmm - perhaps we could do a periodic cleanup of the list via the
> periodic kupdate bdi-flusher pass? Just to clear off anything that
> is clean, not to wait on anything that is under IO. That would stop
> the entire inode cache migrating to this list over time, and
> generally keep it down to a sane size for sync passes...
  I like this idea. That will keep the scanning of even the first sync after
a long time in reasonable bounds.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
