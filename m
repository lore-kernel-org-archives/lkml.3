Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaLAQtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:49:45 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47990 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaLAQtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:49:40 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 3/3] nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races
Date: Tue,  2 Dec 2014 01:41:47 +0900
Message-Id: <1417452107-6411-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417452107-6411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1417452107-6411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20110525(IM151)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

same story as in commit 41080b5a240113328c607f22b849f653373db0ce
(similar ext2 fix) except that nilfs2 needs to use
insert_inode_locked4() instead of insert_inode_locked() and a bug of a
check for dead inodes needs to be fixed.

If nilfs_iget() is called from nfsd after nilfs_new_inode() calls
insert_inode_locked4(), nilfs_iget() will wait for unlock_new_inode()
at the end of nilfs_mkdir()/nilfs_create()/etc to unlock the inode.

If nilfs_iget() is called before nilfs_new_inode() calls
insert_inode_locked4(), it will create an in-core inode and read its
data from the on-disk inode.  But, nilfs_iget() will find i_nlink
equals zero and fail at nilfs_read_inode_common(), which will lead it
to call iget_failed() and cleanly fail.

However, this sanity check doesn't work as expected for reused on-disk
inodes because they leave a non-zero value in i_mode field and it
hinders the test of i_nlink.  This patch also fixes the issue by
removing the test on i_mode that nilfs2 doesn't need.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/inode.c | 32 ++++++++++++++++++++++++--------
 fs/nilfs2/namei.c | 15 ++++++++++++---
 2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index e1fa69b..8b59695 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -49,6 +49,8 @@ struct nilfs_iget_args {
 	int for_gc;
 };
 
+static int nilfs_iget_test(struct inode *inode, void *opaque);
+
 void nilfs_inode_add_blocks(struct inode *inode, int n)
 {
 	struct nilfs_root *root = NILFS_I(inode)->i_root;
@@ -348,6 +350,17 @@ const struct address_space_operations nilfs_aops = {
 	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
+static int nilfs_insert_inode_locked(struct inode *inode,
+				     struct nilfs_root *root,
+				     unsigned long ino)
+{
+	struct nilfs_iget_args args = {
+		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+	};
+
+	return insert_inode_locked4(inode, ino, nilfs_iget_test, &args);
+}
+
 struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
@@ -383,7 +396,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)) {
 		err = nilfs_bmap_read(ii->i_bmap, NULL);
 		if (err < 0)
-			goto failed_bmap;
+			goto failed_after_creation;
 
 		set_bit(NILFS_I_BMAP, &ii->i_state);
 		/* No lock is needed; iget() ensures it. */
@@ -399,21 +412,24 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	spin_lock(&nilfs->ns_next_gen_lock);
 	inode->i_generation = nilfs->ns_next_generation++;
 	spin_unlock(&nilfs->ns_next_gen_lock);
-	insert_inode_hash(inode);
+	if (nilfs_insert_inode_locked(inode, root, ino) < 0) {
+		err = -EIO;
+		goto failed_after_creation;
+	}
 
 	err = nilfs_init_acl(inode, dir);
 	if (unlikely(err))
-		goto failed_acl; /* never occur. When supporting
+		goto failed_after_creation; /* never occur. When supporting
 				    nilfs_init_acl(), proper cancellation of
 				    above jobs should be considered */
 
 	return inode;
 
- failed_acl:
- failed_bmap:
+ failed_after_creation:
 	clear_nlink(inode);
+	unlock_new_inode(inode);
 	iput(inode);  /* raw_inode will be deleted through
-			 generic_delete_inode() */
+			 nilfs_evict_inode() */
 	goto failed;
 
  failed_ifile_create_inode:
@@ -461,8 +477,8 @@ int nilfs_read_inode_common(struct inode *inode,
 	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
-	if (inode->i_nlink == 0 && inode->i_mode == 0)
-		return -EINVAL; /* this inode is deleted */
+	if (inode->i_nlink == 0)
+		return -ESTALE; /* this inode is deleted */
 
 	inode->i_blocks = le64_to_cpu(raw_inode->i_blocks);
 	ii->i_flags = le32_to_cpu(raw_inode->i_flags);
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 9de78f0..0f84b25 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -51,9 +51,11 @@ static inline int nilfs_add_nondir(struct dentry *dentry, struct inode *inode)
 	int err = nilfs_add_link(dentry, inode);
 	if (!err) {
 		d_instantiate(dentry, inode);
+		unlock_new_inode(inode);
 		return 0;
 	}
 	inode_dec_link_count(inode);
+	unlock_new_inode(inode);
 	iput(inode);
 	return err;
 }
@@ -182,6 +184,7 @@ out:
 out_fail:
 	drop_nlink(inode);
 	nilfs_mark_inode_dirty(inode);
+	unlock_new_inode(inode);
 	iput(inode);
 	goto out;
 }
@@ -201,11 +204,15 @@ static int nilfs_link(struct dentry *old_dentry, struct inode *dir,
 	inode_inc_link_count(inode);
 	ihold(inode);
 
-	err = nilfs_add_nondir(dentry, inode);
-	if (!err)
+	err = nilfs_add_link(dentry, inode);
+	if (!err) {
+		d_instantiate(dentry, inode);
 		err = nilfs_transaction_commit(dir->i_sb);
-	else
+	} else {
+		inode_dec_link_count(inode);
+		iput(inode);
 		nilfs_transaction_abort(dir->i_sb);
+	}
 
 	return err;
 }
@@ -243,6 +250,7 @@ static int nilfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 	nilfs_mark_inode_dirty(inode);
 	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
 out:
 	if (!err)
 		err = nilfs_transaction_commit(dir->i_sb);
@@ -255,6 +263,7 @@ out_fail:
 	drop_nlink(inode);
 	drop_nlink(inode);
 	nilfs_mark_inode_dirty(inode);
+	unlock_new_inode(inode);
 	iput(inode);
 out_dir:
 	drop_nlink(dir);
-- 
1.8.3.1

