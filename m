Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab3BSKeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:34:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600Ab3BSKeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:08 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/10] GFS2: Merge gfs2_attach_bufdata() into trans.c
Date: Tue, 19 Feb 2013 10:07:35 +0000
Message-Id: <1361268460-3092-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The locking in gfs2_attach_bufdata() was type specific (data/meta)
which made the function rather confusing. This patch moves the core
of gfs2_attach_bufdata() into trans.c renaming it gfs2_alloc_bufdata()
and moving the locking into gfs2_trans_add_data()/gfs2_trans_add_meta()

As a result all of the locking related to adding data and metadata to
the journal is now in these two functions. This should help to clarify
what is going on, and give us some opportunities to simplify in
some cases.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index d85b376..ba77b7d 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -47,13 +47,6 @@ static inline unsigned int databuf_limit(struct gfs2_sbd *sdp)
 	return limit;
 }
 
-static inline void lops_init_le(struct gfs2_bufdata *bd,
-				const struct gfs2_log_operations *lops)
-{
-	INIT_LIST_HEAD(&bd->bd_list);
-	bd->bd_ops = lops;
-}
-
 static inline void lops_before_commit(struct gfs2_sbd *sdp)
 {
 	int x;
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 22255d9..b059bbb 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -271,41 +271,6 @@ int gfs2_meta_wait(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	return 0;
 }
 
-/**
- * gfs2_attach_bufdata - attach a struct gfs2_bufdata structure to a buffer
- * @gl: the glock the buffer belongs to
- * @bh: The buffer to be attached to
- * @meta: Flag to indicate whether its metadata or not
- */
-
-void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
-			 int meta)
-{
-	struct gfs2_bufdata *bd;
-
-	if (meta)
-		lock_page(bh->b_page);
-
-	if (bh->b_private) {
-		if (meta)
-			unlock_page(bh->b_page);
-		return;
-	}
-
-	bd = kmem_cache_zalloc(gfs2_bufdata_cachep, GFP_NOFS | __GFP_NOFAIL);
-	bd->bd_bh = bh;
-	bd->bd_gl = gl;
-
-	if (meta)
-		lops_init_le(bd, &gfs2_buf_lops);
-	else
-		lops_init_le(bd, &gfs2_databuf_lops);
-	bh->b_private = bd;
-
-	if (meta)
-		unlock_page(bh->b_page);
-}
-
 void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int meta)
 {
 	struct address_space *mapping = bh->b_page->mapping;
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index c30973b..0d4c843 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -56,9 +56,6 @@ int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno,
 int gfs2_meta_wait(struct gfs2_sbd *sdp, struct buffer_head *bh);
 struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl, u64 blkno, int create);
 
-void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
-			 int meta);
-
 void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr,
 			      int meta);
 
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 1fbd57e..14dbf6d 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -143,6 +143,21 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 	sb_end_intwrite(sdp->sd_vfs);
 }
 
+static struct gfs2_bufdata *gfs2_alloc_bufdata(struct gfs2_glock *gl,
+					       struct buffer_head *bh,
+					       const struct gfs2_log_operations *lops)
+{
+	struct gfs2_bufdata *bd;
+
+	bd = kmem_cache_zalloc(gfs2_bufdata_cachep, GFP_NOFS | __GFP_NOFAIL);
+	bd->bd_bh = bh;
+	bd->bd_gl = gl;
+	bd->bd_ops = lops;
+	INIT_LIST_HEAD(&bd->bd_list);
+	bh->b_private = bd;
+	return bd;
+}
+
 /**
  * databuf_lo_add - Add a databuf to the transaction.
  *
@@ -190,16 +205,15 @@ void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
 	lock_buffer(bh);
 	gfs2_log_lock(sdp);
 	bd = bh->b_private;
-	if (bd)
-		gfs2_assert(sdp, bd->bd_gl == gl);
-	else {
+	if (bd == NULL) {
 		gfs2_log_unlock(sdp);
 		unlock_buffer(bh);
-		gfs2_attach_bufdata(gl, bh, 0);
-		bd = bh->b_private;
+		if (bh->b_private == NULL)
+			bd = gfs2_alloc_bufdata(gl, bh, &gfs2_databuf_lops);
 		lock_buffer(bh);
 		gfs2_log_lock(sdp);
 	}
+	gfs2_assert(sdp, bd->bd_gl == gl);
 	databuf_lo_add(sdp, bd);
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
@@ -240,16 +254,17 @@ void gfs2_trans_add_meta(struct gfs2_glock *gl, struct buffer_head *bh)
 	lock_buffer(bh);
 	gfs2_log_lock(sdp);
 	bd = bh->b_private;
-	if (bd)
-		gfs2_assert(sdp, bd->bd_gl == gl);
-	else {
+	if (bd == NULL) {
 		gfs2_log_unlock(sdp);
 		unlock_buffer(bh);
-		gfs2_attach_bufdata(gl, bh, 1);
-		bd = bh->b_private;
+		lock_page(bh->b_page);
+		if (bh->b_private == NULL)
+			bd = gfs2_alloc_bufdata(gl, bh, &gfs2_buf_lops);
+		unlock_page(bh->b_page);
 		lock_buffer(bh);
 		gfs2_log_lock(sdp);
 	}
+	gfs2_assert(sdp, bd->bd_gl == gl);
 	meta_lo_add(sdp, bd);
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
@@ -263,7 +278,7 @@ void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	BUG_ON(!list_empty(&bd->bd_list));
 	BUG_ON(!list_empty(&bd->bd_ail_st_list));
 	BUG_ON(!list_empty(&bd->bd_ail_gl_list));
-	lops_init_le(bd, &gfs2_revoke_lops);
+	bd->bd_ops = &gfs2_revoke_lops;
 	tr->tr_touched = 1;
 	tr->tr_num_revoke++;
 	sdp->sd_log_num_revoke++;
-- 
1.7.4

