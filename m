Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaENLzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:55:21 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:46359 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaENLzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:55:18 -0400
Subject: [PATCH v1.2 17/16] arcmsr: fixed calling scsi_scan_host after all
 initialization done
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 May 2014 19:55:09 +0800
Message-ID: <1400068509.6957.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

This is a new patch after patch v1.1 series.

Fixed calling scsi_scan_host until all initialization are done.
And fixed error path free allocated resource.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-08 17:45:34.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-14 18:29:30.000000000 +0800
@@ -112,6 +112,7 @@ static void arcmsr_hbaD_message_isr(stru
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
+static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock *);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
 					  int queue_depth, int reason)
 {
@@ -778,12 +779,11 @@ static int arcmsr_probe(struct pci_dev *
 	}
 	error = scsi_add_host(host, &pdev->dev);
 	if(error){
-		goto RAID_controller_stop;
+		goto free_ccb_pool;
 	}
 	if (arcmsr_request_irq(pdev, acb) == ARC_FAILURE)
 		goto scsi_host_remove;
 	arcmsr_iop_init(acb);
-    	scsi_scan_host(host);
 	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
 	atomic_set(&acb->rq_map_token, 16);
 	atomic_set(&acb->ante_token_value, 16);
@@ -795,13 +795,17 @@ static int arcmsr_probe(struct pci_dev *
 	add_timer(&acb->eternal_timer);
 	if(arcmsr_alloc_sysfs_attr(acb))
 		goto out_free_sysfs;
+    	scsi_scan_host(host);
 	return 0;
 out_free_sysfs:
-scsi_host_remove:
-	scsi_remove_host(host);
-RAID_controller_stop:
+	del_timer_sync(&acb->eternal_timer);
+ 	flush_work(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
+	arcmsr_free_irq(pdev, acb);
+scsi_host_remove:
+	scsi_remove_host(host);
+free_ccb_pool:
 	arcmsr_free_ccb_pool(acb);
 free_hbb_mu:
 	arcmsr_free_mu(acb);


