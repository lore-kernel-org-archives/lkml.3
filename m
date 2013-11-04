Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3KDNAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:00:31 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:45423 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3KDNAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:00:30 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] block: Do not call sector_div() with a 64-bit divisor
Date: Mon,  4 Nov 2013 14:00:06 +0100
Message-Id: <1383570006-4605-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_div() (called by sector_div() if CONFIG_LBDAF=y) is meant for divisions
of 64-bit number by 32-bit numbers.  Passing 64-bit divisor types caused
issues in the past on 32-bit platforms, cfr. commit
ea077b1b96e073eac5c3c5590529e964767fc5f7 ("m68k: Truncate base in
do_div()").

As queue_limits.max_discard_sectors and .discard_granularity are unsigned
int, max_discard_sectors and granularity should be unsigned int.
As bdev_discard_alignment() returns int, alignment should be int.
Now 2 calls to sector_div() can be replaced by 32-bit arithmetic:
  - The 64-bit modulo operation can become a 32-bit modulo operation,
  - The 64-bit division and multiplication can be replaced by a 32-bit
    modulo operation and a subtraction.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Please review!

 block/blk-lib.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d6f50d572565..9b5b561cb928 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -43,8 +43,8 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
-	sector_t max_discard_sectors;
-	sector_t granularity, alignment;
+	unsigned int max_discard_sectors, granularity;
+	int alignment;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
@@ -58,16 +58,14 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
-	alignment = bdev_discard_alignment(bdev) >> 9;
-	alignment = sector_div(alignment, granularity);
+	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
 
 	/*
 	 * Ensure that max_discard_sectors is of the proper
 	 * granularity, so that requests stay aligned after a split.
 	 */
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-	sector_div(max_discard_sectors, granularity);
-	max_discard_sectors *= granularity;
+	max_discard_sectors -= max_discard_sectors % granularity;
 	if (unlikely(!max_discard_sectors)) {
 		/* Avoid infinite loop below. Being cautious never hurts. */
 		return -EOPNOTSUPP;
-- 
1.7.9.5

