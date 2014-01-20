Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaATM34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:29:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbaATMYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:37 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/24] GFS2: Add directory addition info structure
Date: Mon, 20 Jan 2014 12:23:32 +0000
Message-Id: <1390220627-1571-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent is that this structure will hold the information
required when adding entries to a directory (linking). To
start with, it will contain only the number of blocks which
are required to link the new entry into the directory. The
current calculation returns either 0 or the maximim number of
blocks that can ever be requested by such a transaction.

The intent is that in a later patch, we can update the dir
code to calculate this value more accurately. In addition
further patches will also add further fields to the new
structure to increase its utility.

In addition this patch fixes a bug where the link used during
inode creation was adding requesting too many blocks in
some cases. This is harmless unless the fs is close to being
full.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 2e5fc26..0b6be20 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -2017,18 +2017,24 @@ out:
  * gfs2_diradd_alloc_required - find if adding entry will require an allocation
  * @ip: the file being written to
  * @filname: the filename that's going to be added
+ * @da: The structure to return dir alloc info
  *
- * Returns: 1 if alloc required, 0 if not, -ve on error
+ * Returns: 0 if ok, -ve on error
  */
 
-int gfs2_diradd_alloc_required(struct inode *inode, const struct qstr *name)
+int gfs2_diradd_alloc_required(struct inode *inode, const struct qstr *name,
+			       struct gfs2_diradd *da)
 {
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_dirent *dent;
 	struct buffer_head *bh;
 
+	da->nr_blocks = 0;
+
 	dent = gfs2_dirent_search(inode, name, gfs2_dirent_find_space, &bh);
 	if (!dent) {
-		return 1;
+		da->nr_blocks = sdp->sd_max_dirres;
+		return 0;
 	}
 	if (IS_ERR(dent))
 		return PTR_ERR(dent);
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index 4f03bbd..c5573e7 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -17,6 +17,10 @@ struct inode;
 struct gfs2_inode;
 struct gfs2_inum;
 
+struct gfs2_diradd {
+	unsigned nr_blocks;
+};
+
 extern struct inode *gfs2_dir_search(struct inode *dir,
 				     const struct qstr *filename,
 				     bool fail_on_exist);
@@ -33,7 +37,8 @@ extern int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 extern int gfs2_dir_exhash_dealloc(struct gfs2_inode *dip);
 
 extern int gfs2_diradd_alloc_required(struct inode *dir,
-				      const struct qstr *filename);
+				      const struct qstr *filename,
+				      struct gfs2_diradd *da);
 extern int gfs2_dir_get_new_buffer(struct gfs2_inode *ip, u64 block,
 				   struct buffer_head **bhp);
 extern void gfs2_dir_hash_inval(struct gfs2_inode *ip);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 7119504..9ac8f13 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -470,13 +470,13 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 }
 
 static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
-		       struct gfs2_inode *ip, int arq)
+		       struct gfs2_inode *ip, struct gfs2_diradd *da)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct gfs2_alloc_parms ap = { .target = sdp->sd_max_dirres, };
+	struct gfs2_alloc_parms ap = { .target = da->nr_blocks, };
 	int error;
 
-	if (arq) {
+	if (da->nr_blocks) {
 		error = gfs2_quota_lock_check(dip);
 		if (error)
 			goto fail_quota_locks;
@@ -485,8 +485,8 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 		if (error)
 			goto fail_quota_locks;
 
-		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 dip->i_rgd->rd_length +
+		error = gfs2_trans_begin(sdp, da->nr_blocks +
+					 gfs2_rg_blocks(dip, da->nr_blocks) +
 					 2 * RES_DINODE +
 					 RES_STATFS + RES_QUOTA, 0);
 		if (error)
@@ -560,7 +560,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	struct dentry *d;
 	int error;
 	u32 aflags = 0;
-	int arq;
+	struct gfs2_diradd da;
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return -ENAMETOOLONG;
@@ -602,7 +602,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_gunlock;
 	}
 
-	arq = error = gfs2_diradd_alloc_required(dir, name);
+	error = gfs2_diradd_alloc_required(dir, name, &da);
 	if (error < 0)
 		goto fail_gunlock;
 
@@ -690,7 +690,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_gunlock3;
 
-	error = link_dinode(dip, name, ip, arq);
+	error = link_dinode(dip, name, ip, &da);
 	if (error)
 		goto fail_gunlock3;
 
@@ -817,7 +817,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder ghs[2];
 	struct buffer_head *dibh;
-	int alloc_required;
+	struct gfs2_diradd da;
 	int error;
 
 	if (S_ISDIR(inode->i_mode))
@@ -872,13 +872,12 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	if (ip->i_inode.i_nlink == (u32)-1)
 		goto out_gunlock;
 
-	alloc_required = error = gfs2_diradd_alloc_required(dir, &dentry->d_name);
+	error = gfs2_diradd_alloc_required(dir, &dentry->d_name, &da);
 	if (error < 0)
 		goto out_gunlock;
-	error = 0;
 
-	if (alloc_required) {
-		struct gfs2_alloc_parms ap = { .target = sdp->sd_max_dirres, };
+	if (da.nr_blocks) {
+		struct gfs2_alloc_parms ap = { .target = da.nr_blocks, };
 		error = gfs2_quota_lock_check(dip);
 		if (error)
 			goto out_gunlock;
@@ -887,8 +886,8 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 		if (error)
 			goto out_gunlock_q;
 
-		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 gfs2_rg_blocks(dip, sdp->sd_max_dirres) +
+		error = gfs2_trans_begin(sdp, da.nr_blocks +
+					 gfs2_rg_blocks(dip, da.nr_blocks) +
 					 2 * RES_DINODE + RES_STATFS +
 					 RES_QUOTA, 0);
 		if (error)
@@ -919,10 +918,10 @@ out_brelse:
 out_end_trans:
 	gfs2_trans_end(sdp);
 out_ipres:
-	if (alloc_required)
+	if (da.nr_blocks)
 		gfs2_inplace_release(dip);
 out_gunlock_q:
-	if (alloc_required)
+	if (da.nr_blocks)
 		gfs2_quota_unlock(dip);
 out_gunlock:
 	gfs2_glock_dq(ghs + 1);
@@ -1254,7 +1253,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	struct gfs2_rgrpd *nrgd;
 	unsigned int num_gh;
 	int dir_rename = 0;
-	int alloc_required = 0;
+	struct gfs2_diradd da = { .nr_blocks = 0, };
 	unsigned int x;
 	int error;
 
@@ -1388,14 +1387,14 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			goto out_gunlock;
 	}
 
-	if (nip == NULL)
-		alloc_required = gfs2_diradd_alloc_required(ndir, &ndentry->d_name);
-	error = alloc_required;
-	if (error < 0)
-		goto out_gunlock;
+	if (nip == NULL) {
+		error = gfs2_diradd_alloc_required(ndir, &ndentry->d_name, &da);
+		if (error)
+			goto out_gunlock;
+	}
 
-	if (alloc_required) {
-		struct gfs2_alloc_parms ap = { .target = sdp->sd_max_dirres, };
+	if (da.nr_blocks) {
+		struct gfs2_alloc_parms ap = { .target = da.nr_blocks, };
 		error = gfs2_quota_lock_check(ndip);
 		if (error)
 			goto out_gunlock;
@@ -1404,8 +1403,8 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_gunlock_q;
 
-		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
-					 gfs2_rg_blocks(ndip, sdp->sd_max_dirres) +
+		error = gfs2_trans_begin(sdp, da.nr_blocks +
+					 gfs2_rg_blocks(ndip, da.nr_blocks) +
 					 4 * RES_DINODE + 4 * RES_LEAF +
 					 RES_STATFS + RES_QUOTA + 4, 0);
 		if (error)
@@ -1448,10 +1447,10 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 out_end_trans:
 	gfs2_trans_end(sdp);
 out_ipreserv:
-	if (alloc_required)
+	if (da.nr_blocks)
 		gfs2_inplace_release(ndip);
 out_gunlock_q:
-	if (alloc_required)
+	if (da.nr_blocks)
 		gfs2_quota_unlock(ndip);
 out_gunlock:
 	while (x--) {
-- 
1.8.3.1

