Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbbALHSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:18:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32553 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbbALHSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:18:41 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-cb-54b375505477
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][RFC PATCH 09/10] f2fs: show extent tree,node stat info in
 debugfs
Date: Mon, 12 Jan 2015 15:17:56 +0800
Message-id: <000d01d02e37$fe5310c0$faf93240$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAuBrTeB3SkMuq5TqygfuRx6GmceA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jQd2A0s0hBs9OyVlc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro2/2RPaC
	q4IV++d8YmlgvM7XxcjJISFgIvH3xmtmCFtM4sK99WwgtpDAdEaJndcquhi5gOwfjBKzb85g
	BUmwCahILO/4zwRiiwh4SUzaf4IFxGYW8JBo7PgOViMsEC7x4cEHRhCbRUBVYtWZa+wgNq+A
	pcTiLbeZIWxBiR+T70H1akms33mcCcKWl9i85i3UQQoSO86+BprDDrRLT+K0LUSFuMTGI7dY
	JjAKzEIyaBaSQbOQDJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBwfia9g3FV
	g8UhRgEORiUeXgupzSFCrIllxZW5hxglOJiVRHjDrIFCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eZXs20KEBNITS1KzU1MLUotgskwcnFINjBqSYU+dJCcsrF+5eHJ5esCi+y0zLsdlRPR0NfVZ
	5n+5lLOh8MnRzMmG21NYC6aY/7Y1fRU+3Te9PBfo5B3yAuvkGeyedU3cadvSIfp+y38tPh7v
	Lys678ZMtuffZsDGdUn5ocebL2fFZHIf/mBQOF4XofHLXvlAK6948e/w1P8vbe7c6WBVYinO
	SDTUYi4qTgQAkAtdCmMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add and show stat info of total memory footprint for extent tree,node
in debugfs.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/debug.c | 7 +++++++
 fs/f2fs/f2fs.h  | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 1f0fb58..0fdfffe 100644
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
@@ -177,6 +179,9 @@ get_cache:
 	si->cache_mem += sbi->n_dirty_dirs * sizeof(struct inode_entry);
 	for (i = 0; i <= UPDATE_INO; i++)
 		si->cache_mem += sbi->im[i].ino_num * sizeof(struct ino_entry);
+	si->cache_mem += sbi->total_ext_tree * sizeof(struct extent_tree);
+	si->cache_mem += atomic_read(&sbi->total_ext_node) *
+						sizeof(struct extent_node);
 }
 
 static int stat_show(struct seq_file *s, void *v)
@@ -253,6 +258,8 @@ static int stat_show(struct seq_file *s, void *v)
 		seq_printf(s, "  - node blocks : %d\n", si->node_blks);
 		seq_printf(s, "\nExtent Hit Ratio: %d / %d\n",
 			   si->hit_ext, si->total_ext);
+		seq_printf(s, "\nExtent Tree Count: %d\n", si->ext_tree);
+		seq_printf(s, "\nExtent Node Count: %d\n", si->ext_node);
 		seq_puts(s, "\nBalancing F2FS Async:\n");
 		seq_printf(s, "  - inmem: %4d\n",
 			   si->inmem_pages);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 811fd90..c5138fc 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1540,7 +1540,7 @@ struct f2fs_stat_info {
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


