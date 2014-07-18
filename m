Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169AbaGRKLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:11:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:44212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760723AbaGRKLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:11:07 -0400
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] scsi: add scsi_setup_cmnd helper
Date: Fri, 18 Jul 2014 12:13:00 +0200
Message-Id: <1405678393-11497-2-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out command setup code that will be shared with the blk-mq code path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 85cf0ef..04c3684 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1092,6 +1092,27 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
+static int scsi_setup_cmnd(struct scsi_device *sdev, struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+
+	if (!blk_rq_bytes(req))
+		cmd->sc_data_direction = DMA_NONE;
+	else if (rq_data_dir(req) == WRITE)
+		cmd->sc_data_direction = DMA_TO_DEVICE;
+	else
+		cmd->sc_data_direction = DMA_FROM_DEVICE;
+
+	switch (req->cmd_type) {
+	case REQ_TYPE_FS:
+		return scsi_setup_fs_cmnd(sdev, req);
+	case REQ_TYPE_BLOCK_PC:
+		return scsi_setup_blk_pc_cmnd(sdev, req);
+	default:
+		return BLKPREP_KILL;
+	}
+}
+
 static int
 scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 {
@@ -1195,24 +1216,7 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 		goto out;
 	}
 
-	if (!blk_rq_bytes(req))
-		cmd->sc_data_direction = DMA_NONE;
-	else if (rq_data_dir(req) == WRITE)
-		cmd->sc_data_direction = DMA_TO_DEVICE;
-	else
-		cmd->sc_data_direction = DMA_FROM_DEVICE;
-
-	switch (req->cmd_type) {
-	case REQ_TYPE_FS:
-		ret = scsi_setup_fs_cmnd(sdev, req);
-		break;
-	case REQ_TYPE_BLOCK_PC:
-		ret = scsi_setup_blk_pc_cmnd(sdev, req);
-		break;
-	default:
-		ret = BLKPREP_KILL;
-	}
-
+	ret = scsi_setup_cmnd(sdev, req);
 out:
 	return scsi_prep_return(q, req, ret);
 }
-- 
1.9.1

