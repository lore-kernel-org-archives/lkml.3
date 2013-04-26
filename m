Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab3DZJpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab3DZJpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:45:44 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/8] GFS2: Clean up inode creation path
Date: Fri, 26 Apr 2013 10:18:54 +0100
Message-Id: <1366967941-7184-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
References: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the inode creation code path in GFS2. After the
Orlov allocator was merged, a number of potential improvements are
now possible, and this is a first set of these.

The quota handling is now updated so that it matches the point in
the code where the allocation takes place. This means that the one
exception in gfs2_alloc_blocks relating to quota is now no longer
required, and we can use the generic code everywhere.

In addition the call to figure out whether we need to allocate any
extra blocks in order to add a directory entry is moved higher up
gfs2_create_inode. This means that if it returns an error, we
can deal with that at a stage where it is easier to handle that case.
The returned status cannot change during the function since we hold
an exclusive lock on the directory.

Two calls to gfs2_rindex_update have been changed to one, again at
the top of gfs2_create_inode to simplify error handling.

The time stamps are also now initialised earlier in the creation
process, this is gradually moving towards being able to remove the
call to gfs2_refresh_inode in gfs2_inode_create once we have all the
fields covered.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index cc00bd1..df51557 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -392,11 +392,15 @@ static int alloc_dinode(struct gfs2_inode *ip, u32 flags)
 	int error;
 	int dblocks = 1;
 
-	error = gfs2_inplace_reserve(ip, RES_DINODE, flags);
+	error = gfs2_quota_lock_check(ip);
 	if (error)
 		goto out;
 
-	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS, 0);
+	error = gfs2_inplace_reserve(ip, RES_DINODE, flags);
+	if (error)
+		goto out_quota;
+
+	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS + RES_QUOTA, 0);
 	if (error)
 		goto out_ipreserv;
 
@@ -409,6 +413,8 @@ static int alloc_dinode(struct gfs2_inode *ip, u32 flags)
 
 out_ipreserv:
 	gfs2_inplace_release(ip);
+out_quota:
+	gfs2_quota_unlock(ip);
 out:
 	return error;
 }
@@ -445,7 +451,6 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_dinode *di;
 	struct buffer_head *dibh;
-	struct timespec tv = CURRENT_TIME;
 
 	dibh = gfs2_meta_new(ip->i_gl, ip->i_no_addr);
 	gfs2_trans_add_meta(ip->i_gl, dibh);
@@ -461,7 +466,9 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	di->di_nlink = 0;
 	di->di_size = cpu_to_be64(ip->i_inode.i_size);
 	di->di_blocks = cpu_to_be64(1);
-	di->di_atime = di->di_mtime = di->di_ctime = cpu_to_be64(tv.tv_sec);
+	di->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
+	di->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
+	di->di_ctime = cpu_to_be64(ip->i_inode.i_ctime.tv_sec);
 	di->di_major = cpu_to_be32(MAJOR(ip->i_inode.i_rdev));
 	di->di_minor = cpu_to_be32(MINOR(ip->i_inode.i_rdev));
 	di->di_goal_meta = di->di_goal_data = cpu_to_be64(ip->i_no_addr);
@@ -476,9 +483,9 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	di->di_entries = 0;
 	memset(&di->__pad4, 0, sizeof(di->__pad4));
 	di->di_eattr = 0;
-	di->di_atime_nsec = cpu_to_be32(tv.tv_nsec);
-	di->di_mtime_nsec = cpu_to_be32(tv.tv_nsec);
-	di->di_ctime_nsec = cpu_to_be32(tv.tv_nsec);
+	di->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
+	di->di_mtime_nsec = cpu_to_be32(ip->i_inode.i_mtime.tv_nsec);
+	di->di_ctime_nsec = cpu_to_be32(ip->i_inode.i_ctime.tv_nsec);
 	memset(&di->di_reserved, 0, sizeof(di->di_reserved));
 
 	switch(ip->i_inode.i_mode & S_IFMT) {
@@ -505,58 +512,18 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	*bhp = dibh;
 }
 
-static int make_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
-		       const char *symname, struct buffer_head **bhp)
-{
-	struct inode *inode = &ip->i_inode;
-	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	int error;
-
-	error = gfs2_rindex_update(sdp);
-	if (error)
-		return error;
-
-	error = gfs2_quota_lock(dip, inode->i_uid, inode->i_gid);
-	if (error)
-		return error;
-
-	error = gfs2_quota_check(dip, inode->i_uid, inode->i_gid);
-	if (error)
-		goto out_quota;
-
-	error = gfs2_trans_begin(sdp, RES_DINODE + RES_QUOTA, 0);
-	if (error)
-		goto out_quota;
-
-	init_dinode(dip, ip, symname, bhp);
-	gfs2_quota_change(dip, +1, inode->i_uid, inode->i_gid);
-	gfs2_trans_end(sdp);
-
-out_quota:
-	gfs2_quota_unlock(dip);
-	return error;
-}
-
 static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
-		       struct gfs2_inode *ip)
+		       struct gfs2_inode *ip, int arq)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	int alloc_required;
 	struct buffer_head *dibh;
 	int error;
 
-	error = gfs2_rindex_update(sdp);
-	if (error)
-		return error;
-
 	error = gfs2_quota_lock(dip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
 	if (error)
-		goto fail;
+		return error;
 
-	error = alloc_required = gfs2_diradd_alloc_required(&dip->i_inode, name);
-	if (alloc_required < 0)
-		goto fail_quota_locks;
-	if (alloc_required) {
+	if (arq) {
 		error = gfs2_quota_check(dip, dip->i_inode.i_uid, dip->i_inode.i_gid);
 		if (error)
 			goto fail_quota_locks;
@@ -592,15 +559,10 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 
 fail_end_trans:
 	gfs2_trans_end(sdp);
-
 fail_ipreserv:
-	if (alloc_required)
-		gfs2_inplace_release(dip);
-
+	gfs2_inplace_release(dip);
 fail_quota_locks:
 	gfs2_quota_unlock(dip);
-
-fail:
 	return error;
 }
 
@@ -652,6 +614,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	int error;
 	struct buffer_head *bh = NULL;
 	u32 aflags = 0;
+	int arq;
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return -ENAMETOOLONG;
@@ -660,6 +623,10 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		return error;
 
+	error = gfs2_rindex_update(sdp);
+	if (error)
+		return error;
+
 	error = gfs2_glock_nq_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	if (error)
 		goto fail;
@@ -674,11 +641,15 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_gunlock;
 
+	arq = error = gfs2_diradd_alloc_required(dir, name);
+	if (error < 0)
+		goto fail_gunlock;
+
 	inode = new_inode(sdp->sd_vfs);
-	if (!inode) {
-		gfs2_glock_dq_uninit(ghs);
-		return -ENOMEM;
-	}
+	error = -ENOMEM;
+	if (!inode)
+		goto fail_gunlock;
+
 	ip = GFS2_I(inode);
 	error = gfs2_rs_alloc(ip);
 	if (error)
@@ -688,6 +659,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	inode->i_mode = mode;
 	inode->i_rdev = dev;
 	inode->i_size = size;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	munge_mode_uid_gid(dip, inode);
 	ip->i_goal = dip->i_goal;
 
@@ -708,10 +680,13 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_free_inode;
 
-	error = make_dinode(dip, ip, symname, &bh);
+	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
 	if (error)
 		goto fail_gunlock2;
 
+	init_dinode(dip, ip, symname, &bh);
+	gfs2_trans_end(sdp);
+
 	error = gfs2_glock_get(sdp, ip->i_no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
 	if (error)
 		goto fail_gunlock2;
@@ -737,7 +712,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_gunlock3;
 
-	error = link_dinode(dip, name, ip);
+	error = link_dinode(dip, name, ip, arq);
 	if (error)
 		goto fail_gunlock3;
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5a51265..71c7fc5 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2180,13 +2180,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	if (dinode)
 		gfs2_trans_add_unrevoke(sdp, block, 1);
 
-	/*
-	 * This needs reviewing to see why we cannot do the quota change
-	 * at this point in the dinode case.
-	 */
-	if (ndata)
-		gfs2_quota_change(ip, ndata, ip->i_inode.i_uid,
-				  ip->i_inode.i_gid);
+	gfs2_quota_change(ip, *nblocks, ip->i_inode.i_uid, ip->i_inode.i_gid);
 
 	rbm.rgd->rd_free_clone -= *nblocks;
 	trace_gfs2_block_alloc(ip, rbm.rgd, block, *nblocks,
-- 
1.7.4

