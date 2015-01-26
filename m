Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbbAZF52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:57:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:59397 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbbAZF5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:57:24 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-55-54c5d7426edb
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2 09/10] f2fs: show extent tree,node stat info in
 debugfs
Date: Mon, 26 Jan 2015 13:56:36 +0800
Message-id: <006501d0392c$f3df5b30$db9e1190$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA24WJ0iqXkJiGzRwSPv2YcQAhRVA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jQV2n60dDDHobTSyu7Wtksniyfhaz
	xaVF7haXd81hc2Dx2LSqk81j94LPTB59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVceaEf8Fd
	wYqWti72BsZ7fF2MHBwSAiYSD57GdjFyApliEhfurWfrYuTiEBKYzijRcnoyI4Tzg1Fix7xJ
	bCBVbAIqEss7/jOB2CICXhKT9p9gAbGZBTwkGju+s4LYwgJhEq+WTgerZxFQldgxfyVYnFfA
	UuLAiVdMELagxI/J96B6tSTW7zzOBGHLS2xe85YZ4iIFiR1nXzOCHCoioCfxaIYfRIm4xMYj
	t1gmMArMQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4HB+Jr2D
	cVWDxSFGAQ5GJR5ejcajIUKsiWXFlbmHGCU4mJVEeMunAIV4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzKtm3hQgJpCeWpGanphakFsFkmTg4pRoY575g80yYLb1k75Lz/15+c5+e8PewYmr3y6ta
	IhfUn89aesn4w5T1d44wTnDTk09WOxOhUBqgd+miumdQJ6MH9/1v+RU+x1g2G/m0bhO7kvU3
	3y3T22d/wrnFE/r7Sw5ybnm3+c6Z3piQ/6Ib6+WnnbLuNDBw3dEZfeaId7Lt7qtBxYK7rR5t
	V2Ipzkg01GIuKk4EAOajnaFjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds and shows stat info of total memory footprint for extent tree,
node in debugfs.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/debug.c | 7 +++++++
 fs/f2fs/f2fs.h  | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 0f721f6..031dc61 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -35,6 +35,8 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	/* validation check of the segment numbers */
 	si->hit_ext = sbi->read_hit_ext;
 	si->total_ext = sbi->total_hit_ext;
+	si->ext_tree = sbi->total_ext_tree;
+	si->ext_node = atomic_read(&sbi->total_ext_node);
 	si->ndirty_node = get_pages(sbi, F2FS_DIRTY_NODES);
 	si->ndirty_dent = get_pages(sbi, F2FS_DIRTY_DENTS);
 	si->ndirty_dirs = sbi->n_dirty_dirs;
@@ -183,6 +185,9 @@ get_cache:
 	si->cache_mem += sbi->n_dirty_dirs * sizeof(struct inode_entry);
 	for (i = 0; i <= UPDATE_INO; i++)
 		si->cache_mem += sbi->im[i].ino_num * sizeof(struct ino_entry);
+	si->cache_mem += sbi->total_ext_tree * sizeof(struct extent_tree);
+	si->cache_mem += atomic_read(&sbi->total_ext_node) *
+						sizeof(struct extent_node);
 
 	si->page_mem = 0;
 	npages = NODE_MAPPING(sbi)->nrpages;
@@ -265,6 +270,8 @@ static int stat_show(struct seq_file *s, void *v)
 		seq_printf(s, "  - node blocks : %d\n", si->node_blks);
 		seq_printf(s, "\nExtent Hit Ratio: %d / %d\n",
 			   si->hit_ext, si->total_ext);
+		seq_printf(s, "\nExtent Tree Count: %d\n", si->ext_tree);
+		seq_printf(s, "\nExtent Node Count: %d\n", si->ext_node);
 		seq_puts(s, "\nBalancing F2FS Async:\n");
 		seq_printf(s, "  - inmem: %4d\n",
 			   si->inmem_pages);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c96f451..3329367 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1568,7 +1568,7 @@ struct f2fs_stat_info {
 	struct f2fs_sb_info *sbi;
 	int all_area_segs, sit_area_segs, nat_area_segs, ssa_area_segs;
 	int main_area_segs, main_area_sections, main_area_zones;
-	int hit_ext, total_ext;
+	int hit_ext, total_ext, ext_tree, ext_node;
 	int ndirty_node, ndirty_dent, ndirty_dirs, ndirty_meta;
 	int nats, dirty_nats, sits, dirty_sits, fnids;
 	int total_count, utilization;
-- 
2.2.1


