Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaLaNXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:23:23 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:41681 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaLaNXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:23:19 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 5/5] block: loop: don't handle REQ_FUA explicitly
Date: Wed, 31 Dec 2014 13:23:00 +0000
Message-Id: <1420032180-30256-6-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420032180-30256-1-git-send-email-ming.lei@canonical.com>
References: <1420032180-30256-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block core handles REQ_FUA by its flush state machine, so
won't do it in loop explicitly.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 018af27..185a86d 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -459,23 +459,15 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 
 	if (rq->cmd_flags & REQ_WRITE) {
-
 		if (rq->cmd_flags & REQ_FLUSH)
 			ret = lo_req_flush(lo, rq);
-
-		if (rq->cmd_flags & REQ_DISCARD) {
+		else if (rq->cmd_flags & REQ_DISCARD)
 			ret = lo_discard(lo, rq, pos);
-			goto out;
-		}
-
-		ret = lo_send(lo, rq, pos);
-
-		if ((rq->cmd_flags & REQ_FUA) && !ret)
-			ret = lo_req_flush(lo, rq);
+		else
+			ret = lo_send(lo, rq, pos);
 	} else
 		ret = lo_receive(lo, rq, lo->lo_blocksize, pos);
 
-out:
 	return ret;
 }
 
-- 
1.7.9.5

