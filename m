Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaAOWkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:40:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaAOVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 011/166] [media] af9035: [0ccd:0099] TerraTec Cinergy T Stick Dual RC (rev. 2)
Date: Wed, 15 Jan 2014 13:50:25 -0800
Message-Id: <1389822780-4729-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit b799b8102baa8e63139f0eadef00d75701328775 upstream.

That same USB ID is used both AF9015 and AF9035 driver.
iManufacturer is only thing we can select correct driver without a I/O.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 42 ++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index c3cd6be..cbe1373 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1046,6 +1046,43 @@ err:
 	return ret;
 }
 
+static int af9035_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	char manufacturer[sizeof("Afatech")];
+
+	memset(manufacturer, 0, sizeof(manufacturer));
+	usb_string(udev, udev->descriptor.iManufacturer,
+			manufacturer, sizeof(manufacturer));
+	/*
+	 * There is two devices having same ID but different chipset. One uses
+	 * AF9015 and the other IT9135 chipset. Only difference seen on lsusb
+	 * is iManufacturer string.
+	 *
+	 * idVendor           0x0ccd TerraTec Electronic GmbH
+	 * idProduct          0x0099
+	 * bcdDevice            2.00
+	 * iManufacturer           1 Afatech
+	 * iProduct                2 DVB-T 2
+	 *
+	 * idVendor           0x0ccd TerraTec Electronic GmbH
+	 * idProduct          0x0099
+	 * bcdDevice            2.00
+	 * iManufacturer           1 ITE Technologies, Inc.
+	 * iProduct                2 DVB-T TV Stick
+	 */
+	if ((le16_to_cpu(udev->descriptor.idVendor) == USB_VID_TERRATEC) &&
+			(le16_to_cpu(udev->descriptor.idProduct) == 0x0099)) {
+		if (!strcmp("Afatech", manufacturer)) {
+			dev_dbg(&udev->dev, "%s: rejecting device\n", __func__);
+			return -ENODEV;
+		}
+	}
+
+	return dvb_usbv2_probe(intf, id);
+}
+
 /* interface 0 is used by DVB-T receiver and
    interface 1 is for remote controller (HID) */
 static const struct dvb_usb_device_properties af9035_props = {
@@ -1135,6 +1172,9 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "Asus U3100Mini Plus", NULL) },
         { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
 		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
+	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
+		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
@@ -1142,7 +1182,7 @@ MODULE_DEVICE_TABLE(usb, af9035_id_table);
 static struct usb_driver af9035_usb_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = af9035_id_table,
-	.probe = dvb_usbv2_probe,
+	.probe = af9035_probe,
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
-- 
1.8.3.2

