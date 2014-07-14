Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaGNGgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:36:03 -0400
Received: from [207.46.163.139] ([207.46.163.139]:18692 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750892AbaGNGfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:35:51 -0400
Date: Mon, 14 Jul 2014 12:00:49 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [PATCH v2] mpt2sas: delay scsi_add_host call to work with scsi-mq
Message-ID: <20140714063049.GA16875@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130497933276983364;(f081dce6-2920-4dfc-23e8-08d07091c5e3);(f081dce6-2920-4dfc-23e8-08d07091c5e3)
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(83506001)(85852003)(106466001)(36756003)(64706001)(16796002)(105596002)(83322001)(50466002)(83072002)(21056001)(85306003)(74662001)(74502001)(19580395003)(102836001)(44976005)(20776003)(77982001)(92726001)(107046002)(26826002)(31966008)(81342001)(19580405001)(54356999)(46406003)(46102001)(95666004)(76482001)(99396002)(79102001)(4396001)(97756001)(86362001)(50986999)(80022001)(33656002)(81542001)(57986006)(77096002)(47776003)(23726002)(87936001)(229853001)(76506005)(6806004)(92566001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0701MB1018;H:COSEXCH10.lsi.com;FPR:;MLV:ovrnspm;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In _scsih_probe, delay the call to scsi_add_host until the host has been
fully set up.

Otherwise, the default .can_queue value of 1 causes scsi-mq to set the block
layer request queue size to its minimum size, resulting in awful performance.

In _scsih_probe error handling, call mpt3sas_base_detach rather than
scsi_remove_host to properly clean up in reverse order.

In _scsih_remove, call scsi_remove_host earlier to clean up in reverse order.

Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>
Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   25 ++++++++++++-------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index b4b391d..20e2ff8 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -281,7 +281,7 @@ mpt2sas_base_stop_watchdog(struct MPT2SAS_ADAPTER *ioc)
 	ioc->fault_reset_work_q = NULL;
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	if (wq) {
-		if (!cancel_delayed_work(&ioc->fault_reset_work))
+		if (!cancel_delayed_work_sync(&ioc->fault_reset_work))
 			flush_workqueue(wq);
 		destroy_workqueue(wq);
 	}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index ed8b6c1..53c4764 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2906,11 +2906,10 @@ _scsih_fw_event_cleanup_queue(struct MPT2SAS_ADAPTER *ioc)
 		return;
 
 	list_for_each_entry_safe(fw_event, next, &ioc->fw_event_list, list) {
-		if (cancel_delayed_work(&fw_event->delayed_work)) {
+		if (cancel_delayed_work_sync(&fw_event->delayed_work)) {
 			_scsih_fw_event_free(ioc, fw_event);
 			continue;
 		}
-		fw_event->cancel_pending_work = 1;
 	}
 }
 
@@ -7514,7 +7513,7 @@ _firmware_event_work(struct work_struct *work)
 	struct MPT2SAS_ADAPTER *ioc = fw_event->ioc;
 
 	/* the queue is being flushed so ignore this event */
-	if (ioc->remove_host || fw_event->cancel_pending_work ||
+	if (ioc->remove_host ||
 	    ioc->pci_error_recovery) {
 		_scsih_fw_event_free(ioc, fw_event);
 		return;
@@ -7970,9 +7969,9 @@ _scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
+	scsi_remove_host(shost);
 	mpt2sas_base_detach(ioc);
 	list_del(&ioc->list);
-	scsi_remove_host(shost);
 	scsi_host_put(shost);
 }
 
@@ -8313,13 +8312,6 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	}
 
-	if ((scsi_add_host(shost, &pdev->dev))) {
-		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
-		list_del(&ioc->list);
-		goto out_add_shost_fail;
-	}
-
 	/* register EEDP capabilities with SCSI layer */
 	if (prot_mask)
 		scsi_host_set_prot(shost, prot_mask);
@@ -8361,16 +8353,23 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	} else
 		ioc->hide_drives = 0;
+
+	if ((scsi_add_host(shost, &pdev->dev))) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out_add_shost_fail;
+	}
+
 	scsi_scan_host(shost);
 
 	return 0;
 
+ out_add_shost_fail:
+	mpt2sas_base_detach(ioc);
  out_attach_fail:
 	destroy_workqueue(ioc->firmware_event_thread);
  out_thread_fail:
 	list_del(&ioc->list);
-	scsi_remove_host(shost);
- out_add_shost_fail:
 	scsi_host_put(shost);
 	return -ENODEV;
 }
-- 
1.7.1

