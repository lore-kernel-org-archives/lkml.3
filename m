Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbbA0XcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:32:09 -0500
Received: from mail.kernel.org ([198.145.29.136]:53655 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758990AbbA0XcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:32:07 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5/5] f2fs: introduce a batched trim
Date: Tue, 27 Jan 2015 15:31:43 -0800
Message-Id: <1422401503-4769-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
References: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a batched trimming feature, which submits split discard
commands.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h    |  1 +
 fs/f2fs/segment.c | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c0b83d6..ec4d16b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -104,6 +104,7 @@ enum {
 	CP_DISCARD,
 };
 
+#define BATCHED_TRIM_SEGMENTS	10
 struct cp_control {
 	int reason;
 	__u64 trim_start;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 31c4e57..6c9c784 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1066,14 +1066,19 @@ int f2fs_trim_fs(struct f2fs_sb_info *sbi, struct fstrim_range *range)
 	end_segno = (end >= MAX_BLKADDR(sbi)) ? MAIN_SEGS(sbi) - 1 :
 						GET_SEGNO(sbi, end);
 	cpc.reason = CP_DISCARD;
-	cpc.trim_start = start_segno;
-	cpc.trim_end = end_segno;
 	cpc.trim_minlen = range->minlen >> sbi->log_blocksize;
 
 	/* do checkpoint to issue discard commands safely */
-	mutex_lock(&sbi->gc_mutex);
-	write_checkpoint(sbi, &cpc);
-	mutex_unlock(&sbi->gc_mutex);
+	for (; start_segno <= end_segno;
+				start_segno += BATCHED_TRIM_SEGMENTS + 1) {
+		cpc.trim_start = start_segno;
+		cpc.trim_end = min_t(unsigned int,
+				start_segno + BATCHED_TRIM_SEGMENTS, end_segno);
+
+		mutex_lock(&sbi->gc_mutex);
+		write_checkpoint(sbi, &cpc);
+		mutex_unlock(&sbi->gc_mutex);
+	}
 out:
 	range->len = cpc.trimmed << sbi->log_blocksize;
 	return 0;
-- 
2.1.1

