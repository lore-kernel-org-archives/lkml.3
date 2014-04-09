Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbaDILTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:19:42 -0400
Received: from prifuk.cz ([31.31.77.140]:52594 "EHLO devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbaDILTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:19:40 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 08/24] Port hid-emsff to ff-memless-next
Date: Wed, 09 Apr 2014 13:19:37 +0200
Message-ID: <1509099.M9DXKGbrjE@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-emsff to ff-memless-next

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
1.9.1


