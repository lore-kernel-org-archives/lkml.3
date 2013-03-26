Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035Ab3CZPWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53722 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992Ab3CZPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 053/150] HID: add support for Sony RF receiver with USB product id 0x0374
Date: Tue, 26 Mar 2013 15:19:12 +0000
Message-Id: <1364311249-14454-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Fernando=20Luis=20V=C3=A1zquez=20Cao?=

commit a464918419f94a0043d2f549d6defb4c3f69f68a upstream.

Some Vaio desktop computers, among them the VGC-LN51JGB multimedia PC, have
a RF receiver, multi-interface USB device 054c:0374, that is used to connect
a wireless keyboard and a wireless mouse.

The keyboard works flawlessly, but the mouse (VGP-WMS3 in my case) does not
seem to be generating any pointer events. The problem is that the mouse pointer
is wrongly declared as a constant non-data variable in the report descriptor
(see lsusb and usbhid-dump output below), with the consequence that it is
ignored by the HID code.

Add this device to the have-special-driver list and fix up the report
descriptor in the Sony-specific driver which happens to already have a fixup
for a similar firmware bug.

Bus 003 Device 002: ID 054c:0374 Sony Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x054c Sony Corp.
  idProduct          0x0374
  iSerial                 0
[...]
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              2 RF Receiver
[...]
          Report Descriptor: (length is 100)
[...]
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage, data= [ 0x30 ] 48
                            Direction-X
            Item(Local ): Usage, data= [ 0x31 ] 49
                            Direction-Y
            Item(Global): Report Count, data= [ 0x02 ] 2
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Logical Minimum, data= [ 0x81 ] 129
            Item(Global): Logical Maximum, data= [ 0x7f ] 127
            Item(Main  ): Input, data= [ 0x07 ] 7
                            Constant Variable Relative No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield

003:002:001:DESCRIPTOR         1357910009.758544
 05 01 09 02 A1 01 05 01 09 02 A1 02 85 01 09 01
 A1 00 05 09 19 01 29 05 95 05 75 01 15 00 25 01
 81 02 75 03 95 01 81 01 05 01 09 30 09 31 95 02
 75 08 15 81 25 7F 81 07 A1 02 85 01 09 38 35 00
 45 00 15 81 25 7F 95 01 75 08 81 06 C0 A1 02 85
 01 05 0C 15 81 25 7F 95 01 75 08 0A 38 02 81 06
 C0 C0 C0 C0

Cc: linux-input@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[ luis: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c | 1 +
 drivers/hid/hid-ids.h  | 1 +
 drivers/hid/hid-sony.c | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 52bc936..2f85e59 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1641,6 +1641,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index de39a12..c04eec3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -684,6 +684,7 @@
 
 #define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE	0x024b
+#define USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE	0x0374
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
 #define USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER	0x042f
 
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 5cd25bd..963bda1 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -46,7 +46,7 @@ static __u8 *sony_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 	if ((sc->quirks & VAIO_RDESC_CONSTANT) &&
 			*rsize >= 56 && rdesc[54] == 0x81 && rdesc[55] == 0x07) {
-		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
+		hid_info(hdev, "Fixing up Sony RF Receiver report descriptor\n");
 		rdesc[55] = 0x06;
 	}
 
@@ -218,6 +218,8 @@ static const struct hid_device_id sony_devices[] = {
 		.driver_data = SIXAXIS_CONTROLLER_BT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE),
 		.driver_data = VAIO_RDESC_CONSTANT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE),
+		.driver_data = VAIO_RDESC_CONSTANT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, sony_devices);
-- 
1.8.1.2

