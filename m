Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaDAJRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:17:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaDAJQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:54 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 28/29] GFS2: Fix uninitialized VFS inode in gfs2_create_inode
Date: Tue,  1 Apr 2014 10:15:40 +0100
Message-Id: <1396343741-1524-29-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhi Das <adas@redhat.com>

When gfs2_create_inode() fails due to quota violation, the VFS
inode is not completely uninitialized. This can cause a list
corruption error.

This patch correctly uninitializes the VFS inode when a quota
violation occurs in the gfs2_create_inode codepath.

Resolves: rhbz#1059808
Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index ef26ed9..bdf70c1 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -371,6 +371,7 @@ enum {
 	GIF_ALLOC_FAILED	= 2,
 	GIF_SW_PAGED		= 3,
 	GIF_ORDERED		= 4,
+	GIF_FREE_VFS_INODE      = 5,
 };
 
 struct gfs2_inode {
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 69ed57a..28cc7bf 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -597,7 +597,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_glock *io_gl;
 	struct dentry *d;
-	int error;
+	int error, free_vfs_inode = 0;
 	u32 aflags = 0;
 	unsigned blocks = 1;
 	struct gfs2_diradd da = { .bh = NULL, };
@@ -788,15 +788,16 @@ fail_free_acls:
 	if (acl)
 		posix_acl_release(acl);
 fail_free_vfs_inode:
-	free_inode_nonrcu(inode);
-	inode = NULL;
+	free_vfs_inode = 1;
 fail_gunlock:
 	gfs2_dir_no_add(&da);
 	gfs2_glock_dq_uninit(ghs);
 	if (inode && !IS_ERR(inode)) {
 		clear_nlink(inode);
-		mark_inode_dirty(inode);
-		set_bit(GIF_ALLOC_FAILED, &GFS2_I(inode)->i_flags);
+		if (!free_vfs_inode)
+			mark_inode_dirty(inode);
+		set_bit(free_vfs_inode ? GIF_FREE_VFS_INODE : GIF_ALLOC_FAILED,
+			&GFS2_I(inode)->i_flags);
 		iput(inode);
 	}
 fail:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index a08c66e..29cacd5 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1248,7 +1248,7 @@ static int gfs2_drop_inode(struct inode *inode)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 
-	if (inode->i_nlink) {
+	if (!test_bit(GIF_FREE_VFS_INODE, &ip->i_flags) && inode->i_nlink) {
 		struct gfs2_glock *gl = ip->i_iopen_gh.gh_gl;
 		if (gl && test_bit(GLF_DEMOTE, &gl->gl_flags))
 			clear_nlink(inode);
@@ -1463,6 +1463,11 @@ static void gfs2_evict_inode(struct inode *inode)
 	struct gfs2_holder gh;
 	int error;
 
+	if (test_bit(GIF_FREE_VFS_INODE, &ip->i_flags)) {
+		clear_inode(inode);
+		return;
+	}
+
 	if (inode->i_nlink || (sb->s_flags & MS_RDONLY))
 		goto out;
 
-- 
1.8.3.1

