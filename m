Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaDVOEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:04:44 -0400
Received: from smtp.devoid-pointer.net ([31.31.77.140]:49533 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaDVOBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:35 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 23/24] input: Port hid-lg4ff to ff-memless-next
Date: Tue, 22 Apr 2014 16:00:08 +0200
Message-Id: <1398175209-9565-24-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-lg4ff to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig     |  2 +-
 drivers/hid/hid-lg4ff.c | 93 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 8889b7a..5e6aa8e 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -390,7 +390,7 @@ config LOGIG940_FF
 config LOGIWHEELS_FF
 	bool "Logitech wheels configuration and force feedback support"
 	depends on HID_LOGITECH
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	default LOGITECH_FF
 	help
 	  Say Y here if you want to enable force feedback and range setting
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 24883b4..d629093 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -25,6 +25,7 @@
 
 
 #include <linux/input.h>
+#include <linux/input/ff-memless-next.h>
 #include <linux/usb.h>
 #include <linux/hid.h>
 
@@ -45,6 +46,8 @@
 #define G27_REV_MIN 0x38
 #define G27_2_REV_MIN 0x39
 
+#define FF_UPDATE_RATE 8
+
 #define to_hid_device(pdev) container_of(pdev, struct hid_device, dev)
 
 static void hid_lg4ff_set_range_dfp(struct hid_device *hid, u16 range);
@@ -69,6 +72,13 @@ struct lg4ff_device_entry {
 
 static const signed short lg4ff_wheel_effects[] = {
 	FF_CONSTANT,
+	FF_RAMP,
+	FF_PERIODIC,
+	FF_SQUARE,
+	FF_TRIANGLE,
+	FF_SINE,
+	FF_SAW_UP,
+	FF_SAW_DOWN,
 	FF_AUTOCENTER,
 	-1
 };
@@ -184,47 +194,60 @@ int lg4ff_adjust_input_event(struct hid_device *hid, struct hid_field *field,
 	}
 }
 
-static int hid_lg4ff_play(struct input_dev *dev, void *data, struct ff_effect *effect)
+static int hid_lg4ff_start_combined(struct hid_device *hid, struct hid_report *report,
+				    const struct mlnx_simple_force *force)
+{
+	__s32 *value = report->field[0]->value;
+	int scaled_x;
+
+	/* Scale down from MLNX range */
+	scaled_x = 0x80 - (force->x * 0xff / 0xffff);
+
+	value[0] = 0x11;	/* Slot 1 */
+	value[1] = 0x08;
+	value[2] = scaled_x;
+	value[3] = 0x80;
+	value[4] = 0x00;
+	value[5] = 0x00;
+	value[6] = 0x00;
+
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+	return 0;
+}
+
+static int hid_lg4ff_stop_combined(struct hid_device *hid, struct hid_report *report)
+{
+	__s32 *value = report->field[0]->value;
+
+	value[0] = 0x13;	/* Slot 1 */
+	value[1] = 0x00;
+	value[2] = 0x00;
+	value[3] = 0x00;
+	value[4] = 0x00;
+	value[5] = 0x00;
+	value[6] = 0x00;
+
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+	return 0;
+}
+
+static int hid_lg4ff_control(struct input_dev *dev, void *data, const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
-	__s32 *value = report->field[0]->value;
-	int x;
-
-#define CLAMP(x) do { if (x < 0) x = 0; else if (x > 0xff) x = 0xff; } while (0)
-
-	switch (effect->type) {
-	case FF_CONSTANT:
-		x = effect->u.ramp.start_level + 0x80;	/* 0x80 is no force */
-		CLAMP(x);
-
-		if (x == 0x80) {
-			/* De-activate force in slot-1*/
-			value[0] = 0x13;
-			value[1] = 0x00;
-			value[2] = 0x00;
-			value[3] = 0x00;
-			value[4] = 0x00;
-			value[5] = 0x00;
-			value[6] = 0x00;
-
-			hid_hw_request(hid, report, HID_REQ_SET_REPORT);
-			return 0;
-		}
-
-		value[0] = 0x11;	/* Slot 1 */
-		value[1] = 0x08;
-		value[2] = x;
-		value[3] = 0x80;
-		value[4] = 0x00;
-		value[5] = 0x00;
-		value[6] = 0x00;
 
-		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+	switch (command->cmd) {
+	case MLNX_START_COMBINED:
+		return hid_lg4ff_start_combined(hid, report, &command->u.simple_force);
+		break;
+	case MLNX_STOP_COMBINED:
+		return hid_lg4ff_stop_combined(hid, report);
 		break;
+	default:
+		dbg_hid("Unsupported effect command");
+		return -EINVAL;
 	}
-	return 0;
 }
 
 /* Sends default autocentering command compatible with
@@ -610,7 +633,7 @@ int lg4ff_init(struct hid_device *hid)
 	for (j = 0; lg4ff_devices[i].ff_effects[j] >= 0; j++)
 		set_bit(lg4ff_devices[i].ff_effects[j], dev->ffbit);
 
-	error = input_ff_create_memless(dev, NULL, hid_lg4ff_play);
+	error = input_ff_create_mlnx(dev, (void *)NULL, hid_lg4ff_control, FF_UPDATE_RATE);
 
 	if (error)
 		return error;
-- 
1.9.2

