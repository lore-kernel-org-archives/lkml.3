Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab3BSKge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:36:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607Ab3BSKeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:06 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/10] GFS2: Copy gfs2_trans_add_bh into new data/meta functions
Date: Tue, 19 Feb 2013 10:07:34 +0000
Message-Id: <1361268460-3092-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch copies the body of gfs2_trans_add_bh into the two newly
added gfs2_trans_add_data and gfs2_trans_add_meta functions. We can
then move the .lo_add functions from lops.c into trans.c and call
them directly.

As a result of this, we no longer need to use the .lo_add functions
at all, so that is removed from the log operations structure.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index c373a24..5d129ab 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -52,7 +52,6 @@ struct gfs2_log_header_host {
  */
 
 struct gfs2_log_operations {
-	void (*lo_add) (struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
 	void (*lo_before_commit) (struct gfs2_sbd *sdp);
 	void (*lo_after_commit) (struct gfs2_sbd *sdp, struct gfs2_ail *ai);
 	void (*lo_before_scan) (struct gfs2_jdesc *jd,
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9c80742..a505597 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -37,7 +37,7 @@
  *
  * The log lock must be held when calling this function
  */
-static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
+void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 {
 	struct gfs2_bufdata *bd;
 
@@ -388,32 +388,6 @@ static struct page *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type,
 	return page;
 }
 
-static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
-{
-	struct gfs2_meta_header *mh;
-	struct gfs2_trans *tr;
-
-	tr = current->journal_info;
-	tr->tr_touched = 1;
-	if (!list_empty(&bd->bd_list))
-		return;
-	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
-	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
-	mh = (struct gfs2_meta_header *)bd->bd_bh->b_data;
-	if (unlikely(mh->mh_magic != cpu_to_be32(GFS2_MAGIC))) {
-		printk(KERN_ERR
-		       "Attempting to add uninitialised block to journal (inplace block=%lld)\n",
-		       (unsigned long long)bd->bd_bh->b_blocknr);
-		BUG();
-	}
-	gfs2_pin(sdp, bd->bd_bh);
-	mh->__pad0 = cpu_to_be64(0);
-	mh->mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
-	sdp->sd_log_num_buf++;
-	list_add(&bd->bd_list, &sdp->sd_log_le_buf);
-	tr->tr_num_buf_new++;
-}
-
 static void gfs2_check_magic(struct buffer_head *bh)
 {
 	void *kaddr;
@@ -735,44 +709,6 @@ static void revoke_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 }
 
 /**
- * databuf_lo_add - Add a databuf to the transaction.
- *
- * This is used in two distinct cases:
- * i) In ordered write mode
- *    We put the data buffer on a list so that we can ensure that its
- *    synced to disk at the right time
- * ii) In journaled data mode
- *    We need to journal the data block in the same way as metadata in
- *    the functions above. The difference is that here we have a tag
- *    which is two __be64's being the block number (as per meta data)
- *    and a flag which says whether the data block needs escaping or
- *    not. This means we need a new log entry for each 251 or so data
- *    blocks, which isn't an enormous overhead but twice as much as
- *    for normal metadata blocks.
- */
-static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
-{
-	struct gfs2_trans *tr = current->journal_info;
-	struct address_space *mapping = bd->bd_bh->b_page->mapping;
-	struct gfs2_inode *ip = GFS2_I(mapping->host);
-
-	if (tr)
-		tr->tr_touched = 1;
-	if (!list_empty(&bd->bd_list))
-		return;
-	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
-	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
-	if (gfs2_is_jdata(ip)) {
-		gfs2_pin(sdp, bd->bd_bh);
-		tr->tr_num_databuf_new++;
-		sdp->sd_log_num_databuf++;
-		list_add_tail(&bd->bd_list, &sdp->sd_log_le_databuf);
-	} else {
-		list_add_tail(&bd->bd_list, &sdp->sd_log_le_ordered);
-	}
-}
-
-/**
  * databuf_lo_before_commit - Scan the data buffers, writing as we go
  *
  */
@@ -871,7 +807,6 @@ static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 
 
 const struct gfs2_log_operations gfs2_buf_lops = {
-	.lo_add = buf_lo_add,
 	.lo_before_commit = buf_lo_before_commit,
 	.lo_after_commit = buf_lo_after_commit,
 	.lo_before_scan = buf_lo_before_scan,
@@ -894,7 +829,6 @@ const struct gfs2_log_operations gfs2_rg_lops = {
 };
 
 const struct gfs2_log_operations gfs2_databuf_lops = {
-	.lo_add = databuf_lo_add,
 	.lo_before_commit = databuf_lo_before_commit,
 	.lo_after_commit = databuf_lo_after_commit,
 	.lo_scan_elements = databuf_lo_scan_elements,
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index 954a330..d85b376 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -29,6 +29,7 @@ extern const struct gfs2_log_operations gfs2_databuf_lops;
 extern const struct gfs2_log_operations *gfs2_log_ops[];
 extern void gfs2_log_write_page(struct gfs2_sbd *sdp, struct page *page);
 extern void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int rw);
+extern void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh);
 
 static inline unsigned int buf_limit(struct gfs2_sbd *sdp)
 {
@@ -53,12 +54,6 @@ static inline void lops_init_le(struct gfs2_bufdata *bd,
 	bd->bd_ops = lops;
 }
 
-static inline void lops_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
-{
-	if (bd->bd_ops->lo_add)
-		bd->bd_ops->lo_add(sdp, bd);
-}
-
 static inline void lops_before_commit(struct gfs2_sbd *sdp)
 {
 	int x;
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index cb795ac..1fbd57e 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -18,6 +18,7 @@
 #include "gfs2.h"
 #include "incore.h"
 #include "glock.h"
+#include "inode.h"
 #include "log.h"
 #include "lops.h"
 #include "meta_io.h"
@@ -143,15 +144,46 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 }
 
 /**
- * gfs2_trans_add_bh - Add a to-be-modified buffer to the current transaction
- * @gl: the glock the buffer belongs to
- * @bh: The buffer to add
- * @meta: True in the case of adding metadata
+ * databuf_lo_add - Add a databuf to the transaction.
  *
+ * This is used in two distinct cases:
+ * i) In ordered write mode
+ *    We put the data buffer on a list so that we can ensure that its
+ *    synced to disk at the right time
+ * ii) In journaled data mode
+ *    We need to journal the data block in the same way as metadata in
+ *    the functions above. The difference is that here we have a tag
+ *    which is two __be64's being the block number (as per meta data)
+ *    and a flag which says whether the data block needs escaping or
+ *    not. This means we need a new log entry for each 251 or so data
+ *    blocks, which isn't an enormous overhead but twice as much as
+ *    for normal metadata blocks.
  */
+static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
+{
+	struct gfs2_trans *tr = current->journal_info;
+	struct address_space *mapping = bd->bd_bh->b_page->mapping;
+	struct gfs2_inode *ip = GFS2_I(mapping->host);
+
+	if (tr)
+		tr->tr_touched = 1;
+	if (!list_empty(&bd->bd_list))
+		return;
+	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
+	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
+	if (gfs2_is_jdata(ip)) {
+		gfs2_pin(sdp, bd->bd_bh);
+		tr->tr_num_databuf_new++;
+		sdp->sd_log_num_databuf++;
+		list_add_tail(&bd->bd_list, &sdp->sd_log_le_databuf);
+	} else {
+		list_add_tail(&bd->bd_list, &sdp->sd_log_le_ordered);
+	}
+}
 
-static void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
+void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
 {
+
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct gfs2_bufdata *bd;
 
@@ -163,24 +195,64 @@ static void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int
 	else {
 		gfs2_log_unlock(sdp);
 		unlock_buffer(bh);
-		gfs2_attach_bufdata(gl, bh, meta);
+		gfs2_attach_bufdata(gl, bh, 0);
 		bd = bh->b_private;
 		lock_buffer(bh);
 		gfs2_log_lock(sdp);
 	}
-	lops_add(sdp, bd);
+	databuf_lo_add(sdp, bd);
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
 }
 
-void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
+static void meta_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
-	return gfs2_trans_add_bh(gl, bh, 0);
+	struct gfs2_meta_header *mh;
+	struct gfs2_trans *tr;
+
+	tr = current->journal_info;
+	tr->tr_touched = 1;
+	if (!list_empty(&bd->bd_list))
+		return;
+	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
+	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
+	mh = (struct gfs2_meta_header *)bd->bd_bh->b_data;
+	if (unlikely(mh->mh_magic != cpu_to_be32(GFS2_MAGIC))) {
+		printk(KERN_ERR
+		       "Attempting to add uninitialised block to journal (inplace block=%lld)\n",
+		       (unsigned long long)bd->bd_bh->b_blocknr);
+		BUG();
+	}
+	gfs2_pin(sdp, bd->bd_bh);
+	mh->__pad0 = cpu_to_be64(0);
+	mh->mh_jid = cpu_to_be32(sdp->sd_jdesc->jd_jid);
+	sdp->sd_log_num_buf++;
+	list_add(&bd->bd_list, &sdp->sd_log_le_buf);
+	tr->tr_num_buf_new++;
 }
 
 void gfs2_trans_add_meta(struct gfs2_glock *gl, struct buffer_head *bh)
 {
-	return gfs2_trans_add_bh(gl, bh, 1);
+
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct gfs2_bufdata *bd;
+
+	lock_buffer(bh);
+	gfs2_log_lock(sdp);
+	bd = bh->b_private;
+	if (bd)
+		gfs2_assert(sdp, bd->bd_gl == gl);
+	else {
+		gfs2_log_unlock(sdp);
+		unlock_buffer(bh);
+		gfs2_attach_bufdata(gl, bh, 1);
+		bd = bh->b_private;
+		lock_buffer(bh);
+		gfs2_log_lock(sdp);
+	}
+	meta_lo_add(sdp, bd);
+	gfs2_log_unlock(sdp);
+	unlock_buffer(bh);
 }
 
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
-- 
1.7.4

