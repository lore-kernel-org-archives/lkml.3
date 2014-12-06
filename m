Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaLFT4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 14:56:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:37349 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbaLFTzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 14:55:49 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5/5] f2fs: count the number of inmemory pages
Date: Sat,  6 Dec 2014 11:55:39 -0800
Message-Id: <1417895739-15251-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
References: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds counting # of inmemory pages in the page cache.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/debug.c   | 3 +++
 fs/f2fs/f2fs.h    | 3 ++-
 fs/f2fs/segment.c | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 40b679c..4e2e39c 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -39,6 +39,7 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	si->ndirty_dent = get_pages(sbi, F2FS_DIRTY_DENTS);
 	si->ndirty_dirs = sbi->n_dirty_dirs;
 	si->ndirty_meta = get_pages(sbi, F2FS_DIRTY_META);
+	si->inmem_pages = get_pages(sbi, F2FS_INMEM_PAGES);
 	si->total_count = (int)sbi->user_block_count / sbi->blocks_per_seg;
 	si->rsvd_segs = reserved_segments(sbi);
 	si->overp_segs = overprovision_segments(sbi);
@@ -249,6 +250,8 @@ static int stat_show(struct seq_file *s, void *v)
 		seq_printf(s, "\nExtent Hit Ratio: %d / %d\n",
 			   si->hit_ext, si->total_ext);
 		seq_puts(s, "\nBalancing F2FS Async:\n");
+		seq_printf(s, "  - inmem: %4d\n",
+			   si->inmem_pages);
 		seq_printf(s, "  - nodes: %4d in %4d\n",
 			   si->ndirty_node, si->node_pages);
 		seq_printf(s, "  - dents: %4d in dirs:%4d\n",
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c787fe3..f60b817 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -462,6 +462,7 @@ enum count_type {
 	F2FS_DIRTY_DENTS,
 	F2FS_DIRTY_NODES,
 	F2FS_DIRTY_META,
+	F2FS_INMEM_PAGES,
 	NR_COUNT_TYPE,
 };
 
@@ -1498,7 +1499,7 @@ struct f2fs_stat_info {
 	int ndirty_node, ndirty_dent, ndirty_dirs, ndirty_meta;
 	int nats, sits, fnids;
 	int total_count, utilization;
-	int bg_gc, inline_inode, inline_dir;
+	int bg_gc, inline_inode, inline_dir, inmem_pages;
 	unsigned int valid_count, valid_node_count, valid_inode_count;
 	unsigned int bimodal, avg_vblocks;
 	int util_free, util_valid, util_invalid;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3ebcf96..42607a6 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -201,6 +201,7 @@ retry:
 	}
 	get_page(page);
 	list_add_tail(&new->list, &fi->inmem_pages);
+	inc_page_count(F2FS_I_SB(inode), F2FS_INMEM_PAGES);
 	mutex_unlock(&fi->inmem_lock);
 }
 
@@ -216,6 +217,7 @@ void invalidate_inmem_page(struct inode *inode, struct page *page)
 		f2fs_put_page(cur->page, 0);
 		list_del(&cur->list);
 		kmem_cache_free(inmem_entry_slab, cur);
+		dec_page_count(F2FS_I_SB(inode), F2FS_INMEM_PAGES);
 	}
 	mutex_unlock(&fi->inmem_lock);
 }
@@ -257,6 +259,7 @@ void commit_inmem_pages(struct inode *inode, bool abort)
 		f2fs_put_page(cur->page, 1);
 		list_del(&cur->list);
 		kmem_cache_free(inmem_entry_slab, cur);
+		dec_page_count(F2FS_I_SB(inode), F2FS_INMEM_PAGES);
 	}
 	if (submit_bio)
 		f2fs_submit_merged_bio(sbi, DATA, WRITE);
-- 
2.1.1

