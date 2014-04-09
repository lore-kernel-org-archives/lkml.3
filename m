Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaDIL2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:28:13 -0400
Received: from prifuk.cz ([31.31.77.140]:52627 "EHLO devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbaDIL2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:28:11 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 17/24] Port hid-tmff to ff-memless-next
Date: Wed, 09 Apr 2014 13:28:07 +0200
Message-ID: <2584376.Vex4NMe8Ya@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
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
1.9.1


