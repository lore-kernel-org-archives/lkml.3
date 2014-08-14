Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaHNPxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:53:03 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48340 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbaHNPxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:53:00 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 8/9] block: loop: don't handle REQ_FUA explicitly
Date: Thu, 14 Aug 2014 23:50:39 +0800
Message-Id: <1408031441-31156-9-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
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
index 3836dcc..0ce51ee 100644
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

