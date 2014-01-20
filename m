Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaATM0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:26:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbaATMY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:58 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 20/24] GFS2: Move quota bitmap operations under their own lock
Date: Mon, 20 Jan 2014 12:23:43 +0000
Message-Id: <1390220627-1571-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gradually, the global qd_lock is being used for less and less.
After this patch it will only be used for the per super block
list whose purpose is to allow syncing of changes back to the
master quota file from the local quota changes file. Fixing
up that process to make it more efficient will be the subject
of a later patch, however this patch removes another barrier
to doing that.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 4b9aa5b..8c64e26 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -734,6 +734,7 @@ struct gfs2_sbd {
 
 	unsigned int sd_quota_slots;
 	unsigned long *sd_quota_bitmap;
+	spinlock_t sd_bitmap_lock;
 
 	u64 sd_quota_sync_gen;
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 27648e8..06a66c9 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -99,6 +99,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	init_waitqueue_head(&sdp->sd_quota_wait);
 	INIT_LIST_HEAD(&sdp->sd_trunc_list);
 	spin_lock_init(&sdp->sd_trunc_lock);
+	spin_lock_init(&sdp->sd_bitmap_lock);
 
 	mapping = &sdp->sd_aspace;
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 79be67a..02a2740 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -76,6 +76,7 @@
 #define GFS2_QD_HASH_MASK       (GFS2_QD_HASH_SIZE - 1)
 
 /* Lock order: qd_lock -> bucket lock -> qd->lockref.lock -> lru lock */
+/*                     -> sd_bitmap_lock                              */
 static DEFINE_SPINLOCK(qd_lock);
 struct list_lru gfs2_qd_lru;
 
@@ -319,7 +320,7 @@ static int slot_get(struct gfs2_quota_data *qd)
 	unsigned int bit;
 	int error = 0;
 
-	spin_lock(&qd_lock);
+	spin_lock(&sdp->sd_bitmap_lock);
 	if (qd->qd_slot_count != 0)
 		goto out;
 
@@ -331,7 +332,7 @@ static int slot_get(struct gfs2_quota_data *qd)
 out:
 		qd->qd_slot_count++;
 	}
-	spin_unlock(&qd_lock);
+	spin_unlock(&sdp->sd_bitmap_lock);
 
 	return error;
 }
@@ -340,23 +341,23 @@ static void slot_hold(struct gfs2_quota_data *qd)
 {
 	struct gfs2_sbd *sdp = qd->qd_sbd;
 
-	spin_lock(&qd_lock);
+	spin_lock(&sdp->sd_bitmap_lock);
 	gfs2_assert(sdp, qd->qd_slot_count);
 	qd->qd_slot_count++;
-	spin_unlock(&qd_lock);
+	spin_unlock(&sdp->sd_bitmap_lock);
 }
 
 static void slot_put(struct gfs2_quota_data *qd)
 {
 	struct gfs2_sbd *sdp = qd->qd_sbd;
 
-	spin_lock(&qd_lock);
+	spin_lock(&sdp->sd_bitmap_lock);
 	gfs2_assert(sdp, qd->qd_slot_count);
 	if (!--qd->qd_slot_count) {
 		BUG_ON(!test_and_clear_bit(qd->qd_slot, sdp->sd_quota_bitmap));
 		qd->qd_slot = -1;
 	}
-	spin_unlock(&qd_lock);
+	spin_unlock(&sdp->sd_bitmap_lock);
 }
 
 static int bh_get(struct gfs2_quota_data *qd)
@@ -434,8 +435,7 @@ static int qd_check_sync(struct gfs2_sbd *sdp, struct gfs2_quota_data *qd,
 	list_move_tail(&qd->qd_list, &sdp->sd_quota_list);
 	set_bit(QDF_LOCKED, &qd->qd_flags);
 	qd->qd_change_sync = qd->qd_change;
-	gfs2_assert_warn(sdp, qd->qd_slot_count);
-	qd->qd_slot_count++;
+	slot_hold(qd);
 	return 1;
 }
 
-- 
1.8.3.1

