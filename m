Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3GBMir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:38:47 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:10618 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503Ab3GBMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:38:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag0OAI3H0lF5LCeA/2dsb2JhbABagwmDGbgChSgEAX8XdIIjAQEEAScTHA8UBQsIAw4HAwklDwUlAyETHodrBbwBFo4ngR0HgwRnA5dIkUaDIyo
Date: Tue, 2 Jul 2013 22:38:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130702123835.GF14996@dastard>
References: <20130627100612.GA29338@dastard>
 <20130627125218.GB32195@dastard>
 <20130627152151.GA11551@redhat.com>
 <20130628011301.GC32195@dastard>
 <20130628035825.GC29338@dastard>
 <20130628102819.GA4725@quack.suse.cz>
 <20130629033924.GK32195@dastard>
 <20130701120037.GA6196@quack.suse.cz>
 <20130702062954.GA14996@dastard>
 <20130702081937.GA31770@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702081937.GA31770@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 10:19:37AM +0200, Jan Kara wrote:
> On Tue 02-07-13 16:29:54, Dave Chinner wrote:
> > > > We could, but we just end up in the same place with sync as we are
> > > > now - with a long list of clean inodes with a few inodes hidden in
> > > > it that are under IO. i.e. we still have to walk lots of clean
> > > > inodes to find the dirty ones that we need to wait on....
> > >   If the syncs are rare then yes. If they are relatively frequent, you
> > > would win because the first sync will cleanup the list and subsequent ones
> > > will be fast.
> > 
> > I haven't done this yet, because I've found an interesting
> > performance problem with our sync implementation. Basically, sync(2)
> > on a filesystem that is being constantly dirtied blocks the flusher
> > thread waiting for IO completion like so:
> > 
> > # echo w > /proc/sysrq-trigger 
> > [ 1968.031001] SysRq : Show Blocked State
> > [ 1968.032748]   task                        PC stack   pid father
> > [ 1968.034534] kworker/u19:2   D ffff8800bed13140  3448  4830      2 0x00000000
> > [ 1968.034534] Workqueue: writeback bdi_writeback_workfn (flush-253:32)
> > [ 1968.034534]  ffff8800bdca3998 0000000000000046 ffff8800bd1cae20 ffff8800bdca3fd8
> > [ 1968.034534]  ffff8800bdca3fd8 ffff8800bdca3fd8 ffff88003ea10000 ffff8800bd1cae20
> > [ 1968.034534]  ffff8800bdca3968 ffff8800bd1cae20 ffff8800bed139a0 0000000000000002
> > [ 1968.034534] Call Trace:
> > [ 1968.034534]  [<ffffffff81bff7c9>] schedule+0x29/0x70
> > [ 1968.034534]  [<ffffffff81bff89f>] io_schedule+0x8f/0xd0
> > [ 1968.034534]  [<ffffffff8113263e>] sleep_on_page+0xe/0x20
> > [ 1968.034534]  [<ffffffff81bfd030>] __wait_on_bit+0x60/0x90
> > [ 1968.034534]  [<ffffffff81132770>] wait_on_page_bit+0x80/0x90
> > [ 1968.034534]  [<ffffffff81132881>] filemap_fdatawait_range+0x101/0x190
> > [ 1968.034534]  [<ffffffff81132937>] filemap_fdatawait+0x27/0x30
> > [ 1968.034534]  [<ffffffff811a7f18>] __writeback_single_inode+0x1b8/0x220
> > [ 1968.034534]  [<ffffffff811a88ab>] writeback_sb_inodes+0x27b/0x410
> > [ 1968.034534]  [<ffffffff811a8c00>] wb_writeback+0xf0/0x2c0
> > [ 1968.034534]  [<ffffffff811aa668>] wb_do_writeback+0xb8/0x210
> > [ 1968.034534]  [<ffffffff811aa832>] bdi_writeback_workfn+0x72/0x160
> > [ 1968.034534]  [<ffffffff8109e487>] process_one_work+0x177/0x400
> > [ 1968.034534]  [<ffffffff8109eb82>] worker_thread+0x122/0x380
> > [ 1968.034534]  [<ffffffff810a5508>] kthread+0xd8/0xe0
> > [ 1968.034534]  [<ffffffff81c091ec>] ret_from_fork+0x7c/0xb0
> > 
> > i.e. this code:
> > 
> > static int
> > __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
> > {
> >         struct address_space *mapping = inode->i_mapping;
> >         long nr_to_write = wbc->nr_to_write;
> >         unsigned dirty;
> >         int ret;
> > 
> >         WARN_ON(!(inode->i_state & I_SYNC));
> > 
> >         trace_writeback_single_inode_start(inode, wbc, nr_to_write);
> > 
> >         ret = do_writepages(mapping, wbc);
> > 
> >         /*
> >          * Make sure to wait on the data before writing out the metadata.
> >          * This is important for filesystems that modify metadata on data
> >          * I/O completion.
> >          */
> >         if (wbc->sync_mode == WB_SYNC_ALL) {
> >                 int err = filemap_fdatawait(mapping);
> >                 if (ret == 0)
> >                         ret = err;
> >         }
> > ....
> > 
> > If completely serialising IO dispatch during sync. We are not
> > batching IO submission at all - we are dispatching it one inode at a
> > time an then waiting for it to complete.  Guess where in the
> > benchmark run I ran sync:
> > 
> > FSUse%        Count         Size    Files/sec     App Overhead
> > .....
> >      0       640000         4096      35154.6          1026984
> >      0       720000         4096      36740.3          1023844
> >      0       800000         4096      36184.6           916599
> >      0       880000         4096       1282.7          1054367
> >      0       960000         4096       3951.3           918773
> >      0      1040000         4096      40646.2           996448
> >      0      1120000         4096      43610.1           895647
> >      0      1200000         4096      40333.1           921048
> > 
> > sync absolutely *murders* asynchronous IO performance right now
> > because it stops background writeback completely and stalls all new
> > writes in balance_dirty_pages like:
> > 
> > [ 1968.034534] fs_mark         D ffff88007ed13140  3680  9219   7127 0x00000000
> > [ 1968.034534]  ffff88005a279a38 0000000000000046 ffff880040318000 ffff88005a279fd8
> > [ 1968.034534]  ffff88005a279fd8 ffff88005a279fd8 ffff88003e9fdc40 ffff880040318000
> > [ 1968.034534]  ffff88005a279a28 ffff88005a279a70 ffff88007e9e0000 0000000100065d20
> > [ 1968.034534] Call Trace:
> > [ 1968.034534]  [<ffffffff81bff7c9>] schedule+0x29/0x70
> > [ 1968.034534]  [<ffffffff81bfcd3b>] schedule_timeout+0x10b/0x1f0
> > [ 1968.034534]  [<ffffffff81bfe492>] io_schedule_timeout+0xa2/0x100
> > [ 1968.034534]  [<ffffffff8113d6fb>] balance_dirty_pages_ratelimited+0x37b/0x7a0
> > [ 1968.034534]  [<ffffffff811322e8>] generic_file_buffered_write+0x1b8/0x280
> > [ 1968.034534]  [<ffffffff8144e649>] xfs_file_buffered_aio_write+0x109/0x1a0
> > [ 1968.034534]  [<ffffffff8144e7ae>] xfs_file_aio_write+0xce/0x140
> > [ 1968.034534]  [<ffffffff8117f4b0>] do_sync_write+0x80/0xb0
> > [ 1968.034534]  [<ffffffff811801c1>] vfs_write+0xc1/0x1c0
> > [ 1968.034534]  [<ffffffff81180642>] SyS_write+0x52/0xa0
> > [ 1968.034534]  [<ffffffff81c09299>] system_call_fastpath+0x16/0x1b
> > 
> > IOWs, blocking the flusher thread for IO completion on WB_SYNC_ALL
> > writeback is very harmful. Given that we rely on ->sync_fs to
> > guarantee all inode metadata is written back - the async pass up
> > front doesn't do any waiting so any inode metadata updates done
> > after IO completion have to be caught by ->sync_fs - why are we
> > doing IO completion waiting here for sync(2) writeback?
>   So I did a bit of digging in history and the wait in
> __writeback_single_inode() (at that time it was just
> writeback_single_inode()) has been introduced by Christoph in commit
> 26821ed40. It is there for calls like sync_inode() or write_inode_now()
> where it really is necessary.
> 
> You are right that for syncing the whole filesystem like sync(2) does, the
> wait in __writeback_single_inode() isn't necessary. After all, all the
> inode data might have been written back asynchronously so never have to see
> the inode in __writeback_single_inode() when sync_mode == WB_SYNC_ALL and
> each filesystem has to make sure inode metadata is correctly on disk. So
> removing that wait for global sync isn't going to introduce any new
> problem.
> 
> Now how to implement that practically - __writeback_single_inode() is
> called from two places. From writeback_single_inode() - that is the
> function for writing only a single inode, and from writeback_sb_inodes()
> - that is used by flusher threads. I'd be inclined to move do_writepages()
> call from __writeback_single_inode() to the callsites and move the wait to
> writeback_single_inode() only. But that would mean also moving of
> tracepoints and it starts to get a bit ugly. Maybe we could instead create
> a new flag in struct writeback_control to indicate that we are doing global
> sync - for_sync flag? Then we could use that flag in
> __writeback_single_inode() to decide whether to wait or not.

Snap!

I wrote a patch a few hours ago that does exactly this, right down
to the "for_sync" variable name. :)
See below.

> As a bonus filesystems could also optimize their write_inode() methods when
> they know ->sync_fs() is going to happen in future. E.g. ext4 wouldn't have
> to do the stupid ext4_force_commit() after each written inode in
> WB_SYNC_ALL mode.

Yeah, that's true.

Since XFS now catches all metadata modifications in it's journal, it
doesn't have a ->write_inode method anymore.  Only ->fsync,
->sync_fs and ->commit_metadata are defined as data integrity
operations that require metadata to be sychronised and we ensure the
journal is committed in those methods. WB_SYNC_ALL writeback is
really only a method for getting data dispatched to disk, so I
suspect that we should ensure that waiting for data IO completion
happens at higher levels, not be hidden deep in the guts of writing
back inode metadata..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

sync: don't block the flusher thread waiting on IO

From: Dave Chinner <dchinner@redhat.com>

When sync does it's WB_SYNC_ALL writeback, it issues data Io and
then immediately waits for IO completion. This is done in the
context of the flusher thread, and hence completely ties up the
flusher thread for the backing device until all the dirty inodes
have been synced. On filesystems that are dirtying inodes constantly
and quickly, this means the flusher thread can be tied up for
minutes per sync call and hence badly affect system level write IO
performance as the page cache cannot be cleaned quickly.

We already have a wait loop for IO completion for sync(2), so cut
this out of the flusher thread and delegate it to wait_sb_inodes().
Hence we can do rapid IO submission, and then wait for it all to
complete.

Effect of sync on fsmark before the patch:

FSUse%        Count         Size    Files/sec     App Overhead
.....
     0       640000         4096      35154.6          1026984
     0       720000         4096      36740.3          1023844
     0       800000         4096      36184.6           916599
     0       880000         4096       1282.7          1054367
     0       960000         4096       3951.3           918773
     0      1040000         4096      40646.2           996448
     0      1120000         4096      43610.1           895647
     0      1200000         4096      40333.1           921048

And a single sync pass took:

real    0m52.407s
user    0m0.000s
sys     0m0.090s

After the patch, there is no impact on fsmark results, and each
individual sync(2) operation run concurrently with the same fsmark
workload takes roughly 7s:

real    0m6.930s
user    0m0.000s
sys     0m0.039s

IOWs, sync is 7-8x faster on a busy filesystem and does not have an
adverse impact on ongoing async data write operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c         |    9 +++++++--
 include/linux/writeback.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 25a766c..ea56583 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -45,6 +45,7 @@ struct wb_writeback_work {
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
+	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
@@ -476,9 +477,11 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	/*
 	 * Make sure to wait on the data before writing out the metadata.
 	 * This is important for filesystems that modify metadata on data
-	 * I/O completion.
+	 * I/O completion. We don't do it for sync(2) writeback because it has a
+	 * separate, external IO completion path and ->sync_fs for guaranteeing
+	 * inode metadata is written back correctly.
 	 */
-	if (wbc->sync_mode == WB_SYNC_ALL) {
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
 		int err = filemap_fdatawait(mapping);
 		if (ret == 0)
 			ret = err;
@@ -611,6 +614,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 		.tagged_writepages	= work->tagged_writepages,
 		.for_kupdate		= work->for_kupdate,
 		.for_background		= work->for_background,
+		.for_sync		= work->for_sync,
 		.range_cyclic		= work->range_cyclic,
 		.range_start		= 0,
 		.range_end		= LLONG_MAX,
@@ -1442,6 +1446,7 @@ void sync_inodes_sb(struct super_block *sb)
 		.range_cyclic	= 0,
 		.done		= &done,
 		.reason		= WB_REASON_SYNC,
+		.for_sync	= 1,
 	};
 
 	/* Nothing to do? */
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 579a500..abfe117 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -78,6 +78,7 @@ struct writeback_control {
 	unsigned tagged_writepages:1;	/* tag-and-write to avoid livelock */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
+	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
 };
 
 /*
