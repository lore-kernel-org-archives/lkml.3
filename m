Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaDAJXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:23:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaDAJQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:20 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/29] GFS2: Move log buffer lists into transaction
Date: Tue,  1 Apr 2014 10:15:21 +0100
Message-Id: <1396343741-1524-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over time, we hope to be able to improve the concurrency available
in the log code. This is one small step towards that, by moving
the buffer lists from the super block, and into the transaction
structure, so that each transaction builds its own buffer lists.

At transaction commit time, the buffer lists are merged into
the currently accumulating transaction. That transaction then
is passed into the before and after commit functions at journal
flush time. Thus there should be no change in overall behaviour
yet.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 3bf0631..54b66809 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -82,6 +82,8 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	struct gfs2_trans tr;
 
 	memset(&tr, 0, sizeof(tr));
+	INIT_LIST_HEAD(&tr.tr_buf);
+	INIT_LIST_HEAD(&tr.tr_databuf);
 	tr.tr_revokes = atomic_read(&gl->gl_ail_count);
 
 	if (!tr.tr_revokes)
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 645655c..99aab64 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -52,7 +52,7 @@ struct gfs2_log_header_host {
  */
 
 struct gfs2_log_operations {
-	void (*lo_before_commit) (struct gfs2_sbd *sdp);
+	void (*lo_before_commit) (struct gfs2_sbd *sdp, struct gfs2_trans *tr);
 	void (*lo_after_commit) (struct gfs2_sbd *sdp, struct gfs2_trans *tr);
 	void (*lo_before_scan) (struct gfs2_jdesc *jd,
 				struct gfs2_log_header_host *head, int pass);
@@ -476,6 +476,8 @@ struct gfs2_trans {
 	unsigned int tr_num_revoke_rm;
 
 	struct list_head tr_list;
+	struct list_head tr_databuf;
+	struct list_head tr_buf;
 
 	unsigned int tr_first;
 	struct list_head tr_ail1_list;
@@ -756,9 +758,7 @@ struct gfs2_sbd {
 	unsigned int sd_log_num_rg;
 	unsigned int sd_log_num_databuf;
 
-	struct list_head sd_log_le_buf;
 	struct list_head sd_log_le_revoke;
-	struct list_head sd_log_le_databuf;
 	struct list_head sd_log_le_ordered;
 	spinlock_t sd_ordered_lock;
 
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 1e1bda0..975712c 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -712,7 +712,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 		tr->tr_first = sdp->sd_log_flush_head;
 
 	gfs2_ordered_write(sdp);
-	lops_before_commit(sdp);
+	lops_before_commit(sdp, tr);
 	gfs2_log_flush_bio(sdp, WRITE);
 
 	if (sdp->sd_log_head != sdp->sd_log_flush_head) {
@@ -744,6 +744,27 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	kfree(tr);
 }
 
+/**
+ * gfs2_merge_trans - Merge a new transaction into a cached transaction
+ * @old: Original transaction to be expanded
+ * @new: New transaction to be merged
+ */
+
+static void gfs2_merge_trans(struct gfs2_trans *old, struct gfs2_trans *new)
+{
+	WARN_ON_ONCE(old->tr_attached != 1);
+
+	old->tr_num_buf_new	+= new->tr_num_buf_new;
+	old->tr_num_databuf_new	+= new->tr_num_databuf_new;
+	old->tr_num_buf_rm	+= new->tr_num_buf_rm;
+	old->tr_num_databuf_rm	+= new->tr_num_databuf_rm;
+	old->tr_num_revoke	+= new->tr_num_revoke;
+	old->tr_num_revoke_rm	+= new->tr_num_revoke_rm;
+
+	list_splice_tail_init(&new->tr_databuf, &old->tr_databuf);
+	list_splice_tail_init(&new->tr_buf, &old->tr_buf);
+}
+
 static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	unsigned int reserved;
@@ -766,8 +787,9 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 			     sdp->sd_jdesc->jd_blocks);
 	sdp->sd_log_blks_reserved = reserved;
 
-	if (sdp->sd_log_tr == NULL &&
-	    (tr->tr_num_buf_new || tr->tr_num_databuf_new)) {
+	if (sdp->sd_log_tr) {
+		gfs2_merge_trans(sdp->sd_log_tr, tr);
+	} else if (tr->tr_num_buf_new || tr->tr_num_databuf_new) {
 		gfs2_assert_withdraw(sdp, tr->tr_t_gh.gh_gl);
 		sdp->sd_log_tr = tr;
 		tr->tr_attached = 1;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 7669379..ee9ec7f 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -491,24 +491,23 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 	gfs2_log_unlock(sdp);
 }
 
-static void buf_lo_before_commit(struct gfs2_sbd *sdp)
+static void buf_lo_before_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	unsigned int limit = buf_limit(sdp); /* 503 for 4k blocks */
-
-	gfs2_before_commit(sdp, limit, sdp->sd_log_num_buf,
-			   &sdp->sd_log_le_buf, 0);
+	if (tr == NULL)
+		return;
+	gfs2_before_commit(sdp, limit, sdp->sd_log_num_buf, &tr->tr_buf, 0);
 }
 
 static void buf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
-	struct list_head *head = &sdp->sd_log_le_buf;
+	struct list_head *head;
 	struct gfs2_bufdata *bd;
 
-	if (tr == NULL) {
-		gfs2_assert(sdp, list_empty(head));
+	if (tr == NULL)
 		return;
-	}
 
+	head = &tr->tr_buf;
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
@@ -620,7 +619,7 @@ static void buf_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 	        jd->jd_jid, sdp->sd_replayed_blocks, sdp->sd_found_blocks);
 }
 
-static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
+static void revoke_lo_before_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	struct gfs2_meta_header *mh;
 	unsigned int offset;
@@ -760,12 +759,12 @@ static void revoke_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
  *
  */
 
-static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
+static void databuf_lo_before_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	unsigned int limit = buf_limit(sdp) / 2;
-
-	gfs2_before_commit(sdp, limit, sdp->sd_log_num_databuf,
-			   &sdp->sd_log_le_databuf, 1);
+	if (tr == NULL)
+		return;
+	gfs2_before_commit(sdp, limit, sdp->sd_log_num_databuf, &tr->tr_databuf, 1);
 }
 
 static int databuf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
@@ -840,14 +839,13 @@ static void databuf_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 
 static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
-	struct list_head *head = &sdp->sd_log_le_databuf;
+	struct list_head *head;
 	struct gfs2_bufdata *bd;
 
-	if (tr == NULL) {
-		gfs2_assert(sdp, list_empty(head));
+	if (tr == NULL)
 		return;
-	}
 
+	head = &tr->tr_databuf;
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index 9ca2e64..a65a7ba 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -46,12 +46,13 @@ static inline unsigned int databuf_limit(struct gfs2_sbd *sdp)
 	return limit;
 }
 
-static inline void lops_before_commit(struct gfs2_sbd *sdp)
+static inline void lops_before_commit(struct gfs2_sbd *sdp,
+				      struct gfs2_trans *tr)
 {
 	int x;
 	for (x = 0; gfs2_log_ops[x]; x++)
 		if (gfs2_log_ops[x]->lo_before_commit)
-			gfs2_log_ops[x]->lo_before_commit(sdp);
+			gfs2_log_ops[x]->lo_before_commit(sdp, tr);
 }
 
 static inline void lops_after_commit(struct gfs2_sbd *sdp,
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index c6872d0..1f855a7 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -114,9 +114,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	spin_lock_init(&sdp->sd_log_lock);
 	atomic_set(&sdp->sd_log_pinned, 0);
-	INIT_LIST_HEAD(&sdp->sd_log_le_buf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_revoke);
-	INIT_LIST_HEAD(&sdp->sd_log_le_databuf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_ordered);
 	spin_lock_init(&sdp->sd_ordered_lock);
 
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 963b28c..e0464a2 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -51,6 +51,9 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 	if (revokes)
 		tr->tr_reserved += gfs2_struct2blk(sdp, revokes,
 						   sizeof(u64));
+	INIT_LIST_HEAD(&tr->tr_databuf);
+	INIT_LIST_HEAD(&tr->tr_buf);
+
 	sb_start_intwrite(sdp->sd_vfs);
 	gfs2_holder_init(sdp->sd_trans_gl, LM_ST_SHARED, 0, &tr->tr_t_gh);
 
@@ -211,7 +214,7 @@ void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
 		sdp->sd_log_num_databuf++;
-		list_add_tail(&bd->bd_list, &sdp->sd_log_le_databuf);
+		list_add_tail(&bd->bd_list, &tr->tr_databuf);
 	}
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
@@ -239,7 +242,7 @@ static void meta_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	mh->__pad0 = cpu_to_be64(0);
 	mh->mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
 	sdp->sd_log_num_buf++;
-	list_add(&bd->bd_list, &sdp->sd_log_le_buf);
+	list_add(&bd->bd_list, &tr->tr_buf);
 	tr->tr_num_buf_new++;
 }
 
-- 
1.8.3.1

