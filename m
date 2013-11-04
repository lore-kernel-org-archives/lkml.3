Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3KDLtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:49:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3KDLtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:49:08 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 18/19] GFS2: Rename quota qd_lru_lock qd_lock
Date: Mon,  4 Nov 2013 11:22:29 +0000
Message-Id: <1383564150-8975-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383564150-8975-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
 <1383564150-8975-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a straight forward rename which is in preparation for
introducing the generic list_lru infrastructure in the
following patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Abhijith Das <adas@redhat.com>
Tested-by: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index ed08911..466516a 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -74,7 +74,7 @@ struct gfs2_quota_change_host {
 
 static LIST_HEAD(qd_lru_list);
 static atomic_t qd_lru_count = ATOMIC_INIT(0);
-static DEFINE_SPINLOCK(qd_lru_lock);
+static DEFINE_SPINLOCK(qd_lock);
 
 unsigned long gfs2_qd_shrink_scan(struct shrinker *shrink,
 				  struct shrink_control *sc)
@@ -87,7 +87,7 @@ unsigned long gfs2_qd_shrink_scan(struct shrinker *shrink,
 	if (!(sc->gfp_mask & __GFP_FS))
 		return SHRINK_STOP;
 
-	spin_lock(&qd_lru_lock);
+	spin_lock(&qd_lock);
 	while (nr_to_scan && !list_empty(&qd_lru_list)) {
 		qd = list_entry(qd_lru_list.next,
 				struct gfs2_quota_data, qd_reclaim);
@@ -106,13 +106,13 @@ unsigned long gfs2_qd_shrink_scan(struct shrinker *shrink,
 		/* Delete it from the common reclaim list */
 		list_del_init(&qd->qd_reclaim);
 		atomic_dec(&qd_lru_count);
-		spin_unlock(&qd_lru_lock);
+		spin_unlock(&qd_lock);
 		kmem_cache_free(gfs2_quotad_cachep, qd);
-		spin_lock(&qd_lru_lock);
+		spin_lock(&qd_lock);
 		nr_to_scan--;
 		freed++;
 	}
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 	return freed;
 }
 
@@ -179,7 +179,7 @@ static int qd_get(struct gfs2_sbd *sdp, struct kqid qid,
 
 	for (;;) {
 		found = 0;
-		spin_lock(&qd_lru_lock);
+		spin_lock(&qd_lock);
 		list_for_each_entry(qd, &sdp->sd_quota_list, qd_list) {
 			if (qid_eq(qd->qd_id, qid)) {
 				lockref_get(&qd->qd_lockref);
@@ -203,7 +203,7 @@ static int qd_get(struct gfs2_sbd *sdp, struct kqid qid,
 			new_qd = NULL;
 		}
 
-		spin_unlock(&qd_lru_lock);
+		spin_unlock(&qd_lock);
 
 		if (qd) {
 			if (new_qd) {
@@ -229,7 +229,7 @@ static void qd_hold(struct gfs2_quota_data *qd)
 
 static void qd_put(struct gfs2_quota_data *qd)
 {
-	spin_lock(&qd_lru_lock);
+	spin_lock(&qd_lock);
 
 	if (!lockref_put_or_lock(&qd->qd_lockref)) {
 
@@ -240,7 +240,7 @@ static void qd_put(struct gfs2_quota_data *qd)
 		spin_unlock(&qd->qd_lockref.lock);
 	}
 
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 }
 
 static int slot_get(struct gfs2_quota_data *qd)
@@ -249,10 +249,10 @@ static int slot_get(struct gfs2_quota_data *qd)
 	unsigned int c, o = 0, b;
 	unsigned char byte = 0;
 
-	spin_lock(&qd_lru_lock);
+	spin_lock(&qd_lock);
 
 	if (qd->qd_slot_count++) {
-		spin_unlock(&qd_lru_lock);
+		spin_unlock(&qd_lock);
 		return 0;
 	}
 
@@ -276,13 +276,13 @@ found:
 
 	sdp->sd_quota_bitmap[c][o] |= 1 << b;
 
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 
 	return 0;
 
 fail:
 	qd->qd_slot_count--;
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 	return -ENOSPC;
 }
 
@@ -290,10 +290,10 @@ static void slot_hold(struct gfs2_quota_data *qd)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 
-	spin_lock(&qd_lru_lock);
+	spin_lock(&qd_lock);
 	gfs2_assert(sdp, qd->qd_slot_count);
 	qd->qd_slot_count++;
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 }
 
 static void gfs2_icbit_munge(struct gfs2_sbd *sdp, unsigned char **bitmap,
@@ -320,13 +320,13 @@ static void slot_put(struct gfs2_quota_data *qd)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 
-	spin_lock(&qd_lru_lock);
+	spin_lock(&qd_lock);
 	gfs2_assert(sdp, qd->qd_slot_count);
 	if (!--qd->qd_slot_count) {
 		gfs2_icbit_munge(sdp, sdp->sd_quota_bitmap, qd->qd_slot, 0);
 		qd->qd_slot = -1;
 	}
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 }
 
 static int bh_get(struct gfs2_quota_data *qd)
@@ -420,7 +420,7 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 	if (sdp->sd_vfs->s_flags & MS_RDONLY)
 		return 0;
 
-	spin_lock(&qd_lru_lock);
+	spin_lock(&qd_lock);
 
 	list_for_each_entry(qd, &sdp->sd_quota_list, qd_list) {
 		found = qd_check_sync(sdp, qd, &sdp->sd_quota_sync_gen);
@@ -431,7 +431,7 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 	if (!found)
 		qd = NULL;
 
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 
 	if (qd) {
 		gfs2_assert_warn(sdp, qd->qd_change_sync);
@@ -598,9 +598,9 @@ static void do_qc(struct gfs2_quota_data *qd, s64 change)
 	x = be64_to_cpu(qc->qc_change) + change;
 	qc->qc_change = cpu_to_be64(x);
 
-	spin_lock(&qd_lru_lock);
+	spin_lock(&qd_lock);
 	qd->qd_change = x;
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 
 	if (!x) {
 		gfs2_assert_warn(sdp, test_bit(QDF_CHANGE, &qd->qd_flags));
@@ -972,9 +972,9 @@ static int need_sync(struct gfs2_quota_data *qd)
 	if (!qd->qd_qb.qb_limit)
 		return 0;
 
-	spin_lock(&qd_lru_lock);
+	spin_lock(&qd_lock);
 	value = qd->qd_change;
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 
 	spin_lock(&gt->gt_spin);
 	num = gt->gt_quota_scale_num;
@@ -1019,9 +1019,9 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 		if (!sync)
 			continue;
 
-		spin_lock(&qd_lru_lock);
+		spin_lock(&qd_lock);
 		found = qd_check_sync(sdp, qd, NULL);
-		spin_unlock(&qd_lru_lock);
+		spin_unlock(&qd_lock);
 
 		if (!found)
 			continue;
@@ -1083,9 +1083,9 @@ int gfs2_quota_check(struct gfs2_inode *ip, kuid_t uid, kgid_t gid)
 			continue;
 
 		value = (s64)be64_to_cpu(qd->qd_qb.qb_value);
-		spin_lock(&qd_lru_lock);
+		spin_lock(&qd_lock);
 		value += qd->qd_change;
-		spin_unlock(&qd_lru_lock);
+		spin_unlock(&qd_lock);
 
 		if (be64_to_cpu(qd->qd_qb.qb_limit) && (s64)be64_to_cpu(qd->qd_qb.qb_limit) < value) {
 			print_message(qd, "exceeded");
@@ -1276,11 +1276,11 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 			qd->qd_slot = slot;
 			qd->qd_slot_count = 1;
 
-			spin_lock(&qd_lru_lock);
+			spin_lock(&qd_lock);
 			gfs2_icbit_munge(sdp, sdp->sd_quota_bitmap, slot, 1);
 			list_add(&qd->qd_list, &sdp->sd_quota_list);
 			atomic_inc(&sdp->sd_quota_count);
-			spin_unlock(&qd_lru_lock);
+			spin_unlock(&qd_lock);
 
 			found++;
 		}
@@ -1306,7 +1306,7 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 	struct gfs2_quota_data *qd;
 	unsigned int x;
 
-	spin_lock(&qd_lru_lock);
+	spin_lock(&qd_lock);
 	while (!list_empty(head)) {
 		qd = list_entry(head->prev, struct gfs2_quota_data, qd_list);
 
@@ -1320,9 +1320,9 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 		    (qd->qd_lockref.count && !test_bit(QDF_CHANGE, &qd->qd_flags))) {
 			spin_unlock(&qd->qd_lockref.lock);
 			list_move(&qd->qd_list, head);
-			spin_unlock(&qd_lru_lock);
+			spin_unlock(&qd_lock);
 			schedule();
-			spin_lock(&qd_lru_lock);
+			spin_lock(&qd_lock);
 			continue;
 		}
 		spin_unlock(&qd->qd_lockref.lock);
@@ -1334,7 +1334,7 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 			atomic_dec(&qd_lru_count);
 		}
 		atomic_dec(&sdp->sd_quota_count);
-		spin_unlock(&qd_lru_lock);
+		spin_unlock(&qd_lock);
 
 		if (!qd->qd_lockref.count) {
 			gfs2_assert_warn(sdp, !qd->qd_change);
@@ -1346,9 +1346,9 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 		gfs2_glock_put(qd->qd_gl);
 		kmem_cache_free(gfs2_quotad_cachep, qd);
 
-		spin_lock(&qd_lru_lock);
+		spin_lock(&qd_lock);
 	}
-	spin_unlock(&qd_lru_lock);
+	spin_unlock(&qd_lock);
 
 	gfs2_assert_warn(sdp, !atomic_read(&sdp->sd_quota_count));
 
-- 
1.7.4.4

