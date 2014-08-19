Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaHSH2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:28:47 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32768 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaHSH2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:28:46 -0400
Subject: [PATCH v3 17/17] arcmsr: modify calling scsi_scan_host after all
 initialization done
From: Ching Huang <ching2048@areca.com.tw>
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Aug 2014 15:28:36 +0800
Message-ID: <1408433316.4748.76.camel@Centos6.3-64>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Modify calling scsi_scan_host until all initialization done.
And fix error path of free allocation resource.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:38:46.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 17:43:04.000000000 +0800
@@ -112,6 +112,7 @@ static void arcmsr_hbaD_message_isr(stru
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
+static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock *);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
 					  int queue_depth, int reason)
 {
@@ -730,12 +731,11 @@ static int arcmsr_probe(struct pci_dev *
 	}
 	error = scsi_add_host(host, &pdev->dev);
 	if(error){
-		goto RAID_controller_stop;
+		goto free_ccb_pool;
 	}
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto scsi_host_remove;
 	arcmsr_iop_init(acb);
-    	scsi_scan_host(host);
 	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
 	atomic_set(&acb->rq_map_token, 16);
 	atomic_set(&acb->ante_token_value, 16);
@@ -747,13 +747,17 @@ static int arcmsr_probe(struct pci_dev *
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


