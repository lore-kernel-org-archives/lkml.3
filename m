Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaKZPbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:31:33 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54806 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaKZPbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:31:31 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] fat: Fix oops on corrupted vfat fs
Date: Thu, 27 Nov 2014 00:31:28 +0900
Message-ID: <873896x9kf.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a) don't bother with ->d_time for positives - we only check it for negatives
anyway.
b) make sure to set it at unlink and rmdir time - at *that* point soon-to-be
negative dentry matches then-current directory contents
c) don't go into renaming of old alias in vfat_lookup() unless it has
the same parent (which it will, unless we are seeing corrupted image)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org> # 3.17.x
[Make change minimum, don't call d_move() for dir]
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/namei_vfat.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN fs/fat/namei_vfat.c~fat-corrupt-fs-fix fs/fat/namei_vfat.c
--- linux/fs/fat/namei_vfat.c~fat-corrupt-fs-fix	2014-11-10 01:09:08.782815944 +0900
+++ linux-hirofumi/fs/fat/namei_vfat.c	2014-11-10 01:56:47.283117983 +0900
@@ -736,7 +736,12 @@ static struct dentry *vfat_lookup(struct
 	}
 
 	alias = d_find_alias(inode);
-	if (alias && !vfat_d_anon_disconn(alias)) {
+	/*
+	 * Checking "alias->d_parent == dentry->d_parent" to make sure
+	 * FS is not corrupted (especially double linked dir).
+	 */
+	if (alias && alias->d_parent == dentry->d_parent &&
+	    !vfat_d_anon_disconn(alias)) {
 		/*
 		 * This inode has non anonymous-DCACHE_DISCONNECTED
 		 * dentry. This means, the user did ->lookup() by an
@@ -755,12 +760,9 @@ static struct dentry *vfat_lookup(struct
 
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
-	dentry = d_splice_alias(inode, dentry);
-	if (dentry)
-		dentry->d_time = dentry->d_parent->d_inode->i_version;
-	return dentry;
-
+	if (!inode)
+		dentry->d_time = dir->i_version;
+	return d_splice_alias(inode, dentry);
 error:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return ERR_PTR(err);
@@ -793,7 +795,6 @@ static int vfat_create(struct inode *dir
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -824,6 +825,7 @@ static int vfat_rmdir(struct inode *dir,
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
+	dentry->d_time = dir->i_version;
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -849,6 +851,7 @@ static int vfat_unlink(struct inode *dir
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
+	dentry->d_time = dir->i_version;
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -889,7 +892,6 @@ static int vfat_mkdir(struct inode *dir,
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
_
