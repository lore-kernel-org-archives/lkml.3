Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbbALTKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:10:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbbALSFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Hauke <mardnh@gmx.de>, Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 031/216] USB: qcserial: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem
Date: Mon, 12 Jan 2015 18:02:28 +0000
Message-Id: <1421085933-32536-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Hauke <mardnh@gmx.de>

commit e7181d005e84b15fe3121a8d22840adc3395d496 upstream.

Added new device layout "DEVICE_HWI" and also added the USB VID/PID for the
HP lt4112 LTE/HSPA+ Gobi 4G Modem (Huawei me906e)

Signed-off-by: Martin Hauke <mardnh@gmx.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/qcserial.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index b2aa003bf411..cb3e14780a7e 100644
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
@@ -157,6 +160,9 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x413c, 0x81a8)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a9)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card */
 
+	/* Huawei devices */
+	{DEVICE_HWI(0x03f0, 0x581d)},	/* HP lt4112 LTE/HSPA+ Gobi 4G Modem (Huawei me906e) */
+
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -287,6 +293,33 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 			break;
 		}
 		break;
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
+			altsetting = -1;
+			break;
+		}
+		break;
 	default:
 		dev_err(dev, "unsupported device layout type: %lu\n",
 			id->driver_info);
-- 
2.1.4

