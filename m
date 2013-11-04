Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3KDLgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab3KDLgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:32 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@suse.cz>,
        Steven Whitehouse <swhiteho@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 07/19] GFS2: fix dentry leaks
Date: Mon,  4 Nov 2013 11:09:30 +0000
Message-Id: <1383563382-8535-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>

We need to dput() the result of d_splice_alias(), unless it is passed to
finish_no_open().

Edited by Steven Whitehouse in order to make it apply to the current
GFS2 git tree, and taking account of a prerequisite patch which hasn't
been applied.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: stable@vger.kernel.org

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 6d7f976..cd58611 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -585,12 +585,14 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		d = d_splice_alias(inode, dentry);
 		error = 0;
 		if (file) {
-			if (d == NULL)
-				d = dentry;
-			if (S_ISREG(inode->i_mode))
-				error = finish_open(file, d, gfs2_open_common, opened);
-			else
+			if (S_ISREG(inode->i_mode)) {
+				WARN_ON(d != NULL);
+				error = finish_open(file, dentry, gfs2_open_common, opened);
+			} else {
 				error = finish_no_open(file, d);
+			}
+		} else {
+			dput(d);
 		}
 		gfs2_glock_dq_uninit(ghs);
 		return error;
@@ -777,8 +779,10 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
 		error = finish_open(file, dentry, gfs2_open_common, opened);
 
 	gfs2_glock_dq_uninit(&gh);
-	if (error)
+	if (error) {
+		dput(d);
 		return ERR_PTR(error);
+	}
 	return d;
 }
 
@@ -1159,14 +1163,16 @@ static int gfs2_atomic_open(struct inode *dir, struct dentry *dentry,
 	d = __gfs2_lookup(dir, dentry, file, opened);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
-	if (d == NULL)
-		d = dentry;
-	if (d->d_inode) {
+	if (d != NULL)
+		dentry = d;
+	if (dentry->d_inode) {
 		if (!(*opened & FILE_OPENED))
-			return finish_no_open(file, d);
+			return finish_no_open(file, dentry);
+		dput(d);
 		return 0;
 	}
 
+	BUG_ON(d != NULL);
 	if (!(flags & O_CREAT))
 		return -ENOENT;
 
-- 
1.7.4.4

