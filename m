Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbaKSVCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:02:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbaKSVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:01:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.17 128/141] GFS2: Make rename not save dirent location
Date: Wed, 19 Nov 2014 12:52:31 -0800
Message-Id: <20141119205155.009579512@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/dir.c   |    9 +++++++--
 fs/gfs2/dir.h   |    1 +
 fs/gfs2/inode.c |    6 +++---
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -2100,8 +2100,13 @@ int gfs2_diradd_alloc_required(struct in
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
 
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -23,6 +23,7 @@ struct gfs2_diradd {
 	unsigned nr_blocks;
 	struct gfs2_dirent *dent;
 	struct buffer_head *bh;
+	int save_loc;
 };
 
 extern struct inode *gfs2_dir_search(struct inode *dir,
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -600,7 +600,7 @@ static int gfs2_create_inode(struct inod
 	int error, free_vfs_inode = 0;
 	u32 aflags = 0;
 	unsigned blocks = 1;
-	struct gfs2_diradd da = { .bh = NULL, };
+	struct gfs2_diradd da = { .bh = NULL, .save_loc = 1, };
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return -ENAMETOOLONG;
@@ -899,7 +899,7 @@ static int gfs2_link(struct dentry *old_
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder ghs[2];
 	struct buffer_head *dibh;
-	struct gfs2_diradd da = { .bh = NULL, };
+	struct gfs2_diradd da = { .bh = NULL, .save_loc = 1, };
 	int error;
 
 	if (S_ISDIR(inode->i_mode))
@@ -1337,7 +1337,7 @@ static int gfs2_rename(struct inode *odi
 	struct gfs2_rgrpd *nrgd;
 	unsigned int num_gh;
 	int dir_rename = 0;
-	struct gfs2_diradd da = { .nr_blocks = 0, };
+	struct gfs2_diradd da = { .nr_blocks = 0, .save_loc = 0, };
 	unsigned int x;
 	int error;
 


