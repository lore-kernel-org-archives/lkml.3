Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaJ0TOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:14:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaJ0TDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 087/105] block: fix alignment_offset math that assumes io_min is a power-of-2
Date: Mon, 27 Oct 2014 11:57:02 -0700
Message-Id: <1414436240-13879-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit b8839b8c55f3fdd60dc36abcda7e0266aff7985c upstream.

The math in both blk_stack_limits() and queue_limit_alignment_offset()
assume that a block device's io_min (aka minimum_io_size) is always a
power-of-2.  Fix the math such that it works for non-power-of-2 io_min.

This issue (of alignment_offset != 0) became apparent when testing
dm-thinp with a thinp blocksize that matches a RAID6 stripesize of
1280K.  Commit fdfb4c8c1 ("dm thin: set minimum_io_size to pool's data
block size") unlocked the potential for alignment_offset != 0 due to
the dm-thin-pool's io_min possibly being a non-power-of-2.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/blk-settings.c   | 4 ++--
 include/linux/blkdev.h | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 05e8267..b0b1ec6 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -553,7 +553,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		bottom = max(b->physical_block_size, b->io_min) + alignment;
 
 		/* Verify that top and bottom intervals line up */
-		if (max(top, bottom) & (min(top, bottom) - 1)) {
+		if (max(top, bottom) % min(top, bottom)) {
 			t->misaligned = 1;
 			ret = -1;
 		}
@@ -594,7 +594,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	/* Find lowest common alignment_offset */
 	t->alignment_offset = lcm(t->alignment_offset, alignment)
-		& (max(t->physical_block_size, t->io_min) - 1);
+		% max(t->physical_block_size, t->io_min);
 
 	/* Verify that new alignment_offset is on a logical block boundary */
 	if (t->alignment_offset & (t->logical_block_size - 1)) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1b135d4..75fc3a1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1238,10 +1238,9 @@ static inline int queue_alignment_offset(struct request_queue *q)
 static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t sector)
 {
 	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
-	unsigned int alignment = (sector << 9) & (granularity - 1);
+	unsigned int alignment = sector_div(sector, granularity >> 9) << 9;
 
-	return (granularity + lim->alignment_offset - alignment)
-		& (granularity - 1);
+	return (granularity + lim->alignment_offset - alignment) % granularity;
 }
 
 static inline int bdev_alignment_offset(struct block_device *bdev)
-- 
1.9.1

