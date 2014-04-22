Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaDVOBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:01:10 -0400
Received: from transparentnimenzy.cz ([31.31.77.140]:49487 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbaDVOBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:04 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 10/24] input: Port hid-gaff to ff-memless-next
Date: Tue, 22 Apr 2014 15:59:55 +0200
Message-Id: <1398175209-9565-11-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-gaff to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig    |  2 +-
 drivers/hid/hid-gaff.c | 32 +++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 0ba1962..24b336e 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -656,7 +656,7 @@ config HID_GREENASIA
 config GREENASIA_FF
 	bool "GreenAsia (Product ID 0x12) force feedback support"
 	depends on HID_GREENASIA
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	Say Y here if you have a GreenAsia (Product ID 0x12) based game controller
 	(like MANTA Warrior MM816 and SpeedLink Strike2 SL-6635) or adapter
diff --git a/drivers/hid/hid-gaff.c b/drivers/hid/hid-gaff.c
index 2d8cead..f2f70c1 100644
--- a/drivers/hid/hid-gaff.c
+++ b/drivers/hid/hid-gaff.c
@@ -31,8 +31,11 @@
 #include <linux/slab.h>
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/input/ff-memless-next.h>
 #include "hid-ids.h"
 
+#define FF_UPDATE_RATE 50
+
 #ifdef CONFIG_GREENASIA_FF
 
 struct gaff_device {
@@ -40,19 +43,30 @@ struct gaff_device {
 };
 
 static int hid_gaff_play(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
+			 const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct gaff_device *gaff = data;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	int left, right;
 
-	left = effect->u.rumble.strong_magnitude;
-	right = effect->u.rumble.weak_magnitude;
-
-	dbg_hid("called with 0x%04x 0x%04x", left, right);
-
-	left = left * 0xfe / 0xffff;
-	right = right * 0xfe / 0xffff;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		left = rumble_force->strong;
+		right = rumble_force->weak;
+
+		dbg_hid("called with 0x%04x 0x%04x", left, right);
+
+		left = left * 0xfe / 0xffff;
+		right = right * 0xfe / 0xffff;
+		break;
+	case MLNX_STOP_RUMBLE:
+		left = 0;
+		right = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	gaff->report->field[0]->value[0] = 0x51;
 	gaff->report->field[0]->value[1] = 0x0;
@@ -109,7 +123,7 @@ static int gaff_init(struct hid_device *hid)
 
 	set_bit(FF_RUMBLE, dev->ffbit);
 
-	error = input_ff_create_memless(dev, gaff, hid_gaff_play);
+	error = input_ff_create_mlnx(dev, gaff, hid_gaff_play, FF_UPDATE_RATE);
 	if (error) {
 		kfree(gaff);
 		return error;
-- 
1.9.2

