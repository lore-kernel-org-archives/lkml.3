Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab3FMJAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:00:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:44392 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469Ab3FMJAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:00:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,857,1363158000"; 
   d="scan'208";a="349193766"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 1/3] f2fs: remove unnecessary parameter "offset" from __add_sum_entry()
Date: Thu, 13 Jun 2013 16:59:27 +0800
Message-Id: <1371113969-946-2-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371113969-946-1-git-send-email-haicheng.li@linux.intel.com>
References: <1371113969-946-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get the value directly from pointer "curseg".

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/segment.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index be668ff..77f31c0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -255,11 +255,11 @@ void invalidate_blocks(struct f2fs_sb_info *sbi, block_t addr)
  * This function should be resided under the curseg_mutex lock
  */
 static void __add_sum_entry(struct f2fs_sb_info *sbi, int type,
-		struct f2fs_summary *sum, unsigned short offset)
+					struct f2fs_summary *sum)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
 	void *addr = curseg->sum_blk;
-	addr += offset * sizeof(struct f2fs_summary);
+	addr += curseg->next_blkoff * sizeof(struct f2fs_summary);
 	memcpy(addr, sum, sizeof(struct f2fs_summary));
 	return;
 }
@@ -845,7 +845,7 @@ static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
 	 * because, this function updates a summary entry in the
 	 * current summary block.
 	 */
-	__add_sum_entry(sbi, type, sum, curseg->next_blkoff);
+	__add_sum_entry(sbi, type, sum);
 
 	mutex_lock(&sit_i->sentry_lock);
 	__refresh_next_blkoff(sbi, curseg);
@@ -946,7 +946,7 @@ void recover_data_page(struct f2fs_sb_info *sbi,
 
 	curseg->next_blkoff = GET_SEGOFF_FROM_SEG0(sbi, new_blkaddr) &
 					(sbi->blocks_per_seg - 1);
-	__add_sum_entry(sbi, type, sum, curseg->next_blkoff);
+	__add_sum_entry(sbi, type, sum);
 
 	refresh_sit_entry(sbi, old_blkaddr, new_blkaddr);
 
@@ -983,7 +983,7 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 	}
 	curseg->next_blkoff = GET_SEGOFF_FROM_SEG0(sbi, new_blkaddr) &
 					(sbi->blocks_per_seg - 1);
-	__add_sum_entry(sbi, type, sum, curseg->next_blkoff);
+	__add_sum_entry(sbi, type, sum);
 
 	/* change the current log to the next block addr in advance */
 	if (next_segno != segno) {
-- 
1.7.9.5

