Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbaDIL3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:29:49 -0400
Received: from prifuk.cz ([31.31.77.140]:52633 "EHLO devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932777AbaDIL3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:29:45 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 19/24] Port hid-zpff to ff-memless-next
Date: Wed, 09 Apr 2014 13:29:42 +0200
Message-ID: <1496205.vHVYf5XDMd@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-zpff to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig    |  2 +-
 drivers/hid/hid-zpff.c | 30 ++++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index d1cbad6..7d617a8 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -775,7 +775,7 @@ config HID_ZEROPLUS
 config ZEROPLUS_FF
 	bool "Zeroplus based game controller force feedback support"
 	depends on HID_ZEROPLUS
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	  Say Y here if you have a Zeroplus based game controller and want
 	  to have force feedback support for it.
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index a29756c..6912500 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -25,9 +25,12 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-ids.h"
 
+#define FF_UPDATE_RATE 50
+
 #ifdef CONFIG_ZEROPLUS_FF
 
 struct zpff_device {
@@ -35,10 +38,11 @@ struct zpff_device {
 };
 
 static int zpff_play(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
+			 const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct zpff_device *zpff = data;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	int left, right;
 
 	/*
@@ -47,12 +51,22 @@ static int zpff_play(struct input_dev *dev, void *data,
 	 * however it is possible that the XFX Executioner is an exception
 	 */
 
-	left = effect->u.rumble.strong_magnitude;
-	right = effect->u.rumble.weak_magnitude;
-	dbg_hid("called with 0x%04x 0x%04x\n", left, right);
-
-	left = left * 0x7f / 0xffff;
-	right = right * 0x7f / 0xffff;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		left = rumble_force->strong;
+		right = rumble_force->weak;
+		dbg_hid("called with 0x%04x 0x%04x\n", left, right);
+
+		left = left * 0x7f / 0xffff;
+		right = right * 0x7f / 0xffff;
+		break;
+	case MLNX_STOP_RUMBLE:
+		left = 0;
+		right = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	zpff->report->field[2]->value[0] = left;
 	zpff->report->field[3]->value[0] = right;
@@ -83,7 +97,7 @@ static int zpff_init(struct hid_device *hid)
 
 	set_bit(FF_RUMBLE, dev->ffbit);
 
-	error = input_ff_create_memless(dev, zpff, zpff_play);
+	error = input_ff_create_mlnx(dev, zpff, zpff_play, FF_UPDATE_RATE);
 	if (error) {
 		kfree(zpff);
 		return error;
-- 
1.9.1


