Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3KFNvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:51:14 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:57757 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab3KFNsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:16 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v6 03/11] VFS hot tracking: Add a workqueue to move items between hot maps
Date: Wed,  6 Nov 2013 21:45:36 +0800
Message-Id: <1383745544-391-4-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-6688-0000-0000-00000337424C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Add a workqueue per superblock and a delayed_work
to run periodic work to update map info on each superblock.

Two arrays of map list are defined, one is for hot inode
items, and the other is for hot extent items.

The hot items in the RB-tree will be at first distilled
into one temperature in the range [0, 255]. It will be
be linked to its corresponding array of map list which use
the temperature as its index.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 208 +++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |  25 ++++++
 include/linux/hot_tracking.h |   8 +-
 3 files changed, 240 insertions(+), 1 deletion(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index d68c458..35d3b83 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -12,6 +12,7 @@
 #include <linux/list.h>
 #include <linux/err.h>
 #include <linux/spinlock.h>
+#include <linux/sched.h>
 #include "hot_tracking.h"
 
 /* kmem_cache pointers for slab caches */
@@ -22,6 +23,7 @@ static void hot_range_item_init(struct hot_range_item *hr,
 			struct hot_inode_item *he, loff_t start)
 {
 	kref_init(&hr->refs);
+	INIT_LIST_HEAD(&hr->track_list);
 	hr->freq.avg_delta_reads = (u64) -1;
 	hr->freq.avg_delta_writes = (u64) -1;
 	hr->start = start;
@@ -41,8 +43,13 @@ static void hot_range_item_free(struct kref *kref)
 {
 	struct hot_range_item *hr = container_of(kref,
 				struct hot_range_item, refs);
+	struct hot_info *root = hr->hot_inode->hot_root;
 
 	rb_erase(&hr->rb_node, &hr->hot_inode->hot_range_tree);
+	spin_lock(&root->m_lock);
+	if (!list_empty(&hr->track_list))
+		list_del_init(&hr->track_list);
+	spin_unlock(&root->m_lock);
 
 	call_rcu(&hr->rcu, hot_range_item_free_cb);
 }
@@ -67,6 +74,8 @@ static struct hot_range_item
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hot_range_item *hr, *hr_new = NULL;
+	u32 temp;
+	u8 temp_cur;
 
 	start = start << RANGE_BITS;
 
@@ -100,6 +109,12 @@ redo:
 	if (hr_new) {
 		rb_link_node(&hr_new->rb_node, parent, p);
 		rb_insert_color(&hr_new->rb_node, &he->hot_range_tree);
+		temp = hot_temp_calc(&hr_new->freq);
+		temp_cur = (u8)(temp >> (32 - MAP_BITS));
+		spin_lock(&he->hot_root->m_lock);
+		list_add_tail(&hr_new->track_list,
+			&he->hot_root->hot_map[TYPE_RANGE][temp_cur]);
+		spin_unlock(&he->hot_root->m_lock);
 		hot_range_item_get(hr_new); /* For the caller */
 		spin_unlock(&he->i_lock);
 		return hr_new;
@@ -136,10 +151,49 @@ static void hot_range_tree_free(struct hot_inode_item *he)
 	spin_unlock(&he->i_lock);
 }
 
+static void hot_range_map_update(struct hot_info *root,
+			struct hot_range_item *hr)
+{
+	u32 temp = hot_temp_calc(&hr->freq);
+	u8 temp_cur = (u8)(temp >> (32 - MAP_BITS));
+	u8 temp_prev = (u8)(hr->freq.last_temp >> (32 - MAP_BITS));
+
+	spin_lock(&root->m_lock);
+	if (!list_empty(&hr->track_list)
+		&& (temp_cur != temp_prev)) {
+		hr->freq.last_temp = temp;
+		list_del_init(&hr->track_list);
+		list_add_tail(&hr->track_list,
+			&root->hot_map[TYPE_RANGE][temp_cur]);
+	}
+	spin_unlock(&root->m_lock);
+}
+
+/*
+ * Update temperatures for each range item for aging purposes.
+ * If one hot range item is old, it will be aged out.
+ */
+static void hot_range_tree_update(struct hot_inode_item *he,
+				struct hot_info *root)
+{
+	struct rb_node *node;
+	struct hot_range_item *hr;
+
+	rcu_read_lock();
+	node = rb_first(&he->hot_range_tree);
+	while (node) {
+		hr = rb_entry(node, struct hot_range_item, rb_node);
+		node = rb_next(node);
+		hot_range_map_update(root, hr);
+	}
+	rcu_read_unlock();
+}
+
 static void hot_inode_item_init(struct hot_inode_item *he,
 			struct hot_info *root, u64 ino)
 {
 	kref_init(&he->refs);
+	INIT_LIST_HEAD(&he->track_list);
 	he->freq.avg_delta_reads = (u64) -1;
 	he->freq.avg_delta_writes = (u64) -1;
 	he->ino = ino;
@@ -161,6 +215,8 @@ static void hot_inode_item_free(struct kref *kref)
 				struct hot_inode_item, refs);
 
 	rb_erase(&he->rb_node, &he->hot_root->hot_inode_tree);
+	if (!list_empty(&he->track_list))
+		list_del_init(&he->track_list);
 	hot_range_tree_free(he);
 
 	call_rcu(&he->rcu, hot_inode_item_free_cb);
@@ -186,6 +242,8 @@ static struct hot_inode_item
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hot_inode_item *he, *he_new = NULL;
+	u32 temp;
+	u8 temp_cur;
 
 	/* walk tree to find insertion point */
 redo:
@@ -217,6 +275,10 @@ redo:
 	if (he_new) {
 		rb_link_node(&he_new->rb_node, parent, p);
 		rb_insert_color(&he_new->rb_node, &root->hot_inode_tree);
+		temp = hot_temp_calc(&he_new->freq);
+		temp_cur = (u8)(temp >> (32 - MAP_BITS));
+		list_add_tail(&he_new->track_list,
+			&root->hot_map[TYPE_INODE][temp_cur]);
 		hot_inode_item_get(he_new); /* For the caller */
 		spin_unlock(&root->t_lock);
 		return he_new;
@@ -283,6 +345,29 @@ void hot_inode_item_unlink(struct inode *inode)
 }
 
 /*
+ * Calculate a new temperature and, if necessary,
+ * move the list_head corresponding to this inode or range
+ * to the proper list with the new temperature.
+ */
+static void hot_inode_map_update(struct hot_info *root,
+			struct hot_inode_item *he)
+{
+	u32 temp = hot_temp_calc(&he->freq);
+	u8 temp_cur = (u8)(temp >> (32 - MAP_BITS));
+	u8 temp_prev = (u8)(he->freq.last_temp >> (32 - MAP_BITS));
+
+	spin_lock(&root->t_lock);
+	if (!list_empty(&he->track_list)
+		&& (temp_cur != temp_prev)) {
+		he->freq.last_temp = temp;
+		list_del_init(&he->track_list);
+		list_add_tail(&he->track_list,
+			&root->hot_map[TYPE_INODE][temp_cur]);
+	}
+	spin_unlock(&root->t_lock);
+}
+
+/*
  * This function does the actual work of updating
  * the frequency numbers.
  *
@@ -328,6 +413,106 @@ static void hot_freq_update(struct hot_info *root,
 }
 
 /*
+ * hot_temp_calc() is responsible for distilling the six heat
+ * criteria down into a single temperature value for the data,
+ * which is an integer between 0 and HEAT_MAX_VALUE.
+ *
+ * With the six values, we first do some very rudimentary
+ * "normalizations" to each metric such that they affect the
+ * final temperature calculation exactly the right way. It's
+ * important to note that we still weren't really sure that
+ * these six adjustments were exactly right.
+ * They could definitely use more tweaking and adjustment,
+ * especially in terms of the memory footprint they consume.
+ *
+ * Next, we take the adjusted values and shift them down to
+ * a manageable size, whereafter they are weighted using the
+ * the *_COEFF_POWER values and combined to a single temperature
+ * value.
+ */
+u32 hot_temp_calc(struct hot_freq *freq)
+{
+	u32 result = 0;
+
+	struct timespec ckt = current_kernel_time();
+	u64 cur_time = timespec_to_ns(&ckt);
+	u32 nrr_heat, nrw_heat;
+	u64 ltr_heat, ltw_heat, avr_heat, avw_heat;
+
+	nrr_heat = (u32)(freq->nr_reads << NRR_MULTIPLIER_POWER);
+	nrw_heat = (u32)(freq->nr_writes << NRW_MULTIPLIER_POWER);
+
+	ltr_heat = (cur_time - timespec_to_ns(&freq->last_read_time))
+			>> LTR_DIVIDER_POWER;
+	ltw_heat = (cur_time - timespec_to_ns(&freq->last_write_time))
+			>> LTW_DIVIDER_POWER;
+
+	avr_heat = (((u64) -1) - freq->avg_delta_reads)
+			>> AVR_DIVIDER_POWER;
+	avw_heat = (((u64) -1) - freq->avg_delta_writes)
+			>> AVW_DIVIDER_POWER;
+
+	/* ltr_heat is now guaranteed to be u32 safe */
+	if (ltr_heat >= ((u64)1 << 32))
+		ltr_heat = 0;
+	else
+		ltr_heat = ((u64)1 << 32) - ltr_heat;
+
+	/* ltw_heat is now guaranteed to be u32 safe */
+	if (ltw_heat >= ((u64)1 << 32))
+		ltw_heat = 0;
+	else
+		ltw_heat = ((u64)1 << 32) - ltw_heat;
+
+	/* avr_heat is now guaranteed to be u32 safe */
+	if (avr_heat >= ((u64)1 << 32))
+		avr_heat = (u32)-1;
+
+	/* avw_heat is now guaranteed to be u32 safe */
+	if (avw_heat >= ((u64)1 << 32))
+		avw_heat = (u32)-1;
+
+	nrr_heat = (u32)((u64)nrr_heat >> (3 - NRR_COEFF_POWER));
+	nrw_heat = (u32)((u64)nrw_heat >> (3 - NRW_COEFF_POWER));
+	ltr_heat = (ltr_heat >> (3 - LTR_COEFF_POWER));
+	ltw_heat = (ltw_heat >> (3 - LTW_COEFF_POWER));
+	avr_heat = (avr_heat >> (3 - AVR_COEFF_POWER));
+	avw_heat = (avw_heat >> (3 - AVW_COEFF_POWER));
+
+	result = nrr_heat + nrw_heat + (u32) ltr_heat +
+		(u32) ltw_heat + (u32) avr_heat + (u32) avw_heat;
+
+	return result;
+}
+
+/*
+ * Every sync period we update temperatures for
+ * each hot inode item and hot range item for aging
+ * purposes.
+ */
+static void hot_update_worker(struct work_struct *work)
+{
+	struct hot_info *root = container_of(to_delayed_work(work),
+					struct hot_info, update_work);
+	struct hot_inode_item *he;
+	struct rb_node *node;
+
+	rcu_read_lock();
+	node = root->hot_inode_tree.rb_node;
+	while (node) {
+		he = rb_entry(node, struct hot_inode_item, rb_node);
+		node = rb_next(node);
+		hot_inode_map_update(root, he);
+		hot_range_tree_update(he, root);
+	}
+	rcu_read_unlock();
+
+	/* Instert next delayed work */
+	queue_delayed_work(root->update_wq, &root->update_work,
+		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
+}
+
+/*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
 void __init hot_cache_init(void)
@@ -409,6 +594,26 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 
 	root->hot_inode_tree = RB_ROOT;
 	spin_lock_init(&root->t_lock);
+	spin_lock_init(&root->m_lock);
+
+	for (i = 0; i < MAP_SIZE; i++) {
+		for (j = 0; j < MAX_TYPES; j++)
+			INIT_LIST_HEAD(&root->hot_map[j][i]);
+	}
+
+	root->update_wq = alloc_workqueue(
+			"hot_update_wq", WQ_NON_REENTRANT, 0);
+	if (!root->update_wq) {
+		printk(KERN_ERR "%s: Failed to create "
+				"hot update workqueue\n", __func__);
+		kfree(root);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* Initialize hot tracking wq and arm one delayed work */
+	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
+	queue_delayed_work(root->update_wq, &root->update_work,
+		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
 
 	return root;
 }
@@ -421,6 +626,9 @@ static void hot_tree_exit(struct hot_info *root)
 	struct hot_inode_item *he;
 	struct rb_node *node;
 
+	cancel_delayed_work_sync(&root->update_work);
+	destroy_workqueue(root->update_wq);
+
 	spin_lock(&root->t_lock);
 	node = rb_first(&root->hot_inode_tree);
 	while (node) {
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 56ab13c..4a89fdb 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -12,15 +12,40 @@
 #ifndef __HOT_TRACKING__
 #define __HOT_TRACKING__
 
+#include <linux/workqueue.h>
 #include <linux/hot_tracking.h>
 
+#define HOT_UPDATE_INTERVAL 150
+
 /* size of sub-file ranges */
 #define RANGE_BITS 20
 #define FREQ_POWER 4
 
+/* NRR/NRW heat unit = 2^X accesses */
+#define NRR_MULTIPLIER_POWER 20 /* NRR - number of reads since mount */
+#define NRR_COEFF_POWER 0
+#define NRW_MULTIPLIER_POWER 20 /* NRW - number of writes since mount */
+#define NRW_COEFF_POWER 0
+
+/* LTR/LTW heat unit = 2^X ns of age */
+#define LTR_DIVIDER_POWER 30 /* LTR - time elapsed since last read(ns) */
+#define LTR_COEFF_POWER 1
+#define LTW_DIVIDER_POWER 30 /* LTW - time elapsed since last write(ns) */
+#define LTW_COEFF_POWER 1
+
+/*
+ * AVR/AVW cold unit = 2^X ns of average delta
+ * AVR/AVW heat unit = HEAT_MAX_VALUE - cold unit
+ */
+#define AVR_DIVIDER_POWER 40 /* AVR - average delta between recent reads(ns) */
+#define AVR_COEFF_POWER 0
+#define AVW_DIVIDER_POWER 40 /* AVW - average delta between recent writes(ns) */
+#define AVW_COEFF_POWER 0
+
 void __init hot_cache_init(void);
 void hot_inode_item_put(struct hot_inode_item *he);
 struct hot_inode_item *hot_inode_item_lookup(struct hot_info *root, u64 ino);
 void hot_inode_item_unlink(struct inode *inode);
+u32 hot_temp_calc(struct hot_freq *freq);
 
 #endif /* __HOT_TRACKING__ */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 5f02025..3f82610 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -52,6 +52,7 @@ struct hot_inode_item {
 	struct kref refs;
 	struct rb_node rb_node;         /* rbtree index */
 	struct rcu_head rcu;
+	struct list_head track_list;    /* link to *_map[] */
 	struct rb_root hot_range_tree;	/* tree of ranges */
 	spinlock_t i_lock;		/* protect above tree */
 	struct hot_info *hot_root;	/* associated hot_info */
@@ -67,6 +68,7 @@ struct hot_range_item {
 	struct kref refs;
 	struct rb_node rb_node;                 /* rbtree index */
 	struct rcu_head rcu;
+	struct list_head track_list;            /* link to *_map[] */
 	struct hot_inode_item *hot_inode;	/* associated hot_inode_item */
 	loff_t start;				/* offset in bytes */
 	size_t len;				/* length in bytes */
@@ -74,7 +76,11 @@ struct hot_range_item {
 
 struct hot_info {
 	struct rb_root hot_inode_tree;
-	spinlock_t t_lock;				/* protect above tree */
+	struct list_head hot_map[MAX_TYPES][MAP_SIZE];	/* map of inode temp */
+	spinlock_t t_lock;		/* protect tree and map for inode item */
+	spinlock_t m_lock;		/* protect map for range item */
+	struct workqueue_struct *update_wq;
+	struct delayed_work update_work;
 };
 
 extern int hot_track_init(struct super_block *sb);
-- 
1.7.11.7

