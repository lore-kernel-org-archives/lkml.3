Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbaDILQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:16:17 -0400
Received: from prifuk.cz ([31.31.77.140]:52583 "EHLO devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758261AbaDILQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:16:15 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 07:16:15 EDT
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 04/24] Port twl6040-vibra to ff-memless-next
Date: Wed, 09 Apr 2014 13:16:12 +0200
Message-ID: <7022354.ZeeqfKrrUN@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
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
1.9.1


