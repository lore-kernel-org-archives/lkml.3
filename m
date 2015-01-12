Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbbALGNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 01:13:52 -0500
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:36270 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbbALGJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 01:09:46 -0500
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
X-Google-Original-From: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        JBottomley@Parallels.com, Sathya.Prakash@avagotech.com,
        Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Subject: [PATCH v2 03/22] [SCSI] mpt2sas, mpt3sas: Fail the host reset initiated due to discovery related I/O timeouts at driver load time
Date: Mon, 12 Jan 2015 11:38:57 +0530
Message-Id: <1421042944-14988-4-git-send-email-Sreekanth.Reddy@avagotech.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1421042944-14988-1-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1421042944-14988-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a flaky disk is there in a topology then during driver load,
discovery related I/O times out; which results in SCSI error recovery
initiating host reset and then the controller won't see any disk.

In this patch, The driver would return FAILED status to the host reset
initiated due to discovery related I/O timeout if ioc->is_driver_loading
is set. This flag would be set until we exit out of scsih_scan_finished().
i.e.
During device discovery if one of the disk is flaky
(which responds to some discovery commands and doesn't respond to some)
the driver wouldn't perform host reset for discovery related I/O timeout.
Instead it would return Failure for the host reset resulting in the
flaky disk getting removed by the SCSI Mid layer,
so other disks would be added correctly.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 9 +++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index bbdea00..9803d8f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2729,9 +2729,18 @@ _scsih_host_reset(struct scsi_cmnd *scmd)
 	    ioc->name, scmd);
 	scsi_print_command(scmd);
 
+	if (ioc->is_driver_loading) {
+		printk(MPT2SAS_INFO_FMT "Blocking the host reset\n",
+							  ioc->name);
+		r = FAILED;
+		goto out;
+	}
+
 	retval = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 	    FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
+
+ out:
 	printk(MPT2SAS_INFO_FMT "host reset: %s scmd(%p)\n",
 	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d36c304..8cbd078 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2392,9 +2392,17 @@ _scsih_host_reset(struct scsi_cmnd *scmd)
 	    ioc->name, scmd);
 	scsi_print_command(scmd);
 
+	if (ioc->is_driver_loading) {
+		pr_info(MPT3SAS_FMT "Blocking the host reset\n",
+		    ioc->name);
+		r = FAILED;
+		goto out;
+	}
+
 	retval = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 	    FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
+out:
 	pr_info(MPT3SAS_FMT "host reset: %s scmd(%p)\n",
 	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
 
-- 
2.0.2

