Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaF3L47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:56:59 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52059 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753910AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 091/181] usb: qcserial: define and use Sierra Wireless layout
Date: Mon, 30 Jun 2014 13:51:52 +0200
Message-Id: <e70e18f0292d9ef006eee8cfdeb64e7bae890b8d.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8bc7a069402e1a443ded8088a8be0dc8aa1c2c9b upstream.

All the "non Gobi" Qualcomm based devices handled by this
driver share a common standard Sierra Wireless specific
layout. Adding code specifically for this layout allow
us to reduce the number of match entries per device from
three to one.

This change will result in a penalty wrt stable backports,
but simplifies new Sierra device addtitions in the long
term.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/qcserial.c | 98 +++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 217e29ccde52..91e7bb515398 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -26,10 +26,13 @@
 enum qcserial_layouts {
 	QCSERIAL_G2K = 0,	/* Gobi 2000 */
 	QCSERIAL_G1K = 1,	/* Gobi 1000 */
+	QCSERIAL_SWI = 2,	/* Sierra Wireless */
 };
 
 #define DEVICE_G1K(v, p) \
 	USB_DEVICE(v, p), .driver_info = QCSERIAL_G1K
+#define DEVICE_SWI(v, p) \
+	USB_DEVICE(v, p), .driver_info = QCSERIAL_SWI
 
 static const struct usb_device_id id_table[] = {
 	/* Gobi 1000 devices */
@@ -132,46 +135,20 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x12D1, 0x14F1)},	/* Sony Gobi 3000 Composite */
 	{USB_DEVICE(0x0AF0, 0x8120)},	/* Option GTM681W */
 
-	/* non Gobi Qualcomm serial devices */
-	{USB_DEVICE_INTERFACE_NUMBER(0x0f3d, 0x68a2, 0)},	/* Sierra Wireless MC7700 Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x0f3d, 0x68a2, 2)},	/* Sierra Wireless MC7700 NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x0f3d, 0x68a2, 3)},	/* Sierra Wireless MC7700 Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x114f, 0x68a2, 0)},	/* Sierra Wireless MC7750 Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x114f, 0x68a2, 2)},	/* Sierra Wireless MC7750 NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x114f, 0x68a2, 3)},	/* Sierra Wireless MC7750 Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 0)},	/* Sierra Wireless MC7710 Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 2)},	/* Sierra Wireless MC7710 NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 3)},	/* Sierra Wireless MC7710 Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 0)},	/* Sierra Wireless MC73xx Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 2)},	/* Sierra Wireless MC73xx NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 3)},	/* Sierra Wireless MC73xx Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 0)},	/* Sierra Wireless EM7700 Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 2)},	/* Sierra Wireless EM7700 NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 3)},	/* Sierra Wireless EM7700 Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901f, 0)},	/* Sierra Wireless EM7355 Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901f, 2)},	/* Sierra Wireless EM7355 NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901f, 3)},	/* Sierra Wireless EM7355 Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9041, 0)},	/* Sierra Wireless MC7305/MC7355 Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9041, 2)},	/* Sierra Wireless MC7305/MC7355 NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9041, 3)},	/* Sierra Wireless MC7305/MC7355 Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 0)},	/* Netgear AirCard 340U Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 2)},	/* Netgear AirCard 340U NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 3)},	/* Netgear AirCard 340U Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 0)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 3)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a3, 0)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a3, 2)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a3, 3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a4, 0)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a4, 2)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a4, 3)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a8, 0)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a8, 2)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a8, 3)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card Modem */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a9, 0)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card Device Management */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a9, 2)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card NMEA */
-	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a9, 3)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card Modem */
+	/* non-Gobi Sierra Wireless devices */
+	{DEVICE_SWI(0x0f3d, 0x68a2)},	/* Sierra Wireless MC7700 */
+	{DEVICE_SWI(0x114f, 0x68a2)},	/* Sierra Wireless MC7750 */
+	{DEVICE_SWI(0x1199, 0x68a2)},	/* Sierra Wireless MC7710 */
+	{DEVICE_SWI(0x1199, 0x68c0)},	/* Sierra Wireless MC73xx */
+	{DEVICE_SWI(0x1199, 0x901c)},	/* Sierra Wireless EM7700 */
+	{DEVICE_SWI(0x1199, 0x901f)},	/* Sierra Wireless EM7355 */
+	{DEVICE_SWI(0x1199, 0x9041)},	/* Sierra Wireless MC7305/MC7355 */
+	{DEVICE_SWI(0x1199, 0x9051)},	/* Netgear AirCard 340U */
+	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
+	{DEVICE_SWI(0x413c, 0x81a3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
+	{DEVICE_SWI(0x413c, 0x81a4)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
+	{DEVICE_SWI(0x413c, 0x81a8)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card */
+	{DEVICE_SWI(0x413c, 0x81a9)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card */
 
 	{ }				/* Terminating entry */
 };
@@ -220,11 +197,6 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 		goto done;
 	}
 
-	if (nintf < 3 || nintf > 4) {
-		dev_err(dev, "unknown number of interfaces: %d\n", nintf);
-		goto done;
-	}
-
 	/* default to enabling interface */
 	altsetting = 0;
 
@@ -242,6 +214,12 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 		 * 2: AT-capable modem port
 		 * 3: QMI/net
 		 */
+		if (nintf < 3 || nintf > 4) {
+			dev_err(dev, "unknown number of interfaces: %d\n", nintf);
+			altsetting = -1;
+			goto done;
+		}
+
 		if (ifnum == 0) {
 			dev_dbg(dev, "Gobi 1K DM/DIAG interface found\n");
 			altsetting = 1;
@@ -258,6 +236,12 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 		 * 2: AT-capable modem port
 		 * 3: NMEA
 		 */
+		if (nintf < 3 || nintf > 4) {
+			dev_err(dev, "unknown number of interfaces: %d\n", nintf);
+			altsetting = -1;
+			goto done;
+		}
+
 		switch (ifnum) {
 		case 0:
 			/* Don't claim the QMI/net interface */
@@ -279,6 +263,30 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 			break;
 		}
 		break;
+	case QCSERIAL_SWI:
+		/*
+		 * Sierra Wireless layout:
+		 * 0: DM/DIAG (use libqcdm from ModemManager for communication)
+		 * 2: NMEA
+		 * 3: AT-capable modem port
+		 * 8: QMI/net
+		 */
+		switch (ifnum) {
+		case 0:
+			dev_dbg(dev, "DM/DIAG interface found\n");
+			break;
+		case 2:
+			dev_dbg(dev, "NMEA GPS interface found\n");
+			break;
+		case 3:
+			dev_dbg(dev, "Modem port found\n");
+			break;
+		default:
+			/* don't claim any unsupported interface */
+			altsetting = -1;
+			break;
+		}
+		break;
 	default:
 		dev_err(dev, "unsupported device layout type: %lu\n",
 			id->driver_info);
-- 
2.0.0

