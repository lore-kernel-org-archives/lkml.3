Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab3KNQ5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:57:37 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46616 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3KNQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:04 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Niu Yawei <yawei.niu@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 09/39] staging/lustre/llite: use 64bits flags in ll_lov_setea()
Date: Fri, 15 Nov 2013 00:32:32 +0800
Message-Id: <1384446782-13741-10-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niu Yawei <yawei.niu@intel.com>

In ll_lov_setea(), setting MDS_OPEN_HAS_OBJS to an int flags will
result in the flags being overflowed.

Lustre-change: http://review.whamcloud.com/7312
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3744
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-by: Emoly Liu <emoly.liu@intel.com>
Reviewed-by: Jian Yu <jian.yu@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c         |    7 ++++---
 .../staging/lustre/lustre/llite/llite_internal.h   |    2 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |    6 +++---
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 02b297b..d3f375d 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1401,7 +1401,8 @@ static int ll_lov_recreate_fid(struct inode *inode, unsigned long arg)
 }
 
 int ll_lov_setstripe_ea_info(struct inode *inode, struct file *file,
-			     int flags, struct lov_user_md *lum, int lum_size)
+			     __u64  flags, struct lov_user_md *lum,
+			     int lum_size)
 {
 	struct lov_stripe_md *lsm = NULL;
 	struct lookup_intent oit = {.it_op = IT_OPEN, .it_flags = flags};
@@ -1522,7 +1523,7 @@ out:
 static int ll_lov_setea(struct inode *inode, struct file *file,
 			    unsigned long arg)
 {
-	int			 flags = MDS_OPEN_HAS_OBJS | FMODE_WRITE;
+	__u64			 flags = MDS_OPEN_HAS_OBJS | FMODE_WRITE;
 	struct lov_user_md	*lump;
 	int			 lum_size = sizeof(struct lov_user_md) +
 					    sizeof(struct lov_user_ost_data);
@@ -1554,7 +1555,7 @@ static int ll_lov_setstripe(struct inode *inode, struct file *file,
 	struct lov_user_md_v1	*lumv1p = (struct lov_user_md_v1 *)arg;
 	struct lov_user_md_v3	*lumv3p = (struct lov_user_md_v3 *)arg;
 	int			 lum_size, rc;
-	int			 flags = FMODE_WRITE;
+	__u64			 flags = FMODE_WRITE;
 
 	/* first try with v1 which is smaller than v3 */
 	lum_size = sizeof(struct lov_user_md_v1);
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 37e33ab..69b5d91 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -790,7 +790,7 @@ struct posix_acl * ll_get_acl(struct inode *inode, int type);
 int ll_inode_permission(struct inode *inode, int mask);
 
 int ll_lov_setstripe_ea_info(struct inode *inode, struct file *file,
-			     int flags, struct lov_user_md *lum,
+			     __u64  flags, struct lov_user_md *lum,
 			     int lum_size);
 int ll_lov_getstripe_ea_info(struct inode *inode, const char *filename,
 			     struct lov_mds_md **lmm, int *lmm_size,
diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 8c96854..b6cb0db 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -236,13 +236,13 @@ int ll_setxattr(struct dentry *dentry, const char *name,
 			lump->lmm_stripe_offset = -1;
 
 		if (lump != NULL && S_ISREG(inode->i_mode)) {
-			struct file f;
-			int flags = FMODE_WRITE;
+			struct file	f;
+			__u64		it_flags = FMODE_WRITE;
 			int lum_size = (lump->lmm_magic == LOV_USER_MAGIC_V1) ?
 				sizeof(*lump) : sizeof(struct lov_user_md_v3);
 
 			f.f_dentry = dentry;
-			rc = ll_lov_setstripe_ea_info(inode, &f, flags, lump,
+			rc = ll_lov_setstripe_ea_info(inode, &f, it_flags, lump,
 						      lum_size);
 			/* b10667: rc always be 0 here for now */
 			rc = 0;
-- 
1.7.9.5

