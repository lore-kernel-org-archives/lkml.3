Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaCYRVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:21:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbaCYRVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 55/81] ASoC: dapm: Add locking to snd_soc_dapm_xxxx_pin functions
Date: Tue, 25 Mar 2014 10:16:08 -0700
Message-Id: <1395767794-5012-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 113911006442a36c2b4669faf1699d9042ef80ab upstream.

The snd_soc_dapm_xxxx_pin all require the dapm_mutex to be held when
they are called as they edit the dirty list, however very few of the
callers do so.

This patch adds unlocked versions of all the functions replacing the
existing implementations with one that holds the lock internally. We
also fix up the places where the lock was actually held on the caller
side.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/misc/arizona-haptics.c |  16 -----
 include/sound/soc-dapm.h             |   8 +++
 sound/soc/soc-dapm.c                 | 133 ++++++++++++++++++++++++++++++++---
 3 files changed, 131 insertions(+), 26 deletions(-)

diff --git a/drivers/input/misc/arizona-haptics.c b/drivers/input/misc/arizona-haptics.c
index e7e12a5..ef2e281 100644
--- a/drivers/input/misc/arizona-haptics.c
+++ b/drivers/input/misc/arizona-haptics.c
@@ -37,7 +37,6 @@ static void arizona_haptics_work(struct work_struct *work)
 						       struct arizona_haptics,
 						       work);
 	struct arizona *arizona = haptics->arizona;
-	struct mutex *dapm_mutex = &arizona->dapm->card->dapm_mutex;
 	int ret;
 
 	if (!haptics->arizona->dapm) {
@@ -67,18 +66,13 @@ static void arizona_haptics_work(struct work_struct *work)
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
 
-		mutex_unlock(dapm_mutex);
-
 		ret = snd_soc_dapm_sync(arizona->dapm);
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to sync DAPM: %d\n",
@@ -87,18 +81,13 @@ static void arizona_haptics_work(struct work_struct *work)
 		}
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
 
-		mutex_unlock(dapm_mutex);
-
 		ret = snd_soc_dapm_sync(arizona->dapm);
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to sync DAPM: %d\n",
@@ -152,16 +141,11 @@ static int arizona_haptics_play(struct input_dev *input, void *data,
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
diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index e1ef63d..ace8d41e 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -402,14 +402,22 @@ void snd_soc_dapm_debugfs_init(struct snd_soc_dapm_context *dapm,
 /* dapm audio pin control and status */
 int snd_soc_dapm_enable_pin(struct snd_soc_dapm_context *dapm,
 			    const char *pin);
+int snd_soc_dapm_enable_pin_unlocked(struct snd_soc_dapm_context *dapm,
+				     const char *pin);
 int snd_soc_dapm_disable_pin(struct snd_soc_dapm_context *dapm,
 			     const char *pin);
+int snd_soc_dapm_disable_pin_unlocked(struct snd_soc_dapm_context *dapm,
+				      const char *pin);
 int snd_soc_dapm_nc_pin(struct snd_soc_dapm_context *dapm, const char *pin);
+int snd_soc_dapm_nc_pin_unlocked(struct snd_soc_dapm_context *dapm,
+				 const char *pin);
 int snd_soc_dapm_get_pin_status(struct snd_soc_dapm_context *dapm,
 				const char *pin);
 int snd_soc_dapm_sync(struct snd_soc_dapm_context *dapm);
 int snd_soc_dapm_force_enable_pin(struct snd_soc_dapm_context *dapm,
 				  const char *pin);
+int snd_soc_dapm_force_enable_pin_unlocked(struct snd_soc_dapm_context *dapm,
+					   const char *pin);
 int snd_soc_dapm_ignore_suspend(struct snd_soc_dapm_context *dapm,
 				const char *pin);
 void snd_soc_dapm_auto_nc_codec_pins(struct snd_soc_codec *codec);
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index f8495ef..e12569d 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3005,15 +3005,11 @@ int snd_soc_dapm_put_pin_switch(struct snd_kcontrol *kcontrol,
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
@@ -3507,23 +3503,52 @@ void snd_soc_dapm_stream_event(struct snd_soc_pcm_runtime *rtd, int stream,
 }
 
 /**
+ * snd_soc_dapm_enable_pin_unlocked - enable pin.
+ * @dapm: DAPM context
+ * @pin: pin name
+ *
+ * Enables input/output pin and its parents or children widgets iff there is
+ * a valid audio route and active audio stream.
+ *
+ * Requires external locking.
+ *
+ * NOTE: snd_soc_dapm_sync() needs to be called after this for DAPM to
+ * do any widget power switching.
+ */
+int snd_soc_dapm_enable_pin_unlocked(struct snd_soc_dapm_context *dapm,
+				   const char *pin)
+{
+	return snd_soc_dapm_set_pin(dapm, pin, 1);
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_enable_pin_unlocked);
+
+/**
  * snd_soc_dapm_enable_pin - enable pin.
  * @dapm: DAPM context
  * @pin: pin name
  *
  * Enables input/output pin and its parents or children widgets iff there is
  * a valid audio route and active audio stream.
+ *
  * NOTE: snd_soc_dapm_sync() needs to be called after this for DAPM to
  * do any widget power switching.
  */
 int snd_soc_dapm_enable_pin(struct snd_soc_dapm_context *dapm, const char *pin)
 {
-	return snd_soc_dapm_set_pin(dapm, pin, 1);
+	int ret;
+
+	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
+
+	ret = snd_soc_dapm_set_pin(dapm, pin, 1);
+
+	mutex_unlock(&dapm->card->dapm_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_enable_pin);
 
 /**
- * snd_soc_dapm_force_enable_pin - force a pin to be enabled
+ * snd_soc_dapm_force_enable_pin_unlocked - force a pin to be enabled
  * @dapm: DAPM context
  * @pin: pin name
  *
@@ -3531,11 +3556,13 @@ EXPORT_SYMBOL_GPL(snd_soc_dapm_enable_pin);
  * intended for use with microphone bias supplies used in microphone
  * jack detection.
  *
+ * Requires external locking.
+ *
  * NOTE: snd_soc_dapm_sync() needs to be called after this for DAPM to
  * do any widget power switching.
  */
-int snd_soc_dapm_force_enable_pin(struct snd_soc_dapm_context *dapm,
-				  const char *pin)
+int snd_soc_dapm_force_enable_pin_unlocked(struct snd_soc_dapm_context *dapm,
+					 const char *pin)
 {
 	struct snd_soc_dapm_widget *w = dapm_find_widget(dapm, pin, true);
 
@@ -3551,25 +3578,103 @@ int snd_soc_dapm_force_enable_pin(struct snd_soc_dapm_context *dapm,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(snd_soc_dapm_force_enable_pin_unlocked);
+
+/**
+ * snd_soc_dapm_force_enable_pin - force a pin to be enabled
+ * @dapm: DAPM context
+ * @pin: pin name
+ *
+ * Enables input/output pin regardless of any other state.  This is
+ * intended for use with microphone bias supplies used in microphone
+ * jack detection.
+ *
+ * NOTE: snd_soc_dapm_sync() needs to be called after this for DAPM to
+ * do any widget power switching.
+ */
+int snd_soc_dapm_force_enable_pin(struct snd_soc_dapm_context *dapm,
+				  const char *pin)
+{
+	int ret;
+
+	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
+
+	ret = snd_soc_dapm_force_enable_pin_unlocked(dapm, pin);
+
+	mutex_unlock(&dapm->card->dapm_mutex);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(snd_soc_dapm_force_enable_pin);
 
 /**
+ * snd_soc_dapm_disable_pin_unlocked - disable pin.
+ * @dapm: DAPM context
+ * @pin: pin name
+ *
+ * Disables input/output pin and its parents or children widgets.
+ *
+ * Requires external locking.
+ *
+ * NOTE: snd_soc_dapm_sync() needs to be called after this for DAPM to
+ * do any widget power switching.
+ */
+int snd_soc_dapm_disable_pin_unlocked(struct snd_soc_dapm_context *dapm,
+				    const char *pin)
+{
+	return snd_soc_dapm_set_pin(dapm, pin, 0);
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_disable_pin_unlocked);
+
+/**
  * snd_soc_dapm_disable_pin - disable pin.
  * @dapm: DAPM context
  * @pin: pin name
  *
  * Disables input/output pin and its parents or children widgets.
+ *
  * NOTE: snd_soc_dapm_sync() needs to be called after this for DAPM to
  * do any widget power switching.
  */
 int snd_soc_dapm_disable_pin(struct snd_soc_dapm_context *dapm,
 			     const char *pin)
 {
-	return snd_soc_dapm_set_pin(dapm, pin, 0);
+	int ret;
+
+	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
+
+	ret = snd_soc_dapm_set_pin(dapm, pin, 0);
+
+	mutex_unlock(&dapm->card->dapm_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_disable_pin);
 
 /**
+ * snd_soc_dapm_nc_pin_unlocked - permanently disable pin.
+ * @dapm: DAPM context
+ * @pin: pin name
+ *
+ * Marks the specified pin as being not connected, disabling it along
+ * any parent or child widgets.  At present this is identical to
+ * snd_soc_dapm_disable_pin() but in future it will be extended to do
+ * additional things such as disabling controls which only affect
+ * paths through the pin.
+ *
+ * Requires external locking.
+ *
+ * NOTE: snd_soc_dapm_sync() needs to be called after this for DAPM to
+ * do any widget power switching.
+ */
+int snd_soc_dapm_nc_pin_unlocked(struct snd_soc_dapm_context *dapm,
+			       const char *pin)
+{
+	return snd_soc_dapm_set_pin(dapm, pin, 0);
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_nc_pin_unlocked);
+
+/**
  * snd_soc_dapm_nc_pin - permanently disable pin.
  * @dapm: DAPM context
  * @pin: pin name
@@ -3585,7 +3690,15 @@ EXPORT_SYMBOL_GPL(snd_soc_dapm_disable_pin);
  */
 int snd_soc_dapm_nc_pin(struct snd_soc_dapm_context *dapm, const char *pin)
 {
-	return snd_soc_dapm_set_pin(dapm, pin, 0);
+	int ret;
+
+	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
+
+	ret = snd_soc_dapm_set_pin(dapm, pin, 0);
+
+	mutex_unlock(&dapm->card->dapm_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_nc_pin);
 
-- 
1.8.3.2

