Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab3JWEmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 00:42:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:18507 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3JWEmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 00:42:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,553,1378882800"; 
   d="scan'208";a="421168404"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH] f2fs: use bool for booleans
Date: Wed, 23 Oct 2013 12:39:32 +0800
Message-Id: <1382503172-28030-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/checkpoint.c |    4 ++--
 fs/f2fs/f2fs.h       |    4 ++--
 fs/f2fs/node.c       |    4 ++--
 fs/f2fs/recovery.c   |    8 ++++----
 fs/f2fs/super.c      |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 8d16071..bd0aa9c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -279,7 +279,7 @@ int recover_orphan_inodes(struct f2fs_sb_info *sbi)
 	if (!is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ORPHAN_PRESENT_FLAG))
 		return 0;
 
-	sbi->por_doing = 1;
+	sbi->por_doing = true;
 	start_blk = __start_cp_addr(sbi) + 1;
 	orphan_blkaddr = __start_sum_addr(sbi) - 1;
 
@@ -296,7 +296,7 @@ int recover_orphan_inodes(struct f2fs_sb_info *sbi)
 	}
 	/* clear Orphan Flag */
 	clear_ckpt_flags(F2FS_CKPT(sbi), CP_ORPHAN_PRESENT_FLAG);
-	sbi->por_doing = 0;
+	sbi->por_doing = false;
 	return 0;
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 171c52f..2b163f8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -360,8 +360,8 @@ struct f2fs_sb_info {
 	struct rw_semaphore cp_rwsem;		/* blocking FS operations */
 	struct mutex node_write;		/* locking node writes */
 	struct mutex writepages;		/* mutex for writepages() */
-	int por_doing;				/* recovery is doing or not */
-	int on_build_free_nids;			/* build_free_nids is doing */
+	bool por_doing;				/* recovery is doing or not */
+	bool on_build_free_nids;		/* build_free_nids is doing */
 	struct task_struct *cp_task;		/* checkpoint task */
 
 	/* for orphan inode management */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index ef80f79..f90485b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1444,9 +1444,9 @@ retry:
 
 	/* Let's scan nat pages and its caches to get free nids */
 	mutex_lock(&nm_i->build_lock);
-	sbi->on_build_free_nids = 1;
+	sbi->on_build_free_nids = true;
 	build_free_nids(sbi);
-	sbi->on_build_free_nids = 0;
+	sbi->on_build_free_nids = false;
 	mutex_unlock(&nm_i->build_lock);
 	goto retry;
 }
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 353cf4f..b278c68 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -425,7 +425,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 {
 	struct list_head inode_list;
 	int err;
-	int need_writecp = 0;
+	bool need_writecp = false;
 
 	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
 			sizeof(struct fsync_inode_entry), NULL);
@@ -435,7 +435,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	INIT_LIST_HEAD(&inode_list);
 
 	/* step #1: find fsynced inode numbers */
-	sbi->por_doing = 1;
+	sbi->por_doing = true;
 	err = find_fsync_dnodes(sbi, &inode_list);
 	if (err)
 		goto out;
@@ -443,7 +443,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	if (list_empty(&inode_list))
 		goto out;
 
-	need_writecp = 1;
+	need_writecp = true;
 
 	/* step #2: recover data */
 	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
@@ -451,7 +451,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 out:
 	destroy_fsync_dnodes(&inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
-	sbi->por_doing = 0;
+	sbi->por_doing = false;
 	if (!err && need_writecp)
 		write_checkpoint(sbi, false);
 	return err;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 692f35f..9a09459 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -850,7 +850,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	mutex_init(&sbi->writepages);
 	mutex_init(&sbi->cp_mutex);
 	mutex_init(&sbi->node_write);
-	sbi->por_doing = 0;
+	sbi->por_doing = false;
 	spin_lock_init(&sbi->stat_lock);
 	init_rwsem(&sbi->bio_sem);
 	init_rwsem(&sbi->cp_rwsem);
-- 
1.7.9.5

