Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaHVUTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:19:41 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:50956 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaHVUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:19:39 -0400
Message-ID: <53F79FC3.6040907@cybernetics.com>
Date: Fri, 22 Aug 2014 15:53:39 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH][SCSI] scsi-mq: fix requests that use a separate CDB buffer
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes code such as the following with scsi-mq enabled:

    rq = blk_get_request(...);
    blk_rq_set_block_pc(rq);

    rq->cmd = my_cmd_buffer; /* separate CDB buffer */

    blk_execute_rq_nowait(...);

Code like this appears in e.g. sg_start_req() in drivers/scsi/sg.c (for
large CDBs only).  Without this patch, scsi_mq_prep_fn() will set
rq->cmd back to rq->__cmd, causing the wrong CDB to be sent to the device.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

---

For inclusion in 3.17 only.

diff -urpN linux-3.17.0-rc1-a/block/blk-core.c linux-3.17.0-rc1-b/block/blk-core.c
--- linux-3.17.0-rc1-a/block/blk-core.c	2014-08-16 12:40:26.000000000 -0400
+++ linux-3.17.0-rc1-b/block/blk-core.c	2014-08-22 14:03:33.000000000 -0400
@@ -1252,7 +1252,6 @@ void blk_rq_set_block_pc(struct request 
 	rq->__sector = (sector_t) -1;
 	rq->bio = rq->biotail = NULL;
 	memset(rq->__cmd, 0, sizeof(rq->__cmd));
-	rq->cmd = rq->__cmd;
 }
 EXPORT_SYMBOL(blk_rq_set_block_pc);
 
diff -urpN linux-3.17.0-rc1-a/block/blk-mq.c linux-3.17.0-rc1-b/block/blk-mq.c
--- linux-3.17.0-rc1-a/block/blk-mq.c	2014-08-16 12:40:26.000000000 -0400
+++ linux-3.17.0-rc1-b/block/blk-mq.c	2014-08-22 14:02:32.000000000 -0400
@@ -172,6 +172,8 @@ static void blk_mq_rq_ctx_init(struct re
 	/* tag was already set */
 	rq->errors = 0;
 
+	rq->cmd = rq->__cmd;
+
 	rq->extra_len = 0;
 	rq->sense_len = 0;
 	rq->resid_len = 0;
diff -urpN linux-3.17.0-rc1-a/drivers/scsi/scsi_lib.c linux-3.17.0-rc1-b/drivers/scsi/scsi_lib.c
--- linux-3.17.0-rc1-a/drivers/scsi/scsi_lib.c	2014-08-16 12:40:26.000000000 -0400
+++ linux-3.17.0-rc1-b/drivers/scsi/scsi_lib.c	2014-08-22 14:02:32.000000000 -0400
@@ -1808,7 +1808,6 @@ static int scsi_mq_prep_fn(struct reques
 
 	cmd->tag = req->tag;
 
-	req->cmd = req->__cmd;
 	cmd->cmnd = req->cmd;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 

