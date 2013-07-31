Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab3GaNZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:25:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46913 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759699Ab3GaNZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James Bottomley" <JBottomley@Parallels.com>,
        "Ewan D. Milne" <emilne@redhat.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.148708244@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [68/84] [SCSI] sd: fix crash when UA received on DIF enabled device
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sd.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -641,10 +641,17 @@ static int scsi_setup_flush_cmnd(struct
 
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
@@ -1452,21 +1459,6 @@ static int sd_done(struct scsi_cmnd *SCp
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
 

