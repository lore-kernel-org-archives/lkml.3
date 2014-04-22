Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbaDVNt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:49:26 -0400
Received: from transparentnimenzy.cz ([31.31.77.140]:49414 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbaDVNqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:46:35 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH 08/24] Port hid-emsff to ff-memless-next
Date: Tue, 22 Apr 2014 15:45:58 +0200
Message-Id: <1398174374-9501-9-git-send-email-madcatxster@devoid-pointer.net>
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
 drivers/hid/Kconfig     |  2 +-
 drivers/hid/hid-emsff.c | 38 ++++++++++++++++++++++++++------------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 68c19a0..6e233d2 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -204,7 +204,7 @@ config DRAGONRISE_FF
 config HID_EMS_FF
 	tristate "EMS Production Inc. force feedback support"
 	depends on HID
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	Say Y here if you want to enable force feedback support for devices by
 	EMS Production Ltd.
diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
index d82d75b..c0cbe50 100644
--- a/drivers/hid/hid-emsff.c
+++ b/drivers/hid/hid-emsff.c
@@ -24,30 +24,44 @@
 #include <linux/hid.h>
 #include <linux/input.h>
 #include <linux/module.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-ids.h"
 
+#define FF_UPDATE_RATE 50
+
 struct emsff_device {
 	struct hid_report *report;
 };
 
 static int emsff_play(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
+			 const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct emsff_device *emsff = data;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	int weak, strong;
 
-	weak = effect->u.rumble.weak_magnitude;
-	strong = effect->u.rumble.strong_magnitude;
-
-	dbg_hid("called with 0x%04x 0x%04x\n", strong, weak);
-
-	weak = weak * 0xff / 0xffff;
-	strong = strong * 0xff / 0xffff;
-
-	emsff->report->field[0]->value[1] = weak;
-	emsff->report->field[0]->value[2] = strong;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		weak = rumble_force->weak;
+		strong = rumble_force->strong;
+
+		dbg_hid("called with 0x%04x 0x%04x\n", strong, weak);
+
+		weak = weak * 0xff / 0xffff;
+		strong = strong * 0xff / 0xffff;
+
+		emsff->report->field[0]->value[1] = weak;
+		emsff->report->field[0]->value[2] = strong;
+		break;
+	case MLNX_STOP_RUMBLE:
+		weak = 0;
+		strong = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	dbg_hid("running with 0x%02x 0x%02x\n", strong, weak);
 	hid_hw_request(hid, emsff->report, HID_REQ_SET_REPORT);
@@ -88,7 +102,7 @@ static int emsff_init(struct hid_device *hid)
 
 	set_bit(FF_RUMBLE, dev->ffbit);
 
-	error = input_ff_create_memless(dev, emsff, emsff_play);
+	error = input_ff_create_mlnx(dev, emsff, emsff_play, FF_UPDATE_RATE);
 	if (error) {
 		kfree(emsff);
 		return error;
-- 
1.9.2

