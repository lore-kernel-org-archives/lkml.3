Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3BCBg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:36:29 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45987 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3BCBV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:26 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/62] block/loop: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:09 -0800
Message-Id: <1359854463-2538-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/block/loop.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 3b9c32b..dafbfdb 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1624,30 +1624,17 @@ static int loop_add(struct loop_device **l, int i)
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
-	} else if (i == -1) {
-		int m;
-
-		/* get next free nr */
-		err = idr_get_new(&loop_index_idr, lo, &m);
-		if (err >= 0)
-			i = m;
 	} else {
-		err = -EINVAL;
+		err = idr_alloc(&loop_index_idr, lo, 0, 0, GFP_KERNEL);
 	}
 	if (err < 0)
 		goto out_free_dev;
+	i = err;
 
 	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!lo->lo_queue)
-- 
1.8.1

