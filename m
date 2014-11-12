Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965481AbaKLCyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:54:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934458AbaKLBme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:42:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sami Liedes <sami.liedes@iki.fi>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.14 102/203] ext4: add ext4_iget_normal() which is to be used for dir tree lookups
Date: Wed, 12 Nov 2014 10:16:12 +0900
Message-Id: <20141112011547.362219353@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/inode.c |    7 +++++++
 fs/ext4/namei.c |    4 ++--
 fs/ext4/super.c |    2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2110,6 +2110,7 @@ int do_journal_get_write_access(handle_t
 #define CONVERT_INLINE_DATA	 2
 
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
+extern struct inode *ext4_iget_normal(struct super_block *, unsigned long);
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4250,6 +4250,13 @@ bad_inode:
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
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1429,7 +1429,7 @@ static struct dentry *ext4_lookup(struct
 					 dentry);
 			return ERR_PTR(-EIO);
 		}
-		inode = ext4_iget(dir->i_sb, ino);
+		inode = ext4_iget_normal(dir->i_sb, ino);
 		if (inode == ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,
 					 "deleted inode referenced: %u",
@@ -1460,7 +1460,7 @@ struct dentry *ext4_get_parent(struct de
 		return ERR_PTR(-EIO);
 	}
 
-	return d_obtain_alias(ext4_iget(child->d_inode->i_sb, ino));
+	return d_obtain_alias(ext4_iget_normal(child->d_inode->i_sb, ino));
 }
 
 /*
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -996,7 +996,7 @@ static struct inode *ext4_nfs_get_inode(
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode = ext4_iget(sb, ino);
+	inode = ext4_iget_normal(sb, ino);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 	if (generation && inode->i_generation != generation) {


