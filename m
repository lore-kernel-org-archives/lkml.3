Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab3J1PCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:02:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51133 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab3J1OtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 28/64] usb-storage: add quirk for mandatory READ_CAPACITY_16
Date: Mon, 28 Oct 2013 14:47:47 +0000
Message-Id: <1382971703-17393-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/scsiglue.c     | 5 ++++-
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 include/linux/usb_usual.h          | 4 +++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 11418da..a6e4c4a 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -205,8 +205,11 @@ static int slave_configure(struct scsi_device *sdev)
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
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index ae14acd..7da68c4 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1905,6 +1905,13 @@ UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x0201,
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
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 17df360..425bc8b 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -64,7 +64,9 @@
 	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
 		/* cannot handle READ_CAPACITY_16 */		\
 	US_FLAG(INITIAL_READ10,	0x00100000)			\
-		/* Initial READ(10) (and others) must be retried */
+		/* Initial READ(10) (and others) must be retried */	\
+	US_FLAG(NEEDS_CAP16,	0x00400000)
+		/* cannot handle READ_CAPACITY_10 */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
1.8.3.2

