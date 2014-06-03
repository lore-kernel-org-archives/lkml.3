Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaFCH0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:26:09 -0400
Received: from mail.phunq.net ([184.71.0.62]:46288 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbaFCH0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:26:08 -0400
Message-ID: <538D788C.5060702@phunq.net>
Date: Tue, 03 Jun 2014 00:26:04 -0700
From: Daniel Phillips <daniel@phunq.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
References: <538B9DEE.20800@phunq.net> <20140602031526.GS14410@dastard> <538CD855.90804@phunq.net> <20140603033322.GA14410@dastard> <538D72B7.3010700@phunq.net>
In-Reply-To: <538D72B7.3010700@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Here is a non-incremental patch. This implements your suggestion
from yesterday, except that the wb list lock is dropped before
calling ->writeback().

Regards,

Daniel

>From d030d328757b160b39b252e82811a94843513cfc Mon Sep 17 00:00:00 2001
From: Daniel Phillips <daniel@tux3.org>
Date: Tue, 3 Jun 2014 00:19:11 -0700
Subject: [PATCH]     Add a super operation for writeback

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
and therefore set clean) or inode_writeback_touch(inode)
for any inode that will be retained dirty in cache.

Signed-off-by: Daniel Phillips <daniel@tux3.org>
---
 fs/fs-writeback.c         | 107 +++++++++++++++++++++++++++++-----------------
 include/linux/fs.h        |   9 +++-
 include/linux/writeback.h |  19 ++++++++
 3 files changed, 95 insertions(+), 40 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index be568b7..98810bd 100644
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
@@ -192,6 +173,35 @@ void inode_wb_list_del(struct inode *inode)
 }
 
 /*
+ * Remove inode from writeback list if clean.
+ */
+void inode_writeback_done(struct inode *inode)
+{
+    struct backing_dev_info *bdi = inode_to_bdi(inode);
+
+    spin_lock(&bdi->wb.list_lock);
+    spin_lock(&inode->i_lock);
+    if (!(inode->i_state & I_DIRTY))
+        list_del_init(&inode->i_wb_list);
+    spin_unlock(&inode->i_lock);
+    spin_unlock(&bdi->wb.list_lock);
+}
+EXPORT_SYMBOL_GPL(inode_writeback_done);
+
+/*
+ * Add inode to writeback dirty list with current time.
+ */
+void inode_writeback_touch(struct inode *inode)
+{
+    struct backing_dev_info *bdi = inode->i_sb->s_bdi;
+    spin_lock(&bdi->wb.list_lock);
+    inode->dirtied_when = jiffies;
+    list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
+    spin_unlock(&bdi->wb.list_lock);
+}
+EXPORT_SYMBOL_GPL(inode_writeback_touch);
+
+/*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
  *
@@ -593,20 +603,12 @@ static long writeback_chunk_size(struct backing_dev_info *bdi,
  *
  * Return the number of pages and/or inodes written.
  */
-static long writeback_sb_inodes(struct super_block *sb,
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
@@ -644,7 +646,7 @@ static long writeback_sb_inodes(struct super_block *sb,
             redirty_tail(inode, wb);
             continue;
         }
-        if ((inode->i_state & I_SYNC) && wbc.sync_mode != WB_SYNC_ALL) {
+        if ((inode->i_state & I_SYNC) && wbc->sync_mode != WB_SYNC_ALL) {
             /*
              * If this inode is locked for writeback and we are not
              * doing writeback-for-data-integrity, move it to
@@ -677,22 +679,22 @@ static long writeback_sb_inodes(struct super_block *sb,
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
@@ -710,6 +712,33 @@ static long writeback_sb_inodes(struct super_block *sb,
     return wrote;
 }
 
+static long writeback_sb_inodes(
+    struct super_block *sb,
+    struct bdi_writeback *wb,
+    struct wb_writeback_work *work)
+{
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
+
+    if (sb->s_op->writeback) {
+        long ret;
+        spin_unlock(&wb->list_lock);
+        ret = sb->s_op->writeback(sb, wb, work, &wbc);
+        spin_lock(&wb->list_lock);
+        return ret;
+    }
+
+    return generic_writeback_sb_inodes(sb, wb, work, &wbc);
+}
+
 static long __writeback_inodes_wb(struct bdi_writeback *wb,
                   struct wb_writeback_work *work)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8780312..fc07d33 100644
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
@@ -1542,7 +1544,10 @@ struct super_operations {
     int (*statfs) (struct dentry *, struct kstatfs *);
     int (*remount_fs) (struct super_block *, int *, char *);
     void (*umount_begin) (struct super_block *);
-
+    long (*writeback)(struct super_block *sb,
+                struct bdi_writeback *wb,
+                struct wb_writeback_work *work,
+                struct writeback_control *wbc);
     int (*show_options)(struct seq_file *, struct dentry *);
     int (*show_devname)(struct seq_file *, struct dentry *);
     int (*show_path)(struct seq_file *, struct dentry *);
@@ -1739,6 +1744,8 @@ static inline void file_accessed(struct file *file)
 
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
 int sync_inode_metadata(struct inode *inode, int wait);
+void inode_writeback_done(struct inode *inode);
+void inode_writeback_touch(struct inode *inode);
 
 struct file_system_type {
     const char *name;
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

