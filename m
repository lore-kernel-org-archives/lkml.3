Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbbALHTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:19:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16294 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbALHTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:19:39 -0500
X-AuditID: cbfee61a-f79c06d000004e71-a7-54b3758990a8
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][RFC PATCH 10/10] f2fs: add trace for rb-tree extent cache
 ops
Date: Mon, 12 Jan 2015 15:18:54 +0800
Message-id: <000e01d02e38$2067bc60$61373520$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAuBsZ9gYtr+k3oQIyYhiC2wa8J8g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jAd3O0s0hBuvuqFlc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro+NTN0tB
	p2ZFc+d11gbGG4pdjBwcEgImEl0HS7oYOYFMMYkL99azdTFycQgJLGKUuNr0GMr5wSix7MJL
	dpAqNgEVieUd/5lAbBEBL4lJ+0+wgNjMAh4SjR3fWUFsYYFgiZ7771hBFrAIqEpMXmoFEuYV
	sJR4cPgEG4QtKPFj8j2oVi2J9TuPM0HY8hKb17xlhjhIQWLH2deMEKv0JK4tXwdVIy6x8cgt
	lgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4oJ9J7WBc
	2WBxiFGAg1GJh9dCanOIEGtiWXFl7iFGCQ5mJRHeMGugEG9KYmVValF+fFFpTmrxIUZpDhYl
	cV4l+7YQIYH0xJLU7NTUgtQimCwTB6dUA2N7ZL147ru955snOJStDVzZdJbt8lHecA/xD3mR
	BrNiTb51WyVOvnJj/dot/RbOnvddEwy98viPHS0pPfvim7erqIn+xb5y9mrZIyyrDK5qvp0R
	PWHyadXm7vMpMw9eZJ2qUcNU7ck+kUH07Zu6cv5UlQ0dm4K//cxUtPrvvPLODtm0PYtCxZRY
	ijMSDbWYi4oTAS8SPhZkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds trace for lookup/update/shrink/destroy ops in rb-tree extent cache.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              |   9 +++
 include/trace/events/f2fs.h | 134 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ed7b9c5..d636475 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -572,6 +572,8 @@ static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
 	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
 		return false;
 
+	trace_f2fs_lookup_extent_tree_start(inode, pgofs);
+
 	down_read(&sbi->extent_tree_lock);
 	et = radix_tree_lookup(&sbi->extent_tree_root, inode->i_ino);
 	if (!et) {
@@ -594,6 +596,8 @@ static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
 	stat_inc_total_hit(sbi->sb);
 	read_unlock(&et->lock);
 
+	trace_f2fs_lookup_extent_tree_end(inode, pgofs, en);
+
 	atomic_dec(&et->refcount);
 	return en ? true : false;
 }
@@ -613,6 +617,8 @@ static void f2fs_update_extent_tree(struct inode *inode, pgoff_t fofs,
 	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
 		return;
 
+	trace_f2fs_update_extent_tree(inode, fofs, blkaddr);
+
 retry:
 	down_write(&sbi->extent_tree_lock);
 	et = radix_tree_lookup(&sbi->extent_tree_root, ino);
@@ -763,6 +769,8 @@ void f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 		}
 	}
 	up_write(&sbi->extent_tree_lock);
+
+	trace_f2fs_shrink_extent_tree(sbi, node_cnt, tree_cnt);
 }
 
 void f2fs_destroy_extent_tree(struct inode *inode)
@@ -803,6 +811,7 @@ void f2fs_destroy_extent_tree(struct inode *inode)
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


