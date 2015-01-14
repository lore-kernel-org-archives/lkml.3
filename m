Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbbANIVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:21:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbbANH3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:29:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Hauke <mardnh@gmx.de>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.18 087/150] USB: qcserial: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem
Date: Tue, 13 Jan 2015 23:22:38 -0800
Message-Id: <20150114072059.810226330@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Hauke <mardnh@gmx.de>

commit e7181d005e84b15fe3121a8d22840adc3395d496 upstream.

Added new device layout "DEVICE_HWI" and also added the USB VID/PID for the
HP lt4112 LTE/HSPA+ Gobi 4G Modem (Huawei me906e)

Signed-off-by: Martin Hauke <mardnh@gmx.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -27,12 +27,15 @@ enum qcserial_layouts {
 	QCSERIAL_G2K = 0,	/* Gobi 2000 */
 	QCSERIAL_G1K = 1,	/* Gobi 1000 */
 	QCSERIAL_SWI = 2,	/* Sierra Wireless */
+	QCSERIAL_HWI = 3,	/* Huawei */
 };
 
 #define DEVICE_G1K(v, p) \
 	USB_DEVICE(v, p), .driver_info = QCSERIAL_G1K
 #define DEVICE_SWI(v, p) \
 	USB_DEVICE(v, p), .driver_info = QCSERIAL_SWI
+#define DEVICE_HWI(v, p) \
+	USB_DEVICE(v, p), .driver_info = QCSERIAL_HWI
 
 static const struct usb_device_id id_table[] = {
 	/* Gobi 1000 devices */
@@ -157,6 +160,9 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x413c, 0x81a8)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a9)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card */
 
+	/* Huawei devices */
+	{DEVICE_HWI(0x03f0, 0x581d)},	/* HP lt4112 LTE/HSPA+ Gobi 4G Modem (Huawei me906e) */
+
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -283,6 +289,33 @@ static int qcprobe(struct usb_serial *se
 			break;
 		default:
 			/* don't claim any unsupported interface */
+			altsetting = -1;
+			break;
+		}
+		break;
+	case QCSERIAL_HWI:
+		/*
+		 * Huawei layout:
+		 * 0: AT-capable modem port
+		 * 1: DM/DIAG
+		 * 2: AT-capable modem port
+		 * 3: CCID-compatible PCSC interface
+		 * 4: QMI/net
+		 * 5: NMEA
+		 */
+		switch (ifnum) {
+		case 0:
+		case 2:
+			dev_dbg(dev, "Modem port found\n");
+			break;
+		case 1:
+			dev_dbg(dev, "DM/DIAG interface found\n");
+			break;
+		case 5:
+			dev_dbg(dev, "NMEA GPS interface found\n");
+			break;
+		default:
+			/* don't claim any unsupported interface */
 			altsetting = -1;
 			break;
 		}


