Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaEFIzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:55:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45979 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbaEFIzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:55:09 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-2a-5368a36c31fd
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 6/6] f2fs: add a tracepoint for f2fs_read_data_pages
Date: Tue, 06 May 2014 16:54:23 +0800
Message-id: <004801cf6908$e2149bd0$a63dd370$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9pCJ1oMWLILZnWThWRJ0xujooqLA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd2cxRnBBj/bxC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyphw+TxLwS/eiq2/
	nzE1MG7j7mLk5JAQMJE4PuMPM4QtJnHh3nq2LkYuDiGBRYwSZz+9ZIFwfjBKPLq2lBWkik1A
	RWJ5x38mEFtEQFPi8fLNYN3MApkS95pmgNnCAn4SdybPZwSxWQRUJZ6dnQ8U5+DgFbCU+Hvd
	ESTMKyAo8WPyPRaIVi2J9TuPM0HY8hKb17yFOkhBYsfZ14wgrSICehJXLkhBlIhLbDxyi2UC
	o8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDuNnUjsYVzZY
	HGIU4GBU4uE9sTI9WIg1say4MvcQowQHs5IIb31+RrAQb0piZVVqUX58UWlOavEhRmkOFiVx
	3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxsTXes0Ta7wnHRHOWiLjua2329zJ2epuOsN6wzWv
	w/aEVJ9f+ed6qILq1aB99/Qihbg2n2CoPsV9Yvukr3mLt6b5LvNQ65cTErq9WoZx+daZy4Lm
	r4mdp6ugWVx1YfsB/c0TxSxc43ZafTR5635C6IyceOhuNpG1mxf/1HIK+ha/Q9i/ebeKuBJL
	cUaioRZzUXEiAPWZNb5fAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_read_data_pages to trace when pages are
readahead by VFS.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              |    3 +++
 include/trace/events/f2fs.h |   26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8c250a5..f2d1e8a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -729,6 +729,9 @@ static int f2fs_read_data_pages(struct file *file,
 			struct list_head *pages, unsigned nr_pages)
 {
 	struct inode *inode = file->f_mapping->host;
+	struct page *page = list_entry(pages->prev, struct page, lru);
+
+	trace_f2fs_readpages(inode, page, nr_pages);
 
 	/* If the file has inline data, skip readpages */
 	if (f2fs_has_inline_data(inode))
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index b983990..7fbaaaa 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -847,6 +847,32 @@ TRACE_EVENT(f2fs_writepages,
 		__entry->for_sync)
 );
 
+TRACE_EVENT(f2fs_readpages,
+
+	TP_PROTO(struct inode *inode, struct page *page, unsigned int nrpage),
+
+	TP_ARGS(inode, page, nrpage),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t,	start)
+		__field(unsigned int,	nrpage)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->start	= page->index;
+		__entry->nrpage	= nrpage;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, start = %lu nrpage = %u",
+		show_dev_ino(__entry),
+		(unsigned long)__entry->start,
+		__entry->nrpage)
+);
+
 TRACE_EVENT(f2fs_submit_page_mbio,
 
 	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
-- 
1.7.9.5


