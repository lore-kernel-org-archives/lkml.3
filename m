Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaJCVhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:37:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaJCVfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:35:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.16 107/357] ufs: fix deadlocks introduced by sb mutex merge
Date: Fri,  3 Oct 2014 14:28:13 -0700
Message-Id: <20141003212936.690670660@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 9ef7db7f38d0472dd9c444e42d5c5175ccbe5451 upstream.

Commit 0244756edc4b ("ufs: sb mutex merge + mutex_destroy") introduces
deadlocks in ufs_new_inode() and ufs_free_inode().
Most callers of that functions acqure the mutex by themselves and
ufs_{new,free}_inode() do that via lock_ufs(),
i.e we have an unavoidable double lock.

The patch proposes to resolve the issue by making sure that
ufs_{new,free}_inode() are not called with the mutex held.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ufs/inode.c |    7 ++-----
 fs/ufs/namei.c |   14 ++++++--------
 2 files changed, 8 insertions(+), 13 deletions(-)

--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -902,9 +902,6 @@ void ufs_evict_inode(struct inode * inod
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
-	if (want_delete) {
-		lock_ufs(inode->i_sb);
-		ufs_free_inode (inode);
-		unlock_ufs(inode->i_sb);
-	}
+	if (want_delete)
+		ufs_free_inode(inode);
 }
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -126,12 +126,12 @@ static int ufs_symlink (struct inode * d
 	if (l > sb->s_blocksize)
 		goto out_notlocked;
 
-	lock_ufs(dir->i_sb);
 	inode = ufs_new_inode(dir, S_IFLNK | S_IRWXUGO);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
-		goto out;
+		goto out_notlocked;
 
+	lock_ufs(dir->i_sb);
 	if (l > UFS_SB(sb)->s_uspi->s_maxsymlinklen) {
 		/* slow symlink */
 		inode->i_op = &ufs_symlink_inode_operations;
@@ -181,13 +181,9 @@ static int ufs_mkdir(struct inode * dir,
 	struct inode * inode;
 	int err;
 
-	lock_ufs(dir->i_sb);
-	inode_inc_link_count(dir);
-
 	inode = ufs_new_inode(dir, S_IFDIR|mode);
-	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
-		goto out_dir;
+		return PTR_ERR(inode);
 
 	inode->i_op = &ufs_dir_inode_operations;
 	inode->i_fop = &ufs_dir_operations;
@@ -195,6 +191,9 @@ static int ufs_mkdir(struct inode * dir,
 
 	inode_inc_link_count(inode);
 
+	lock_ufs(dir->i_sb);
+	inode_inc_link_count(dir);
+
 	err = ufs_make_empty(inode, dir);
 	if (err)
 		goto out_fail;
@@ -212,7 +211,6 @@ out_fail:
 	inode_dec_link_count(inode);
 	inode_dec_link_count(inode);
 	iput (inode);
-out_dir:
 	inode_dec_link_count(dir);
 	unlock_ufs(dir->i_sb);
 	goto out;


