Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaIOU3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:29:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbaIOThF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Janusz Dziemidowicz <rraptorr@nails.eu.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 040/114] scsi: do not issue SCSI RSOC command to Promise Vtrak E610f
Date: Mon, 15 Sep 2014 12:25:40 -0700
Message-Id: <20140915192642.699290685@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_devinfo.c |    1 +
 drivers/scsi/scsi_scan.c    |    6 ++++++
 include/scsi/scsi_devinfo.h |    2 ++
 3 files changed, 9 insertions(+)

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
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -922,6 +922,12 @@ static int scsi_add_lun(struct scsi_devi
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
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -35,4 +35,6 @@
 #define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256 LUNs
 					     for sequential scan */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
+#define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
+
 #endif


