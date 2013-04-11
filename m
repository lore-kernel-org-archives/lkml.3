Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422745Ab3DKVCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:02:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11236 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935756Ab3DKUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:18 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=yqUjVqmuiwIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0h8FTeKJrcQA:10 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=n9GBPR9yFnkA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202601.690043517@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 095/171 ] xen-blkback: fix dispatch_rw_block_io() error path
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0095-xen-blkback-fix-dispatch_rw_block_io-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

[ Upstream commit 0e5e098ac22dae38f957e951b70d3cf73beff0f7 ]

Commit 7708992 ("xen/blkback: Seperate the bio allocation and the bio
submission") consolidated the pendcnt updates to just a single write,
neglecting the fact that the error path relied on it getting set to 1
up front (such that the decrement in __end_block_io_op() would actually
drop the count to zero, triggering the necessary cleanup actions).

Also remove a misleading and a stale (after said commit) comment.

CC: stable@vger.kernel.org
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/block/xen-blkback/blkback.c |    7 +------
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
1.7.10.4


