Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaLXIJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:09:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27762 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaLXIJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:09:02 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-4b-549a749b093c
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: cleanup parameters for
 trace_f2fs_submit_{read_,write_,page_,page_m}bio with fio
Date: Wed, 24 Dec 2014 16:08:14 +0800
Message-id: <007001d01f50$df496bc0$9ddc4340$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAfUFbm1AZkGYr/RZaA2hEQQafobg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAd05JbNCDCbzWlzb18hk8WT9LGaL
	S4vcLS7vmsPmwOKxaVUnm8fuBZ+ZPPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugStjz/EmtoIm
	5YqmV6vYGhjvyXQxcnJICJhIdNz6zwxhi0lcuLeerYuRi0NIYBGjxLs9a1ghnB+MEm1ND8Gq
	2ARUJJZ3/GcCsUUEvCQm7T/BAmIzC3hINHZ8ZwWxhQWKJV7/vQA0iYODRUBVoueHI4jJK2Ap
	0dxTAlLBKyAo8WPyPahOLYn1O48zQdjyEpvXvIW6R0Fix9nXjBCb9CReHp8OVS8usfHILZYJ
	jAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOJyfSe9gXNVg
	cYhRgINRiYd3R8SsECHWxLLiytxDjBIczEoivKFZQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
	SvZtIUIC6YklqdmpqQWpRTBZJg5OqQbGBrlVfy9MzVz8K5TpQN3UP49uq3TqL+CTurl42RTZ
	bpF/HzN7t6yXWZG2JZ1L9pWZ5PycDEeGgisipcYRve/e6c2Tiz52THPtfBHZdzmf8oKaZ8z5
	Gc2ZGPnl/sPUQ5cvtzzJillY7fx35tIqwdzrs6Zu2rEwXCd0Tljbs3UvzV88OCS28rwmgxJL
	cUaioRZzUXEiAMNbo2xjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup parameters for trace_f2fs_submit_{read_,write_,page_,page_m}bio with fio
as one parameter.

Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              | 10 ++++------
 include/trace/events/f2fs.h | 37 ++++++++++++++++++++-----------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7953bc2..6308435 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -96,11 +96,9 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 		return;
 
 	if (is_read_io(fio->rw))
-		trace_f2fs_submit_read_bio(io->sbi->sb, fio->rw,
-							fio->type, io->bio);
+		trace_f2fs_submit_read_bio(io->sbi->sb, fio, io->bio);
 	else
-		trace_f2fs_submit_write_bio(io->sbi->sb, fio->rw,
-							fio->type, io->bio);
+		trace_f2fs_submit_write_bio(io->sbi->sb, fio, io->bio);
 
 	submit_bio(fio->rw, io->bio);
 	io->bio = NULL;
@@ -137,7 +135,7 @@ int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
 {
 	struct bio *bio;
 
-	trace_f2fs_submit_page_bio(page, fio->blk_addr, fio->rw, fio->type);
+	trace_f2fs_submit_page_bio(page, fio);
 	f2fs_trace_ios(page, fio, 0);
 
 	/* Allocate a new bio */
@@ -190,7 +188,7 @@ alloc_new:
 	f2fs_trace_ios(page, fio, 0);
 
 	up_write(&io->io_rwsem);
-	trace_f2fs_submit_page_mbio(page, fio->blk_addr, fio->rw, fio->type);
+	trace_f2fs_submit_page_mbio(page, fio);
 }
 
 /*
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 553311f..13992f3 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -650,9 +650,9 @@ TRACE_EVENT(f2fs_reserve_new_block,
 
 DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
 
-	TP_PROTO(struct page *page, block_t blkaddr, int rw, int type),
+	TP_PROTO(struct page *page, struct f2fs_io_info *fio),
 
-	TP_ARGS(page, blkaddr, rw, type),
+	TP_ARGS(page, fio),
 
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -667,9 +667,9 @@ DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
 		__entry->dev		= page->mapping->host->i_sb->s_dev;
 		__entry->ino		= page->mapping->host->i_ino;
 		__entry->index		= page->index;
-		__entry->blkaddr	= blkaddr;
-		__entry->rw		= rw;
-		__entry->type		= type;
+		__entry->blkaddr	= fio->blk_addr;
+		__entry->rw		= fio->rw;
+		__entry->type		= fio->type;
 	),
 
 	TP_printk("dev = (%d,%d), ino = %lu, page_index = 0x%lx, "
@@ -683,27 +683,28 @@ DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
 
 DEFINE_EVENT_CONDITION(f2fs__submit_page_bio, f2fs_submit_page_bio,
 
-	TP_PROTO(struct page *page, block_t blkaddr, int rw, int type),
+	TP_PROTO(struct page *page, struct f2fs_io_info *fio),
 
-	TP_ARGS(page, blkaddr, rw, type),
+	TP_ARGS(page, fio),
 
 	TP_CONDITION(page->mapping)
 );
 
 DEFINE_EVENT_CONDITION(f2fs__submit_page_bio, f2fs_submit_page_mbio,
 
-	TP_PROTO(struct page *page, block_t blkaddr, int rw, int type),
+	TP_PROTO(struct page *page, struct f2fs_io_info *fio),
 
-	TP_ARGS(page, blkaddr, rw, type),
+	TP_ARGS(page, fio),
 
 	TP_CONDITION(page->mapping)
 );
 
 DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
-	TP_PROTO(struct super_block *sb, int rw, int type, struct bio *bio),
+	TP_PROTO(struct super_block *sb, struct f2fs_io_info *fio,
+						struct bio *bio),
 
-	TP_ARGS(sb, rw, type, bio),
+	TP_ARGS(sb, fio, bio),
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
@@ -715,8 +716,8 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
-		__entry->rw		= rw;
-		__entry->type		= type;
+		__entry->rw		= fio->rw;
+		__entry->type		= fio->type;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->size		= bio->bi_iter.bi_size;
 	),
@@ -731,18 +732,20 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
 DEFINE_EVENT_CONDITION(f2fs__submit_bio, f2fs_submit_write_bio,
 
-	TP_PROTO(struct super_block *sb, int rw, int type, struct bio *bio),
+	TP_PROTO(struct super_block *sb, struct f2fs_io_info *fio,
+							struct bio *bio),
 
-	TP_ARGS(sb, rw, type, bio),
+	TP_ARGS(sb, fio, bio),
 
 	TP_CONDITION(bio)
 );
 
 DEFINE_EVENT_CONDITION(f2fs__submit_bio, f2fs_submit_read_bio,
 
-	TP_PROTO(struct super_block *sb, int rw, int type, struct bio *bio),
+	TP_PROTO(struct super_block *sb, struct f2fs_io_info *fio,
+							struct bio *bio),
 
-	TP_ARGS(sb, rw, type, bio),
+	TP_ARGS(sb, fio, bio),
 
 	TP_CONDITION(bio)
 );
-- 
2.2.1


