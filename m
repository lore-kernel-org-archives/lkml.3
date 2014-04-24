Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbaDXLWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:22:25 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:16828 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaDXLWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:22:15 -0400
X-Nat-Received: from [202.181.97.72]:21743 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1398338532.17346
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        miklos@szeredi.hu
Subject: [PATCH (for 3.15) 1/5] LSM: Pass the rename flags to each LSM module.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
	<53523D16.9020101@gmail.com>
	<201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
	<CAJfpeguus=9GuvEKua4U-VF=nonzLgU5VFHqt8xRTTYU7RL-zQ@mail.gmail.com>
	<201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
In-Reply-To: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
Message-Id: <201404242022.DDG90163.VFSFLOJOOMFQHt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 24 Apr 2014 20:22:05 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24042014 #7805673, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 207346b4153e2b441e0c45d933043e6ba7abb419 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 24 Apr 2014 20:04:57 +0900
Subject: [PATCH (for 3.15) 1/5] LSM: Pass the rename flags to each LSM module.

Commit da1ce067 "vfs: add cross-rename" changed security_inode_rename() and
security_path_rename() to call LSM module with reversed arguments if the rename
flags contain RENAME_EXCHANGE. But that commit introduced a race window for
TOMOYO and AppArmor (users of security_path_rename) because the pathnames may
have been changed between the first call and the second call.

To fix this race condition, the rename flags should be passed to LSM module
in order to allow LSM module to avoid re-calculation of pathnames.
Passing the rename flags allows SMACK (one of users of security_inode_rename)
to avoid needlessly checking the same permission twice.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/security.h   |    8 ++++++--
 security/apparmor/lsm.c    |    3 ++-
 security/capability.c      |    6 ++++--
 security/security.c        |   10 ++++++----
 security/selinux/hooks.c   |    3 ++-
 security/smack/smack_lsm.c |    4 +++-
 security/tomoyo/tomoyo.c   |    4 +++-
 7 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 9c6b972..12770bb 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -446,6 +446,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@old_dentry contains the dentry structure of the old link.
  *	@new_dir contains the inode structure for parent of the new link.
  *	@new_dentry contains the dentry structure of the new link.
+ *	@flags contains rename flags.
  *	Return 0 if permission is granted.
  * @path_rename:
  *	Check for permission to rename a file or directory.
@@ -453,6 +454,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@old_dentry contains the dentry structure of the old link.
  *	@new_dir contains the path structure for parent of the new link.
  *	@new_dentry contains the dentry structure of the new link.
+ *	@flags contains rename flags.
  *	Return 0 if permission is granted.
  * @path_chmod:
  *	Check for permission to change DAC's permission of a file or directory.
@@ -1492,7 +1494,8 @@ struct security_operations {
 	int (*path_link) (struct dentry *old_dentry, struct path *new_dir,
 			  struct dentry *new_dentry);
 	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
-			    struct path *new_dir, struct dentry *new_dentry);
+			    struct path *new_dir, struct dentry *new_dentry,
+			    unsigned int flags);
 	int (*path_chmod) (struct path *path, umode_t mode);
 	int (*path_chown) (struct path *path, kuid_t uid, kgid_t gid);
 	int (*path_chroot) (struct path *path);
@@ -1515,7 +1518,8 @@ struct security_operations {
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 			    umode_t mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
-			     struct inode *new_dir, struct dentry *new_dentry);
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     unsigned int flags);
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask);
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 9981000..c0b4366 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -315,7 +315,8 @@ static int apparmor_path_link(struct dentry *old_dentry, struct path *new_dir,
 }
 
 static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
-				struct path *new_dir, struct dentry *new_dentry)
+				struct path *new_dir, struct dentry *new_dentry,
+				unsigned int flags)
 {
 	struct aa_profile *profile;
 	int error = 0;
diff --git a/security/capability.c b/security/capability.c
index e76373d..b3690cc 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -176,7 +176,8 @@ static int cap_inode_mknod(struct inode *inode, struct dentry *dentry,
 }
 
 static int cap_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
-			    struct inode *new_inode, struct dentry *new_dentry)
+			    struct inode *new_inode, struct dentry *new_dentry,
+			    unsigned int flags)
 {
 	return 0;
 }
@@ -280,7 +281,8 @@ static int cap_path_link(struct dentry *old_dentry, struct path *new_dir,
 }
 
 static int cap_path_rename(struct path *old_path, struct dentry *old_dentry,
-			   struct path *new_path, struct dentry *new_dentry)
+			   struct path *new_path, struct dentry *new_dentry,
+			   unsigned int flags)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 31614e9..65ceef3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -442,13 +442,14 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 
 	if (flags & RENAME_EXCHANGE) {
 		int err = security_ops->path_rename(new_dir, new_dentry,
-						    old_dir, old_dentry);
+						    old_dir, old_dentry,
+						    flags);
 		if (err)
 			return err;
 	}
 
 	return security_ops->path_rename(old_dir, old_dentry, new_dir,
-					 new_dentry);
+					 new_dentry, flags);
 }
 EXPORT_SYMBOL(security_path_rename);
 
@@ -542,13 +543,14 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if (flags & RENAME_EXCHANGE) {
 		int err = security_ops->inode_rename(new_dir, new_dentry,
-						     old_dir, old_dentry);
+						     old_dir, old_dentry,
+						     flags);
 		if (err)
 			return err;
 	}
 
 	return security_ops->inode_rename(old_dir, old_dentry,
-					   new_dir, new_dentry);
+					  new_dir, new_dentry, flags);
 }
 
 int security_inode_readlink(struct dentry *dentry)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6befc92..d4913d1 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2749,7 +2749,8 @@ static int selinux_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t
 }
 
 static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
-				struct inode *new_inode, struct dentry *new_dentry)
+				struct inode *new_inode, struct dentry *new_dentry,
+				unsigned int flags)
 {
 	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
 }
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 8177e7d..41bd059 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -697,6 +697,7 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
  * @old_dentry: unused
  * @new_inode: the new directory
  * @new_dentry: unused
+ * @flags: unused
  *
  * Read and write access is required on both the old and
  * new directories.
@@ -706,7 +707,8 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
 static int smack_inode_rename(struct inode *old_inode,
 			      struct dentry *old_dentry,
 			      struct inode *new_inode,
-			      struct dentry *new_dentry)
+			      struct dentry *new_dentry,
+			      unsigned int flags)
 {
 	int rc;
 	char *isp;
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index f0b756e..ac7dd97 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -287,13 +287,15 @@ static int tomoyo_path_link(struct dentry *old_dentry, struct path *new_dir,
  * @old_dentry: Pointer to "struct dentry".
  * @new_parent: Pointer to "struct path".
  * @new_dentry: Pointer to "struct dentry".
+ * @flags:      Rename flags.
  *
  * Returns 0 on success, negative value otherwise.
  */
 static int tomoyo_path_rename(struct path *old_parent,
 			      struct dentry *old_dentry,
 			      struct path *new_parent,
-			      struct dentry *new_dentry)
+			      struct dentry *new_dentry,
+			      unsigned int flags)
 {
 	struct path path1 = { old_parent->mnt, old_dentry };
 	struct path path2 = { new_parent->mnt, new_dentry };
-- 
1.7.9.5
