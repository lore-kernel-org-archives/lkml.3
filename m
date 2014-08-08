Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbaHHV2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:28:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40766 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313AbaHHUt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:49:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 043/259] usb-storage/SCSI: Add broken_fua blacklist flag
Date: Fri,  8 Aug 2014 13:37:46 -0700
Message-Id: <1407530482-4483-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit b14bf2d0c0358140041d1c1805a674376964d0e0 upstream.

Some buggy JMicron USB-ATA bridges don't know how to translate the FUA
bit in READs or WRITEs.  This patch adds an entry in unusual_devs.h
and a blacklist flag to tell the sd driver not to use FUA.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Michael Büsch <m@bues.ch>
Tested-by: Michael Büsch <m@bues.ch>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.13-stable (sd_printk; context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/sd.c                  | 5 ++++-
 drivers/usb/storage/scsiglue.c     | 4 ++++
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 include/linux/usb_usual.h          | 6 ++++--
 include/scsi/scsi_device.h         | 1 +
 5 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 410be82..8ee2f56 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2454,7 +2454,10 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 		}
 
 		sdkp->DPOFUA = (data.device_specific & 0x10) != 0;
-		if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
+		if (sdp->broken_fua) {
+			sd_printk(KERN_NOTICE, sdkp, "Disabling FUA\n");
+			sdkp->DPOFUA = 0;
+		} else if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Uses READ/WRITE(6), disabling FUA\n");
 			sdkp->DPOFUA = 0;
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 9d38ddc..866b5df 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -256,6 +256,10 @@ static int slave_configure(struct scsi_device *sdev)
 		if (us->fflags & US_FL_WRITE_CACHE)
 			sdev->wce_default_on = 1;
 
+		/* A few buggy USB-ATA bridges don't understand FUA */
+		if (us->fflags & US_FL_BROKEN_FUA)
+			sdev->broken_fua = 1;
+
 	} else {
 
 		/* Non-disk-type devices don't need to blacklist any pages
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 042c83b0..e2d0050 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1936,6 +1936,13 @@ UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x0201,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* Reported by Michael Büsch <m@bues.ch> */
+UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0114,
+		"JMicron",
+		"USB to ATA/ATAPI Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BROKEN_FUA ),
+
 /* Reported by Alexandre Oliva <oliva@lsd.ic.unicamp.br>
  * JMicron responds to USN and several other SCSI ioctls with a
  * residue that causes subsequent I/O requests to fail.  */
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 6303568..b2a709b 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -67,8 +67,10 @@
 		/* Initial READ(10) (and others) must be retried */	\
 	US_FLAG(WRITE_CACHE,	0x00200000)			\
 		/* Write Cache status is not available */	\
-	US_FLAG(NEEDS_CAP16,	0x00400000)
-		/* cannot handle READ_CAPACITY_10 */
+	US_FLAG(NEEDS_CAP16,	0x00400000)			\
+		/* cannot handle READ_CAPACITY_10 */		\
+	US_FLAG(BROKEN_FUA,	0x01000000)			\
+		/* Cannot handle FUA in WRITE or READ CDBs */	\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d65fbec..8e6b70f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -167,6 +167,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
+	unsigned broken_fua:1;		/* Don't set FUA bit */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
-- 
1.9.1

