Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaJJHw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:52:59 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51638 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaJJHwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:52:55 -0400
Date: Fri, 10 Oct 2014 08:52:51 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 2/3] scsi: add try_rc16 blacklist flag
Message-ID: <20141010075251.GC32028@sucs.org>
References: <20141010074901.GA32028@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010074901.GA32028@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microsoft Hyper-V virtual disks currently only claim SPC-2 compliance causing
the kernel skip checks for features such as thin provisioning even though the
virtual disk advertises them.

Add a blacklist flag that can allow such devices to quirk past READ
CAPACITY(16) guards.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 drivers/scsi/scsi_scan.c    | 3 +++
 drivers/scsi/sd.c           | 3 +++
 include/scsi/scsi_device.h  | 1 +
 include/scsi/scsi_devinfo.h | 1 +
 4 files changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ba3f1e8..d3f6267 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -962,6 +962,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
+	if (*bflags & BLIST_TRY_RC16)
+		sdev->try_rc16 = 1;
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0cb5c9f..0ccf372 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2143,6 +2143,9 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 		return 0;
 	if (sdp->scsi_level > SCSI_SPC_2)
 		return 1;
+	if (sdp->try_rc16) {
+		return 1;
+	}
 	if (scsi_device_protection(sdp))
 		return 1;
 	return 0;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 27ecee7..d6e2bd8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -155,6 +155,7 @@ struct scsi_device {
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
 	unsigned try_vpd_pages:1;	/* attempt to read VPD pages */
+	unsigned try_rc16:1;		/* attempt READ CAPACITY(16) */
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 183eaab..9431f5e 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -36,5 +36,6 @@
 					     for sequential scan */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
+#define BLIST_TRY_RC16		0x40000000 /* Attempt READ CAPACITY(16) */
 
 #endif
-- 
1.9.3

