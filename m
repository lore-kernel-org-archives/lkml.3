Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaEZPWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:22:36 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57009 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaEZPWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:22:34 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: benoit.taine@lip6.fr, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/18] Drivers: scsi: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:17 +0200
Message-Id: <1401117687-28911-9-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 +---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6fd7d40..080d5f5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7603,7 +7603,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		return;
 	}
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
+	fw_event->event_data = kmemdup(mpi_reply->EventData, sz, GFP_ATOMIC);
 	if (!fw_event->event_data) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -7611,8 +7611,6 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		return;
 	}
 
-	memcpy(fw_event->event_data, mpi_reply->EventData,
-	    sz);
 	fw_event->ioc = ioc;
 	fw_event->VF_ID = mpi_reply->VF_ID;
 	fw_event->VP_ID = mpi_reply->VP_ID;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..40c15cf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7205,7 +7205,7 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		return 1;
 	}
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
+	fw_event->event_data = kmemdup(mpi_reply->EventData, sz, GFP_ATOMIC);
 	if (!fw_event->event_data) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -7213,7 +7213,6 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		return 1;
 	}
 
-	memcpy(fw_event->event_data, mpi_reply->EventData, sz);
 	fw_event->ioc = ioc;
 	fw_event->VF_ID = mpi_reply->VF_ID;
 	fw_event->VP_ID = mpi_reply->VP_ID;

