Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbaIRFyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:54:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:43988 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbaIRFyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:54:01 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Subject: [PATCH 2/3] f2fs: change the ipu_policy option to enable combinations
Date: Wed, 17 Sep 2014 22:53:56 -0700
Message-Id: <1411019637-2381-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1411019637-2381-1-git-send-email-jaegeuk@kernel.org>
References: <1411019637-2381-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the ipu_policy setting to use any combination of orthogonal policies.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 Documentation/filesystems/f2fs.txt |  6 +++---
 fs/f2fs/segment.c                  |  2 +-
 fs/f2fs/segment.h                  | 39 ++++++++++++++++----------------------
 3 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index d010da8..2cca5a2 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -192,9 +192,9 @@ Files in /sys/fs/f2fs/<devname>
 
  ipu_policy                   This parameter controls the policy of in-place
                               updates in f2fs. There are five policies:
-                               0: F2FS_IPU_FORCE, 1: F2FS_IPU_SSR,
-                               2: F2FS_IPU_UTIL,  3: F2FS_IPU_SSR_UTIL,
-                               4: F2FS_IPU_FSYNC, 5: F2FS_IPU_DISABLE.
+                               0x01: F2FS_IPU_FORCE, 0x02: F2FS_IPU_SSR,
+                               0x04: F2FS_IPU_UTIL,  0x08: F2FS_IPU_SSR_UTIL,
+                               0x10: F2FS_IPU_FSYNC.
 
  min_ipu_util                 This parameter controls the threshold to trigger
                               in-place-updates. The number indicates percentage
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 24b768a..3125a3d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1928,7 +1928,7 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->ssa_blkaddr = le32_to_cpu(raw_super->ssa_blkaddr);
 	sm_info->rec_prefree_segments = sm_info->main_segments *
 					DEF_RECLAIM_PREFREE_SEGMENTS / 100;
-	sm_info->ipu_policy = F2FS_IPU_FSYNC;
+	sm_info->ipu_policy = 1 << F2FS_IPU_FSYNC;
 	sm_info->min_ipu_util = DEF_MIN_IPU_UTIL;
 	sm_info->min_fsync_blocks = DEF_MIN_FSYNC_BLOCKS;
 
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 032c090..d317b61 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -487,40 +487,33 @@ enum {
 	F2FS_IPU_UTIL,
 	F2FS_IPU_SSR_UTIL,
 	F2FS_IPU_FSYNC,
-	F2FS_IPU_DISABLE,
 };
 
 static inline bool need_inplace_update(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	unsigned int policy = SM_I(sbi)->ipu_policy;
 
 	/* IPU can be done only for the user data */
 	if (S_ISDIR(inode->i_mode))
 		return false;
 
-	switch (SM_I(sbi)->ipu_policy) {
-	case F2FS_IPU_FORCE:
+	if (policy & (0x1 << F2FS_IPU_FORCE))
 		return true;
-	case F2FS_IPU_SSR:
-		if (need_SSR(sbi))
-			return true;
-		break;
-	case F2FS_IPU_UTIL:
-		if (utilization(sbi) > SM_I(sbi)->min_ipu_util)
-			return true;
-		break;
-	case F2FS_IPU_SSR_UTIL:
-		if (need_SSR(sbi) && utilization(sbi) > SM_I(sbi)->min_ipu_util)
-			return true;
-		break;
-	case F2FS_IPU_FSYNC:
-		/* this is only set during fdatasync */
-		if (is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
-			return true;
-		break;
-	case F2FS_IPU_DISABLE:
-		break;
-	}
+	if (policy & (0x1 << F2FS_IPU_SSR) && need_SSR(sbi))
+		return true;
+	if (policy & (0x1 << F2FS_IPU_UTIL) &&
+			utilization(sbi) > SM_I(sbi)->min_ipu_util)
+		return true;
+	if (policy & (0x1 << F2FS_IPU_SSR_UTIL) && need_SSR(sbi) &&
+			utilization(sbi) > SM_I(sbi)->min_ipu_util)
+		return true;
+
+	/* this is only set during fdatasync */
+	if (policy & (0x1 << F2FS_IPU_FSYNC) &&
+			is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
+		return true;
+
 	return false;
 }
 
-- 
1.8.5.2 (Apple Git-48)

