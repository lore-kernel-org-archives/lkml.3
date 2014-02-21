Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480AbaBUNkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:40:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47041 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaBUMuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 064/121] usb-storage: enable multi-LUN scanning when needed
Date: Fri, 21 Feb 2014 12:48:08 +0000
Message-Id: <1392986945-9693-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 823d12c95c666fa7ab7dad208d735f6bc6afabdc upstream.

People sometimes create their own custom-configured kernels and forget
to enable CONFIG_SCSI_MULTI_LUN.  This causes problems when they plug
in a USB storage device (such as a card reader) with more than one
LUN.

Fortunately, we can tell fairly easily when a storage device claims to
have more than one LUN.  When that happens, this patch asks the SCSI
layer to probe all the LUNs automatically, regardless of the config
setting.

The patch also updates the Kconfig help text for usb-storage,
explaining that CONFIG_SCSI_MULTI_LUN may be necessary.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Thomas Raschbacher <lordvan@lordvan.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/Kconfig    | 4 +++-
 drivers/usb/storage/scsiglue.c | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 8470e1b..1dd0604 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -18,7 +18,9 @@ config USB_STORAGE
 
 	  This option depends on 'SCSI' support being enabled, but you
 	  probably also need 'SCSI device support: SCSI disk support'
-	  (BLK_DEV_SD) for most USB storage devices.
+	  (BLK_DEV_SD) for most USB storage devices.  Some devices also
+	  will require 'Probe all LUNs on each SCSI device'
+	  (SCSI_MULTI_LUN).
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called usb-storage.
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 5db1532..bb7bf19 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -78,6 +78,8 @@ static const char* host_info(struct Scsi_Host *host)
 
 static int slave_alloc (struct scsi_device *sdev)
 {
+	struct us_data *us = host_to_us(sdev->host);
+
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
 	 * the extra data and many devices choke if asked for more or
@@ -102,6 +104,10 @@ static int slave_alloc (struct scsi_device *sdev)
 	 */
 	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 
+	/* Tell the SCSI layer if we know there is more than one LUN */
+	if (us->protocol == USB_PR_BULK && us->max_lun > 0)
+		sdev->sdev_bflags |= BLIST_FORCELUN;
+
 	return 0;
 }
 
-- 
1.9.0

