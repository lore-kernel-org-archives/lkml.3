Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaDVOHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:07:39 -0400
Received: from smtp.devoid-pointer.net ([31.31.77.140]:49507 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaDVOBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:14 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 14/24] input: Port hid-pl to ff-memless-next
Date: Tue, 22 Apr 2014 15:59:59 +0200
Message-Id: <1398175209-9565-15-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-pl to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig  |  2 +-
 drivers/hid/hid-pl.c | 38 ++++++++++++++++++++++++++------------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 6f2941a..87a02cc 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -500,7 +500,7 @@ config HID_PANTHERLORD
 config PANTHERLORD_FF
 	bool "Pantherlord force feedback support"
 	depends on HID_PANTHERLORD
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	  Say Y here if you have a PantherLord/GreenAsia based game controller
 	  or adapter and want to enable force feedback support for it.
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 2dcd7d9..9b539d5 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -44,9 +44,12 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/hid.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-ids.h"
 
+#define FF_UPDATE_RATE 50
+
 #ifdef CONFIG_PANTHERLORD_FF
 
 struct plff_device {
@@ -57,24 +60,35 @@ struct plff_device {
 };
 
 static int hid_plff_play(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
+			 const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct plff_device *plff = data;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	int left, right;
 
-	left = effect->u.rumble.strong_magnitude;
-	right = effect->u.rumble.weak_magnitude;
-	debug("called with 0x%04x 0x%04x", left, right);
-
-	left = left * plff->maxval / 0xffff;
-	right = right * plff->maxval / 0xffff;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		left = rumble_force->strong;
+		right = rumble_force->weak;
+		debug("called with 0x%04x 0x%04x", left, right);
+
+		left = left * plff->maxval / 0xffff;
+		right = right * plff->maxval / 0xffff;
+
+		*plff->strong = left;
+		*plff->weak = right;
+		debug("running with 0x%02x 0x%02x", left, right);
+		break;
+	case MLNX_STOP_RUMBLE:
+		*plff->strong = 0;
+		*plff->weak = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	*plff->strong = left;
-	*plff->weak = right;
-	debug("running with 0x%02x 0x%02x", left, right);
 	hid_hw_request(hid, plff->report, HID_REQ_SET_REPORT);
-
 	return 0;
 }
 
@@ -160,7 +174,7 @@ static int plff_init(struct hid_device *hid)
 
 		set_bit(FF_RUMBLE, dev->ffbit);
 
-		error = input_ff_create_memless(dev, plff, hid_plff_play);
+		error = input_ff_create_mlnx(dev, plff, hid_plff_play, FF_UPDATE_RATE);
 		if (error) {
 			kfree(plff);
 			return error;
-- 
1.9.2

