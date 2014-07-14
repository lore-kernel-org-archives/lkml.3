Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaGNGgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:36:18 -0400
Received: from [207.46.163.139] ([207.46.163.139]:32881 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750892AbaGNGgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:36:14 -0400
Date: Mon, 14 Jul 2014 12:01:35 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [PATCH v2] mpt3sas: delay scsi_add_host call to work with scsi-mq
Message-ID: <20140714063135.GA16900@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130497933507286261;(f081dce6-2920-4dfc-23e8-08d07091c5e3);(f081dce6-2920-4dfc-23e8-08d07091c5e3)
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(81542001)(50466002)(81342001)(26826002)(102836001)(107046002)(36756003)(95666004)(23726002)(87936001)(6806004)(106466001)(54356999)(76506005)(105596002)(57986006)(92566001)(92726001)(85306003)(83072002)(85852003)(99396002)(77096002)(50986999)(97756001)(79102001)(44976005)(86362001)(47776003)(20776003)(19580405001)(83322001)(19580395003)(46406003)(31966008)(83506001)(16796002)(229853001)(21056001)(76482001)(74502001)(33656002)(74662001)(4396001)(64706001)(77982001)(80022001)(46102001)(32563001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:CO2PR0701MB1013;H:COSEXCH10.lsi.com;FPR:;MLV:ovrnspm;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
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
 drivers/scsi/mpt3sas/mpt3sas_base.c  |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   26 ++++++++++++--------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index cb5f879..b2817c7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -266,7 +266,7 @@ mpt3sas_base_stop_watchdog(struct MPT3SAS_ADAPTER *ioc)
 	ioc->fault_reset_work_q = NULL;
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	if (wq) {
-		if (!cancel_delayed_work(&ioc->fault_reset_work))
+		if (!cancel_delayed_work_sync(&ioc->fault_reset_work))
 			flush_workqueue(wq);
 		destroy_workqueue(wq);
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 21b50c1..7c830af 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2586,11 +2586,10 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
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
 
@@ -7077,7 +7076,7 @@ static void
 _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 {
 	/* the queue is being flushed so ignore this event */
-	if (ioc->remove_host || fw_event->cancel_pending_work ||
+	if (ioc->remove_host ||
 	    ioc->pci_error_recovery) {
 		_scsih_fw_event_free(ioc, fw_event);
 		return;
@@ -7482,9 +7481,9 @@ static void _scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
+	scsi_remove_host(shost);
 	mpt3sas_base_detach(ioc);
 	list_del(&ioc->list);
-	scsi_remove_host(shost);
 	scsi_host_put(shost);
 }
 
@@ -7852,13 +7851,6 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	}
 
-	if ((scsi_add_host(shost, &pdev->dev))) {
-		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-		    ioc->name, __FILE__, __LINE__, __func__);
-		list_del(&ioc->list);
-		goto out_add_shost_fail;
-	}
-
 	/* register EEDP capabilities with SCSI layer */
 	if (prot_mask > 0)
 		scsi_host_set_prot(shost, prot_mask);
@@ -7886,15 +7878,21 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		    ioc->name, __FILE__, __LINE__, __func__);
 		goto out_attach_fail;
 	}
+	if ((scsi_add_host(shost, &pdev->dev))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		list_del(&ioc->list);
+		goto out_add_shost_fail;
+	}
+
 	scsi_scan_host(shost);
 	return 0;
-
+out_add_shost_fail:
+	mpt3sas_base_detach(ioc);
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

