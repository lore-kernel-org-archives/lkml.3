Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182AbaDJEBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:01:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934876AbaDJDWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 081/134] USB: ti_usb_3410_5052: fix big-endian firmware handling
Date: Wed,  9 Apr 2014 20:23:17 -0700
Message-Id: <20140410032310.409085074@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e877dd2f2581628b7119df707d4cf03d940cff49 upstream.

Fix endianess bugs in firmware handling introduced by commits cb7a7c6a
("ti_usb_3410_5052: add Multi-Tech modem support") and 05a3d905
("ti_usb_3410_5052: support alternate firmware") which made the driver
use the wrong firmware for certain devices on big-endian machines.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ti_usb_3410_5052.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1687,12 +1687,13 @@ static int ti_download_firmware(struct t
 
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


