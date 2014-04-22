Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbaDVOBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:01:36 -0400
Received: from transparentnimenzy.cz ([31.31.77.140]:49519 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaDVOBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:22 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 17/24] input: Port hid-tmff to ff-memless-next
Date: Tue, 22 Apr 2014 16:00:02 +0200
Message-Id: <1398175209-9565-18-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-tmff to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig    |  2 +-
 drivers/hid/hid-tmff.c | 83 ++++++++++++++++++++++++++++++--------------------
 2 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index fc22f72..ee999bc 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -719,7 +719,7 @@ config HID_THRUSTMASTER
 config THRUSTMASTER_FF
 	bool "ThrustMaster devices force feedback support"
 	depends on HID_THRUSTMASTER
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or 3,
 	  a THRUSTMASTER Dual Trigger 3-in-1 or a THRUSTMASTER Ferrari GT
diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
index b833760..3df000c 100644
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -31,9 +31,12 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-ids.h"
 
+#define FF_UPDATE_RATE 50
+
 static const signed short ff_rumble[] = {
 	FF_RUMBLE,
 	-1
@@ -41,6 +44,13 @@ static const signed short ff_rumble[] = {
 
 static const signed short ff_joystick[] = {
 	FF_CONSTANT,
+	FF_RAMP,
+	FF_PERIODIC,
+	FF_SINE,
+	FF_SQUARE,
+	FF_TRIANGLE,
+	FF_SAW_DOWN,
+	FF_SAW_UP,
 	-1
 };
 
@@ -67,12 +77,12 @@ static inline int tmff_scale_u16(unsigned int in, int minimum, int maximum)
 	return ret;
 }
 
-/* Changes values from -0x80 to 0x7f into values from minimum to maximum */
-static inline int tmff_scale_s8(int in, int minimum, int maximum)
+/* Changes values from -0x7fff to 0x7fff into values from minimum to maximum */
+static inline int tmff_scale_s32(int in, int minimum, int maximum)
 {
 	int ret;
 
-	ret = (((in + 0x80) * (maximum - minimum)) / 0xff) + minimum;
+	ret = (((in + 0x7fff) * (maximum - minimum)) / 0xffff) + minimum;
 	if (ret < minimum)
 		return minimum;
 	if (ret > maximum)
@@ -81,43 +91,50 @@ static inline int tmff_scale_s8(int in, int minimum, int maximum)
 }
 
 static int tmff_play(struct input_dev *dev, void *data,
-		struct ff_effect *effect)
+		const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct tmff_device *tmff = data;
 	struct hid_field *ff_field = tmff->ff_field;
 	int x, y;
-	int left, right;	/* Rumbling */
-
-	switch (effect->type) {
-	case FF_CONSTANT:
-		x = tmff_scale_s8(effect->u.ramp.start_level,
-					ff_field->logical_minimum,
-					ff_field->logical_maximum);
-		y = tmff_scale_s8(effect->u.ramp.end_level,
-					ff_field->logical_minimum,
-					ff_field->logical_maximum);
-
-		dbg_hid("(x, y)=(%04x, %04x)\n", x, y);
-		ff_field->value[0] = x;
-		ff_field->value[1] = y;
-		hid_hw_request(hid, tmff->report, HID_REQ_SET_REPORT);
-		break;
 
-	case FF_RUMBLE:
-		left = tmff_scale_u16(effect->u.rumble.weak_magnitude,
-					ff_field->logical_minimum,
-					ff_field->logical_maximum);
-		right = tmff_scale_u16(effect->u.rumble.strong_magnitude,
-					ff_field->logical_minimum,
-					ff_field->logical_maximum);
-
-		dbg_hid("(left,right)=(%08x, %08x)\n", left, right);
-		ff_field->value[0] = left;
-		ff_field->value[1] = right;
-		hid_hw_request(hid, tmff->report, HID_REQ_SET_REPORT);
+	switch (command->cmd) {
+	case MLNX_START_COMBINED: {
+		const struct mlnx_simple_force *sf = &command->u.simple_force;
+		x = tmff_scale_s32(sf->x,
+				   ff_field->logical_minimum,
+				   ff_field->logical_maximum);
+		y = tmff_scale_s32(sf->y,
+				   ff_field->logical_minimum,
+				   ff_field->logical_maximum);
+		break;
+		}
+	case MLNX_STOP_COMBINED:
+		x = 0;
+		y = 0;
+		break;
+	case MLNX_START_RUMBLE: {
+		const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
+		x = tmff_scale_u16(rumble_force->weak,
+				   ff_field->logical_minimum,
+				   ff_field->logical_maximum);
+		y = tmff_scale_u16(rumble_force->strong,
+				   ff_field->logical_minimum,
+				   ff_field->logical_maximum);
 		break;
+		}
+	case MLNX_STOP_RUMBLE:
+		x = 0;
+		y = 0;
+		break;
+	default:
+		return -EINVAL;
 	}
+
+	ff_field->value[0] = x;
+	ff_field->value[1] = y;
+
+	hid_hw_request(hid, tmff->report, HID_REQ_SET_REPORT);
 	return 0;
 }
 
@@ -192,7 +209,7 @@ static int tmff_init(struct hid_device *hid, const signed short *ff_bits)
 		goto fail;
 	}
 
-	error = input_ff_create_memless(input_dev, tmff, tmff_play);
+	error = input_ff_create_mlnx(input_dev, tmff, tmff_play, FF_UPDATE_RATE);
 	if (error)
 		goto fail;
 
-- 
1.9.2

