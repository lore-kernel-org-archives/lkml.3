Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaIOWLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:11:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaIOWLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Janusz Dziemidowicz <rraptorr@nails.eu.org>,
        Christoph Hellwig <hch@lst.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 109/187] scsi: do not issue SCSI RSOC command to Promise Vtrak E610f
Date: Mon, 15 Sep 2014 15:08:39 -0700
Message-Id: <1410818997-9432-110-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janusz Dziemidowicz <rraptorr@nails.eu.org>

commit 0213436a2cc5e4a5ca2fabfaa4d3877097f3b13f upstream.

Some devices don't like REPORT SUPPORTED OPERATION CODES and will
simply timeout causing sd_mod init to take a very very long time.
Introduce BLIST_NO_RSOC scsi scan flag, that stops RSOC from being
issued. Add it to Promise Vtrak E610f entry in scsi scan
blacklist. Fixes bug #79901 reported at
https://bugzilla.kernel.org/show_bug.cgi?id=79901

Fixes: 98dcc2946adb ("SCSI: sd: Update WRITE SAME heuristics")

Signed-off-by: Janusz Dziemidowicz <rraptorr@nails.eu.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 drivers/scsi/scsi_scan.c    | 6 ++++++
 include/scsi/scsi_devinfo.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index f969aca..49014a1 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -222,6 +222,7 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "", NULL, BLIST_SPARSELUN},
 	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
 	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 08e6151..f194e43 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -898,6 +898,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
 
+	/* some devices don't like REPORT SUPPORTED OPERATION CODES
+	 * and will simply timeout causing sd_mod init to take a very
+	 * very long time */
+	if (*bflags & BLIST_NO_RSOC)
+		sdev->no_report_opcodes = 1;
+
 	/* set the device running here so that slave configure
 	 * may do I/O */
 	ret = scsi_device_set_state(sdev, SDEV_RUNNING);
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 913c624..428b023 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -33,4 +33,6 @@
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
+#define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
+
 #endif
-- 
1.9.1

