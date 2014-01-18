Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaARKlD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 05:41:03 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57964 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaARKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 05:40:59 -0500
X-Nat-Received: from [202.181.97.72]:60949 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1390041610.6910
To: miklos@szeredi.hu, linux-security-module@vger.kernel.org
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 04/11] vfs: add renameat2 syscall
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<1389219015-10980-5-git-send-email-miklos@szeredi.hu>
	<201401150711.AHB52169.VMSFFLtHQFOOOJ@I-love.SAKURA.ne.jp>
	<20140115103032.GD24171@tucsk.piliscsaba.szeredi.hu>
	<20140115135058.GE24171@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <20140115135058.GE24171@tucsk.piliscsaba.szeredi.hu>
Message-Id: <201401181940.CDF09817.tHOSFFJOVLFQMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 18 Jan 2014 19:40:09 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 18012014 #7352336, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Since there were a few changes to the series since posting, I pushed the updated
> patchset to
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename
> 
> Thanks for the reviews.
> 
> Thanks,
> Miklos
> ----
> 
> Miklos Szeredi (11):
>       vfs: add d_is_dir()
>       vfs: rename: move d_move() up
>       vfs: rename: use common code for dir and non-dir
>       vfs: add renameat2 syscall
>       vfs: add RENAME_NOREPLACE flag
>       security: add flags to rename hooks
>       vfs: add cross-rename
>       ext4: rename: create ext4_renament structure for local vars
>       ext4: rename: move EMLINK check up
>       ext4: rename: split out helper functions
>       ext4: add cross rename support

Here is a patchset refreshed using the abovementioned tree
for handling the rename flags in each LSM module.

  SELinux:  Added a few lines.
  SMACK:    No changes needed.
  TOMOYO:   Added some lines in order to check swapname permission once
            rather than checking rename permission twice.
  AppArmor: Using a temporary solution. John Johansen will overwrite this
            change in order to avoid re-calculation of pathnames.

LSM users, please review your relevant part in the following changes.
----------------------------------------
>From 15850773c7b6336f1d884c2daa314f4c408d355e Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 18 Jan 2014 14:01:12 +0900
Subject: [PATCH 1/5] LSM: Pass the rename flags to each LSM module.

For now, security_inode_rename() and security_path_rename() are calling each
LSM module with reversed arguments if the rename flags contain RENAME_EXCHANGE
in order to avoid bypassing LSM module's permission checks. But since LSM
modules can avoid re-calculation if the arguments are known to be reversed,
it is better to pass the rename flags anyway.

security_inode_rename() and security_path_rename() will stop calling each LSM
module with reversed arguments after all LSM modules became ready to handle
the rename flags.

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
index 95cfccc..dbd05ca 100644
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
@@ -1491,7 +1493,8 @@ struct security_operations {
 	int (*path_link) (struct dentry *old_dentry, struct path *new_dir,
 			  struct dentry *new_dentry);
 	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
-			    struct path *new_dir, struct dentry *new_dentry);
+			    struct path *new_dir, struct dentry *new_dentry,
+			    unsigned int flags);
 	int (*path_chmod) (struct path *path, umode_t mode);
 	int (*path_chown) (struct path *path, kuid_t uid, kgid_t gid);
 	int (*path_chroot) (struct path *path);
@@ -1514,7 +1517,8 @@ struct security_operations {
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
index 4257b7e..2afa7c5 100644
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
index 8b4f24a..ab2f231 100644
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
index 3dd2258..d720afc 100644
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
index 57b0b49..c139369 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2731,7 +2731,8 @@ static int selinux_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t
 }
 
 static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
-				struct inode *new_inode, struct dentry *new_dentry)
+				struct inode *new_inode, struct dentry *new_dentry,
+				unsigned int flags)
 {
 	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
 }
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b0be893..1cbb73b 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -722,6 +722,7 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
  * @old_dentry: unused
  * @new_inode: the new directory
  * @new_dentry: unused
+ * @flags: unused
  *
  * Read and write access is required on both the old and
  * new directories.
@@ -731,7 +732,8 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
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
1.7.1
----------------------------------------
>From 3b109949884ef534cbe0f8ddb9115422fd75b67d Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 18 Jan 2014 14:25:39 +0900
Subject: [PATCH 2/5] SELinux: Handle the rename flags.

For SELinux, the RENAME_EXCHANGE flag means "check permissions with reversed
arguments".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/selinux/hooks.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index c139369..a6ef610 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2734,7 +2734,10 @@ static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dent
 				struct inode *new_inode, struct dentry *new_dentry,
 				unsigned int flags)
 {
-	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
+	int err = may_rename(old_inode, old_dentry, new_inode, new_dentry);
+	if (!err && (flags & RENAME_EXCHANGE))
+		err = may_rename(new_inode, new_dentry, old_inode, old_dentry);
+	return err;
 }
 
 static int selinux_inode_readlink(struct dentry *dentry)
-- 
1.7.1
----------------------------------------
>From d0e400cf5e134cf8b6d06dc6b9c15fa6e6ca007e Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 18 Jan 2014 14:30:51 +0900
Subject: [PATCH 3/5] AppArmor: Handle the rename flags.

For AppArmor, the RENAME_EXCHANGE flag means "check permissions with reversed
arguments". Future patches will stop re-calculating pathnames.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/apparmor/lsm.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 2afa7c5..8b04056 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -332,6 +332,7 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
 					  old_dentry->d_inode->i_mode
 		};
 
+retry:
 		error = aa_path_perm(OP_RENAME_SRC, profile, &old_path, 0,
 				     MAY_READ | AA_MAY_META_READ | MAY_WRITE |
 				     AA_MAY_META_WRITE | AA_MAY_DELETE,
@@ -340,6 +341,17 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
 			error = aa_path_perm(OP_RENAME_DEST, profile, &new_path,
 					     0, MAY_WRITE | AA_MAY_META_WRITE |
 					     AA_MAY_CREATE, &cond);
+		if (!error && (flags & RENAME_EXCHANGE)) {
+			/* Cross rename requires both inodes to exist. */
+			old_path.mnt = new_dir->mnt;
+			old_path.dentry = new_dentry;
+			new_path.mnt = old_dir->mnt;
+			new_path.dentry = old_dentry;
+			cond.uid = new_dentry->d_inode->i_uid;
+			cond.mode = new_dentry->d_inode->i_mode;
+			flags = 0;
+			goto retry;
+		}
 
 	}
 	return error;
-- 
1.7.1
----------------------------------------
>From 76fbf677b730070ee7eb2296ef4c38fa288b1bbd Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 18 Jan 2014 16:45:53 +0900
Subject: [PATCH 4/5] TOMOYO: Handle the rename flags.

For TOMOYO, the RENAME_EXCHANGE flag means "check swapname permission once
rather than checking rename permission twice". This patch adds swapname
permission to TOMOYO.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/common.c |    1 +
 security/tomoyo/common.h |    5 ++++-
 security/tomoyo/file.c   |   10 +++++++++-
 security/tomoyo/tomoyo.c |    4 +++-
 security/tomoyo/util.c   |    1 +
 5 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 283862a..86747a7 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -36,6 +36,7 @@ const char * const tomoyo_mac_keywords[TOMOYO_MAX_MAC_INDEX
 	[TOMOYO_MAC_FILE_MKCHAR]     = "mkchar",
 	[TOMOYO_MAC_FILE_LINK]       = "link",
 	[TOMOYO_MAC_FILE_RENAME]     = "rename",
+	[TOMOYO_MAC_FILE_SWAPNAME]   = "swapname",
 	[TOMOYO_MAC_FILE_CHMOD]      = "chmod",
 	[TOMOYO_MAC_FILE_CHOWN]      = "chown",
 	[TOMOYO_MAC_FILE_CHGRP]      = "chgrp",
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index b897d48..0349ae9 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -276,6 +276,7 @@ enum tomoyo_network_acl_index {
 enum tomoyo_path2_acl_index {
 	TOMOYO_TYPE_LINK,
 	TOMOYO_TYPE_RENAME,
+	TOMOYO_TYPE_SWAPNAME,
 	TOMOYO_TYPE_PIVOT_ROOT,
 	TOMOYO_MAX_PATH2_OPERATION
 };
@@ -335,6 +336,7 @@ enum tomoyo_mac_index {
 	TOMOYO_MAC_FILE_MKCHAR,
 	TOMOYO_MAC_FILE_LINK,
 	TOMOYO_MAC_FILE_RENAME,
+	TOMOYO_MAC_FILE_SWAPNAME,
 	TOMOYO_MAC_FILE_CHMOD,
 	TOMOYO_MAC_FILE_CHOWN,
 	TOMOYO_MAC_FILE_CHGRP,
@@ -730,7 +732,8 @@ struct tomoyo_mkdev_acl {
 };
 
 /*
- * Structure for "file rename", "file link" and "file pivot_root" directive.
+ * Structure for "file rename", "file swapname", "file link" and
+ * "file pivot_root" directive.
  */
 struct tomoyo_path2_acl {
 	struct tomoyo_acl_info head; /* type = TOMOYO_TYPE_PATH2_ACL */
diff --git a/security/tomoyo/file.c b/security/tomoyo/file.c
index 4003907..c7d9546 100644
--- a/security/tomoyo/file.c
+++ b/security/tomoyo/file.c
@@ -38,6 +38,7 @@ const u8 tomoyo_pnnn2mac[TOMOYO_MAX_MKDEV_OPERATION] = {
 const u8 tomoyo_pp2mac[TOMOYO_MAX_PATH2_OPERATION] = {
 	[TOMOYO_TYPE_LINK]       = TOMOYO_MAC_FILE_LINK,
 	[TOMOYO_TYPE_RENAME]     = TOMOYO_MAC_FILE_RENAME,
+	[TOMOYO_TYPE_SWAPNAME]   = TOMOYO_MAC_FILE_SWAPNAME,
 	[TOMOYO_TYPE_PIVOT_ROOT] = TOMOYO_MAC_FILE_PIVOT_ROOT,
 };
 
@@ -874,7 +875,7 @@ int tomoyo_mkdev_perm(const u8 operation, struct path *path,
 }
 
 /**
- * tomoyo_path2_perm - Check permission for "rename", "link" and "pivot_root".
+ * tomoyo_path2_perm - Check permission for "rename", "swapname", "link" and "pivot_root".
  *
  * @operation: Type of operation.
  * @path1:      Pointer to "struct path".
@@ -916,6 +917,13 @@ int tomoyo_path2_perm(const u8 operation, struct path *path1,
 		tomoyo_add_slash(&buf1);
 		tomoyo_add_slash(&buf2);
 		break;
+	case TOMOYO_TYPE_SWAPNAME:
+		/* Cross rename requires both inodes to exist. */
+		if (S_ISDIR(path1->dentry->d_inode->i_mode))
+			tomoyo_add_slash(&buf1);
+		if (S_ISDIR(path2->dentry->d_inode->i_mode))
+			tomoyo_add_slash(&buf2);
+		break;
 	}
 	r.obj = &obj;
 	r.param_type = TOMOYO_TYPE_PATH2_ACL;
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index ac7dd97..8e9fb4a 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -299,7 +299,9 @@ static int tomoyo_path_rename(struct path *old_parent,
 {
 	struct path path1 = { old_parent->mnt, old_dentry };
 	struct path path2 = { new_parent->mnt, new_dentry };
-	return tomoyo_path2_perm(TOMOYO_TYPE_RENAME, &path1, &path2);
+	return tomoyo_path2_perm((flags & RENAME_EXCHANGE) ?
+				 TOMOYO_TYPE_SWAPNAME : TOMOYO_TYPE_RENAME,
+				 &path1, &path2);
 }
 
 /**
diff --git a/security/tomoyo/util.c b/security/tomoyo/util.c
index 2952ba5..f0ac0be 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -34,6 +34,7 @@ const u8 tomoyo_index2category[TOMOYO_MAX_MAC_INDEX] = {
 	[TOMOYO_MAC_FILE_MKCHAR]     = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_LINK]       = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_RENAME]     = TOMOYO_MAC_CATEGORY_FILE,
+	[TOMOYO_MAC_FILE_SWAPNAME]   = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_CHMOD]      = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_CHOWN]      = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_CHGRP]      = TOMOYO_MAC_CATEGORY_FILE,
-- 
1.7.1
----------------------------------------
>From 9b135d4223002f9d193066b1908a6de976238e6d Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 18 Jan 2014 16:52:06 +0900
Subject: [PATCH 5/5] LSM: Remove duplicated rename handling.

Since all LSM modules are now ready to handle the rename flags,
security_inode_rename() and security_path_rename() no longer need to call
each LSM module with reversed arguments.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/security.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/security/security.c b/security/security.c
index d720afc..9258353 100644
--- a/security/security.c
+++ b/security/security.c
@@ -439,15 +439,6 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
 		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-
-	if (flags & RENAME_EXCHANGE) {
-		int err = security_ops->path_rename(new_dir, new_dentry,
-						    old_dir, old_dentry,
-						    flags);
-		if (err)
-			return err;
-	}
-
 	return security_ops->path_rename(old_dir, old_dentry, new_dir,
 					 new_dentry, flags);
 }
@@ -540,15 +531,6 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
         if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
             (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-
-	if (flags & RENAME_EXCHANGE) {
-		int err = security_ops->inode_rename(new_dir, new_dentry,
-						     old_dir, old_dentry,
-						     flags);
-		if (err)
-			return err;
-	}
-
 	return security_ops->inode_rename(old_dir, old_dentry,
 					  new_dir, new_dentry, flags);
 }
-- 
1.7.1
----------------------------------------
