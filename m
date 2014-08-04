Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaHDQ7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:59:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56573 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "James Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Michael =?UTF-8?Q?B=C3=BCsch?=" <m@bues.ch>,
        "Matthew Dharm" <mdharm-usb@one-eyed-alien.net>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.655304265@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 18/94] usb-storage/SCSI: Add broken_fua blacklist flag
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Use sd_printk() not sd_first_printk()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sd.c                  | 5 ++++-
 drivers/usb/storage/scsiglue.c     | 4 ++++
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 include/linux/usb_usual.h          | 4 +++-
 include/scsi/scsi_device.h         | 1 +
 5 files changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2149,7 +2149,10 @@ sd_read_cache_type(struct scsi_disk *sdk
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
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -255,6 +255,10 @@ static int slave_configure(struct scsi_d
 					US_FL_SCM_MULT_TARG)) &&
 				us->protocol == USB_PR_BULK)
 			us->use_last_sector_hacks = 1;
+
+		/* A few buggy USB-ATA bridges don't understand FUA */
+		if (us->fflags & US_FL_BROKEN_FUA)
+			sdev->broken_fua = 1;
 	} else {
 
 		/* Non-disk-type devices don't need to blacklist any pages
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1916,6 +1916,13 @@ UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x
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
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -64,7 +64,9 @@
 	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
 		/* cannot handle READ_CAPACITY_16 */		\
 	US_FLAG(INITIAL_READ10,	0x00100000)			\
-		/* Initial READ(10) (and others) must be retried */
+		/* Initial READ(10) (and others) must be retried */ \
+	US_FLAG(BROKEN_FUA,	0x01000000)			\
+		/* Cannot handle FUA in WRITE or READ CDBs */	\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -151,6 +151,7 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
+	unsigned broken_fua:1;		/* Don't set FUA bit */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */

