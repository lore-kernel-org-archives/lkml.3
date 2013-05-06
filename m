Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab3EFWtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:49:11 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63491 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab3EFWrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:47:10 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 27/33] blk-throttle: make blk_throtl_bio() ready for hierarchy
Date: Mon,  6 May 2013 15:46:06 -0700
Message-Id: <1367880372-28312-28-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, blk_throtl_bio() issues the passed in bio directly if it's
within limits of its associated tg (throtl_grp).  This behavior
becomes incorrect with hierarchy support as the bio should be
accounted to and throttled by the ancestor throtl_grps too.

This patch makes the direct issue path of blk_throtl_bio() to loop
until it reaches the top-level service_queue or gets throttled.  If
the former, the bio can be issued directly; otherwise, it gets queued
at the first layer it was above limits.

As tg->parent_sq is always the top-level service queue currently, this
patch in itself doesn't make any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8c6e133..52321a4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1239,12 +1239,16 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 
 	sq = &tg->service_queue;
 
-	/* throtl is FIFO - if other bios are already queued, should queue */
-	if (sq->nr_queued[rw])
-		goto queue_bio;
+	while (true) {
+		/* throtl is FIFO - if bios are already queued, should queue */
+		if (sq->nr_queued[rw])
+			break;
 
-	/* Bio is with-in rate limit of group */
-	if (tg_may_dispatch(tg, bio, NULL)) {
+		/* if above limits, break to queue */
+		if (!tg_may_dispatch(tg, bio, NULL))
+			break;
+
+		/* within limits, let's charge and dispatch directly */
 		throtl_charge_bio(tg, bio);
 
 		/*
@@ -1259,10 +1263,19 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 		 * So keep on trimming slice even if bio is not queued.
 		 */
 		throtl_trim_slice(tg, rw);
-		goto out_unlock;
+
+		/*
+		 * @bio passed through this layer without being throttled.
+		 * Climb up the ladder.  If we''re already at the top, it
+		 * can be executed directly.
+		 */
+		sq = sq->parent_sq;
+		tg = sq_to_tg(sq);
+		if (!tg)
+			goto out_unlock;
 	}
 
-queue_bio:
+	/* out-of-limit, queue to @tg */
 	throtl_log(sq, "[%c] bio. bdisp=%llu sz=%u bps=%llu iodisp=%u iops=%u queued=%d/%d",
 		   rw == READ ? 'R' : 'W',
 		   tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
-- 
1.8.1.4

