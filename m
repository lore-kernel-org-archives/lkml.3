Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaLNUcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:32:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaLNUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 04/47] fat: fix oops on corrupted vfat fs
Date: Sun, 14 Dec 2014 12:20:39 -0800
Message-Id: <20141214201818.683512474@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1ead0e79bfedd4b563b8ea7c585ca3884b0c89a7 upstream.

a) don't bother with ->d_time for positives - we only check it for
   negatives anyway.

b) make sure to set it at unlink and rmdir time - at *that* point
   soon-to-be negative dentry matches then-current directory contents

c) don't go into renaming of old alias in vfat_lookup() unless it
   has the same parent (which it will, unless we are seeing corrupted
   image)

[hirofumi@mail.parknet.co.jp: make change minimum, don't call d_move() for dir]
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fat/namei_vfat.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
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


