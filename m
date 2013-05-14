Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3ENKVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:21:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:52051 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab3ENKVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:21:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,669,1363158000"; 
   d="scan'208";a="336915459"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH] f2fs: remove unecessary variable and code
Date: Tue, 14 May 2013 18:20:28 +0800
Message-Id: <1368526828-17494-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code cleanup without behavior changed.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/segment.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d8e84e4..3a0d027 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -126,17 +126,16 @@ void locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno)
 static void set_prefree_as_free_segments(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
-	unsigned int segno, offset = 0;
+	unsigned int segno = -1;
 	unsigned int total_segs = TOTAL_SEGS(sbi);
 
 	mutex_lock(&dirty_i->seglist_lock);
 	while (1) {
 		segno = find_next_bit(dirty_i->dirty_segmap[PRE], total_segs,
-				offset);
+				segno + 1);
 		if (segno >= total_segs)
 			break;
 		__set_test_and_free(sbi, segno);
-		offset = segno + 1;
 	}
 	mutex_unlock(&dirty_i->seglist_lock);
 }
@@ -144,17 +143,16 @@ static void set_prefree_as_free_segments(struct f2fs_sb_info *sbi)
 void clear_prefree_segments(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
-	unsigned int segno, offset = 0;
+	unsigned int segno = -1;
 	unsigned int total_segs = TOTAL_SEGS(sbi);
 
 	mutex_lock(&dirty_i->seglist_lock);
 	while (1) {
 		segno = find_next_bit(dirty_i->dirty_segmap[PRE], total_segs,
-				offset);
+				segno + 1);
 		if (segno >= total_segs)
 			break;
 
-		offset = segno + 1;
 		if (test_and_clear_bit(segno, dirty_i->dirty_segmap[PRE]))
 			dirty_i->nr_dirty[PRE]--;
 
@@ -364,11 +362,11 @@ next:
 static int is_next_segment_free(struct f2fs_sb_info *sbi, int type)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
-	unsigned int segno = curseg->segno;
+	unsigned int segno = curseg->segno + 1;
 	struct free_segmap_info *free_i = FREE_I(sbi);
 
-	if (segno + 1 < TOTAL_SEGS(sbi) && (segno + 1) % sbi->segs_per_sec)
-		return !test_bit(segno + 1, free_i->free_segmap);
+	if (segno < TOTAL_SEGS(sbi) && segno % sbi->segs_per_sec)
+		return !test_bit(segno, free_i->free_segmap);
 	return 0;
 }
 
@@ -495,7 +493,7 @@ static void new_curseg(struct f2fs_sb_info *sbi, int type, bool new_sec)
 	int dir = ALLOC_LEFT;
 
 	write_sum_page(sbi, curseg->sum_blk,
-				GET_SUM_BLOCK(sbi, curseg->segno));
+				GET_SUM_BLOCK(sbi, segno));
 	if (type == CURSEG_WARM_DATA || type == CURSEG_COLD_DATA)
 		dir = ALLOC_RIGHT;
 
-- 
1.7.9.5

