Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaDZPEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 11:04:30 -0400
Received: from prifuk.cz ([31.31.77.140]:50020 "EHLO smtp.devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaDZPDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 11:03:36 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
Subject: [PATCH v4 16/24] hid: Port hid-sony to ff-memless-next
Date: Sat, 26 Apr 2014 17:02:15 +0200
Message-Id: <1398524543-15012-17-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-sony to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig    |  2 +-
 drivers/hid/hid-sony.c | 23 +++++++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 9260d14..e97c382 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -634,7 +634,7 @@ config HID_SONY
 config SONY_FF
 	bool "Sony PS2/3/4 accessories force feedback support" 
 	depends on HID_SONY
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	Say Y here if you have a Sony PS2/3/4 accessory and want to enable
 	force feedback support for it.
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 908de27..5a28833 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -34,6 +34,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/input/mt.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-ids.h"
 
@@ -53,6 +54,7 @@
 #define SONY_BATTERY_SUPPORT (SIXAXIS_CONTROLLER | DUALSHOCK4_CONTROLLER)
 #define SONY_FF_SUPPORT (SIXAXIS_CONTROLLER | DUALSHOCK4_CONTROLLER)
 
+#define FF_UPDATE_RATE 50
 #define MAX_LEDS 4
 
 static const u8 sixaxis_rdesc_fixup[] = {
@@ -1308,16 +1310,25 @@ static void dualshock4_state_worker(struct work_struct *work)
 
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
@@ -1330,7 +1341,7 @@ static int sony_init_ff(struct hid_device *hdev)
 	struct input_dev *input_dev = hidinput->input;
 
 	input_set_capability(input_dev, EV_FF, FF_RUMBLE);
-	return input_ff_create_memless(input_dev, NULL, sony_play_effect);
+	return input_ff_create_mlnx(input_dev, NULL, sony_play_effect, FF_UPDATE_RATE);
 }
 
 #else
-- 
1.9.2

