Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbaDIL12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:27:28 -0400
Received: from prifuk.cz ([31.31.77.140]:52624 "EHLO devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932996AbaDIL10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:27:26 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 16/24] Port hid-sony to ff-memless-next
Date: Wed, 09 Apr 2014 13:27:20 +0200
Message-ID: <1533887.7OAvZ9zf9k@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-sony to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig    |  2 +-
 drivers/hid/hid-sony.c | 24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e76c36a..fc22f72 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -623,7 +623,7 @@ config HID_SONY
 config SONY_FF
 	bool "Sony PS2/3 accessories force feedback support"
 	depends on HID_SONY
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	Say Y here if you have a Sony PS2/3 accessory and want to enable force
 	feedback support for it.
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 2f19b15..70a9cc5 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/leds.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-ids.h"
 
@@ -44,6 +45,7 @@
 #define SONY_LED_SUPPORT (SIXAXIS_CONTROLLER_USB | BUZZ_CONTROLLER | DUALSHOCK4_CONTROLLER_USB)
 #define SONY_FF_SUPPORT (SIXAXIS_CONTROLLER_USB | DUALSHOCK4_CONTROLLER_USB)
 
+#define FF_UPDATE_RATE 50
 #define MAX_LEDS 4
 
 static const u8 sixaxis_rdesc_fixup[] = {
@@ -970,16 +972,25 @@ static void dualshock4_state_worker(struct work_struct *work)
 
 #ifdef CONFIG_SONY_FF
 static int sony_play_effect(struct input_dev *dev, void *data,
-			    struct ff_effect *effect)
+			    const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct sony_sc *sc = hid_get_drvdata(hid);
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 
-	if (effect->type != FF_RUMBLE)
-		return 0;
 
-	sc->left = effect->u.rumble.strong_magnitude / 256;
-	sc->right = effect->u.rumble.weak_magnitude / 256;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		sc->left = rumble_force->strong / 256;
+		sc->right = rumble_force->weak / 256;
+		break;
+	case MLNX_STOP_RUMBLE:
+		sc->left = 0;
+		sc->right = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	schedule_work(&sc->state_worker);
 	return 0;
@@ -992,7 +1003,7 @@ static int sony_init_ff(struct hid_device *hdev)
 	struct input_dev *input_dev = hidinput->input;
 
 	input_set_capability(input_dev, EV_FF, FF_RUMBLE);
-	return input_ff_create_memless(input_dev, NULL, sony_play_effect);
+	return input_ff_create_mlnx(input_dev, NULL, sony_play_effect, FF_UPDATE_RATE);
 }
 
 #else
@@ -1150,6 +1161,7 @@ static const struct hid_device_id sony_devices[] = {
 		.driver_data = DUALSHOCK4_CONTROLLER_USB },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROLLER),
 		.driver_data = DUALSHOCK4_CONTROLLER_BT },
+
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, sony_devices);
-- 
1.9.1


