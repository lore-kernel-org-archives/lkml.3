Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab3ETXbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:31:32 -0400
Received: from mout.gmx.net ([212.227.17.21]:49332 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3ETXbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:31:18 -0400
X-Authenticated: #885997
X-Provags-ID: V01U2FsdGVkX1+CU2pc8yGC/3lpjXEmPnUr4/LfZyCXZn0PrsMpTE
	HiP+mIbI2nYEiM
From: Christian Ohm <chr.ohm@gmx.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] HID: Add support for Holtek gaming mouse 04d9:a04a
Date: Tue, 21 May 2013 01:31:09 +0200
Message-Id: <9c457292f966aed8b29001a29ae0ab9e433d973d.1369083628.git.chr.ohm@gmx.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1369083628.git.chr.ohm@gmx.net>
References: <cover.1369083628.git.chr.ohm@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mouse is sold as Tracer Sniper TRM-503, NOVA Gaming Slider X200 and
Zalman ZM-GM1, and reports too high usage maximum and logical maximum
(like 04d9:a067, but its report descriptor is different). This patch
adds its USB ID and fixes the report descriptor in the same way.

Note: I don't actually have such a mouse to test, I took the report
descriptor posted at https://bugzilla.novell.com/show_bug.cgi?id=774676,
compared it to the one from 04d9:a067 and changed the offsets
accordingly (all numbers minus 9, since it is 9 bytes shorter, and the
difference is before the values that need changing). That Surely Works™.

Signed-off-by: Christian Ohm <chr.ohm@gmx.net>
---
 drivers/hid/Kconfig            |    2 ++
 drivers/hid/hid-holtek-mouse.c |   28 ++++++++++++++++++++++------
 drivers/hid/hid-ids.h          |    1 +
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index d661a41..ec55049 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -221,6 +221,8 @@ config HID_HOLTEK
 	  - Holtek On Line Grip based game controller
 	  - Trust GXT 18 Gaming Keyboard
 	  - Sharkoon Drakonia / Perixx MX-2000 gaming mice
+	  - Tracer Sniper TRM-503 / NOVA Gaming Slider X200 /
+	    Zalman ZM-GM1
 
 config HOLTEK_FF
 	bool "Holtek On Line Grip force feedback support"
diff --git a/drivers/hid/hid-holtek-mouse.c b/drivers/hid/hid-holtek-mouse.c
index f32e29a..6a23ee6 100644
--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -23,8 +23,10 @@
  * excessively large number of consumer usages (2^15), which is more than
  * HID_MAX_USAGES. This prevents proper parsing of the report descriptor.
  *
- * This driver fixes the report descriptor for USB ID 04d9:a067, sold as
- * Sharkoon Drakonia and Perixx MX-2000.
+ * This driver fixes the report descriptor for:
+ * - USB ID 04d9:a067, sold as Sharkoon Drakonia and Perixx MX-2000
+ * - USB ID 04d9:a04a, sold as Tracer Sniper TRM-503, NOVA Gaming Slider X200
+ *   and Zalman ZM-GM1
  */
 
 static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
@@ -35,11 +37,23 @@ static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	if (intf->cur_altsetting->desc.bInterfaceNumber == 1) {
 		/* Change usage maximum and logical maximum from 0x7fff to
 		 * 0x2fff, so they don't exceed HID_MAX_USAGES */
-		if (*rsize >= 122 && rdesc[115] == 0xff && rdesc[116] == 0x7f
-				&& rdesc[120] == 0xff && rdesc[121] == 0x7f) {
-			hid_info(hdev, "Fixing up report descriptor\n");
-			rdesc[116] = rdesc[121] = 0x2f;
+		switch (hdev->product) {
+		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067:
+			if (*rsize >= 122 && rdesc[115] == 0xff && rdesc[116] == 0x7f
+					&& rdesc[120] == 0xff && rdesc[121] == 0x7f) {
+				hid_info(hdev, "Fixing up report descriptor\n");
+				rdesc[116] = rdesc[121] = 0x2f;
+			}
+			break;
+		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A:
+			if (*rsize >= 113 && rdesc[106] == 0xff && rdesc[107] == 0x7f
+					&& rdesc[111] == 0xff && rdesc[112] == 0x7f) {
+				hid_info(hdev, "Fixing up report descriptor\n");
+				rdesc[107] = rdesc[112] = 0x2f;
+			}
+			break;
 		}
+
 	}
 	return rdesc;
 }
@@ -47,6 +61,8 @@ static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 static const struct hid_device_id holtek_mouse_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
+			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, holtek_mouse_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 00f7ba9..fdde254 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -436,6 +436,7 @@
 #define USB_VENDOR_ID_HOLTEK_ALT		0x04d9
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD	0xa055
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067	0xa067
+#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A04A	0xa04a
 
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
-- 
1.7.10.4

