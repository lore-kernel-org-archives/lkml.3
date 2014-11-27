Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaK0Isu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:42286 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbaK0Iso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:44 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark <markk@clara.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 53/91] USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters
Date: Thu, 27 Nov 2014 16:42:36 +0800
Message-Id: <1417077794-9299-53-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark <markk@clara.co.uk>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit c80b4495c61636edc58fe1ce300f09f24db28e10 upstream.

This patch adds quirks for Entrega Technologies (later Xircom PortGear) USB-
SCSI converters. They use Shuttle Technology EUSB-01/EUSB-S1 chips. The
US_FL_SCM_MULT_TARG quirk is needed to allow multiple devices on the SCSI
chain to be accessed. Without it only the (single) device with SCSI ID 0
can be used.

The standalone converter sold by Entrega had model number U1-SC25. Xircom
acquired Entrega and re-branded the product line PortGear. The PortGear USB
to SCSI Converter (model PGSCSI) is internally identical to the Entrega
product, but later models may use a different USB ID. The Entrega-branded
units have USB ID 1645:0007, as does my Xircom PGSCSI, but the Windows and
Macintosh drivers also support 085A:0028.

Entrega also sold the "Mac USB Dock", which provides two USB ports, a Mac
(8-pin mini-DIN) serial port and a SCSI port. It appears to the computer as
a four-port hub, USB-serial, and USB-SCSI converters. The USB-SCSI part may
have initially used the same ID as the standalone U1-SC25 (1645:0007), but
later production used 085A:0026.

My Xircom PortGear PGSCSI has bcdDevice=0x0100. Units with bcdDevice=0x0133
probably also exist.

This patch adds quirks for 1645:0007, 085A:0026 and 085A:0028. The Windows
driver INF file also mentions 085A:0032 "PortStation SCSI Module", but I
couldn't find any mention of that actually existing in the wild; perhaps it
was cancelled before release?

Signed-off-by: Mark Knibbs <markk@clara.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/storage/unusual_devs.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 8642da6..a280945 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1117,6 +1117,18 @@ UNUSUAL_DEV(  0x0851, 0x1543, 0x0200, 0x0200,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NOT_LOCKABLE),
 
+UNUSUAL_DEV(  0x085a, 0x0026, 0x0100, 0x0133,
+		"Xircom",
+		"PortGear USB-SCSI (Mac USB Dock)",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
+UNUSUAL_DEV(  0x085a, 0x0028, 0x0100, 0x0133,
+		"Xircom",
+		"PortGear USB to SCSI Converter",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
 /* Submitted by Jan De Luyck <lkml@kcore.org> */
 UNUSUAL_DEV(  0x08bd, 0x1100, 0x0000, 0x0000,
 		"CITIZEN",
@@ -1937,6 +1949,14 @@ UNUSUAL_DEV(  0x152d, 0x2329, 0x0100, 0x0100,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
 
+/* Entrega Technologies U1-SC25 (later Xircom PortGear PGSCSI)
+ * and Mac USB Dock USB-SCSI */
+UNUSUAL_DEV(  0x1645, 0x0007, 0x0100, 0x0133,
+		"Entrega Technologies",
+		"USB to SCSI Converter",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
 /* Reported by Robert Schedel <r.schedel@yahoo.de>
  * Note: this is a 'super top' device like the above 14cd/6600 device */
 UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x0201,
-- 
1.9.1

