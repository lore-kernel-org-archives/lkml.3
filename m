Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3KNQnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:43:19 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58870 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3KNQk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:56 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, James Simmons <uja.ornl@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 38/39] staging/lustre/autoconf: remove LC_SECURITY_PLUG test
Date: Fri, 15 Nov 2013 00:33:01 +0800
Message-Id: <1384446782-13741-39-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

Only the SLES 10 kernel took a vfsmount for various vfs operations
to support AppArmor before the path variants were available.
We can remove the test and the dead code.

Lustre-change: http://review.whamcloud.com/5360
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2800
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/linux/lustre_compat25.h  |    9 ---------
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    3 +--
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index 8e1505a..a8b6af1 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -99,15 +99,6 @@ static inline void ll_set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
 #define FS_HAS_FIEMAP			(0)
 #endif
 
-#define ll_vfs_rmdir(dir,entry,mnt)	     vfs_rmdir(dir,entry)
-#define ll_vfs_mkdir(inode,dir,mnt,mode)	vfs_mkdir(inode,dir,mode)
-#define ll_vfs_link(old,mnt,dir,new,mnt1)       vfs_link(old,dir,new)
-#define ll_vfs_unlink(inode,entry,mnt)	  vfs_unlink(inode,entry)
-#define ll_vfs_mknod(dir,entry,mnt,mode,dev)    vfs_mknod(dir,entry,mode,dev)
-#define ll_security_inode_unlink(dir,entry,mnt) security_inode_unlink(dir,entry)
-#define ll_vfs_rename(old,old_dir,mnt,new,new_dir,mnt1) \
-		vfs_rename(old,old_dir,new,new_dir)
-
 #define cfs_bio_io_error(a,b)   bio_io_error((a))
 #define cfs_bio_endio(a,b,c)    bio_endio((a),(c))
 
diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
index 86b09a8..2ca3fc4 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
@@ -223,8 +223,7 @@ int lustre_rename(struct dentry *dir, struct vfsmount *mnt,
 	if (IS_ERR(dchild_new))
 		GOTO(put_old, err = PTR_ERR(dchild_new));
 
-	err = ll_vfs_rename(dir->d_inode, dchild_old, mnt,
-			    dir->d_inode, dchild_new, mnt);
+	err = vfs_rename(dir->d_inode, dchild_old, dir->d_inode, dchild_new);
 
 	dput(dchild_new);
 put_old:
-- 
1.7.9.5

