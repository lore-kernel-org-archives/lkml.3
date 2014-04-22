Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbaDVOBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:01:46 -0400
Received: from devoid-pointer.net ([31.31.77.140]:49539 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbaDVOBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:34 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 22/24] input: Port hid-lg2ff to ff-memless-next
Date: Tue, 22 Apr 2014 16:00:07 +0200
Message-Id: <1398175209-9565-23-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Port hid-lg2ff to ff-memless-next
* Clamp vibration magnitude to range <0x02; 0xfd> to prevent irregular shaking of the vibration motors.

Signed-off-by: Elias Vanderstuyft <elias.vds@gmail.com>
---
 drivers/hid/Kconfig     |  2 +-
 drivers/hid/hid-lg2ff.c | 65 ++++++++++++++++++++++++++++++++++---------------
 2 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7d617a8..8889b7a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -372,7 +372,7 @@ config LOGITECH_FF
 config LOGIRUMBLEPAD2_FF
 	bool "Logitech force feedback support (variant 2)"
 	depends on HID_LOGITECH
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	help
 	  Say Y here if you want to enable force feedback support for:
 	  - Logitech RumblePad
diff --git a/drivers/hid/hid-lg2ff.c b/drivers/hid/hid-lg2ff.c
index 0e3fb1a..6ab5327 100644
--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -22,42 +22,69 @@
 
 
 #include <linux/input.h>
+#include <linux/input/ff-memless-next.h>
 #include <linux/slab.h>
 #include <linux/hid.h>
 
 #include "hid-lg.h"
 
+#define FF_UPDATE_RATE 8
+
 struct lg2ff_device {
 	struct hid_report *report;
 };
 
-static int play_effect(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
+static int hid_lg2ff_start_rumble(struct hid_device *hid, struct hid_report *report,
+				const struct mlnx_rumble_force *rumble)
 {
-	struct hid_device *hid = input_get_drvdata(dev);
-	struct lg2ff_device *lg2ff = data;
 	int weak, strong;
 
-	strong = effect->u.rumble.strong_magnitude;
-	weak = effect->u.rumble.weak_magnitude;
+#define CLAMP_QUIRK(x) do { if (x < 2) x = 2; else if (x > 0xfd) x = 0xfd; } \
+			while (0)
 
-	if (weak || strong) {
-		weak = weak * 0xff / 0xffff;
-		strong = strong * 0xff / 0xffff;
+	/* Scale down from MLNX range */
+	strong = rumble->strong * 0xff / 0xffff;
+	weak = rumble->weak * 0xff / 0xffff;
+	CLAMP_QUIRK(weak);
+	CLAMP_QUIRK(strong);
 
-		lg2ff->report->field[0]->value[0] = 0x51;
-		lg2ff->report->field[0]->value[2] = weak;
-		lg2ff->report->field[0]->value[4] = strong;
-	} else {
-		lg2ff->report->field[0]->value[0] = 0xf3;
-		lg2ff->report->field[0]->value[2] = 0x00;
-		lg2ff->report->field[0]->value[4] = 0x00;
-	}
+	report->field[0]->value[0] = 0x51;
+	report->field[0]->value[2] = weak;
+	report->field[0]->value[4] = strong;
 
-	hid_hw_request(hid, lg2ff->report, HID_REQ_SET_REPORT);
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 	return 0;
 }
 
+static int hid_lg2ff_stop_rumble(struct hid_device *hid, struct hid_report *report)
+{
+	report->field[0]->value[0] = 0xf3;
+	report->field[0]->value[2] = 0x00;
+	report->field[0]->value[4] = 0x00;
+
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+	return 0;
+}
+
+static int hid_lg2ff_control(struct input_dev *dev, void *data,
+				const struct mlnx_effect_command *command)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+	struct lg2ff_device *lg2ff = data;
+
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		return hid_lg2ff_start_rumble(hid, lg2ff->report, &command->u.rumble_force);
+		break;
+	case MLNX_STOP_RUMBLE:
+		return hid_lg2ff_stop_rumble(hid, lg2ff->report);
+		break;
+	default:
+		dbg_hid("Unsupported effect command");
+		return -EINVAL;
+	}
+}
+
 int lg2ff_init(struct hid_device *hid)
 {
 	struct lg2ff_device *lg2ff;
@@ -78,7 +105,7 @@ int lg2ff_init(struct hid_device *hid)
 
 	set_bit(FF_RUMBLE, dev->ffbit);
 
-	error = input_ff_create_memless(dev, lg2ff, play_effect);
+	error = input_ff_create_mlnx(dev, lg2ff, hid_lg2ff_control, FF_UPDATE_RATE);
 	if (error) {
 		kfree(lg2ff);
 		return error;
-- 
1.9.2

