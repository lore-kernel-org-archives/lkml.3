Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077AbaDAJQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaDAJQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:21 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/29] GFS2: Move log buffer accounting to transaction
Date: Tue,  1 Apr 2014 10:15:22 +0100
Message-Id: <1396343741-1524-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have a master transaction into which other transactions
are merged, the accounting can be done using this master
transaction. We no longer require the superblock fields which
were being used for this function.

In addition, this allows for a clean up in calc_reserved()
making it rather easier understand. Also, by reducing the
number of variables used to track the buffers being added
and removed from the journal, a number of error checks are
now no longer required.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 99aab64..d0c3928 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -748,15 +748,10 @@ struct gfs2_sbd {
 
 	struct gfs2_trans *sd_log_tr;
 	unsigned int sd_log_blks_reserved;
-	unsigned int sd_log_commited_buf;
-	unsigned int sd_log_commited_databuf;
 	int sd_log_commited_revoke;
 
 	atomic_t sd_log_pinned;
-	unsigned int sd_log_num_buf;
 	unsigned int sd_log_num_revoke;
-	unsigned int sd_log_num_rg;
-	unsigned int sd_log_num_databuf;
 
 	struct list_head sd_log_le_revoke;
 	struct list_head sd_log_le_ordered;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 975712c..c1c9a29 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -414,24 +414,22 @@ static inline unsigned int log_distance(struct gfs2_sbd *sdp, unsigned int newer
 static unsigned int calc_reserved(struct gfs2_sbd *sdp)
 {
 	unsigned int reserved = 0;
-	unsigned int mbuf_limit, metabufhdrs_needed;
-	unsigned int dbuf_limit, databufhdrs_needed;
-	unsigned int revokes = 0;
+	unsigned int mbuf;
+	unsigned int dbuf;
+	struct gfs2_trans *tr = sdp->sd_log_tr;
 
-	mbuf_limit = buf_limit(sdp);
-	metabufhdrs_needed = (sdp->sd_log_commited_buf +
-			      (mbuf_limit - 1)) / mbuf_limit;
-	dbuf_limit = databuf_limit(sdp);
-	databufhdrs_needed = (sdp->sd_log_commited_databuf +
-			      (dbuf_limit - 1)) / dbuf_limit;
+	if (tr) {
+		mbuf = tr->tr_num_buf_new - tr->tr_num_buf_rm;
+		dbuf = tr->tr_num_databuf_new - tr->tr_num_databuf_rm;
+		reserved = mbuf + dbuf;
+		/* Account for header blocks */
+		reserved += DIV_ROUND_UP(mbuf, buf_limit(sdp));
+		reserved += DIV_ROUND_UP(dbuf, databuf_limit(sdp));
+	}
 
 	if (sdp->sd_log_commited_revoke > 0)
-		revokes = gfs2_struct2blk(sdp, sdp->sd_log_commited_revoke,
+		reserved += gfs2_struct2blk(sdp, sdp->sd_log_commited_revoke,
 					  sizeof(u64));
-
-	reserved = sdp->sd_log_commited_buf + metabufhdrs_needed +
-		sdp->sd_log_commited_databuf + databufhdrs_needed +
-		revokes;
 	/* One for the overall header */
 	if (reserved)
 		reserved++;
@@ -693,16 +691,6 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 		INIT_LIST_HEAD(&tr->tr_ail2_list);
 	}
 
-	if (sdp->sd_log_num_buf != sdp->sd_log_commited_buf) {
-		printk(KERN_INFO "GFS2: log buf %u %u\n", sdp->sd_log_num_buf,
-		       sdp->sd_log_commited_buf);
-		gfs2_assert_withdraw(sdp, 0);
-	}
-	if (sdp->sd_log_num_databuf != sdp->sd_log_commited_databuf) {
-		printk(KERN_INFO "GFS2: log databuf %u %u\n",
-		       sdp->sd_log_num_databuf, sdp->sd_log_commited_databuf);
-		gfs2_assert_withdraw(sdp, 0);
-	}
 	gfs2_assert_withdraw(sdp,
 			sdp->sd_log_num_revoke == sdp->sd_log_commited_revoke);
 
@@ -727,8 +715,6 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	gfs2_log_lock(sdp);
 	sdp->sd_log_head = sdp->sd_log_flush_head;
 	sdp->sd_log_blks_reserved = 0;
-	sdp->sd_log_commited_buf = 0;
-	sdp->sd_log_commited_databuf = 0;
 	sdp->sd_log_commited_revoke = 0;
 
 	spin_lock(&sdp->sd_ail_lock);
@@ -769,31 +755,29 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	unsigned int reserved;
 	unsigned int unused;
+	unsigned int maxres;
 
 	gfs2_log_lock(sdp);
 
-	sdp->sd_log_commited_buf += tr->tr_num_buf_new - tr->tr_num_buf_rm;
-	sdp->sd_log_commited_databuf += tr->tr_num_databuf_new -
-		tr->tr_num_databuf_rm;
-	gfs2_assert_withdraw(sdp, (((int)sdp->sd_log_commited_buf) >= 0) ||
-			     (((int)sdp->sd_log_commited_databuf) >= 0));
+	if (sdp->sd_log_tr) {
+		gfs2_merge_trans(sdp->sd_log_tr, tr);
+	} else if (tr->tr_num_buf_new || tr->tr_num_databuf_new) {
+		gfs2_assert_withdraw(sdp, tr->tr_t_gh.gh_gl);
+		sdp->sd_log_tr = tr;
+		tr->tr_attached = 1;
+	}
+
 	sdp->sd_log_commited_revoke += tr->tr_num_revoke - tr->tr_num_revoke_rm;
 	reserved = calc_reserved(sdp);
-	gfs2_assert_withdraw(sdp, sdp->sd_log_blks_reserved + tr->tr_reserved >= reserved);
-	unused = sdp->sd_log_blks_reserved - reserved + tr->tr_reserved;
+	maxres = sdp->sd_log_blks_reserved + tr->tr_reserved;
+	gfs2_assert_withdraw(sdp, maxres >= reserved);
+	unused = maxres - reserved;
 	atomic_add(unused, &sdp->sd_log_blks_free);
 	trace_gfs2_log_blocks(sdp, unused);
 	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
 			     sdp->sd_jdesc->jd_blocks);
 	sdp->sd_log_blks_reserved = reserved;
 
-	if (sdp->sd_log_tr) {
-		gfs2_merge_trans(sdp->sd_log_tr, tr);
-	} else if (tr->tr_num_buf_new || tr->tr_num_databuf_new) {
-		gfs2_assert_withdraw(sdp, tr->tr_t_gh.gh_gl);
-		sdp->sd_log_tr = tr;
-		tr->tr_attached = 1;
-	}
 	gfs2_log_unlock(sdp);
 }
 
@@ -833,10 +817,7 @@ void gfs2_log_shutdown(struct gfs2_sbd *sdp)
 	down_write(&sdp->sd_log_flush_lock);
 
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_blks_reserved);
-	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_buf);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
-	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_rg);
-	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_databuf);
 	gfs2_assert_withdraw(sdp, list_empty(&sdp->sd_ail1_list));
 
 	sdp->sd_log_flush_head = sdp->sd_log_head;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index ee9ec7f..23c6e72 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -494,9 +494,11 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 static void buf_lo_before_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	unsigned int limit = buf_limit(sdp); /* 503 for 4k blocks */
+	unsigned int nbuf;
 	if (tr == NULL)
 		return;
-	gfs2_before_commit(sdp, limit, sdp->sd_log_num_buf, &tr->tr_buf, 0);
+	nbuf = tr->tr_num_buf_new - tr->tr_num_buf_rm;
+	gfs2_before_commit(sdp, limit, nbuf, &tr->tr_buf, 0);
 }
 
 static void buf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
@@ -511,11 +513,8 @@ static void buf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
-		sdp->sd_log_num_buf--;
-
 		gfs2_unpin(sdp, bd->bd_bh, tr);
 	}
-	gfs2_assert_warn(sdp, !sdp->sd_log_num_buf);
 }
 
 static void buf_lo_before_scan(struct gfs2_jdesc *jd,
@@ -761,10 +760,12 @@ static void revoke_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 
 static void databuf_lo_before_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
-	unsigned int limit = buf_limit(sdp) / 2;
+	unsigned int limit = databuf_limit(sdp);
+	unsigned int nbuf;
 	if (tr == NULL)
 		return;
-	gfs2_before_commit(sdp, limit, sdp->sd_log_num_databuf, &tr->tr_databuf, 1);
+	nbuf = tr->tr_num_databuf_new - tr->tr_num_databuf_rm;
+	gfs2_before_commit(sdp, limit, nbuf, &tr->tr_databuf, 1);
 }
 
 static int databuf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
@@ -849,10 +850,8 @@ static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_list);
 		list_del_init(&bd->bd_list);
-		sdp->sd_log_num_databuf--;
 		gfs2_unpin(sdp, bd->bd_bh, tr);
 	}
-	gfs2_assert_warn(sdp, !sdp->sd_log_num_databuf);
 }
 
 
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index c7f2469..005e468 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -267,15 +267,10 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 		trace_gfs2_pin(bd, 0);
 		atomic_dec(&sdp->sd_log_pinned);
 		list_del_init(&bd->bd_list);
-		if (meta) {
-			gfs2_assert_warn(sdp, sdp->sd_log_num_buf);
-			sdp->sd_log_num_buf--;
+		if (meta)
 			tr->tr_num_buf_rm++;
-		} else {
-			gfs2_assert_warn(sdp, sdp->sd_log_num_databuf);
-			sdp->sd_log_num_databuf--;
+		else
 			tr->tr_num_databuf_rm++;
-		}
 		tr->tr_touched = 1;
 		was_pinned = 1;
 		brelse(bh);
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index e0464a2..295f400 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -213,7 +213,6 @@ void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
 		set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
-		sdp->sd_log_num_databuf++;
 		list_add_tail(&bd->bd_list, &tr->tr_databuf);
 	}
 	gfs2_log_unlock(sdp);
@@ -241,7 +240,6 @@ static void meta_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	gfs2_pin(sdp, bd->bd_bh);
 	mh->__pad0 = cpu_to_be64(0);
 	mh->mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
-	sdp->sd_log_num_buf++;
 	list_add(&bd->bd_list, &tr->tr_buf);
 	tr->tr_num_buf_new++;
 }
-- 
1.8.3.1

