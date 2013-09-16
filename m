Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3IPWW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:22:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50348 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab3IPWUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:20:32 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v5 02/10] VFS hot tracking: Track IO and record heat information
Date: Tue, 17 Sep 2013 06:17:47 +0800
Message-Id: <1379369875-5123-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
References: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091622-7182-0000-0000-0000086CD517
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

This patch adds read/write code paths: include read_pages(),
do_writepages(), do_generic_file_read() and __blockdev_direct_IO()
to record heat information.

When real disk i/o for an inode is done, its own hot_inode_item will
be created or updated in the RB tree for the filesystem, and the i/o freq for
all of its extents will also be created/updated in the RB-tree per inode.

Each of the two structures hot_inode_item and hot_range_item
contains a hot_freq_data struct with its frequency of access metrics
(number of {reads, writes}, last {read,write} time, frequency of
{reads,writes}).

Each hot_inode_item contains one hot_range_tree struct which is keyed by
{inode, offset, length} and used to keep track of all the ranges in this file.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/direct-io.c               |   5 +
 fs/hot_tracking.c            | 238 +++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |   1 +
 fs/namei.c                   |   3 +
 include/linux/hot_tracking.h |  26 +++++
 mm/filemap.c                 |  19 +++-
 mm/page-writeback.c          |  13 +++
 mm/readahead.c               |   6 ++
 8 files changed, 309 insertions(+), 2 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 0e04142..db59aa3 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -38,6 +38,7 @@
 #include <linux/atomic.h>
 #include <linux/prefetch.h>
 #include <linux/aio.h>
+#include "hot_tracking.h"
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
@@ -1376,6 +1377,10 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	prefetch(bdev->bd_queue);
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
+	/* Hot tracking */
+	hot_freqs_update(inode, offset,
+			iov_length(iov, nr_segs), rw & WRITE);
+
 	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
 				     nr_segs, get_block, end_io,
 				     submit_io, flags);
diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index bb82a8d..a6cf1a5 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -22,6 +22,8 @@ static void hot_range_item_init(struct hot_range_item *hr,
 			struct hot_inode_item *he, loff_t start)
 {
 	kref_init(&hr->refs);
+	hr->freq.avg_delta_reads = (u64) -1;
+	hr->freq.avg_delta_writes = (u64) -1;
 	hr->start = start;
 	hr->len = hot_bit_shift(1, RANGE_BITS, true);
 	hr->hot_inode = he;
@@ -61,6 +63,66 @@ void hot_range_item_put(struct hot_range_item *hr)
 }
 EXPORT_SYMBOL_GPL(hot_range_item_put);
 
+struct hot_range_item
+*hot_range_item_lookup(struct hot_inode_item *he, loff_t start, int alloc)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct hot_range_item *hr, *hr_new = NULL;
+
+	start = hot_bit_shift(start, RANGE_BITS, true);
+
+	/* walk tree to find insertion point */
+redo:
+	spin_lock(&he->i_lock);
+	p = &he->hot_range_tree.rb_node;
+	while (*p) {
+		parent = *p;
+		hr = rb_entry(parent, struct hot_range_item, rb_node);
+		if (start < hr->start)
+			p = &(*p)->rb_left;
+		else if (start > (hr->start + hr->len - 1))
+			p = &(*p)->rb_right;
+		else {
+			hot_range_item_get(hr);
+			if (hr_new) {
+				/*
+				 * Lost the race. Somebody else inserted
+				 * the item for the range. Free the
+				 * newly allocated item.
+				 */
+				kmem_cache_free(hot_range_item_cachep, hr_new);
+			}
+			spin_unlock(&he->i_lock);
+
+			return hr;
+		}
+	}
+
+	if (hr_new) {
+		rb_link_node(&hr_new->rb_node, parent, p);
+		rb_insert_color(&hr_new->rb_node, &he->hot_range_tree);
+		hot_range_item_get(hr_new); /* For the caller */
+		spin_unlock(&he->i_lock);
+		return hr_new;
+	}
+        spin_unlock(&he->i_lock);
+
+	if (!alloc)
+		return ERR_PTR(-ENOENT);
+
+	hr_new = kmem_cache_zalloc(hot_range_item_cachep, GFP_NOFS);
+	if (!hr_new)
+		return ERR_PTR(-ENOMEM);
+
+	hot_range_item_init(hr_new, he, start);
+
+	cond_resched();
+
+	goto redo;
+}
+EXPORT_SYMBOL_GPL(hot_range_item_lookup);
+
 /*
  * Free the entire hot_range_tree.
  */
@@ -84,6 +146,8 @@ static void hot_inode_item_init(struct hot_inode_item *he,
 			struct hot_info *root, u64 ino)
 {
 	kref_init(&he->refs);
+	he->freq.avg_delta_reads = (u64) -1;
+	he->freq.avg_delta_writes = (u64) -1;
 	he->ino = ino;
 	he->hot_root = root;
 	spin_lock_init(&he->i_lock);
@@ -124,6 +188,128 @@ void hot_inode_item_put(struct hot_inode_item *he)
 }
 EXPORT_SYMBOL_GPL(hot_inode_item_put);
 
+struct hot_inode_item
+*hot_inode_item_lookup(struct hot_info *root, u64 ino, int alloc)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct hot_inode_item *he, *he_new = NULL;
+
+	/* walk tree to find insertion point */
+redo:
+	spin_lock(&root->t_lock);
+	p = &root->hot_inode_tree.rb_node;
+	while (*p) {
+		parent = *p;
+		he = rb_entry(parent, struct hot_inode_item, rb_node);
+		if (ino < he->ino)
+			p = &(*p)->rb_left;
+		else if (ino > he->ino)
+			p = &(*p)->rb_right;
+		else {
+			hot_inode_item_get(he);
+			if (he_new) {
+				/*
+				 * Lost the race. Somebody else inserted
+				 * the item for the inode. Free the
+				 * newly allocated item.
+				 */
+				kmem_cache_free(hot_inode_item_cachep, he_new);
+			}
+			spin_unlock(&root->t_lock);
+
+			return he;
+		}
+	}
+
+	if (he_new) {
+		rb_link_node(&he_new->rb_node, parent, p);
+		rb_insert_color(&he_new->rb_node, &root->hot_inode_tree);
+		hot_inode_item_get(he_new); /* For the caller */
+		spin_unlock(&root->t_lock);
+		return he_new;
+	}
+	spin_unlock(&root->t_lock);
+
+	if (!alloc)
+		return ERR_PTR(-ENOENT);
+
+	he_new = kmem_cache_zalloc(hot_inode_item_cachep, GFP_NOFS);
+	if (!he_new)
+		return ERR_PTR(-ENOMEM);
+
+	hot_inode_item_init(he_new, root, ino);
+
+	cond_resched();
+
+	goto redo;
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_lookup);
+
+void hot_inode_item_unlink(struct inode *inode)
+{
+	struct hot_info *root = inode->i_sb->s_hot_root;
+	struct hot_inode_item *he;
+
+	if (!root || !S_ISREG(inode->i_mode))
+		return;
+
+	he = hot_inode_item_lookup(root, inode->i_ino, 0);
+	if (IS_ERR(he))
+                return;
+
+	spin_lock(&root->t_lock);
+	hot_inode_item_put(he);
+	hot_inode_item_put(he); /* For the caller */
+	spin_unlock(&root->t_lock);
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_unlink);
+
+/*
+ * This function does the actual work of updating
+ * the frequency numbers.
+ *
+ * avg_delta_{reads,writes} are indeed a kind of simple moving
+ * average of the time difference between each of the last
+ * 2^(FREQ_POWER) reads/writes. If there have not yet been that
+ * many reads or writes, it's likely that the values will be very
+ * large; They are initialized to the largest possible value for the
+ * data type. Simply, we don't want a few fast access to a file to
+ * automatically make it appear very hot.
+ */
+static void hot_freq_calc(struct timespec old_atime,
+		struct timespec cur_time, u64 *avg)
+{
+	struct timespec delta_ts;
+	u64 new_delta;
+
+	delta_ts = timespec_sub(cur_time, old_atime);
+	new_delta = timespec_to_ns(&delta_ts) >> FREQ_POWER;
+
+	*avg = (*avg << FREQ_POWER) - *avg + new_delta;
+	*avg = *avg >> FREQ_POWER;
+}
+
+static void hot_freq_update(struct hot_info *root,
+		struct hot_freq *freq, bool write)
+{
+	struct timespec cur_time = current_kernel_time();
+
+	if (write) {
+		freq->nr_writes += 1;
+		hot_freq_calc(freq->last_write_time,
+				cur_time,
+				&freq->avg_delta_writes);
+		freq->last_write_time = cur_time;
+	} else {
+		freq->nr_reads += 1;
+		hot_freq_calc(freq->last_read_time,
+				cur_time,
+				&freq->avg_delta_reads);
+		freq->last_read_time = cur_time;
+	}
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -141,6 +327,58 @@ void __init hot_cache_init(void)
 }
 EXPORT_SYMBOL_GPL(hot_cache_init);
 
+/*
+ * Main function to update i/o access frequencies, and it will be called
+ * from read/writepages() hooks, which are read_pages(), do_writepages(),
+ * do_generic_file_read(), and __blockdev_direct_IO().
+ */
+void hot_freqs_update(struct inode *inode, loff_t start,
+			size_t len, int rw)
+{
+	struct hot_info *root = inode->i_sb->s_hot_root;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+	u64 range_size;
+	loff_t cur, end;
+
+	if (!root || (len == 0) || !S_ISREG(inode->i_mode))
+		return;
+
+	he = hot_inode_item_lookup(root, inode->i_ino, 1);
+	if (IS_ERR(he))
+		return;
+
+	hot_freq_update(root, &he->freq, rw);
+
+	/*
+	 * Align ranges on range size boundary
+	 * to prevent proliferation of range structs
+	 */
+	range_size  = hot_bit_shift(1, RANGE_BITS, true);
+	end = hot_bit_shift((start + len + range_size - 1),
+			RANGE_BITS, false);
+	cur = hot_bit_shift(start, RANGE_BITS, false);
+	for (; cur < end; cur++) {
+		hr = hot_range_item_lookup(he, cur, 1);
+		if (IS_ERR(hr)) {
+			WARN(1, "hot_range_item_lookup returns %ld\n",
+				PTR_ERR(hr));
+			return;
+		}
+
+		hot_freq_update(root, &hr->freq, rw);
+
+		spin_lock(&he->i_lock);
+		hot_range_item_put(hr);
+		spin_unlock(&he->i_lock);
+	}
+
+	spin_lock(&root->t_lock);
+	hot_inode_item_put(he);
+	spin_unlock(&root->t_lock);
+}
+EXPORT_SYMBOL_GPL(hot_freqs_update);
+
 static struct hot_info *hot_tree_init(struct super_block *sb)
 {
 	struct hot_info *root;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 2776092..bb4cb16 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -16,5 +16,6 @@
 
 /* size of sub-file ranges */
 #define RANGE_BITS 20
+#define FREQ_POWER 4
 
 #endif /* __HOT_TRACKING__ */
diff --git a/fs/namei.c b/fs/namei.c
index 0dc4cbf..e6ec3c3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3659,6 +3659,9 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
+	if (!error && !dentry->d_inode->i_nlink)
+		hot_inode_item_unlink(dentry->d_inode);
+
 	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
 	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
 		fsnotify_link_count(dentry->d_inode);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 4112af2..f93db02 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -34,8 +34,24 @@ enum {
 	MAX_TYPES,
 };
 
+/*
+ * A frequency data struct holds values that are used to
+ * determine temperature of files and file ranges. These structs
+ * are members of hot_inode_item and hot_range_item
+ */
+struct hot_freq {
+	struct timespec last_read_time;
+	struct timespec last_write_time;
+	u32 nr_reads;
+	u32 nr_writes;
+	u64 avg_delta_reads;
+	u64 avg_delta_writes;
+	u32 last_temp;
+};
+
 /* An item representing an inode and its access frequency */
 struct hot_inode_item {
+	struct hot_freq freq;           /* frequency data */
 	struct kref refs;
 	struct rb_node rb_node;         /* rbtree index */
 	struct rcu_head rcu;
@@ -50,6 +66,7 @@ struct hot_inode_item {
  * an inode whose frequency is being tracked
  */
 struct hot_range_item {
+	struct hot_freq freq;                   /* frequency data */
 	struct kref refs;
 	struct rb_node rb_node;                 /* rbtree index */
 	struct rcu_head rcu;
@@ -70,6 +87,15 @@ extern void hot_range_item_put(struct hot_range_item *hr);
 extern void hot_inode_item_put(struct hot_inode_item *he);
 extern void hot_range_item_get(struct hot_range_item *hr);
 extern void hot_inode_item_get(struct hot_inode_item *he);
+extern struct hot_range_item
+*hot_range_item_lookup(struct hot_inode_item *he,
+			loff_t start, int alloc);
+extern struct hot_inode_item
+*hot_inode_item_lookup(struct hot_info *root,
+			u64 ino, int alloc);
+extern void hot_inode_item_unlink(struct inode *inode);
+extern void hot_freqs_update(struct inode *inode, loff_t start,
+			size_t len, int rw);
 
 static inline u64 hot_bit_shift(u64 counter, u32 bits, bool dir)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 1e6aec4..d1fed16 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
+#include <linux/hot_tracking.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -1244,6 +1245,11 @@ readpage:
 		 * PG_error will be set again if readpage fails.
 		 */
 		ClearPageError(page);
+
+		/* Hot tracking */
+		hot_freqs_update(inode, page->index << PAGE_CACHE_SHIFT,
+				PAGE_CACHE_SIZE, 0);
+
 		/* Start the actual read. The read will unlock the page. */
 		error = mapping->a_ops->readpage(filp, page);
 
@@ -1514,9 +1520,13 @@ static int page_cache_read(struct file *file, pgoff_t offset)
 			return -ENOMEM;
 
 		ret = add_to_page_cache_lru(page, mapping, offset, GFP_KERNEL);
-		if (ret == 0)
+		if (ret == 0) {
+			/* Hot tracking */
+			hot_freqs_update(mapping->host,
+					page->index << PAGE_CACHE_SHIFT,
+					PAGE_CACHE_SIZE, 0);
 			ret = mapping->a_ops->readpage(file, page);
-		else if (ret == -EEXIST)
+		} else if (ret == -EEXIST)
 			ret = 0; /* losing race to add is OK */
 
 		page_cache_release(page);
@@ -1720,6 +1730,11 @@ page_not_uptodate:
 	 * and we need to check for errors.
 	 */
 	ClearPageError(page);
+
+	/* Hot tracking */
+	hot_freqs_update(inode, page->index << PAGE_CACHE_SHIFT,
+			PAGE_CACHE_SIZE, 0);
+
 	error = mapping->a_ops->readpage(file, page);
 	if (!error) {
 		wait_on_page_locked(page);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index f5236f8..8d79af0 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -37,7 +37,9 @@
 #include <linux/timer.h>
 #include <linux/sched/rt.h>
 #include <linux/mm_inline.h>
+#include <linux/hot_tracking.h>
 #include <trace/events/writeback.h>
+#include <linux/hot_tracking.h>
 
 #include "internal.h"
 
@@ -2062,13 +2064,24 @@ EXPORT_SYMBOL(generic_writepages);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
+	loff_t start = 0;
+	size_t count = 0;
 
 	if (wbc->nr_to_write <= 0)
 		return 0;
+
+	start = mapping->writeback_index << PAGE_CACHE_SHIFT;
+	count = wbc->nr_to_write;
+
 	if (mapping->a_ops->writepages)
 		ret = mapping->a_ops->writepages(mapping, wbc);
 	else
 		ret = generic_writepages(mapping, wbc);
+
+	/* Hot tracking */
+	hot_freqs_update(mapping->host, start,
+			(count - wbc->nr_to_write) * PAGE_CACHE_SIZE, 1);
+
 	return ret;
 }
 
diff --git a/mm/readahead.c b/mm/readahead.c
index e4ed041..51f0e88 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -19,6 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
+#include <linux/hot_tracking.h>
 
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
@@ -115,6 +116,11 @@ static int read_pages(struct address_space *mapping, struct file *filp,
 	unsigned page_idx;
 	int ret;
 
+	/* Hot tracking */
+	hot_freqs_update(mapping->host,
+			list_to_page(pages)->index << PAGE_CACHE_SHIFT,
+			(size_t)nr_pages * PAGE_CACHE_SIZE, 0);
+
 	blk_start_plug(&plug);
 
 	if (mapping->a_ops->readpages) {
-- 
1.7.11.7

