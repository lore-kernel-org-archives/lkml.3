Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935678Ab3BTDf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 22:35:26 -0500
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:34081 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935668Ab3BTDe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 22:34:58 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=YO+FcVZrxpdWV6Mo6AkY2Rtp7tuV51ZJEd1ZQZEmJbs= c=1 sm=1
 a=Yp7lHQjj3ZkA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=VwQbUJbxAAAA:8 a=47LbCVvxAAAA:8
 a=c6gCK2x0kKHlvJvzz_wA:9 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org
Subject: [PATCH 1/5] HID: LG: Add support for Logitech Momo Force (Red) Wheel
Date: Tue, 19 Feb 2013 20:25:10 -0700
Message-Id: <1361330714-5217-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a modified report descriptor to split accelerator
and brake, and adds the 'NO_GET' flag to prevent it hanging on
connection.

Note: for convience this patch is against the follow patch which was applied
earlier this week.
https://patchwork.kernel.org/patch/2153471/

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 6bb7f05..160c489 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -45,6 +45,7 @@
 /* Size of the original descriptors of the Driving Force (and Pro) wheels */
 #define DF_RDESC_ORIG_SIZE	130
 #define DFP_RDESC_ORIG_SIZE	97
+#define MOMO_RDESC_ORIG_SIZE	87
 
 /* Fixed report descriptors for Logitech Driving Force (and Pro)
  * wheel controllers
@@ -169,6 +170,52 @@ static __u8 dfp_rdesc_fixed[] = {
 0xC0                /*  End Collection                          */
 };
 
+static __u8 momo_rdesc_fixed[] = {
+0x05, 0x01,         /*  Usage Page (Desktop),               */
+0x09, 0x04,         /*  Usage (Joystik),                    */
+0xA1, 0x01,         /*  Collection (Application),           */
+0xA1, 0x02,         /*      Collection (Logical),           */
+0x95, 0x01,         /*          Report Count (1),           */
+0x75, 0x0A,         /*          Report Size (10),           */
+0x15, 0x00,         /*          Logical Minimum (0),        */
+0x26, 0xFF, 0x03,   /*          Logical Maximum (1023),     */
+0x35, 0x00,         /*          Physical Minimum (0),       */
+0x46, 0xFF, 0x03,   /*          Physical Maximum (1023),    */
+0x09, 0x30,         /*          Usage (X),                  */
+0x81, 0x02,         /*          Input (Variable),           */
+0x95, 0x08,         /*          Report Count (8),           */
+0x75, 0x01,         /*          Report Size (1),            */
+0x25, 0x01,         /*          Logical Maximum (1),        */
+0x45, 0x01,         /*          Physical Maximum (1),       */
+0x05, 0x09,         /*          Usage Page (Button),        */
+0x19, 0x01,         /*          Usage Minimum (01h),        */
+0x29, 0x08,         /*          Usage Maximum (08h),        */
+0x81, 0x02,         /*          Input (Variable),           */
+0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),         */
+0x75, 0x0E,         /*          Report Size (14),           */
+0x95, 0x01,         /*          Report Count (1),           */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),      */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),     */
+0x09, 0x00,         /*          Usage (00h),                */
+0x81, 0x02,         /*          Input (Variable),           */
+0x05, 0x01,         /*          Usage Page (Desktop),       */
+0x75, 0x08,         /*          Report Size (8),            */
+0x09, 0x31,         /*          Usage (Y),                  */
+0x81, 0x02,         /*          Input (Variable),           */
+0x09, 0x32,         /*          Usage (Z),                  */
+0x81, 0x02,         /*          Input (Variable),           */
+0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),         */
+0x09, 0x01,         /*          Usage (01h),                */
+0x81, 0x02,         /*          Input (Variable),           */
+0xC0,               /*      End Collection,                 */
+0xA1, 0x02,         /*      Collection (Logical),           */
+0x09, 0x02,         /*          Usage (02h),                */
+0x95, 0x07,         /*          Report Count (7),           */
+0x91, 0x02,         /*          Output (Variable),          */
+0xC0,               /*      End Collection,                 */
+0xC0                /*  End Collection                      */
+};
+
 /*
  * Certain Logitech keyboards send in report #3 keys which are far
  * above the logical maximum described in descriptor. This extends
@@ -228,6 +275,15 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		}
 		break;
 
+	case USB_DEVICE_ID_LOGITECH_MOMO_WHEEL:
+		if (*rsize == MOMO_RDESC_ORIG_SIZE) {
+			hid_info(hdev,
+				"fixing up Logitech Momo Force (Red) report descriptor\n");
+			rdesc = momo_rdesc_fixed;
+			*rsize = sizeof(momo_rdesc_fixed);
+		}
+		break;
+
 	case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
 		if (*rsize == DFP_RDESC_ORIG_SIZE) {
 			hid_info(hdev,
@@ -558,7 +614,7 @@ static const struct hid_device_id lg_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_FORCE3D_PRO),
 		.driver_data = LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL),
-		.driver_data = LG_FF4 },
+		.driver_data = LG_NOGET | LG_FF4 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2),
 		.driver_data = LG_FF4 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL),
-- 
1.7.10.4

