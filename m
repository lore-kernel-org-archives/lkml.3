Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3JJOUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:20:31 -0400
Received: from host171.canaca.com ([67.55.55.225]:58970 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3JJOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:20:29 -0400
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, Elias Vanderstuyft <elias.vds@gmail.com>,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@prifuk.cz>
Subject: [PATCHv2 1/3] HID:hid-lg: Fixed ReportDescriptor for Logitech Formula Vibration to split Accel/Brake into seperate axis
Date: Thu, 10 Oct 2013 08:20:12 -0600
Message-Id: <1381414814-2107-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <alpine.LNX.2.00.1310101002120.13289@pobox.suse.cz>
References: <alpine.LNX.2.00.1310101002120.13289@pobox.suse.cz>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requires https://patchwork.kernel.org/patch/2998241/

By default the Logitech Formula Vibration presents a combined accel/brake
axis ('Y'). This patch modifies the HID descriptor to present seperate    
accel/brake axes ('Y' and 'Z').

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index c2c7dab..c6efdae 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -45,6 +45,7 @@
 /* Size of the original descriptors of the Driving Force (and Pro) wheels */
 #define DF_RDESC_ORIG_SIZE	130
 #define DFP_RDESC_ORIG_SIZE	97
+#define FV_RDESC_ORIG_SIZE	130
 #define MOMO_RDESC_ORIG_SIZE	87
 
 /* Fixed report descriptors for Logitech Driving Force (and Pro)
@@ -170,6 +171,73 @@ static __u8 dfp_rdesc_fixed[] = {
 0xC0                /*  End Collection                          */
 };
 
+static __u8 fv_rdesc_fixed[] = {
+0x05, 0x01,         /*  Usage Page (Desktop),                   */
+0x09, 0x04,         /*  Usage (Joystik),                        */
+0xA1, 0x01,         /*  Collection (Application),               */
+0xA1, 0x02,         /*      Collection (Logical),               */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x0A,         /*          Report Size (10),               */
+0x15, 0x00,         /*          Logical Minimum (0),            */
+0x26, 0xFF, 0x03,   /*          Logical Maximum (1023),         */
+0x35, 0x00,         /*          Physical Minimum (0),           */
+0x46, 0xFF, 0x03,   /*          Physical Maximum (1023),        */
+0x09, 0x30,         /*          Usage (X),                      */
+0x81, 0x02,         /*          Input (Variable),               */
+0x95, 0x0C,         /*          Report Count (12),              */
+0x75, 0x01,         /*          Report Size (1),                */
+0x25, 0x01,         /*          Logical Maximum (1),            */
+0x45, 0x01,         /*          Physical Maximum (1),           */
+0x05, 0x09,         /*          Usage Page (Button),            */
+0x19, 0x01,         /*          Usage Minimum (01h),            */
+0x29, 0x0C,         /*          Usage Maximum (0Ch),            */
+0x81, 0x02,         /*          Input (Variable),               */
+0x95, 0x02,         /*          Report Count (2),               */
+0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),             */
+0x09, 0x01,         /*          Usage (01h),                    */
+0x81, 0x02,         /*          Input (Variable),               */
+0x09, 0x02,         /*          Usage (02h),                    */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x81, 0x02,         /*          Input (Variable),               */
+0x05, 0x01,         /*          Usage Page (Desktop),           */
+0x25, 0x07,         /*          Logical Maximum (7),            */
+0x46, 0x3B, 0x01,   /*          Physical Maximum (315),         */
+0x75, 0x04,         /*          Report Size (4),                */
+0x65, 0x14,         /*          Unit (Degrees),                 */
+0x09, 0x39,         /*          Usage (Hat Switch),             */
+0x81, 0x42,         /*          Input (Variable, Null State),   */
+0x75, 0x01,         /*          Report Size (1),                */
+0x95, 0x04,         /*          Report Count (4),               */
+0x65, 0x00,         /*          Unit,                           */
+0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),             */
+0x09, 0x01,         /*          Usage (01h),                    */
+0x25, 0x01,         /*          Logical Maximum (1),            */
+0x45, 0x01,         /*          Physical Maximum (1),           */
+0x81, 0x02,         /*          Input (Variable),               */
+0x05, 0x01,         /*          Usage Page (Desktop),           */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x09, 0x31,         /*          Usage (Y),                      */
+0x81, 0x02,         /*          Input (Variable),               */
+0x09, 0x32,         /*          Usage (Z),                      */
+0x81, 0x02,         /*          Input (Variable),               */
+0xC0,               /*      End Collection,                     */
+0xA1, 0x02,         /*      Collection (Logical),               */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x95, 0x07,         /*          Report Count (7),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x09, 0x03,         /*          Usage (03h),                    */
+0x91, 0x02,         /*          Output (Variable),              */
+0xC0,               /*      End Collection,                     */
+0xC0                /*  End Collection                          */
+};
+
 static __u8 momo_rdesc_fixed[] = {
 0x05, 0x01,         /*  Usage Page (Desktop),               */
 0x09, 0x04,         /*  Usage (Joystik),                    */
@@ -275,6 +343,15 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		}
 		break;
 
+	case USB_DEVICE_ID_LOGITECH_VIBRATION_WHEEL:
+		if (*rsize == FV_RDESC_ORIG_SIZE) {
+			hid_info(hdev,
+				"fixing up Logitech Formula Vibration report descriptor\n");
+			rdesc = fv_rdesc_fixed;
+			*rsize = sizeof(fv_rdesc_fixed);
+		}
+		break;
+
 	case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
 		if (*rsize == DFP_RDESC_ORIG_SIZE) {
 			hid_info(hdev,
-- 
1.8.1.2

