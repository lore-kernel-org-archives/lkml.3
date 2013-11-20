Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3KTIlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:41:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42587 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3KTIlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:41:03 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-e8-528c759d8e8d
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 1/2] f2fs: adds a tracepoint for submit_read_page
Date: Wed, 20 Nov 2013 16:40:10 +0800
Message-id: <001e01cee5cc$3d118310$b7348930$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7lysJw152B31R1Tku1iEIEWIYTpA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQd25pT1BBrfPiltc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxv79txgL
	FvJWLO3pYWlg/MzVxcjJISFgIvF41glmCFtM4sK99WxdjFwcQgLTGSVOX5rODOH8YJTYMmcr
	E0gVm4CKxPKO/2C2iICixIb3G9hBipgFZjBKHJ77jxUkISzgI9HSvJYdxGYRUJVYvbEZLM4r
	YClxvLuLGcIWlPgx+R4LiM0soCHRv2gDG4QtL7F5zVuokxQkdpx9zQixTE/i1uN/UPXiEhuP
	3GKZwCgwC8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsP6mdQO
	xpUNFocYBTgYlXh4JRZ0BwmxJpYVV+YeYpTgYFYS4V1R2BMkxJuSWFmVWpQfX1Sak1p8iFGa
	g0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgTFU0Sd1tsfKQ7c/MZx8IPvqSH4UT1Yqp9y6
	fdYnHa949f55UfvczmNiwet7/aa/L4hun39nenXs98Xx4vbdMm9r1M6ekeRTTZ2mtDpcNmqj
	37z7HxyzXRb2rLyxbbPXjFbez0v+JjWYHk762pi4jr1p+v0J2e67d1c6r9snsTUqr6Zb7N1E
	8UglluKMREMt5qLiRAAZpmvjZwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for submit_read_page.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              |    1 +
 include/trace/events/f2fs.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9cf3f6c..0ca93be 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -448,6 +448,7 @@ alloc_new:
 	io->last_block_in_bio = blk_addr;
 
 	mutex_unlock(&io->io_mutex);
+	trace_f2fs_submit_read_page(page, blk_addr, rw);
 }
 
 /*
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index e0dc355..571f39a 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -453,6 +453,36 @@ TRACE_EVENT_CONDITION(f2fs_readpage,
 		show_bio_type(__entry->type))
 );
 
+TRACE_EVENT(f2fs_submit_read_page,
+
+	TP_PROTO(struct page *page, block_t blk_addr, int rw),
+
+	TP_ARGS(page, blk_addr, rw),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int, rw)
+		__field(pgoff_t, index)
+		__field(block_t, block)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->rw	= rw;
+		__entry->index	= page->index;
+		__entry->block	= blk_addr;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, bio_type = %s, "
+		"index = %lu, blkaddr = 0x%llx",
+		show_dev_ino(__entry),
+		show_bio_type(__entry->rw),
+		(unsigned long)__entry->index,
+		(unsigned long long)__entry->block)
+);
+
 TRACE_EVENT(f2fs_get_data_block,
 	TP_PROTO(struct inode *inode, sector_t iblock,
 				struct buffer_head *bh, int ret),
-- 
1.7.9.5

