Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbaIZKY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:24:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbaIZJqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Janusz Dziemidowicz <rraptorr@nails.eu.org>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 067/142] scsi: do not issue SCSI RSOC command to Promise Vtrak E610f
Date: Fri, 26 Sep 2014 11:44:38 +0200
Message-Id: <3ebf51b399b298a8f012f711ad514123d00581c5.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Janusz Dziemidowicz <rraptorr@nails.eu.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 drivers/scsi/scsi_scan.c    | 6 ++++++
 include/scsi/scsi_devinfo.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index f969aca0b54e..49014a143c6a 100644
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
index 17b08db224e8..054ec2c412a4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -922,6 +922,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
index 1fdd6fc5492b..183eaab7c380 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -35,4 +35,6 @@
 #define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256 LUNs
 					     for sequential scan */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
+#define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
+
 #endif
-- 
2.1.0

