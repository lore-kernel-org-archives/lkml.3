Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935596Ab3IEJ2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:28:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763411Ab3IEJ2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/6] GFS2: Move gfs2_sync_meta to lops.c
Date: Thu,  5 Sep 2013 10:02:07 +0100
Message-Id: <1378371732-3947-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
References: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since gfs2_sync_meta() is only called from a single file, lets move
it to lops.c where it is used, and mark it static. At the same
time, we can clean up the meta_io.h header too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 17c5b5d..010b9fb 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -579,6 +579,24 @@ static int buf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 	return error;
 }
 
+/**
+ * gfs2_meta_sync - Sync all buffers associated with a glock
+ * @gl: The glock
+ *
+ */
+
+static void gfs2_meta_sync(struct gfs2_glock *gl)
+{
+	struct address_space *mapping = gfs2_glock2aspace(gl);
+	int error;
+
+	filemap_fdatawrite(mapping);
+	error = filemap_fdatawait(mapping);
+
+	if (error)
+		gfs2_io_error(gl->gl_sbd);
+}
+
 static void buf_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 {
 	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 0da3906..9324150 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -98,24 +98,6 @@ const struct address_space_operations gfs2_meta_aops = {
 };
 
 /**
- * gfs2_meta_sync - Sync all buffers associated with a glock
- * @gl: The glock
- *
- */
-
-void gfs2_meta_sync(struct gfs2_glock *gl)
-{
-	struct address_space *mapping = gfs2_glock2aspace(gl);
-	int error;
-
-	filemap_fdatawrite(mapping);
-	error = filemap_fdatawait(mapping);
-
-	if (error)
-		gfs2_io_error(gl->gl_sbd);
-}
-
-/**
  * gfs2_getbuf - Get a buffer with a given address space
  * @gl: the glock
  * @blkno: the block number (filesystem scope)
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index 0d4c843..4823b93 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -48,21 +48,17 @@ static inline struct gfs2_sbd *gfs2_mapping2sbd(struct address_space *mapping)
 		return inode->i_sb->s_fs_info;
 }
 
-void gfs2_meta_sync(struct gfs2_glock *gl);
-
-struct buffer_head *gfs2_meta_new(struct gfs2_glock *gl, u64 blkno);
-int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno,
-		   int flags, struct buffer_head **bhp);
-int gfs2_meta_wait(struct gfs2_sbd *sdp, struct buffer_head *bh);
-struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl, u64 blkno, int create);
-
-void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr,
-			      int meta);
-
-void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen);
-
-int gfs2_meta_indirect_buffer(struct gfs2_inode *ip, int height, u64 num,
-			      struct buffer_head **bhp);
+extern struct buffer_head *gfs2_meta_new(struct gfs2_glock *gl, u64 blkno);
+extern int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
+			  struct buffer_head **bhp);
+extern int gfs2_meta_wait(struct gfs2_sbd *sdp, struct buffer_head *bh);
+extern struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl, u64 blkno,
+				       int create);
+extern void gfs2_remove_from_journal(struct buffer_head *bh,
+				     struct gfs2_trans *tr, int meta);
+extern void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen);
+extern int gfs2_meta_indirect_buffer(struct gfs2_inode *ip, int height, u64 num,
+				     struct buffer_head **bhp);
 
 static inline int gfs2_meta_inode_buffer(struct gfs2_inode *ip,
 					 struct buffer_head **bhp)
-- 
1.7.4

