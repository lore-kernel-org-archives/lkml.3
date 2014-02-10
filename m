Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaBJLFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:05:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37374 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbaBJLFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:05:40 -0500
Date: Mon, 10 Feb 2014 11:05:36 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, dmitry.torokhov@gmail.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: dapm: Add locking to snd_soc_dapm_xxxx_pin functions
Message-ID: <20140210110536.GB6856@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_soc_dapm_disable_pin, snd_soc_dapm_enable_pin and
snd_soc_dapm_force_enable_pin all require the dapm_mutex to be held when
they are called as they edit the dirty list. There are 385 usages of
these functions and only 7 hold the lock whilst calling.

This patch moves the locking into snd_soc_dapm_set_pin and fixes up the
places where the lock was held on the caller side. This saves on fixing
up all the current users and also is much more consistant with the rest
of the DAPM API which all handles the locking internally.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

Hi,

I have put the changes in a single patch to avoid bisect
problems, but let me know if it would be better split into
seperate patches.

Thanks,
Charles

 drivers/extcon/extcon-arizona.c      |   11 -----------
 drivers/input/misc/arizona-haptics.c |   19 -------------------
 sound/soc/soc-dapm.c                 |    8 ++++----
 3 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index c20602f..84167f4 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -222,26 +222,19 @@ static void arizona_extcon_pulse_micbias(struct arizona_extcon_info *info)
 	struct snd_soc_dapm_context *dapm = arizona->dapm;
 	int ret;
 
-	mutex_lock(&dapm->card->dapm_mutex);
-
 	ret = snd_soc_dapm_force_enable_pin(dapm, widget);
 	if (ret != 0)
 		dev_warn(arizona->dev, "Failed to enable %s: %d\n",
 			 widget, ret);
 
-	mutex_unlock(&dapm->card->dapm_mutex);
-
 	snd_soc_dapm_sync(dapm);
 
 	if (!arizona->pdata.micd_force_micbias) {
-		mutex_lock(&dapm->card->dapm_mutex);
-
 		ret = snd_soc_dapm_disable_pin(arizona->dapm, widget);
 		if (ret != 0)
 			dev_warn(arizona->dev, "Failed to disable %s: %d\n",
 				 widget, ret);
 
-		mutex_unlock(&dapm->card->dapm_mutex);
 
 		snd_soc_dapm_sync(dapm);
 	}
@@ -304,16 +297,12 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
 				 ARIZONA_MICD_ENA, 0,
 				 &change);
 
-	mutex_lock(&dapm->card->dapm_mutex);
-
 	ret = snd_soc_dapm_disable_pin(dapm, widget);
 	if (ret != 0)
 		dev_warn(arizona->dev,
 			 "Failed to disable %s: %d\n",
 			 widget, ret);
 
-	mutex_unlock(&dapm->card->dapm_mutex);
-
 	snd_soc_dapm_sync(dapm);
 
 	if (info->micd_reva) {
diff --git a/drivers/input/misc/arizona-haptics.c b/drivers/input/misc/arizona-haptics.c
index 7a04f54..ef2e281 100644
--- a/drivers/input/misc/arizona-haptics.c
+++ b/drivers/input/misc/arizona-haptics.c
@@ -37,7 +37,6 @@ static void arizona_haptics_work(struct work_struct *work)
 						       struct arizona_haptics,
 						       work);
 	struct arizona *arizona = haptics->arizona;
-	struct mutex *dapm_mutex = &arizona->dapm->card->dapm_mutex;
 	int ret;
 
 	if (!haptics->arizona->dapm) {
@@ -67,13 +66,10 @@ static void arizona_haptics_work(struct work_struct *work)
 			return;
 		}
 
-		mutex_lock_nested(dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
-
 		ret = snd_soc_dapm_enable_pin(arizona->dapm, "HAPTICS");
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to start HAPTICS: %d\n",
 				ret);
-			mutex_unlock(dapm_mutex);
 			return;
 		}
 
@@ -81,21 +77,14 @@ static void arizona_haptics_work(struct work_struct *work)
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to sync DAPM: %d\n",
 				ret);
-			mutex_unlock(dapm_mutex);
 			return;
 		}
-
-		mutex_unlock(dapm_mutex);
-
 	} else {
 		/* This disable sequence will be a noop if already enabled */
-		mutex_lock_nested(dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
-
 		ret = snd_soc_dapm_disable_pin(arizona->dapm, "HAPTICS");
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to disable HAPTICS: %d\n",
 				ret);
-			mutex_unlock(dapm_mutex);
 			return;
 		}
 
@@ -103,12 +92,9 @@ static void arizona_haptics_work(struct work_struct *work)
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to sync DAPM: %d\n",
 				ret);
-			mutex_unlock(dapm_mutex);
 			return;
 		}
 
-		mutex_unlock(dapm_mutex);
-
 		ret = regmap_update_bits(arizona->regmap,
 					 ARIZONA_HAPTICS_CONTROL_1,
 					 ARIZONA_HAP_CTRL_MASK,
@@ -155,16 +141,11 @@ static int arizona_haptics_play(struct input_dev *input, void *data,
 static void arizona_haptics_close(struct input_dev *input)
 {
 	struct arizona_haptics *haptics = input_get_drvdata(input);
-	struct mutex *dapm_mutex = &haptics->arizona->dapm->card->dapm_mutex;
 
 	cancel_work_sync(&haptics->work);
 
-	mutex_lock_nested(dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
-
 	if (haptics->arizona->dapm)
 		snd_soc_dapm_disable_pin(haptics->arizona->dapm, "HAPTICS");
-
-	mutex_unlock(dapm_mutex);
 }
 
 static int arizona_haptics_probe(struct platform_device *pdev)
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index dc8ff13..a44b560 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2325,6 +2325,8 @@ static int snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
 {
 	struct snd_soc_dapm_widget *w = dapm_find_widget(dapm, pin, true);
 
+	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
+
 	if (!w) {
 		dev_err(dapm->dev, "ASoC: DAPM unknown pin %s\n", pin);
 		return -EINVAL;
@@ -2337,6 +2339,8 @@ static int snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
 	if (status == 0)
 		w->force = 0;
 
+	mutex_unlock(&dapm->card->dapm_mutex);
+
 	return 0;
 }
 
@@ -3210,15 +3214,11 @@ int snd_soc_dapm_put_pin_switch(struct snd_kcontrol *kcontrol,
 	struct snd_soc_card *card = snd_kcontrol_chip(kcontrol);
 	const char *pin = (const char *)kcontrol->private_value;
 
-	mutex_lock_nested(&card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
-
 	if (ucontrol->value.integer.value[0])
 		snd_soc_dapm_enable_pin(&card->dapm, pin);
 	else
 		snd_soc_dapm_disable_pin(&card->dapm, pin);
 
-	mutex_unlock(&card->dapm_mutex);
-
 	snd_soc_dapm_sync(&card->dapm);
 	return 0;
 }
-- 
1.7.2.5

