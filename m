Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab3IHDTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56001 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685Ab3IHDSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.669115870@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [069/121] USB: ti_usb_3410_5052: fix big-endian firmware handling
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e877dd2f2581628b7119df707d4cf03d940cff49 upstream.

Fix endianess bugs in firmware handling introduced by commits cb7a7c6a
("ti_usb_3410_5052: add Multi-Tech modem support") and 05a3d905
("ti_usb_3410_5052: support alternate firmware") which made the driver
use the wrong firmware for certain devices on big-endian machines.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ti_usb_3410_5052.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1713,12 +1713,13 @@ static int ti_download_firmware(struct t
 
 	dbg("%s\n", __func__);
 	/* try ID specific firmware first, then try generic firmware */
-	sprintf(buf, "ti_usb-v%04x-p%04x.fw", dev->descriptor.idVendor,
-	    dev->descriptor.idProduct);
+	sprintf(buf, "ti_usb-v%04x-p%04x.fw",
+			le16_to_cpu(dev->descriptor.idVendor),
+			le16_to_cpu(dev->descriptor.idProduct));
 	if ((status = request_firmware(&fw_p, buf, &dev->dev)) != 0) {
 		buf[0] = '\0';
-		if (dev->descriptor.idVendor == MTS_VENDOR_ID) {
-			switch (dev->descriptor.idProduct) {
+		if (le16_to_cpu(dev->descriptor.idVendor) == MTS_VENDOR_ID) {
+			switch (le16_to_cpu(dev->descriptor.idProduct)) {
 			case MTS_CDMA_PRODUCT_ID:
 				strcpy(buf, "mts_cdma.fw");
 				break;

