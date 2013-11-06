Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3KFNsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:48:37 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60796 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3KFNse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:34 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v6 07/11] VFS hot tracking: Add a /proc interface to control memory usage
Date: Wed,  6 Nov 2013 21:45:40 +0800
Message-Id: <1383745544-391-8-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-1542-0000-0000-000002F825C3
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
 fs/hot_tracking.c            | 29 +++++++++++++++++++++++++++++
 fs/hot_tracking.h            | 23 +++++++++++++++++++++++
 include/linux/hot_tracking.h |  3 +++
 kernel/sysctl.c              |  7 +++++++
 4 files changed, 62 insertions(+)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 7a9bd4f..2c5a7fd 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include "hot_tracking.h"
 
+int sysctl_hot_mem_high_thresh __read_mostly = 0;
 int sysctl_hot_update_interval __read_mostly = 150;
 
 /* kmem_cache pointers for slab caches */
@@ -32,6 +33,7 @@ static void hot_range_item_init(struct hot_range_item *hr,
 	hr->len = 1 << RANGE_BITS;
 	hr->hot_inode = he;
 	atomic_long_inc(&he->hot_root->hot_cnt);
+	hot_mem_limit_add(he->hot_root, sizeof(struct hot_range_item));
 }
 
 static void hot_range_item_free_cb(struct rcu_head *head)
@@ -55,6 +57,7 @@ static void hot_range_item_free(struct kref *kref)
 	spin_unlock(&root->m_lock);
 
 	atomic_long_dec(&root->hot_cnt);
+	hot_mem_limit_sub(root, sizeof(struct hot_range_item));
 	call_rcu(&hr->rcu, hot_range_item_free_cb);
 }
 
@@ -103,6 +106,8 @@ redo:
 				 * newly allocated item.
 				 */
 				atomic_long_dec(&he->hot_root->hot_cnt);
+				hot_mem_limit_sub(he->hot_root,
+						sizeof(struct hot_range_item));
 				kmem_cache_free(hot_range_item_cachep, hr_new);
 			}
 			spin_unlock(&he->i_lock);
@@ -205,6 +210,7 @@ static void hot_inode_item_init(struct hot_inode_item *he,
 	he->hot_root = root;
 	spin_lock_init(&he->i_lock);
 	atomic_long_inc(&root->hot_cnt);
+	hot_mem_limit_add(root, sizeof(struct hot_inode_item));
 }
 
 static void hot_inode_item_free_cb(struct rcu_head *head)
@@ -226,6 +232,7 @@ static void hot_inode_item_free(struct kref *kref)
 	hot_range_tree_free(he);
 
 	atomic_long_dec(&he->hot_root->hot_cnt);
+	hot_mem_limit_sub(he->hot_root, sizeof(struct hot_inode_item));
 	call_rcu(&he->rcu, hot_inode_item_free_cb);
 }
 
@@ -272,6 +279,8 @@ redo:
 				 * newly allocated item.
 				 */
 				atomic_long_dec(&root->hot_cnt);
+				hot_mem_limit_sub(root,
+						sizeof(struct hot_inode_item));
 				kmem_cache_free(hot_inode_item_cachep, he_new);
 			}
 			spin_unlock(&root->t_lock);
@@ -534,6 +543,23 @@ static unsigned long hot_item_evict(struct hot_info *root, unsigned long work,
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
@@ -546,6 +572,8 @@ static void hot_update_worker(struct work_struct *work)
 	struct hot_inode_item *he;
 	struct rb_node *node;
 
+	hot_mem_evict(root);
+
 	rcu_read_lock();
 	node = root->hot_inode_tree.rb_node;
 	while (node) {
@@ -753,6 +781,7 @@ int hot_track_init(struct super_block *sb)
 		goto err;
 	}
 
+	hot_mem_limit_init(root);
 	sb->s_hot_root = root;
 	sb->s_flags |= MS_HOTTRACK;
 
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 6a6971e..4ee0b90 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -46,4 +46,27 @@ struct hot_inode_item *hot_inode_item_lookup(struct hot_info *root, u64 ino);
 void hot_inode_item_unlink(struct inode *inode);
 u32 hot_temp_calc(struct hot_freq *freq);
 
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
index 43df1b9..5c2c247 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -83,10 +83,13 @@ struct hot_info {
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

