Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab3BSKgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:36:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab3BSKeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:11 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/10] GFS2: Use ->writepages for ordered writes
Date: Tue, 19 Feb 2013 10:07:37 +0000
Message-Id: <1361268460-3092-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using a list of buffers to write ahead of the journal
flush, this now uses a list of inodes and calls ->writepages
via filemap_fdatawrite() in order to achieve the same thing. For
most use cases this results in a shorter ordered write list,
as well as much larger i/os being issued.

The ordered write list is sorted by inode number before writing
in order to retain the disk block ordering between inodes as
per the previous code.

The previous ordered write code used to conflict in its assumptions
about how to write out the disk blocks with mpage_writepages()
so that with this updated version we can also use mpage_writepages()
for GFS2's ordered write, writepages implementation. So we will
also send larger i/os from writeback too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 92340dd..24f414f 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -230,16 +230,14 @@ out_ignore:
 }
 
 /**
- * gfs2_writeback_writepages - Write a bunch of dirty pages back to disk
+ * gfs2_writepages - Write a bunch of dirty pages back to disk
  * @mapping: The mapping to write
  * @wbc: Write-back control
  *
- * For the data=writeback case we can already ignore buffer heads
- * and write whole extents at once. This is a big reduction in the
- * number of I/O requests we send and the bmap calls we make in this case.
+ * Used for both ordered and writeback modes.
  */
-static int gfs2_writeback_writepages(struct address_space *mapping,
-				     struct writeback_control *wbc)
+static int gfs2_writepages(struct address_space *mapping,
+			   struct writeback_control *wbc)
 {
 	return mpage_writepages(mapping, wbc, gfs2_get_block_noalloc);
 }
@@ -1102,7 +1100,7 @@ cannot_release:
 
 static const struct address_space_operations gfs2_writeback_aops = {
 	.writepage = gfs2_writeback_writepage,
-	.writepages = gfs2_writeback_writepages,
+	.writepages = gfs2_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
 	.write_begin = gfs2_write_begin,
@@ -1118,6 +1116,7 @@ static const struct address_space_operations gfs2_writeback_aops = {
 
 static const struct address_space_operations gfs2_ordered_aops = {
 	.writepage = gfs2_ordered_writepage,
+	.writepages = gfs2_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
 	.write_begin = gfs2_write_begin,
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 7a86275..d29d779 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -22,6 +22,7 @@
 #include "meta_io.h"
 #include "quota.h"
 #include "rgrp.h"
+#include "log.h"
 #include "super.h"
 #include "trans.h"
 #include "dir.h"
@@ -1137,6 +1138,7 @@ static int trunc_end(struct gfs2_inode *ip)
 		ip->i_height = 0;
 		ip->i_goal = ip->i_no_addr;
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
+		gfs2_ordered_del_inode(ip);
 	}
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 	ip->i_diskflags &= ~GFS2_DIF_TRUNC_IN_PROG;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 19750bc..1533cf8 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -340,6 +340,7 @@ enum {
 	GIF_QD_LOCKED		= 1,
 	GIF_ALLOC_FAILED	= 2,
 	GIF_SW_PAGED		= 3,
+	GIF_ORDERED		= 4,
 };
 
 struct gfs2_inode {
@@ -356,6 +357,7 @@ struct gfs2_inode {
 	struct gfs2_rgrpd *i_rgd;
 	u64 i_goal;	/* goal block for allocations */
 	struct rw_semaphore i_rw_mutex;
+	struct list_head i_ordered;
 	struct list_head i_trunc_list;
 	__be64 *i_hash_cache;
 	u32 i_entries;
@@ -722,6 +724,7 @@ struct gfs2_sbd {
 	struct list_head sd_log_le_revoke;
 	struct list_head sd_log_le_databuf;
 	struct list_head sd_log_le_ordered;
+	spinlock_t sd_ordered_lock;
 
 	atomic_t sd_log_thresh1;
 	atomic_t sd_log_thresh2;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index f4beeb9..9a2ca8b 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -482,70 +482,66 @@ static void log_flush_wait(struct gfs2_sbd *sdp)
 	}
 }
 
-static int bd_cmp(void *priv, struct list_head *a, struct list_head *b)
+static int ip_cmp(void *priv, struct list_head *a, struct list_head *b)
 {
-	struct gfs2_bufdata *bda, *bdb;
+	struct gfs2_inode *ipa, *ipb;
 
-	bda = list_entry(a, struct gfs2_bufdata, bd_list);
-	bdb = list_entry(b, struct gfs2_bufdata, bd_list);
+	ipa = list_entry(a, struct gfs2_inode, i_ordered);
+	ipb = list_entry(b, struct gfs2_inode, i_ordered);
 
-	if (bda->bd_bh->b_blocknr < bdb->bd_bh->b_blocknr)
+	if (ipa->i_no_addr < ipb->i_no_addr)
 		return -1;
-	if (bda->bd_bh->b_blocknr > bdb->bd_bh->b_blocknr)
+	if (ipa->i_no_addr > ipb->i_no_addr)
 		return 1;
 	return 0;
 }
 
 static void gfs2_ordered_write(struct gfs2_sbd *sdp)
 {
-	struct gfs2_bufdata *bd;
-	struct buffer_head *bh;
+	struct gfs2_inode *ip;
 	LIST_HEAD(written);
 
-	gfs2_log_lock(sdp);
-	list_sort(NULL, &sdp->sd_log_le_ordered, &bd_cmp);
+	spin_lock(&sdp->sd_ordered_lock);
+	list_sort(NULL, &sdp->sd_log_le_ordered, &ip_cmp);
 	while (!list_empty(&sdp->sd_log_le_ordered)) {
-		bd = list_entry(sdp->sd_log_le_ordered.next, struct gfs2_bufdata, bd_list);
-		list_move(&bd->bd_list, &written);
-		bh = bd->bd_bh;
-		if (!buffer_dirty(bh))
+		ip = list_entry(sdp->sd_log_le_ordered.next, struct gfs2_inode, i_ordered);
+		list_move(&ip->i_ordered, &written);
+		if (ip->i_inode.i_mapping->nrpages == 0)
 			continue;
-		get_bh(bh);
-		gfs2_log_unlock(sdp);
-		lock_buffer(bh);
-		if (buffer_mapped(bh) && test_clear_buffer_dirty(bh)) {
-			bh->b_end_io = end_buffer_write_sync;
-			submit_bh(WRITE_SYNC, bh);
-		} else {
-			unlock_buffer(bh);
-			brelse(bh);
-		}
-		gfs2_log_lock(sdp);
+		spin_unlock(&sdp->sd_ordered_lock);
+		filemap_fdatawrite(ip->i_inode.i_mapping);
+		spin_lock(&sdp->sd_ordered_lock);
 	}
 	list_splice(&written, &sdp->sd_log_le_ordered);
-	gfs2_log_unlock(sdp);
+	spin_unlock(&sdp->sd_ordered_lock);
 }
 
 static void gfs2_ordered_wait(struct gfs2_sbd *sdp)
 {
-	struct gfs2_bufdata *bd;
-	struct buffer_head *bh;
+	struct gfs2_inode *ip;
 
-	gfs2_log_lock(sdp);
+	spin_lock(&sdp->sd_ordered_lock);
 	while (!list_empty(&sdp->sd_log_le_ordered)) {
-		bd = list_entry(sdp->sd_log_le_ordered.prev, struct gfs2_bufdata, bd_list);
-		bh = bd->bd_bh;
-		if (buffer_locked(bh)) {
-			get_bh(bh);
-			gfs2_log_unlock(sdp);
-			wait_on_buffer(bh);
-			brelse(bh);
-			gfs2_log_lock(sdp);
+		ip = list_entry(sdp->sd_log_le_ordered.next, struct gfs2_inode, i_ordered);
+		list_del(&ip->i_ordered);
+		WARN_ON(!test_and_clear_bit(GIF_ORDERED, &ip->i_flags));
+		if (ip->i_inode.i_mapping->nrpages == 0)
 			continue;
-		}
-		list_del_init(&bd->bd_list);
+		spin_unlock(&sdp->sd_ordered_lock);
+		filemap_fdatawait(ip->i_inode.i_mapping);
+		spin_lock(&sdp->sd_ordered_lock);
 	}
-	gfs2_log_unlock(sdp);
+	spin_unlock(&sdp->sd_ordered_lock);
+}
+
+void gfs2_ordered_del_inode(struct gfs2_inode *ip)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+
+	spin_lock(&sdp->sd_ordered_lock);
+	if (test_and_clear_bit(GIF_ORDERED, &ip->i_flags))
+		list_del(&ip->i_ordered);
+	spin_unlock(&sdp->sd_ordered_lock);
 }
 
 /**
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 3fd5215..3566f35 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -48,6 +48,18 @@ static inline void gfs2_log_pointers_init(struct gfs2_sbd *sdp,
 	sdp->sd_log_head = sdp->sd_log_tail = value;
 }
 
+static inline void gfs2_ordered_add_inode(struct gfs2_inode *ip)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+
+	if (!test_bit(GIF_ORDERED, &ip->i_flags)) {
+		spin_lock(&sdp->sd_ordered_lock);
+		if (!test_and_set_bit(GIF_ORDERED, &ip->i_flags))
+			list_add(&ip->i_ordered, &sdp->sd_log_le_ordered);
+		spin_unlock(&sdp->sd_ordered_lock);
+	}
+}
+extern void gfs2_ordered_del_inode(struct gfs2_inode *ip);
 extern unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 			    unsigned int ssize);
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 5f5aba5..e063f22 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -102,6 +102,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	INIT_LIST_HEAD(&sdp->sd_log_le_revoke);
 	INIT_LIST_HEAD(&sdp->sd_log_le_databuf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_ordered);
+	spin_lock_init(&sdp->sd_ordered_lock);
 
 	init_waitqueue_head(&sdp->sd_log_waitq);
 	init_waitqueue_head(&sdp->sd_logd_waitq);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index c075b62..a3b40ee 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1524,6 +1524,7 @@ out:
 	/* Case 3 starts here */
 	truncate_inode_pages(&inode->i_data, 0);
 	gfs2_rs_delete(ip);
+	gfs2_ordered_del_inode(ip);
 	clear_inode(inode);
 	gfs2_dir_hash_inval(ip);
 	ip->i_gl->gl_object = NULL;
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 14dbf6d..88162fa 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -159,7 +159,9 @@ static struct gfs2_bufdata *gfs2_alloc_bufdata(struct gfs2_glock *gl,
 }
 
 /**
- * databuf_lo_add - Add a databuf to the transaction.
+ * gfs2_trans_add_data - Add a databuf to the transaction.
+ * @gl: The inode glock associated with the buffer
+ * @bh: The buffer to add
  *
  * This is used in two distinct cases:
  * i) In ordered write mode
@@ -174,33 +176,18 @@ static struct gfs2_bufdata *gfs2_alloc_bufdata(struct gfs2_glock *gl,
  *    blocks, which isn't an enormous overhead but twice as much as
  *    for normal metadata blocks.
  */
-static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
+void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
 {
 	struct gfs2_trans *tr = current->journal_info;
-	struct address_space *mapping = bd->bd_bh->b_page->mapping;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct address_space *mapping = bh->b_page->mapping;
 	struct gfs2_inode *ip = GFS2_I(mapping->host);
+	struct gfs2_bufdata *bd;
 
-	if (tr)
-		tr->tr_touched = 1;
-	if (!list_empty(&bd->bd_list))
+	if (!gfs2_is_jdata(ip)) {
+		gfs2_ordered_add_inode(ip);
 		return;
-	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
-	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
-	if (gfs2_is_jdata(ip)) {
-		gfs2_pin(sdp, bd->bd_bh);
-		tr->tr_num_databuf_new++;
-		sdp->sd_log_num_databuf++;
-		list_add_tail(&bd->bd_list, &sdp->sd_log_le_databuf);
-	} else {
-		list_add_tail(&bd->bd_list, &sdp->sd_log_le_ordered);
 	}
-}
-
-void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
-{
-
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	struct gfs2_bufdata *bd;
 
 	lock_buffer(bh);
 	gfs2_log_lock(sdp);
@@ -214,7 +201,15 @@ void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
 		gfs2_log_lock(sdp);
 	}
 	gfs2_assert(sdp, bd->bd_gl == gl);
-	databuf_lo_add(sdp, bd);
+	tr->tr_touched = 1;
+	if (list_empty(&bd->bd_list)) {
+		set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
+		set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
+		gfs2_pin(sdp, bd->bd_bh);
+		tr->tr_num_databuf_new++;
+		sdp->sd_log_num_databuf++;
+		list_add_tail(&bd->bd_list, &sdp->sd_log_le_databuf);
+	}
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
 }
-- 
1.7.4

