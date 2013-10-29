Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3J2U7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:59:30 -0400
Received: from mail-gg0-f169.google.com ([209.85.161.169]:39157 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3J2U72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:59:28 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net (open list:9P FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] 9p: code refactor in vfs_inode.c
Date: Tue, 29 Oct 2013 17:54:37 -0300
Message-Id: <1383080077-16071-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In unixmode2p9mode():
Change 'res' type from int to u32.

In p9mode2unixmode():
Change 'res' type from int to umode_t.
Add sscanf() return value check and p9_debug() when error.
Add possibility to call it passing NULL to rdev parameter.
Only make device if 'rdev' pointer isn't NULL.
Set '-EIO' to rdev if error when P9_DMDEVICE.
Centralize return.

In v9fs_test_inode():
Change 'umode' type from int to umode_t.
Remove now useless 'rdev'.

In v9fs_qid_iget():
Return rdev if 'IS_ERR_VALUE(rdev)' is true after call p9mode2unixmode().

In v9fs_refresh_inode():
Change 'umode' type from int to umode_t.
Remove now useless 'rdev'.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/9p/vfs_inode.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 94de6d1..e3d56f1 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -63,7 +63,7 @@ static const struct inode_operations v9fs_symlink_inode_operations;
 
 static u32 unixmode2p9mode(struct v9fs_session_info *v9ses, umode_t mode)
 {
-	int res;
+	u32 res;
 	res = mode & 0777;
 	if (S_ISDIR(mode))
 		res |= P9_DMDIR;
@@ -125,10 +125,9 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 			       struct p9_wstat *stat, dev_t *rdev)
 {
-	int res;
+	umode_t res;
 	u32 mode = stat->mode;
 
-	*rdev = 0;
 	res = p9mode2perm(v9ses, stat);
 
 	if ((mode & P9_DMDIR) == P9_DMDIR)
@@ -144,10 +143,15 @@ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 	else if ((mode & P9_DMDEVICE) && (v9fs_proto_dotu(v9ses))
 		 && (v9ses->nodev == 0)) {
 		char type = 0, ext[32];
-		int major = -1, minor = -1;
+		u32 major = 0, minor = 0;
 
 		strlcpy(ext, stat->extension, sizeof(ext));
-		sscanf(ext, "%c %u %u", &type, &major, &minor);
+		if (sscanf(ext, "%c %u %u", &type, &major, &minor) < 3) {
+			p9_debug(P9_DEBUG_ERROR,
+				 "It's necessary define type [%c], major [%u] and minor [%u]" \
+				 "values when mode is P9_DMDEVICE\n", type, major, minor);
+			goto err_dev;
+		}
 		switch (type) {
 		case 'c':
 			res |= S_IFCHR;
@@ -158,11 +162,18 @@ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 		default:
 			p9_debug(P9_DEBUG_ERROR, "Unknown special type %c %s\n",
 				 type, stat->extension);
-		};
-		*rdev = MKDEV(major, minor);
+			goto err_dev;
+		}
+		/* Only make device if rdev pointer isn't NULL */
+		if (rdev)
+			*rdev = MKDEV(major, minor);
 	} else
 		res |= S_IFREG;
-
+	goto ret;
+err_dev:
+	if (rdev)
+		rdev = ERR_PTR(-EIO);
+ret:
 	return res;
 }
 
@@ -460,13 +471,12 @@ void v9fs_evict_inode(struct inode *inode)
 
 static int v9fs_test_inode(struct inode *inode, void *data)
 {
-	int umode;
-	dev_t rdev;
+	umode_t umode;
 	struct v9fs_inode *v9inode = V9FS_I(inode);
 	struct p9_wstat *st = (struct p9_wstat *)data;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 
-	umode = p9mode2unixmode(v9ses, st, &rdev);
+	umode = p9mode2unixmode(v9ses, st, NULL);
 	/* don't match inode of different type */
 	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
 		return 0;
@@ -526,6 +536,10 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 	 */
 	inode->i_ino = i_ino;
 	umode = p9mode2unixmode(v9ses, st, &rdev);
+	if (IS_ERR_VALUE(rdev)) {
+		retval = rdev;
+		goto error;
+	}
 	retval = v9fs_init_inode(v9ses, inode, umode, rdev);
 	if (retval)
 		goto error;
@@ -1461,8 +1475,7 @@ v9fs_vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t rde
 
 int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
 {
-	int umode;
-	dev_t rdev;
+	umode_t umode;
 	loff_t i_size;
 	struct p9_wstat *st;
 	struct v9fs_session_info *v9ses;
@@ -1474,7 +1487,7 @@ int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
 	/*
 	 * Don't update inode if the file type is different
 	 */
-	umode = p9mode2unixmode(v9ses, st, &rdev);
+	umode = p9mode2unixmode(v9ses, st, NULL);
 	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
 		goto out;
 
-- 
1.8.4

