Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3JXHJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:09:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20802 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3JXHJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:09:21 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-05-5268c7a03493
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: remove redundant set_page_dirty from
 write_compacted_summaries
Date: Thu, 24 Oct 2013 15:08:28 +0800
Message-id: <000201ced087$f5433d70$dfc9b850$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7QhA4Q4tVVIka5T+SK0LuwbGg6vQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd0FxzOCDG5/ZLe4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujCVr/7IV
	7OOu+N93krmBcQ5nFyMnh4SAicSFA2dYIWwxiQv31rOB2EICixgl+p87Qdg/GCU+ffYAsdkE
	VCSWd/xnArFFBKQlZn2ax9LFyMXBLDCbUaLnyzNGkISwQJLElq2tYENZBFQlHrfsAWvgFbCU
	2HPqMZQtKPFj8j2gZg6gZnWJKVNyQcLMAtoST95dgLpHQWLH2deMICUiAnoSF+5qQZSIS2w8
	cotlAqPALCSDZiEMmoVk0CwkHQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfzM+kd
	jKsaLA4xCnAwKvHwanxIDxJiTSwrrsw9xCjBwawkwutZkREkxJuSWFmVWpQfX1Sak1p8iFGa
	g0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgVFUZsI1Psktwi7uWSpZOSyCWqcP9cfNtjkf
	sa5vxWXd3Q+q3DdsFeRZLrI00/mswmf2ef8s9v7N26OWvTrHl/PgtsICV8ldn5pVnl9kkju9
	cAlXB5deK3fqpwPvr8wzlS5y8d3W+ujCqYALD49Ff/+pb5LbPH2ixAL/ulOaSzRtv6/4N3Pi
	2TglluKMREMt5qLiRACuGcNUYgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, set_page_dirty is called every time after writting one summary info into compacted summary page,
To avoid redundant set_page_dirty, we only call set_page_dirty before release page.

Signed-off-by: Yu Chao <chao2.yu@samsung.com>
---
 fs/f2fs/segment.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3b20359..bdd53d0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1128,8 +1128,6 @@ static void write_compacted_summaries(struct f2fs_sb_info *sbi, block_t blkaddr)
 						SUM_JOURNAL_SIZE);
 	written_size += SUM_JOURNAL_SIZE;
 
-	set_page_dirty(page);
-
 	/* Step 3: write summary entries */
 	for (i = CURSEG_HOT_DATA; i <= CURSEG_COLD_DATA; i++) {
 		unsigned short blkoff;
@@ -1148,18 +1146,20 @@ static void write_compacted_summaries(struct f2fs_sb_info *sbi, block_t blkaddr)
 			summary = (struct f2fs_summary *)(kaddr + written_size);
 			*summary = seg_i->sum_blk->entries[j];
 			written_size += SUMMARY_SIZE;
-			set_page_dirty(page);
 
 			if (written_size + SUMMARY_SIZE <= PAGE_CACHE_SIZE -
 							SUM_FOOTER_SIZE)
 				continue;
 
+			set_page_dirty(page);
 			f2fs_put_page(page, 1);
 			page = NULL;
 		}
 	}
-	if (page)
+	if (page) {
+		set_page_dirty(page);
 		f2fs_put_page(page, 1);
+	}
 }
 
 static void write_normal_summaries(struct f2fs_sb_info *sbi,
-- 
1.7.9.5

