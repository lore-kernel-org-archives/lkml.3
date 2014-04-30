Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbaD3Ktc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:49:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37014 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbaD3Kta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:49:30 -0400
Subject: [PATCH v1.0 5/16] arcmsr: fix abort command function
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 18:49:22 +0800
Message-ID: <1398854962.6930.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Fix abort command and its relate function.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:08:08.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:09:06.000000000 +0800
@@ -2523,7 +2523,7 @@ static int arcmsr_polling_hba_ccbdone(st
 		}
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
 		ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-		poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+		poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
 		if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
 			if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
 				printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
@@ -2587,7 +2587,7 @@ static int arcmsr_polling_hbb_ccbdone(st
 		/* check if command done with no error*/
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
 		ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-		poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+		poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
 		if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
 			if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
 				printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
@@ -2643,7 +2643,7 @@ polling_hbc_ccb_retry:
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);/*frame must be 32 bytes aligned*/
 		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-		poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
+		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
 		/* check ifcommand done with no error*/
 		if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
 			if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
@@ -3245,6 +3245,8 @@ static int arcmsr_abort(struct scsi_cmnd
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;
 	int i = 0;
 	int rtn = FAILED;
+	uint32_t intmask_org;
+
 	printk(KERN_NOTICE
 		"arcmsr%d: abort device command of scsi id = %d lun = %d \n",
 		acb->host->host_no, cmd->device->id, cmd->device->lun);
@@ -3256,9 +3258,12 @@ static int arcmsr_abort(struct scsi_cmnd
 	** we need to handle it as soon as possible and exit
 	************************************************
 	*/
-	if (!atomic_read(&acb->ccboutstandingcount))
+	if (!atomic_read(&acb->ccboutstandingcount)) {
+		acb->acb_flags &= ~ACB_F_ABORT;
 		return rtn;
+	}
 
+	intmask_org = arcmsr_disable_outbound_ints(acb);
 	for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
 		struct CommandControlBlock *ccb = acb->pccb_pool[i];
 		if (ccb->startdone == ARCMSR_CCB_START && ccb->pcmd == cmd) {
@@ -3268,6 +3273,7 @@ static int arcmsr_abort(struct scsi_cmnd
 		}
 	}
 	acb->acb_flags &= ~ACB_F_ABORT;
+	arcmsr_enable_outbound_ints(acb, intmask_org);
 	return rtn;
 }
 


