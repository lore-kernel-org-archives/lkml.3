Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894AbaJDAfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:35:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaJCVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Knibbs <markk@clara.co.uk>
Subject: [PATCH 3.16 138/357] USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters
Date: Fri,  3 Oct 2014 14:28:44 -0700
Message-Id: <20141003212937.618994608@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark <markk@clara.co.uk>

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

---
 drivers/usb/storage/unusual_devs.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1125,6 +1125,18 @@ UNUSUAL_DEV(  0x0851, 0x1543, 0x0200, 0x
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
@@ -1964,6 +1976,14 @@ UNUSUAL_DEV(  0x152d, 0x2329, 0x0100, 0x
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


