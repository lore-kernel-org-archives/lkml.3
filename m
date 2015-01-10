Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbbAJFgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:36:48 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36953 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbbAJFgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:37 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 06/25] staging: line6: Index properties array with device type
Date: Fri,  9 Jan 2015 23:35:52 -0600
Message-Id: <1420868171-2031-7-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current logic uses the index of the matched entry from the device
table as an offset to the corresponding properties entry.  The values
of the new `line6_device_type' enum are ordered such that they can be
used as an index into either of these arrays.  Drop the device entry
lookup logic and use the device type (via the .driver_info member)
instead.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 2797e41..c090b2b 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -624,7 +624,7 @@ static void line6_destruct(struct usb_interface *interface)
 static int line6_probe(struct usb_interface *interface,
 		       const struct usb_device_id *id)
 {
-	int devtype;
+	enum line6_device_type devtype;
 	struct usb_device *usbdev;
 	struct usb_line6 *line6;
 	const struct line6_properties *properties;
@@ -646,20 +646,7 @@ static int line6_probe(struct usb_interface *interface,
 		goto err_put;
 	}
 
-	/* check vendor and product id */
-	for (devtype = ARRAY_SIZE(line6_id_table) - 1; devtype--;) {
-		u16 idVendor = le16_to_cpu(usbdev->descriptor.idVendor);
-		u16 idProduct = le16_to_cpu(usbdev->descriptor.idProduct);
-
-		if (idVendor == line6_id_table[devtype].idVendor &&
-		    idProduct == line6_id_table[devtype].idProduct)
-			break;
-	}
-
-	if (devtype < 0) {
-		ret = -ENODEV;
-		goto err_put;
-	}
+	devtype = id->driver_info;
 
 	/* initialize device info: */
 	properties = &line6_properties_table[devtype];
-- 
2.1.0

