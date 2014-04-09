Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbaDILYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:24:55 -0400
Received: from transparentnimenzy.cz ([31.31.77.140]:52614 "EHLO
	devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbaDILYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:24:53 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 13/24] Port hid-lg3ff to ff-memless-next
Date: Wed, 09 Apr 2014 13:24:49 +0200
Message-ID: <1950497.jofl5Si0qz@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-lg3ff to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig     |  2 +-
 drivers/hid/hid-lg3ff.c | 56 +++++++++++++++++++++++++++++++------------------
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index c7794ae..6f2941a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -382,7 +382,7 @@ config LOGIRUMBLEPAD2_FF
 config LOGIG940_FF
 	bool "Logitech Flight System G940 force feedback support"
 	depends on HID_LOGITECH
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	help
 	  Say Y here if you want to enable force feedback support for Logitech
 	  Flight System G940 devices.
diff --git a/drivers/hid/hid-lg3ff.c b/drivers/hid/hid-lg3ff.c
index 8c2da18..a85f8e5 100644
--- a/drivers/hid/hid-lg3ff.c
+++ b/drivers/hid/hid-lg3ff.c
@@ -23,9 +23,12 @@
 
 #include <linux/input.h>
 #include <linux/hid.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-lg.h"
 
+#define FF_UPDATE_RATE 50
+
 /*
  * G940 Theory of Operation (from experimentation)
  *
@@ -58,12 +61,11 @@ struct lg3ff_device {
 };
 
 static int hid_lg3ff_play(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
+			 const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
-	int x, y;
 
 /*
  * Available values in the field should always be 63, but we only use up to
@@ -72,30 +74,37 @@ static int hid_lg3ff_play(struct input_dev *dev, void *data,
 	memset(report->field[0]->value, 0,
 	       sizeof(__s32) * report->field[0]->report_count);
 
-	switch (effect->type) {
-	case FF_CONSTANT:
-/*
- * Already clamped in ff_memless
- * 0 is center (different then other logitech)
- */
-		x = effect->u.ramp.start_level;
-		y = effect->u.ramp.end_level;
-
-		/* send command byte */
-		report->field[0]->value[0] = 0x51;
+	/* send command byte */
+	report->field[0]->value[0] = 0x51;
 
-/*
- * Sign backwards from other Force3d pro
- * which get recast here in two's complement 8 bits
- */
+	switch (command->cmd) {
+	case MLNX_START_COMBINED: {
+		const struct mlnx_simple_force *simple_force = &command->u.simple_force;
+		/* Scale down from MLNX range */
+		const int x = 0x80 - (simple_force->x * 0xff / 0xffff);
+		const int y = simple_force->y * 0xff / 0xffff;
+
+		/*
+		 * Sign backwards from other Force3d pro
+		 * which get recast here in two's complement 8 bits
+		*/
 		report->field[0]->value[1] = (unsigned char)(-x);
 		report->field[0]->value[31] = (unsigned char)(-y);
-
-		hid_hw_request(hid, report, HID_REQ_SET_REPORT);
 		break;
+		}
+	case MLNX_STOP_COMBINED:
+		report->field[0]->value[1] = 0;
+		report->field[0]->value[31] = 0;
+		break;
+	default:
+		return -EINVAL;
 	}
+
+	hid_hw_request(hid, report, HID_REQ_SET_REPORT);
+
 	return 0;
 }
+
 static void hid_lg3ff_set_autocenter(struct input_dev *dev, u16 magnitude)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
@@ -123,6 +132,13 @@ static void hid_lg3ff_set_autocenter(struct input_dev *dev, u16 magnitude)
 
 static const signed short ff3_joystick_ac[] = {
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
@@ -143,7 +159,7 @@ int lg3ff_init(struct hid_device *hid)
 	for (i = 0; ff_bits[i] >= 0; i++)
 		set_bit(ff_bits[i], dev->ffbit);
 
-	error = input_ff_create_memless(dev, NULL, hid_lg3ff_play);
+	error = input_ff_create_mlnx(dev, NULL, hid_lg3ff_play, FF_UPDATE_RATE);
 	if (error)
 		return error;
 
-- 
1.9.1


