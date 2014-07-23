Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919AbaGWW6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:58:36 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62745 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306AbaGWW6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:58:35 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 6/9] block: loop: don't handle REQ_FUA explicitly
Date: Thu, 24 Jul 2014 06:55:27 +0800
Message-Id: <1406156130-15575-7-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
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
index 96f945e..96a8913 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -459,23 +459,15 @@ static int do_bio_filebacked(struct loop_device *lo, struct request *rq)
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

