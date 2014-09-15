Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbaIOXOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:14:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50575 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaIOWLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 092/187] scsi: add a blacklist flag which enables VPD page inquiries
Date: Mon, 15 Sep 2014 15:08:22 -0700
Message-Id: <1410818997-9432-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/scsi_scan.c    | 4 +++-
 drivers/scsi/sd.c           | 5 +++++
 include/scsi/scsi_device.h  | 1 +
 include/scsi/scsi_devinfo.h | 1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..08e6151 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -926,7 +926,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
-	if (*bflags & BLIST_SKIP_VPD_PAGES)
+	if (*bflags & BLIST_TRY_VPD_PAGES)
+		sdev->try_vpd_pages = 1;
+	else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
 	transport_configure_device(&sdev->sdev_gendev);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8ee2f56..2735c50 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2691,6 +2691,11 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 
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
index 8e6b70f..9695cf5 100644
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
index 447d2d7..913c624 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -32,4 +32,5 @@
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
+#define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #endif
-- 
1.9.1

