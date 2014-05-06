Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572AbaEFItX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:49:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38641 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934382AbaEFItV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:49:21 -0400
X-AuditID: cbfee61b-b7f766d00000646c-0e-5368a20f8348
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/6] f2fs: add a tracepoint for
 f2fs_write_{meta,node,data}_page
Date: Tue, 06 May 2014 16:48:26 +0800
Message-id: <004501cf6908$123c99d0$36b5cd70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9pB91OS7JTDtXAT02lTE6MmAzJtw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQV3+RRnBBjtu6Vhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH5/zq2glv8FTe2
	vmdsYLzP08XIySEhYCLx+GAPE4QtJnHh3nq2LkYuDiGB6YwSf1bsYIJwfjBKfFpwhg2kik1A
	RWJ5x3+wDhEBTYnHyzczg9jMApkS95pmgNnCAjES1+ceYQWxWQRUJabeWwIW5xWwlHjw6gIr
	hC0o8WPyPRaIXi2J9TuPM0HY8hKb17xlhrhIQWLH2deMXYwcQLv0JB53hkOUiEtsPHKLZQKj
	wCwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgO5GfSOxhXNVgc
	YhTgYFTi4T2xMj1YiDWxrLgy9xCjBAezkghvfX5GsBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
	g63WgUIC6YklqdmpqQWpRTBZJg5OqQbGEL9+Ifbfnq4axbenr5zApDp/5loR5o0tB251738e
	6rk2crFs5MTMK/9uiK+N5Vd9c7j8aeGGb+J5ywwZhN4xi6oUXQqqKbvYXSDc/k4gnd/VffnN
	HMZ9zxN74j84OCeFP/i++bu7ofOOb5dfpS8y2qN2gsfZkSewW7ZjmevjV94mCm6FHN5KLMUZ
	iYZazEXFiQDvycn9YAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_write_{meta,node,data}_page to trace when
page is writting out.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c        |    2 ++
 fs/f2fs/data.c              |    2 ++
 fs/f2fs/node.c              |    2 ++
 include/trace/events/f2fs.h |    7 +++++++
 4 files changed, 13 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index b6f6ead..7962aaf 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -160,6 +160,8 @@ static int f2fs_write_meta_page(struct page *page,
 	struct inode *inode = page->mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
+	trace_f2fs_writepage(page, META);
+
 	if (unlikely(sbi->por_doing))
 		goto redirty_out;
 	if (wbc->for_reclaim)
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ea58fb6..b997d55 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -788,6 +788,8 @@ static int f2fs_write_data_page(struct page *page,
 		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
 	};
 
+	trace_f2fs_writepage(page, DATA);
+
 	if (page->index < end_index)
 		goto write;
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 059aaf5..49bdddb 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1199,6 +1199,8 @@ static int f2fs_write_node_page(struct page *page,
 		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
 	};
 
+	trace_f2fs_writepage(page, NODE);
+
 	if (unlikely(sbi->por_doing))
 		goto redirty_out;
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 483804b..d70991e 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -751,6 +751,13 @@ DECLARE_EVENT_CLASS(f2fs__page,
 		__entry->dirty)
 );
 
+DEFINE_EVENT(f2fs__page, f2fs_writepage,
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


