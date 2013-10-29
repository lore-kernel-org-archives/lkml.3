Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3J2SRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:17:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59501 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3J2SJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 78/81] usb-storage: add quirk for mandatory READ_CAPACITY_16
Date: Tue, 29 Oct 2013 11:04:39 -0700
Message-Id: <1383069882-11437-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/storage/scsiglue.c     | 5 ++++-
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 include/linux/usb_usual.h          | 4 +++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 92f35ab..8dd5d1b 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -211,8 +211,11 @@ static int slave_configure(struct scsi_device *sdev)
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
index f828c76..df8c74b 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1917,6 +1917,13 @@ UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x0201,
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
index bf99cd0..6303568 100644
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
-- 
1.8.1.2

