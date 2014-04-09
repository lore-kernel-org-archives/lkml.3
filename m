Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbaDILUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:20:04 -0400
Received: from prifuk.cz ([31.31.77.140]:52597 "EHLO devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933038AbaDILT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:19:59 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: [PATCH 02/24] Port arizona-haptics to ff-memless-next
Date: Wed, 09 Apr 2014 13:14:22 +0200
Message-ID: <2461623.gOt8QLnnPs@sigyn>
User-Agent: KMail/4.13 rc (Linux/3.14.0-1-ARCHMOD; KDE/4.12.97; x86_64; ; )
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port arizona-haptics to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/input/misc/Kconfig           |  2 +-
 drivers/input/misc/arizona-haptics.c | 39 +++++++++++++++++++++++-------------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7904ab0..33e0f5d 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -75,7 +75,7 @@ config INPUT_AD714X_SPI
 config INPUT_ARIZONA_HAPTICS
 	tristate "Arizona haptics support"
 	depends on MFD_ARIZONA && SND_SOC
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	help
 	  Say Y to enable support for the haptics module in Arizona CODECs.
 
diff --git a/drivers/input/misc/arizona-haptics.c b/drivers/input/misc/arizona-haptics.c
index ef2e281..b4707cc 100644
--- a/drivers/input/misc/arizona-haptics.c
+++ b/drivers/input/misc/arizona-haptics.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
+#include <linux/input/ff-memless-next.h>
 #include <linux/slab.h>
 
 #include <sound/soc.h>
@@ -22,6 +23,8 @@
 #include <linux/mfd/arizona/pdata.h>
 #include <linux/mfd/arizona/registers.h>
 
+#define FF_UPDATE_RATE 50
+
 struct arizona_haptics {
 	struct arizona *arizona;
 	struct input_dev *input_dev;
@@ -108,29 +111,37 @@ static void arizona_haptics_work(struct work_struct *work)
 }
 
 static int arizona_haptics_play(struct input_dev *input, void *data,
-				struct ff_effect *effect)
+				const struct mlnx_effect_command *command)
 {
 	struct arizona_haptics *haptics = input_get_drvdata(input);
 	struct arizona *arizona = haptics->arizona;
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 
 	if (!arizona->dapm) {
 		dev_err(arizona->dev, "No DAPM context\n");
 		return -EBUSY;
 	}
 
-	if (effect->u.rumble.strong_magnitude) {
-		/* Scale the magnitude into the range the device supports */
-		if (arizona->pdata.hap_act) {
-			haptics->intensity =
-				effect->u.rumble.strong_magnitude >> 9;
-			if (effect->direction < 0x8000)
-				haptics->intensity += 0x7f;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		if (rumble_force->strong) {
+			/* Scale the magnitude into the range the device supports */
+			if (arizona->pdata.hap_act) {
+				haptics->intensity = rumble_force->strong >> 9;
+				if (rumble_force->strong_dir < 0x8000)
+					haptics->intensity += 0x7f;
+			} else {
+				haptics->intensity = rumble_force->strong >> 8;
+			}
 		} else {
-			haptics->intensity =
-				effect->u.rumble.strong_magnitude >> 8;
+			haptics->intensity = 0;
 		}
-	} else {
+		break;
+	case MLNX_STOP_RUMBLE:
 		haptics->intensity = 0;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	schedule_work(&haptics->work);
@@ -183,10 +194,10 @@ static int arizona_haptics_probe(struct platform_device *pdev)
 	haptics->input_dev->close = arizona_haptics_close;
 	__set_bit(FF_RUMBLE, haptics->input_dev->ffbit);
 
-	ret = input_ff_create_memless(haptics->input_dev, NULL,
-				      arizona_haptics_play);
+	ret = input_ff_create_mlnx(haptics->input_dev, NULL,
+				   arizona_haptics_play, FF_UPDATE_RATE);
 	if (ret < 0) {
-		dev_err(arizona->dev, "input_ff_create_memless() failed: %d\n",
+		dev_err(arizona->dev, "input_ff_create_mlnx() failed: %d\n",
 			ret);
 		goto err_ialloc;
 	}
-- 
1.9.1


