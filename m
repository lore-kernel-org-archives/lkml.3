Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3F0Mwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:52:46 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17870 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724Ab3F0Mwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:52:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcOABM1zFF5LKwQ/2dsb2JhbABbgwmDGLdEhSEEAXsXdIIjAQEFJxMcMwgDFQMJJQ8FJQMhARKIDbpTFo4igRISgwJjA5dEkUaDIyqBLCQ
Date: Thu, 27 Jun 2013 22:52:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130627125218.GB32195@dastard>
References: <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627100612.GA29338@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627100612.GA29338@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 08:06:12PM +1000, Dave Chinner wrote:
> On Thu, Jun 27, 2013 at 05:55:43PM +1000, Dave Chinner wrote:
> > On Wed, Jun 26, 2013 at 08:22:55PM -0400, Dave Jones wrote:
> > > On Wed, Jun 26, 2013 at 09:18:53PM +0200, Oleg Nesterov wrote:
> > >  > On 06/25, Dave Jones wrote:
> > >  > >
> > >  > > Took a lot longer to trigger this time. (13 hours of runtime).
> > >  > 
> > >  > And _perhaps_ this means that 3.10-rc7 without 8aac6270 needs more
> > >  > time to hit the same bug ;)
> > ....
> > > What I've gathered so far:
> > > 
> > > - Only affects two machines I have (both Intel Quad core Haswell, one with SSD, one with hybrid SSD)
> > > - One machine is XFS, the other EXT4.
> > > - When the lockup occurs, it happens on all cores.
> > > - It's nearly always a sync() call that triggers it looking like this..
> > > 
> > >   irq event stamp: 8465043
> > >   hardirqs last  enabled at (8465042): [<ffffffff816ebc60>] restore_args+0x0/0x30
> > >   hardirqs last disabled at (8465043): [<ffffffff816f476a>] apic_timer_interrupt+0x6a/0x80
> > >   softirqs last  enabled at (8464292): [<ffffffff81054204>] __do_softirq+0x194/0x440
> > >   softirqs last disabled at (8464295): [<ffffffff8105466d>] irq_exit+0xcd/0xe0
> > >   RIP: 0010:[<ffffffff81054121>]  [<ffffffff81054121>] __do_softirq+0xb1/0x440
> > > 
> > >   Call Trace:
> > >    <IRQ> 
> > >    [<ffffffff8105466d>] irq_exit+0xcd/0xe0
> > >    [<ffffffff816f560b>] smp_apic_timer_interrupt+0x6b/0x9b
> > >    [<ffffffff816f476f>] apic_timer_interrupt+0x6f/0x80
> > >    <EOI> 
> > >    [<ffffffff816ebc60>] ? retint_restore_args+0xe/0xe
> > >    [<ffffffff810b9c56>] ? lock_acquire+0xa6/0x1f0
> > >    [<ffffffff811da892>] ? sync_inodes_sb+0x1c2/0x2a0
> > >    [<ffffffff816eaba0>] _raw_spin_lock+0x40/0x80
> > >    [<ffffffff811da892>] ? sync_inodes_sb+0x1c2/0x2a0
> > >    [<ffffffff811da892>] sync_inodes_sb+0x1c2/0x2a0
> > >    [<ffffffff816e8206>] ? wait_for_completion+0x36/0x110
> > >    [<ffffffff811e04f0>] ? generic_write_sync+0x70/0x70
> > >    [<ffffffff811e0509>] sync_inodes_one_sb+0x19/0x20
> > >    [<ffffffff811b0e62>] iterate_supers+0xb2/0x110
> > >    [<ffffffff811e0775>] sys_sync+0x35/0x90
> > >    [<ffffffff816f3d14>] tracesys+0xdd/0xe2
> > 
> > Is this just a soft lockup warning? Or is the system hung?
> > 
> > I mean, what you see here is probably sync_inodes_sb() having called
> > wait_sb_inodes() and is spinning on the inode_sb_list_lock.
> > 
> > There's nothing stopping multiple sys_sync() calls from executing on
> > the same superblock simulatenously, and if there's lots of cached
> > inodes on a single filesystem and nothing much to write back then
> > concurrent sync() calls will enter wait_sb_inodes() concurrently and
> > contend on the inode_sb_list_lock.
> > 
> > Get enough sync() calls running at the same time, and you'll see
> > this. e.g. I just ran a parallel find/stat workload over a
> > filesystem with 50 million inodes in it, and once that had reached a
> > steady state of about 2 million cached inodes in RAM:
> > 
> > $ for i in `seq 0 1 100`; do time sync & done
> > .....
> > 
> > real    0m38.508s
> > user    0m0.000s
> > sys     0m2.849s
> > $
> 
> Got a prototype patch for this. It's a bit nasty - it hooks the
> test_set_page_writeback/test_clear_page_writeback and adds another
> listhead to the struct inode, but:
> 
> $ time (for i in `seq 0 1 1000`; do sync & done ; wait)
> 
> real    0m0.552s
> user    0m0.097s
> sys     0m1.555s
> $
> 
> Yup, that's about three of orders of magnitude faster on this
> workload....
> 
> Lightly smoke tested patch below - it passed the first round of
> XFS data integrity tests in xfstests, so it's not completely
> busted...

And now with even less smoke out that the first version. This one
gets though a full xfstests run...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

writeback: store inodes under writeback on a separate list

From: Dave Chinner <dchinner@redhat.com>

When there are lots of cached inodes, a sync(2) operation walks all
of them to try to find which ones are under writeback and wait for
IO completion on them. Run enough load, and this caused catastrophic
lock contention on the inode_sb_list_lock.

Try to fix this problem by tracking inodes under data IO and wait
specifically for only those inodes that haven't completed their data
IO in wait_sb_inodes().

This is a bit hacky and messy, but demonstrates one method of
solving this problem....

XXX: This will catch data IO - do we need to catch actual inode
writeback (i.e. the metadata) here? I'm pretty sure we don't need to
because the existing code just calls filemap_fdatawait() and that
doesn't wait for the inode metadata writeback to occur....

[v2 - needs spin_lock_irq variants in wait_sb_inodes.
    - move freeing inodes back to primary list, we don't wait for
      them
    - take mapping lock in wait_sb_inodes when requeuing.]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c           |   50 ++++++++++++++++++++++++++++++++++++-------
 fs/inode.c                  |    1 +
 include/linux/backing-dev.h |    3 +++
 include/linux/fs.h          |    3 ++-
 mm/backing-dev.c            |    2 ++
 mm/page-writeback.c         |   22 +++++++++++++++++++
 6 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3be5718..b0e943a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1208,7 +1208,10 @@ EXPORT_SYMBOL(__mark_inode_dirty);
 
 static void wait_sb_inodes(struct super_block *sb)
 {
-	struct inode *inode, *old_inode = NULL;
+	struct backing_dev_info *bdi = sb->s_bdi;
+	struct inode *old_inode = NULL;
+	unsigned long flags;
+	LIST_HEAD(sync_list);
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -1216,7 +1219,6 @@ static void wait_sb_inodes(struct super_block *sb)
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	spin_lock(&inode_sb_list_lock);
 
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
@@ -1224,19 +1226,40 @@ static void wait_sb_inodes(struct super_block *sb)
 	 * call, but which had writeout started before we write it out.
 	 * In which case, the inode may not be on the dirty list, but
 	 * we still have to wait for that writeout.
+	 *
+	 * To avoid syncing inodes put under IO after we have started here,
+	 * splice the io list to a temporary list head and walk that. Newly
+	 * dirtied inodes will go onto the primary list so we won't wait for
+	 * them.
+	 *
+	 * Inodes that have pages under writeback after we've finished the wait
+	 * may or may not be on the primary list. They had pages under put IOi
+	 * after
+	 * we started our wait, so we need to make sure the next sync or IO
+	 * completion treats them correctly, Move them back to the primary list
+	 * and restart the walk.
+	 *
+	 * Inodes that are clean after we have waited for them don't belong
+	 * on any list, and the cleaning of them should have removed them from
+	 * the temporary list. Check this is true, and restart the walk.
 	 */
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+	spin_lock_irqsave(&bdi->wb.wb_list_lock, flags);
+	list_splice_init(&bdi->wb.b_wb, &sync_list);
+
+	while (!list_empty(&sync_list)) {
+		struct inode *inode = list_first_entry(&sync_list, struct inode,
+						       i_io_list);
 		struct address_space *mapping = inode->i_mapping;
 
 		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    (mapping->nrpages == 0)) {
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
+			list_move(&inode->i_io_list, &bdi->wb.b_wb);
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&inode_sb_list_lock);
+		spin_unlock_irqrestore(&bdi->wb.wb_list_lock, flags);
 
 		/*
 		 * We hold a reference to 'inode' so it couldn't have been
@@ -1253,9 +1276,20 @@ static void wait_sb_inodes(struct super_block *sb)
 
 		cond_resched();
 
-		spin_lock(&inode_sb_list_lock);
+		/*
+		 * the inode has been written back now, so check whether we
+		 * still have pages under IO and move it back to the primary
+		 * list if necessary
+		 */
+		spin_lock_irqsave(&mapping->tree_lock, flags);
+		spin_lock(&bdi->wb.wb_list_lock);
+		if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
+			WARN_ON(list_empty(&inode->i_io_list));
+			list_move(&inode->i_io_list, &bdi->wb.b_wb);
+		}
+		spin_unlock(&mapping->tree_lock);
 	}
-	spin_unlock(&inode_sb_list_lock);
+	spin_unlock_irqrestore(&bdi->wb.wb_list_lock, flags);
 	iput(old_inode);
 }
 
diff --git a/fs/inode.c b/fs/inode.c
index 00d5fc3..f25c1ca 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -364,6 +364,7 @@ void inode_init_once(struct inode *inode)
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_LIST_HEAD(&inode->i_wb_list);
+	INIT_LIST_HEAD(&inode->i_io_list);
 	INIT_LIST_HEAD(&inode->i_lru);
 	address_space_init_once(&inode->i_data);
 	i_size_ordered_init(inode);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c388155..4a6283c 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -59,6 +59,9 @@ struct bdi_writeback {
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
 	spinlock_t list_lock;		/* protects the b_* lists */
+
+	spinlock_t wb_list_lock;	/* writeback list lock */
+	struct list_head b_wb;		/* under writeback, for wait_sb_inodes */
 };
 
 struct backing_dev_info {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63cac31..7861017 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -573,7 +573,8 @@ struct inode {
 	unsigned long		dirtied_when;	/* jiffies of first dirtying */
 
 	struct hlist_node	i_hash;
-	struct list_head	i_wb_list;	/* backing dev IO list */
+	struct list_head	i_wb_list;	/* backing dev WB list */
+	struct list_head	i_io_list;	/* backing dev IO list */
 	struct list_head	i_lru;		/* inode LRU list */
 	struct list_head	i_sb_list;
 	union {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 5025174..896b8f5 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -421,7 +421,9 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
+	INIT_LIST_HEAD(&wb->b_wb);
 	spin_lock_init(&wb->list_lock);
+	spin_lock_init(&wb->wb_list_lock);
 	INIT_DELAYED_WORK(&wb->dwork, bdi_writeback_workfn);
 }
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 4514ad7..4c411fe 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2238,6 +2238,15 @@ int test_clear_page_writeback(struct page *page)
 				__dec_bdi_stat(bdi, BDI_WRITEBACK);
 				__bdi_writeout_inc(bdi);
 			}
+			if (mapping->host &&
+			    !mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
+				struct inode *inode = mapping->host;
+
+				WARN_ON(list_empty(&inode->i_io_list));
+				spin_lock(&bdi->wb.wb_list_lock);
+				list_del_init(&inode->i_io_list);
+				spin_unlock(&bdi->wb.wb_list_lock);
+			}
 		}
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
@@ -2262,11 +2271,24 @@ int test_set_page_writeback(struct page *page)
 		spin_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestSetPageWriteback(page);
 		if (!ret) {
+			bool on_wblist;
+
+			/* __swap_writepage comes through here */
+			on_wblist = mapping_tagged(mapping,
+						   PAGECACHE_TAG_WRITEBACK);
 			radix_tree_tag_set(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi))
 				__inc_bdi_stat(bdi, BDI_WRITEBACK);
+			if (!on_wblist && mapping->host) {
+				struct inode *inode = mapping->host;
+
+				WARN_ON(!list_empty(&inode->i_io_list));
+				spin_lock(&bdi->wb.wb_list_lock);
+				list_add_tail(&inode->i_io_list, &bdi->wb.b_wb);
+				spin_unlock(&bdi->wb.wb_list_lock);
+			}
 		}
 		if (!PageDirty(page))
 			radix_tree_tag_clear(&mapping->page_tree,
