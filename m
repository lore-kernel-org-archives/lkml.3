Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbbANAde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:33:34 -0500
Received: from mail.kernel.org ([198.145.29.136]:55499 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbbANAdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:33:31 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] f2fs: update memory footprint information
Date: Tue, 13 Jan 2015 16:33:24 -0800
Message-Id: <1421195604-5256-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1421195604-5256-1-git-send-email-jaegeuk@kernel.org>
References: <1421195604-5256-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing memory usages, and splits them in detail.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/debug.c | 24 +++++++++++++++++-------
 fs/f2fs/f2fs.h  |  2 +-
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index b45daab..0f721f6 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -177,13 +177,18 @@ get_cache:
 	/* free nids */
 	si->cache_mem += NM_I(sbi)->fcnt * sizeof(struct free_nid);
 	si->cache_mem += NM_I(sbi)->nat_cnt * sizeof(struct nat_entry);
-	npages = NODE_MAPPING(sbi)->nrpages;
-	si->cache_mem += npages << PAGE_CACHE_SHIFT;
-	npages = META_MAPPING(sbi)->nrpages;
-	si->cache_mem += npages << PAGE_CACHE_SHIFT;
+	si->cache_mem += NM_I(sbi)->dirty_nat_cnt *
+					sizeof(struct nat_entry_set);
+	si->cache_mem += si->inmem_pages * sizeof(struct inmem_pages);
 	si->cache_mem += sbi->n_dirty_dirs * sizeof(struct inode_entry);
 	for (i = 0; i <= UPDATE_INO; i++)
 		si->cache_mem += sbi->im[i].ino_num * sizeof(struct ino_entry);
+
+	si->page_mem = 0;
+	npages = NODE_MAPPING(sbi)->nrpages;
+	si->page_mem += npages << PAGE_CACHE_SHIFT;
+	npages = META_MAPPING(sbi)->nrpages;
+	si->page_mem += npages << PAGE_CACHE_SHIFT;
 }
 
 static int stat_show(struct seq_file *s, void *v)
@@ -301,9 +306,14 @@ static int stat_show(struct seq_file *s, void *v)
 
 		/* memory footprint */
 		update_mem_info(si->sbi);
-		seq_printf(s, "\nMemory: %u KB = static: %u + cached: %u\n",
-				(si->base_mem + si->cache_mem) >> 10,
-				si->base_mem >> 10, si->cache_mem >> 10);
+		seq_printf(s, "\nMemory: %u KB\n",
+			(si->base_mem + si->cache_mem + si->page_mem) >> 10);
+		seq_printf(s, "  - static: %u KB\n",
+				si->base_mem >> 10);
+		seq_printf(s, "  - cached: %u KB\n",
+				si->cache_mem >> 10);
+		seq_printf(s, "  - paged : %u KB\n",
+				si->page_mem >> 10);
 	}
 	mutex_unlock(&f2fs_stat_mutex);
 	return 0;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 209532c..c2cf040 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1530,7 +1530,7 @@ struct f2fs_stat_info {
 	unsigned int segment_count[2];
 	unsigned int block_count[2];
 	unsigned int inplace_count;
-	unsigned base_mem, cache_mem;
+	unsigned base_mem, cache_mem, page_mem;
 };
 
 static inline struct f2fs_stat_info *F2FS_STAT(struct f2fs_sb_info *sbi)
-- 
2.1.1

