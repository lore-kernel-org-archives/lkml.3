Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbaDILZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:25:01 -0400
Received: from prifuk.cz ([31.31.77.140]:52617 "EHLO devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486AbaDILY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:24:58 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 03/24] Port twl4030-vibra to ff-memless-next
Date: Wed, 09 Apr 2014 13:15:10 +0200
Message-ID: <6530276.pE3b2r1u1b@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port twl4030-vibra to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/input/misc/Kconfig         |  2 +-
 drivers/input/misc/twl4030-vibra.c | 31 +++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 33e0f5d..1016a1b 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -407,7 +407,7 @@ config INPUT_TWL4030_VIBRA
 	tristate "Support for TWL4030 Vibrator"
 	depends on TWL4030_CORE
 	select MFD_TWL4030_AUDIO
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	help
 	  This option enables support for TWL4030 Vibrator Driver.
 
diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index 960ef2a..5274ad2 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -32,9 +32,11 @@
 #include <linux/mfd/twl4030-audio.h>
 #include <linux/input.h>
 #include <linux/slab.h>
+#include <linux/input/ff-memless-next.h>
 
 /* MODULE ID2 */
 #define LEDEN		0x00
+#define FF_UPDATE_RATE	50
 
 /* ForceFeedback */
 #define EFFECT_DIR_180_DEG	0x8000 /* range is 0 - 0xFFFF */
@@ -134,14 +136,31 @@ static void vibra_play_work(struct work_struct *work)
 /*** Input/ForceFeedback ***/
 
 static int vibra_play(struct input_dev *input, void *data,
-		      struct ff_effect *effect)
+		      const struct mlnx_effect_command *command)
 {
 	struct vibra_info *info = input_get_drvdata(input);
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
+
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		if (command->u.rumble_force.strong) {
+			info->speed = rumble_force->strong >> 8;
+			info->direction = rumble_force->strong_dir < EFFECT_DIR_180_DEG ?
+					  0 : 1;
+		} else {
+			info->speed = rumble_force->weak >> 9;
+			info->direction = rumble_force->weak_dir < EFFECT_DIR_180_DEG ?
+					  0 : 1;
+		}
+		break;
+	case MLNX_STOP_RUMBLE:
+		info->speed = 0;
+		info->direction = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	info->speed = effect->u.rumble.strong_magnitude >> 8;
-	if (!info->speed)
-		info->speed = effect->u.rumble.weak_magnitude >> 9;
-	info->direction = effect->direction < EFFECT_DIR_180_DEG ? 0 : 1;
 	schedule_work(&info->play_work);
 	return 0;
 }
@@ -227,7 +246,7 @@ static int twl4030_vibra_probe(struct platform_device *pdev)
 	info->input_dev->close = twl4030_vibra_close;
 	__set_bit(FF_RUMBLE, info->input_dev->ffbit);
 
-	ret = input_ff_create_memless(info->input_dev, NULL, vibra_play);
+	ret = input_ff_create_mlnx(info->input_dev, NULL, vibra_play, FF_UPDATE_RATE);
 	if (ret < 0) {
 		dev_dbg(&pdev->dev, "couldn't register vibrator to FF\n");
 		return ret;
-- 
1.9.1


