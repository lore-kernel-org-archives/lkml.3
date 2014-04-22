Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaDVOHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:07:11 -0400
Received: from devoid-pointer.net ([31.31.77.140]:49512 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaDVOBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:17 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 15/24] input: Port hid-sjoy to ff-memless-next
Date: Tue, 22 Apr 2014 16:00:00 +0200
Message-Id: <1398175209-9565-16-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-sjoy to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig    |  2 +-
 drivers/hid/hid-sjoy.c | 35 +++++++++++++++++++++++++----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 87a02cc..e76c36a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -681,7 +681,7 @@ config HID_SMARTJOYPLUS
 config SMARTJOYPLUS_FF
 	bool "SmartJoy PLUS PS2/USB adapter force feedback support"
 	depends on HID_SMARTJOYPLUS
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	Say Y here if you have a SmartJoy PLUS PS2/USB adapter and want to
 	enable force feedback support for it.
diff --git a/drivers/hid/hid-sjoy.c b/drivers/hid/hid-sjoy.c
index 37845ec..a6f8cfe 100644
--- a/drivers/hid/hid-sjoy.c
+++ b/drivers/hid/hid-sjoy.c
@@ -30,8 +30,11 @@
 #include <linux/slab.h>
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/input/ff-memless-next.h>
 #include "hid-ids.h"
 
+#define FF_UPDATE_RATE 50
+
 #ifdef CONFIG_SMARTJOYPLUS_FF
 
 struct sjoyff_device {
@@ -39,21 +42,33 @@ struct sjoyff_device {
 };
 
 static int hid_sjoyff_play(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
+			const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct sjoyff_device *sjoyff = data;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	u32 left, right;
 
-	left = effect->u.rumble.strong_magnitude;
-	right = effect->u.rumble.weak_magnitude;
-	dev_dbg(&dev->dev, "called with 0x%08x 0x%08x\n", left, right);
-
-	left = left * 0xff / 0xffff;
-	right = (right != 0); /* on/off only */
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		left = rumble_force->strong;
+		right = rumble_force->weak;
+		dev_dbg(&dev->dev, "called with 0x%08x 0x%08x\n", left, right);
+
+		left = left * 0xff / 0xffff;
+		right = (right != 0); /* on/off only */
+
+		sjoyff->report->field[0]->value[1] = right;
+		sjoyff->report->field[0]->value[2] = left;
+		break;
+	case MLNX_STOP_RUMBLE:
+		left = 0;
+		right = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	sjoyff->report->field[0]->value[1] = right;
-	sjoyff->report->field[0]->value[2] = left;
 	dev_dbg(&dev->dev, "running with 0x%02x 0x%02x\n", left, right);
 	hid_hw_request(hid, sjoyff->report, HID_REQ_SET_REPORT);
 
@@ -103,7 +118,7 @@ static int sjoyff_init(struct hid_device *hid)
 
 		set_bit(FF_RUMBLE, dev->ffbit);
 
-		error = input_ff_create_memless(dev, sjoyff, hid_sjoyff_play);
+		error = input_ff_create_mlnx(dev, sjoyff, hid_sjoyff_play, FF_UPDATE_RATE);
 		if (error) {
 			kfree(sjoyff);
 			return error;
-- 
1.9.2

