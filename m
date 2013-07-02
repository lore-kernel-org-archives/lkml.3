Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3GBQKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:10:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab3GBQKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:10:21 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: kye: Add report fixup for Genius Gila Gaming mouse
Date: Tue,  2 Jul 2013 18:10:09 +0200
Message-Id: <1372781409-5356-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Genius Gila Gaming Mouse presents an obviously wrong report descriptor.
the Consumer control (report ID 3) is the following:
0x05, 0x0c,                    // Usage Page (Consumer Devices)       105
0x09, 0x01,                    // Usage (Consumer Control)            107
0xa1, 0x01,                    // Collection (Application)            109
0x85, 0x03,                    //   Report ID (3)                     111
0x19, 0x00,                    //   Usage Minimum (0)                 113
0x2a, 0xff, 0x7f,              //   Usage Maximum (32767)             115
0x15, 0x00,                    //   Logical Minimum (0)               118
0x26, 0xff, 0x7f,              //   Logical Maximum (32767)           120
0x75, 0x10,                    //   Report Size (16)                  123
0x95, 0x03,                    //   Report Count (3)                  125
0x81, 0x00,                    //   Input (Data,Arr,Abs)              127
0x75, 0x08,                    //   Report Size (8)                   129
0x95, 0x01,                    //   Report Count (1)                  131
0x81, 0x01,                    //   Input (Cnst,Arr,Abs)              133
0xc0,                          // End Collection                      135

So the first input whithin this report has a count of 3 but a usage range
of 32768. So this value is obviously wrong as it should not be greater than
the report count.

Fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=959721

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
Hi Jiri,

I know the window just opened and you don't really like receiving patches at
that time. Still, my patch queue is growing, and I would like you to consider
this patch for 3.11.

FYI, my patch queue is the following:
- one hid-multitouch patch which set the quirk NO_INIT_REPORTS for mt devices
- few hidp cleanup related to the wrong init_report called during start
- re-implement the hidinput_input_event callback in hidp to allow LEDs to work with BT keyboards
- some trivial devm conversions for some special HID drivers
- add devm_hid_allocate_device which allow to devm-ize i2c-hid

All of these are cleanups/enhancements, so I think we can postpone those patches
to 3.12 to get a maximum testing time.

Cheers,
Benjamin

 drivers/hid/hid-core.c |  1 +
 drivers/hid/hid-ids.h  |  1 +
 drivers/hid/hid-kye.c  | 21 +++++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0951a9a..e39dac6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1593,6 +1593,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ION, USB_DEVICE_ID_ICADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KEYTOUCH, USB_DEVICE_ID_KEYTOUCH_IEC) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_I405X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 2afa99a..c5aea29 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -478,6 +478,7 @@
 
 #define USB_VENDOR_ID_KYE		0x0458
 #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
+#define USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE	0x0138
 #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
 #define USB_DEVICE_ID_KYE_EASYPEN_I405X	0x5010
 #define USB_DEVICE_ID_KYE_MOUSEPEN_I608X	0x5011
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index 6af90db..1e2ee2aa 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -314,6 +314,25 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 			*rsize = sizeof(easypen_m610x_rdesc_fixed);
 		}
 		break;
+	case USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE:
+		/*
+		 * the fixup that need to be done:
+		 *   - change Usage Maximum in the Comsumer Control
+		 *     (report ID 3) to a reasonable value
+		 */
+		if (*rsize >= 135 &&
+			/* Usage Page (Consumer Devices) */
+			rdesc[104] == 0x05 && rdesc[105] == 0x0c &&
+			/* Usage (Consumer Control) */
+			rdesc[106] == 0x09 && rdesc[107] == 0x01 &&
+			/*   Usage Maximum > 12287 */
+			rdesc[114] == 0x2a && rdesc[116] > 0x2f) {
+			hid_info(hdev,
+				 "fixing up Genius Gila Gaming Mouse "
+				 "report descriptor\n");
+			rdesc[116] = 0x2f;
+		}
+		break;
 	}
 	return rdesc;
 }
@@ -407,6 +426,8 @@ static const struct hid_device_id kye_devices[] = {
 				USB_DEVICE_ID_KYE_MOUSEPEN_I608X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
 				USB_DEVICE_ID_KYE_EASYPEN_M610X) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
+				USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, kye_devices);
-- 
1.8.3.1

