Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbaIZK0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:26:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbaIZJqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 066/142] scsi: add a blacklist flag which enables VPD page inquiries
Date: Fri, 26 Sep 2014 11:44:37 +0200
Message-Id: <29f9575fde21ea15388f74038d384ad55ecf1baa.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Martin K. Petersen" <martin.petersen@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c1d40a527e885a40bb9ea6c46a1b1145d42b66a0 upstream.

Despite supporting modern SCSI features some storage devices continue to
claim conformance to an older version of the SPC spec. This is done for
compatibility with legacy operating systems.

Linux by default will not attempt to read VPD pages on devices that
claim SPC-2 or older. Introduce a blacklist flag that can be used to
trigger VPD page inquiries on devices that are known to support them.

Reported-by: KY Srinivasan <kys@microsoft.com>
Tested-by: KY Srinivasan <kys@microsoft.com>
Reviewed-by: KY Srinivasan <kys@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/scsi_scan.c    | 4 +++-
 drivers/scsi/sd.c           | 5 +++++
 include/scsi/scsi_device.h  | 1 +
 include/scsi/scsi_devinfo.h | 1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index bfad3586d914..17b08db224e8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -950,7 +950,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
-	if (*bflags & BLIST_SKIP_VPD_PAGES)
+	if (*bflags & BLIST_TRY_VPD_PAGES)
+		sdev->try_vpd_pages = 1;
+	else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
 	transport_configure_device(&sdev->sdev_gendev);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dbc024bd4adf..69d2a7060fde 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2667,6 +2667,11 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 
 static int sd_try_extended_inquiry(struct scsi_device *sdp)
 {
+	/* Attempt VPD inquiry if the device blacklist explicitly calls
+	 * for it.
+	 */
+	if (sdp->try_vpd_pages)
+		return 1;
 	/*
 	 * Although VPD inquiries can go to SCSI-2 type devices,
 	 * some USB ones crash on receiving them, and the pages
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b4f1effc9216..409fafb63f63 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -149,6 +149,7 @@ struct scsi_device {
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
+	unsigned try_vpd_pages:1;	/* attempt to read VPD pages */
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 8670c04e199e..1fdd6fc5492b 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -34,4 +34,5 @@
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
 #define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256 LUNs
 					     for sequential scan */
+#define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #endif
-- 
2.1.0

