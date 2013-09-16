Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3IPWU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:20:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49542 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3IPWUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:20:52 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v5 07/10] VFS hot tracking: Add a /proc interface to control memory usage
Date: Tue, 17 Sep 2013 06:17:52 +0800
Message-Id: <1379369875-5123-8-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
References: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091622-9332-0000-0000-0000016FFDE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Introduce a /proc interface hot-mem-high-thresh and
to cap the memory which is consumed by hot_inode_item
and hot_range_item, and they will be in the unit of
1M bytes.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 31 +++++++++++++++++++++++++++++++
 fs/hot_tracking.h            | 23 +++++++++++++++++++++++
 include/linux/hot_tracking.h |  3 +++
 kernel/sysctl.c              |  7 +++++++
 4 files changed, 64 insertions(+)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 8c7e403..0047252 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -15,6 +15,9 @@
 #include <linux/sched.h>
 #include "hot_tracking.h"
 
+int sysctl_hot_mem_high_thresh __read_mostly = 0;
+EXPORT_SYMBOL_GPL(sysctl_hot_mem_high_thresh);
+
 int sysctl_hot_update_interval __read_mostly = 150;
 EXPORT_SYMBOL_GPL(sysctl_hot_update_interval);
 
@@ -33,6 +36,7 @@ static void hot_range_item_init(struct hot_range_item *hr,
 	hr->len = hot_bit_shift(1, RANGE_BITS, true);
 	hr->hot_inode = he;
 	atomic_long_inc(&he->hot_root->hot_cnt);
+	hot_mem_limit_add(he->hot_root, sizeof(struct hot_range_item));
 }
 
 static void hot_range_item_free_cb(struct rcu_head *head)
@@ -56,6 +60,7 @@ static void hot_range_item_free(struct kref *kref)
 	spin_unlock(&root->m_lock);
 
 	atomic_long_dec(&root->hot_cnt);
+	hot_mem_limit_sub(root, sizeof(struct hot_range_item));
 	call_rcu(&hr->rcu, hot_range_item_free_cb);
 }
 
@@ -106,6 +111,8 @@ redo:
 				 * newly allocated item.
 				 */
 				atomic_long_dec(&he->hot_root->hot_cnt);
+				hot_mem_limit_sub(he->hot_root,
+						sizeof(struct hot_range_item));
 				kmem_cache_free(hot_range_item_cachep, hr_new);
 			}
 			spin_unlock(&he->i_lock);
@@ -213,6 +220,7 @@ static void hot_inode_item_init(struct hot_inode_item *he,
 	he->hot_root = root;
 	spin_lock_init(&he->i_lock);
 	atomic_long_inc(&root->hot_cnt);
+	hot_mem_limit_add(root, sizeof(struct hot_inode_item));
 }
 
 static void hot_inode_item_free_cb(struct rcu_head *head)
@@ -234,6 +242,7 @@ static void hot_inode_item_free(struct kref *kref)
 	hot_range_tree_free(he);
 
 	atomic_long_dec(&he->hot_root->hot_cnt);
+	hot_mem_limit_sub(he->hot_root, sizeof(struct hot_inode_item));
 	call_rcu(&he->rcu, hot_inode_item_free_cb);
 }
 
@@ -282,6 +291,8 @@ redo:
 				 * newly allocated item.
 				 */
 				atomic_long_dec(&root->hot_cnt);
+				hot_mem_limit_sub(root,
+						sizeof(struct hot_inode_item));
 				kmem_cache_free(hot_inode_item_cachep, he_new);
 			}
 			spin_unlock(&root->t_lock);
@@ -528,6 +539,23 @@ static unsigned long hot_item_evict(struct hot_info *root, unsigned long work,
 	return freed;
 }
 
+static void hot_mem_evict(struct hot_info *root)
+{
+	unsigned long sum, thresh;
+
+	if (sysctl_hot_mem_high_thresh == 0) 
+		return;
+
+	sum = hot_mem_limit_sum(root);
+	/* Note: sysctl_** is in the unit of 1M bytes */
+	thresh = sysctl_hot_mem_high_thresh;
+	thresh *= 1024 * 1024;
+	if (sum <= thresh)
+		return;
+
+	hot_item_evict(root, sum - thresh, hot_mem_limit_sum);
+}
+
 /*
  * Every sync period we update temperatures for
  * each hot inode item and hot range item for aging
@@ -540,6 +568,8 @@ static void hot_update_worker(struct work_struct *work)
 	struct hot_inode_item *he;
 	struct rb_node *node;
 
+	hot_mem_evict(root);
+
 	rcu_read_lock();
 	node = root->hot_inode_tree.rb_node;
 	while (node) {
@@ -748,6 +778,7 @@ int hot_track_init(struct super_block *sb)
 		goto err;
 	}
 
+	hot_mem_limit_init(root);
 	sb->s_hot_root = root;
 
 	printk(KERN_INFO "VFS: Turning on hot tracking\n");
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 23b1339..c9efa5b 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -40,4 +40,27 @@
 #define AVW_DIVIDER_POWER 40 /* AVW - average delta between recent writes(ns) */
 #define AVW_COEFF_POWER 0
 
+/* Memory Tracking Functions. */
+static inline unsigned long hot_mem_limit_sum(struct hot_info *root)
+{
+	return atomic_long_read(&root->mem);
+}
+
+static inline void hot_mem_limit_sub(struct hot_info *root,
+				unsigned long count)
+{
+	atomic_long_sub(count, &root->mem);
+}
+
+static inline void hot_mem_limit_add(struct hot_info *root,
+				unsigned long count)
+{
+	atomic_long_add(count, &root->mem);
+}
+
+static inline void hot_mem_limit_init(struct hot_info *root)
+{
+	atomic_long_set(&root->mem, 0);
+}
+
 #endif /* __HOT_TRACKING__ */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 6923771..3f50c39 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -99,10 +99,13 @@ struct hot_info {
 	struct workqueue_struct *update_wq;
 	struct delayed_work update_work;
 	struct shrinker hot_shrink;
+	atomic_long_t mem;
 };
 
 /* set how often to update temperatures (seconds) */
 extern int sysctl_hot_update_interval;
+/* note: sysctl_** is in the unit of 1M bytes */
+extern int sysctl_hot_mem_high_thresh;
 
 /*
  * Hot data tracking ioctls:
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e0b062a..fde8bc2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1632,6 +1632,13 @@ static struct ctl_table fs_table[] = {
 		.extra1		= &pipe_min_size,
 	},
 	{
+		.procname       = "hot-mem-high-thresh",
+		.data           = &sysctl_hot_mem_high_thresh,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec,
+	},
+	{
 		.procname	= "hot-update-interval",
 		.data		= &sysctl_hot_update_interval,
 		.maxlen		= sizeof(int),
-- 
1.7.11.7

