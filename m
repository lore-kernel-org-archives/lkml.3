Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbaAHWKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:10:04 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:45911 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbaAHWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:09:52 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: [PATCH 06/11] security: add flags to rename hooks
Date: Wed,  8 Jan 2014 23:10:10 +0100
Message-Id: <1389219015-10980-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add flags to security_path_rename() and security_inode_rename() hooks.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/cachefiles/namei.c    |  2 +-
 fs/namei.c               |  5 +++--
 include/linux/security.h | 12 ++++++++----
 security/security.c      |  6 ++++--
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 31088a969351..6494d9f673aa 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -391,7 +391,7 @@ try_again:
 	path.dentry = dir;
 	path_to_graveyard.mnt = cache->mnt;
 	path_to_graveyard.dentry = cache->graveyard;
-	ret = security_path_rename(&path, rep, &path_to_graveyard, grave);
+	ret = security_path_rename(&path, rep, &path_to_graveyard, grave, 0);
 	if (ret < 0) {
 		cachefiles_io_error(cache, "Rename security error %d", ret);
 	} else {
diff --git a/fs/namei.c b/fs/namei.c
index f9cf3020394c..3fbc95c72e31 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4048,7 +4048,8 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			return error;
 	}
 
-	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry);
+	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry,
+				      flags);
 	if (error)
 		return error;
 
@@ -4198,7 +4199,7 @@ retry_deleg:
 		goto exit5;
 
 	error = security_path_rename(&oldnd.path, old_dentry,
-				     &newnd.path, new_dentry);
+				     &newnd.path, new_dentry, flags);
 	if (error)
 		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
diff --git a/include/linux/security.h b/include/linux/security.h
index 5623a7f965b7..95cfccc213fb 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1792,7 +1792,8 @@ int security_inode_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
 int security_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
-			  struct inode *new_dir, struct dentry *new_dentry);
+			  struct inode *new_dir, struct dentry *new_dentry,
+			  unsigned int flags);
 int security_inode_readlink(struct dentry *dentry);
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
 int security_inode_permission(struct inode *inode, int mask);
@@ -2160,7 +2161,8 @@ static inline int security_inode_mknod(struct inode *dir,
 static inline int security_inode_rename(struct inode *old_dir,
 					 struct dentry *old_dentry,
 					 struct inode *new_dir,
-					 struct dentry *new_dentry)
+					 struct dentry *new_dentry,
+					 unsigned int flags)
 {
 	return 0;
 }
@@ -2951,7 +2953,8 @@ int security_path_symlink(struct path *dir, struct dentry *dentry,
 int security_path_link(struct dentry *old_dentry, struct path *new_dir,
 		       struct dentry *new_dentry);
 int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
-			 struct path *new_dir, struct dentry *new_dentry);
+			 struct path *new_dir, struct dentry *new_dentry,
+			 unsigned int flags);
 int security_path_chmod(struct path *path, umode_t mode);
 int security_path_chown(struct path *path, kuid_t uid, kgid_t gid);
 int security_path_chroot(struct path *path);
@@ -2999,7 +3002,8 @@ static inline int security_path_link(struct dentry *old_dentry,
 static inline int security_path_rename(struct path *old_dir,
 				       struct dentry *old_dentry,
 				       struct path *new_dir,
-				       struct dentry *new_dentry)
+				       struct dentry *new_dentry,
+				       unsigned int flags)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 15b6928592ef..edc179f1ade0 100644
--- a/security/security.c
+++ b/security/security.c
@@ -433,7 +433,8 @@ int security_path_link(struct dentry *old_dentry, struct path *new_dir,
 }
 
 int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
-			 struct path *new_dir, struct dentry *new_dentry)
+			 struct path *new_dir, struct dentry *new_dentry,
+			 unsigned int flags)
 {
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
 		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
@@ -524,7 +525,8 @@ int security_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 }
 
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
-			   struct inode *new_dir, struct dentry *new_dentry)
+			   struct inode *new_dir, struct dentry *new_dentry,
+			   unsigned int flags)
 {
         if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
             (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
-- 
1.8.1.4

