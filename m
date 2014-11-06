Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaKFWor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59186 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaKFWok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:40 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 068/162] ext4: add ext4_iget_normal() which is to be used for dir tree lookups
Date: Thu,  6 Nov 2014 14:35:32 -0800
Message-Id: <1415313426-9622-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit f4bb2981024fc91b23b4d09a8817c415396dbabb upstream.

If there is a corrupted file system which has directory entries that
point at reserved, metadata inodes, prohibit them from being used by
treating them the same way we treat Boot Loader inodes --- that is,
mark them to be bad inodes.  This prohibits them from being opened,
deleted, or modified via chmod, chown, utimes, etc.

In particular, this prevents a corrupted file system which has a
directory entry which points at the journal inode from being deleted
and its blocks released, after which point Much Hilarity Ensues.

Reported-by: Sami Liedes <sami.liedes@iki.fi>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/ext4.h  | 1 +
 fs/ext4/inode.c | 7 +++++++
 fs/ext4/namei.c | 4 ++--
 fs/ext4/super.c | 2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e531054..c9d0794 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2110,6 +2110,7 @@ int do_journal_get_write_access(handle_t *handle,
 #define CONVERT_INLINE_DATA	 2
 
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
+extern struct inode *ext4_iget_normal(struct super_block *, unsigned long);
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 37d3b1a..a4c4f38 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4260,6 +4260,13 @@ bad_inode:
 	return ERR_PTR(ret);
 }
 
+struct inode *ext4_iget_normal(struct super_block *sb, unsigned long ino)
+{
+	if (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)
+		return ERR_PTR(-EIO);
+	return ext4_iget(sb, ino);
+}
+
 static int ext4_inode_blocks_set(handle_t *handle,
 				struct ext4_inode *raw_inode,
 				struct ext4_inode_info *ei)
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d4fa3ed..5bfbf94 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1430,7 +1430,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 					 dentry->d_name.name);
 			return ERR_PTR(-EIO);
 		}
-		inode = ext4_iget(dir->i_sb, ino);
+		inode = ext4_iget_normal(dir->i_sb, ino);
 		if (inode == ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,
 					 "deleted inode referenced: %u",
@@ -1461,7 +1461,7 @@ struct dentry *ext4_get_parent(struct dentry *child)
 		return ERR_PTR(-EIO);
 	}
 
-	return d_obtain_alias(ext4_iget(child->d_inode->i_sb, ino));
+	return d_obtain_alias(ext4_iget_normal(child->d_inode->i_sb, ino));
 }
 
 /*
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5ee03e5d..c888f23 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -996,7 +996,7 @@ static struct inode *ext4_nfs_get_inode(struct super_block *sb,
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode = ext4_iget(sb, ino);
+	inode = ext4_iget_normal(sb, ino);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 	if (generation && inode->i_generation != generation) {
-- 
1.9.1

