Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaJHW0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbaJHW0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:26:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: martin.petersen@oracle.com, dm-devel@redhat.com
Subject: [PATCH v2] block: fix alignment_offset math that assumes io_min is a power-of-2
Date: Wed,  8 Oct 2014 18:26:13 -0400
Message-Id: <1412807173-15541-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <to=1412805952-15316-1-git-send-email-snitzer@redhat.com>
References: <to=1412805952-15316-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The math in both blk_stack_limits() and queue_limit_alignment_offset()
assume that a block device's io_min (aka minimum_io_size) is always a
power-of-2.  Fix the math such that it works for non-power-of-2 io_min.

This issue (of alignment_offset != 0) became apparent when testing
dm-thinp with a thinp blocksize that matches a RAID6 stripesize of
1280K.  Commit fdfb4c8c1 ("dm thin: set minimum_io_size to pool's data
block size") unlocked the potential for alignment_offset != 0 due to
the dm-thin-pool's io_min possibly being a non-power-of-2.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 block/blk-settings.c   | 4 ++--
 include/linux/blkdev.h | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

v2: fix bug in queue_limit_alignment_offset's math conversion (missed trailing << 9)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index f1a1795..aa02247 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -574,7 +574,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		bottom = max(b->physical_block_size, b->io_min) + alignment;
 
 		/* Verify that top and bottom intervals line up */
-		if (max(top, bottom) & (min(top, bottom) - 1)) {
+		if (max(top, bottom) % min(top, bottom)) {
 			t->misaligned = 1;
 			ret = -1;
 		}
@@ -619,7 +619,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	/* Find lowest common alignment_offset */
 	t->alignment_offset = lcm(t->alignment_offset, alignment)
-		& (max(t->physical_block_size, t->io_min) - 1);
+		% max(t->physical_block_size, t->io_min);
 
 	/* Verify that new alignment_offset is on a logical block boundary */
 	if (t->alignment_offset & (t->logical_block_size - 1)) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 038b40f..5546392 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1279,10 +1279,9 @@ static inline int queue_alignment_offset(struct request_queue *q)
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
1.8.3.1

