Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaHDCLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 22:11:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10916 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaHDCK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 22:10:59 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f1-53deebb1b424
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/2] f2fs: use for_each_set_bit to simplify the code
Date: Mon, 04 Aug 2014 10:10:07 +0800
Message-id: <001e01cfaf89$54164640$fc42d2c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+vh4Dv8ZT0xFSJQWa769Azw8KUYw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQd2Nr+8FG/T26Fpc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	/5ftZS7oEal4fvccUwPjDoEuRk4OCQETicNP77JB2GISF+6tB7K5OIQEpjNK/PnwnxHC+cEo
	ce73G2aQKjYBFYnlHf+ZQGwRAS+JSftPsIDYzAKZEveaZgDVcHAIC/hJTL0IZrIIqEr8vs4L
	UsErYCnRdOwKG4QtKPFj8j2oTi2J9TuPM0HY8hKb17xlhrhHQWLH2deMEJv0JB7MvABVIy6x
	8cgtlgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4tJ9J
	7WBc2WBxiFGAg1GJh1dh791gIdbEsuLK3EOMEhzMSiK8iS/vBQvxpiRWVqUW5ccXleakFh9i
	lOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgFCoOTL/tVHbyj6zhzDfcpk8TUgMDAx5P
	8alPW5p8tlf6jMtcU/lNj/c0ReQc+5jl1FYcubtf0TrH1Zj/wYt9Xjd4v8hd3vJ9Tabw+aU1
	+ycyVpw5Jmy8VFzll8+/eQfzNmrcNRHplt0b6NLVbaLuzamtz3DPaELToX1PD77ue/SdWeZq
	w/lPSizFGYmGWsxFxYkAQJtWV2kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses for_each_set_bit to simplify some codes in f2fs.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/gc.c      |  7 ++-----
 fs/f2fs/segment.c | 13 ++++---------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b90dbe5..d7947d9 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -186,7 +186,6 @@ static unsigned int get_max_cost(struct f2fs_sb_info *sbi,
 static unsigned int check_bg_victims(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
-	unsigned int hint = 0;
 	unsigned int secno;
 
 	/*
@@ -194,11 +193,9 @@ static unsigned int check_bg_victims(struct f2fs_sb_info *sbi)
 	 * selected by background GC before.
 	 * Those segments guarantee they have small valid blocks.
 	 */
-next:
-	secno = find_next_bit(dirty_i->victim_secmap, TOTAL_SECS(sbi), hint++);
-	if (secno < TOTAL_SECS(sbi)) {
+	for_each_set_bit(secno, dirty_i->victim_secmap, TOTAL_SECS(sbi)) {
 		if (sec_usage_check(sbi, secno))
-			goto next;
+			continue;
 		clear_bit(secno, dirty_i->victim_secmap);
 		return secno * sbi->segs_per_sec;
 	}
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c3b76d0..0dfeeba 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -439,17 +439,12 @@ static void add_discard_addrs(struct f2fs_sb_info *sbi,
 static void set_prefree_as_free_segments(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
-	unsigned int segno = -1;
+	unsigned int segno;
 	unsigned int total_segs = TOTAL_SEGS(sbi);
 
 	mutex_lock(&dirty_i->seglist_lock);
-	while (1) {
-		segno = find_next_bit(dirty_i->dirty_segmap[PRE], total_segs,
-				segno + 1);
-		if (segno >= total_segs)
-			break;
+	for_each_set_bit(segno, dirty_i->dirty_segmap[PRE], total_segs)
 		__set_test_and_free(sbi, segno);
-	}
 	mutex_unlock(&dirty_i->seglist_lock);
 }
 
@@ -1531,7 +1526,7 @@ void flush_sit_entries(struct f2fs_sb_info *sbi)
 	struct page *page = NULL;
 	struct f2fs_sit_block *raw_sit = NULL;
 	unsigned int start = 0, end = 0;
-	unsigned int segno = -1;
+	unsigned int segno;
 	bool flushed;
 
 	mutex_lock(&curseg->curseg_mutex);
@@ -1543,7 +1538,7 @@ void flush_sit_entries(struct f2fs_sb_info *sbi)
 	 */
 	flushed = flush_sits_in_journal(sbi);
 
-	while ((segno = find_next_bit(bitmap, nsegs, segno + 1)) < nsegs) {
+	for_each_set_bit(segno, bitmap, nsegs) {
 		struct seg_entry *se = get_seg_entry(sbi, segno);
 		int sit_offset, offset;
 
-- 
2.0.0.421.g786a89d


