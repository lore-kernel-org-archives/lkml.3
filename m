Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab3KFNtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:49:14 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54764 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab3KFNsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:51 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v6 04/11] VFS hot tracking: Add shrinker functionality to curtail memory usage
Date: Wed,  6 Nov 2013 21:45:37 +0800
Message-Id: <1383745544-391-5-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-0320-0000-0000-000001A3EE63
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
index 35d3b83..ac0cdda 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -29,6 +29,7 @@ static void hot_range_item_init(struct hot_range_item *hr,
 	hr->start = start;
 	hr->len = 1 << RANGE_BITS;
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
 
@@ -98,6 +100,7 @@ redo:
 				 * the item for the range. Free the
 				 * newly allocated item.
 				 */
+				atomic_long_dec(&he->hot_root->hot_cnt);
 				kmem_cache_free(hot_range_item_cachep, hr_new);
 			}
 			spin_unlock(&he->i_lock);
@@ -199,6 +202,7 @@ static void hot_inode_item_init(struct hot_inode_item *he,
 	he->ino = ino;
 	he->hot_root = root;
 	spin_lock_init(&he->i_lock);
+	atomic_long_inc(&root->hot_cnt);
 }
 
 static void hot_inode_item_free_cb(struct rcu_head *head)
@@ -219,6 +223,7 @@ static void hot_inode_item_free(struct kref *kref)
 		list_del_init(&he->track_list);
 	hot_range_tree_free(he);
 
+	atomic_long_dec(&he->hot_root->hot_cnt);
 	call_rcu(&he->rcu, hot_inode_item_free_cb);
 }
 
@@ -264,6 +269,7 @@ redo:
 				 * the item for the inode. Free the
 				 * newly allocated item.
 				 */
+				atomic_long_dec(&root->hot_cnt);
 				kmem_cache_free(hot_inode_item_cachep, he_new);
 			}
 			spin_unlock(&root->t_lock);
@@ -485,6 +491,47 @@ u32 hot_temp_calc(struct hot_freq *freq)
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
@@ -528,6 +575,41 @@ void __init hot_cache_init(void)
 		kmem_cache_destroy(hot_inode_item_cachep);
 }
 
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
@@ -595,6 +677,7 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 	root->hot_inode_tree = RB_ROOT;
 	spin_lock_init(&root->t_lock);
 	spin_lock_init(&root->m_lock);
+	atomic_long_set(&root->hot_cnt, 0);
 
 	for (i = 0; i < MAP_SIZE; i++) {
 		for (j = 0; j < MAX_TYPES; j++)
@@ -615,6 +698,13 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
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
 
@@ -626,6 +716,7 @@ static void hot_tree_exit(struct hot_info *root)
 	struct hot_inode_item *he;
 	struct rb_node *node;
 
+	unregister_shrinker(&root->hot_shrink);
 	cancel_delayed_work_sync(&root->update_work);
 	destroy_workqueue(root->update_wq);
 
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 3f82610..67468a51 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -79,8 +79,10 @@ struct hot_info {
 	struct list_head hot_map[MAX_TYPES][MAP_SIZE];	/* map of inode temp */
 	spinlock_t t_lock;		/* protect tree and map for inode item */
 	spinlock_t m_lock;		/* protect map for range item */
+	atomic_long_t hot_cnt;
 	struct workqueue_struct *update_wq;
 	struct delayed_work update_work;
+	struct shrinker hot_shrink;
 };
 
 extern int hot_track_init(struct super_block *sb);
-- 
1.7.11.7

