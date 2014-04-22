Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaDVOKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:10:02 -0400
Received: from transparentnimenzy.cz ([31.31.77.140]:49474 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbaDVOAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:00:32 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 07/24] input: Port hid-axff to ff-memless-next
Date: Tue, 22 Apr 2014 15:59:52 +0200
Message-Id: <1398175209-9565-8-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
1.9.2

