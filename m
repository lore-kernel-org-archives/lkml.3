Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3GBOFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:05:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab3GBOFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:05:13 -0400
Date: Tue, 2 Jul 2013 16:05:08 +0200
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
Message-ID: <20130702140508.GB31770@quack.suse.cz>
References: <20130627125218.GB32195@dastard>
 <20130627152151.GA11551@redhat.com>
 <20130628011301.GC32195@dastard>
 <20130628035825.GC29338@dastard>
 <20130628102819.GA4725@quack.suse.cz>
 <20130629033924.GK32195@dastard>
 <20130701120037.GA6196@quack.suse.cz>
 <20130702062954.GA14996@dastard>
 <20130702081937.GA31770@quack.suse.cz>
 <20130702123835.GF14996@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702123835.GF14996@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-07-13 22:38:35, Dave Chinner wrote:
> > As a bonus filesystems could also optimize their write_inode() methods when
> > they know ->sync_fs() is going to happen in future. E.g. ext4 wouldn't have
> > to do the stupid ext4_force_commit() after each written inode in
> > WB_SYNC_ALL mode.
> 
> Yeah, that's true.
> 
> Since XFS now catches all metadata modifications in it's journal, it
> doesn't have a ->write_inode method anymore.  Only ->fsync,
> ->sync_fs and ->commit_metadata are defined as data integrity
> operations that require metadata to be sychronised and we ensure the
> journal is committed in those methods. WB_SYNC_ALL writeback is
> really only a method for getting data dispatched to disk, so I
> suspect that we should ensure that waiting for data IO completion
> happens at higher levels, not be hidden deep in the guts of writing
> back inode metadata..
  Yeah. Ext4 could probably do the same, just noone took the time to audit
everything properly and remove the historical heritage... That being said
there are tricky things like making sure write_inode_now() from
iput_final() will do the right thing so it's not completely obvious.

> -- 
> Dave Chinner
> david@fromorbit.com
> 
> sync: don't block the flusher thread waiting on IO
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When sync does it's WB_SYNC_ALL writeback, it issues data Io and
> then immediately waits for IO completion. This is done in the
> context of the flusher thread, and hence completely ties up the
> flusher thread for the backing device until all the dirty inodes
> have been synced. On filesystems that are dirtying inodes constantly
> and quickly, this means the flusher thread can be tied up for
> minutes per sync call and hence badly affect system level write IO
> performance as the page cache cannot be cleaned quickly.
> 
> We already have a wait loop for IO completion for sync(2), so cut
> this out of the flusher thread and delegate it to wait_sb_inodes().
> Hence we can do rapid IO submission, and then wait for it all to
> complete.
> 
> Effect of sync on fsmark before the patch:
> 
> FSUse%        Count         Size    Files/sec     App Overhead
> .....
>      0       640000         4096      35154.6          1026984
>      0       720000         4096      36740.3          1023844
>      0       800000         4096      36184.6           916599
>      0       880000         4096       1282.7          1054367
>      0       960000         4096       3951.3           918773
>      0      1040000         4096      40646.2           996448
>      0      1120000         4096      43610.1           895647
>      0      1200000         4096      40333.1           921048
> 
> And a single sync pass took:
> 
> real    0m52.407s
> user    0m0.000s
> sys     0m0.090s
> 
> After the patch, there is no impact on fsmark results, and each
> individual sync(2) operation run concurrently with the same fsmark
> workload takes roughly 7s:
> 
> real    0m6.930s
> user    0m0.000s
> sys     0m0.039s
> 
> IOWs, sync is 7-8x faster on a busy filesystem and does not have an
> adverse impact on ongoing async data write operations.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/fs-writeback.c         |    9 +++++++--
>  include/linux/writeback.h |    1 +
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 25a766c..ea56583 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -45,6 +45,7 @@ struct wb_writeback_work {
>  	unsigned int for_kupdate:1;
>  	unsigned int range_cyclic:1;
>  	unsigned int for_background:1;
> +	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
>  	enum wb_reason reason;		/* why was writeback initiated? */
>  
>  	struct list_head list;		/* pending work list */
> @@ -476,9 +477,11 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  	/*
>  	 * Make sure to wait on the data before writing out the metadata.
>  	 * This is important for filesystems that modify metadata on data
> -	 * I/O completion.
> +	 * I/O completion. We don't do it for sync(2) writeback because it has a
> +	 * separate, external IO completion path and ->sync_fs for guaranteeing
> +	 * inode metadata is written back correctly.
>  	 */
> -	if (wbc->sync_mode == WB_SYNC_ALL) {
> +	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
>  		int err = filemap_fdatawait(mapping);
>  		if (ret == 0)
>  			ret = err;
> @@ -611,6 +614,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  		.tagged_writepages	= work->tagged_writepages,
>  		.for_kupdate		= work->for_kupdate,
>  		.for_background		= work->for_background,
> +		.for_sync		= work->for_sync,
>  		.range_cyclic		= work->range_cyclic,
>  		.range_start		= 0,
>  		.range_end		= LLONG_MAX,
> @@ -1442,6 +1446,7 @@ void sync_inodes_sb(struct super_block *sb)
>  		.range_cyclic	= 0,
>  		.done		= &done,
>  		.reason		= WB_REASON_SYNC,
> +		.for_sync	= 1,
>  	};
>  
>  	/* Nothing to do? */
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 579a500..abfe117 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -78,6 +78,7 @@ struct writeback_control {
>  	unsigned tagged_writepages:1;	/* tag-and-write to avoid livelock */
>  	unsigned for_reclaim:1;		/* Invoked from the page allocator */
>  	unsigned range_cyclic:1;	/* range_start is cyclic */
> +	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
>  };
>  
>  /*
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
