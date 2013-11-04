Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3KDLim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:38:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab3KDLgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:40 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 14/19] GFS2: Inline qd_trylock into gfs2_quota_unlock
Date: Mon,  4 Nov 2013 11:09:37 +0000
Message-Id: <1383563382-8535-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function qd_trylock was not a trylock despite its name and
can be inlined into gfs2_quota_unlock in order to make the
code a bit clearer. There should be no functional change as a
result of this patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 75414e7..cfb4cde 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -442,29 +442,6 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 	return 0;
 }
 
-static int qd_trylock(struct gfs2_quota_data *qd)
-{
-	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
-	int found;
-
-	spin_lock(&qd_lru_lock);
-	found = qd_check_sync(sdp, qd, NULL);
-	spin_unlock(&qd_lru_lock);
-
-	if (!found)
-		return 0;
-
-	gfs2_assert_warn(sdp, qd->qd_change_sync);
-	if (bh_get(qd)) {
-		clear_bit(QDF_LOCKED, &qd->qd_flags);
-		slot_put(qd);
-		qd_put(qd);
-		return 0;
-	}
-
-	return 1;
-}
-
 static void qd_unlock(struct gfs2_quota_data *qd)
 {
 	gfs2_assert_warn(qd->qd_gl->gl_sbd,
@@ -1015,9 +992,11 @@ static int need_sync(struct gfs2_quota_data *qd)
 
 void gfs2_quota_unlock(struct gfs2_inode *ip)
 {
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_quota_data *qda[4];
 	unsigned int count = 0;
 	unsigned int x;
+	int found;
 
 	if (!test_and_clear_bit(GIF_QD_LOCKED, &ip->i_flags))
 		goto out;
@@ -1030,9 +1009,25 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 		sync = need_sync(qd);
 
 		gfs2_glock_dq_uninit(&ip->i_res->rs_qa_qd_ghs[x]);
+		if (!sync)
+			continue;
+
+		spin_lock(&qd_lru_lock);
+		found = qd_check_sync(sdp, qd, NULL);
+		spin_unlock(&qd_lru_lock);
+
+		if (!found)
+			continue;
+
+		gfs2_assert_warn(sdp, qd->qd_change_sync);
+		if (bh_get(qd)) {
+			clear_bit(QDF_LOCKED, &qd->qd_flags);
+			slot_put(qd);
+			qd_put(qd);
+			continue;
+		}
 
-		if (sync && qd_trylock(qd))
-			qda[count++] = qd;
+		qda[count++] = qd;
 	}
 
 	if (count) {
-- 
1.7.4.4

