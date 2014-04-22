Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbaDVNqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:46:49 -0400
Received: from prifuk.cz ([31.31.77.140]:49426 "EHLO smtp.devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbaDVNqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:46:42 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH 11/24] Port hid-holtekff to ff-memless-next
Date: Tue, 22 Apr 2014 15:46:01 +0200
Message-Id: <1398174374-9501-12-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398174374-9501-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398174374-9501-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig        |  2 +-
 drivers/hid/hid-holtekff.c | 47 +++++++++++++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 24b336e..d1d4e77 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -247,7 +247,7 @@ config HID_HOLTEK
 config HOLTEK_FF
 	bool "Holtek On Line Grip force feedback support"
 	depends on HID_HOLTEK
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	  Say Y here if you have a Holtek On Line Grip based game controller
 	  and want to have force feedback support for it.
diff --git a/drivers/hid/hid-holtekff.c b/drivers/hid/hid-holtekff.c
index 9325545..9c6064d 100644
--- a/drivers/hid/hid-holtekff.c
+++ b/drivers/hid/hid-holtekff.c
@@ -27,9 +27,12 @@
 #include <linux/input.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-ids.h"
 
+#define FF_UPDATE_RATE 50
+
 #ifdef CONFIG_HOLTEK_FF
 
 MODULE_LICENSE("GPL");
@@ -104,34 +107,44 @@ static void holtekff_send(struct holtekff_device *holtekff,
 }
 
 static int holtekff_play(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
+			 const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct holtekff_device *holtekff = data;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	int left, right;
 	/* effect type 1, length 65535 msec */
 	u8 buf[HOLTEKFF_MSG_LENGTH] =
 		{ 0x01, 0x01, 0xff, 0xff, 0x10, 0xe0, 0x00 };
 
-	left = effect->u.rumble.strong_magnitude;
-	right = effect->u.rumble.weak_magnitude;
-	dbg_hid("called with 0x%04x 0x%04x\n", left, right);
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		left = rumble_force->strong;
+		right = rumble_force->weak;
+		dbg_hid("called with 0x%04x 0x%04x\n", left, right);
 
-	if (!left && !right) {
-		holtekff_send(holtekff, hid, stop_all6);
-		return 0;
-	}
+		if (!left && !right) {
+			holtekff_send(holtekff, hid, stop_all6);
+			return 0;
+		}
 
-	if (left)
-		buf[1] |= 0x80;
-	if (right)
-		buf[1] |= 0x40;
+		if (left)
+			buf[1] |= 0x80;
+		if (right)
+			buf[1] |= 0x40;
 
-	/* The device takes a single magnitude, so we just sum them up. */
-	buf[6] = min(0xf, (left >> 12) + (right >> 12));
+		/* The device takes a single magnitude, so we just sum them up. */
+		buf[6] = min(0xf, (left >> 12) + (right >> 12));
 
-	holtekff_send(holtekff, hid, buf);
-	holtekff_send(holtekff, hid, start_effect_1);
+		holtekff_send(holtekff, hid, buf);
+		holtekff_send(holtekff, hid, start_effect_1);
+		return 0;
+	case MLNX_STOP_RUMBLE:
+		holtekff_send(holtekff, hid, stop_all6);
+		return 0;
+	default:
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -171,7 +184,7 @@ static int holtekff_init(struct hid_device *hid)
 	holtekff_send(holtekff, hid, stop_all4);
 	holtekff_send(holtekff, hid, stop_all6);
 
-	error = input_ff_create_memless(dev, holtekff, holtekff_play);
+	error = input_ff_create_mlnx(dev, holtekff, holtekff_play, FF_UPDATE_RATE);
 	if (error) {
 		kfree(holtekff);
 		return error;
-- 
1.9.2

