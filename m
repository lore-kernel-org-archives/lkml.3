Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab3DZJpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759624Ab3DZJpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:45:51 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/8] GFS2: replace gfs2_ail structure with gfs2_trans
Date: Fri, 26 Apr 2013 10:18:58 +0100
Message-Id: <1366967941-7184-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
References: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

In order to allow transactions and log flushes to happen at the same
time, gfs2 needs to move the transaction accounting and active items
list code into the gfs2_trans structure.  As a first step toward this,
this patch removes the gfs2_ail structure, and handles the active items
list in the gfs_trans structure.  This keeps gfs2 from allocating an ail
structure on log flushes, and gives us a struture that can later be used
to store the transaction accounting outside of the gfs2 superblock
structure.

With this patch, at the end of a transaction, gfs2 will add the
gfs2_trans structure to the superblock if there is not one already.
This structure now has the active items fields that were previously in
gfs2_ail.  This is not necessary in the case where the transaction was
simply used to add revokes, since these are never written outside of the
journal, and thus, don't need an active items list.

Also, in order to make sure that the transaction structure is not
removed while it's still in use by gfs2_trans_end, unlocking the
sd_log_flush_lock has to happen slightly later in ending the
transaction.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 24f414f..9883694 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1055,7 +1055,7 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 		if (atomic_read(&bh->b_count))
 			goto cannot_release;
 		bd = bh->b_private;
-		if (bd && bd->bd_ail)
+		if (bd && bd->bd_tr)
 			goto cannot_release;
 		if (buffer_pinned(bh) || buffer_dirty(bh))
 			goto not_possible;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 5c29216..2532f7e 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -31,7 +31,6 @@ struct gfs2_holder;
 struct gfs2_glock;
 struct gfs2_quota_data;
 struct gfs2_trans;
-struct gfs2_ail;
 struct gfs2_jdesc;
 struct gfs2_sbd;
 struct lm_lockops;
@@ -53,7 +52,7 @@ struct gfs2_log_header_host {
 
 struct gfs2_log_operations {
 	void (*lo_before_commit) (struct gfs2_sbd *sdp);
-	void (*lo_after_commit) (struct gfs2_sbd *sdp, struct gfs2_ail *ai);
+	void (*lo_after_commit) (struct gfs2_sbd *sdp, struct gfs2_trans *tr);
 	void (*lo_before_scan) (struct gfs2_jdesc *jd,
 				struct gfs2_log_header_host *head, int pass);
 	int (*lo_scan_elements) (struct gfs2_jdesc *jd, unsigned int start,
@@ -139,7 +138,7 @@ struct gfs2_bufdata {
 	struct list_head bd_list;
 	const struct gfs2_log_operations *bd_ops;
 
-	struct gfs2_ail *bd_ail;
+	struct gfs2_trans *bd_tr;
 	struct list_head bd_ail_st_list;
 	struct list_head bd_ail_gl_list;
 };
@@ -433,6 +432,7 @@ struct gfs2_trans {
 	struct gfs2_holder tr_t_gh;
 
 	int tr_touched;
+	int tr_attached;
 
 	unsigned int tr_num_buf_new;
 	unsigned int tr_num_databuf_new;
@@ -440,14 +440,12 @@ struct gfs2_trans {
 	unsigned int tr_num_databuf_rm;
 	unsigned int tr_num_revoke;
 	unsigned int tr_num_revoke_rm;
-};
 
-struct gfs2_ail {
-	struct list_head ai_list;
+	struct list_head tr_list;
 
-	unsigned int ai_first;
-	struct list_head ai_ail1_list;
-	struct list_head ai_ail2_list;
+	unsigned int tr_first;
+	struct list_head tr_ail1_list;
+	struct list_head tr_ail2_list;
 };
 
 struct gfs2_journal_extent {
@@ -710,6 +708,7 @@ struct gfs2_sbd {
 
 	spinlock_t sd_log_lock;
 
+	struct gfs2_trans *sd_log_tr;
 	unsigned int sd_log_blks_reserved;
 	unsigned int sd_log_commited_buf;
 	unsigned int sd_log_commited_databuf;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 9a2ca8b..b404f48 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -73,7 +73,7 @@ unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 
 void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
 {
-	bd->bd_ail = NULL;
+	bd->bd_tr = NULL;
 	list_del_init(&bd->bd_ail_st_list);
 	list_del_init(&bd->bd_ail_gl_list);
 	atomic_dec(&bd->bd_gl->gl_ail_count);
@@ -90,7 +90,7 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
 
 static int gfs2_ail1_start_one(struct gfs2_sbd *sdp,
 			       struct writeback_control *wbc,
-			       struct gfs2_ail *ai)
+			       struct gfs2_trans *tr)
 __releases(&sdp->sd_ail_lock)
 __acquires(&sdp->sd_ail_lock)
 {
@@ -99,15 +99,15 @@ __acquires(&sdp->sd_ail_lock)
 	struct gfs2_bufdata *bd, *s;
 	struct buffer_head *bh;
 
-	list_for_each_entry_safe_reverse(bd, s, &ai->ai_ail1_list, bd_ail_st_list) {
+	list_for_each_entry_safe_reverse(bd, s, &tr->tr_ail1_list, bd_ail_st_list) {
 		bh = bd->bd_bh;
 
-		gfs2_assert(sdp, bd->bd_ail == ai);
+		gfs2_assert(sdp, bd->bd_tr == tr);
 
 		if (!buffer_busy(bh)) {
 			if (!buffer_uptodate(bh))
 				gfs2_io_error_bh(sdp, bh);
-			list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
+			list_move(&bd->bd_ail_st_list, &tr->tr_ail2_list);
 			continue;
 		}
 
@@ -116,7 +116,7 @@ __acquires(&sdp->sd_ail_lock)
 		if (gl == bd->bd_gl)
 			continue;
 		gl = bd->bd_gl;
-		list_move(&bd->bd_ail_st_list, &ai->ai_ail1_list);
+		list_move(&bd->bd_ail_st_list, &tr->tr_ail1_list);
 		mapping = bh->b_page->mapping;
 		if (!mapping)
 			continue;
@@ -144,15 +144,15 @@ __acquires(&sdp->sd_ail_lock)
 void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc)
 {
 	struct list_head *head = &sdp->sd_ail1_list;
-	struct gfs2_ail *ai;
+	struct gfs2_trans *tr;
 
 	trace_gfs2_ail_flush(sdp, wbc, 1);
 	spin_lock(&sdp->sd_ail_lock);
 restart:
-	list_for_each_entry_reverse(ai, head, ai_list) {
+	list_for_each_entry_reverse(tr, head, tr_list) {
 		if (wbc->nr_to_write <= 0)
 			break;
-		if (gfs2_ail1_start_one(sdp, wbc, ai))
+		if (gfs2_ail1_start_one(sdp, wbc, tr))
 			goto restart;
 	}
 	spin_unlock(&sdp->sd_ail_lock);
@@ -183,20 +183,20 @@ static void gfs2_ail1_start(struct gfs2_sbd *sdp)
  *
  */
 
-static void gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
+static void gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	struct gfs2_bufdata *bd, *s;
 	struct buffer_head *bh;
 
-	list_for_each_entry_safe_reverse(bd, s, &ai->ai_ail1_list,
+	list_for_each_entry_safe_reverse(bd, s, &tr->tr_ail1_list,
 					 bd_ail_st_list) {
 		bh = bd->bd_bh;
-		gfs2_assert(sdp, bd->bd_ail == ai);
+		gfs2_assert(sdp, bd->bd_tr == tr);
 		if (buffer_busy(bh))
 			continue;
 		if (!buffer_uptodate(bh))
 			gfs2_io_error_bh(sdp, bh);
-		list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
+		list_move(&bd->bd_ail_st_list, &tr->tr_ail2_list);
 	}
 
 }
@@ -210,14 +210,14 @@ static void gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 
 static int gfs2_ail1_empty(struct gfs2_sbd *sdp)
 {
-	struct gfs2_ail *ai, *s;
+	struct gfs2_trans *tr, *s;
 	int ret;
 
 	spin_lock(&sdp->sd_ail_lock);
-	list_for_each_entry_safe_reverse(ai, s, &sdp->sd_ail1_list, ai_list) {
-		gfs2_ail1_empty_one(sdp, ai);
-		if (list_empty(&ai->ai_ail1_list))
-			list_move(&ai->ai_list, &sdp->sd_ail2_list);
+	list_for_each_entry_safe_reverse(tr, s, &sdp->sd_ail1_list, tr_list) {
+		gfs2_ail1_empty_one(sdp, tr);
+		if (list_empty(&tr->tr_ail1_list))
+			list_move(&tr->tr_list, &sdp->sd_ail2_list);
 		else
 			break;
 	}
@@ -229,13 +229,13 @@ static int gfs2_ail1_empty(struct gfs2_sbd *sdp)
 
 static void gfs2_ail1_wait(struct gfs2_sbd *sdp)
 {
-	struct gfs2_ail *ai;
+	struct gfs2_trans *tr;
 	struct gfs2_bufdata *bd;
 	struct buffer_head *bh;
 
 	spin_lock(&sdp->sd_ail_lock);
-	list_for_each_entry_reverse(ai, &sdp->sd_ail1_list, ai_list) {
-		list_for_each_entry(bd, &ai->ai_ail1_list, bd_ail_st_list) {
+	list_for_each_entry_reverse(tr, &sdp->sd_ail1_list, tr_list) {
+		list_for_each_entry(bd, &tr->tr_ail1_list, bd_ail_st_list) {
 			bh = bd->bd_bh;
 			if (!buffer_locked(bh))
 				continue;
@@ -256,40 +256,40 @@ static void gfs2_ail1_wait(struct gfs2_sbd *sdp)
  *
  */
 
-static void gfs2_ail2_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
+static void gfs2_ail2_empty_one(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
-	struct list_head *head = &ai->ai_ail2_list;
+	struct list_head *head = &tr->tr_ail2_list;
 	struct gfs2_bufdata *bd;
 
 	while (!list_empty(head)) {
 		bd = list_entry(head->prev, struct gfs2_bufdata,
 				bd_ail_st_list);
-		gfs2_assert(sdp, bd->bd_ail == ai);
+		gfs2_assert(sdp, bd->bd_tr == tr);
 		gfs2_remove_from_ail(bd);
 	}
 }
 
 static void ail2_empty(struct gfs2_sbd *sdp, unsigned int new_tail)
 {
-	struct gfs2_ail *ai, *safe;
+	struct gfs2_trans *tr, *safe;
 	unsigned int old_tail = sdp->sd_log_tail;
 	int wrap = (new_tail < old_tail);
 	int a, b, rm;
 
 	spin_lock(&sdp->sd_ail_lock);
 
-	list_for_each_entry_safe(ai, safe, &sdp->sd_ail2_list, ai_list) {
-		a = (old_tail <= ai->ai_first);
-		b = (ai->ai_first < new_tail);
+	list_for_each_entry_safe(tr, safe, &sdp->sd_ail2_list, tr_list) {
+		a = (old_tail <= tr->tr_first);
+		b = (tr->tr_first < new_tail);
 		rm = (wrap) ? (a || b) : (a && b);
 		if (!rm)
 			continue;
 
-		gfs2_ail2_empty_one(sdp, ai);
-		list_del(&ai->ai_list);
-		gfs2_assert_warn(sdp, list_empty(&ai->ai_ail1_list));
-		gfs2_assert_warn(sdp, list_empty(&ai->ai_ail2_list));
-		kfree(ai);
+		gfs2_ail2_empty_one(sdp, tr);
+		list_del(&tr->tr_list);
+		gfs2_assert_warn(sdp, list_empty(&tr->tr_ail1_list));
+		gfs2_assert_warn(sdp, list_empty(&tr->tr_ail2_list));
+		kfree(tr);
 	}
 
 	spin_unlock(&sdp->sd_ail_lock);
@@ -435,7 +435,7 @@ static unsigned int calc_reserved(struct gfs2_sbd *sdp)
 
 static unsigned int current_tail(struct gfs2_sbd *sdp)
 {
-	struct gfs2_ail *ai;
+	struct gfs2_trans *tr;
 	unsigned int tail;
 
 	spin_lock(&sdp->sd_ail_lock);
@@ -443,8 +443,9 @@ static unsigned int current_tail(struct gfs2_sbd *sdp)
 	if (list_empty(&sdp->sd_ail1_list)) {
 		tail = sdp->sd_log_head;
 	} else {
-		ai = list_entry(sdp->sd_ail1_list.prev, struct gfs2_ail, ai_list);
-		tail = ai->ai_first;
+		tr = list_entry(sdp->sd_ail1_list.prev, struct gfs2_trans,
+				tr_list);
+		tail = tr->tr_first;
 	}
 
 	spin_unlock(&sdp->sd_ail_lock);
@@ -600,7 +601,7 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 
 void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 {
-	struct gfs2_ail *ai;
+	struct gfs2_trans *tr;
 
 	down_write(&sdp->sd_log_flush_lock);
 
@@ -611,9 +612,12 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	}
 	trace_gfs2_log_flush(sdp, 1);
 
-	ai = kzalloc(sizeof(struct gfs2_ail), GFP_NOFS | __GFP_NOFAIL);
-	INIT_LIST_HEAD(&ai->ai_ail1_list);
-	INIT_LIST_HEAD(&ai->ai_ail2_list);
+	tr = sdp->sd_log_tr;
+	if (tr) {
+		sdp->sd_log_tr = NULL;
+		INIT_LIST_HEAD(&tr->tr_ail1_list);
+		INIT_LIST_HEAD(&tr->tr_ail2_list);
+	}
 
 	if (sdp->sd_log_num_buf != sdp->sd_log_commited_buf) {
 		printk(KERN_INFO "GFS2: log buf %u %u\n", sdp->sd_log_num_buf,
@@ -630,7 +634,8 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 
 	sdp->sd_log_flush_head = sdp->sd_log_head;
 	sdp->sd_log_flush_wrapped = 0;
-	ai->ai_first = sdp->sd_log_flush_head;
+	if (tr)
+		tr->tr_first = sdp->sd_log_flush_head;
 
 	gfs2_ordered_write(sdp);
 	lops_before_commit(sdp);
@@ -643,7 +648,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 		trace_gfs2_log_blocks(sdp, -1);
 		log_write_header(sdp, 0);
 	}
-	lops_after_commit(sdp, ai);
+	lops_after_commit(sdp, tr);
 
 	gfs2_log_lock(sdp);
 	sdp->sd_log_head = sdp->sd_log_flush_head;
@@ -653,16 +658,16 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	sdp->sd_log_commited_revoke = 0;
 
 	spin_lock(&sdp->sd_ail_lock);
-	if (!list_empty(&ai->ai_ail1_list)) {
-		list_add(&ai->ai_list, &sdp->sd_ail1_list);
-		ai = NULL;
+	if (tr && !list_empty(&tr->tr_ail1_list)) {
+		list_add(&tr->tr_list, &sdp->sd_ail1_list);
+		tr = NULL;
 	}
 	spin_unlock(&sdp->sd_ail_lock);
 	gfs2_log_unlock(sdp);
 	trace_gfs2_log_flush(sdp, 0);
 	up_write(&sdp->sd_log_flush_lock);
 
-	kfree(ai);
+	kfree(tr);
 }
 
 static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
@@ -687,6 +692,12 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 			     sdp->sd_jdesc->jd_blocks);
 	sdp->sd_log_blks_reserved = reserved;
 
+	if (sdp->sd_log_tr == NULL &&
+	    (tr->tr_num_buf_new || tr->tr_num_databuf_new)) {
+		gfs2_assert_withdraw(sdp, tr->tr_t_gh.gh_gl);
+		sdp->sd_log_tr = tr;
+		tr->tr_attached = 1;
+	}
 	gfs2_log_unlock(sdp);
 }
 
@@ -708,7 +719,6 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	log_refund(sdp, tr);
-	up_read(&sdp->sd_log_flush_lock);
 
 	if (atomic_read(&sdp->sd_log_pinned) > atomic_read(&sdp->sd_log_thresh1) ||
 	    ((sdp->sd_jdesc->jd_blocks - atomic_read(&sdp->sd_log_blks_free)) >
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index a505597..7318abf 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -53,8 +53,8 @@ void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	 * to in-place disk block, remove it from the AIL.
 	 */
 	spin_lock(&sdp->sd_ail_lock);
-	if (bd->bd_ail)
-		list_move(&bd->bd_ail_st_list, &bd->bd_ail->ai_ail2_list);
+	if (bd->bd_tr)
+		list_move(&bd->bd_ail_st_list, &bd->bd_tr->tr_ail2_list);
 	spin_unlock(&sdp->sd_ail_lock);
 	get_bh(bh);
 	atomic_inc(&sdp->sd_log_pinned);
@@ -94,7 +94,7 @@ static void maybe_release_space(struct gfs2_bufdata *bd)
  */
 
 static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
-		       struct gfs2_ail *ai)
+		       struct gfs2_trans *tr)
 {
 	struct gfs2_bufdata *bd = bh->b_private;
 
@@ -109,7 +109,7 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 		maybe_release_space(bd);
 
 	spin_lock(&sdp->sd_ail_lock);
-	if (bd->bd_ail) {
+	if (bd->bd_tr) {
 		list_del(&bd->bd_ail_st_list);
 		brelse(bh);
 	} else {
@@ -117,8 +117,8 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 		list_add(&bd->bd_ail_gl_list, &gl->gl_ail_list);
 		atomic_inc(&gl->gl_ail_count);
 	}
-	bd->bd_ail = ai;
-	list_add(&bd->bd_ail_st_list, &ai->ai_ail1_list);
+	bd->bd_tr = tr;
+	list_add(&bd->bd_ail_st_list, &tr->tr_ail1_list);
 	spin_unlock(&sdp->sd_ail_lock);
 
 	clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
@@ -480,17 +480,22 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 			   &sdp->sd_log_le_buf, 0);
 }
 
-static void buf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
+static void buf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	struct list_head *head = &sdp->sd_log_le_buf;
 	struct gfs2_bufdata *bd;
 
+	if (tr == NULL) {
+		gfs2_assert(sdp, list_empty(head));
+		return;
+	}
+
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
 		sdp->sd_log_num_buf--;
 
-		gfs2_unpin(sdp, bd->bd_bh, ai);
+		gfs2_unpin(sdp, bd->bd_bh, tr);
 	}
 	gfs2_assert_warn(sdp, !sdp->sd_log_num_buf);
 }
@@ -613,7 +618,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	gfs2_log_write_page(sdp, page);
 }
 
-static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
+static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	struct list_head *head = &sdp->sd_log_le_revoke;
 	struct gfs2_bufdata *bd;
@@ -791,16 +796,21 @@ static void databuf_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 		jd->jd_jid, sdp->sd_replayed_blocks, sdp->sd_found_blocks);
 }
 
-static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
+static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	struct list_head *head = &sdp->sd_log_le_databuf;
 	struct gfs2_bufdata *bd;
 
+	if (tr == NULL) {
+		gfs2_assert(sdp, list_empty(head));
+		return;
+	}
+
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
 		sdp->sd_log_num_databuf--;
-		gfs2_unpin(sdp, bd->bd_bh, ai);
+		gfs2_unpin(sdp, bd->bd_bh, tr);
 	}
 	gfs2_assert_warn(sdp, !sdp->sd_log_num_databuf);
 }
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index ba77b7d..87e062e 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -55,12 +55,13 @@ static inline void lops_before_commit(struct gfs2_sbd *sdp)
 			gfs2_log_ops[x]->lo_before_commit(sdp);
 }
 
-static inline void lops_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
+static inline void lops_after_commit(struct gfs2_sbd *sdp,
+				     struct gfs2_trans *tr)
 {
 	int x;
 	for (x = 0; gfs2_log_ops[x]; x++)
 		if (gfs2_log_ops[x]->lo_after_commit)
-			gfs2_log_ops[x]->lo_after_commit(sdp, ai);
+			gfs2_log_ops[x]->lo_after_commit(sdp, tr);
 }
 
 static inline void lops_before_scan(struct gfs2_jdesc *jd,
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index b059bbb..1a89afb 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -295,7 +295,7 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 	}
 	if (bd) {
 		spin_lock(&sdp->sd_ail_lock);
-		if (bd->bd_ail) {
+		if (bd->bd_tr) {
 			gfs2_remove_from_ail(bd);
 			bh->b_private = NULL;
 			bd->bd_bh = NULL;
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 88162fa..3bb4ac7 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -135,8 +135,10 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 	if (tr->tr_t_gh.gh_gl) {
 		gfs2_glock_dq(&tr->tr_t_gh);
 		gfs2_holder_uninit(&tr->tr_t_gh);
-		kfree(tr);
+		if (!tr->tr_attached)
+			kfree(tr);
 	}
+	up_read(&sdp->sd_log_flush_lock);
 
 	if (sdp->sd_vfs->s_flags & MS_SYNCHRONOUS)
 		gfs2_log_flush(sdp, NULL);
-- 
1.7.4

