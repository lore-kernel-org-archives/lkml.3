Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbaDILSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:18:03 -0400
Received: from devoid-pointer.net ([31.31.77.140]:52589 "EHLO
	devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaDILR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:17:59 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 06/24] Port pm8xxx-vibrator to ff-memless-next
Date: Wed, 09 Apr 2014 13:17:55 +0200
Message-ID: <5798897.DMOHYaxkqk@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port pm8xxx-vibrator to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/input/misc/Kconfig           |  2 +-
 drivers/input/misc/pm8xxx-vibrator.c | 28 +++++++++++++++++++---------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 6ba327f..300b5a8 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -108,7 +108,7 @@ config INPUT_PCSPKR
 config INPUT_PM8XXX_VIBRATOR
 	tristate "Qualcomm PM8XXX vibrator support"
 	depends on MFD_PM8XXX
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	help
 	  This option enables device driver support for the vibrator
 	  on Qualcomm PM8xxx chip. This driver supports ff-memless interface
diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
index b88b7cb..6b0e9eb 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -17,6 +17,7 @@
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/regmap.h>
+#include <linux/input/ff-memless-next.h>
 
 #define VIB_DRV			0x4A
 
@@ -29,7 +30,7 @@
 #define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
 
 #define MAX_FF_SPEED		0xff
-
+#define FF_UPDATE_RATE		50
 /**
  * struct pm8xxx_vib - structure to hold vibrator data
  * @vib_input_dev: input device supporting force feedback
@@ -128,14 +129,23 @@ static void pm8xxx_vib_close(struct input_dev *dev)
  * Currently this driver supports only rumble effects.
  */
 static int pm8xxx_vib_play_effect(struct input_dev *dev, void *data,
-				  struct ff_effect *effect)
+				  const struct mlnx_command *command)
 {
 	struct pm8xxx_vib *vib = input_get_drvdata(dev);
-
-	vib->speed = effect->u.rumble.strong_magnitude >> 8;
-	if (!vib->speed)
-		vib->speed = effect->u.rumble.weak_magnitude >> 9;
-
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
+
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		vib->speed = rumble_force->strong >> 8;
+		if (!vib->speed)
+			vib->speed = rumble_force->weak >> 9;
+		break;
+	case MLNX_STOP_RUMBLE:
+		vib->speed = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 	schedule_work(&vib->work);
 
 	return 0;
@@ -182,8 +192,8 @@ static int pm8xxx_vib_probe(struct platform_device *pdev)
 	input_set_drvdata(input_dev, vib);
 	input_set_capability(vib->vib_input_dev, EV_FF, FF_RUMBLE);
 
-	error = input_ff_create_memless(input_dev, NULL,
-					pm8xxx_vib_play_effect);
+	error = input_ff_create_mlnx(input_dev, NULL,
+				     pm8xxx_vib_play_effect, FF_UPDATE_RATE);
 	if (error) {
 		dev_err(&pdev->dev,
 			"couldn't register vibrator as FF device\n");
-- 
1.9.1


