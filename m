Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3G3Jja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:39:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53351 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab3G3Jdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Ewan D. Milne" <emilne@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 087/106] [SCSI] sd: fix crash when UA received on DIF enabled device
Date: Tue, 30 Jul 2013 10:31:46 +0100
Message-Id: <1375176725-5825-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Ewan D. Milne" <emilne@redhat.com>

commit 085b513f97d8d799d28491239be4b451bcd8c2c5 upstream.

sd_prep_fn will allocate a larger CDB for the command via mempool_alloc
for devices using DIF type 2 protection.  This CDB was being freed
in sd_done, which results in a kernel crash if the command is retried
due to a UNIT ATTENTION.  This change moves the code to free the larger
CDB into sd_unprep_fn instead, which is invoked after the request is
complete.

It is no longer necessary to call scsi_print_command separately for
this case as the ->cmnd will no longer be NULL in the normal code path.

Also removed conditional test for DIF type 2 when freeing the larger
CDB because the protection_type could have been changed via sysfs while
the command was executing.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/sd.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3977faa..8e18431 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -673,10 +673,17 @@ static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
+	struct scsi_cmnd *SCpnt = rq->special;
+
 	if (rq->cmd_flags & REQ_DISCARD) {
 		free_page((unsigned long)rq->buffer);
 		rq->buffer = NULL;
 	}
+	if (SCpnt->cmnd != rq->cmd) {
+		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+		SCpnt->cmnd = NULL;
+		SCpnt->cmd_len = 0;
+	}
 }
 
 /**
@@ -1540,21 +1547,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
 		sd_dif_complete(SCpnt, good_bytes);
 
-	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
-	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd) {
-
-		/* We have to print a failed command here as the
-		 * extended CDB gets freed before scsi_io_completion()
-		 * is called.
-		 */
-		if (result)
-			scsi_print_command(SCpnt);
-
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-	}
-
 	return good_bytes;
 }
 
-- 
1.8.3.2

