Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaJHJy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:54:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbaJHJxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:53:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: Make rename not save dirent location
Date: Wed,  8 Oct 2014 10:53:11 +0100
Message-Id: <1412761993-5982-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1412761993-5982-1-git-send-email-swhiteho@redhat.com>
References: <1412761993-5982-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a regression in the patch "GFS2: Remember directory
insert point", commit 2b47dad866d04f14c328f888ba5406057b8c7d33.
The problem had to do with the rename function: The function found
space for the new dirent, and remembered that location. But then the
old dirent was removed, which often moved the eligible location for
the renamed dirent. Putting the new dirent at the saved location
caused file system corruption.

This patch adds a new "save_loc" variable to struct gfs2_diradd.
If 1, the dirent location is saved. If 0, the dirent location is not
saved and the buffer_head is released as per previous behavior.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 1a349f9..5d4261f 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -2100,8 +2100,13 @@ int gfs2_diradd_alloc_required(struct inode *inode, const struct qstr *name,
 	}
 	if (IS_ERR(dent))
 		return PTR_ERR(dent);
-	da->bh = bh;
-	da->dent = dent;
+
+	if (da->save_loc) {
+		da->bh = bh;
+		da->dent = dent;
+	} else {
+		brelse(bh);
+	}
 	return 0;
 }
 
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index 126c65d..e1b309c 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -23,6 +23,7 @@ struct gfs2_diradd {
 	unsigned nr_blocks;
 	struct gfs2_dirent *dent;
 	struct buffer_head *bh;
+	int save_loc;
 };
 
 extern struct inode *gfs2_dir_search(struct inode *dir,
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9516f5c..fcf42ea 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -600,7 +600,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	int error, free_vfs_inode = 0;
 	u32 aflags = 0;
 	unsigned blocks = 1;
-	struct gfs2_diradd da = { .bh = NULL, };
+	struct gfs2_diradd da = { .bh = NULL, .save_loc = 1, };
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return -ENAMETOOLONG;
@@ -900,7 +900,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder ghs[2];
 	struct buffer_head *dibh;
-	struct gfs2_diradd da = { .bh = NULL, };
+	struct gfs2_diradd da = { .bh = NULL, .save_loc = 1, };
 	int error;
 
 	if (S_ISDIR(inode->i_mode))
@@ -1338,7 +1338,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	struct gfs2_rgrpd *nrgd;
 	unsigned int num_gh;
 	int dir_rename = 0;
-	struct gfs2_diradd da = { .nr_blocks = 0, };
+	struct gfs2_diradd da = { .nr_blocks = 0, .save_loc = 0, };
 	unsigned int x;
 	int error;
 
-- 
1.8.3.1

