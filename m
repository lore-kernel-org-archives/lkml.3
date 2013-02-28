Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab3B1Bop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:44:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:43405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab3B1Boo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:44:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,752,1355126400"; 
   d="scan'208";a="292814950"
Date: Thu, 28 Feb 2013 09:43:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] writeback fixes for v3.9-rc1
Message-ID: <20130228014316.GA15164@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are 2 writeback fixes.

Please be prepared for a merge conflict in fs/btrfs/extent-tree.c as
occured/resolved in linux-next's merge commit 6ae374247bfd8 ("Merge
remote-tracking branch 'writeback/writeback-for-next'").

Thanks,
Fengguang
---

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback-fixes

for you to fetch changes up to ed84825b785ceb932af7dd5aa08614801721320b:

  Negative (setpoint-dirty) in bdi_position_ratio() (2013-01-24 22:22:22 +0800)

----------------------------------------------------------------
2 writeback fixes
- fix negative (setpoint - dirty) in 32bit archs
- use down_read_trylock() in writeback_inodes_sb(_nr)_if_idle()

----------------------------------------------------------------
Miao Xie (1):
      vfs: re-implement writeback_inodes_sb(_nr)_if_idle() and rename them

paul.szabo@sydney.edu.au (1):
      Negative (setpoint-dirty) in bdi_position_ratio()

(Yeah I'm aware of that broken author name and tried to fix it, however just
 found that the fixing commit lies in "* (no branch)" and now it's a bit late
 to update the "writeback-for-next" branch).

 fs/btrfs/extent-tree.c    |   20 +++-----------------
 fs/ext4/inode.c           |    8 ++------
 fs/fs-writeback.c         |   44 ++++++++++++++++++++------------------------
 include/linux/writeback.h |    6 +++---
 mm/page-writeback.c       |    2 +-
 5 files changed, 29 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 521e9d4..f31abb1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3689,20 +3689,6 @@ static int can_overcommit(struct btrfs_root *root,
 	return 0;
 }
 
-static int writeback_inodes_sb_nr_if_idle_safe(struct super_block *sb,
-					       unsigned long nr_pages,
-					       enum wb_reason reason)
-{
-	if (!writeback_in_progress(sb->s_bdi) &&
-	    down_read_trylock(&sb->s_umount)) {
-		writeback_inodes_sb_nr(sb, nr_pages, reason);
-		up_read(&sb->s_umount);
-		return 1;
-	}
-
-	return 0;
-}
-
 /*
  * shrink metadata reservation for delalloc
  */
@@ -3735,9 +3721,9 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	while (delalloc_bytes && loops < 3) {
 		max_reclaim = min(delalloc_bytes, to_reclaim);
 		nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
-		writeback_inodes_sb_nr_if_idle_safe(root->fs_info->sb,
-						    nr_pages,
-						    WB_REASON_FS_FREE_SPACE);
+		try_to_writeback_inodes_sb_nr(root->fs_info->sb,
+					      nr_pages,
+					      WB_REASON_FS_FREE_SPACE);
 
 		/*
 		 * We need to wait for the async pages to actually start before
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cbfe13b..5f6eef7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2512,12 +2512,8 @@ static int ext4_nonda_switch(struct super_block *sb)
 	/*
 	 * Start pushing delalloc when 1/2 of free blocks are dirty.
 	 */
-	if (dirty_blocks && (free_blocks < 2 * dirty_blocks) &&
-	    !writeback_in_progress(sb->s_bdi) &&
-	    down_read_trylock(&sb->s_umount)) {
-		writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
-		up_read(&sb->s_umount);
-	}
+	if (dirty_blocks && (free_blocks < 2 * dirty_blocks))
+		try_to_writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
 
 	if (2 * free_blocks < 3 * dirty_blocks ||
 		free_blocks < (dirty_blocks + EXT4_FREECLUSTERS_WATERMARK)) {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 310972b..ad3cc46 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1332,47 +1332,43 @@ void writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
 EXPORT_SYMBOL(writeback_inodes_sb);
 
 /**
- * writeback_inodes_sb_if_idle	-	start writeback if none underway
+ * try_to_writeback_inodes_sb_nr - try to start writeback if none underway
  * @sb: the superblock
- * @reason: reason why some writeback work was initiated
+ * @nr: the number of pages to write
+ * @reason: the reason of writeback
  *
- * Invoke writeback_inodes_sb if no writeback is currently underway.
+ * Invoke writeback_inodes_sb_nr if no writeback is currently underway.
  * Returns 1 if writeback was started, 0 if not.
  */
-int writeback_inodes_sb_if_idle(struct super_block *sb, enum wb_reason reason)
+int try_to_writeback_inodes_sb_nr(struct super_block *sb,
+				  unsigned long nr,
+				  enum wb_reason reason)
 {
-	if (!writeback_in_progress(sb->s_bdi)) {
-		down_read(&sb->s_umount);
-		writeback_inodes_sb(sb, reason);
-		up_read(&sb->s_umount);
+	if (writeback_in_progress(sb->s_bdi))
 		return 1;
-	} else
+
+	if (!down_read_trylock(&sb->s_umount))
 		return 0;
+
+	writeback_inodes_sb_nr(sb, nr, reason);
+	up_read(&sb->s_umount);
+	return 1;
 }
-EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
+EXPORT_SYMBOL(try_to_writeback_inodes_sb_nr);
 
 /**
- * writeback_inodes_sb_nr_if_idle	-	start writeback if none underway
+ * try_to_writeback_inodes_sb - try to start writeback if none underway
  * @sb: the superblock
- * @nr: the number of pages to write
  * @reason: reason why some writeback work was initiated
  *
- * Invoke writeback_inodes_sb if no writeback is currently underway.
+ * Implement by try_to_writeback_inodes_sb_nr()
  * Returns 1 if writeback was started, 0 if not.
  */
-int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
-				   unsigned long nr,
-				   enum wb_reason reason)
+int try_to_writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
 {
-	if (!writeback_in_progress(sb->s_bdi)) {
-		down_read(&sb->s_umount);
-		writeback_inodes_sb_nr(sb, nr, reason);
-		up_read(&sb->s_umount);
-		return 1;
-	} else
-		return 0;
+	return try_to_writeback_inodes_sb_nr(sb, get_nr_dirty_pages(), reason);
 }
-EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
+EXPORT_SYMBOL(try_to_writeback_inodes_sb);
 
 /**
  * sync_inodes_sb	-	sync sb inode pages
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b82a83a..9a9367c 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -87,9 +87,9 @@ int inode_wait(void *);
 void writeback_inodes_sb(struct super_block *, enum wb_reason reason);
 void writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
 							enum wb_reason reason);
-int writeback_inodes_sb_if_idle(struct super_block *, enum wb_reason reason);
-int writeback_inodes_sb_nr_if_idle(struct super_block *, unsigned long nr,
-							enum wb_reason reason);
+int try_to_writeback_inodes_sb(struct super_block *, enum wb_reason reason);
+int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
+				  enum wb_reason reason);
 void sync_inodes_sb(struct super_block *);
 long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0713bfb..1534ebd 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -692,7 +692,7 @@ static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
 	 *     => fast response on large errors; small oscillation near setpoint
 	 */
 	setpoint = (freerun + limit) / 2;
-	x = div_s64((setpoint - dirty) << RATELIMIT_CALC_SHIFT,
+	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
 		    limit - setpoint + 1);
 	pos_ratio = x;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
