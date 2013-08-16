Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3HPWli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:41:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3HPWla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Ewan D. Milne" <emilne@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 022/133] [SCSI] sd: fix crash when UA received on DIF enabled device
Date: Fri, 16 Aug 2013 15:32:44 -0700
Message-Id: <1376692475-28413-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/sd.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f5fcf65..a1dcdc3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -828,10 +828,17 @@ static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 
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
@@ -1722,21 +1729,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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
1.8.1.2

