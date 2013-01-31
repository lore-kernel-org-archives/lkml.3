Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3AaPHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:07:25 -0500
Received: from host171.canaca.com ([67.55.55.225]:33527 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3AaPHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:07:23 -0500
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, rosegardener@freeode.co.uk
Subject: [PATCH 2/5] USB: HID: Steelseries SRW-S1 Add support for dials
Date: Thu, 31 Jan 2013 08:07:08 -0700
Message-Id: <1359644830-3274-2-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359644830-3274-1-git-send-email-simon@mungewell.org>
References: <alpine.LNX.2.00.1301291057170.23853@pobox.suse.cz>
 <1359644830-3274-1-git-send-email-simon@mungewell.org>
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

This patch to the SRW-S1 driver re-writes the HID descriptor
to insert a section for the 3 dials on the device, previously
these were contained within a 'Manufacturer Specific' usage
page.

Signed-off-by: Simon Wood <simon@mungewell.org>
Tested-by: John Murphy <rosegardener@freeode.co.uk>
---
 drivers/hid/hid-steelseries-srws1.c |   86 +++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-steelseries-srws1.c b/drivers/hid/hid-steelseries-srws1.c
index 4a5386b..38b0a24 100644
--- a/drivers/hid/hid-steelseries-srws1.c
+++ b/drivers/hid/hid-steelseries-srws1.c
@@ -17,16 +17,94 @@
 
 #include "hid-ids.h"
 
+/* Fixed report descriptor for Steelseries SRW-S1 wheel controller
+ *
+ * The original descriptor hides the sensitivity and assists dials
+ * a custom vendor usage page. This inserts a patch to make them
+ * appear in the 'Generic Desktop' usage.
+ */
+
+static __u8 steelseries_srws1_rdesc_fixed[] = {
+0x05, 0x01,         /*  Usage Page (Desktop)                */
+0x09, 0x08,         /*  Usage (MultiAxis), Changed          */
+0xA1, 0x01,         /*  Collection (Application),           */
+0xA1, 0x02,         /*      Collection (Logical),           */
+0x95, 0x01,         /*          Report Count (1),           */
+0x05, 0x01,         /* Changed  Usage Page (Desktop),       */
+0x09, 0x30,         /* Changed  Usage (X),                  */
+0x16, 0xF8, 0xF8,   /*          Logical Minimum (-1800),    */
+0x26, 0x08, 0x07,   /*          Logical Maximum (1800),     */
+0x65, 0x14,         /*          Unit (Degrees),             */
+0x55, 0x0F,         /*          Unit Exponent (15),         */
+0x75, 0x10,         /*          Report Size (16),           */
+0x81, 0x02,         /*          Input (Variable),           */
+0x09, 0x31,         /* Changed  Usage (Y),                  */
+0x15, 0x00,         /*          Logical Minimum (0),        */
+0x26, 0xFF, 0x03,   /*          Logical Maximum (1023),     */
+0x75, 0x0C,         /*          Report Size (12),           */
+0x81, 0x02,         /*          Input (Variable),           */
+0x09, 0x32,         /* Changed  Usage (Z),                  */
+0x15, 0x00,         /*          Logical Minimum (0),        */
+0x26, 0xFF, 0x03,   /*          Logical Maximum (1023),     */
+0x75, 0x0C,         /*          Report Size (12),           */
+0x81, 0x02,         /*          Input (Variable),           */
+0x05, 0x01,         /*          Usage Page (Desktop),       */
+0x09, 0x39,         /*          Usage (Hat Switch),         */
+0x25, 0x07,         /*          Logical Maximum (7),        */
+0x35, 0x00,         /*          Physical Minimum (0),       */
+0x46, 0x3B, 0x01,   /*          Physical Maximum (315),     */
+0x65, 0x14,         /*          Unit (Degrees),             */
+0x75, 0x04,         /*          Report Size (4),            */
+0x95, 0x01,         /*          Report Count (1),           */
+0x81, 0x02,         /*          Input (Variable),           */
+0x25, 0x01,         /*          Logical Maximum (1),        */
+0x45, 0x01,         /*          Physical Maximum (1),       */
+0x65, 0x00,         /*          Unit,                       */
+0x75, 0x01,         /*          Report Size (1),            */
+0x95, 0x03,         /*          Report Count (3),           */
+0x81, 0x01,         /*          Input (Constant),           */
+0x05, 0x09,         /*          Usage Page (Button),        */
+0x19, 0x01,         /*          Usage Minimum (01h),        */
+0x29, 0x11,         /*          Usage Maximum (11h),        */
+0x95, 0x11,         /*          Report Count (17),          */
+0x81, 0x02,         /*          Input (Variable),           */
+                    /*   ---- Dial patch starts here ----   */
+0x05, 0x01,         /*          Usage Page (Desktop),       */
+0x09, 0x33,         /*          Usage (RX),                 */
+0x75, 0x04,         /*          Report Size (4),            */
+0x95, 0x02,         /*          Report Count (2),           */
+0x15, 0x00,         /*          Logical Minimum (0),        */
+0x25, 0x0b,         /*          Logical Maximum (b),        */
+0x81, 0x02,         /*          Input (Variable),           */
+0x09, 0x35,         /*          Usage (RZ),                 */
+0x75, 0x04,         /*          Report Size (4),            */
+0x95, 0x01,         /*          Report Count (1),           */
+0x25, 0x03,         /*          Logical Maximum (3),        */
+0x81, 0x02,         /*          Input (Variable),           */
+                    /*    ---- Dial patch ends here ----    */
+0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),         */
+0x09, 0x01,         /*          Usage (01h),                */
+0x75, 0x04,         /* Changed  Report Size (4),            */
+0x95, 0x0D,         /* Changed  Report Count (13),          */
+0x81, 0x02,         /*          Input (Variable),           */
+0xC0,               /*      End Collection,                 */
+0xA1, 0x02,         /*      Collection (Logical),           */
+0x09, 0x02,         /*          Usage (02h),                */
+0x75, 0x08,         /*          Report Size (8),            */
+0x95, 0x10,         /*          Report Count (16),          */
+0x91, 0x02,         /*          Output (Variable),          */
+0xC0,               /*      End Collection,                 */
+0xC0                /*  End Collection                      */
+};
+
 static __u8 *steelseries_srws1_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 115 && rdesc[11] == 0x02 && rdesc[13] == 0xc8
 			&& rdesc[29] == 0xbb && rdesc[40] == 0xc5) {
 		hid_info(hdev, "Fixing up Steelseries SRW-S1 report descriptor\n");
-		rdesc[11] = 0x01;
-		rdesc[13] = 0x30;
-		rdesc[29] = 0x31;
-		rdesc[40] = 0x32;
+		rdesc = steelseries_srws1_rdesc_fixed;
+		*rsize = sizeof(steelseries_srws1_rdesc_fixed);
 	}
 	return rdesc;
 }
-- 
1.7.10.4

