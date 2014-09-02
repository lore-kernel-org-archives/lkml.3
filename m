Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaIBHka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:40:30 -0400
Received: from mail.ispras.ru ([83.149.199.45]:55691 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaIBHk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:40:29 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH v2] ufs: fix deadlocks introduced by sb mutex merge
Date: Tue,  2 Sep 2014 11:40:17 +0400
Message-Id: <1409643617-13594-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140901231306.GL7996@ZenIV.linux.org.uk>
References: <20140901231306.GL7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0244756edc4b ("ufs: sb mutex merge + mutex_destroy") introduces
deadlocks in ufs_new_inode() and ufs_free_inode().
Most callers of that functions acqure the mutex by themselves and
ufs_{new,free}_inode() do that via lock_ufs(),
i.e we have an unavoidable double lock.

The patch proposes to resolve the issue by making sure that
ufs_{new,free}_inode() are not called with the mutex held.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/ufs/inode.c |  7 ++-----
 fs/ufs/namei.c | 14 ++++++--------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 7c580c97990e..be7d42c7d938 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -902,9 +902,6 @@ void ufs_evict_inode(struct inode * inode)
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
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 90d74b8f8eba..2df62a73f20c 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -126,12 +126,12 @@ static int ufs_symlink (struct inode * dir, struct dentry * dentry,
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
@@ -181,13 +181,9 @@ static int ufs_mkdir(struct inode * dir, struct dentry * dentry, umode_t mode)
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
@@ -195,6 +191,9 @@ static int ufs_mkdir(struct inode * dir, struct dentry * dentry, umode_t mode)
 
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
-- 
1.9.1

