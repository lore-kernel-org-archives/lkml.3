Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaDVOJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:09:48 -0400
Received: from prifuk.cz ([31.31.77.140]:49483 "EHLO smtp.devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbaDVOAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:00:35 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 09/24] input: Port hid-dr to ff-memless-next
Date: Tue, 22 Apr 2014 15:59:54 +0200
Message-Id: <1398175209-9565-10-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-dr to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig  |  2 +-
 drivers/hid/hid-dr.c | 59 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 6e233d2..0ba1962 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -196,7 +196,7 @@ config HID_DRAGONRISE
 config DRAGONRISE_FF
 	bool "DragonRise Inc. force feedback"
 	depends on HID_DRAGONRISE
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	Say Y here if you want to enable force feedback support for DragonRise Inc.
 	game controllers.
diff --git a/drivers/hid/hid-dr.c b/drivers/hid/hid-dr.c
index ce06444..b95c676 100644
--- a/drivers/hid/hid-dr.c
+++ b/drivers/hid/hid-dr.c
@@ -31,8 +31,10 @@
 #include <linux/slab.h>
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-ids.h"
+#define FF_UPDATE_RATE 50
 
 #ifdef CONFIG_DRAGONRISE_FF
 
@@ -41,38 +43,49 @@ struct drff_device {
 };
 
 static int drff_play(struct input_dev *dev, void *data,
-				 struct ff_effect *effect)
+			const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct drff_device *drff = data;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	int strong, weak;
 
-	strong = effect->u.rumble.strong_magnitude;
-	weak = effect->u.rumble.weak_magnitude;
+	strong = rumble_force->strong;
+	weak = rumble_force->weak;
 
 	dbg_hid("called with 0x%04x 0x%04x", strong, weak);
 
-	if (strong || weak) {
-		strong = strong * 0xff / 0xffff;
-		weak = weak * 0xff / 0xffff;
-
-		/* While reverse engineering this device, I found that when
-		   this value is set, it causes the strong rumble to function
-		   at a near maximum speed, so we'll bypass it. */
-		if (weak == 0x0a)
-			weak = 0x0b;
-
-		drff->report->field[0]->value[0] = 0x51;
-		drff->report->field[0]->value[1] = 0x00;
-		drff->report->field[0]->value[2] = weak;
-		drff->report->field[0]->value[4] = strong;
-		hid_hw_request(hid, drff->report, HID_REQ_SET_REPORT);
-
-		drff->report->field[0]->value[0] = 0xfa;
-		drff->report->field[0]->value[1] = 0xfe;
-	} else {
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		if (strong || weak) {
+			strong = strong * 0xff / 0xffff;
+			weak = weak * 0xff / 0xffff;
+
+			/* While reverse engineering this device, I found that when
+			this value is set, it causes the strong rumble to function
+			at a near maximum speed, so we'll bypass it. */
+			if (weak == 0x0a)
+				weak = 0x0b;
+
+			drff->report->field[0]->value[0] = 0x51;
+			drff->report->field[0]->value[1] = 0x00;
+			drff->report->field[0]->value[2] = weak;
+			drff->report->field[0]->value[4] = strong;
+			hid_hw_request(hid, drff->report, HID_REQ_SET_REPORT);
+
+			drff->report->field[0]->value[0] = 0xfa;
+			drff->report->field[0]->value[1] = 0xfe;
+		} else {
+			drff->report->field[0]->value[0] = 0xf3;
+			drff->report->field[0]->value[1] = 0x00;
+		}
+		break;
+	case MLNX_STOP_RUMBLE:
 		drff->report->field[0]->value[0] = 0xf3;
 		drff->report->field[0]->value[1] = 0x00;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	drff->report->field[0]->value[2] = 0x00;
@@ -116,7 +129,7 @@ static int drff_init(struct hid_device *hid)
 
 	set_bit(FF_RUMBLE, dev->ffbit);
 
-	error = input_ff_create_memless(dev, drff, drff_play);
+	error = input_ff_create_mlnx(dev, drff, drff_play, FF_UPDATE_RATE);
 	if (error) {
 		kfree(drff);
 		return error;
-- 
1.9.2

