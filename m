Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbaDVOBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:01:01 -0400
Received: from smtp.devoid-pointer.net ([31.31.77.140]:49463 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaDVOAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:00:22 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 04/24] input: Port twl6040-vibra to ff-memless-next
Date: Tue, 22 Apr 2014 15:59:49 +0200
Message-Id: <1398175209-9565-5-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port twl6040-vibra to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/input/misc/Kconfig         |  2 +-
 drivers/input/misc/twl6040-vibra.c | 27 ++++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 1016a1b..91dcae8 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -417,7 +417,7 @@ config INPUT_TWL4030_VIBRA
 config INPUT_TWL6040_VIBRA
 	tristate "Support for TWL6040 Vibrator"
 	depends on TWL6040_CORE
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	help
 	  This option enables support for TWL6040 Vibrator Driver.
 
diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index 77dc23b..7440a74 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -30,12 +30,14 @@
 #include <linux/of.h>
 #include <linux/workqueue.h>
 #include <linux/input.h>
+#include <linux/input/ff-memless-next.h>
 #include <linux/mfd/twl6040.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/regulator/consumer.h>
 
 #define EFFECT_DIR_180_DEG	0x8000
+#define FF_UPDATE_RATE		50
 
 /* Recommended modulation index 85% */
 #define TWL6040_VIBRA_MOD	85
@@ -197,9 +199,10 @@ static void vibra_play_work(struct work_struct *work)
 }
 
 static int vibra_play(struct input_dev *input, void *data,
-		      struct ff_effect *effect)
+		      const struct mlnx_effect_command *command)
 {
 	struct vibra_info *info = input_get_drvdata(input);
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	int ret;
 
 	/* Do not allow effect, while the routing is set to use audio */
@@ -209,9 +212,23 @@ static int vibra_play(struct input_dev *input, void *data,
 		return -EBUSY;
 	}
 
-	info->weak_speed = effect->u.rumble.weak_magnitude;
-	info->strong_speed = effect->u.rumble.strong_magnitude;
-	info->direction = effect->direction < EFFECT_DIR_180_DEG ? 1 : -1;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		info->weak_speed = rumble_force->weak;
+		info->strong_speed = rumble_force->strong;
+		if (info->strong_speed >= info->weak_speed)
+			info->direction = rumble_force->strong_dir < EFFECT_DIR_180_DEG ? 1 : -1;
+		else
+			info->direction = rumble_force->weak_dir < EFFECT_DIR_180_DEG ? 1 : -1;
+		break;
+	case MLNX_STOP_RUMBLE:
+		info->weak_speed = 0;
+		info->strong_speed = 0;
+		info->direction = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	ret = queue_work(info->workqueue, &info->play_work);
 	if (!ret) {
@@ -367,7 +384,7 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 	info->input_dev->close = twl6040_vibra_close;
 	__set_bit(FF_RUMBLE, info->input_dev->ffbit);
 
-	ret = input_ff_create_memless(info->input_dev, NULL, vibra_play);
+	ret = input_ff_create_mlnx(info->input_dev, NULL, vibra_play, FF_UPDATE_RATE);
 	if (ret < 0) {
 		dev_err(info->dev, "couldn't register vibrator to FF\n");
 		goto err_ialloc;
-- 
1.9.2

