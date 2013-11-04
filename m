Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3KDLt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:49:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3KDLtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:49:11 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 19/19] GFS2: Use generic list_lru for quota
Date: Mon,  4 Nov 2013 11:22:30 +0000
Message-Id: <1383564150-8975-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383564150-8975-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
 <1383564150-8975-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using the generic list_lru code, we can now separate the
per sb quota list locking from the lru locking. The lru
lock is made into the inner-most lock.

As a result of this new lock order, we may occasionally see
items on the per-sb quota list which are "dead" so that the
two places where we traverse that list are updated to take
account of that.

As a result of this patch, the gfs2 quota shrinker is now
NUMA zone aware, and we are also laying the foundations for
further improvments in due course.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Abhijith Das <adas@redhat.com>
Tested-by: Abhijith Das <adas@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 9d77804..ba1ea67 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -420,11 +420,10 @@ enum {
 
 struct gfs2_quota_data {
 	struct list_head qd_list;
-	struct list_head qd_reclaim;
-
+	struct kqid qd_id;
 	struct lockref qd_lockref;
+	struct list_head qd_lru;
 
-	struct kqid qd_id;
 	unsigned long qd_flags;		/* QDF_... */
 
 	s64 qd_change;
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 351586e..0650db2 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -31,12 +31,6 @@
 
 struct workqueue_struct *gfs2_control_wq;
 
-static struct shrinker qd_shrinker = {
-	.count_objects = gfs2_qd_shrink_count,
-	.scan_objects = gfs2_qd_shrink_scan,
-	.seeks = DEFAULT_SEEKS,
-};
-
 static void gfs2_init_inode_once(void *foo)
 {
 	struct gfs2_inode *ip = foo;
@@ -87,6 +81,10 @@ static int __init init_gfs2_fs(void)
 	if (error)
 		return error;
 
+	error = list_lru_init(&gfs2_qd_lru);
+	if (error)
+		goto fail_lru;
+
 	error = gfs2_glock_init();
 	if (error)
 		goto fail;
@@ -139,7 +137,7 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_rsrv_cachep)
 		goto fail;
 
-	register_shrinker(&qd_shrinker);
+	register_shrinker(&gfs2_qd_shrinker);
 
 	error = register_filesystem(&gfs2_fs_type);
 	if (error)
@@ -179,7 +177,9 @@ fail_wq:
 fail_unregister:
 	unregister_filesystem(&gfs2_fs_type);
 fail:
-	unregister_shrinker(&qd_shrinker);
+	list_lru_destroy(&gfs2_qd_lru);
+fail_lru:
+	unregister_shrinker(&gfs2_qd_shrinker);
 	gfs2_glock_exit();
 
 	if (gfs2_rsrv_cachep)
@@ -214,13 +214,14 @@ fail:
 
 static void __exit exit_gfs2_fs(void)
 {
-	unregister_shrinker(&qd_shrinker);
+	unregister_shrinker(&gfs2_qd_shrinker);
 	gfs2_glock_exit();
 	gfs2_unregister_debugfs();
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
 	destroy_workqueue(gfs_recovery_wq);
 	destroy_workqueue(gfs2_control_wq);
+	list_lru_destroy(&gfs2_qd_lru);
 
 	rcu_barrier();
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 466516a..453b50e 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -51,6 +51,7 @@
 #include <linux/quota.h>
 #include <linux/dqblk_xfs.h>
 #include <linux/lockref.h>
+#include <linux/list_lru.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -72,29 +73,25 @@ struct gfs2_quota_change_host {
 	struct kqid qc_id;
 };
 
-static LIST_HEAD(qd_lru_list);
-static atomic_t qd_lru_count = ATOMIC_INIT(0);
+/* Lock order: qd_lock -> qd->lockref.lock -> lru lock */
 static DEFINE_SPINLOCK(qd_lock);
+struct list_lru gfs2_qd_lru;
 
-unsigned long gfs2_qd_shrink_scan(struct shrinker *shrink,
-				  struct shrink_control *sc)
+static void gfs2_qd_dispose(struct list_head *list)
 {
 	struct gfs2_quota_data *qd;
 	struct gfs2_sbd *sdp;
-	int nr_to_scan = sc->nr_to_scan;
-	long freed = 0;
 
-	if (!(sc->gfp_mask & __GFP_FS))
-		return SHRINK_STOP;
-
-	spin_lock(&qd_lock);
-	while (nr_to_scan && !list_empty(&qd_lru_list)) {
-		qd = list_entry(qd_lru_list.next,
-				struct gfs2_quota_data, qd_reclaim);
+	while (!list_empty(list)) {
+		qd = list_entry(list->next, struct gfs2_quota_data, qd_lru);
 		sdp = qd->qd_gl->gl_sbd;
 
+		list_del(&qd->qd_lru);
+
 		/* Free from the filesystem-specific list */
+		spin_lock(&qd_lock);
 		list_del(&qd->qd_list);
+		spin_unlock(&qd_lock);
 
 		gfs2_assert_warn(sdp, !qd->qd_change);
 		gfs2_assert_warn(sdp, !qd->qd_slot_count);
@@ -104,24 +101,59 @@ unsigned long gfs2_qd_shrink_scan(struct shrinker *shrink,
 		atomic_dec(&sdp->sd_quota_count);
 
 		/* Delete it from the common reclaim list */
-		list_del_init(&qd->qd_reclaim);
-		atomic_dec(&qd_lru_count);
-		spin_unlock(&qd_lock);
 		kmem_cache_free(gfs2_quotad_cachep, qd);
-		spin_lock(&qd_lock);
-		nr_to_scan--;
-		freed++;
 	}
-	spin_unlock(&qd_lock);
+}
+
+
+static enum lru_status gfs2_qd_isolate(struct list_head *item, spinlock_t *lock, void *arg)
+{
+	struct list_head *dispose = arg;
+	struct gfs2_quota_data *qd = list_entry(item, struct gfs2_quota_data, qd_lru);
+
+	if (!spin_trylock(&qd->qd_lockref.lock))
+		return LRU_SKIP;
+
+	if (qd->qd_lockref.count == 0) {
+		lockref_mark_dead(&qd->qd_lockref);
+		list_move(&qd->qd_lru, dispose);
+	}
+
+	spin_unlock(&qd->qd_lockref.lock);
+	return LRU_REMOVED;
+}
+
+static unsigned long gfs2_qd_shrink_scan(struct shrinker *shrink,
+					 struct shrink_control *sc)
+{
+	LIST_HEAD(dispose);
+	unsigned long freed;
+
+	if (!(sc->gfp_mask & __GFP_FS))
+		return SHRINK_STOP;
+
+	freed = list_lru_walk_node(&gfs2_qd_lru, sc->nid, gfs2_qd_isolate,
+				   &dispose, &sc->nr_to_scan);
+
+	gfs2_qd_dispose(&dispose);
+
 	return freed;
 }
 
-unsigned long gfs2_qd_shrink_count(struct shrinker *shrink,
-				   struct shrink_control *sc)
+static unsigned long gfs2_qd_shrink_count(struct shrinker *shrink,
+					  struct shrink_control *sc)
 {
-	return vfs_pressure_ratio(atomic_read(&qd_lru_count));
+	return vfs_pressure_ratio(list_lru_count_node(&gfs2_qd_lru, sc->nid));
 }
 
+struct shrinker gfs2_qd_shrinker = {
+	.count_objects = gfs2_qd_shrink_count,
+	.scan_objects = gfs2_qd_shrink_scan,
+	.seeks = DEFAULT_SEEKS,
+	.flags = SHRINKER_NUMA_AWARE,
+};
+
+
 static u64 qd2index(struct gfs2_quota_data *qd)
 {
 	struct kqid qid = qd->qd_id;
@@ -153,7 +185,7 @@ static int qd_alloc(struct gfs2_sbd *sdp, struct kqid qid,
 	spin_lock_init(&qd->qd_lockref.lock);
 	qd->qd_id = qid;
 	qd->qd_slot = -1;
-	INIT_LIST_HEAD(&qd->qd_reclaim);
+	INIT_LIST_HEAD(&qd->qd_lru);
 
 	error = gfs2_glock_get(sdp, qd2index(qd),
 			      &gfs2_quota_glops, CREATE, &qd->qd_gl);
@@ -181,13 +213,9 @@ static int qd_get(struct gfs2_sbd *sdp, struct kqid qid,
 		found = 0;
 		spin_lock(&qd_lock);
 		list_for_each_entry(qd, &sdp->sd_quota_list, qd_list) {
-			if (qid_eq(qd->qd_id, qid)) {
-				lockref_get(&qd->qd_lockref);
-				if (!list_empty(&qd->qd_reclaim)) {
-					/* Remove it from reclaim list */
-					list_del_init(&qd->qd_reclaim);
-					atomic_dec(&qd_lru_count);
-				}
+			if (qid_eq(qd->qd_id, qid) &&
+			    lockref_get_not_dead(&qd->qd_lockref)) {
+				list_lru_del(&gfs2_qd_lru, &qd->qd_lru);
 				found = 1;
 				break;
 			}
@@ -229,18 +257,13 @@ static void qd_hold(struct gfs2_quota_data *qd)
 
 static void qd_put(struct gfs2_quota_data *qd)
 {
-	spin_lock(&qd_lock);
-
-	if (!lockref_put_or_lock(&qd->qd_lockref)) {
+	if (lockref_put_or_lock(&qd->qd_lockref))
+		return;
 
-		/* Add to the reclaim list */
-		list_add_tail(&qd->qd_reclaim, &qd_lru_list);
-		atomic_inc(&qd_lru_count);
+	qd->qd_lockref.count = 0;
+	list_lru_add(&gfs2_qd_lru, &qd->qd_lru);
+	spin_unlock(&qd->qd_lockref.lock);
 
-		spin_unlock(&qd->qd_lockref.lock);
-	}
-
-	spin_unlock(&qd_lock);
 }
 
 static int slot_get(struct gfs2_quota_data *qd)
@@ -398,11 +421,11 @@ static int qd_check_sync(struct gfs2_sbd *sdp, struct gfs2_quota_data *qd,
 	    (sync_gen && (qd->qd_sync_gen >= *sync_gen)))
 		return 0;
 
-	list_move_tail(&qd->qd_list, &sdp->sd_quota_list);
+	if (!lockref_get_not_dead(&qd->qd_lockref))
+		return 0;
 
+	list_move_tail(&qd->qd_list, &sdp->sd_quota_list);
 	set_bit(QDF_LOCKED, &qd->qd_flags);
-	gfs2_assert_warn(sdp, !__lockref_is_dead(&qd->qd_lockref));
-	lockref_get(&qd->qd_lockref);
 	qd->qd_change_sync = qd->qd_change;
 	gfs2_assert_warn(sdp, qd->qd_slot_count);
 	qd->qd_slot_count++;
@@ -1329,10 +1352,7 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 
 		list_del(&qd->qd_list);
 		/* Also remove if this qd exists in the reclaim list */
-		if (!list_empty(&qd->qd_reclaim)) {
-			list_del_init(&qd->qd_reclaim);
-			atomic_dec(&qd_lru_count);
-		}
+		list_lru_del(&gfs2_qd_lru, &qd->qd_lru);
 		atomic_dec(&sdp->sd_quota_count);
 		spin_unlock(&qd_lock);
 
@@ -1487,7 +1507,7 @@ static int gfs2_quota_get_xstate(struct super_block *sb,
 	}
 	fqs->qs_uquota.qfs_nextents = 1; /* unsupported */
 	fqs->qs_gquota = fqs->qs_uquota; /* its the same inode in both cases */
-	fqs->qs_incoredqs = atomic_read(&qd_lru_count);
+	fqs->qs_incoredqs = list_lru_count(&gfs2_qd_lru);
 	return 0;
 }
 
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 0f64d9d..96e4f34 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -10,9 +10,10 @@
 #ifndef __QUOTA_DOT_H__
 #define __QUOTA_DOT_H__
 
+#include <linux/list_lru.h>
+
 struct gfs2_inode;
 struct gfs2_sbd;
-struct shrink_control;
 
 #define NO_UID_QUOTA_CHANGE INVALID_UID
 #define NO_GID_QUOTA_CHANGE INVALID_GID
@@ -53,10 +54,8 @@ static inline int gfs2_quota_lock_check(struct gfs2_inode *ip)
 	return ret;
 }
 
-extern unsigned long gfs2_qd_shrink_count(struct shrinker *shrink,
-					  struct shrink_control *sc);
-extern unsigned long gfs2_qd_shrink_scan(struct shrinker *shrink,
-					 struct shrink_control *sc);
 extern const struct quotactl_ops gfs2_quotactl_ops;
+extern struct shrinker gfs2_qd_shrinker;
+extern struct list_lru gfs2_qd_lru;
 
 #endif /* __QUOTA_DOT_H__ */
-- 
1.7.4.4

