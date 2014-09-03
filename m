Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaICFDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:03:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:37821 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbaICFCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:02:44 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5/6] f2fs: handle bug cases by letting fsck.f2fs initiate
Date: Tue,  2 Sep 2014 22:02:33 -0700
Message-Id: <1409720554-72925-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1409720554-72925-1-git-send-email-jaegeuk@kernel.org>
References: <1409720554-72925-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to handle corner buggy cases for fsck.f2fs.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 46586d3..853c8f5 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -317,6 +317,10 @@ static void __locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
 		struct seg_entry *sentry = get_seg_entry(sbi, segno);
 		enum dirty_type t = sentry->type;
 
+		if (unlikely(t >= DIRTY)) {
+			f2fs_bug_on(sbi, 1);
+			return;
+		}
 		if (!test_and_set_bit(segno, dirty_i->dirty_segmap[t]))
 			dirty_i->nr_dirty[t]++;
 	}
@@ -1745,8 +1749,12 @@ static void init_dirty_segmap(struct f2fs_sb_info *sbi)
 			break;
 		offset = segno + 1;
 		valid_blocks = get_valid_blocks(sbi, segno, 0);
-		if (valid_blocks >= sbi->blocks_per_seg || !valid_blocks)
+		if (valid_blocks == sbi->blocks_per_seg || !valid_blocks)
 			continue;
+		if (valid_blocks > sbi->blocks_per_seg) {
+			f2fs_bug_on(sbi, 1);
+			continue;
+		}
 		mutex_lock(&dirty_i->seglist_lock);
 		__locate_dirty_segment(sbi, segno, DIRTY);
 		mutex_unlock(&dirty_i->seglist_lock);
-- 
1.8.5.2 (Apple Git-48)

