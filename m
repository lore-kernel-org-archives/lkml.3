Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbbAZF6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:58:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54476 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbbAZF6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:58:30 -0500
X-AuditID: cbfee61a-f79c06d000004e71-71-54c5d7844b01
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2 10/10] f2fs: add trace for rb-tree extent cache ops
Date: Mon, 26 Jan 2015 13:57:42 +0800
Message-id: <006601d0392d$1b1a62d0$514f2870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA24Xwk94lL3vTnSvGs9ePJhPyV3A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd2W60dDDF7917a4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxpfdD5gL
	jhlVvFi+j7mBcZ1mFyMnh4SAicS1Q0dZIWwxiQv31rN1MXJxCAlMZ5To2XOSCcL5wSixfOIO
	ZpAqNgEVieUd/5lAbBEBL4lJ+0+wgNjMAh4SjR3fwSYJCwRILJ+wjx3EZhFQlbiyuAesl1fA
	UuLJpfksELagxI/J96B6tSTW7zzOBGHLS2xe85YZ4iIFiR1nXzNC7NKTeNS5ghmiRlxi45Fb
	LBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwUD+T2sG4
	ssHiEKMAB6MSD29D89EQIdbEsuLK3EOMEhzMSiK85VOAQrwpiZVVqUX58UWlOanFhxilOViU
	xHmV7NtChATSE0tSs1NTC1KLYLJMHJxSDYwnZh033FM+Szb/XHZ9+3f2DWv1ypsm+3u7pa++
	seAUc+qUumb+W+XOjV+ydxSaLl30Jkj2RGsfQ7y1XPhbR/2Se3pVcxntWPac3iTO+PXU6o0v
	n3/ONv3n+THqcp6l970LrxVeeqe8vFIRUMv9jWWDxhsGjroTJ38sesR6W3HO8ZnrBRh3Vz9T
	YinOSDTUYi4qTgQALTtzP2YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds trace for lookup/update/shrink/destroy ops in rb-tree extent cache.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              |  16 +++++-
 include/trace/events/f2fs.h | 134 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2325b1c..aff497e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -533,6 +533,8 @@ static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
 	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
 		return false;
 
+	trace_f2fs_lookup_extent_tree_start(inode, pgofs);
+
 	down_read(&sbi->extent_tree_lock);
 	et = radix_tree_lookup(&sbi->extent_tree_root, inode->i_ino);
 	if (!et) {
@@ -555,6 +557,8 @@ static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
 	stat_inc_total_hit(sbi->sb);
 	read_unlock(&et->lock);
 
+	trace_f2fs_lookup_extent_tree_end(inode, pgofs, en);
+
 	atomic_dec(&et->refcount);
 	return en ? true : false;
 }
@@ -573,6 +577,8 @@ static void f2fs_update_extent_tree(struct inode *inode, pgoff_t fofs,
 	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
 		return;
 
+	trace_f2fs_update_extent_tree(inode, fofs, blkaddr);
+
 	down_write(&sbi->extent_tree_lock);
 	et = radix_tree_lookup(&sbi->extent_tree_root, ino);
 	if (!et) {
@@ -664,6 +670,7 @@ void f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 	struct radix_tree_iter iter;
 	void **slot;
 	unsigned int found;
+	unsigned int node_cnt = 0, tree_cnt = 0;
 
 	if (!test_opt(sbi, EXTENT_CACHE))
 		return;
@@ -690,7 +697,7 @@ void f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 
 			atomic_inc(&et->refcount);
 			write_lock(&et->lock);
-			__free_extent_tree(sbi, et, false);
+			node_cnt += __free_extent_tree(sbi, et, false);
 			write_unlock(&et->lock);
 			atomic_dec(&et->refcount);
 		}
@@ -706,15 +713,19 @@ void f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 			radix_tree_delete(&sbi->extent_tree_root, et->ino);
 			kmem_cache_free(extent_tree_slab, et);
 			sbi->total_ext_tree--;
+			tree_cnt++;
 		}
 	}
 	up_write(&sbi->extent_tree_lock);
+
+	trace_f2fs_shrink_extent_tree(sbi, node_cnt, tree_cnt);
 }
 
 void f2fs_destroy_extent_tree(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct extent_tree *et;
+	unsigned int node_cnt = 0;
 
 	if (!test_opt(sbi, EXTENT_CACHE))
 		return;
@@ -730,7 +741,7 @@ void f2fs_destroy_extent_tree(struct inode *inode)
 
 	/* free all extent info belong to this extent tree */
 	write_lock(&et->lock);
-	__free_extent_tree(sbi, et, true);
+	node_cnt = __free_extent_tree(sbi, et, true);
 	write_unlock(&et->lock);
 
 	atomic_dec(&et->refcount);
@@ -748,6 +759,7 @@ void f2fs_destroy_extent_tree(struct inode *inode)
 	sbi->total_ext_tree--;
 	up_write(&sbi->extent_tree_lock);
 out:
+	trace_f2fs_destroy_extent_tree(inode, node_cnt);
 	return;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 13992f3..8f53fda 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -1009,6 +1009,140 @@ TRACE_EVENT(f2fs_issue_flush,
 		__entry->nobarrier ? "skip (nobarrier)" : "issue",
 		__entry->flush_merge ? " with flush_merge" : "")
 );
+
+TRACE_EVENT(f2fs_lookup_extent_tree_start,
+
+	TP_PROTO(struct inode *inode, unsigned int pgofs),
+
+	TP_ARGS(inode, pgofs),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(unsigned int, pgofs)
+	),
+
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->pgofs = pgofs;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, pgofs = %u",
+		show_dev_ino(__entry),
+		__entry->pgofs)
+);
+
+TRACE_EVENT_CONDITION(f2fs_lookup_extent_tree_end,
+
+	TP_PROTO(struct inode *inode, unsigned int pgofs,
+						struct extent_node *en),
+
+	TP_ARGS(inode, pgofs, en),
+
+	TP_CONDITION(en),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(unsigned int, pgofs)
+		__field(unsigned int, fofs)
+		__field(u32, blk)
+		__field(unsigned int, len)
+	),
+
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->pgofs = pgofs;
+		__entry->fofs = en->ei.fofs;
+		__entry->blk = en->ei.blk;
+		__entry->len = en->ei.len;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, pgofs = %u, "
+		"ext_info(fofs: %u, blk: %u, len: %u)",
+		show_dev_ino(__entry),
+		__entry->pgofs,
+		__entry->fofs,
+		__entry->blk,
+		__entry->len)
+);
+
+TRACE_EVENT(f2fs_update_extent_tree,
+
+	TP_PROTO(struct inode *inode, unsigned int pgofs, block_t blkaddr),
+
+	TP_ARGS(inode, pgofs, blkaddr),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(unsigned int, pgofs)
+		__field(u32, blk)
+	),
+
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->pgofs = pgofs;
+		__entry->blk = blkaddr;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, pgofs = %u, blkaddr = %u",
+		show_dev_ino(__entry),
+		__entry->pgofs,
+		__entry->blk)
+);
+
+TRACE_EVENT(f2fs_shrink_extent_tree,
+
+	TP_PROTO(struct f2fs_sb_info *sbi, unsigned int node_cnt,
+						unsigned int tree_cnt),
+
+	TP_ARGS(sbi, node_cnt, tree_cnt),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(unsigned int, node_cnt)
+		__field(unsigned int, tree_cnt)
+	),
+
+	TP_fast_assign(
+		__entry->dev = sbi->sb->s_dev;
+		__entry->node_cnt = node_cnt;
+		__entry->tree_cnt = tree_cnt;
+	),
+
+	TP_printk("dev = (%d,%d), shrunk: node_cnt = %u, tree_cnt = %u",
+		show_dev(__entry),
+		__entry->node_cnt,
+		__entry->tree_cnt)
+);
+
+TRACE_EVENT(f2fs_destroy_extent_tree,
+
+	TP_PROTO(struct inode *inode, unsigned int node_cnt),
+
+	TP_ARGS(inode, node_cnt),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(unsigned int, node_cnt)
+	),
+
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->node_cnt = node_cnt;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, destroyed: node_cnt = %u",
+		show_dev_ino(__entry),
+		__entry->node_cnt)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
2.2.1


