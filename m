Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaHUFBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:01:14 -0400
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:60961 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaHUFBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:01:13 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2014 01:01:12 EDT
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=/MiPqmMwFv6ha2ZBybe0ZU9m+O5sXPp7gEUgHVyRzyY= c=1 sm=1
 a=lCjy0tSDDicA:10 a=009HhJXs7FYA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=x/GiHf5VU5uXFAeKKVSXKg==:17 a=NcP6RiT5J5w_GCMKhIsA:9
 a=o9_k_pa99ygZmGRZ:21 a=6rvib8z1mVRbGbxj:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Simon Wood <simon@mungewell.org>
Subject: [RFC 3/4] HID:hid-logitech: Use new native switch method
Date: Wed, 20 Aug 2014 22:51:41 -0600
Message-Id: <1408596702-3895-3-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408596702-3895-1-git-send-email-simon@mungewell.org>
References: <1408596702-3895-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/hid/hid-lg4ff.c | 126 +++++++++++++++++++++---------------------------
 1 file changed, 55 insertions(+), 71 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index eda07a2..0ba0838 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -32,21 +32,10 @@
 #include "hid-lg.h"
 #include "hid-ids.h"
 
-#define DFGT_REV_MAJ 0x13
-#define DFGT_REV_MIN 0x22
-#define DFGT2_REV_MIN 0x26
-#define DFP_REV_MAJ 0x11
-#define DFP_REV_MIN 0x06
-#define FFEX_REV_MAJ 0x21
-#define FFEX_REV_MIN 0x00
-#define G25_REV_MAJ 0x12
-#define G25_REV_MIN 0x22
-#define G27_REV_MAJ 0x12
-#define G27_REV_MIN 0x38
-#define G27_2_REV_MIN 0x39
-
 #define to_hid_device(pdev) container_of(pdev, struct hid_device, dev)
 
+#define LG4FF_FFEX_BCDDEVICE 0x2100
+
 static void hid_lg4ff_set_range_dfp(struct hid_device *hid, u16 range);
 static void hid_lg4ff_set_range_g25(struct hid_device *hid, u16 range);
 static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *attr, char *buf);
@@ -89,48 +78,6 @@ static const struct lg4ff_mode_switcher lg4ff_mode_switchers[] = {	/* Note: Orde
 	{0x1000, 0xf000, LG4FF_MSW_DFP, USB_DEVICE_ID_LOGITECH_DFP_WHEEL, hid_lg4ff_set_range_dfp},
 };
 
-struct lg4ff_native_cmd {
-	const __u8 cmd_num;	/* Number of commands to send */
-	const __u8 cmd[];
-};
-
-struct lg4ff_usb_revision {
-	const __u16 rev_maj;
-	const __u16 rev_min;
-	const struct lg4ff_native_cmd *command;
-};
-
-static const struct lg4ff_native_cmd native_dfp = {
-	1,
-	{0xf8, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct lg4ff_native_cmd native_dfgt = {
-	2,
-	{0xf8, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00,	/* 1st command */
-	 0xf8, 0x09, 0x03, 0x01, 0x00, 0x00, 0x00}	/* 2nd command */
-};
-
-static const struct lg4ff_native_cmd native_g25 = {
-	1,
-	{0xf8, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct lg4ff_native_cmd native_g27 = {
-	2,
-	{0xf8, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00,	/* 1st command */
-	 0xf8, 0x09, 0x04, 0x01, 0x00, 0x00, 0x00}	/* 2nd command */
-};
-
-static const struct lg4ff_usb_revision lg4ff_revs[] = {
-	{DFGT_REV_MAJ, DFGT_REV_MIN, &native_dfgt},	/* Driving Force GT */
-	{DFGT_REV_MAJ, DFGT2_REV_MIN, &native_dfgt},	/* Driving Force GT v2 */
-	{DFP_REV_MAJ,  DFP_REV_MIN,  &native_dfp},	/* Driving Force Pro */
-	{G25_REV_MAJ,  G25_REV_MIN,  &native_g25},	/* G25 */
-	{G27_REV_MAJ,  G27_REV_MIN,  &native_g27},	/* G27 */
-	{G27_REV_MAJ,  G27_2_REV_MIN,  &native_g27},	/* G27 v2 */
-};
-
 /* Recalculates X axis value accordingly to currently selected range */
 static __s32 lg4ff_adjust_dfp_x_axis(__s32 value, __u16 range)
 {
@@ -397,19 +344,63 @@ static void hid_lg4ff_set_range_dfp(struct hid_device *hid, __u16 range)
 	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
-static void hid_lg4ff_switch_native(struct hid_device *hid, const struct lg4ff_native_cmd *cmd)
+static int lg4ff_switch_mode(struct hid_device *hid, __u16 type, int mode)
 {
 	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
-	__u8 i, j;
+	__s32 *value = report->field[0]->value;
+
+	if (mode >= LG4FF_MSW_MAX || mode <= LG4FF_MSW_NAT) mode = type;
+
+	if (type == LG4FF_MSW_G25 && mode == LG4FF_MSW_G25) {
+		value[0] = 0xf8;
+		value[1] = 0x10;
+		value[2] = 0x00;
+		value[3] = 0x00;
+		value[4] = 0x00;
+		value[5] = 0x00;
+		value[6] = 0x00;
+
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+		return 0;
+	}
 
-	j = 0;
-	while (j < 7*cmd->cmd_num) {
-		for (i = 0; i < 7; i++)
-			report->field[0]->value[i] = cmd->cmd[j++];
+	if (mode == LG4FF_MSW_DFP) {
+		value[0] = 0xf8;
+		value[1] = 0x01;
+		value[2] = 0x00;
+		value[3] = 0x00;
+		value[4] = 0x00;
+		value[5] = 0x00;
+		value[6] = 0x00;
 
 		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+		return 0;
 	}
+
+	/* Prevent compat mode on USB reset */
+	if (type == LG4FF_MSW_DFGT || type == LG4FF_MSW_G27) {
+		value[0] = 0xf8;
+		value[1] = 0x0a;
+		value[2] = 0x00;
+		value[3] = 0x00;
+		value[4] = 0x00;
+		value[5] = 0x00;
+		value[6] = 0x00;
+
+		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+	}
+
+	value[0] = 0xf8;
+	value[1] = 0x09;
+	value[2] = mode;
+	value[3] = 0x01;
+	value[4] = 0x00;
+	value[5] = 0x00;
+	value[6] = 0x00;
+
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+	return 0;
 }
 
 /* Read current range and display it in terminal */
@@ -608,21 +599,14 @@ int lg4ff_init(struct hid_device *hid, const int switch_mode)
 		dbg_hid("Native capable device detected (Native ID %04X, type %d)\n", s->native_pid, s->type);
 
 		if (hid->product == s->native_pid) {
-			entry->product_id = s->native_pid;
 			entry->min_range = 40;
 			entry->max_range = 900;
 			entry->set_range = s->set_range;
 		}
 
-		if (hid->product != s->native_pid && switch_mode != LG4FF_MSW_EMU) {
+		if (hid->product == USB_DEVICE_ID_LOGITECH_WHEEL && switch_mode != LG4FF_MSW_EMU) {
 			dbg_hid("Switching to native mode\n");
-
-			for (j = 0; j < ARRAY_SIZE(lg4ff_revs); j++) {
-				if (lg4ff_revs[j].rev_maj == rev_maj && lg4ff_revs[j].rev_min == rev_min) {
-					hid_lg4ff_switch_native(hid, lg4ff_revs[j].command);
-					hid_info(hid, "Switched to native mode\n");
-				}
-			}
+			lg4ff_switch_mode(hid, s->type, switch_mode);
 		}
 		break;
 	}
@@ -639,7 +623,7 @@ int lg4ff_init(struct hid_device *hid, const int switch_mode)
 	/* Check if autocentering is available and
 	 * set the centering force to zero by default */
 	if (test_bit(FF_AUTOCENTER, dev->ffbit)) {
-		if (rev_maj == FFEX_REV_MAJ && rev_min == FFEX_REV_MIN)	/* Formula Force EX expects different autocentering command */
+		if (bcdDevice == LG4FF_FFEX_BCDDEVICE)	/* Formula Force EX does not seem to support hi-res autocentering */
 			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_ffex;
 		else
 			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_default;
-- 
1.9.1

