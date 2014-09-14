Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaINWQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:16:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:32841 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbaINWO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:14:29 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 04/10] f2fs: give an option to enable in-place-updates during fsync to users
Date: Sun, 14 Sep 2014 15:14:18 -0700
Message-Id: <1410732864-53069-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user wrote F2FS_IPU_FSYNC:4 in /sys/fs/f2fs/ipu_policy, f2fs_sync_file
only starts to try in-place-updates.
And, if the number of dirty pages is over /sys/fs/f2fs/min_fsync_blocks, it
keeps out-of-order manner. Otherwise, it triggers in-place-updates.

This may be used by storage showing very high random write performance.

For example, it can be used when,

Seq. writes (Data) + wait + Seq. writes (Node)

is pretty much slower than,

Rand. writes (Data)

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs |  7 +++++++
 Documentation/filesystems/f2fs.txt      |  9 ++++++++-
 fs/f2fs/f2fs.h                          |  1 +
 fs/f2fs/file.c                          |  7 +++----
 fs/f2fs/segment.c                       |  3 ++-
 fs/f2fs/segment.h                       | 14 ++++++++++----
 fs/f2fs/super.c                         |  2 ++
 7 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 62dd725..6f9157f 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -44,6 +44,13 @@ Description:
 		 Controls the FS utilization condition for the in-place-update
 		 policies.
 
+What:		/sys/fs/f2fs/<disk>/min_fsync_blocks
+Date:		September 2014
+Contact:	"Jaegeuk Kim" <jaegeuk@kernel.org>
+Description:
+		 Controls the dirty page count condition for the in-place-update
+		 policies.
+
 What:		/sys/fs/f2fs/<disk>/max_small_discards
 Date:		November 2013
 Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index a2046a7..d010da8 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -194,13 +194,20 @@ Files in /sys/fs/f2fs/<devname>
                               updates in f2fs. There are five policies:
                                0: F2FS_IPU_FORCE, 1: F2FS_IPU_SSR,
                                2: F2FS_IPU_UTIL,  3: F2FS_IPU_SSR_UTIL,
-                               4: F2FS_IPU_DISABLE.
+                               4: F2FS_IPU_FSYNC, 5: F2FS_IPU_DISABLE.
 
  min_ipu_util                 This parameter controls the threshold to trigger
                               in-place-updates. The number indicates percentage
                               of the filesystem utilization, and used by
                               F2FS_IPU_UTIL and F2FS_IPU_SSR_UTIL policies.
 
+ min_fsync_blocks             This parameter controls the threshold to trigger
+                              in-place-updates when F2FS_IPU_FSYNC mode is set.
+			      The number indicates the number of dirty pages
+			      when fsync needs to flush on its call path. If
+			      the number is less than this value, it triggers
+			      in-place-updates.
+
  max_victim_search	      This parameter controls the number of trials to
 			      find a victim segment when conducting SSR and
 			      cleaning operations. The default value is 4096
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2756c16..4f84d2a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -386,6 +386,7 @@ struct f2fs_sm_info {
 
 	unsigned int ipu_policy;	/* in-place-update policy */
 	unsigned int min_ipu_util;	/* in-place-update threshold */
+	unsigned int min_fsync_blocks;	/* threshold for fsync */
 
 	/* for flush command control */
 	struct flush_cmd_control *cmd_control_info;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 77426c7..af06e22 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -154,12 +154,11 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	trace_f2fs_sync_file_enter(inode);
 
 	/* if fdatasync is triggered, let's do in-place-update */
-	if (datasync)
+	if (get_dirty_pages(inode) <= SM_I(sbi)->min_fsync_blocks)
 		set_inode_flag(fi, FI_NEED_IPU);
-
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (datasync)
-		clear_inode_flag(fi, FI_NEED_IPU);
+	clear_inode_flag(fi, FI_NEED_IPU);
+
 	if (ret) {
 		trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
 		return ret;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index e158d63..c6f627b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1928,8 +1928,9 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->ssa_blkaddr = le32_to_cpu(raw_super->ssa_blkaddr);
 	sm_info->rec_prefree_segments = sm_info->main_segments *
 					DEF_RECLAIM_PREFREE_SEGMENTS / 100;
-	sm_info->ipu_policy = F2FS_IPU_DISABLE;
+	sm_info->ipu_policy = F2FS_IPU_FSYNC;
 	sm_info->min_ipu_util = DEF_MIN_IPU_UTIL;
+	sm_info->min_fsync_blocks = DEF_MIN_FSYNC_BLOCKS;
 
 	INIT_LIST_HEAD(&sm_info->discard_list);
 	sm_info->nr_discards = 0;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index bed0dc9..013aed2 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -472,15 +472,20 @@ static inline int utilization(struct f2fs_sb_info *sbi)
  * F2FS_IPU_UTIL - if FS utilization is over threashold,
  * F2FS_IPU_SSR_UTIL - if SSR mode is activated and FS utilization is over
  *                     threashold,
+ * F2FS_IPU_FSYNC - activated in fsync path only for high performance flash
+ *                     storages. IPU will be triggered only if the # of dirty
+ *                     pages over min_fsync_blocks.
  * F2FS_IPUT_DISABLE - disable IPU. (=default option)
  */
 #define DEF_MIN_IPU_UTIL	70
+#define DEF_MIN_FSYNC_BLOCKS	8
 
 enum {
 	F2FS_IPU_FORCE,
 	F2FS_IPU_SSR,
 	F2FS_IPU_UTIL,
 	F2FS_IPU_SSR_UTIL,
+	F2FS_IPU_FSYNC,
 	F2FS_IPU_DISABLE,
 };
 
@@ -492,10 +497,6 @@ static inline bool need_inplace_update(struct inode *inode)
 	if (S_ISDIR(inode->i_mode))
 		return false;
 
-	/* this is only set during fdatasync */
-	if (is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
-		return true;
-
 	switch (SM_I(sbi)->ipu_policy) {
 	case F2FS_IPU_FORCE:
 		return true;
@@ -511,6 +512,11 @@ static inline bool need_inplace_update(struct inode *inode)
 		if (need_SSR(sbi) && utilization(sbi) > SM_I(sbi)->min_ipu_util)
 			return true;
 		break;
+	case F2FS_IPU_FSYNC:
+		/* this is only set during fdatasync */
+		if (is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
+			return true;
+		break;
 	case F2FS_IPU_DISABLE:
 		break;
 	}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b5af9be..ed4095e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -190,6 +190,7 @@ F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, reclaim_segments, rec_prefree_segments);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, max_small_discards, max_discards);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, ipu_policy, ipu_policy);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, min_ipu_util, min_ipu_util);
+F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, min_fsync_blocks, min_fsync_blocks);
 F2FS_RW_ATTR(NM_INFO, f2fs_nm_info, ram_thresh, ram_thresh);
 F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, max_victim_search, max_victim_search);
 F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, dir_level, dir_level);
@@ -204,6 +205,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(max_small_discards),
 	ATTR_LIST(ipu_policy),
 	ATTR_LIST(min_ipu_util),
+	ATTR_LIST(min_fsync_blocks),
 	ATTR_LIST(max_victim_search),
 	ATTR_LIST(dir_level),
 	ATTR_LIST(ram_thresh),
-- 
1.8.5.2 (Apple Git-48)

