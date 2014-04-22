Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaDVOFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:05:53 -0400
Received: from devoid-pointer.net ([31.31.77.140]:49526 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385AbaDVOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:24 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 18/24] input: Port hid-wiimote-modules to ff-memless-next
Date: Tue, 22 Apr 2014 16:00:03 +0200
Message-Id: <1398175209-9565-19-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-wiimote-modules to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig               |  2 +-
 drivers/hid/hid-wiimote-modules.c | 74 ++++++++++++++++++++++++---------------
 2 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index ee999bc..d1cbad6 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -738,7 +738,7 @@ config HID_WIIMOTE
 	depends on HID
 	depends on LEDS_CLASS
 	select POWER_SUPPLY
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	Support for Nintendo Wii and Wii U Bluetooth peripherals. Supported
 	devices are the Wii Remote and its extension devices, but also devices
diff --git a/drivers/hid/hid-wiimote-modules.c b/drivers/hid/hid-wiimote-modules.c
index 6b61f01..95b20ea 100644
--- a/drivers/hid/hid-wiimote-modules.c
+++ b/drivers/hid/hid-wiimote-modules.c
@@ -37,8 +37,11 @@
 #include <linux/hid.h>
 #include <linux/input.h>
 #include <linux/spinlock.h>
+#include <linux/input/ff-memless-next.h>
 #include "hid-wiimote.h"
 
+#define FF_UPDATE_RATE 50
+
 /*
  * Keys
  * The initial Wii Remote provided a bunch of buttons that are reported as
@@ -131,21 +134,27 @@ static void wiimod_rumble_worker(struct work_struct *work)
 }
 
 static int wiimod_rumble_play(struct input_dev *dev, void *data,
-			      struct ff_effect *eff)
+			      const struct mlnx_effect_command *command)
 {
 	struct wiimote_data *wdata = input_get_drvdata(dev);
-	__u8 value;
-
-	/*
-	 * The wiimote supports only a single rumble motor so if any magnitude
-	 * is set to non-zero then we start the rumble motor. If both are set to
-	 * zero, we stop the rumble motor.
-	 */
-
-	if (eff->u.rumble.strong_magnitude || eff->u.rumble.weak_magnitude)
-		value = 1;
-	else
-		value = 0;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
+	__u8 value = 0;
+
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		/*
+		 * The wiimote supports only a single rumble motor so if any magnitude
+		 * is set to non-zero then we start the rumble motor. If both are set to
+		 * zero, we stop the rumble motor.
+		 */
+		if (rumble_force->strong || rumble_force->weak)
+			value = 1;
+		break;
+	case MLNX_STOP_RUMBLE:
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	/* Locking state.lock here might deadlock with input_event() calls.
 	 * schedule_work acts as barrier. Merging multiple changes is fine. */
@@ -161,7 +170,7 @@ static int wiimod_rumble_probe(const struct wiimod_ops *ops,
 	INIT_WORK(&wdata->rumble_worker, wiimod_rumble_worker);
 
 	set_bit(FF_RUMBLE, wdata->input->ffbit);
-	if (input_ff_create_memless(wdata->input, NULL, wiimod_rumble_play))
+	if (input_ff_create_mlnx(wdata->input, NULL, wiimod_rumble_play, FF_UPDATE_RATE))
 		return -ENOMEM;
 
 	return 0;
@@ -1771,21 +1780,28 @@ static void wiimod_pro_close(struct input_dev *dev)
 }
 
 static int wiimod_pro_play(struct input_dev *dev, void *data,
-			   struct ff_effect *eff)
+			   const struct mlnx_effect_command *command)
 {
 	struct wiimote_data *wdata = input_get_drvdata(dev);
-	__u8 value;
-
-	/*
-	 * The wiimote supports only a single rumble motor so if any magnitude
-	 * is set to non-zero then we start the rumble motor. If both are set to
-	 * zero, we stop the rumble motor.
-	 */
-
-	if (eff->u.rumble.strong_magnitude || eff->u.rumble.weak_magnitude)
-		value = 1;
-	else
-		value = 0;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
+	__u8 value = 0;
+
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		/*
+		 * The wiimote supports only a single rumble motor so if any magnitude
+		 * is set to non-zero then we start the rumble motor. If both are set to
+		 * zero, we stop the rumble motor.
+		 */
+
+		if (rumble_force->strong || rumble_force->weak)
+			value = 1;
+		break;
+	case MLNX_STOP_RUMBLE:
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	/* Locking state.lock here might deadlock with input_event() calls.
 	 * schedule_work acts as barrier. Merging multiple changes is fine. */
@@ -1867,8 +1883,8 @@ static int wiimod_pro_probe(const struct wiimod_ops *ops,
 	set_bit(FF_RUMBLE, wdata->extension.input->ffbit);
 	input_set_drvdata(wdata->extension.input, wdata);
 
-	if (input_ff_create_memless(wdata->extension.input, NULL,
-				    wiimod_pro_play)) {
+	if (input_ff_create_mlnx(wdata->extension.input, NULL,
+				 wiimod_pro_play, FF_UPDATE_RATE)) {
 		ret = -ENOMEM;
 		goto err_free;
 	}
-- 
1.9.2

