Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161040Ab3BGSZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:25:33 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:42584 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab3BGSZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:25:32 -0500
Date: Thu, 7 Feb 2013 10:25:26 -0800
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22.5/77] block/loop: fix error return value in loop_add()
Message-ID: <20130207182526.GP2875@htj.dyndns.org>
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

If queue or disk allocation fails, loop_add() returns @err, which is
cleared to zero by idr allocation by that point.  Reset @err to
-ENOMEM before the allocations so that we return -ENOMEM instead of 0
on alloc failure.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org
---
Hey, guys.

I was going through the conversions one more time and noticed this
existing bug.  We're returning 0 on alloc failure.  It seems the worst
which can come out of this is userland misled to believe a loop device
has been created when in fact it failed.  This can be routed
separately but it probably is easier to route with other changes.

Thanks!

 drivers/block/loop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1649,6 +1649,7 @@ static int loop_add(struct loop_device *
 	if (err < 0)
 		goto out_free_dev;
 
+	err = -ENOMEM;
 	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!lo->lo_queue)
 		goto out_free_dev;
