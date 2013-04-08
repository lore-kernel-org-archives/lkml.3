Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936508Ab3DHKTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:19:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935523Ab3DHJve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 025/102] xen-blkback: fix dispatch_rw_block_io() error path
Date: Mon,  8 Apr 2013 10:49:40 +0100
Message-Id: <1365414657-29191-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 0e5e098ac22dae38f957e951b70d3cf73beff0f7 upstream.

Commit 7708992 ("xen/blkback: Seperate the bio allocation and the bio
submission") consolidated the pendcnt updates to just a single write,
neglecting the fact that the error path relied on it getting set to 1
up front (such that the decrement in __end_block_io_op() would actually
drop the count to zero, triggering the necessary cleanup actions).

Also remove a misleading and a stale (after said commit) comment.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/xen-blkback/blkback.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index c85d91a..4fd1dea 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -743,13 +743,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		bio->bi_end_io  = end_block_io_op;
 	}
 
-	/*
-	 * We set it one so that the last submit_bio does not have to call
-	 * atomic_inc.
-	 */
 	atomic_set(&pending_req->pendcnt, nbio);
-
-	/* Get a reference count for the disk queue and start sending I/O */
 	blk_start_plug(&plug);
 
 	for (i = 0; i < nbio; i++)
@@ -777,6 +771,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
  fail_put_bio:
 	for (i = 0; i < nbio; i++)
 		bio_put(biolist[i]);
+	atomic_set(&pending_req->pendcnt, 1);
 	__end_block_io_op(pending_req, -EINVAL);
 	msleep(1); /* back off a bit */
 	return -EIO;
-- 
1.8.1.2

