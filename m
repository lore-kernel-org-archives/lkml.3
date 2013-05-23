Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab3EWN6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:58:06 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62870 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab3EWN6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:58:04 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/4] f2fs: push some variables to debug part
Date: Thu, 23 May 2013 22:57:53 +0900
Message-Id: <1369317473-14312-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Some, counters are needed only for the statistical information
while debugging.
So, those can be controlled using CONFIG_F2FS_STAT_FS,
pushing the usage for few variables under this flag.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/checkpoint.c |    4 ++++
 fs/f2fs/data.c       |    6 ++++++
 fs/f2fs/f2fs.h       |    6 ++++--
 fs/f2fs/gc.c         |    2 ++
 fs/f2fs/segment.c    |    5 +++++
 5 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 3d11449..01ddc91 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -478,7 +478,9 @@ retry:
 		}
 	}
 	list_add_tail(&new->list, head);
+#ifdef CONFIG_F2FS_STAT_FS
 	sbi->n_dirty_dirs++;
+#endif
 
 	BUG_ON(!S_ISDIR(inode->i_mode));
 out:
@@ -508,7 +510,9 @@ void remove_dirty_dir_inode(struct inode *inode)
 		if (entry->inode == inode) {
 			list_del(&entry->list);
 			kmem_cache_free(inode_entry_slab, entry);
+#ifdef CONFIG_F2FS_STAT_FS
 			sbi->n_dirty_dirs--;
+#endif
 			break;
 		}
 	}
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 1644fff..93917e3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -68,7 +68,9 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 					struct buffer_head *bh_result)
 {
 	struct f2fs_inode_info *fi = F2FS_I(inode);
+#ifdef CONFIG_F2FS_STAT_FS
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+#endif
 	pgoff_t start_fofs, end_fofs;
 	block_t start_blkaddr;
 
@@ -78,7 +80,9 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 		return 0;
 	}
 
+#ifdef CONFIG_F2FS_STAT_FS
 	sbi->total_hit_ext++;
+#endif
 	start_fofs = fi->ext.fofs;
 	end_fofs = fi->ext.fofs + fi->ext.len - 1;
 	start_blkaddr = fi->ext.blk_addr;
@@ -96,7 +100,9 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 		else
 			bh_result->b_size = UINT_MAX;
 
+#ifdef CONFIG_F2FS_STAT_FS
 		sbi->read_hit_ext++;
+#endif
 		read_unlock(&fi->ext.ext_lock);
 		return 1;
 	}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 7b05029..00c8c5f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -369,7 +369,6 @@ struct f2fs_sb_info {
 	/* for directory inode management */
 	struct list_head dir_inode_list;	/* dir inode list */
 	spinlock_t dir_inode_lock;		/* for dir inode list lock */
-	unsigned int n_dirty_dirs;		/* # of dir inodes */
 
 	/* basic file system units */
 	unsigned int log_sectors_per_block;	/* log2 sectors per block */
@@ -406,12 +405,15 @@ struct f2fs_sb_info {
 	 * for stat information.
 	 * one is for the LFS mode, and the other is for the SSR mode.
 	 */
+#ifdef CONFIG_F2FS_STAT_FS
 	struct f2fs_stat_info *stat_info;	/* FS status information */
 	unsigned int segment_count[2];		/* # of allocated segments */
 	unsigned int block_count[2];		/* # of allocated blocks */
-	unsigned int last_victim[2];		/* last victim segment # */
 	int total_hit_ext, read_hit_ext;	/* extent cache hit ratio */
 	int bg_gc;				/* background gc calls */
+	unsigned int n_dirty_dirs;		/* # of dir inodes */
+#endif
+	unsigned int last_victim[2];		/* last victim segment # */
 	spinlock_t stat_lock;			/* lock for stat operations */
 };
 
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 1496159..25b083c 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -76,7 +76,9 @@ static int gc_thread_func(void *data)
 		else
 			wait_ms = increase_sleep_time(wait_ms);
 
+#ifdef CONFIG_F2FS_STAT_FS
 		sbi->bg_gc++;
+#endif
 
 		/* if return value is not zero, no victim was selected */
 		if (f2fs_gc(sbi))
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3a0d027..6ebad78 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -610,7 +610,10 @@ static void allocate_segment_by_default(struct f2fs_sb_info *sbi,
 	else
 		new_curseg(sbi, type, false);
 out:
+#ifdef CONFIG_F2FS_STAT_FS
 	sbi->segment_count[curseg->alloc_type]++;
+#endif
+return;
 }
 
 void allocate_new_segments(struct f2fs_sb_info *sbi)
@@ -846,7 +849,9 @@ static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
 
 	mutex_lock(&sit_i->sentry_lock);
 	__refresh_next_blkoff(sbi, curseg);
+#ifdef CONFIG_F2FS_STAT_FS
 	sbi->block_count[curseg->alloc_type]++;
+#endif
 
 	/*
 	 * SIT information should be updated before segment allocation,
-- 
1.7.9.5

