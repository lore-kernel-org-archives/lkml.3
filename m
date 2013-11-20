Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3KTIl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:41:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21772 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTIl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:41:56 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-af-528c75d3a4bd
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 2/2] f2fs: adds a tracepoint for f2fs_submit_read_bio
Date: Wed, 20 Nov 2013 16:41:17 +0800
Message-id: <001f01cee5cc$5d297450$177c5cf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7lytGxwzvwEvaWSpKasT4BJCeI/Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd3LpT1BBj/b+S2u7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4+HnuWwF
	d3kqvt1vZm5g3MTVxcjJISFgInGpdRsThC0mceHeerYuRi4OIYHpjBIfNu6Ecn4wSrxatYYN
	pIpNQEViecd/sA4RAUWJDe83sIMUMQvMYJQ4PPcfaxcjO4ewQIDEOhuQEhYBVYnT2zpZQWxe
	AUuJF70vmCBsQYkfk++xgNjMAhoS/Ys2sEHY8hKb17xlhjhIQWLH2deMEKv0JI7smsMOUSMu
	sfHILZYJjAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKSf
	Se1gXNlgcYhRgINRiYdXYkF3kBBrYllxZe4hRgkOZiUR3hWFPUFCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGOvd3IOeL/906p6P9pYtM8vd2+4JVBTN
	Ub+5vjPa+5Scp7Kg9Ju47TY9LJmqixVvc5pXyTQJGX41EAw5PNkuL1DwXf0dweLof4cM183Z
	HlsdXGXmNOPQJqn7WoFzbnl5Lrp+IsLx08ms+388U2q4Y13/zQwQa+HsatDndbTwbFEsyjp8
	OqpeiaU4I9FQi7moOBEA6M2sKWUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_submit_read_bio.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              |    2 ++
 include/trace/events/f2fs.h |   27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 0ca93be..c9e9d79 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -407,6 +407,8 @@ void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
 	if (!io->bio)
 		return;
 
+	trace_f2fs_submit_read_bio(sbi->sb, rw, io->bio);
+
 	mutex_lock(&io->io_mutex);
 	if (io->bio) {
 		submit_bio(rw, io->bio);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 571f39a..ac970e3 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -453,6 +453,33 @@ TRACE_EVENT_CONDITION(f2fs_readpage,
 		show_bio_type(__entry->type))
 );
 
+TRACE_EVENT(f2fs_submit_read_bio,
+
+	TP_PROTO(struct super_block *sb, int rw, struct bio *bio),
+
+	TP_ARGS(sb, rw, bio),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	rw)
+		__field(sector_t,	sector)
+		__field(unsigned int,	size)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= sb->s_dev;
+		__entry->rw		= rw;
+		__entry->sector		= bio->bi_sector;
+		__entry->size		= bio->bi_size;
+	),
+
+	TP_printk("dev = (%d,%d), bio_type = %s, sector = %lld, size = %u",
+		show_dev(__entry),
+		show_bio_type(__entry->rw),
+		(unsigned long long)__entry->sector,
+		__entry->size)
+);
+
 TRACE_EVENT(f2fs_submit_read_page,
 
 	TP_PROTO(struct page *page, block_t blk_addr, int rw),
-- 
1.7.9.5


