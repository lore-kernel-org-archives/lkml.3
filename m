Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaEWJrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:47:01 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54214 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaEWJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:44:03 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 05/13] vfs: export check_sticky()
Date: Fri, 23 May 2014 11:43:35 +0200
Message-Id: <1400838223-30844-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

It's already duplicated in btrfs and about to be used in overlayfs too.

Move the sticky bit check to an inline helper and call the out-of-line
helper only in the unlikly case of the sticky bit being set.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/btrfs/ioctl.c   | 20 +-------------------
 fs/namei.c         |  9 ++-------
 include/linux/fs.h |  9 +++++++++
 3 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2f6d7b13b5bd..7b4184923fbd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -730,23 +730,6 @@ out:
 	return ret;
 }
 
-/*  copy of check_sticky in fs/namei.c()
-* It's inline, so penalty for filesystems that don't use sticky bit is
-* minimal.
-*/
-static inline int btrfs_check_sticky(struct inode *dir, struct inode *inode)
-{
-	kuid_t fsuid = current_fsuid();
-
-	if (!(dir->i_mode & S_ISVTX))
-		return 0;
-	if (uid_eq(inode->i_uid, fsuid))
-		return 0;
-	if (uid_eq(dir->i_uid, fsuid))
-		return 0;
-	return !capable(CAP_FOWNER);
-}
-
 /*  copy of may_delete in fs/namei.c()
  *	Check whether we can remove a link victim from directory dir, check
  *  whether the type of victim is right.
@@ -782,8 +765,7 @@ static int btrfs_may_delete(struct inode *dir, struct dentry *victim, int isdir)
 		return error;
 	if (IS_APPEND(dir))
 		return -EPERM;
-	if (btrfs_check_sticky(dir, victim->d_inode)||
-		IS_APPEND(victim->d_inode)||
+	if (check_sticky(dir, victim->d_inode) || IS_APPEND(victim->d_inode) ||
 	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
 		return -EPERM;
 	if (isdir) {
diff --git a/fs/namei.c b/fs/namei.c
index fe615561c90e..1039eef0e22c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2366,22 +2366,17 @@ kern_path_mountpoint(int dfd, const char *name, struct path *path,
 }
 EXPORT_SYMBOL(kern_path_mountpoint);
 
-/*
- * It's inline, so penalty for filesystems that don't use sticky bit is
- * minimal.
- */
-static inline int check_sticky(struct inode *dir, struct inode *inode)
+int __check_sticky(struct inode *dir, struct inode *inode)
 {
 	kuid_t fsuid = current_fsuid();
 
-	if (!(dir->i_mode & S_ISVTX))
-		return 0;
 	if (uid_eq(inode->i_uid, fsuid))
 		return 0;
 	if (uid_eq(dir->i_uid, fsuid))
 		return 0;
 	return !inode_capable(inode, CAP_FOWNER);
 }
+EXPORT_SYMBOL(__check_sticky);
 
 /*
  *	Check whether we can remove a link victim from directory dir, check
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0ca904f5cd1c..9d821253379d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2235,6 +2235,7 @@ extern int notify_change(struct dentry *, struct iattr *, struct inode **);
 extern int inode_permission(struct inode *, int);
 extern int __inode_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int);
+extern int __check_sticky(struct inode *dir, struct inode *inode);
 
 static inline bool execute_ok(struct inode *inode)
 {
@@ -2720,6 +2721,14 @@ static inline int is_sxid(umode_t mode)
 	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
 }
 
+static inline int check_sticky(struct inode *dir, struct inode *inode)
+{
+	if (!(dir->i_mode & S_ISVTX))
+		return 0;
+
+	return __check_sticky(dir, inode);
+}
+
 static inline void inode_has_no_xattr(struct inode *inode)
 {
 	if (!is_sxid(inode->i_mode) && (inode->i_sb->s_flags & MS_NOSEC))
-- 
1.8.1.4

