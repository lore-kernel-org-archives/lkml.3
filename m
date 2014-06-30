Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaF3MAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:00:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52057 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 090/181] usb: qcserial: refactor device layout selection
Date: Mon, 30 Jun 2014 13:51:51 +0200
Message-Id: <00648395832ebfee24964f232ee2a123e7eb8f83.1404128998.git.jslaby@suse.cz>
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

commit d712ca91db6d5463ca5a9b06eb6ba937c59a15fa upstream.

Preparing for more supported standard device layouts. Keeping
the matching macros unchanged to avoid breaking stable
backporting of new device additions.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/qcserial.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index e282155dd4a1..217e29ccde52 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -22,8 +22,14 @@
 #define DRIVER_AUTHOR "Qualcomm Inc"
 #define DRIVER_DESC "Qualcomm USB Serial driver"
 
+/* standard device layouts supported by this driver */
+enum qcserial_layouts {
+	QCSERIAL_G2K = 0,	/* Gobi 2000 */
+	QCSERIAL_G1K = 1,	/* Gobi 1000 */
+};
+
 #define DEVICE_G1K(v, p) \
-	USB_DEVICE(v, p), .driver_info = 1
+	USB_DEVICE(v, p), .driver_info = QCSERIAL_G1K
 
 static const struct usb_device_id id_table[] = {
 	/* Gobi 1000 devices */
@@ -178,11 +184,8 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 	int retval = -ENODEV;
 	__u8 nintf;
 	__u8 ifnum;
-	bool is_gobi1k = id->driver_info ? true : false;
 	int altsetting = -1;
 
-	dev_dbg(dev, "Is Gobi 1000 = %d\n", is_gobi1k);
-
 	nintf = serial->dev->actconfig->desc.bNumInterfaces;
 	dev_dbg(dev, "Num Interfaces = %d\n", nintf);
 	ifnum = intf->desc.bInterfaceNumber;
@@ -230,7 +233,8 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 	 * gets handled by other drivers.
 	 */
 
-	if (is_gobi1k) {
+	switch (id->driver_info) {
+	case QCSERIAL_G1K:
 		/*
 		 * Gobi 1K USB layout:
 		 * 0: DM/DIAG (use libqcdm from ModemManager for communication)
@@ -245,7 +249,8 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 			dev_dbg(dev, "Modem port found\n");
 		else
 			altsetting = -1;
-	} else {
+		break;
+	case QCSERIAL_G2K:
 		/*
 		 * Gobi 2K+ USB layout:
 		 * 0: QMI/net
@@ -273,6 +278,11 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 			dev_dbg(dev, "Gobi 2K+ NMEA GPS interface found\n");
 			break;
 		}
+		break;
+	default:
+		dev_err(dev, "unsupported device layout type: %lu\n",
+			id->driver_info);
+		break;
 	}
 
 done:
-- 
2.0.0

