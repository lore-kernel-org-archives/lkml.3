Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3KFNsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:48:19 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39504 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab3KFNsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:16 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v6 02/11] VFS hot tracking: Track IO and record heat information
Date: Wed,  6 Nov 2013 21:45:35 +0800
Message-Id: <1383745544-391-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-3532-0000-0000-000002C95774
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
 fs/hot_tracking.c            | 259 +++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |   3 +
 fs/namei.c                   |   4 +
 include/linux/hot_tracking.h |  19 ++++
 mm/filemap.c                 |  24 +++-
 mm/readahead.c               |   6 +
 6 files changed, 313 insertions(+), 2 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 25e7858..d68c458 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -22,6 +22,8 @@ static void hot_range_item_init(struct hot_range_item *hr,
 			struct hot_inode_item *he, loff_t start)
 {
 	kref_init(&hr->refs);
+	hr->freq.avg_delta_reads = (u64) -1;
+	hr->freq.avg_delta_writes = (u64) -1;
 	hr->start = start;
 	hr->len = 1 << RANGE_BITS;
 	hr->hot_inode = he;
@@ -59,6 +61,62 @@ static void hot_range_item_put(struct hot_range_item *hr)
         kref_put(&hr->refs, hot_range_item_free);
 }
 
+static struct hot_range_item
+*hot_range_item_alloc(struct hot_inode_item *he, loff_t start)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct hot_range_item *hr, *hr_new = NULL;
+
+	start = start << RANGE_BITS;
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
+
 /*
  * Free the entire hot_range_tree.
  */
@@ -82,6 +140,8 @@ static void hot_inode_item_init(struct hot_inode_item *he,
 			struct hot_info *root, u64 ino)
 {
 	kref_init(&he->refs);
+	he->freq.avg_delta_reads = (u64) -1;
+	he->freq.avg_delta_writes = (u64) -1;
 	he->ino = ino;
 	he->hot_root = root;
 	spin_lock_init(&he->i_lock);
@@ -120,6 +180,153 @@ void hot_inode_item_put(struct hot_inode_item *he)
         kref_put(&he->refs, hot_inode_item_free);
 }
 
+static struct hot_inode_item
+*hot_inode_item_alloc(struct hot_info *root, u64 ino)
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
+
+struct hot_inode_item
+*hot_inode_item_lookup(struct hot_info *root, u64 ino)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct hot_inode_item *he;
+
+	/* walk tree to find insertion point */
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
+			spin_unlock(&root->t_lock);
+
+			return he;
+		}
+	}
+	spin_unlock(&root->t_lock);
+
+	return ERR_PTR(-ENOENT);
+}
+
+void hot_inode_item_unlink(struct inode *inode)
+{
+	struct hot_info *root = inode->i_sb->s_hot_root;
+	struct hot_inode_item *he;
+
+	if (!(inode->i_sb->s_flags & MS_HOTTRACK)
+		|| !S_ISREG(inode->i_mode))
+		return;
+
+	he = hot_inode_item_lookup(root, inode->i_ino);
+	if (IS_ERR(he))
+                return;
+
+	spin_lock(&root->t_lock);
+	hot_inode_item_put(he);
+	hot_inode_item_put(he); /* For the caller */
+	spin_unlock(&root->t_lock);
+}
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
@@ -136,6 +343,58 @@ void __init hot_cache_init(void)
 		kmem_cache_destroy(hot_inode_item_cachep);
 }
 
+/*
+ * Main function to update i/o access frequencies, and it will be called
+ * from read/writepages() hooks, which are read_pages(), do_writepages(),
+ * do_generic_file_read(), and __blockdev_direct_IO().
+ */
+inline void hot_freqs_update(struct inode *inode, loff_t start,
+			size_t len, int rw)
+{
+	struct hot_info *root = inode->i_sb->s_hot_root;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+	u64 range_size;
+	loff_t cur, end;
+
+	if (!(inode->i_sb->s_flags & MS_HOTTRACK) || (len == 0)
+		|| !S_ISREG(inode->i_mode) || !inode->i_nlink)
+		return;
+
+	he = hot_inode_item_alloc(root, inode->i_ino);
+	if (IS_ERR(he))
+		return;
+
+	hot_freq_update(root, &he->freq, rw);
+
+	/*
+	 * Align ranges on range size boundary
+	 * to prevent proliferation of range structs
+	 */
+	range_size  = 1 << RANGE_BITS;
+	end = (start + len + range_size - 1) >> RANGE_BITS;
+	cur = start >> RANGE_BITS;
+	for (; cur < end; cur++) {
+		hr = hot_range_item_alloc(he, cur);
+		if (IS_ERR(hr)) {
+			WARN(1, "hot_range_item_alloc returns %ld\n",
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
+EXPORT_SYMBOL(hot_freqs_update);
+
 static struct hot_info *hot_tree_init(struct super_block *sb)
 {
 	struct hot_info *root;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 51d829e..56ab13c 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -16,8 +16,11 @@
 
 /* size of sub-file ranges */
 #define RANGE_BITS 20
+#define FREQ_POWER 4
 
 void __init hot_cache_init(void);
 void hot_inode_item_put(struct hot_inode_item *he);
+struct hot_inode_item *hot_inode_item_lookup(struct hot_info *root, u64 ino);
+void hot_inode_item_unlink(struct inode *inode);
 
 #endif /* __HOT_TRACKING__ */
diff --git a/fs/namei.c b/fs/namei.c
index caa2805..e50af1e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -38,6 +38,7 @@
 
 #include "internal.h"
 #include "mount.h"
+#include "hot_tracking.h"
 
 /* [Feb-1997 T. Schoebel-Theuer]
  * Fundamental changes in the pathname lookup mechanisms (namei)
@@ -3668,6 +3669,9 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry)
 				dont_mount(dentry);
 		}
 	}
+
+	if (!error && !dentry->d_inode->i_nlink)
+		hot_inode_item_unlink(dentry->d_inode);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
 	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 91633db..5f02025 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -31,8 +31,24 @@ enum {
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
@@ -47,6 +63,7 @@ struct hot_inode_item {
  * an inode whose frequency is being tracked
  */
 struct hot_range_item {
+	struct hot_freq freq;                   /* frequency data */
 	struct kref refs;
 	struct rb_node rb_node;                 /* rbtree index */
 	struct rcu_head rcu;
@@ -62,5 +79,7 @@ struct hot_info {
 
 extern int hot_track_init(struct super_block *sb);
 extern void hot_track_exit(struct super_block *sb);
+extern void hot_freqs_update(struct inode *inode, loff_t start,
+			size_t len, int rw);
 
 #endif  /* _LINUX_HOTTRACK_H */
diff --git a/mm/filemap.c b/mm/filemap.c
index ae4846f..d70939d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
+#include <linux/hot_tracking.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -1196,6 +1197,10 @@ page_ok:
 			mark_page_accessed(page);
 		prev_index = index;
 
+		/* Hot tracking */
+		hot_freqs_update(inode, page->index << PAGE_CACHE_SHIFT,
+				PAGE_CACHE_SIZE, 0);
+
 		/*
 		 * Ok, we have the page, and it's up-to-date, so
 		 * now we can copy it to user space...
@@ -1514,9 +1519,13 @@ static int page_cache_read(struct file *file, pgoff_t offset)
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
@@ -1711,6 +1720,11 @@ page_not_uptodate:
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
@@ -2249,6 +2263,9 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	}
 
 	if (written > 0) {
+		/* Hot tracking */
+		hot_freqs_update(inode, pos, written, 1);
+
 		pos += written;
 		if (pos > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
 			i_size_write(inode, pos);
@@ -2404,6 +2421,9 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 	status = generic_perform_write(file, &i, pos);
 
 	if (likely(status >= 0)) {
+		/* Hot tracking */
+		hot_freqs_update(file_inode(file), pos, status, 1);
+
 		written += status;
 		*ppos = pos + status;
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

