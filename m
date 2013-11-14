Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab3KNQp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:45:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53177 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323Ab3KNQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:45:04 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, James Simmons <uja.ornl@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 25/26] staging/lustre/autoconf: remove quota_on/quota_off checks
Date: Fri, 15 Nov 2013 00:43:12 +0800
Message-Id: <1384447393-13838-26-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

With the rewrite of the Lustre quota code we no longer
need ll_quota_[on/off]. Those obsolete methods touched
linux kernel internals that have changed over time.
With ll_quota_[on/off[ gone we can remove all the
quota autoconf that was required.

Lustre-change: http://review.whamcloud.com/5367
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2800
Signed-off-by: James Simmons  <uja.ornl@gmail.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
[also remove ll_vfs_dq_xxx wrappers that are not in use -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/linux/lustre_compat25.h  |   43 --------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index a8b6af1..fbe1d69 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -106,49 +106,6 @@ static inline void ll_set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
 #define SLAB_DESTROY_BY_RCU 0
 #endif
 
-
-
-static inline int
-ll_quota_on(struct super_block *sb, int off, int ver, char *name, int remount)
-{
-	int rc;
-
-	if (sb->s_qcop->quota_on) {
-		struct path path;
-
-		rc = kern_path(name, LOOKUP_FOLLOW, &path);
-		if (!rc)
-			return rc;
-		rc = sb->s_qcop->quota_on(sb, off, ver
-					    , &path
-					   );
-		path_put(&path);
-		return rc;
-	}
-	else
-		return -ENOSYS;
-}
-
-static inline int ll_quota_off(struct super_block *sb, int off, int remount)
-{
-	if (sb->s_qcop->quota_off) {
-		return sb->s_qcop->quota_off(sb, off
-					    );
-	}
-	else
-		return -ENOSYS;
-}
-
-
-# define ll_vfs_dq_init	     dquot_initialize
-# define ll_vfs_dq_drop	     dquot_drop
-# define ll_vfs_dq_transfer	 dquot_transfer
-# define ll_vfs_dq_off(sb, remount) dquot_suspend(sb, -1)
-
-
-
-
-
 #define queue_max_phys_segments(rq)       queue_max_segments(rq)
 #define queue_max_hw_segments(rq)	 queue_max_segments(rq)
 
-- 
1.7.9.5

