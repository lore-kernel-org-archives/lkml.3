Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbaIOUaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:30:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaIOThF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        KY Srinivasan <kys@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 039/114] scsi: add a blacklist flag which enables VPD page inquiries
Date: Mon, 15 Sep 2014 12:25:39 -0700
Message-Id: <20140915192642.667743291@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_scan.c    |    4 +++-
 drivers/scsi/sd.c           |    5 +++++
 include/scsi/scsi_device.h  |    1 +
 include/scsi/scsi_devinfo.h |    1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -950,7 +950,9 @@ static int scsi_add_lun(struct scsi_devi
 
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
-	if (*bflags & BLIST_SKIP_VPD_PAGES)
+	if (*bflags & BLIST_TRY_VPD_PAGES)
+		sdev->try_vpd_pages = 1;
+	else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
 	transport_configure_device(&sdev->sdev_gendev);
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2686,6 +2686,11 @@ static void sd_read_write_same(struct sc
 
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
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -34,4 +34,5 @@
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
 #define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256 LUNs
 					     for sequential scan */
+#define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #endif


