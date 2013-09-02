Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab3IBIzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37700 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352Ab3IBIzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 17/58] USB: ti_usb_3410_5052: fix big-endian firmware handling
Date: Mon,  2 Sep 2013 09:54:02 +0100
Message-Id: <1378112083-9475-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e877dd2f2581628b7119df707d4cf03d940cff49 upstream.

Fix endianess bugs in firmware handling introduced by commits cb7a7c6a
("ti_usb_3410_5052: add Multi-Tech modem support") and 05a3d905
("ti_usb_3410_5052: support alternate firmware") which made the driver
use the wrong firmware for certain devices on big-endian machines.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ti_usb_3410_5052.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 2f02f79..ea41faa 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1641,14 +1641,15 @@ static int ti_download_firmware(struct ti_device *tdev)
 	char buf[32];
 
 	/* try ID specific firmware first, then try generic firmware */
-	sprintf(buf, "ti_usb-v%04x-p%04x.fw", dev->descriptor.idVendor,
-	    dev->descriptor.idProduct);
+	sprintf(buf, "ti_usb-v%04x-p%04x.fw",
+			le16_to_cpu(dev->descriptor.idVendor),
+			le16_to_cpu(dev->descriptor.idProduct));
 	status = request_firmware(&fw_p, buf, &dev->dev);
 
 	if (status != 0) {
 		buf[0] = '\0';
-		if (dev->descriptor.idVendor == MTS_VENDOR_ID) {
-			switch (dev->descriptor.idProduct) {
+		if (le16_to_cpu(dev->descriptor.idVendor) == MTS_VENDOR_ID) {
+			switch (le16_to_cpu(dev->descriptor.idProduct)) {
 			case MTS_CDMA_PRODUCT_ID:
 				strcpy(buf, "mts_cdma.fw");
 				break;
-- 
1.8.3.2

