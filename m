Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3KNQkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:40:52 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:40128 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab3KNQj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:57 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, James Simmons <uja.ornl@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 23/39] staging/lustre/autoconf: remove LC_FS_STRUCT_USE_PATH
Date: Fri, 15 Nov 2013 00:32:46 +0800
Message-Id: <1384446782-13741-24-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

struct fs_struct has been using struct path for working dirs
since v2.6.26.

We can remove the test and the dead code.

Lustre-change: http://review.whamcloud.com/5359
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2800
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/linux/lustre_compat25.h  |    5 -----
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |   14 +++++++-------
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |    2 +-
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index 2e1b7f1..8e1505a 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -111,11 +111,6 @@ static inline void ll_set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
 #define cfs_bio_io_error(a,b)   bio_io_error((a))
 #define cfs_bio_endio(a,b,c)    bio_endio((a),(c))
 
-#define cfs_fs_pwd(fs)       ((fs)->pwd.dentry)
-#define cfs_fs_mnt(fs)       ((fs)->pwd.mnt)
-#define cfs_path_put(nd)     path_put(&(nd)->path)
-
-
 #ifndef SLAB_DESTROY_BY_RCU
 #define SLAB_DESTROY_BY_RCU 0
 #endif
diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
index 1ef06fe..86b09a8 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
@@ -119,10 +119,10 @@ void push_ctxt(struct lvfs_run_ctxt *save, struct lvfs_run_ctxt *new_ctx,
 	OBD_SET_CTXT_MAGIC(save);
 
 	save->fs = get_fs();
-	LASSERT(d_count(cfs_fs_pwd(current->fs)));
+	LASSERT(d_count(current->fs->pwd.dentry));
 	LASSERT(d_count(new_ctx->pwd));
-	save->pwd = dget(cfs_fs_pwd(current->fs));
-	save->pwdmnt = mntget(cfs_fs_mnt(current->fs));
+	save->pwd = dget(current->fs->pwd.dentry);
+	save->pwdmnt = mntget(current->fs->pwd.mnt);
 	save->luc.luc_umask = current_umask();
 	save->ngroups = current_cred()->group_info->ngroups;
 
@@ -170,10 +170,10 @@ void pop_ctxt(struct lvfs_run_ctxt *saved, struct lvfs_run_ctxt *new_ctx,
 	ASSERT_CTXT_MAGIC(saved->magic);
 	ASSERT_KERNEL_CTXT("popping non-kernel context!\n");
 
-	LASSERTF(cfs_fs_pwd(current->fs) == new_ctx->pwd, "%p != %p\n",
-		 cfs_fs_pwd(current->fs), new_ctx->pwd);
-	LASSERTF(cfs_fs_mnt(current->fs) == new_ctx->pwdmnt, "%p != %p\n",
-		 cfs_fs_mnt(current->fs), new_ctx->pwdmnt);
+	LASSERTF(current->fs->pwd.dentry == new_ctx->pwd, "%p != %p\n",
+		 current->fs->pwd.dentry, new_ctx->pwd);
+	LASSERTF(current->fs->pwd.mnt == new_ctx->pwdmnt, "%p != %p\n",
+		 current->fs->pwd.mnt, new_ctx->pwdmnt);
 
 	set_fs(saved->fs);
 	ll_set_fs_pwd(current->fs, saved->pwdmnt, saved->pwd);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
index 6cc3f23..6b4c971 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -1015,7 +1015,7 @@ int sptlrpc_target_local_copy_conf(struct obd_device *obd,
 
 	push_ctxt(&saved, &obd->obd_lvfs_ctxt, NULL);
 
-	dentry = ll_lookup_one_len(MOUNT_CONFIGS_DIR, cfs_fs_pwd(current->fs),
+	dentry = ll_lookup_one_len(MOUNT_CONFIGS_DIR, current->fs->pwd.dentry,
 				   strlen(MOUNT_CONFIGS_DIR));
 	if (IS_ERR(dentry)) {
 		rc = PTR_ERR(dentry);
-- 
1.7.9.5

