Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881AbaKLCTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:19:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966003AbaKLBvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:51:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.10 038/123] block: fix alignment_offset math that assumes io_min is a power-of-2
Date: Wed, 12 Nov 2014 10:16:44 +0900
Message-Id: <20141112011720.747397646@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-settings.c   |    4 ++--
 include/linux/blkdev.h |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -553,7 +553,7 @@ int blk_stack_limits(struct queue_limits
 		bottom = max(b->physical_block_size, b->io_min) + alignment;
 
 		/* Verify that top and bottom intervals line up */
-		if (max(top, bottom) & (min(top, bottom) - 1)) {
+		if (max(top, bottom) % min(top, bottom)) {
 			t->misaligned = 1;
 			ret = -1;
 		}
@@ -594,7 +594,7 @@ int blk_stack_limits(struct queue_limits
 
 	/* Find lowest common alignment_offset */
 	t->alignment_offset = lcm(t->alignment_offset, alignment)
-		& (max(t->physical_block_size, t->io_min) - 1);
+		% max(t->physical_block_size, t->io_min);
 
 	/* Verify that new alignment_offset is on a logical block boundary */
 	if (t->alignment_offset & (t->logical_block_size - 1)) {
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1187,10 +1187,9 @@ static inline int queue_alignment_offset
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


