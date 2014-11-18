Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbaKROsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:48:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbaKROKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 122/206] ext4: add ext4_iget_normal() which is to be used for dir tree lookups
Date: Tue, 18 Nov 2014 15:07:57 +0100
Message-Id: <bead15b503cf4007a0383f6e8a7409569c41a546.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/ext4.h  | 1 +
 fs/ext4/inode.c | 7 +++++++
 fs/ext4/namei.c | 4 ++--
 fs/ext4/super.c | 2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 54d94db2cf03..4eca63f8314a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2093,6 +2093,7 @@ int do_journal_get_write_access(handle_t *handle,
 #define CONVERT_INLINE_DATA	 2
 
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
+extern struct inode *ext4_iget_normal(struct super_block *, unsigned long);
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 474b9eafee43..a43859ca3184 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4251,6 +4251,13 @@ bad_inode:
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
index 5a0408d7b114..8e000a058958 100644
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
index cf3068a50b48..2914dc7ce9e8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -977,7 +977,7 @@ static struct inode *ext4_nfs_get_inode(struct super_block *sb,
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode = ext4_iget(sb, ino);
+	inode = ext4_iget_normal(sb, ino);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 	if (generation && inode->i_generation != generation) {
-- 
2.1.3

