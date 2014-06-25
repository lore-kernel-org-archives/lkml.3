Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbaFYQxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:53:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:59453 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626AbaFYQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:49:54 -0400
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] scsi: set ->scsi_done before calling scsi_dispatch_cmd
Date: Wed, 25 Jun 2014 18:51:51 +0200
Message-Id: <1403715121-1201-5-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403715121-1201-1-git-send-email-hch@lst.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blk-mq code path will set this to a different function, so make the
code simpler by setting it up in a legacy-request specific place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c     |   23 +----------------------
 drivers/scsi/scsi_lib.c |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index dcc43fd..d3bd6cf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -72,8 +72,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/scsi.h>
 
-static void scsi_done(struct scsi_cmnd *cmd);
-
 /*
  * Definitions and constants.
  */
@@ -696,8 +694,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	}
 
 	trace_scsi_dispatch_cmd_start(cmd);
-
-	cmd->scsi_done = scsi_done;
 	rtn = host->hostt->queuecommand(host, cmd);
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
@@ -711,28 +707,11 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 	return rtn;
  done:
-	scsi_done(cmd);
+	cmd->scsi_done(cmd);
 	return 0;
 }
 
 /**
- * scsi_done - Invoke completion on finished SCSI command.
- * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
- * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
- *
- * Description: This function is the mid-level's (SCSI Core) interrupt routine,
- * which regains ownership of the SCSI command (de facto) from a LLDD, and
- * calls blk_complete_request() for further processing.
- *
- * This function is interrupt context safe.
- */
-static void scsi_done(struct scsi_cmnd *cmd)
-{
-	trace_scsi_dispatch_cmd_done(cmd);
-	blk_complete_request(cmd->request);
-}
-
-/**
  * scsi_finish_command - cleanup and pass command back to upper layer
  * @cmd: the command
  *
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 63bf844..6989b6f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -29,6 +29,8 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 
+#include <trace/events/scsi.h>
+
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
@@ -1480,6 +1482,23 @@ static void scsi_softirq_done(struct request *rq)
 	}
 }
 
+/**
+ * scsi_done - Invoke completion on finished SCSI command.
+ * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
+ * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
+ *
+ * Description: This function is the mid-level's (SCSI Core) interrupt routine,
+ * which regains ownership of the SCSI command (de facto) from a LLDD, and
+ * calls blk_complete_request() for further processing.
+ *
+ * This function is interrupt context safe.
+ */
+static void scsi_done(struct scsi_cmnd *cmd)
+{
+	trace_scsi_dispatch_cmd_done(cmd);
+	blk_complete_request(cmd->request);
+}
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -1582,6 +1601,7 @@ static void scsi_request_fn(struct request_queue *q)
 		/*
 		 * Dispatch the command to the low-level driver.
 		 */
+		cmd->scsi_done = scsi_done;
 		rtn = scsi_dispatch_cmd(cmd);
 		if (rtn) {
 			scsi_queue_insert(cmd, rtn);
-- 
1.7.10.4

