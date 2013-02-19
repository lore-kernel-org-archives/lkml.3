Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab3BSKeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:34:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600Ab3BSKeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:03 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/10] GFS2: Merge revoke adding functions
Date: Tue, 19 Feb 2013 10:07:32 +0000
Message-Id: <1361268460-3092-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the lo_add function for revokes into trans.c, removing
a function call and making the code easier to read.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9ceccb1..9c80742 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -600,20 +600,6 @@ static void buf_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 	        jd->jd_jid, sdp->sd_replayed_blocks, sdp->sd_found_blocks);
 }
 
-static void revoke_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
-{
-	struct gfs2_glock *gl = bd->bd_gl;
-	struct gfs2_trans *tr;
-
-	tr = current->journal_info;
-	tr->tr_touched = 1;
-	tr->tr_num_revoke++;
-	sdp->sd_log_num_revoke++;
-	atomic_inc(&gl->gl_revokes);
-	set_bit(GLF_LFLUSH, &gl->gl_flags);
-	list_add(&bd->bd_list, &sdp->sd_log_le_revoke);
-}
-
 static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 {
 	struct gfs2_meta_header *mh;
@@ -895,7 +881,6 @@ const struct gfs2_log_operations gfs2_buf_lops = {
 };
 
 const struct gfs2_log_operations gfs2_revoke_lops = {
-	.lo_add = revoke_lo_add,
 	.lo_before_commit = revoke_lo_before_commit,
 	.lo_after_commit = revoke_lo_after_commit,
 	.lo_before_scan = revoke_lo_before_scan,
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 4136270..6f3ddbc 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -175,11 +175,19 @@ void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
 
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
+	struct gfs2_glock *gl = bd->bd_gl;
+	struct gfs2_trans *tr = current->journal_info;
+
 	BUG_ON(!list_empty(&bd->bd_list));
 	BUG_ON(!list_empty(&bd->bd_ail_st_list));
 	BUG_ON(!list_empty(&bd->bd_ail_gl_list));
 	lops_init_le(bd, &gfs2_revoke_lops);
-	lops_add(sdp, bd);
+	tr->tr_touched = 1;
+	tr->tr_num_revoke++;
+	sdp->sd_log_num_revoke++;
+	atomic_inc(&gl->gl_revokes);
+	set_bit(GLF_LFLUSH, &gl->gl_flags);
+	list_add(&bd->bd_list, &sdp->sd_log_le_revoke);
 }
 
 void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len)
-- 
1.7.4

