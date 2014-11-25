Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaKYKlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58245 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaKYKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 057/254] GFS2: Make rename not save dirent location
Date: Tue, 25 Nov 2014 10:36:47 +0000
Message-Id: <1416912004-5928-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Peterson <rpeterso@redhat.com>

commit 19aeb5a65f1a6504fc665466c188241e7393d66f upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/gfs2/dir.c   | 9 +++++++--
 fs/gfs2/dir.h   | 1 +
 fs/gfs2/inode.c | 6 +++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 1a349f9a9685..5d4261ff5d23 100644
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
index 126c65dda028..e1b309c24dab 100644
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
index 9c1a680ee468..ba4b2e5377db 100644
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
@@ -897,7 +897,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder ghs[2];
 	struct buffer_head *dibh;
-	struct gfs2_diradd da = { .bh = NULL, };
+	struct gfs2_diradd da = { .bh = NULL, .save_loc = 1, };
 	int error;
 
 	if (S_ISDIR(inode->i_mode))
@@ -1335,7 +1335,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	struct gfs2_rgrpd *nrgd;
 	unsigned int num_gh;
 	int dir_rename = 0;
-	struct gfs2_diradd da = { .nr_blocks = 0, };
+	struct gfs2_diradd da = { .nr_blocks = 0, .save_loc = 0, };
 	unsigned int x;
 	int error;
 
-- 
2.1.0

