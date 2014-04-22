Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaDVNqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:46:37 -0400
Received: from smtp.devoid-pointer.net ([31.31.77.140]:49399 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbaDVNq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:46:28 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH 05/24] Port max8997_haptic to ff-memless-next
Date: Tue, 22 Apr 2014 15:45:55 +0200
Message-Id: <1398174374-9501-6-git-send-email-madcatxster@devoid-pointer.net>
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
 drivers/input/misc/Kconfig          |  2 +-
 drivers/input/misc/max8997_haptic.c | 25 +++++++++++++++++++------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 91dcae8..6ba327f 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -157,7 +157,7 @@ config INPUT_MAX8925_ONKEY
 config INPUT_MAX8997_HAPTIC
 	tristate "MAXIM MAX8997 haptic controller support"
 	depends on PWM && HAVE_PWM && MFD_MAX8997
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	help
 	  This option enables device driver support for the haptic controller
 	  on MAXIM MAX8997 chip. This driver supports ff-memless interface
diff --git a/drivers/input/misc/max8997_haptic.c b/drivers/input/misc/max8997_haptic.c
index 1fea548..029ac8b 100644
--- a/drivers/input/misc/max8997_haptic.c
+++ b/drivers/input/misc/max8997_haptic.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/max8997-private.h>
 #include <linux/mfd/max8997.h>
 #include <linux/regulator/consumer.h>
+#include <linux/input/ff-memless-next.h>
 
 /* Haptic configuration 2 register */
 #define MAX8997_MOTOR_TYPE_SHIFT	7
@@ -43,6 +44,8 @@
 #define MAX8997_SIG_DUTY_SHIFT		2
 #define MAX8997_PWM_DUTY_SHIFT		0
 
+#define FF_UPDATE_RATE 50
+
 struct max8997_haptic {
 	struct device *dev;
 	struct i2c_client *client;
@@ -219,13 +222,23 @@ static void max8997_haptic_play_effect_work(struct work_struct *work)
 }
 
 static int max8997_haptic_play_effect(struct input_dev *dev, void *data,
-				  struct ff_effect *effect)
+				  const struct mlnx_effect_command *command)
 {
 	struct max8997_haptic *chip = input_get_drvdata(dev);
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 
-	chip->level = effect->u.rumble.strong_magnitude;
-	if (!chip->level)
-		chip->level = effect->u.rumble.weak_magnitude;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		chip->level = rumble_force->strong;
+		if (!chip->level)
+			chip->level = rumble_force->weak;
+		break;
+	case MLNX_STOP_RUMBLE:
+		chip->level = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	schedule_work(&chip->work);
 
@@ -319,8 +332,8 @@ static int max8997_haptic_probe(struct platform_device *pdev)
 	input_set_drvdata(input_dev, chip);
 	input_set_capability(input_dev, EV_FF, FF_RUMBLE);
 
-	error = input_ff_create_memless(input_dev, NULL,
-				max8997_haptic_play_effect);
+	error = input_ff_create_mlnx(input_dev, NULL,
+				max8997_haptic_play_effect, FF_UPDATE_RATE);
 	if (error) {
 		dev_err(&pdev->dev,
 			"unable to create FF device, error: %d\n",
-- 
1.9.2

