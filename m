Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3KDLgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab3KDLgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:32 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/19] GFS2: Add allocation parameters structure
Date: Mon,  4 Nov 2013 11:09:32 +0000
Message-Id: <1383563382-8535-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a structure to contain allocation parameters with
the intention of future expansion of this structure. The idea is
that we should be able to add more information about the allocation
in the future in order to allow the allocator to make a better job
of placing the requests on-disk.

There is no functional difference from applying this patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 1f7d805..b7fc035 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -611,12 +611,14 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 		gfs2_write_calc_reserv(ip, len, &data_blocks, &ind_blocks);
 
 	if (alloc_required) {
+		struct gfs2_alloc_parms ap = { .aflags = 0, };
 		error = gfs2_quota_lock_check(ip);
 		if (error)
 			goto out_unlock;
 
 		requested = data_blocks + ind_blocks;
-		error = gfs2_inplace_reserve(ip, requested, 0);
+		ap.target = requested;
+		error = gfs2_inplace_reserve(ip, &ap);
 		if (error)
 			goto out_qunlock;
 	}
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 21ad0f1..fe0500c 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1216,6 +1216,7 @@ static int do_grow(struct inode *inode, u64 size)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_alloc_parms ap = { .target = 1, };
 	struct buffer_head *dibh;
 	int error;
 	int unstuff = 0;
@@ -1226,7 +1227,7 @@ static int do_grow(struct inode *inode, u64 size)
 		if (error)
 			return error;
 
-		error = gfs2_inplace_reserve(ip, 1, 0);
+		error = gfs2_inplace_reserve(ip, &ap);
 		if (error)
 			goto do_grow_qunlock;
 		unstuff = 1;
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 9ad20ed..efc078f 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -383,6 +383,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct inode *inode = file_inode(vma->vm_file);
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_alloc_parms ap = { .aflags = 0, };
 	unsigned long last_index;
 	u64 pos = page->index << PAGE_CACHE_SHIFT;
 	unsigned int data_blocks, ind_blocks, rblocks;
@@ -430,7 +431,8 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (ret)
 		goto out_unlock;
 	gfs2_write_calc_reserv(ip, PAGE_CACHE_SIZE, &data_blocks, &ind_blocks);
-	ret = gfs2_inplace_reserve(ip, data_blocks + ind_blocks, 0);
+	ap.target = data_blocks + ind_blocks;
+	ret = gfs2_inplace_reserve(ip, &ap);
 	if (ret)
 		goto out_quota_unlock;
 
@@ -800,6 +802,7 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	struct inode *inode = file_inode(file);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_alloc_parms ap = { .aflags = 0, };
 	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
 	loff_t bytes, max_bytes;
 	int error;
@@ -850,7 +853,8 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 retry:
 		gfs2_write_calc_reserv(ip, bytes, &data_blocks, &ind_blocks);
 
-		error = gfs2_inplace_reserve(ip, data_blocks + ind_blocks, 0);
+		ap.target = data_blocks + ind_blocks;
+		error = gfs2_inplace_reserve(ip, &ap);
 		if (error) {
 			if (error == -ENOSPC && bytes > sdp->sd_sb.sb_bsize) {
 				bytes >>= 1;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 8c8f110..082c8fa 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -285,6 +285,20 @@ struct gfs2_blkreserv {
 	unsigned int rs_qa_qd_num;
 };
 
+/*
+ * Allocation parameters
+ * @target: The number of blocks we'd ideally like to allocate
+ * @aflags: The flags (e.g. Orlov flag)
+ *
+ * The intent is to gradually expand this structure over time in
+ * order to give more information, e.g. alignment, min extent size
+ * to the allocation code.
+ */
+struct gfs2_alloc_parms {
+	u32 target;
+	u32 aflags;
+};
+
 enum {
 	GLF_LOCK			= 1,
 	GLF_DEMOTE			= 3,
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 4b79c19..5a7ca3d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -379,6 +379,7 @@ static void munge_mode_uid_gid(const struct gfs2_inode *dip,
 static int alloc_dinode(struct gfs2_inode *ip, u32 flags)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct gfs2_alloc_parms ap = { .target = RES_DINODE, .aflags = flags, };
 	int error;
 	int dblocks = 1;
 
@@ -386,7 +387,7 @@ static int alloc_dinode(struct gfs2_inode *ip, u32 flags)
 	if (error)
 		goto out;
 
-	error = gfs2_inplace_reserve(ip, RES_DINODE, flags);
+	error = gfs2_inplace_reserve(ip, &ap);
 	if (error)
 		goto out_quota;
 
@@ -472,6 +473,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 		       struct gfs2_inode *ip, int arq)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
+	struct gfs2_alloc_parms ap = { .target = sdp->sd_max_dirres, };
 	int error;
 
 	if (arq) {
@@ -479,7 +481,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 		if (error)
 			goto fail_quota_locks;
 
-		error = gfs2_inplace_reserve(dip, sdp->sd_max_dirres, 0);
+		error = gfs2_inplace_reserve(dip, &ap);
 		if (error)
 			goto fail_quota_locks;
 
@@ -874,11 +876,12 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	error = 0;
 
 	if (alloc_required) {
+		struct gfs2_alloc_parms ap = { .target = sdp->sd_max_dirres, };
 		error = gfs2_quota_lock_check(dip);
 		if (error)
 			goto out_gunlock;
 
-		error = gfs2_inplace_reserve(dip, sdp->sd_max_dirres, 0);
+		error = gfs2_inplace_reserve(dip, &ap);
 		if (error)
 			goto out_gunlock_q;
 
@@ -1387,11 +1390,12 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		goto out_gunlock;
 
 	if (alloc_required) {
+		struct gfs2_alloc_parms ap = { .target = sdp->sd_max_dirres, };
 		error = gfs2_quota_lock_check(ndip);
 		if (error)
 			goto out_gunlock;
 
-		error = gfs2_inplace_reserve(ndip, sdp->sd_max_dirres, 0);
+		error = gfs2_inplace_reserve(ndip, &ap);
 		if (error)
 			goto out_gunlock_q;
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index db44135..8fe7a0a 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -763,6 +763,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 {
 	struct gfs2_sbd *sdp = (*qda)->qd_gl->gl_sbd;
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_quota_inode);
+	struct gfs2_alloc_parms ap = { .aflags = 0, };
 	unsigned int data_blocks, ind_blocks;
 	struct gfs2_holder *ghs, i_gh;
 	unsigned int qx, x;
@@ -815,7 +816,8 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 	blocks = num_qd * data_blocks + RES_DINODE + num_qd + 3;
 
 	reserved = 1 + (nalloc * (data_blocks + ind_blocks));
-	error = gfs2_inplace_reserve(ip, reserved, 0);
+	ap.target = reserved;
+	error = gfs2_inplace_reserve(ip, &ap);
 	if (error)
 		goto out_alloc;
 
@@ -1573,10 +1575,12 @@ static int gfs2_set_dqblk(struct super_block *sb, struct kqid qid,
 	if (gfs2_is_stuffed(ip))
 		alloc_required = 1;
 	if (alloc_required) {
+		struct gfs2_alloc_parms ap = { .aflags = 0, };
 		gfs2_write_calc_reserv(ip, sizeof(struct gfs2_quota),
 				       &data_blocks, &ind_blocks);
 		blocks = 1 + data_blocks + ind_blocks;
-		error = gfs2_inplace_reserve(ip, blocks, 0);
+		ap.target = blocks;
+		error = gfs2_inplace_reserve(ip, &ap);
 		if (error)
 			goto out_i;
 		blocks += gfs2_rg_blocks(ip, blocks);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index d4d10fa..4f0984a 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1422,12 +1422,12 @@ static void rs_insert(struct gfs2_inode *ip)
  * rg_mblk_search - find a group of multiple free blocks to form a reservation
  * @rgd: the resource group descriptor
  * @ip: pointer to the inode for which we're reserving blocks
- * @requested: number of blocks required for this allocation
+ * @ap: the allocation parameters
  *
  */
 
 static void rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
-			   unsigned requested)
+			   const struct gfs2_alloc_parms *ap)
 {
 	struct gfs2_rbm rbm = { .rgd = rgd, };
 	u64 goal;
@@ -1440,7 +1440,7 @@ static void rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
 	if (S_ISDIR(inode->i_mode))
 		extlen = 1;
 	else {
-		extlen = max_t(u32, atomic_read(&rs->rs_sizehint), requested);
+		extlen = max_t(u32, atomic_read(&rs->rs_sizehint), ap->target);
 		extlen = clamp(extlen, RGRP_RSRV_MINBLKS, free_blocks);
 	}
 	if ((rgd->rd_free_clone < rgd->rd_reserved) || (free_blocks < extlen))
@@ -1831,12 +1831,12 @@ static bool gfs2_select_rgrp(struct gfs2_rgrpd **pos, const struct gfs2_rgrpd *b
 /**
  * gfs2_inplace_reserve - Reserve space in the filesystem
  * @ip: the inode to reserve space for
- * @requested: the number of blocks to be reserved
+ * @ap: the allocation parameters
  *
  * Returns: errno
  */
 
-int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested, u32 aflags)
+int gfs2_inplace_reserve(struct gfs2_inode *ip, const struct gfs2_alloc_parms *ap)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *begin = NULL;
@@ -1848,7 +1848,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested, u32 aflags)
 
 	if (sdp->sd_args.ar_rgrplvb)
 		flags |= GL_SKIP;
-	if (gfs2_assert_warn(sdp, requested))
+	if (gfs2_assert_warn(sdp, ap->target))
 		return -EINVAL;
 	if (gfs2_rs_active(rs)) {
 		begin = rs->rs_rbm.rgd;
@@ -1857,7 +1857,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested, u32 aflags)
 	} else {
 		rs->rs_rbm.rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal, 1);
 	}
-	if (S_ISDIR(ip->i_inode.i_mode) && (aflags & GFS2_AF_ORLOV))
+	if (S_ISDIR(ip->i_inode.i_mode) && (ap->aflags & GFS2_AF_ORLOV))
 		skip = gfs2_orlov_skip(ip);
 	if (rs->rs_rbm.rgd == NULL)
 		return -EBADSLT;
@@ -1899,14 +1899,14 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested, u32 aflags)
 
 		/* Get a reservation if we don't already have one */
 		if (!gfs2_rs_active(rs))
-			rg_mblk_search(rs->rs_rbm.rgd, ip, requested);
+			rg_mblk_search(rs->rs_rbm.rgd, ip, ap);
 
 		/* Skip rgrps when we can't get a reservation on first pass */
 		if (!gfs2_rs_active(rs) && (loops < 1))
 			goto check_rgrp;
 
 		/* If rgrp has enough free space, use it */
-		if (rs->rs_rbm.rgd->rd_free_clone >= requested) {
+		if (rs->rs_rbm.rgd->rd_free_clone >= ap->target) {
 			ip->i_rgd = rs->rs_rbm.rgd;
 			return 0;
 		}
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 57ea16b..3a10d2f 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -40,7 +40,7 @@ extern void gfs2_rgrp_go_unlock(struct gfs2_holder *gh);
 extern struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip);
 
 #define GFS2_AF_ORLOV 1
-extern int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested, u32 flags);
+extern int gfs2_inplace_reserve(struct gfs2_inode *ip, const struct gfs2_alloc_parms *ap);
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
 extern int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index ecd37f3..8c6a6f6 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -723,6 +723,7 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 			     unsigned int blks,
 			     ea_skeleton_call_t skeleton_call, void *private)
 {
+	struct gfs2_alloc_parms ap = { .target = blks };
 	struct buffer_head *dibh;
 	int error;
 
@@ -734,7 +735,7 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	if (error)
 		return error;
 
-	error = gfs2_inplace_reserve(ip, blks, 0);
+	error = gfs2_inplace_reserve(ip, &ap);
 	if (error)
 		goto out_gunlock_q;
 
-- 
1.7.4.4

