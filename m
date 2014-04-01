Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaDAJWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbaDAJQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:28 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/29] GFS2: Clean up journal extent mapping
Date: Tue,  1 Apr 2014 10:15:26 +0100
Message-Id: <1396343741-1524-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a long standing issue in mapping the journal
extents. Most journals will consist of only a single extent,
and although the cache took account of that by merging extents,
it did not actually map large extents, but instead was doing a
block by block mapping. Since the journal was only being mapped
on mount, this was not normally noticeable.

With the updated code, it is now possible to use the same extent
mapping system during journal recovery (which will be added in a
later patch). This will allow checking of the integrity of the
journal before any reply of the journal content is attempted. For
this reason the code is moving to bmap.c, since it will be used
more widely in due course.

An exercise left for the reader is to compare the new function
gfs2_map_journal_extents() with gfs2_write_alloc_required()

Additionally, should there be a failure, the error reporting is
also updated to show more detail about what went wrong.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index fe0500c..c62d4b9 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1328,6 +1328,121 @@ int gfs2_file_dealloc(struct gfs2_inode *ip)
 }
 
 /**
+ * gfs2_free_journal_extents - Free cached journal bmap info
+ * @jd: The journal
+ *
+ */
+
+void gfs2_free_journal_extents(struct gfs2_jdesc *jd)
+{
+	struct gfs2_journal_extent *jext;
+
+	while(!list_empty(&jd->extent_list)) {
+		jext = list_entry(jd->extent_list.next, struct gfs2_journal_extent, list);
+		list_del(&jext->list);
+		kfree(jext);
+	}
+}
+
+/**
+ * gfs2_add_jextent - Add or merge a new extent to extent cache
+ * @jd: The journal descriptor
+ * @lblock: The logical block at start of new extent
+ * @pblock: The physical block at start of new extent
+ * @blocks: Size of extent in fs blocks
+ *
+ * Returns: 0 on success or -ENOMEM
+ */
+
+static int gfs2_add_jextent(struct gfs2_jdesc *jd, u64 lblock, u64 dblock, u64 blocks)
+{
+	struct gfs2_journal_extent *jext;
+
+	if (!list_empty(&jd->extent_list)) {
+		jext = list_entry(jd->extent_list.prev, struct gfs2_journal_extent, list);
+		if ((jext->dblock + jext->blocks) == dblock) {
+			jext->blocks += blocks;
+			return 0;
+		}
+	}
+
+	jext = kzalloc(sizeof(struct gfs2_journal_extent), GFP_NOFS);
+	if (jext == NULL)
+		return -ENOMEM;
+	jext->dblock = dblock;
+	jext->lblock = lblock;
+	jext->blocks = blocks;
+	list_add_tail(&jext->list, &jd->extent_list);
+	jd->nr_extents++;
+	return 0;
+}
+
+/**
+ * gfs2_map_journal_extents - Cache journal bmap info
+ * @sdp: The super block
+ * @jd: The journal to map
+ *
+ * Create a reusable "extent" mapping from all logical
+ * blocks to all physical blocks for the given journal.  This will save
+ * us time when writing journal blocks.  Most journals will have only one
+ * extent that maps all their logical blocks.  That's because gfs2.mkfs
+ * arranges the journal blocks sequentially to maximize performance.
+ * So the extent would map the first block for the entire file length.
+ * However, gfs2_jadd can happen while file activity is happening, so
+ * those journals may not be sequential.  Less likely is the case where
+ * the users created their own journals by mounting the metafs and
+ * laying it out.  But it's still possible.  These journals might have
+ * several extents.
+ *
+ * Returns: 0 on success, or error on failure
+ */
+
+int gfs2_map_journal_extents(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd)
+{
+	u64 lblock = 0;
+	u64 lblock_stop;
+	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
+	struct buffer_head bh;
+	unsigned int shift = sdp->sd_sb.sb_bsize_shift;
+	u64 size;
+	int rc;
+
+	lblock_stop = i_size_read(jd->jd_inode) >> shift;
+	size = (lblock_stop - lblock) << shift;
+	jd->nr_extents = 0;
+	WARN_ON(!list_empty(&jd->extent_list));
+
+	do {
+		bh.b_state = 0;
+		bh.b_blocknr = 0;
+		bh.b_size = size;
+		rc = gfs2_block_map(jd->jd_inode, lblock, &bh, 0);
+		if (rc || !buffer_mapped(&bh))
+			goto fail;
+		rc = gfs2_add_jextent(jd, lblock, bh.b_blocknr, bh.b_size >> shift);
+		if (rc)
+			goto fail;
+		size -= bh.b_size;
+		lblock += (bh.b_size >> ip->i_inode.i_blkbits);
+	} while(size > 0);
+
+	fs_info(sdp, "journal %d mapped with %u extents\n", jd->jd_jid,
+		jd->nr_extents);
+	return 0;
+
+fail:
+	fs_warn(sdp, "error %d mapping journal %u at offset %llu (extent %u)\n",
+		rc, jd->jd_jid,
+		(unsigned long long)(i_size_read(jd->jd_inode) - size),
+		jd->nr_extents);
+	fs_warn(sdp, "bmap=%d lblock=%llu block=%llu, state=0x%08lx, size=%llu\n",
+		rc, (unsigned long long)lblock, (unsigned long long)bh.b_blocknr,
+		bh.b_state, (unsigned long long)bh.b_size);
+	gfs2_free_journal_extents(jd);
+	return rc;
+}
+
+/**
  * gfs2_write_alloc_required - figure out if a write will require an allocation
  * @ip: the file being written to
  * @offset: the offset to write to
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index 42fea03..81ded5e 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -55,5 +55,7 @@ extern int gfs2_truncatei_resume(struct gfs2_inode *ip);
 extern int gfs2_file_dealloc(struct gfs2_inode *ip);
 extern int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 				     unsigned int len);
+extern int gfs2_map_journal_extents(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd);
+extern void gfs2_free_journal_extents(struct gfs2_jdesc *jd);
 
 #endif /* __BMAP_DOT_H__ */
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index d0c3928..456d8fa 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -485,7 +485,7 @@ struct gfs2_trans {
 };
 
 struct gfs2_journal_extent {
-	struct list_head extent_list;
+	struct list_head list;
 
 	unsigned int lblock; /* First logical block */
 	u64 dblock; /* First disk block */
@@ -495,6 +495,7 @@ struct gfs2_journal_extent {
 struct gfs2_jdesc {
 	struct list_head jd_list;
 	struct list_head extent_list;
+	unsigned int nr_extents;
 	struct work_struct jd_work;
 	struct inode *jd_inode;
 	unsigned long jd_flags;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 23c6e72..ae1d635 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -146,8 +146,8 @@ static u64 gfs2_log_bmap(struct gfs2_sbd *sdp)
 	struct gfs2_journal_extent *je;
 	u64 block;
 
-	list_for_each_entry(je, &sdp->sd_jdesc->extent_list, extent_list) {
-		if (lbn >= je->lblock && lbn < je->lblock + je->blocks) {
+	list_for_each_entry(je, &sdp->sd_jdesc->extent_list, list) {
+		if ((lbn >= je->lblock) && (lbn < (je->lblock + je->blocks))) {
 			block = je->dblock + lbn - je->lblock;
 			gfs2_log_incr_head(sdp);
 			return block;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 1f855a7..e0d0db5 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -517,67 +517,6 @@ out:
 	return ret;
 }
 
-/**
- * map_journal_extents - create a reusable "extent" mapping from all logical
- * blocks to all physical blocks for the given journal.  This will save
- * us time when writing journal blocks.  Most journals will have only one
- * extent that maps all their logical blocks.  That's because gfs2.mkfs
- * arranges the journal blocks sequentially to maximize performance.
- * So the extent would map the first block for the entire file length.
- * However, gfs2_jadd can happen while file activity is happening, so
- * those journals may not be sequential.  Less likely is the case where
- * the users created their own journals by mounting the metafs and
- * laying it out.  But it's still possible.  These journals might have
- * several extents.
- *
- * TODO: This should be done in bigger chunks rather than one block at a time,
- *       but since it's only done at mount time, I'm not worried about the
- *       time it takes.
- */
-static int map_journal_extents(struct gfs2_sbd *sdp)
-{
-	struct gfs2_jdesc *jd = sdp->sd_jdesc;
-	unsigned int lb;
-	u64 db, prev_db; /* logical block, disk block, prev disk block */
-	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
-	struct gfs2_journal_extent *jext = NULL;
-	struct buffer_head bh;
-	int rc = 0;
-
-	prev_db = 0;
-
-	for (lb = 0; lb < i_size_read(jd->jd_inode) >> sdp->sd_sb.sb_bsize_shift; lb++) {
-		bh.b_state = 0;
-		bh.b_blocknr = 0;
-		bh.b_size = 1 << ip->i_inode.i_blkbits;
-		rc = gfs2_block_map(jd->jd_inode, lb, &bh, 0);
-		db = bh.b_blocknr;
-		if (rc || !db) {
-			printk(KERN_INFO "GFS2 journal mapping error %d: lb="
-			       "%u db=%llu\n", rc, lb, (unsigned long long)db);
-			break;
-		}
-		if (!prev_db || db != prev_db + 1) {
-			jext = kzalloc(sizeof(struct gfs2_journal_extent),
-				       GFP_KERNEL);
-			if (!jext) {
-				printk(KERN_INFO "GFS2 error: out of memory "
-				       "mapping journal extents.\n");
-				rc = -ENOMEM;
-				break;
-			}
-			jext->dblock = db;
-			jext->lblock = lb;
-			jext->blocks = 1;
-			list_add_tail(&jext->extent_list, &jd->extent_list);
-		} else {
-			jext->blocks++;
-		}
-		prev_db = db;
-	}
-	return rc;
-}
-
 static void gfs2_others_may_mount(struct gfs2_sbd *sdp)
 {
 	char *message = "FIRSTMOUNT=Done";
@@ -779,7 +718,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 		atomic_set(&sdp->sd_log_thresh2, 4*sdp->sd_jdesc->jd_blocks/5);
 
 		/* Map the extents for this journal's blocks */
-		map_journal_extents(sdp);
+		gfs2_map_journal_extents(sdp, sdp->sd_jdesc);
 	}
 	trace_gfs2_log_blocks(sdp, atomic_read(&sdp->sd_log_blks_free));
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 60f60f6..2574744 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -295,9 +295,8 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 
 void gfs2_jindex_free(struct gfs2_sbd *sdp)
 {
-	struct list_head list, *head;
+	struct list_head list;
 	struct gfs2_jdesc *jd;
-	struct gfs2_journal_extent *jext;
 
 	spin_lock(&sdp->sd_jindex_spin);
 	list_add(&list, &sdp->sd_jindex_list);
@@ -307,14 +306,7 @@ void gfs2_jindex_free(struct gfs2_sbd *sdp)
 
 	while (!list_empty(&list)) {
 		jd = list_entry(list.next, struct gfs2_jdesc, jd_list);
-		head = &jd->extent_list;
-		while (!list_empty(head)) {
-			jext = list_entry(head->next,
-					  struct gfs2_journal_extent,
-					  extent_list);
-			list_del(&jext->extent_list);
-			kfree(jext);
-		}
+		gfs2_free_journal_extents(jd);
 		list_del(&jd->jd_list);
 		iput(jd->jd_inode);
 		kfree(jd);
-- 
1.8.3.1

