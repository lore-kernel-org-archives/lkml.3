Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbaDILS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:18:56 -0400
Received: from devoid-pointer.net ([31.31.77.140]:52591 "EHLO
	devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDILSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:18:55 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 07/24] Port hid-axff to ff-memless-next
Date: Wed, 09 Apr 2014 13:18:51 +0200
Message-ID: <1620862.YaQ9IaA2dH@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port hid-axff to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/hid/Kconfig    |  2 +-
 drivers/hid/hid-axff.c | 32 +++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index f722001..68c19a0 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -106,7 +106,7 @@ config HID_ACRUX
 config HID_ACRUX_FF
 	bool "ACRUX force feedback support"
 	depends on HID_ACRUX
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	Say Y here if you want to enable force feedback support for ACRUX
 	game controllers.
diff --git a/drivers/hid/hid-axff.c b/drivers/hid/hid-axff.c
index a594e47..7fbfcbc 100644
--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -31,31 +31,45 @@
 #include <linux/slab.h>
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/input/ff-memless-next.h>
 
 #include "hid-ids.h"
 
+#define FF_UPDATE_RATE 50
 #ifdef CONFIG_HID_ACRUX_FF
 
 struct axff_device {
 	struct hid_report *report;
 };
 
-static int axff_play(struct input_dev *dev, void *data, struct ff_effect *effect)
+static int axff_play(struct input_dev *dev, void *data,
+		     const struct mlnx_effect_command *command)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct axff_device *axff = data;
 	struct hid_report *report = axff->report;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	int field_count = 0;
 	int left, right;
 	int i, j;
 
-	left = effect->u.rumble.strong_magnitude;
-	right = effect->u.rumble.weak_magnitude;
-
-	dbg_hid("called with 0x%04x 0x%04x", left, right);
-
-	left = left * 0xff / 0xffff;
-	right = right * 0xff / 0xffff;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		left = rumble_force->strong;
+		right = rumble_force->weak;
+
+		dbg_hid("called with 0x%04x 0x%04x", left, right);
+
+		left = left * 0xff / 0xffff;
+		right = right * 0xff / 0xffff;
+		break;
+	case MLNX_STOP_RUMBLE:
+		left = 0;
+		right = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	for (i = 0; i < report->maxfield; i++) {
 		for (j = 0; j < report->field[i]->report_count; j++) {
@@ -107,7 +121,7 @@ static int axff_init(struct hid_device *hid)
 
 	set_bit(FF_RUMBLE, dev->ffbit);
 
-	error = input_ff_create_memless(dev, axff, axff_play);
+	error = input_ff_create_mlnx(dev, axff, axff_play, FF_UPDATE_RATE);
 	if (error)
 		goto err_free_mem;
 
-- 
1.9.1


