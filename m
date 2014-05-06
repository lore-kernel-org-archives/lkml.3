Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbaEFIyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:54:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23200 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbaEFIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:54:09 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-a1-5368a32fbbef
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 5/6] f2fs: add a tracepoint for f2fs_read_data_page
Date: Tue, 06 May 2014 16:53:08 +0800
Message-id: <004701cf6908$bdb6c380$39244a80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9pCB3kGFamN5yqS0aXfd/x60e9xA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQV39xRnBBn/+iVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfFgRjtLwRKBit43
	N1kbGBfydjFyckgImEi8v72XFcIWk7hwbz1bFyMXh5DAdEaJQ3s+Qjk/GCVW3/nCAlLFJqAi
	sbzjPxOILSKgKfF4+WZmEJtZIFPiXtMMMFtYwFei8ckkoKkcHCwCqhI9TewgYV4BS4lln/5D
	2YISPybfY4Fo1ZJYv/M4E4QtL7F5zVtmiIMUJHacfc0IsUpPYsWEC2wQNeISG4/cYpnAKDAL
	yahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCA/mZ1A7GlQ0WhxgF
	OBiVeHhPrEwPFmJNLCuuzD3EKMHBrCTCW5+fESzEm5JYWZValB9fVJqTWnyIUZqDRUmc90Cr
	daCQQHpiSWp2ampBahFMlomDUwoY5PfjrzUc+uLNXK+d8y3RnIPX/tYM19w5Ysf9zwT2d1ZG
	+1StMXQsc1Eyn5k+1+dT1xKJzFea89iYHeoqvvY+XcS46EZvFM+vHZ5P9HPZ/7RX7Fyukr5J
	UsdXwP2pfVVd1oKkOUFb75w5uU1c+VeJkPj36zOCbFudXiRt6+Vfs2peSQzHT0klluKMREMt
	5qLiRACOU3klYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_read_data_page to trace when page is
readed by user.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              |    2 ++
 include/trace/events/f2fs.h |   15 +++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 21bfafa..8c250a5 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -713,6 +713,8 @@ static int f2fs_read_data_page(struct file *file, struct page *page)
 	struct inode *inode = page->mapping->host;
 	int ret;
 
+	trace_f2fs_readpage(page, DATA);
+
 	/* If the file has inline data, try to read it directlly */
 	if (f2fs_has_inline_data(inode))
 		ret = f2fs_read_inline_data(inode, page);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 91b1fcc..b983990 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -732,6 +732,7 @@ DECLARE_EVENT_CLASS(f2fs__page,
 		__field(int, dir)
 		__field(pgoff_t, index)
 		__field(int, dirty)
+		__field(int, uptodate)
 	),
 
 	TP_fast_assign(
@@ -741,14 +742,17 @@ DECLARE_EVENT_CLASS(f2fs__page,
 		__entry->dir	= S_ISDIR(page->mapping->host->i_mode);
 		__entry->index	= page->index;
 		__entry->dirty	= PageDirty(page);
+		__entry->uptodate = PageUptodate(page);
 	),
 
-	TP_printk("dev = (%d,%d), ino = %lu, %s, %s, index = %lu, dirty = %d",
+	TP_printk("dev = (%d,%d), ino = %lu, %s, %s, index = %lu, "
+		"dirty = %d, uptodate = %d",
 		show_dev_ino(__entry),
 		show_block_type(__entry->type),
 		show_file_type(__entry->dir),
 		(unsigned long)__entry->index,
-		__entry->dirty)
+		__entry->dirty,
+		__entry->uptodate)
 );
 
 DEFINE_EVENT(f2fs__page, f2fs_writepage,
@@ -758,6 +762,13 @@ DEFINE_EVENT(f2fs__page, f2fs_writepage,
 	TP_ARGS(page, type)
 );
 
+DEFINE_EVENT(f2fs__page, f2fs_readpage,
+
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type)
+);
+
 DEFINE_EVENT(f2fs__page, f2fs_set_page_dirty,
 
 	TP_PROTO(struct page *page, int type),
-- 
1.7.9.5


