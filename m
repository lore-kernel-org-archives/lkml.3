Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3IPMwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:52:12 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:47421 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3IPMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:49 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Steven Whitehouse <swhiteho@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 08/11] gfs2: fix dentry leaks
Date: Mon, 16 Sep 2013 14:52:02 +0200
Message-Id: <1379335925-30858-9-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

We need to dput() the result of d_splice_alias(), unless it is passed to
finish_no_open().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: stable@vger.kernel.org
---
 fs/gfs2/inode.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index abe7dae..9a1be62 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -555,7 +555,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	struct gfs2_inode *dip = GFS2_I(dir), *ip;
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_glock *io_gl;
-	struct dentry *d;
 	int error;
 	u32 aflags = 0;
 	int arq;
@@ -582,15 +581,18 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	inode = gfs2_dir_search(dir, &dentry->d_name, !S_ISREG(mode) || excl);
 	error = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
-		d = d_splice_alias(inode, dentry);
+		struct dentry *d = d_splice_alias(inode, dentry);
 		error = 0;
 		if (file) {
-			if (d == NULL)
-				d = dentry;
-			if (S_ISREG(inode->i_mode))
-				error = finish_open(file, d, gfs2_open_common, opened);
-			else
+			if (S_ISREG(inode->i_mode)) {
+				error = finish_open(file, d ? d : dentry,
+						    gfs2_open_common, opened);
+				dput(d);
+			} else {
 				error = finish_no_open(file, d);
+			}
+		} else {
+			dput(d);
 		}
 		gfs2_glock_dq_uninit(ghs);
 		return error;
@@ -777,8 +779,10 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
 		error = finish_open(file, d ? d : dentry, gfs2_open_common, opened);
 
 	gfs2_glock_dq_uninit(&gh);
-	if (error)
+	if (error) {
+		dput(d);
 		return ERR_PTR(error);
+	}
 	return d;
 }
 
@@ -1159,13 +1163,15 @@ static int gfs2_atomic_open(struct inode *dir, struct dentry *dentry,
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
1.8.1.4

