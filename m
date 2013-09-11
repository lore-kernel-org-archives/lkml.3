Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3IKXMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:12:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15055 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3IKXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:10:44 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=WZ_8_-oCCh8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kqGNItpMEbgA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=ayC55rCoAAAA:8 a=RvlEQHu-AAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=E6k37eg1NvgA:10 a=jEp0ucaQiEUA:10 a=7DSvI1NPTFQA:10 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042905.967076674@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [082/251] sd: fix crash when UA received on DIF enabled device
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0082-sd-fix-crash-when-UA-received-on-DIF-enabled-device.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Ewan D. Milne" <emilne@redhat.com>

[ Upstream commit 085b513f97d8d799d28491239be4b451bcd8c2c5 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/sd.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a2ecd324..e157a93 100644
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
1.7.10.4


