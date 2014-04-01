Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaDAJVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:21:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbaDAJQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:35 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/29] GFS2: Move recovery variables to journal structure in memory
Date: Tue,  1 Apr 2014 10:15:29 +0100
Message-Id: <1396343741-1524-18-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

If multiple nodes fail and their recovery work runs simultaneously, they
would use the same unprotected variables in the superblock. For example,
they would stomp on each other's revoked blocks lists, which resulted
in file system metadata corruption. This patch moves the necessary
variables so that each journal has its own separate area for tracking
its journal replay.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 456d8fa..ef26ed9 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -503,6 +503,15 @@ struct gfs2_jdesc {
 	unsigned int jd_jid;
 	unsigned int jd_blocks;
 	int jd_recover_error;
+	/* Replay stuff */
+
+	unsigned int jd_found_blocks;
+	unsigned int jd_found_revokes;
+	unsigned int jd_replayed_blocks;
+
+	struct list_head jd_revoke_list;
+	unsigned int jd_replay_tail;
+
 };
 
 struct gfs2_statfs_change_host {
@@ -782,15 +791,6 @@ struct gfs2_sbd {
 	struct list_head sd_ail1_list;
 	struct list_head sd_ail2_list;
 
-	/* Replay stuff */
-
-	struct list_head sd_revoke_list;
-	unsigned int sd_replay_tail;
-
-	unsigned int sd_found_blocks;
-	unsigned int sd_found_revokes;
-	unsigned int sd_replayed_blocks;
-
 	/* For quiescing the filesystem */
 	struct gfs2_holder sd_freeze_gh;
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index ae1d635..a294d8d 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -520,13 +520,11 @@ static void buf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 static void buf_lo_before_scan(struct gfs2_jdesc *jd,
 			       struct gfs2_log_header_host *head, int pass)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(jd->jd_inode);
-
 	if (pass != 0)
 		return;
 
-	sdp->sd_found_blocks = 0;
-	sdp->sd_replayed_blocks = 0;
+	jd->jd_found_blocks = 0;
+	jd->jd_replayed_blocks = 0;
 }
 
 static int buf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
@@ -549,9 +547,9 @@ static int buf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 	for (; blks; gfs2_replay_incr_blk(sdp, &start), blks--) {
 		blkno = be64_to_cpu(*ptr++);
 
-		sdp->sd_found_blocks++;
+		jd->jd_found_blocks++;
 
-		if (gfs2_revoke_check(sdp, blkno, start))
+		if (gfs2_revoke_check(jd, blkno, start))
 			continue;
 
 		error = gfs2_replay_read_block(jd, start, &bh_log);
@@ -572,7 +570,7 @@ static int buf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 		if (error)
 			break;
 
-		sdp->sd_replayed_blocks++;
+		jd->jd_replayed_blocks++;
 	}
 
 	return error;
@@ -615,7 +613,7 @@ static void buf_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 	gfs2_meta_sync(ip->i_gl);
 
 	fs_info(sdp, "jid=%u: Replayed %u of %u blocks\n",
-	        jd->jd_jid, sdp->sd_replayed_blocks, sdp->sd_found_blocks);
+	        jd->jd_jid, jd->jd_replayed_blocks, jd->jd_found_blocks);
 }
 
 static void revoke_lo_before_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
@@ -677,13 +675,11 @@ static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 static void revoke_lo_before_scan(struct gfs2_jdesc *jd,
 				  struct gfs2_log_header_host *head, int pass)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(jd->jd_inode);
-
 	if (pass != 0)
 		return;
 
-	sdp->sd_found_revokes = 0;
-	sdp->sd_replay_tail = head->lh_tail;
+	jd->jd_found_revokes = 0;
+	jd->jd_replay_tail = head->lh_tail;
 }
 
 static int revoke_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
@@ -715,13 +711,13 @@ static int revoke_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 		while (offset + sizeof(u64) <= sdp->sd_sb.sb_bsize) {
 			blkno = be64_to_cpu(*(__be64 *)(bh->b_data + offset));
 
-			error = gfs2_revoke_add(sdp, blkno, start);
+			error = gfs2_revoke_add(jd, blkno, start);
 			if (error < 0) {
 				brelse(bh);
 				return error;
 			}
 			else if (error)
-				sdp->sd_found_revokes++;
+				jd->jd_found_revokes++;
 
 			if (!--revokes)
 				break;
@@ -741,16 +737,16 @@ static void revoke_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 	struct gfs2_sbd *sdp = GFS2_SB(jd->jd_inode);
 
 	if (error) {
-		gfs2_revoke_clean(sdp);
+		gfs2_revoke_clean(jd);
 		return;
 	}
 	if (pass != 1)
 		return;
 
 	fs_info(sdp, "jid=%u: Found %u revoke tags\n",
-	        jd->jd_jid, sdp->sd_found_revokes);
+	        jd->jd_jid, jd->jd_found_revokes);
 
-	gfs2_revoke_clean(sdp);
+	gfs2_revoke_clean(jd);
 }
 
 /**
@@ -789,9 +785,9 @@ static int databuf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 		blkno = be64_to_cpu(*ptr++);
 		esc = be64_to_cpu(*ptr++);
 
-		sdp->sd_found_blocks++;
+		jd->jd_found_blocks++;
 
-		if (gfs2_revoke_check(sdp, blkno, start))
+		if (gfs2_revoke_check(jd, blkno, start))
 			continue;
 
 		error = gfs2_replay_read_block(jd, start, &bh_log);
@@ -811,7 +807,7 @@ static int databuf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 		brelse(bh_log);
 		brelse(bh_ip);
 
-		sdp->sd_replayed_blocks++;
+		jd->jd_replayed_blocks++;
 	}
 
 	return error;
@@ -835,7 +831,7 @@ static void databuf_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 	gfs2_meta_sync(ip->i_gl);
 
 	fs_info(sdp, "jid=%u: Replayed %u of %u data blocks\n",
-		jd->jd_jid, sdp->sd_replayed_blocks, sdp->sd_found_blocks);
+		jd->jd_jid, jd->jd_replayed_blocks, jd->jd_found_blocks);
 }
 
 static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index c3ef844..ea9c35c 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -128,8 +128,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	atomic_set(&sdp->sd_log_in_flight, 0);
 	init_waitqueue_head(&sdp->sd_log_flush_wait);
 
-	INIT_LIST_HEAD(&sdp->sd_revoke_list);
-
 	return sdp;
 }
 
@@ -575,6 +573,8 @@ static int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
 			break;
 
 		INIT_LIST_HEAD(&jd->extent_list);
+		INIT_LIST_HEAD(&jd->jd_revoke_list);
+
 		INIT_WORK(&jd->jd_work, gfs2_recover_func);
 		jd->jd_inode = gfs2_lookupi(sdp->sd_jindex, &name, 1);
 		if (!jd->jd_inode || IS_ERR(jd->jd_inode)) {
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 963b2d7..7ad4094 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -52,9 +52,9 @@ int gfs2_replay_read_block(struct gfs2_jdesc *jd, unsigned int blk,
 	return error;
 }
 
-int gfs2_revoke_add(struct gfs2_sbd *sdp, u64 blkno, unsigned int where)
+int gfs2_revoke_add(struct gfs2_jdesc *jd, u64 blkno, unsigned int where)
 {
-	struct list_head *head = &sdp->sd_revoke_list;
+	struct list_head *head = &jd->jd_revoke_list;
 	struct gfs2_revoke_replay *rr;
 	int found = 0;
 
@@ -81,13 +81,13 @@ int gfs2_revoke_add(struct gfs2_sbd *sdp, u64 blkno, unsigned int where)
 	return 1;
 }
 
-int gfs2_revoke_check(struct gfs2_sbd *sdp, u64 blkno, unsigned int where)
+int gfs2_revoke_check(struct gfs2_jdesc *jd, u64 blkno, unsigned int where)
 {
 	struct gfs2_revoke_replay *rr;
 	int wrap, a, b, revoke;
 	int found = 0;
 
-	list_for_each_entry(rr, &sdp->sd_revoke_list, rr_list) {
+	list_for_each_entry(rr, &jd->jd_revoke_list, rr_list) {
 		if (rr->rr_blkno == blkno) {
 			found = 1;
 			break;
@@ -97,17 +97,17 @@ int gfs2_revoke_check(struct gfs2_sbd *sdp, u64 blkno, unsigned int where)
 	if (!found)
 		return 0;
 
-	wrap = (rr->rr_where < sdp->sd_replay_tail);
-	a = (sdp->sd_replay_tail < where);
+	wrap = (rr->rr_where < jd->jd_replay_tail);
+	a = (jd->jd_replay_tail < where);
 	b = (where < rr->rr_where);
 	revoke = (wrap) ? (a || b) : (a && b);
 
 	return revoke;
 }
 
-void gfs2_revoke_clean(struct gfs2_sbd *sdp)
+void gfs2_revoke_clean(struct gfs2_jdesc *jd)
 {
-	struct list_head *head = &sdp->sd_revoke_list;
+	struct list_head *head = &jd->jd_revoke_list;
 	struct gfs2_revoke_replay *rr;
 
 	while (!list_empty(head)) {
diff --git a/fs/gfs2/recovery.h b/fs/gfs2/recovery.h
index 2226136..6142836 100644
--- a/fs/gfs2/recovery.h
+++ b/fs/gfs2/recovery.h
@@ -23,9 +23,9 @@ static inline void gfs2_replay_incr_blk(struct gfs2_sbd *sdp, unsigned int *blk)
 extern int gfs2_replay_read_block(struct gfs2_jdesc *jd, unsigned int blk,
 			   struct buffer_head **bh);
 
-extern int gfs2_revoke_add(struct gfs2_sbd *sdp, u64 blkno, unsigned int where);
-extern int gfs2_revoke_check(struct gfs2_sbd *sdp, u64 blkno, unsigned int where);
-extern void gfs2_revoke_clean(struct gfs2_sbd *sdp);
+extern int gfs2_revoke_add(struct gfs2_jdesc *jd, u64 blkno, unsigned int where);
+extern int gfs2_revoke_check(struct gfs2_jdesc *jd, u64 blkno, unsigned int where);
+extern void gfs2_revoke_clean(struct gfs2_jdesc *jd);
 
 extern int gfs2_find_jhead(struct gfs2_jdesc *jd,
 		    struct gfs2_log_header_host *head);
-- 
1.8.3.1

