Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaEEJp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:45:28 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:53083 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbaEEJp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:45:26 -0400
Subject: [PATCH v1.1 8/16] arcmsr: remove calling
 arcmsr_hbb_enable_driver_mode
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 May 2014 17:45:19 +0800
Message-ID: <1399283119.4398.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Removing call arcmsr_hbb_enable_driver_mode by in-line code.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-02 19:52:26.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-02 19:53:06.000000000 +0800
@@ -892,17 +892,6 @@ static uint8_t arcmsr_abort_allcmd(struc
 	return rtnval;
 }
 
-static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)
-{
-	struct MessageUnit_B *reg = pacb->pmuB;
-	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
-	if (!arcmsr_hbb_wait_msgint_ready(pacb)) {
-		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", pacb->host->host_no);
-		return false;
-	}
-    	return true;
-}
-
 static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
 {
 	struct scsi_cmnd *pcmd = ccb->pcmd;
@@ -2715,7 +2704,12 @@ static int arcmsr_iop_confirm(struct Ada
 			timeout \n",acb->host->host_no);
 			return 1;
 		}
-		arcmsr_hbb_enable_driver_mode(acb);
+		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
+		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+			pr_err("arcmsr%d: can't set driver mode.\n",
+				acb->host->host_no);
+			return 1;
+		}
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {


