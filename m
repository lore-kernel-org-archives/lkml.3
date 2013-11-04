Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3KDLjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:39:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab3KDLgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:39 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 13/19] GFS2: Make two similar quota code fragments into a function
Date: Mon,  4 Nov 2013 11:09:36 +0000
Message-Id: <1383563382-8535-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change bar the removal of a
test of the MS_READONLY flag which would never be reachable.
This merges the common code from qd_fish and qd_trylock into
a single function and calls it from both those places.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 658abe2..75414e7 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -383,6 +383,25 @@ static void bh_put(struct gfs2_quota_data *qd)
 	mutex_unlock(&sdp->sd_quota_mutex);
 }
 
+static int qd_check_sync(struct gfs2_sbd *sdp, struct gfs2_quota_data *qd,
+			 u64 *sync_gen)
+{
+	if (test_bit(QDF_LOCKED, &qd->qd_flags) ||
+	    !test_bit(QDF_CHANGE, &qd->qd_flags) ||
+	    (sync_gen && (qd->qd_sync_gen >= *sync_gen)))
+		return 0;
+
+	list_move_tail(&qd->qd_list, &sdp->sd_quota_list);
+
+	set_bit(QDF_LOCKED, &qd->qd_flags);
+	gfs2_assert_warn(sdp, atomic_read(&qd->qd_count));
+	atomic_inc(&qd->qd_count);
+	qd->qd_change_sync = qd->qd_change;
+	gfs2_assert_warn(sdp, qd->qd_slot_count);
+	qd->qd_slot_count++;
+	return 1;
+}
+
 static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 {
 	struct gfs2_quota_data *qd = NULL;
@@ -397,22 +416,9 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 	spin_lock(&qd_lru_lock);
 
 	list_for_each_entry(qd, &sdp->sd_quota_list, qd_list) {
-		if (test_bit(QDF_LOCKED, &qd->qd_flags) ||
-		    !test_bit(QDF_CHANGE, &qd->qd_flags) ||
-		    qd->qd_sync_gen >= sdp->sd_quota_sync_gen)
-			continue;
-
-		list_move_tail(&qd->qd_list, &sdp->sd_quota_list);
-
-		set_bit(QDF_LOCKED, &qd->qd_flags);
-		gfs2_assert_warn(sdp, atomic_read(&qd->qd_count));
-		atomic_inc(&qd->qd_count);
-		qd->qd_change_sync = qd->qd_change;
-		gfs2_assert_warn(sdp, qd->qd_slot_count);
-		qd->qd_slot_count++;
-		found = 1;
-
-		break;
+		found = qd_check_sync(sdp, qd, &sdp->sd_quota_sync_gen);
+		if (found)
+			break;
 	}
 
 	if (!found)
@@ -439,28 +445,14 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 static int qd_trylock(struct gfs2_quota_data *qd)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
-
-	if (sdp->sd_vfs->s_flags & MS_RDONLY)
-		return 0;
+	int found;
 
 	spin_lock(&qd_lru_lock);
+	found = qd_check_sync(sdp, qd, NULL);
+	spin_unlock(&qd_lru_lock);
 
-	if (test_bit(QDF_LOCKED, &qd->qd_flags) ||
-	    !test_bit(QDF_CHANGE, &qd->qd_flags)) {
-		spin_unlock(&qd_lru_lock);
+	if (!found)
 		return 0;
-	}
-
-	list_move_tail(&qd->qd_list, &sdp->sd_quota_list);
-
-	set_bit(QDF_LOCKED, &qd->qd_flags);
-	gfs2_assert_warn(sdp, atomic_read(&qd->qd_count));
-	atomic_inc(&qd->qd_count);
-	qd->qd_change_sync = qd->qd_change;
-	gfs2_assert_warn(sdp, qd->qd_slot_count);
-	qd->qd_slot_count++;
-
-	spin_unlock(&qd_lru_lock);
 
 	gfs2_assert_warn(sdp, qd->qd_change_sync);
 	if (bh_get(qd)) {
-- 
1.7.4.4

