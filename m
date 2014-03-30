Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaCaASr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:18:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36353 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbaC3XZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "James Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Matthew Dharm" <mdharm-usb@one-eyed-alien.net>,
        "Thomas Raschbacher" <lordvan@lordvan.com>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.261802742@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 080/200] usb-storage: enable multi-LUN scanning when
 needed
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - slave_alloc() already has a us_data pointer]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -19,7 +19,9 @@ config USB_STORAGE
 
 	  This option depends on 'SCSI' support being enabled, but you
 	  probably also need 'SCSI device support: SCSI disk support'
-	  (BLK_DEV_SD) for most USB storage devices.
+	  (BLK_DEV_SD) for most USB storage devices.  Some devices also
+	  will require 'Probe all LUNs on each SCSI device'
+	  (SCSI_MULTI_LUN).
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called usb-storage.
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -116,6 +116,10 @@ static int slave_alloc (struct scsi_devi
 	if (us->subclass == USB_SC_UFI)
 		sdev->sdev_target->pdt_1f_for_no_lun = 1;
 
+	/* Tell the SCSI layer if we know there is more than one LUN */
+	if (us->protocol == USB_PR_BULK && us->max_lun > 0)
+		sdev->sdev_bflags |= BLIST_FORCELUN;
+
 	return 0;
 }
 

