Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbaEFIwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:52:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45589 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbaEFIwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:52:15 -0400
X-AuditID: cbfee61b-b7f766d00000646c-a3-5368a2bb4552
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 4/6] f2fs: add a tracepoint for
 f2fs_write_{meta,node,data}_pages
Date: Tue, 06 May 2014 16:51:24 +0800
Message-id: <004601cf6908$76af2b80$640d8280$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9pCFNmBjdh3htZRkeu7PV8Qzav5A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd3dizKCDZYsMra4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+P1tOmMBfcUKn49
	PcrUwLhYuouRk0NCwERi+arLzBC2mMSFe+vZuhi5OIQEFjFK9P1tYIVwfjBKzP6/FKyKTUBF
	YnnHfyYQW0RAU+Lx8s1gcWaBTIl7TTPAbGGBWInuw/eBajg4WARUJRYd0QUJ8wpYShxomckI
	YQtK/Jh8jwWiVUti/c7jTBC2vMTmNW+hDlKQ2HH2NSPEKj2Jo7u+skHUiEtsPHKLZQKjwCwk
	o2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgO5GfSOxhXNVgcYhTg
	YFTi4T2xMj1YiDWxrLgy9xCjBAezkghvfX5GsBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63W
	gUIC6YklqdmpqQWpRTBZJg5OqQbGOTO513rn/QlZ/ZRpI2vRl2PZHoucy1rOLD3T0sj09d3O
	hjYermdn135/vjm1MedLdcnZowoM57mmhldrvSozqnq1eJqiSNAeIZdzmhHub2acUo8IM5ee
	987P4Wq1v/XSk6l/WT/y5P1IZW1z5d0mKndLI6h9wXGBbOuYuCj/m/P+8j6aP3eJEktxRqKh
	FnNRcSIAKKxxB2ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_write_{meta,node,data}_pages to trace when
pages are fsyncing/flushing.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c        |    2 ++
 fs/f2fs/data.c              |    2 ++
 fs/f2fs/node.c              |    2 ++
 include/trace/events/f2fs.h |   64 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 7962aaf..acf057a 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -189,6 +189,8 @@ static int f2fs_write_meta_pages(struct address_space *mapping,
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 	long diff, written;
 
+	trace_f2fs_writepages(mapping->host, wbc, META);
+
 	/* collect a number of dirty meta pages and write together */
 	if (wbc->for_kupdate ||
 		get_pages(sbi, F2FS_DIRTY_META) < nr_pages_to_skip(sbi, META))
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b997d55..21bfafa 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -860,6 +860,8 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 	int ret;
 	long diff;
 
+	trace_f2fs_writepages(mapping->host, wbc, DATA);
+
 	/* deal with chardevs and other special file */
 	if (!mapping->a_ops->writepage)
 		return 0;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 49bdddb..3d60d3d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1242,6 +1242,8 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 	long diff;
 
+	trace_f2fs_writepages(mapping->host, wbc, NODE);
+
 	/* balancing f2fs's metadata in background */
 	f2fs_balance_fs_bg(sbi);
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index d70991e..91b1fcc 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -772,6 +772,70 @@ DEFINE_EVENT(f2fs__page, f2fs_vm_page_mkwrite,
 	TP_ARGS(page, type)
 );
 
+TRACE_EVENT(f2fs_writepages,
+
+	TP_PROTO(struct inode *inode, struct writeback_control *wbc, int type),
+
+	TP_ARGS(inode, wbc, type),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int,	type)
+		__field(int,	dir)
+		__field(long,	nr_to_write)
+		__field(long,	pages_skipped)
+		__field(loff_t,	range_start)
+		__field(loff_t,	range_end)
+		__field(pgoff_t, writeback_index)
+		__field(int,	sync_mode)
+		__field(char,	for_kupdate)
+		__field(char,	for_background)
+		__field(char,	tagged_writepages)
+		__field(char,	for_reclaim)
+		__field(char,	range_cyclic)
+		__field(char,	for_sync)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->type		= type;
+		__entry->dir		= S_ISDIR(inode->i_mode);
+		__entry->nr_to_write	= wbc->nr_to_write;
+		__entry->pages_skipped	= wbc->pages_skipped;
+		__entry->range_start	= wbc->range_start;
+		__entry->range_end	= wbc->range_end;
+		__entry->writeback_index = inode->i_mapping->writeback_index;
+		__entry->sync_mode	= wbc->sync_mode;
+		__entry->for_kupdate	= wbc->for_kupdate;
+		__entry->for_background	= wbc->for_background;
+		__entry->tagged_writepages	= wbc->tagged_writepages;
+		__entry->for_reclaim	= wbc->for_reclaim;
+		__entry->range_cyclic	= wbc->range_cyclic;
+		__entry->for_sync	= wbc->for_sync;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, %s, %s, nr_to_write %ld, "
+		"skipped %ld, start %lld, end %lld, wb_idx %lu, sync_mode %d, "
+		"kupdate %u background %u tagged %u reclaim %u cyclic %u sync %u",
+		show_dev_ino(__entry),
+		show_block_type(__entry->type),
+		show_file_type(__entry->dir),
+		__entry->nr_to_write,
+		__entry->pages_skipped,
+		__entry->range_start,
+		__entry->range_end,
+		(unsigned long)__entry->writeback_index,
+		__entry->sync_mode,
+		__entry->for_kupdate,
+		__entry->for_background,
+		__entry->tagged_writepages,
+		__entry->for_reclaim,
+		__entry->range_cyclic,
+		__entry->for_sync)
+);
+
 TRACE_EVENT(f2fs_submit_page_mbio,
 
 	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
-- 
1.7.9.5


