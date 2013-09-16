Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3IPWWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:22:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58001 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3IPWUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:20:38 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v5 04/10] VFS hot tracking: Add shrinker functionality to curtail memory usage
Date: Tue, 17 Sep 2013 06:17:49 +0800
Message-Id: <1379369875-5123-5-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
References: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091622-0320-0000-0000-00000106425E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Register a shrinker to control the amount of memory that
is used in tracking hot regions. If we are throwing inodes
out of memory due to memory pressure, we most definitely are
going to need to reduce the amount of memory the tracking
code is using, even if it means losing useful information.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 91 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h |  2 +
 2 files changed, 93 insertions(+)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index cea88f2..953dbc9 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -29,6 +29,7 @@ static void hot_range_item_init(struct hot_range_item *hr,
 	hr->start = start;
 	hr->len = hot_bit_shift(1, RANGE_BITS, true);
 	hr->hot_inode = he;
+	atomic_long_inc(&he->hot_root->hot_cnt);
 }
 
 static void hot_range_item_free_cb(struct rcu_head *head)
@@ -51,6 +52,7 @@ static void hot_range_item_free(struct kref *kref)
 		list_del_init(&hr->track_list);
 	spin_unlock(&root->m_lock);
 
+	atomic_long_dec(&root->hot_cnt);
 	call_rcu(&hr->rcu, hot_range_item_free_cb);
 }
 
@@ -100,6 +102,7 @@ redo:
 				 * the item for the range. Free the
 				 * newly allocated item.
 				 */
+				atomic_long_dec(&he->hot_root->hot_cnt);
 				kmem_cache_free(hot_range_item_cachep, hr_new);
 			}
 			spin_unlock(&he->i_lock);
@@ -206,6 +209,7 @@ static void hot_inode_item_init(struct hot_inode_item *he,
 	he->ino = ino;
 	he->hot_root = root;
 	spin_lock_init(&he->i_lock);
+	atomic_long_inc(&root->hot_cnt);
 }
 
 static void hot_inode_item_free_cb(struct rcu_head *head)
@@ -226,6 +230,7 @@ static void hot_inode_item_free(struct kref *kref)
 		list_del_init(&he->track_list);
 	hot_range_tree_free(he);
 
+	atomic_long_dec(&he->hot_root->hot_cnt);
 	call_rcu(&he->rcu, hot_inode_item_free_cb);
 }
 
@@ -273,6 +278,7 @@ redo:
 				 * the item for the inode. Free the
 				 * newly allocated item.
 				 */
+				atomic_long_dec(&root->hot_cnt);
 				kmem_cache_free(hot_inode_item_cachep, he_new);
 			}
 			spin_unlock(&root->t_lock);
@@ -478,6 +484,47 @@ u32 hot_temp_calc(struct hot_freq *freq)
 	return result;
 }
 
+static unsigned long hot_item_evict(struct hot_info *root, unsigned long work,
+			unsigned long (*work_get)(struct hot_info *root))
+{
+	long budget = work;
+	unsigned long freed = 0;
+	int i;
+
+	for (i = 0; i < MAP_SIZE; i++) {
+		struct hot_inode_item *he, *next;
+
+		spin_lock(&root->t_lock);
+		if (list_empty(&root->hot_map[TYPE_INODE][i])) {
+			spin_unlock(&root->t_lock);
+			continue;
+		}
+
+		list_for_each_entry_safe(he, next,
+			&root->hot_map[TYPE_INODE][i], track_list) {
+			long work_prev, delta;
+
+			if (atomic_read(&he->refs.refcount) > 1)
+				continue;
+			work_prev = work_get(root);
+			hot_inode_item_put(he);
+			delta = work_prev - work_get(root);
+			budget -= delta;
+			freed += delta;
+			if (unlikely(budget <= 0))
+				break;
+		}
+		spin_unlock(&root->t_lock);
+
+		if (unlikely(budget <= 0))
+			break;
+
+		cond_resched();
+	}
+
+	return freed;
+}
+
 /*
  * Every sync period we update temperatures for
  * each hot inode item and hot range item for aging
@@ -522,6 +569,41 @@ void __init hot_cache_init(void)
 }
 EXPORT_SYMBOL_GPL(hot_cache_init);
 
+static unsigned long hot_track_shrink_count(struct shrinker *shrink,
+			struct shrink_control *sc)
+{
+	struct hot_info *root =
+		container_of(shrink, struct hot_info, hot_shrink);
+
+	return (unsigned long)atomic_long_read(&root->hot_cnt);
+}
+
+static inline unsigned long hot_cnt_get(struct hot_info *root)
+{
+	return (unsigned long)atomic_long_read(&root->hot_cnt);
+}
+
+static unsigned long hot_prune_map(struct hot_info *root, unsigned long nr)
+{
+	return hot_item_evict(root, nr, hot_cnt_get);
+}
+
+/* The shrinker callback function */
+static unsigned long hot_track_shrink_scan(struct shrinker *shrink,
+			struct shrink_control *sc)
+{
+	struct hot_info *root =
+		container_of(shrink, struct hot_info, hot_shrink);
+	unsigned long freed;
+
+	if (!(sc->gfp_mask & __GFP_FS))
+		return SHRINK_STOP;
+
+	freed =  hot_prune_map(root, sc->nr_to_scan);
+
+	return freed;
+}
+
 /*
  * Main function to update i/o access frequencies, and it will be called
  * from read/writepages() hooks, which are read_pages(), do_writepages(),
@@ -589,6 +671,7 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 	root->hot_inode_tree = RB_ROOT;
 	spin_lock_init(&root->t_lock);
 	spin_lock_init(&root->m_lock);
+	atomic_long_set(&root->hot_cnt, 0);
 
 	for (i = 0; i < MAP_SIZE; i++) {
 		for (j = 0; j < MAX_TYPES; j++)
@@ -609,6 +692,13 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 	queue_delayed_work(root->update_wq, &root->update_work,
 		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
 
+	/* Register a shrinker callback */
+	root->hot_shrink.count_objects = hot_track_shrink_count;
+	root->hot_shrink.scan_objects = hot_track_shrink_scan;
+	root->hot_shrink.seeks = DEFAULT_SEEKS;
+	root->hot_shrink.flags = SHRINKER_NUMA_AWARE;
+	register_shrinker(&root->hot_shrink);
+
 	return root;
 }
 
@@ -620,6 +710,7 @@ static void hot_tree_exit(struct hot_info *root)
 	struct hot_inode_item *he;
 	struct rb_node *node;
 
+	unregister_shrinker(&root->hot_shrink);
 	cancel_delayed_work_sync(&root->update_work);
 	destroy_workqueue(root->update_wq);
 
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index f5fb1ce..455bfe8 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -82,8 +82,10 @@ struct hot_info {
 	struct list_head hot_map[MAX_TYPES][MAP_SIZE];	/* map of inode temp */
 	spinlock_t t_lock;		/* protect tree and map for inode item */
 	spinlock_t m_lock;		/* protect map for range item */
+	atomic_long_t hot_cnt;
 	struct workqueue_struct *update_wq;
 	struct delayed_work update_work;
+	struct shrinker hot_shrink;
 };
 
 extern void __init hot_cache_init(void);
-- 
1.7.11.7

