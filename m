Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616Ab3DZJps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:45:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759433Ab3DZJpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:45:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/8] GFS2: Remove gfs2_refresh_inode from inode creation path
Date: Fri, 26 Apr 2013 10:18:55 +0100
Message-Id: <1366967941-7184-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
References: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original method for creating inodes used in GFS2 was to fill
out a buffer, with all the information, and then to read that
buffer into the in-core inode, using gfs2_refresh_inode()

The problem with this approach is that all the inode's fields
need to be calculated ahead of time, and were stored in various
variables making the code rather complicated.

The new approach is simply to allocate the in-core inode earlier
and fill in as many fields as possible ahead of time. These can
then be used to initilise the on disk representation. The
code has been working towards the point where it is possible
to remove gfs2_refresh_inode() because all the fields are
correctly initialised ahead of time. We've now reached that
milestone, and have reversed the order of setting up the in
core and on disk inodes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index cf35155..6e30fd1 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1279,19 +1279,6 @@ void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs)
 		gfs2_glock_dq(&ghs[num_gh]);
 }
 
-/**
- * gfs2_glock_dq_uninit_m - release multiple glocks
- * @num_gh: the number of structures
- * @ghs: an array of struct gfs2_holder structures
- *
- */
-
-void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs)
-{
-	while (num_gh--)
-		gfs2_glock_dq_uninit(&ghs[num_gh]);
-}
-
 void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 {
 	unsigned long delay = 0;
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index fd580b7..69f66e3 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -201,7 +201,6 @@ extern int gfs2_glock_nq_num(struct gfs2_sbd *sdp, u64 number,
 			     struct gfs2_holder *gh);
 extern int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 extern void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs);
-extern void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs);
 extern int gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl);
 #define GLOCK_BUG_ON(gl,x) do { if (unlikely(x)) { gfs2_dump_glock(NULL, gl); BUG(); } } while(0)
 extern __printf(2, 3)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index df51557..cb53b4f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -448,7 +448,6 @@ static void gfs2_init_dir(struct buffer_head *dibh,
 static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 			const char *symname, struct buffer_head **bhp)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_dinode *di;
 	struct buffer_head *dibh;
 
@@ -465,7 +464,7 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	di->di_gid = cpu_to_be32(i_gid_read(&ip->i_inode));
 	di->di_nlink = 0;
 	di->di_size = cpu_to_be64(ip->i_inode.i_size);
-	di->di_blocks = cpu_to_be64(1);
+	di->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
 	di->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
 	di->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
 	di->di_ctime = cpu_to_be64(ip->i_inode.i_ctime.tv_sec);
@@ -473,33 +472,23 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	di->di_minor = cpu_to_be32(MINOR(ip->i_inode.i_rdev));
 	di->di_goal_meta = di->di_goal_data = cpu_to_be64(ip->i_no_addr);
 	di->di_generation = cpu_to_be64(ip->i_generation);
-	di->di_flags = 0;
+	di->di_flags = cpu_to_be32(ip->i_diskflags);
 	di->__pad1 = 0;
 	di->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) ? GFS2_FORMAT_DE : 0);
-	di->di_height = 0;
+	di->di_height = cpu_to_be16(ip->i_height);
 	di->__pad2 = 0;
 	di->__pad3 = 0;
-	di->di_depth = 0;
-	di->di_entries = 0;
+	di->di_depth = cpu_to_be16(ip->i_depth);
+	di->di_entries = cpu_to_be32(ip->i_entries);
 	memset(&di->__pad4, 0, sizeof(di->__pad4));
-	di->di_eattr = 0;
+	di->di_eattr = cpu_to_be64(ip->i_eattr);
 	di->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
 	di->di_mtime_nsec = cpu_to_be32(ip->i_inode.i_mtime.tv_nsec);
 	di->di_ctime_nsec = cpu_to_be32(ip->i_inode.i_ctime.tv_nsec);
 	memset(&di->di_reserved, 0, sizeof(di->di_reserved));
 
 	switch(ip->i_inode.i_mode & S_IFMT) {
-	case S_IFREG:
-		if ((dip->i_diskflags & GFS2_DIF_INHERIT_JDATA) ||
-		    gfs2_tune_get(sdp, gt_new_files_jdata))
-			di->di_flags |= cpu_to_be32(GFS2_DIF_JDATA);
-		break;
 	case S_IFDIR:
-		di->di_flags |= cpu_to_be32(dip->i_diskflags &
-					    GFS2_DIF_INHERIT_JDATA);
-		di->di_flags |= cpu_to_be32(GFS2_DIF_JDATA);
-		di->di_size = cpu_to_be64(sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode));
-		di->di_entries = cpu_to_be32(2);
 		gfs2_init_dir(dibh, dip);
 		break;
 	case S_IFLNK:
@@ -516,15 +505,10 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 		       struct gfs2_inode *ip, int arq)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct buffer_head *dibh;
 	int error;
 
-	error = gfs2_quota_lock(dip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
-	if (error)
-		return error;
-
 	if (arq) {
-		error = gfs2_quota_check(dip, dip->i_inode.i_uid, dip->i_inode.i_gid);
+		error = gfs2_quota_lock_check(dip);
 		if (error)
 			goto fail_quota_locks;
 
@@ -548,14 +532,8 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 	if (error)
 		goto fail_end_trans;
 
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		goto fail_end_trans;
 	set_nlink(&ip->i_inode, S_ISDIR(ip->i_inode.i_mode) ? 2 : 1);
-	gfs2_trans_add_meta(ip->i_gl, dibh);
-	gfs2_dinode_out(ip, dibh->b_data);
-	brelse(dibh);
-	return 0;
+	mark_inode_dirty(&ip->i_inode);
 
 fail_end_trans:
 	gfs2_trans_end(sdp);
@@ -655,13 +633,33 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_free_inode;
 
-	set_bit(GIF_INVALID, &ip->i_flags);
 	inode->i_mode = mode;
 	inode->i_rdev = dev;
 	inode->i_size = size;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	gfs2_set_inode_blocks(inode, 1);
 	munge_mode_uid_gid(dip, inode);
 	ip->i_goal = dip->i_goal;
+	ip->i_diskflags = 0;
+	ip->i_eattr = 0;
+	ip->i_height = 0;
+	ip->i_depth = 0;
+	ip->i_entries = 0;
+
+	switch(mode & S_IFMT) {
+	case S_IFREG:
+		if ((dip->i_diskflags & GFS2_DIF_INHERIT_JDATA) ||
+		    gfs2_tune_get(sdp, gt_new_files_jdata))
+			ip->i_diskflags |= GFS2_DIF_JDATA;
+		gfs2_set_aops(inode);
+		break;
+	case S_IFDIR:
+		ip->i_diskflags |= (dip->i_diskflags & GFS2_DIF_INHERIT_JDATA);
+		ip->i_diskflags |= GFS2_DIF_JDATA;
+		ip->i_entries = 2;
+		break;
+	}
+	gfs2_set_inode_flags(inode);
 
 	if ((GFS2_I(sdp->sd_root_dir->d_inode) == dip) ||
 	    (dip->i_diskflags & GFS2_DIF_TOPDIR))
@@ -700,10 +698,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	gfs2_set_iop(inode);
 	insert_inode_hash(inode);
 
-	error = gfs2_inode_refresh(ip);
-	if (error)
-		goto fail_gunlock3;
-
 	error = gfs2_acl_create(dip, inode);
 	if (error)
 		goto fail_gunlock3;
@@ -716,14 +710,9 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_gunlock3;
 
-	if (bh)
-		brelse(bh);
-
-	gfs2_trans_end(sdp);
-	gfs2_inplace_release(dip);
-	gfs2_quota_unlock(dip);
-	mark_inode_dirty(inode);
-	gfs2_glock_dq_uninit_m(2, ghs);
+	brelse(bh);
+	gfs2_glock_dq_uninit(ghs);
+	gfs2_glock_dq_uninit(ghs + 1);
 	d_instantiate(dentry, inode);
 	return 0;
 
@@ -1126,7 +1115,9 @@ static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 
 static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
-	return gfs2_create_inode(dir, dentry, S_IFDIR | mode, 0, NULL, 0, 0);
+	struct gfs2_sbd *sdp = GFS2_SB(dir);
+	unsigned dsize = sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode);
+	return gfs2_create_inode(dir, dentry, S_IFDIR | mode, 0, NULL, dsize, 0);
 }
 
 /**
-- 
1.7.4

