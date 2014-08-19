Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaHSGr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:47:26 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:65405 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaHSGrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:47:24 -0400
Subject: [PATCH v3 5/17] arcmsr: bugfix - return status of abort command
From: Ching Huang <ching2048@areca.com.tw>
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Aug 2014 14:47:16 +0800
Message-ID: <1408430836.4748.32.camel@Centos6.3-64>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

This patch fixed the wrong return status of abort command.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-08 19:35:46.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-08 19:36:00.000000000 +0800
@@ -2476,7 +2476,7 @@ static int arcmsr_polling_hba_ccbdone(st
 		}
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
 		ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-		poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+		poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
 		if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
 			if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
 				printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
@@ -2540,7 +2540,7 @@ static int arcmsr_polling_hbb_ccbdone(st
 		/* check if command done with no error*/
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
 		ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-		poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+		poll_ccb_done |= (ccb == poll_ccb) ? 1 : 0;
 		if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
 			if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
 				printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
@@ -2596,7 +2596,7 @@ polling_hbc_ccb_retry:
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);/*frame must be 32 bytes aligned*/
 		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-		poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
+		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
 		/* check ifcommand done with no error*/
 		if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
 			if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
@@ -3198,6 +3198,8 @@ static int arcmsr_abort(struct scsi_cmnd
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;
 	int i = 0;
 	int rtn = FAILED;
+	uint32_t intmask_org;
+
 	printk(KERN_NOTICE
 		"arcmsr%d: abort device command of scsi id = %d lun = %d \n",
 		acb->host->host_no, cmd->device->id, (u32)cmd->device->lun);
@@ -3209,9 +3211,12 @@ static int arcmsr_abort(struct scsi_cmnd
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
@@ -3221,6 +3226,7 @@ static int arcmsr_abort(struct scsi_cmnd
 		}
 	}
 	acb->acb_flags &= ~ACB_F_ABORT;
+	arcmsr_enable_outbound_ints(acb, intmask_org);
 	return rtn;
 }
 


