Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaDAJ02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbaDAJQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:07 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/29] GFS2: Allocate block for xattr at inode alloc time, if required
Date: Tue,  1 Apr 2014 10:15:14 +0100
Message-Id: <1396343741-1524-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another step towards improving the allocation of xattr
blocks at inode allocation time. Here we take advantage of
Christoph's recent work on ACLs to allocate a block for the
xattrs early if we know that we will be adding ACLs to the
inode later on. The advantage of that is that it is much
more likely that we'll get a contiguous run of two blocks
where the first is the inode and the second is the xattr block.

We still have to fall back to the original system in case we
don't get the requested two contiguous blocks, or in case the
ACLs are too large to fit into the block.

Future patches will move more of the ACL setting code further
up the gfs2_inode_create() function. Also, I'd like to be
able to do the same thing with the xattrs from LSMs in
due course, too. That way we should be able to slowly reduce
the number of independent transactions, at least in the
most common cases.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5c52418..ec455b9 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -376,12 +376,11 @@ static void munge_mode_uid_gid(const struct gfs2_inode *dip,
 		inode->i_gid = current_fsgid();
 }
 
-static int alloc_dinode(struct gfs2_inode *ip, u32 flags)
+static int alloc_dinode(struct gfs2_inode *ip, u32 flags, unsigned *dblocks)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc_parms ap = { .target = RES_DINODE, .aflags = flags, };
+	struct gfs2_alloc_parms ap = { .target = *dblocks, .aflags = flags, };
 	int error;
-	int dblocks = 1;
 
 	error = gfs2_quota_lock_check(ip);
 	if (error)
@@ -391,11 +390,11 @@ static int alloc_dinode(struct gfs2_inode *ip, u32 flags)
 	if (error)
 		goto out_quota;
 
-	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS + RES_QUOTA, 0);
+	error = gfs2_trans_begin(sdp, (*dblocks * RES_RG_BIT) + RES_STATFS + RES_QUOTA, 0);
 	if (error)
 		goto out_ipreserv;
 
-	error = gfs2_alloc_blocks(ip, &ip->i_no_addr, &dblocks, 1, &ip->i_generation);
+	error = gfs2_alloc_blocks(ip, &ip->i_no_addr, dblocks, 1, &ip->i_generation);
 	ip->i_no_formal_ino = ip->i_generation;
 	ip->i_inode.i_ino = ip->i_no_addr;
 	ip->i_goal = ip->i_no_addr;
@@ -428,6 +427,33 @@ static void gfs2_init_dir(struct buffer_head *dibh,
 }
 
 /**
+ * gfs2_init_xattr - Initialise an xattr block for a new inode
+ * @ip: The inode in question
+ *
+ * This sets up an empty xattr block for a new inode, ready to
+ * take any ACLs, LSM xattrs, etc.
+ */
+
+static void gfs2_init_xattr(struct gfs2_inode *ip)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct buffer_head *bh;
+	struct gfs2_ea_header *ea;
+
+	bh = gfs2_meta_new(ip->i_gl, ip->i_eattr);
+	gfs2_trans_add_meta(ip->i_gl, bh);
+	gfs2_metatype_set(bh, GFS2_METATYPE_EA, GFS2_FORMAT_EA);
+	gfs2_buffer_clear_tail(bh, sizeof(struct gfs2_meta_header));
+
+	ea = GFS2_EA_BH2FIRST(bh);
+	ea->ea_rec_len = cpu_to_be32(sdp->sd_jbsize);
+	ea->ea_type = GFS2_EATYPE_UNUSED;
+	ea->ea_flags = GFS2_EAFLAG_LAST;
+
+	brelse(bh);
+}
+
+/**
  * init_dinode - Fill in a new dinode structure
  * @dip: The directory this inode is being created in
  * @ip: The inode
@@ -580,6 +606,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	struct dentry *d;
 	int error;
 	u32 aflags = 0;
+	unsigned blocks = 1;
 	struct gfs2_diradd da = { .bh = NULL, };
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
@@ -676,10 +703,15 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	    (dip->i_diskflags & GFS2_DIF_TOPDIR))
 		aflags |= GFS2_AF_ORLOV;
 
-	error = alloc_dinode(ip, aflags);
+	if (default_acl || acl)
+		blocks++;
+
+	error = alloc_dinode(ip, aflags, &blocks);
 	if (error)
 		goto fail_free_inode;
 
+	gfs2_set_inode_blocks(inode, blocks);
+
 	error = gfs2_glock_get(sdp, ip->i_no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
 	if (error)
 		goto fail_free_inode;
@@ -689,10 +721,14 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_free_inode;
 
-	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
+	error = gfs2_trans_begin(sdp, blocks, 0);
 	if (error)
 		goto fail_gunlock2;
 
+	if (blocks > 1) {
+		ip->i_eattr = ip->i_no_addr + 1;
+		gfs2_init_xattr(ip);
+	}
 	init_dinode(dip, ip, symname);
 	gfs2_trans_end(sdp);
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index a1da213..c13e4c5 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2296,7 +2296,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 
 	gfs2_statfs_change(sdp, 0, -(s64)*nblocks, dinode ? 1 : 0);
 	if (dinode)
-		gfs2_trans_add_unrevoke(sdp, block, 1);
+		gfs2_trans_add_unrevoke(sdp, block, *nblocks);
 
 	gfs2_quota_change(ip, *nblocks, ip->i_inode.i_uid, ip->i_inode.i_gid);
 
diff --git a/include/uapi/linux/gfs2_ondisk.h b/include/uapi/linux/gfs2_ondisk.h
index 0f24c07..3100208 100644
--- a/include/uapi/linux/gfs2_ondisk.h
+++ b/include/uapi/linux/gfs2_ondisk.h
@@ -347,9 +347,9 @@ struct gfs2_leaf {
  * metadata header. Each inode, if it has extended attributes, will
  * have either a single block containing the extended attribute headers
  * or a single indirect block pointing to blocks containing the
- * extended attribure headers.
+ * extended attribute headers.
  *
- * The maximim size of the data part of an extended attribute is 64k
+ * The maximum size of the data part of an extended attribute is 64k
  * so the number of blocks required depends upon block size. Since the
  * block size also determines the number of pointers in an indirect
  * block, its a fairly complicated calculation to work out the maximum
-- 
1.8.3.1

