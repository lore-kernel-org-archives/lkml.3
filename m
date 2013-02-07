Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161058Ab3BGS0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:26:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52402 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161017Ab3BGS0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:26:46 -0500
Date: Thu, 7 Feb 2013 10:26:42 -0800
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 23/77] block/loop: convert to idr_alloc()
Message-ID: <20130207182642.GQ2875@htj.dyndns.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-24-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360179649-22465-24-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: block/loop: convert to idr_alloc()

Convert to the much saner new idr interface.

v2: loop_add() treats -1 @i as request for any free ID while any other
    negative trigger -EINVAL.  The v1 conversion treated any negative
    number as valid request for any free ID.  While this doesn't make
    any difference for in-kernel users, loop_add() is almost directly
    visible to userland via LOOP_CTL_ADD and this behavior change is
    userland-visible.  Restore -EINVAL on < -1.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
---
Another mistake I noticed while auditing the conversions again.  I
don't think this would actually affect anybody but no reason to change
the behavior.

Thanks.

 drivers/block/loop.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1624,30 +1624,19 @@ static int loop_add(struct loop_device *
 	if (!lo)
 		goto out;
 
-	if (!idr_pre_get(&loop_index_idr, GFP_KERNEL))
-		goto out_free_dev;
-
+	/* allocate id, if @id >= 0, we're requesting that specific id */
 	if (i >= 0) {
-		int m;
-
-		/* create specific i in the index */
-		err = idr_get_new_above(&loop_index_idr, lo, i, &m);
-		if (err >= 0 && i != m) {
-			idr_remove(&loop_index_idr, m);
+		err = idr_alloc(&loop_index_idr, lo, i, i + 1, GFP_KERNEL);
+		if (err == -ENOSPC)
 			err = -EEXIST;
-		}
 	} else if (i == -1) {
-		int m;
-
-		/* get next free nr */
-		err = idr_get_new(&loop_index_idr, lo, &m);
-		if (err >= 0)
-			i = m;
+		err = idr_alloc(&loop_index_idr, lo, 0, 0, GFP_KERNEL);
 	} else {
 		err = -EINVAL;
 	}
 	if (err < 0)
 		goto out_free_dev;
+	i = err;
 
 	err = -ENOMEM;
 	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
