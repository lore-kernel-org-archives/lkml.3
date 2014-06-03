Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaFCHBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:01:19 -0400
Received: from mail.phunq.net ([184.71.0.62]:38909 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbaFCHBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:01:15 -0400
Message-ID: <538D72B7.3010700@phunq.net>
Date: Tue, 03 Jun 2014 00:01:11 -0700
From: Daniel Phillips <daniel@phunq.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
References: <538B9DEE.20800@phunq.net> <20140602031526.GS14410@dastard> <538CD855.90804@phunq.net> <20140603033322.GA14410@dastard>
In-Reply-To: <20140603033322.GA14410@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
On 06/02/2014 08:33 PM, Dave Chinner wrote:
> On Mon, Jun 02, 2014 at 01:02:29PM -0700, Daniel Phillips wrote:
>>
>> Redirty_tail nearly works, but "if (!list_empty(&wb->b_dirty))" is
>> not correct because the inode needs to end up on the dirty list
>> whether it was already there or not.
> redirty_tail() always moves the inode to the end of the dirty
> list.
>
>> This requirement is analogous to __mark_inode_dirty() and must
>> tolerate similar races. At the microoptimization level, calling
>> redirty_tail from inode_writeback_touch would be less efficient
>> and more bulky. Another small issue is, redirty_tail does not
>> always update the timestamp, which could trigger some bogus
>> writeback events.
> redirty_tail does not update the timestamp when it doesn't need to
> change. If it needs to be changed because the current value would
> violate the time ordering requirements of the list, it rewrites it.
>
> So there is essentially no functional difference between the new
> function and redirty_tail....

Hirofumi, would you care to comment?

>
>>> Hmmmm - this is using the wb dirty lists and locks, but you
>>> don't pass the wb structure to the writeback callout? That seem
>>> wrong to me - why would you bother manipulating these lists if
>>> you aren't using them to track dirty inodes in the first place?
>> From Tux3's point of view, the wb lists just allow fs-writeback to
>> determine when to call ->writeback(). We agree that inode lists
>> are a suboptimal mechanism, but that is how fs-writeback currently
>> thinks. It would be better if our inodes never go onto wb lists in
>> the first place, provided that fs-writeback can still drive
>> writeback appropriately.
> It can't, and definitely not with the callout you added.

Obviously, fs-writeback does not get to choose inodes or specific pages
with our proposal (which is the whole point) but it still decides when
to call Tux3 vs some other filesystem on the same device, and is still
able to indicate how much data it thinks should be written out. Even
though we ignore the latter suggestion and always flush everything, we
appreciate the timing of those callbacks very much, because they give
us exactly the pressure sensitive batching behavior we want.

> However, we already avoid the VFS writeback lists for certain
> filesystems for pure metadata. e.g. XFS does not use the VFS dirty
> inode lists for inode metadata changes.  They get tracked internally
> by the transaction subsystem which does it's own writeback according
> to the requirements of journal space availability.
>
> This is done simply by not calling mark_inode_dirty() on any
> metadata only change. If we want to do the same for data, then we'd
> simply not call mark_inode_dirty() in the data IO path. That
> requires a custom ->set_page_dirty method to be provided by the
> filesystem that didn't call
>
> 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>
> and instead did it's own thing.
>
> So the per-superblock dirty tracking is something we can do right
> now, and some filesystems do it for metadata. The missing piece for
> data is writeback infrastructure capable of deferring to superblocks
> for writeback rather than BDIs....

We agree that fs-writeback inode lists are broken for anything
more sophisticated than Ext2. An advantage of the patch under
consideration is that it still lets fs-writeback mostly work the
way it has worked for the last few years, except for not allowing it
to pick specific inodes and data pages for writeout. As far as I
can see, it still balances writeout between different filesystems
on the same block device pretty well.

>> Perhaps fs-writeback should have an option to work without inode
>> lists at all, and just maintain writeback scheduling statistics in
>> the superblock or similar. That would be a big change, more on the
>> experimental side. We would be happy to take it on after merge,
>> hopefully for the benefit of other filesystems besides Tux3.
> Well, I don't see it that way. If you have a requirement to be able
> to track dirty inodes internally, then lets move to that implement
> that infrastructure rather than hacking around with callouts that
> only have a limited shelf-life.

What you call shelf-life, I call iteration. Small changes are beautiful.
Apologies for the rhetoric, content is below.

> XFS already has everything it needs internally to track dirty
> inodes. In fact, we used to do data writeback from within XFS and we
> slowly removed it as the generic writeback code was improved made
> the XFS code redundant.
>
> That said, parallelising writeback so we can support hundreds of
> GB/s of delayed allocation based writeback is something we
> eventually need to do, and that pretty much means we need to bring
> dirty data inode tracking back into XFS.
>
> So what we really need is writeback infrastructure that is:
>
> 	a) independent of the dirty inode lists
> 	b) implements background, periodic and immediate writeback
> 	c) can be driven by BDI or superblock
>
> IOWs, the abstraction we need for this writeback callout is not at
> the writeback_sb_inodes() layer, it's above the dirty inode list
> queuing layer. IOWs, the callout needs to be closer to the
> wb_do_writeback() layer which drives all the writeback work
> including periodic and background writeback, and the interactions
> between foreground and background work that wb_writeback() uses
> needs to be turned into a bunch of helpers...

I agree, and that is what Tux3 really wants. I just wonder about the
wisdom of embarking on a big change to fs-writeback when a small
change will do. How will fs-writeback balancing between different
filesystems on the same device work? What will those helpers look
like? How long will it take to prove the new scheme stable? How can
we prove that no existing fs-writeback clients will regress?

What about a sporting proposal: you post a patch that trumps ours in
elegance, that you could in theory use for XFS. We verify that it
works for Tux3 at least as well as the current patch. We also test
it for you.

>> This is not cast in stone, but it smells
>> like decent factoring. We can save some spinlocks by violating
>> that factoring (as Hirofumi's original hack did) at the cost of
>> holding a potentially busy wb lock longer, which does not seem
>> like a good trade.
> If we abstract at a higher layer, the wb lock protects just the work
> queuing and dispatch, and everything else can be done by the
> superblock callout. If the superblock callout is missing, then
> we simply fall down to the existing wb_writeback() code that retakes
> the lock and does it's work....
>
> Let's get the layering and abstraction in the right place the first
> time, rather having to revist this in the not-to-distant future.
>

That would be ideal, but incremental also has its attractions. In that
vein, here is a rewrite along the lines you suggested yesterday. The
only change to your code is, the writeback lock is dropped before calling
->writeback(). I tried doing it the other way (in the fs) but it was just
too ugly. As a result, generic_writeback_sb_inodes is called under the wb
list lock, but ->writeback drops it. An oddity that would obviously go
away with a better abstraction along the lines you suggest.

Regards,

Daniel

---

>From 8672ba5915e94a833321435d979615ac7059c789 Mon Sep 17 00:00:00 2001
From: Daniel Phillips <daniel@tux3.org>
Date: Mon, 2 Jun 2014 21:40:19 -0700
Subject: [PATCH] Add a super operation for writeback

Add a "writeback" super operation to be called in the
form:

   progress = s_op->writeback(sb, wb, work, wbc);

Where sb is (struct super_block *), wb is (struct
bdi_writeback *), work is (struct wb_writeback_work *),
and wbc is (struct writeback_control *).

The filesystem is expected to flush some inodes to disk
and return progress of at least 1, or if no inodes are
flushed, return progress of zero. The filesystem should
try to flush at least the number of pages specified in
work->nr_pages, or if that is not possible, return
approximately the number of pages that were not flushed
in work->nr_pages.

Within the ->writeback callback, the filesystem should
call inode_writeback_done(inode) for each inode flushed
(and therefore set clean) or inode_writeback_touch(inode)
for any inode that will be retained dirty in cache.

Signed-off-by: Daniel Phillips <daniel@tux3.org>
---
 fs/fs-writeback.c         | 86 +++++++++++++++++------------------------------
 include/linux/fs.h        |  8 +++--
 include/linux/writeback.h | 19 +++++++++++
 3 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 154d63e..ae25d25 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -34,25 +34,6 @@
  */
 #define MIN_WRITEBACK_PAGES    (4096UL >> (PAGE_CACHE_SHIFT - 10))
 
-/*
- * Passed into wb_writeback(), essentially a subset of writeback_control
- */
-struct wb_writeback_work {
-    long nr_pages;
-    struct super_block *sb;
-    unsigned long *older_than_this;
-    enum writeback_sync_modes sync_mode;
-    unsigned int tagged_writepages:1;
-    unsigned int for_kupdate:1;
-    unsigned int range_cyclic:1;
-    unsigned int for_background:1;
-    unsigned int for_sync:1;    /* sync(2) WB_SYNC_ALL writeback */
-    enum wb_reason reason;        /* why was writeback initiated? */
-
-    struct list_head list;        /* pending work list */
-    struct completion *done;    /* set if the caller waits */
-};
-
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
@@ -622,20 +603,12 @@ static long writeback_chunk_size(struct backing_dev_info *bdi,
  *
  * Return the number of pages and/or inodes written.
  */
-static long __writeback_sb_inodes(struct super_block *sb,
-                struct bdi_writeback *wb,
-                struct wb_writeback_work *work)
+long generic_writeback_sb_inodes(
+    struct super_block *sb,
+    struct bdi_writeback *wb,
+    struct wb_writeback_work *work,
+    struct writeback_control *wbc)
 {
-    struct writeback_control wbc = {
-        .sync_mode        = work->sync_mode,
-        .tagged_writepages    = work->tagged_writepages,
-        .for_kupdate        = work->for_kupdate,
-        .for_background        = work->for_background,
-        .for_sync        = work->for_sync,
-        .range_cyclic        = work->range_cyclic,
-        .range_start        = 0,
-        .range_end        = LLONG_MAX,
-    };
     unsigned long start_time = jiffies;
     long write_chunk;
     long wrote = 0;  /* count both pages and inodes */
@@ -673,7 +646,7 @@ static long __writeback_sb_inodes(struct super_block *sb,
             redirty_tail(inode, wb);
             continue;
         }
-        if ((inode->i_state & I_SYNC) && wbc.sync_mode != WB_SYNC_ALL) {
+        if ((inode->i_state & I_SYNC) && wbc->sync_mode != WB_SYNC_ALL) {
             /*
              * If this inode is locked for writeback and we are not
              * doing writeback-for-data-integrity, move it to
@@ -706,22 +679,22 @@ static long __writeback_sb_inodes(struct super_block *sb,
         spin_unlock(&inode->i_lock);
 
         write_chunk = writeback_chunk_size(wb->bdi, work);
-        wbc.nr_to_write = write_chunk;
-        wbc.pages_skipped = 0;
+        wbc->nr_to_write = write_chunk;
+        wbc->pages_skipped = 0;
 
         /*
          * We use I_SYNC to pin the inode in memory. While it is set
          * evict_inode() will wait so the inode cannot be freed.
          */
-        __writeback_single_inode(inode, &wbc);
+        __writeback_single_inode(inode, wbc);
 
-        work->nr_pages -= write_chunk - wbc.nr_to_write;
-        wrote += write_chunk - wbc.nr_to_write;
+        work->nr_pages -= write_chunk - wbc->nr_to_write;
+        wrote += write_chunk - wbc->nr_to_write;
         spin_lock(&wb->list_lock);
         spin_lock(&inode->i_lock);
         if (!(inode->i_state & I_DIRTY))
             wrote++;
-        requeue_inode(inode, wb, &wbc);
+        requeue_inode(inode, wb, wbc);
         inode_sync_complete(inode);
         spin_unlock(&inode->i_lock);
         cond_resched_lock(&wb->list_lock);
@@ -739,28 +712,31 @@ static long __writeback_sb_inodes(struct super_block *sb,
     return wrote;
 }
 
-static long writeback_sb_inodes(struct super_block *sb,
-                struct bdi_writeback *wb,
-                struct wb_writeback_work *work)
+static long writeback_sb_inodes(
+    struct super_block *sb,
+    struct bdi_writeback *wb,
+    struct wb_writeback_work *work)
 {
-    if (sb->s_op->writeback) {
-        struct writeback_control wbc = {
-            .sync_mode = work->sync_mode,
-            .tagged_writepages = work->tagged_writepages,
-            .for_kupdate = work->for_kupdate,
-            .for_background = work->for_background,
-            .for_sync = work->for_sync,
-            .range_cyclic = work->range_cyclic,
-        };
-        long ret;
+    struct writeback_control wbc = {
+        .sync_mode        = work->sync_mode,
+        .tagged_writepages    = work->tagged_writepages,
+        .for_kupdate        = work->for_kupdate,
+        .for_background        = work->for_background,
+        .for_sync        = work->for_sync,
+        .range_cyclic        = work->range_cyclic,
+        .range_start        = 0,
+        .range_end        = LLONG_MAX,
+    };
 
+    if (sb->s_op->writeback) {
+        int err;
         spin_unlock(&wb->list_lock);
-        ret = sb->s_op->writeback(sb, &wbc, &work->nr_pages);
+        err = sb->s_op->writeback(sb, wb, work, &wbc);
         spin_lock(&wb->list_lock);
-        return ret;
+        return err;
     }
 
-    return __writeback_sb_inodes(sb, wb, work);
+    return generic_writeback_sb_inodes(sb, wb, work, &wbc);
 }
 
 static long __writeback_inodes_wb(struct bdi_writeback *wb,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 91dae3e..fc07d33 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -295,6 +295,8 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct wb_writeback_work;
+struct bdi_writeback;
 
 /*
  * "descriptor" for what we're up to with a read.
@@ -1542,8 +1544,10 @@ struct super_operations {
     int (*statfs) (struct dentry *, struct kstatfs *);
     int (*remount_fs) (struct super_block *, int *, char *);
     void (*umount_begin) (struct super_block *);
-    long (*writeback)(struct super_block *super, struct writeback_control *wbc, long *nr_pages);
-
+    long (*writeback)(struct super_block *sb,
+                struct bdi_writeback *wb,
+                struct wb_writeback_work *work,
+                struct writeback_control *wbc);
     int (*show_options)(struct seq_file *, struct dentry *);
     int (*show_devname)(struct seq_file *, struct dentry *);
     int (*show_path)(struct seq_file *, struct dentry *);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 5777c13..24e12be 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -87,6 +87,25 @@ struct writeback_control {
 };
 
 /*
+ * Passed into wb_writeback(), essentially a subset of writeback_control
+ */
+struct wb_writeback_work {
+    long nr_pages;
+    struct super_block *sb;
+    unsigned long *older_than_this;
+    enum writeback_sync_modes sync_mode;
+    unsigned int tagged_writepages:1;
+    unsigned int for_kupdate:1;
+    unsigned int range_cyclic:1;
+    unsigned int for_background:1;
+    unsigned int for_sync:1;    /* sync(2) WB_SYNC_ALL writeback */
+    enum wb_reason reason;        /* why was writeback initiated? */
+
+    struct list_head list;        /* pending work list */
+    struct completion *done;    /* set if the caller waits */
+};
+
+/*
  * fs/fs-writeback.c
  */   
 struct bdi_writeback;
-- 
1.9.1


