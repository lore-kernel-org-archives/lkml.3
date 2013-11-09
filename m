Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab3KIGu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:50:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab3KIGuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 3.10 01/74] usb-storage: add quirk for mandatory READ_CAPACITY_16
Date: Fri,  8 Nov 2013 22:51:06 -0800
Message-Id: <20131109065113.604224881@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 32c37fc30c52508711ea6a108cfd5855b8a07176 upstream.

Some USB drive enclosures do not correctly report an
overflow condition if they hold a drive with a capacity
over 2TB and are confronted with a READ_CAPACITY_10.
They answer with their capacity modulo 2TB.
The generic layer cannot cope with that. It must be told
to use READ_CAPACITY_16 from the beginning.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/scsiglue.c     |    5 ++++-
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 include/linux/usb_usual.h          |    4 +++-
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -211,8 +211,11 @@ static int slave_configure(struct scsi_d
 		/*
 		 * Many devices do not respond properly to READ_CAPACITY_16.
 		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
+		 * However some USB 3.0 drive enclosures return capacity
+		 * modulo 2TB. Those must use READ_CAPACITY_16
 		 */
-		sdev->try_rc_10_first = 1;
+		if (!(us->fflags & US_FL_NEEDS_CAP16))
+			sdev->try_rc_10_first = 1;
 
 		/* assume SPC3 or latter devices support sense size > 18 */
 		if (sdev->scsi_level > SCSI_SPC_2)
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1925,6 +1925,13 @@ UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* Reported by Oliver Neukum <oneukum@suse.com> */
+UNUSUAL_DEV(  0x174c, 0x55aa, 0x0100, 0x0100,
+		"ASMedia",
+		"AS2105",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NEEDS_CAP16),
+
 /* Reported by Jesse Feddema <jdfeddema@gmail.com> */
 UNUSUAL_DEV(  0x177f, 0x0400, 0x0000, 0x0000,
 		"Yarvik",
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -66,7 +66,9 @@
 	US_FLAG(INITIAL_READ10,	0x00100000)			\
 		/* Initial READ(10) (and others) must be retried */	\
 	US_FLAG(WRITE_CACHE,	0x00200000)			\
-		/* Write Cache status is not available */
+		/* Write Cache status is not available */	\
+	US_FLAG(NEEDS_CAP16,	0x00400000)
+		/* cannot handle READ_CAPACITY_10 */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };


