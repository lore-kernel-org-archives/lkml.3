Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3GAKtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:49:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3GAKtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:49:18 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/12] GFS2: aggressively issue revokes in gfs2_log_flush
Date: Mon,  1 Jul 2013 10:33:12 +0100
Message-Id: <1372671195-3472-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

This patch looks at all the outstanding blocks in all the transactions
on the log, and moves the completed ones to the ail2 list.  Then it
issues revokes for these blocks.  This will hopefully speed things up
in situations where there is a lot of contention for glocks, especially
if they are acquired serially.

revoke_lo_before_commit will issue at most one log block's full of these
preemptive revokes. The amount of reserved log space that
gfs2_log_reserve() ignores has been incremented to allow for this extra
block.

This patch also consolidates the common revoke instructions into one
function, gfs2_add_revoke().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index c66e99c..5f2e522 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -54,7 +54,6 @@ static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 	struct gfs2_bufdata *bd, *tmp;
 	struct buffer_head *bh;
 	const unsigned long b_state = (1UL << BH_Dirty)|(1UL << BH_Pinned)|(1UL << BH_Lock);
-	sector_t blocknr;
 
 	gfs2_log_lock(sdp);
 	spin_lock(&sdp->sd_ail_lock);
@@ -65,13 +64,6 @@ static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 				continue;
 			gfs2_ail_error(gl, bh);
 		}
-		blocknr = bh->b_blocknr;
-		bh->b_private = NULL;
-		gfs2_remove_from_ail(bd); /* drops ref on bh */
-
-		bd->bd_bh = NULL;
-		bd->bd_blkno = blocknr;
-
 		gfs2_trans_add_revoke(sdp, bd);
 	}
 	GLOCK_BUG_ON(gl, !fsync && atomic_read(&gl->gl_ail_count));
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index b404f48..610613f 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -211,15 +211,16 @@ static void gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 static int gfs2_ail1_empty(struct gfs2_sbd *sdp)
 {
 	struct gfs2_trans *tr, *s;
+	int oldest_tr = 1;
 	int ret;
 
 	spin_lock(&sdp->sd_ail_lock);
 	list_for_each_entry_safe_reverse(tr, s, &sdp->sd_ail1_list, tr_list) {
 		gfs2_ail1_empty_one(sdp, tr);
-		if (list_empty(&tr->tr_ail1_list))
+		if (list_empty(&tr->tr_ail1_list) && oldest_tr)
 			list_move(&tr->tr_list, &sdp->sd_ail2_list);
 		else
-			break;
+			oldest_tr = 0;
 	}
 	ret = list_empty(&sdp->sd_ail1_list);
 	spin_unlock(&sdp->sd_ail_lock);
@@ -317,7 +318,7 @@ static void ail2_empty(struct gfs2_sbd *sdp, unsigned int new_tail)
 
 int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks)
 {
-	unsigned reserved_blks = 6 * (4096 / sdp->sd_vfs->s_blocksize);
+	unsigned reserved_blks = 7 * (4096 / sdp->sd_vfs->s_blocksize);
 	unsigned wanted = blks + reserved_blks;
 	DEFINE_WAIT(wait);
 	int did_wait = 0;
@@ -545,6 +546,76 @@ void gfs2_ordered_del_inode(struct gfs2_inode *ip)
 	spin_unlock(&sdp->sd_ordered_lock);
 }
 
+void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
+{
+	struct buffer_head *bh = bd->bd_bh;
+	struct gfs2_glock *gl = bd->bd_gl;
+
+	gfs2_remove_from_ail(bd);
+	bd->bd_bh = NULL;
+	bh->b_private = NULL;
+	bd->bd_blkno = bh->b_blocknr;
+	bd->bd_ops = &gfs2_revoke_lops;
+	sdp->sd_log_num_revoke++;
+	atomic_inc(&gl->gl_revokes);
+	set_bit(GLF_LFLUSH, &gl->gl_flags);
+	list_add(&bd->bd_list, &sdp->sd_log_le_revoke);
+}
+
+void gfs2_write_revokes(struct gfs2_sbd *sdp)
+{
+	struct gfs2_trans *tr;
+	struct gfs2_bufdata *bd, *tmp;
+	int have_revokes = 0;
+	int max_revokes = (sdp->sd_sb.sb_bsize - sizeof(struct gfs2_log_descriptor)) / sizeof(u64);
+
+	gfs2_ail1_empty(sdp);
+	spin_lock(&sdp->sd_ail_lock);
+	list_for_each_entry(tr, &sdp->sd_ail1_list, tr_list) {
+		list_for_each_entry(bd, &tr->tr_ail2_list, bd_ail_st_list) {
+			if (list_empty(&bd->bd_list)) {
+				have_revokes = 1;
+				goto done;
+			}
+		}
+	}
+done:
+	spin_unlock(&sdp->sd_ail_lock);
+	if (have_revokes == 0)
+		return;
+	while (sdp->sd_log_num_revoke > max_revokes)
+		max_revokes += (sdp->sd_sb.sb_bsize - sizeof(struct gfs2_meta_header)) / sizeof(u64);
+	max_revokes -= sdp->sd_log_num_revoke;
+	if (!sdp->sd_log_num_revoke) {
+		atomic_dec(&sdp->sd_log_blks_free);
+		/* If no blocks have been reserved, we need to also
+		 * reserve a block for the header */
+		if (!sdp->sd_log_blks_reserved)
+			atomic_dec(&sdp->sd_log_blks_free);
+	}
+	gfs2_log_lock(sdp);
+	spin_lock(&sdp->sd_ail_lock);
+	list_for_each_entry(tr, &sdp->sd_ail1_list, tr_list) {
+		list_for_each_entry_safe(bd, tmp, &tr->tr_ail2_list, bd_ail_st_list) {
+			if (max_revokes == 0)
+				goto out_of_blocks;
+			if (!list_empty(&bd->bd_list))
+				continue;
+			gfs2_add_revoke(sdp, bd);
+			max_revokes--;
+		}
+	}
+out_of_blocks:
+	spin_unlock(&sdp->sd_ail_lock);
+	gfs2_log_unlock(sdp);
+
+	if (!sdp->sd_log_num_revoke) {
+		atomic_inc(&sdp->sd_log_blks_free);
+		if (!sdp->sd_log_blks_reserved)
+			atomic_inc(&sdp->sd_log_blks_free);
+	}
+}
+
 /**
  * log_write_header - Get and initialize a journal header buffer
  * @sdp: The GFS2 superblock
@@ -562,7 +633,6 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 	lh = page_address(page);
 	clear_page(lh);
 
-	gfs2_ail1_empty(sdp);
 	tail = current_tail(sdp);
 
 	lh->lh_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 3566f35..3721663 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -72,5 +72,7 @@ extern void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc)
 extern void gfs2_log_shutdown(struct gfs2_sbd *sdp);
 extern void gfs2_meta_syncfs(struct gfs2_sbd *sdp);
 extern int gfs2_logd(void *data);
+extern void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
+extern void gfs2_write_revokes(struct gfs2_sbd *sdp);
 
 #endif /* __LOG_DOT_H__ */
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 33f18b7..17c5b5d 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -606,6 +606,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	struct page *page;
 	unsigned int length;
 
+	gfs2_write_revokes(sdp);
 	if (!sdp->sd_log_num_revoke)
 		return;
 
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 1a89afb..0da3906 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -296,10 +296,6 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 	if (bd) {
 		spin_lock(&sdp->sd_ail_lock);
 		if (bd->bd_tr) {
-			gfs2_remove_from_ail(bd);
-			bh->b_private = NULL;
-			bd->bd_bh = NULL;
-			bd->bd_blkno = bh->b_blocknr;
 			gfs2_trans_add_revoke(sdp, bd);
 		}
 		spin_unlock(&sdp->sd_ail_lock);
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 7374907..0fa0dba 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -274,15 +274,9 @@ void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	struct gfs2_trans *tr = current->journal_info;
 
 	BUG_ON(!list_empty(&bd->bd_list));
-	BUG_ON(!list_empty(&bd->bd_ail_st_list));
-	BUG_ON(!list_empty(&bd->bd_ail_gl_list));
-	bd->bd_ops = &gfs2_revoke_lops;
+	gfs2_add_revoke(sdp, bd);
 	tr->tr_touched = 1;
 	tr->tr_num_revoke++;
-	sdp->sd_log_num_revoke++;
-	atomic_inc(&gl->gl_revokes);
-	set_bit(GLF_LFLUSH, &gl->gl_flags);
-	list_add(&bd->bd_list, &sdp->sd_log_le_revoke);
 }
 
 void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len)
-- 
1.7.4

