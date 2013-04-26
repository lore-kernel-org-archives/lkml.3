Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab3DZJrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:47:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759600Ab3DZJps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:45:48 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/8] GFS2: Use gfs2_dinode_out() in the inode create path
Date: Fri, 26 Apr 2013 10:18:56 +0100
Message-Id: <1366967941-7184-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
References: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over the previous two patches relating to inode creation, the
content of init_dinode() has been looking more and more like
gfs2_dinode_out(). This is not an accident! This patch replaces
the parts of init_dinode() which are duplicated in gfs2_dinode_out()
with a call to that function.

Mostly that is straightforward, but there is one issue which needed
to be resolved relating to the link count. The link count has to be
set to zero in a certain error handling code path, which lands up
calling iput(). This is now done specifically in that code path
allowing the link count to be set earlier and written into the
on disk inode by gfs2_dinode_put() in the normal way.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index cb53b4f..8833a4f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -446,46 +446,24 @@ static void gfs2_init_dir(struct buffer_head *dibh,
  */
 
 static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
-			const char *symname, struct buffer_head **bhp)
+			const char *symname)
 {
 	struct gfs2_dinode *di;
 	struct buffer_head *dibh;
 
 	dibh = gfs2_meta_new(ip->i_gl, ip->i_no_addr);
 	gfs2_trans_add_meta(ip->i_gl, dibh);
-	gfs2_metatype_set(dibh, GFS2_METATYPE_DI, GFS2_FORMAT_DI);
-	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 	di = (struct gfs2_dinode *)dibh->b_data;
+	gfs2_dinode_out(ip, di);
 
-	di->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
-	di->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
-	di->di_mode = cpu_to_be32(ip->i_inode.i_mode);
-	di->di_uid = cpu_to_be32(i_uid_read(&ip->i_inode));
-	di->di_gid = cpu_to_be32(i_gid_read(&ip->i_inode));
-	di->di_nlink = 0;
-	di->di_size = cpu_to_be64(ip->i_inode.i_size);
-	di->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
-	di->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
-	di->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
-	di->di_ctime = cpu_to_be64(ip->i_inode.i_ctime.tv_sec);
 	di->di_major = cpu_to_be32(MAJOR(ip->i_inode.i_rdev));
 	di->di_minor = cpu_to_be32(MINOR(ip->i_inode.i_rdev));
-	di->di_goal_meta = di->di_goal_data = cpu_to_be64(ip->i_no_addr);
-	di->di_generation = cpu_to_be64(ip->i_generation);
-	di->di_flags = cpu_to_be32(ip->i_diskflags);
 	di->__pad1 = 0;
-	di->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) ? GFS2_FORMAT_DE : 0);
-	di->di_height = cpu_to_be16(ip->i_height);
 	di->__pad2 = 0;
 	di->__pad3 = 0;
-	di->di_depth = cpu_to_be16(ip->i_depth);
-	di->di_entries = cpu_to_be32(ip->i_entries);
 	memset(&di->__pad4, 0, sizeof(di->__pad4));
-	di->di_eattr = cpu_to_be64(ip->i_eattr);
-	di->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
-	di->di_mtime_nsec = cpu_to_be32(ip->i_inode.i_mtime.tv_nsec);
-	di->di_ctime_nsec = cpu_to_be32(ip->i_inode.i_ctime.tv_nsec);
 	memset(&di->di_reserved, 0, sizeof(di->di_reserved));
+	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 
 	switch(ip->i_inode.i_mode & S_IFMT) {
 	case S_IFDIR:
@@ -497,8 +475,7 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	}
 
 	set_buffer_uptodate(dibh);
-
-	*bhp = dibh;
+	brelse(dibh);
 }
 
 static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
@@ -532,9 +509,6 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 	if (error)
 		goto fail_end_trans;
 
-	set_nlink(&ip->i_inode, S_ISDIR(ip->i_inode.i_mode) ? 2 : 1);
-	mark_inode_dirty(&ip->i_inode);
-
 fail_end_trans:
 	gfs2_trans_end(sdp);
 fail_ipreserv:
@@ -590,7 +564,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_glock *io_gl;
 	int error;
-	struct buffer_head *bh = NULL;
 	u32 aflags = 0;
 	int arq;
 
@@ -634,6 +607,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_free_inode;
 
 	inode->i_mode = mode;
+	set_nlink(inode, S_ISDIR(mode) ? 2 : 1);
 	inode->i_rdev = dev;
 	inode->i_size = size;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
@@ -682,7 +656,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_gunlock2;
 
-	init_dinode(dip, ip, symname, &bh);
+	init_dinode(dip, ip, symname);
 	gfs2_trans_end(sdp);
 
 	error = gfs2_glock_get(sdp, ip->i_no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
@@ -710,7 +684,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_gunlock3;
 
-	brelse(bh);
+	mark_inode_dirty(inode);
 	gfs2_glock_dq_uninit(ghs);
 	gfs2_glock_dq_uninit(ghs + 1);
 	d_instantiate(dentry, inode);
@@ -733,12 +707,12 @@ fail_free_inode:
 fail_gunlock:
 	gfs2_glock_dq_uninit(ghs);
 	if (inode && !IS_ERR(inode)) {
+		clear_nlink(inode);
+		mark_inode_dirty(inode);
 		set_bit(GIF_ALLOC_FAILED, &GFS2_I(inode)->i_flags);
 		iput(inode);
 	}
 fail:
-	if (bh)
-		brelse(bh);
 	return error;
 }
 
-- 
1.7.4

