Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaHSHBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:01:37 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61621 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbaHSHBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:01:35 -0400
Subject: [PATCH v3 8/17] arcmsr: remove calling
 arcmsr_hbb_enable_driver_mode
From: Ching Huang <ching2048@areca.com.tw>
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Aug 2014 15:01:28 +0800
Message-ID: <1408431688.4748.47.camel@Centos6.3-64>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Remove calling arcmsr_hbb_enable_driver_mode by in-line code.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:39:06.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:39:48.000000000 +0800
@@ -833,17 +833,6 @@ static uint8_t arcmsr_abort_allcmd(struc
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
@@ -2640,7 +2629,12 @@ static int arcmsr_iop_confirm(struct Ada
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


