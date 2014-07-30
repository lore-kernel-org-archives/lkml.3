Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaG3KKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:10:53 -0400
Received: from imap.devoid-pointer.net ([31.31.77.140]:50192 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaG3KKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:10:51 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        edwin@velds.nl, "elias.vds@gmail.com" <elias.vds@gmail.com>,
        "simon@mungewell.org" <simon@mungewell.org>,
        Roland Bosa <rbosa@logitech.com>
Subject: PATCH hid: Implement mode switching on Logitech gaming wheels accordingly to the documentation
Date: Wed, 30 Jul 2014 12:10:46 +0200
Message-ID: <3335238.KGDcEM6DjH@sigyn>
User-Agent: KMail/4.13.3 (Linux/3.15.0-1-my-rd; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement mode switching on Logitech gaming wheels accordingly to the documentation

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>

---
 Logitech has recently released technical documentation which describes the
 protocol used by their force feedback gaming devices. The documentation
 describes the method by which the driver is supposed to recognize what
 model of the wheel is connected and switch it to so-called "native" mode.
 (https://opensource.logitech.com/opensource/index.php/Technical_Information)

 The patch implements this logic and provides an additional module parameter
 which can force the driver either not perform the switch at all or switch the
 wheel into an "extended compatibility" mode (not applicable for all wheels).
 If a wheel does not support the mode enforced by the parameter, it is left in
 its original mode. Default behavior is to switch all wheels into native mode.

 drivers/hid/hid-lg.c    |  17 +++-
 drivers/hid/hid-lg.h    |  11 ++-
 drivers/hid/hid-lg4ff.c | 224 +++++++++++++++++++++++++++++++++++-------------
 3 files changed, 188 insertions(+), 64 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index a976f48..dc0f2f1 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -334,6 +334,16 @@ static __u8 momo2_rdesc_fixed[] = {
 };
 
 /*
+ * Certain Logitech wheels provide various compatibililty modes
+ * for games that cannot handle their advanced features properly.
+ * This switch forces the wheel into a specific compatibililty
+ * instead of its native mode
+ */
+#ifdef CONFIG_LOGIWHEELS_FF
+static int lg4ff_switch_force_mode;
+#endif
+
+/*
  * Certain Logitech keyboards send in report #3 keys which are far
  * above the logical maximum described in descriptor. This extends
  * the original value of 0x28c of logical maximum to 0x104d
@@ -717,7 +727,7 @@ static int lg_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (drv_data->quirks & LG_FF3)
 		lg3ff_init(hdev);
 	if (drv_data->quirks & LG_FF4)
-		lg4ff_init(hdev);
+		lg4ff_init(hdev, lg4ff_switch_force_mode);
 
 	return 0;
 err_free:
@@ -818,4 +828,9 @@ static struct hid_driver lg_driver = {
 };
 module_hid_driver(lg_driver);
 
+#ifdef CONFIG_LOGIWHEELS_FF
+module_param_named(lg4ff_switch_force_mode, lg4ff_switch_force_mode, int, S_IRUGO);
+MODULE_PARM_DESC(lg4ff_switch_force_mode, "Force gaming wheel into specific compatibililty mode (only certain devices)");
+#endif
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-lg.h b/drivers/hid/hid-lg.h
index 142ce3f..d070e479 100644
--- a/drivers/hid/hid-lg.h
+++ b/drivers/hid/hid-lg.h
@@ -25,14 +25,21 @@ static inline int lg3ff_init(struct hid_device *hdev) { return -1; }
 #endif
 
 #ifdef CONFIG_LOGIWHEELS_FF
+#define LG4FF_MSW_MIN 0
+#define LG4FF_MSW_NATIVE 0	/* Switch device to its native mode (if applicable) */
+#define LG4FF_MSW_DONTSWITCH 1	/* Leave device in its current mode */
+#define LG4FF_MSW_DFP 2		/* Switch device so that it emulates Driving Force Pro (only G25, G27, DFGT) */
+#define LG4FF_MSW_G25 3		/* Switch device so that it emulates G25 (only G27) */
+#define LG4FF_MSW_MAX 3
+
 int lg4ff_adjust_input_event(struct hid_device *hid, struct hid_field *field,
 			     struct hid_usage *usage, __s32 value, struct lg_drv_data *drv_data);
-int lg4ff_init(struct hid_device *hdev);
+int lg4ff_init(struct hid_device *hdev, const int switch_force_mode);
 int lg4ff_deinit(struct hid_device *hdev);
 #else
 static inline int lg4ff_adjust_input_event(struct hid_device *hid, struct hid_field *field,
 					   struct hid_usage *usage, __s32 value, struct lg_drv_data *drv_data) { return 0; }
-static inline int lg4ff_init(struct hid_device *hdev) { return -1; }
+static inline int lg4ff_init(struct hid_device *hdev, const int switch_force_mode) { return -1; }
 static inline int lg4ff_deinit(struct hid_device *hdev) { return -1; }
 #endif
 
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index cc2bd20..14692d9 100644
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
@@ -73,6 +62,26 @@ static const signed short lg4ff_wheel_effects[] = {
 	-1
 };
 
+struct lg4ff_mode_switch_cmd {
+	const __u8 cmd_count;	/* Number of commands to send */
+	const __u8 *cmd[];
+};
+
+struct lg4ff_emulated_wheel_mode {
+	const int tag;
+	const __u32 pid;
+	const struct lg4ff_mode_switch_cmd *cmd;
+};
+
+struct lg4ff_mode_switcher {
+	const u16 bcdDevice;
+	const u16 mask;
+	const __u32 native_pid;
+	const __u32 *nonnative_pids;
+	const struct lg4ff_mode_switch_cmd *native_cmds;
+	const struct lg4ff_emulated_wheel_mode **emulated_modes;
+};
+
 struct lg4ff_wheel {
 	const __u32 product_id;
 	const signed short *ff_effects;
@@ -92,46 +101,79 @@ static const struct lg4ff_wheel lg4ff_devices[] = {
 	{USB_DEVICE_ID_LOGITECH_WII_WHEEL,   lg4ff_wheel_effects, 40, 270, NULL}
 };
 
-struct lg4ff_native_cmd {
-	const __u8 cmd_num;	/* Number of commands to send */
-	const __u8 cmd[];
+
+static const u8 lg4ff_go_native_dfp_cmd[] = {0xf8, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00};
+static const u8 lg4ff_go_native_g25_cmd[] = {0xf8, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00};
+
+static const u8 lg4ff_no_compat_on_usb_reset_cmd[] = {0xf8, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00};
+
+static const u8 lg4ff_force_dfp_cmd[] = {0xf8, 0x09, 0x01, 0x01, 0x00, 0x00, 0x00};
+static const u8 lg4ff_force_g25_cmd[] = {0xf8, 0x09, 0x02, 0x01, 0x00, 0x00, 0x00};
+static const u8 lg4ff_force_dfgt_cmd[] = {0xf8, 0x09, 0x03, 0x01, 0x00, 0x00, 0x00};
+static const u8 lg4ff_force_g27_cmd[] = {0xf8, 0x09, 0x04, 0x01, 0x00, 0x00, 0x00};
+
+static const struct lg4ff_mode_switch_cmd lg4ff_switch_native_dfp_cmd = {
+	1,
+	{ lg4ff_go_native_dfp_cmd }
 };
 
-struct lg4ff_usb_revision {
-	const __u16 rev_maj;
-	const __u16 rev_min;
-	const struct lg4ff_native_cmd *command;
+static const struct lg4ff_mode_switch_cmd lg4ff_switch_native_dfgt_cmd = {
+	2,
+	{ lg4ff_no_compat_on_usb_reset_cmd,
+	  lg4ff_force_dfgt_cmd }
 };
 
-static const struct lg4ff_native_cmd native_dfp = {
+static const struct lg4ff_mode_switch_cmd lg4ff_switch_native_g25_cmd = {
 	1,
-	{0xf8, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00}
+	{ lg4ff_go_native_g25_cmd }
 };
 
-static const struct lg4ff_native_cmd native_dfgt = {
+static const struct lg4ff_mode_switch_cmd lg4ff_switch_native_g27_cmd = {
 	2,
-	{0xf8, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00,	/* 1st command */
-	 0xf8, 0x09, 0x03, 0x01, 0x00, 0x00, 0x00}	/* 2nd command */
+	{ lg4ff_no_compat_on_usb_reset_cmd,
+	  lg4ff_force_g27_cmd }
 };
 
-static const struct lg4ff_native_cmd native_g25 = {
+static const struct lg4ff_mode_switch_cmd lg4ff_switch_emulate_dfp_cmd = {
 	1,
-	{0xf8, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00}
+	{ lg4ff_force_dfp_cmd }
 };
 
-static const struct lg4ff_native_cmd native_g27 = {
-	2,
-	{0xf8, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00,	/* 1st command */
-	 0xf8, 0x09, 0x04, 0x01, 0x00, 0x00, 0x00}	/* 2nd command */
+static const struct lg4ff_mode_switch_cmd lg4ff_switch_emulate_g25_cmd = {
+	1,
+	{ lg4ff_force_g25_cmd }
+};
+
+static const struct lg4ff_emulated_wheel_mode lg4ff_emulated_dfp_mode = {
+	LG4FF_MSW_DFP,
+	USB_DEVICE_ID_LOGITECH_DFP_WHEEL,
+	&lg4ff_switch_emulate_dfp_cmd
 };
 
-static const struct lg4ff_usb_revision lg4ff_revs[] = {
-	{DFGT_REV_MAJ, DFGT_REV_MIN, &native_dfgt},	/* Driving Force GT */
-	{DFGT_REV_MAJ, DFGT2_REV_MIN, &native_dfgt},	/* Driving Force GT v2 */
-	{DFP_REV_MAJ,  DFP_REV_MIN,  &native_dfp},	/* Driving Force Pro */
-	{G25_REV_MAJ,  G25_REV_MIN,  &native_g25},	/* G25 */
-	{G27_REV_MAJ,  G27_REV_MIN,  &native_g27},	/* G27 */
-	{G27_REV_MAJ,  G27_2_REV_MIN,  &native_g27},	/* G27 v2 */
+static const struct lg4ff_emulated_wheel_mode lg4ff_emulated_g25_mode = {
+	LG4FF_MSW_G25,
+	USB_DEVICE_ID_LOGITECH_G25_WHEEL,
+	&lg4ff_switch_emulate_g25_cmd
+};
+
+static const __u32 lg4ff_nonnative_pids_ffex_dfp[] = { USB_DEVICE_ID_LOGITECH_WHEEL, USB_DEVICE_ID_LOGITECH_DFP_WHEEL, 0 };
+static const __u32 lg4ff_nonnative_pids_ffex_dfp_g25[] = { USB_DEVICE_ID_LOGITECH_WHEEL, USB_DEVICE_ID_LOGITECH_DFP_WHEEL,
+						    USB_DEVICE_ID_LOGITECH_G25_WHEEL, 0 };
+static const __u32 lg4ff_nonnative_pids_ffex[] = { USB_DEVICE_ID_LOGITECH_WHEEL, 0 };
+
+static const struct lg4ff_emulated_wheel_mode *lg4ff_emulated_modes_dfp[] = { &lg4ff_emulated_dfp_mode, NULL };
+static const struct lg4ff_emulated_wheel_mode *lg4ff_emulated_modes_dfp_g25[] = { &lg4ff_emulated_dfp_mode, &lg4ff_emulated_g25_mode, NULL };
+static const struct lg4ff_emulated_wheel_mode *lg4ff_emulated_modes_none[] = { NULL };
+
+static const struct lg4ff_mode_switcher lg4ff_mode_switchers[] = {
+	/* DFGT */
+	{0x1300, 0xff00, USB_DEVICE_ID_LOGITECH_DFGT_WHEEL, lg4ff_nonnative_pids_ffex_dfp, &lg4ff_switch_native_dfgt_cmd, lg4ff_emulated_modes_dfp},
+	/* G27 */
+	{0x1230, 0xfff0, USB_DEVICE_ID_LOGITECH_G27_WHEEL, lg4ff_nonnative_pids_ffex_dfp_g25, &lg4ff_switch_native_g27_cmd, lg4ff_emulated_modes_dfp_g25},
+	/* G25 */
+	{0x1200, 0xff00, USB_DEVICE_ID_LOGITECH_G25_WHEEL, lg4ff_nonnative_pids_ffex_dfp, &lg4ff_switch_native_g25_cmd, lg4ff_emulated_modes_dfp},
+	/* DFP */
+	{0x1000, 0xf000, USB_DEVICE_ID_LOGITECH_DFP_WHEEL, lg4ff_nonnative_pids_ffex, &lg4ff_switch_native_dfp_cmd, lg4ff_emulated_modes_none}
 };
 
 /* Recalculates X axis value accordingly to currently selected range */
@@ -400,19 +442,28 @@ static void hid_lg4ff_set_range_dfp(struct hid_device *hid, __u16 range)
 	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 }
 
-static void hid_lg4ff_switch_native(struct hid_device *hid, const struct lg4ff_native_cmd *cmd)
+static int lg4ff_switch_mode(struct hid_device *hid, const struct lg4ff_mode_switch_cmd *cmd)
 {
 	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
-	__u8 i, j;
+	__s32 *value = report->field[0]->value;
+	int i;
+
+	for (i = 0; i < cmd->cmd_count; i++) {
+		const u8 *c = cmd->cmd[i];
 
-	j = 0;
-	while (j < 7*cmd->cmd_num) {
-		for (i = 0; i < 7; i++)
-			report->field[0]->value[i] = cmd->cmd[j++];
+		value[0] = c[0];
+		value[1] = c[1];
+		value[2] = c[2];
+		value[3] = c[3];
+		value[4] = c[4];
+		value[5] = c[5];
+		value[6] = c[6];
 
 		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 	}
+
+	return 0;
 }
 
 /* Read current range and display it in terminal */
@@ -556,7 +607,69 @@ static enum led_brightness lg4ff_led_get_brightness(struct led_classdev *led_cde
 }
 #endif
 
-int lg4ff_init(struct hid_device *hid)
+static int lg4ff_switch_ext_compatibility(struct hid_device *hid, const struct lg4ff_mode_switcher *s, const int switch_force_mode,
+					  const __u32 pid)
+{
+	int k = 0;
+	const struct lg4ff_emulated_wheel_mode *emul;
+
+	while ((emul = s->emulated_modes[k++]) != NULL) {
+		if (emul->tag == switch_force_mode) {
+			if (pid != emul->pid) {
+				dbg_hid("Switching device to extended compatibility mode\n");
+				return lg4ff_switch_mode(hid, emul->cmd);
+			}
+			dbg_hid("Device already is in requested extended compatibility mode\n");
+			return 0;
+		}
+	}
+	dbg_hid("This device does not support the enforced compatibility mode, leaving in FFEX mode\n");
+	return 0;
+}
+
+static int lg4ff_try_mode_switch(struct hid_device *hid, const u16 bcdDevice, int switch_force_mode)
+{
+	const __u32 pid = hid->product;
+	int i;
+
+	if (switch_force_mode < LG4FF_MSW_MIN || switch_force_mode > LG4FF_MSW_MAX)
+		switch_force_mode = LG4FF_MSW_NATIVE;
+	if (switch_force_mode == LG4FF_MSW_DONTSWITCH) {
+		dbg_hid("Leaving device as it is\n");
+		return 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(lg4ff_mode_switchers); i++) {
+		const struct lg4ff_mode_switcher *s = &lg4ff_mode_switchers[i];
+		int j = 0;
+		__u32 nonnative_pid;
+
+		if (s->bcdDevice != (bcdDevice & s->mask))
+			continue;
+
+		if (pid == s->native_pid) {
+			if (switch_force_mode != LG4FF_MSW_NATIVE)
+				return lg4ff_switch_ext_compatibility(hid, s, switch_force_mode, pid);
+			dbg_hid("Device already is in its native mode\n");
+			return 0;
+		}
+
+		/* Check into which mode we want to switch the device to */
+		while ((nonnative_pid = s->nonnative_pids[j++]) != 0) {
+			if (pid == nonnative_pid) {
+				if (switch_force_mode == LG4FF_MSW_NATIVE) {
+					dbg_hid("Switching device to native mode\n");
+					return lg4ff_switch_mode(hid, s->native_cmds);
+				}
+				return lg4ff_switch_ext_compatibility(hid, s, switch_force_mode, pid);
+			}
+		}
+	}
+
+	return 0;
+}
+
+int lg4ff_init(struct hid_device *hid, const int switch_force_mode)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
 	struct input_dev *dev = hidinput->input;
@@ -564,7 +677,7 @@ int lg4ff_init(struct hid_device *hid)
 	struct lg_drv_data *drv_data;
 	struct usb_device_descriptor *udesc;
 	int error, i, j;
-	__u16 bcdDevice, rev_maj, rev_min;
+	u16 bcdDevice;
 
 	/* Check that the report looks ok */
 	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
@@ -591,20 +704,9 @@ int lg4ff_init(struct hid_device *hid)
 		return -1;
 	}
 	bcdDevice = le16_to_cpu(udesc->bcdDevice);
-	rev_maj = bcdDevice >> 8;
-	rev_min = bcdDevice & 0xff;
-
-	if (lg4ff_devices[i].product_id == USB_DEVICE_ID_LOGITECH_WHEEL) {
-		dbg_hid("Generic wheel detected, can it do native?\n");
-		dbg_hid("USB revision: %2x.%02x\n", rev_maj, rev_min);
-
-		for (j = 0; j < ARRAY_SIZE(lg4ff_revs); j++) {
-			if (lg4ff_revs[j].rev_maj == rev_maj && lg4ff_revs[j].rev_min == rev_min) {
-				hid_lg4ff_switch_native(hid, lg4ff_revs[j].command);
-				hid_info(hid, "Switched to native mode\n");
-			}
-		}
-	}
+	error = lg4ff_try_mode_switch(hid, bcdDevice, switch_force_mode);
+	if (error)
+		return error;
 
 	/* Set supported force feedback capabilities */
 	for (j = 0; lg4ff_devices[i].ff_effects[j] >= 0; j++)
@@ -638,7 +740,7 @@ int lg4ff_init(struct hid_device *hid)
 	/* Check if autocentering is available and
 	 * set the centering force to zero by default */
 	if (test_bit(FF_AUTOCENTER, dev->ffbit)) {
-		if (rev_maj == FFEX_REV_MAJ && rev_min == FFEX_REV_MIN)	/* Formula Force EX expects different autocentering command */
+		if (bcdDevice == LG4FF_FFEX_BCDDEVICE)	/* Formula Force EX does not seem to support hi-res autocentering */
 			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_ffex;
 		else
 			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_default;
-- 
2.0.2


